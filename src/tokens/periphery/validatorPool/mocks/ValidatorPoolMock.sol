// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.9;

import "../../ethdkg/ETHDKG.sol";
import "../Snapshots.sol";

import "../utils/CustomEnumerableMaps.sol";

contract ValidatorPoolMock {

    using CustomEnumerableMaps for ValidatorDataMap;

    uint256 internal _tokenIDCounter = 0;
    ETHDKG internal _ethdkg;
    Snapshots internal _snapshots;

    ValidatorDataMap internal _validators;

    address _admin;

    bool internal _isMaintenanceScheduled;
    bool internal _isConsensusRunning;

    constructor(bytes memory hook) {
        _tokenIDCounter = 0;
    }

    function setETHDKG(address ethdkg) external {
        _ethdkg = ETHDKG(ethdkg);
    }

    function setSnapshots(address snapshots) external {
        _snapshots = Snapshots(snapshots);
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

    function registerValidators(address[] memory v) external {
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

    function getValidatorAddresses() external view returns (address[] memory addresses) {
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
}
