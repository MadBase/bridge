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
import "./interfaces/IValidatorPoolEvents.sol";
import "./interfaces/ISnapshots.sol";
import "./interfaces/IDutchAuction.sol";

import "./utils/CustomEnumerableMaps.sol";

contract ValidatorPoolTrue is IValidatorPoolEvents, MagicValue, EthSafeTransfer, ERC20SafeTransfer {
    using CustomEnumerableMaps for ValidatorDataMap;

    // POSITION_LOCK_PERIOD describes the maximum interval a STAKENFT Position may be locked after being
    // given back to validator exiting the pool
    uint256 public constant POSITION_LOCK_PERIOD = 172800;
    // Interval in Madnet Epochs that a validator exiting the pool should before claiming is
    // STAKENFT position
    uint256 public constant CLAIM_PERIOD = 3;

    uint256 public constant MAX_INTERVAL_WITHOUT_SNAPSHOT = 8192;

    INFTStake internal immutable _stakeNFT;
    INFTStake internal immutable _validatorsNFT;
    IETHDKG internal immutable _ethdkg;
    ISnapshots internal immutable _snapshots;
    IERC20Transferable internal immutable _madToken;

    // Minimum amount to stake
    uint256 internal _stakeAmount;
    // Max number of validators in the pool
    uint256 internal _maxNumValidators;
    // minor fine value in WEIs
    uint256 internal _disputerReward;

    bool internal _isMaintenanceScheduled;
    bool internal _isConsensusRunning;

    // validators Pool
    ValidatorDataMap internal _validators;

    mapping(address => ExitingValidatorData) internal _exitingValidatorsData;

    mapping(address => string) internal _ipLocations;

    //todo: change this to use the Admin abstract contract
    address internal _admin;

    constructor(
        INFTStake stakeNFT_,
        INFTStake validatorNFT_,
        IERC20Transferable madToken_,
        IETHDKG ethdkg_,
        ISnapshots snapshots_,
        bytes memory hook
    ) {
        //20000*10**18 MadWei = 20k MadTokens
        _stakeAmount = 20000 * 10**18;
        _maxNumValidators = 5;
        _disputerReward = 1;
        _admin = msg.sender;

        _stakeNFT = stakeNFT_;
        _validatorsNFT = validatorNFT_;
        _ethdkg = ethdkg_;
        _snapshots = snapshots_;
        _madToken = madToken_;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "ValidatorsPool: Requires admin privileges");
        _;
    }

    modifier onlyValidator() {
        require(_isValidator(msg.sender), "ValidatorPool: Only validators allowed!");
        _;
    }

    modifier onlyETHDKG() {
        require(msg.sender == address(_ethdkg), "ValidatorPool: Only ETHDKG contract allowed");
        _;
    }

    function setMinimumStake(uint256 minimumStake_) public onlyAdmin {
        _stakeAmount = minimumStake_;
    }

    function setMaxNumValidators(uint256 maxNumValidators_) public onlyAdmin {
        _maxNumValidators = maxNumValidators_;
    }

    function getValidatorsCount() public view returns (uint256) {
        return _validators.length();
    }

    function getValidatorAddresses() external view returns (address[] memory) {
        return _validators.addressValues();
    }

    // todo: replace this with snapshot version
    function getCurrentMadnetEpoch() public pure returns (uint256) {
        return 1;
    }

    function getValidator(uint256 index) public view returns (address) {
        require(index < _validators.length(), "Index out boundaries!");
        return _validators.at(index)._address;
    }

    function getValidatorData(uint256 index) public view returns (ValidatorData memory) {
        require(index < _validators.length(), "Index out boundaries!");
        return _validators.at(index);
    }

    function isValidator(address participant) public view returns (bool) {
        return _isValidator(participant);
    }

    function isAccusable(address participant) public view returns (bool) {
        return _isAccusable(participant);
    }

    function collectProfits()
        external
        onlyValidator
        returns (uint256 payoutEth, uint256 payoutToken)
    {
        uint256 validatorTokenID = _validators.get(msg.sender)._tokenID;
        payoutEth = _validatorsNFT.collectEthTo(msg.sender, validatorTokenID);
        payoutToken = _validatorsNFT.collectTokenTo(msg.sender, validatorTokenID);
        return (payoutEth, payoutToken);
    }

    function _isValidator(address participant) internal view returns (bool) {
        return _validators.contains(participant);
    }

    function _isAccusable(address participant) internal view returns (bool) {
        return _isValidator(participant) || _exitingValidatorsData[participant]._freeAfter > 0;
    }

    function scheduleMaintenance() public onlyAdmin {
        _isMaintenanceScheduled = true;
        emit MaintenanceScheduled();
    }

    function isMaintenanceScheduled() public view returns(bool){
        return _isMaintenanceScheduled;
    }

    function registerValidators(address[] calldata validators, uint256[] calldata stakerTokenIDs)
        external
        onlyAdmin
    {
        require(
            validators.length <= _maxNumValidators - _validators.length(),
            "ValidatorPool: There are not enough free spots for all new validators!"
        );
        require(
            validators.length == stakerTokenIDs.length,
            "ValidatorPool: Both input array should have same length!"
        );
        //todo: check the ownership of the stakeNFT IDs?
        for (uint256 i = 0; i < validators.length; i++) {
            _registerValidator(validators[i], stakerTokenIDs[i]);
        }
    }

    function _registerValidator(address validator_, uint256 stakerTokenID_)
        internal
        returns (
            uint256 validatorTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        require(!_isConsensusRunning, "ValidatorPool: Error Madnet Consensus should be halted!");
        require(
            _validators.length() <= _maxNumValidators,
            "ValidatorPool: There are no free spots for new validators!"
        );
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");
        require(
            !_isAccusable(validator_),
            "ValidatorPool: Address is already a validator or it is in the exiting line!"
        );

        uint256 balanceBefore = _madToken.balanceOf(address(this));
        (validatorTokenID, payoutEth, payoutToken) = _swapStakeNFTForValidatorNFT(
            validator_,
            stakerTokenID_
        );

        //todo: total amount of Madtokens as invariance, check against overflow
        //todo: add balance checks
        _validators.add(ValidatorData(validator_, validatorTokenID));
        // transfer back any profit that was available for the stakeNFT position by the time that we
        // burned it
        _transferEthAndTokens(validator_, payoutEth, payoutToken);

        emit ValidatorJoined(validator_, validatorTokenID);
    }

    function initializeETHDKG() public onlyAdmin {
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");
        require(!_isConsensusRunning, "ValidatorPool: Error Madnet Consensus should be halted!");
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
        (uint256 stakeShares, , , , ) = _stakeNFT.getPosition(stakerTokenID_);
        uint256 minimumStake = _stakeAmount;
        require(
            stakeShares >= minimumStake,
            "ValidatorStakeNFT: Error, the Stake position doesn't have enough founds!"
        );
        IERC721Transferable(address(_stakeNFT)).safeTransferFrom(
            to_,
            address(this),
            stakerTokenID_
        );
        (payoutEth, payoutToken) = _stakeNFT.burn(stakerTokenID_);

        // Subtracting the shares from StakeNFT profit. The shares will be used to mint the new
        // ValidatorPosition
        payoutToken -= minimumStake;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_validatorsNFT), minimumStake);
        validatorTokenID = _validatorsNFT.mint(minimumStake);

        return (validatorTokenID, payoutEth, payoutToken);
    }

    function _transferEthAndTokens(
        address to_,
        uint256 payoutEth,
        uint256 payoutToken
    ) internal {
        _safeTransferERC20(_madToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);
    }

    function unregisterValidators(address[] calldata validators) external onlyAdmin {
        require(!_isConsensusRunning, "ValidatorPool: Error Madnet Consensus should be halted!");
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");
        require(
            validators.length <= _validators.length(),
            "ValidatorPool: There are not enough validators to be removed!"
        );
        for (uint256 i = 0; i < validators.length; i++) {
            _unregisterValidator(validators[i]);
        }
    }

    function unregisterAllValidators() public onlyAdmin {
        require(!_isConsensusRunning, "ValidatorPool: Error Madnet Consensus should be halted!");
        require(!_ethdkg.isETHDKGRunning(), "ValidatorPool: There's an ETHDKG round running!");
        while (_validators.length() > 0) {
            address validator = _validators.at(_validators.length() - 1)._address;
            _unregisterValidator(validator);
        }
    }

    // todo: check async in Madnet
    function pauseConsensus(uint256 madnetHeight) public {
        require(
            msg.sender == address(_snapshots),
            "ValidatorPool: Caller is not the snapshots contract!"
        );
        _isConsensusRunning = false;
        //todo: set arbitrary height for ethdkg ?
    }

    function pauseConsensusOnArbitraryHeight(uint256 madnetHeight) public onlyAdmin {
        require(
            block.number > _snapshots.getHeightFromLatestSnapshot() + MAX_INTERVAL_WITHOUT_SNAPSHOT,
            "ValidatorPool: Condition not met to stop consensus!"
        );
        _isConsensusRunning = false;
        //todo: set arbitrary height for ethdkg ?
    }

    function claimStakeNFTPosition() public returns (uint256) {
        ExitingValidatorData memory data = _exitingValidatorsData[msg.sender];
        require(
            data._freeAfter > 0,
            "ValidatorPool: No valid StakeNFT Position was found for address in the exitingQueue!"
        );
        require(
            getCurrentMadnetEpoch() > data._freeAfter,
            "ValidatorPool: The waiting period is not over yet!"
        );

        delete _exitingValidatorsData[msg.sender];

        _stakeNFT.lockOwnPosition(data._tokenID, POSITION_LOCK_PERIOD);

        IERC721Transferable(address(_stakeNFT)).safeTransferFrom(
            address(this),
            msg.sender,
            data._tokenID
        );

        return data._tokenID;
    }

    function completeETHDKG() public onlyETHDKG {
        _isMaintenanceScheduled = false;
        _isConsensusRunning = true;
    }

    function collectRewards() public onlyValidator {
        uint256 validatorTokenID = _validators.get(msg.sender)._tokenID;
        _validatorsNFT.collectTokenTo(msg.sender, validatorTokenID);
        _validatorsNFT.collectEthTo(msg.sender, validatorTokenID);
    }

    function majorSlash(address dishonestValidator_, address disputer_) public onlyETHDKG {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _slash(dishonestValidator_);
        _removeValidatorData(dishonestValidator_);
        // redistribute the dishonest staking equally with the other validators
        _validatorsNFT.depositToken(_getMagic(), minerShares);
        // transfer to the disputer any profit that the dishonestValidator had when his
        // position was burned + the disputerReward
        _transferEthAndTokens(disputer_, payoutEth, payoutToken);
        emit ValidatorMajorSlashed(dishonestValidator_);
    }

    function minorSlash(address dishonestValidator_, address disputer_) public onlyETHDKG {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _slash(dishonestValidator_);
        _moveToExitingQueue(dishonestValidator_, minerShares);
        _transferEthAndTokens(disputer_, payoutEth, payoutToken);
        emit ValidatorMinorSlashed(dishonestValidator_);
    }

    function setLocation(string calldata ip) public onlyValidator {
        _ipLocations[msg.sender] = ip;
    }

    function getLocation(address validator) public view returns (string memory) {
        return _ipLocations[validator];
    }

    function getLocations(address[] calldata validators_) internal view returns (string[] memory) {
        string[] memory ret = new string[](validators_.length);
        for (uint256 i = 0; i < validators_.length; i++) {
            ret[i] = _ipLocations[validators_[i]];
        }
        return ret;
    }

    function _unregisterValidator(address validator_)
        internal
        returns (
            uint256 stakeTokenID,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        require(_isValidator(validator_), "ValidatorPool: Address is not a validator_!");

        (stakeTokenID, payoutEth, payoutToken) = _swapValidatorNFTForStakeNFT(validator_);

        _moveToExitingQueue(validator_, stakeTokenID);

        // transfer back any profit that was available for the stakeNFT position by the time that we
        // burned it
        _transferEthAndTokens(validator_, payoutEth, payoutToken);

        emit ValidatorLeft(validator_, stakeTokenID);
    }

    function _burnValidatorNFTPosition(address validator)
        internal
        returns (
            uint256 minerShares,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        uint256 validatorTokenID = _validators.get(validator)._tokenID;
        (minerShares, , , , ) = _validatorsNFT.getPosition(validatorTokenID);
        (payoutEth, payoutToken) = _validatorsNFT.burn(validatorTokenID);
    }

    function _swapValidatorNFTForStakeNFT(address validator)
        internal
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        (uint256 minerShares, uint256 payoutEth, uint256 payoutToken) = _burnValidatorNFTPosition(
            validator
        );
        payoutToken -= minerShares;

        // We should approve the StakeNFT to transferFrom the tokens of this contract
        _madToken.approve(address(_stakeNFT), minerShares);
        // Notice that we are not summing the shared to the payoutToken because we will use this
        // amount to mint a new NFT in the StakeNFT contract.
        uint256 stakeTokenID = _stakeNFT.mint(minerShares);

        return (stakeTokenID, payoutEth, payoutToken);
    }

    function _moveToExitingQueue(address validator_, uint256 stakeTokenID) internal {
        _removeValidatorData(validator_);
        _exitingValidatorsData[validator_] = ExitingValidatorData(
            uint128(stakeTokenID),
            uint128(_snapshots.getEpoch() + CLAIM_PERIOD)
        );
    }

    function _slash(address dishonestValidator_)
        internal
        returns (
            uint256 minerShares,
            uint256 payoutEth,
            uint256 payoutToken
        )
    {
        require(_isAccusable(dishonestValidator_), "ValidatorPool: Address is not accusable!");
        (minerShares, payoutEth, payoutToken) = _burnValidatorNFTPosition(dishonestValidator_);
        minerShares -= _disputerReward;
        payoutToken -= minerShares;
    }

    function _removeValidatorData(address validator_) internal {
        _validators.remove(validator_);
        delete _ipLocations[validator_];
    }
}
