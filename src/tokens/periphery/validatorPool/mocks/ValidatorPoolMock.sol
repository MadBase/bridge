// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.9;

import "../../ethdkg/ETHDKG.sol";
import "../Snapshots.sol";

import "../utils/CustomEnumerableMaps.sol";
import "../interfaces/IValidatorPool.sol";

contract ValidatorPoolMock is IValidatorPool {
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

    function claimExitingNFTPosition() public returns (uint256) {
        return 0;
    }

    function tryGetTokenID(address account_)
        public
        view
        returns (
            bool,
            address,
            uint256
        )
    {
        return (false, address(0), 0);
    }

    function collectProfits() public returns (uint256 payoutEth, uint256 payoutToken) {
        return (0, 0);
    }

    function getLocations(address[] calldata validators_) external view returns (string[] memory) {
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
        registerValidators(validators);
    }

    function pauseConsensusOnArbitraryHeight(uint256 madnetHeight) external {}

    function isInExitingQueue(address participant) external view returns (bool) {
        return false;
    }

    function isAccusable(address participant) external view returns (bool) {
        return false;
    }

    function getLocation(address validator) external view returns (string memory) {
        return "";
    }

    function isMock() public view returns (bool) {
        return true;
    }
}
