// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;
import "../../interfaces/INFTStake.sol";
import "../../interfaces/IERC20Transferable.sol";
import "../../interfaces/IERC721Transferable.sol";
import "../../utils/EthSafeTransfer.sol";
import "../../utils/ERC20SafeTransfer.sol";
import "../ethdkg/interfaces/IETHDKG.sol";

import "../../utils/MagicValue.sol";

import "./interfaces/IValidatorPool.sol";
import "./interfaces/IDutchAuction.sol";

contract ValidatorPoolTrue is MagicValue, EthSafeTransfer, ERC20SafeTransfer {

    event ValidatorJoined(address indexed account, uint256 validatorNFT);
    event ValidatorLeft(address indexed account);
    event ValidatorMinorSlashed(address indexed account);
    event ValidatorMajorSlashed(address indexed account);

    // _maxMintLock describes the maximum interval a Position may be locked
    // during a call to mintTo
    uint256 public constant MAX_MINT_LOCK = 1051200;

    // approx 7 days in block number
    uint256 public constant CLAIM_PERIOD = 45500;

    struct ValidatorData {
        uint128 index;
        uint128 tokenID;
    }

    struct ExitingValidatorData {
        uint256 index;
        uint256 stakedAmount;
        uint256 freeAfter;
        uint256 expireAfter;
    }

    // Minimum amount to stake
    uint256 internal _minimumStake;
    // Max number of validators in the pool
    uint256 internal _maxNumValidators;

    uint256 internal _minorFine;

    INFTStake internal _stakeNFT;
    INFTStake internal _validatorsNFT;
    IETHDKG internal _ethdkg;
    IDutchAuction internal _dutchAuction;

    IERC20Transferable internal _madToken;

    // validators Pool
    bool internal _validatorsChanged;
    address[] internal _validators;
    mapping(address=>ValidatorData) internal _validatorsData;

    address[] internal _exitingQueue;
    mapping(address=>ExitingValidatorData) internal _exitingValidatorsData;

    //todo: change this to use the Admin abstract contract
    address internal _admin;
    mapping(address=>bool) internal _operators;

    constructor(
        INFTStake stakeNFT_,
        INFTStake validatorNFT_,
        IERC20Transferable madToken_,
        IDutchAuction dutchAuction_,
        IETHDKG ethdkg_,
        bytes memory hook
    ) {
        //20000*10**18 MadWei = 20k MadTokens
        _minimumStake = 20000*10**18;
        _maxNumValidators = 5;

        // minorfine: approx 5%
        _minorFine = _minimumStake/20;

        _stakeNFT = stakeNFT_;
        _validatorsNFT = validatorNFT_;
        _ethdkg = ethdkg_;
        _dutchAuction = dutchAuction_;
        _madToken = madToken_;
        _admin = msg.sender;
        _addOperator(address(ethdkg_));
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "ValidatorsPool: Requires admin privileges");
        _;
    }

    modifier onlyValidator() {
        require(_isValidator(msg.sender), "ValidatorPool: Only validators allowed!");
        _;
    }

    modifier onlyOperator() {
        require(_operators[msg.sender], "ValidatorPool: Only valid operators allowed!");
        _;
    }

    function setMinimumStake(uint256 minimumStake_) public onlyAdmin {
        _minimumStake = minimumStake_;
    }

    function setMaxNumValidators(uint256 maxNumValidators_) public onlyAdmin {
        _maxNumValidators = maxNumValidators_;
    }

    function addOperator(address operator) public onlyAdmin {
        _addOperator(operator);
    }

    function removeOperator(address operator) public onlyAdmin {
        _operators[operator] = false;
    }

    function getValidatorsCount() public view returns(uint256) {
        return _validators.length;
    }

    function getValidatorAddresses() external view returns (address[] memory addresses) {
        return _validators;
    }

    function getValidator(uint256 index) public view returns(address) {
        require(index < _validators.length, "Index out boundaries!");
        return _validators[index];
    }

    function isValidator(address participant) public view returns(bool) {
        return _isValidator(participant);
    }

    function isAccusable(address participant) public view returns(bool) {
        return _isAccusable(participant);
    }

    function collectProfits() external onlyValidator returns (uint256 payoutEth, uint256 payoutToken)
    {
        uint256 validatorTokenID = _validatorsData[msg.sender].tokenID;
        require(validatorTokenID > 0, "ValidatorPool Error: No position was found for address!");
        payoutEth = _validatorsNFT.collectEthTo(msg.sender, validatorTokenID);
        payoutToken = _validatorsNFT.collectTokenTo(msg.sender, validatorTokenID);
        return(payoutEth, payoutToken);
    }

    function _addOperator(address operator) internal {
        _operators[operator] = true;
    }

    function _isValidator(address participant) internal view returns(bool) {
        uint256 index = _validatorsData[participant].index;
        return index < _validators.length && _validators[index] == participant;
    }

    function _isAccusable(address participant) internal view returns(bool) {
        return _isValidator(participant) || _exitingValidatorsData[participant].freeAfter > 0 ;
    }

    //todo: test re-entrance
    function registerAsValidator(uint256 stakerTokenID_) external payable returns (
            uint256 validatorTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        ){
        require(_validators.length < _maxNumValidators,"ValidatorPool: There are no free spots for new validators!");
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");
        uint256 auctionPrice = _dutchAuction.getAuctionPrice();
        require(msg.value >= auctionPrice, "ValidatorPool: Auction Price not met!");

        (validatorTokenID, payoutEth, payoutToken) = _swapStakeNFTForValidatorNFT(msg.sender, stakerTokenID_);

        // Returning back any amount sent in excess
        if (msg.value > auctionPrice) {
            payoutEth += (msg.value - auctionPrice);
        }

        _addValidator(msg.sender, validatorTokenID);
        _validatorsChanged = true;
        // transfer back any profit that was available for the stakeNFT position by the time that we
        // burned it
        _transferEthAndTokens(msg.sender, payoutEth, payoutToken);

        emit ValidatorJoined(msg.sender, validatorTokenID);
    }

    function initializeETHDKG() external {
        require(!_dutchAuction.isAuctionRunning(), "ValidatorPool: Auction window should have finished in order to initialize ETHDKG!");
        require(_validatorsChanged, "ValidatorPool: Validators must have changed in order to run a new ETHDKG ceremony!");
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");
        //todo: dutch auction window here
        //todo: reward ppl?
        _ethdkg.initializeETHDKG();
    }

    function _swapStakeNFTForValidatorNFT(address to_, uint256 stakerTokenID_)
        internal
        returns (
            uint256 validatorTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        require(!_isAccusable(to_), "ValidatorPool: Caller is already a validator or it is in the exiting line!");
        (uint256 stakeShares,,,,) = _stakeNFT.getPosition(stakerTokenID_);
        uint256 minimumStake = _minimumStake;
        require(
            stakeShares >= minimumStake,
            "ValidatorStakeNFT: Error, the Stake position doesn't have enough founds!"
        );
        IERC721Transferable(address(_stakeNFT)).safeTransferFrom(msg.sender, address(this), stakerTokenID_);
        (payoutEth, payoutToken) = _stakeNFT.burn(stakerTokenID_);

        // Subtracting the shares from StakeNFT profit. The shares will be used to mint the new
        // ValidatorPosition
        payoutToken -= minimumStake;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_validatorsNFT), minimumStake);
        validatorTokenID = _validatorsNFT.mint(minimumStake);

        return (validatorTokenID, payoutEth, payoutToken);

    }

    function _transferEthAndTokens(address to_, uint256 payoutEth, uint256 payoutToken) internal {
        _safeTransferERC20(_madToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);
    }

    // todo: finish this
    function unregisterAsValidator() external onlyValidator {
        (uint256 payoutEth, uint256 payoutToken) = _swapValidatorNFTForStakeNFT(msg.sender);
        _transferEthAndTokens(msg.sender, payoutEth, payoutToken);
    }

    function _burnValidatorNFTPosition(address validator) internal returns (
            uint256 minerShares,
            uint256 payoutEth,
            uint256 payoutToken
        ){
        uint256 validatorTokenID = _validatorsData[validator].tokenID;
        (minerShares,,,,) = _validatorsNFT.getPosition(validatorTokenID);
        (payoutEth, payoutToken) = _validatorsNFT.burn(validatorTokenID);
    }

    function _swapValidatorNFTForStakeNFT(
        address validator
    )
        internal
        returns (
            uint256 ,
            uint256
        )
    {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _burnValidatorNFTPosition(validator);
        payoutToken -= minerShares;

        _addToExitingQueue(validator, minerShares);
        _removeValidatorState(validator);

        emit ValidatorLeft(validator);
        return (payoutEth, payoutToken);
    }

    function _addValidator(address validator, uint256 validatorTokenID) internal {
        _validators.push(validator);
        _validatorsData[validator] = ValidatorData(uint128(_validators.length-1), uint128(validatorTokenID));
    }

    function _removeValidatorState(address validator) internal {
        ValidatorData memory vd = _validatorsData[validator];
        require(vd.tokenID > 0, "ValidatorPool: Invalid validator!");
        uint256 lastIndex = _validators.length - 1;
        if (vd.index != lastIndex) {
            address lastValidator = _validators[lastIndex];
            _validators[vd.index] = lastValidator;
            _validatorsData[lastValidator].index = vd.index;
        }
        _validators.pop();
        delete _validatorsData[validator];
    }

    function _removeAllValidators() internal {
        uint256 payoutEthTotal = 0;
        uint256 payoutTokenTotal = 0;
        while (_validators.length > 0) {
            address lastValidator = _validators[_validators.length-1];
            (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _burnValidatorNFTPosition(lastValidator);
            _removeValidatorState(lastValidator);
            //todo: add reward
            payoutToken -= minerShares;
            payoutEthTotal += payoutEth;
            payoutTokenTotal += payoutToken;
            _addToExitingQueue(lastValidator, minerShares);
        }
    }

    function _addToExitingQueue(address validator, uint256 minerShares) internal {
        _exitingQueue.push(validator);
        _exitingValidatorsData[validator] = ExitingValidatorData(_exitingQueue.length-1,  minerShares, block.number + CLAIM_PERIOD, MAX_MINT_LOCK);
    }

    function _slash(address validator) internal returns(uint256 minerShares, uint256 payoutEth, uint256 payoutToken){
        (minerShares, payoutEth, payoutToken) = _burnValidatorNFTPosition(validator);
        _removeValidatorState(validator);
    }

    // todo: emit an event
    // todo: add balance checks in the ETHDKG accusation unit tests
    function majorSlash(address validator, address disputer) public onlyOperator {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _slash(validator);
        //todo: set a proper reward value
        uint256 reward = payoutToken/10;
        payoutToken -= reward;
        uint8 magicNumber = _getMagic();
        _validatorsNFT.depositEth{value: payoutEth}(magicNumber);
        _validatorsNFT.depositToken(magicNumber, payoutToken);
        _safeTransferERC20(_madToken, disputer, reward);
        emit ValidatorMajorSlashed(validator);
    }


    // todo: reward caller for taking this awesome action
    // todo: should we receive an address to send the reward to?
    // todo: emit an event
    function minorSlash(address validator, address disputer) public onlyOperator {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _slash(validator);
        minerShares -= _minorFine;
        payoutToken -= minerShares;
        _addToExitingQueue(validator, minerShares);
        _transferEthAndTokens(disputer, payoutEth, payoutToken);
        emit ValidatorMinorSlashed(validator);
    }

    function claimStakeNFTPosition() public returns(uint256 stakeTokenID) {
        ExitingValidatorData memory data = _exitingValidatorsData[msg.sender];
        require(data.freeAfter > 0, "ValidatorPool: Caller doesn't have a valid StakeNFT Position!");
        require(block.number > data.freeAfter, "ValidatorPool: The waiting period is not over yet!");

        delete _exitingValidatorsData[msg.sender];
        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_stakeNFT), data.stakedAmount);
        stakeTokenID = _stakeNFT.mintTo(msg.sender, data.stakedAmount, MAX_MINT_LOCK);
    }

    function completeETHDKG() external onlyOperator {
        _validatorsChanged = false;
    }
}
