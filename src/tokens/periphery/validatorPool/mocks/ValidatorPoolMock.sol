// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.9;

import "../../ethdkg/interfaces/IETHDKG.sol";
import "../../snapshots/interfaces/ISnapshots.sol";
import "../utils/CustomEnumerableMaps.sol";
import "../interfaces/IValidatorPool.sol";
import "../../../../utils/DeterministicAddress.sol";
import "../../../interfaces/INFTStake.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ValidatorPoolMock is Initializable, IValidatorPool, immutableFactory, immutableSnapshots, immutableETHDKG, immutableValidatorNFT {
    using CustomEnumerableMaps for ValidatorDataMap;

    uint256 internal _tokenIDCounter;
    //IETHDKG immutable internal _ethdkg;
    //ISnapshots immutable internal _snapshots;

    ValidatorDataMap internal _validators;

    address internal _admin;

    bool internal _isMaintenanceScheduled;
    bool internal _isConsensusRunning;

    uint256 internal _stakeAmount;

    // solhint-disable no-empty-blocks
    constructor() immutableFactory(msg.sender) immutableValidatorNFT() immutableSnapshots() immutableETHDKG(){
    }

    function initialize() public onlyFactory initializer {
        //20000*10**18 MadWei = 20k MadTokens
        _stakeAmount = 20000 * 10**18;
    }

    function initializeETHDKG() external {
        IETHDKG(_ETHDKGAddress()).initializeETHDKG();
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Validators: requires admin privileges");
        _;
    }

    function mintValidatorNFT(address to_) public returns(uint256 stakeID_){
        stakeID_ = INFTStake(_ValidatorNFTAddress()).mintTo(to_, _stakeAmount, 1);
    }

    function burnValidatorNFT(uint256 tokenID_, address to_) public returns(uint256 payoutEth, uint256 payoutMadToken) {
        return INFTStake(_ValidatorNFTAddress()).burnTo(to_, tokenID_);
    }

    function isValidator(address participant) public view returns (bool) {
        return _isValidator(participant);
    }

    function _isValidator(address participant) internal view returns (bool) {
        return _validators.contains(participant);
    }

    function registerValidators(address[] memory v) internal {
        for (uint256 idx; idx < v.length; idx++) {
            uint256 tokenID = _tokenIDCounter + 1;
            _validators.add(ValidatorData(v[idx], tokenID));
            _tokenIDCounter = tokenID;
        }
    }

    function getValidatorsCount() public view returns (uint256) {
        return _validators.length();
    }

    function getValidator(uint256 index_) public view returns (address) {
        require(index_ < _validators.length(), "Index out boundaries!");
        return _validators.at(index_)._address;
    }

    function getValidatorsAddresses() external view returns (address[] memory addresses) {
        return _validators.addressValues();
    }

    function minorSlash(address validator, address disputer) public {
        disputer; //no-op to suppress warning of not using disputer address
        _removeValidator(validator);
    }

    function majorSlash(address validator, address disputer) public {
        disputer; //no-op to suppress warning of not using disputer address
        _removeValidator(validator);
    }

    function unregisterValidators(address[] memory validators) public {
        for (uint256 idx; idx < validators.length; idx++) {
            _removeValidator(validators[idx]);
        }
    }

    function unregisterAllValidators() public {
        while (_validators.length() > 0) {
            _removeValidator(_validators.at(_validators.length() - 1)._address);
        }
    }

    function _removeValidator(address validator_) internal {
        _validators.remove(validator_);
    }

    function completeETHDKG() public {
        _isMaintenanceScheduled = false;
        _isConsensusRunning = true;
    }

    function pauseConsensus() public onlySnapshots {
        _isConsensusRunning = false;
    }

    function scheduleMaintenance() public {
        _isMaintenanceScheduled = true;
    }

    function isMaintenanceScheduled() public view returns (bool) {
        return _isMaintenanceScheduled;
    }

    function claimExitingNFTPosition() public pure returns (uint256) {
        return 0;
    }

    function tryGetTokenID(address account_)
        public
        pure
        returns (
            bool,
            address,
            uint256
        )
    {
        account_;//no-op to suppress compiling warnings
        return (false, address(0), 0);
    }

    function collectProfits() public pure returns (uint256 payoutEth, uint256 payoutToken) {
        return (0, 0);
    }

    function getLocations(address[] calldata validators_) external pure returns (string[] memory) {
        validators_;
        return new string[](1);
    }

    function getValidatorData(uint256 index) external view returns (ValidatorData memory) {
        return _validators.at(index);
    }

    function setStakeAmount(uint256 stakeAmount_) external {}

    function setSnapshot(address _address) external {}

    function setMaxNumValidators(uint256 maxNumValidators_) public {}

    function setLocation(string calldata ip) external {}

    function registerValidators(address[] calldata validators, uint256[] calldata stakerTokenIDs)
        public
    {
        stakerTokenIDs;
        registerValidators(validators);
    }

    function pauseConsensusOnArbitraryHeight(uint256 madnetHeight) external {}

    function isInExitingQueue(address participant) external pure returns (bool) {
        participant;
        return false;
    }

    function isAccusable(address participant) external pure returns (bool) {
        participant;
        return false;
    }

    function getLocation(address validator) external pure returns (string memory) {
        validator;
        return "";
    }

    function setDisputerReward(uint256 disputerReward_) public {
    }

    function isMock() public pure returns (bool) {
        return true;
    }
}
