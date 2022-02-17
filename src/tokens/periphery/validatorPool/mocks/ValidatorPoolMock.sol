// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.9;

import "../../ethdkg/interfaces/IETHDKG.sol";
import "../../snapshots/interfaces/ISnapshots.sol";

import "../utils/CustomEnumerableMaps.sol";
import "../interfaces/IValidatorPool.sol";
import "../../../../utils/DeterministicAddress.sol";

contract ValidatorPoolMock is IValidatorPool, DeterministicAddress {
    using CustomEnumerableMaps for ValidatorDataMap;

    uint256 internal _tokenIDCounter;
    address immutable _factory;
    IETHDKG immutable internal _ethdkg;
    ISnapshots immutable internal _snapshots;

    ValidatorDataMap internal _validators;

    address internal _admin;

    bool internal _isMaintenanceScheduled;
    bool internal _isConsensusRunning;

    // solhint-disable no-empty-blocks
    constructor() {
        _factory = msg.sender;
        // bytes32("Snapshots") = 0x536e617073686f74730000000000000000000000000000000000000000000000;
        _snapshots = ISnapshots(
            getMetamorphicContractAddress(
                0x536e617073686f74730000000000000000000000000000000000000000000000,
                _factory
            )
        );
        // bytes32("ETHDKG") = 0x455448444b470000000000000000000000000000000000000000000000000000;
        _ethdkg = IETHDKG(
            getMetamorphicContractAddress(
                0x455448444b470000000000000000000000000000000000000000000000000000,
                _factory
            )
        );
    }

    function initializeETHDKG() external {
        _ethdkg.initializeETHDKG();
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Validators: requires admin privileges");
        _;
    }

    modifier onlySnapshots() {
        require(
            msg.sender == address(_snapshots),
            "ValidatorPool: Caller is not the snapshots contract!"
        );
        _;
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
