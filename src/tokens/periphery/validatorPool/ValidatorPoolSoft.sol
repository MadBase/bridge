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

contract ValidatorPoolSoft is MagicValue, EthSafeTransfer, ERC20SafeTransfer {

    event ValidatorJoined(address indexed account, uint256 validatorNFT);
    event ValidatorLeft(address indexed account);
    event ValidatorMinorSlashed(address indexed account);
    event ValidatorMajorSlashed(address indexed account);

    // _maxMintLock describes the maximum interval a Position may be locked
    // during a call to mintTo
    uint256 public constant MAX_MINT_LOCK = 1051200;

    //todo: change this to be 2 epochs length in ethereum blocks
    uint256 public constant CLAIM_PERIOD = 45500;

    struct ValidatorData {
        uint128 index;
        uint128 tokenID;
    }

    struct ExitingValidatorData {
        uint256 index;
        uint256 stakedAmount;
        uint256 freeAfter;
    }

    // Minimum amount to stake
    uint256 internal _minimumStake;
    // Max number of validators in the pool
    uint256 internal _maxNumValidators;

    uint256 internal _minorFine;

    INFTStake internal _stakeNFT;
    INFTStake internal _validatorsNFT;
    IETHDKG internal _ethdkg;

    IERC20Transferable internal _madToken;

    // validators Pool
    bool internal _validatorsChanged;
    address[] internal _validators;
    mapping(address=>ValidatorData) internal _validatorsData;

    address[] internal _exitingQueue;
    mapping(address=>ExitingValidatorData) internal _exitingValidatorsData;

    //todo: change this to use the Admin abstract contract
    address internal _admin;

    constructor(
        INFTStake stakeNFT_,
        INFTStake validatorNFT_,
        IERC20Transferable madToken_,
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
        _madToken = madToken_;
        _admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "ValidatorsPool: Requires admin privileges");
        _;
    }

    modifier onlyETHDKG() {
        require(address(_ethdkg) == msg.sender, "ValidatorPool: Only ethdkg contract allowed!");
        _;
    }

    modifier onlyValidator() {
        require(_isValidator(msg.sender), "ValidatorPool: Only validators allowed!");
        _;
    }

    function setMinimumStake(uint256 minimumStake_) public onlyAdmin {
        _minimumStake = minimumStake_;
    }

    function setMaxNumValidators(uint256 maxNumValidators_) public onlyAdmin {
        _maxNumValidators = maxNumValidators_;
    }

    function getValidatorsCount() public view returns(uint256) {
        return _validators.length;
    }

    function getValidator(uint256 index) public view returns(address) {
        require(index < _validators.length, "Index out boundaries!");
        return _validators[index];
    }

    function getValidators() public view returns(address[] memory) {
        return _validators;
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

    // validator_ should have given permissions to this contract to transfer the stakeTokenID_ nft
    // prior calling this function
    function registerValidator(address validator_, uint256 stakerTokenID_) external onlyAdmin returns (
            uint256 validatorTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        ){
        require(_validators.length < _maxNumValidators,"ValidatorPool: There are no free spots for new validators!");
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");

        (validatorTokenID, payoutEth, payoutToken) = _swapStakeNFTForValidatorNFT(validator_, stakerTokenID_);

        _addValidator(validator_, validatorTokenID);
        _validatorsChanged = true;
        // transfer back any profit that was available for the stakeNFT position by the time that we
        // burned it
        _transferEthAndTokens(validator_, payoutEth, payoutToken);

        emit ValidatorJoined(validator_, validatorTokenID);
    }

    function unregisterValidator(address validator) external onlyAdmin returns(uint256, uint256){
        require(isValidator(validator), "ValidatorPool: Only validators can be unregistered!");
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _burnValidatorNFTPosition(validator);
        _addToExitingQueue(validator, minerShares);
        _validatorsChanged = true;
        _transferEthAndTokens(validator, payoutEth, payoutToken);
        emit ValidatorLeft(validator);
        return(payoutEth, payoutToken);
    }

    function initializeETHDKG() external onlyAdmin {
        require(_validatorsChanged, "ValidatorPool: Validators must have changed in order to run a new ETHDKG ceremony!");
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");
        _ethdkg.initializeETHDKG();
    }

    function _transferEthAndTokens(address to_, uint256 payoutEth, uint256 payoutToken) internal {
        _safeTransferERC20(_madToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);
    }

    function _isValidator(address participant) internal view returns(bool) {
        uint256 index = _validatorsData[participant].index;
        return index < _validators.length && _validators[index] == participant;
    }

    function _isAccusable(address participant) internal view returns(bool) {
        return _isValidator(participant) || _exitingValidatorsData[participant].freeAfter > 0 ;
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
        IERC721Transferable(address(_stakeNFT)).safeTransferFrom(to_, address(this), stakerTokenID_);
        (payoutEth, payoutToken) = _stakeNFT.burn(stakerTokenID_);

        // Subtracting the shares from StakeNFT profit. The shares will be used to mint the new
        // ValidatorPosition
        payoutToken -= minimumStake;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_validatorsNFT), minimumStake);
        validatorTokenID = _validatorsNFT.mint(minimumStake);

        return (validatorTokenID, payoutEth, payoutToken);

    }

    function _burnValidatorNFTPosition(address validator) internal returns (
            uint256 minerShares,
            uint256 payoutEth,
            uint256 payoutToken
        ){
        uint256 validatorTokenID = _validatorsData[validator].tokenID;
        (minerShares,,,,) = _validatorsNFT.getPosition(validatorTokenID);
        (payoutEth, payoutToken) = _validatorsNFT.burn(validatorTokenID);

        payoutToken -= minerShares;
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
        _removeValidatorState(validator);
    }

    function majorSlash(address validator, address disputer) public onlyETHDKG {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _burnValidatorNFTPosition(validator);
        _removeValidatorState(validator);
        //todo: set a proper reward value
        uint256 reward = payoutToken/10;
        payoutToken -= reward;
        uint8 magicNumber = _getMagic();
        _validatorsNFT.depositEth{value: payoutEth}(magicNumber);
        _validatorsNFT.depositToken(magicNumber, payoutToken);
        _safeTransferERC20(_madToken, disputer, reward);
        emit ValidatorMajorSlashed(validator);
    }

    function _majorSlash(address validator, address disputer) internal {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _burnValidatorNFTPosition(validator);
        _removeValidatorState(validator);
        //todo: set a proper reward value
        uint256 reward = payoutToken/10;
        payoutToken -= reward;

        uint8 magicNumber = _getMagic();
        _validatorsNFT.depositEth{value: payoutEth}(magicNumber);
        _validatorsNFT.depositToken(magicNumber, payoutToken);

        _safeTransferERC20(_madToken, disputer, reward);
        emit ValidatorMajorSlashed(validator);
    }

    function minorSlash(address validator, address disputer) public onlyETHDKG {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _burnValidatorNFTPosition(validator);
        minerShares -= _minorFine;
        payoutToken -= minerShares;
        _addToExitingQueue(validator, minerShares);
        _transferEthAndTokens(disputer, payoutEth, payoutToken);
        emit ValidatorMinorSlashed(validator);
    }

    function _removeExitingValidatorState(address validator) internal {
        ExitingValidatorData memory vd = _exitingValidatorsData[validator];
        uint256 lastIndex = _exitingQueue.length - 1;
        if (vd.index != lastIndex) {
            address lastValidator = _exitingQueue[lastIndex];
            _exitingQueue[vd.index] = lastValidator;
            _exitingValidatorsData[lastValidator].index = vd.index;
        }
        _exitingQueue.pop();
        delete _exitingValidatorsData[validator];
    }

    function claimStakeNFTPosition() public returns(uint256 stakeTokenID) {
        ExitingValidatorData memory data = _exitingValidatorsData[msg.sender];
        require(data.freeAfter > 0, "ValidatorPool: Caller doesn't have a valid StakeNFT Position!");
        require(block.number > data.freeAfter, "ValidatorPool: The waiting period is not over yet!");

        _removeExitingValidatorState(msg.sender);
        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_stakeNFT), data.stakedAmount);
        stakeTokenID = _stakeNFT.mintTo(msg.sender, data.stakedAmount, MAX_MINT_LOCK);
    }

    function completeETHDKG() external onlyETHDKG {
        _validatorsChanged = false;
    }
}
