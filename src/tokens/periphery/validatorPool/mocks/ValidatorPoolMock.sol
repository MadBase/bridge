// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "../../ethdkg/ETHDKG.sol";

contract ValidatorPoolMock is Initializable, UUPSUpgradeable {

    struct ValidatorData {
        uint128 index;
        uint128 tokenID;
    }

    uint256 internal _tokenIDCounter = 0;
    ETHDKG internal _ethdkg;

    address[] internal _validators;
    mapping(address=>ValidatorData) internal _validatorsData;

    function initialize() public initializer {
        _tokenIDCounter = 0;
        __UUPSUpgradeable_init();
    }

    function setETHDKG(address ethdkg) external {
        _ethdkg = ETHDKG(ethdkg);
    }

    function initializeETHDKG() external {
        // require(_ethdkg.isAccusationWindowOver(), "cannot init ETHDKG at the moment");

        _ethdkg.initializeETHDKG();
        //require(success, "ValidatorPoolMock: could not init ETHDKG");
    }

    // todo: onlyAdmin or onlyGovernance?
    function _authorizeUpgrade(address newImplementation) internal onlyAdmin override {

    }

    modifier onlyAdmin() {
        require(msg.sender == _getAdmin(), "Validators: requires admin privileges");
        _;
    }

    function isValidator(address participant) public view returns(bool) {
        return _isValidator(participant);
    }

    function _isValidator(address participant) internal view returns(bool) {
        ValidatorData memory vd = _validatorsData[participant];
        return vd.tokenID != 0 && vd.index < _validators.length && _validators[vd.index] == participant;
    }

    function addValidator(address v) external {
        uint256 tokenID = _tokenIDCounter + 1;
        _validators.push(v);
        _validatorsData[v] = ValidatorData(uint128(_validators.length-1), uint128(tokenID));
        _tokenIDCounter = tokenID;
    }

    function getValidatorsCount() public view returns(uint256) {
        return _validators.length;
    }

    function getValidator(uint256 index) public view returns(address) {
        require(index < _validators.length, "Index out boundaries!");
        return _validators[index];
    }

    function minorSlash(address validator) public {
        _removeValidator(validator);
    }

    function majorSlash(address validator) public {
        _removeValidator(validator);
    }

    function removeValidator(address validator) public {
        _removeValidator(validator);
    }

    function removeAllValidators() public {
        while (_validators.length > 0) {
            delete _validatorsData[_validators[_validators.length-1]];
            _validators.pop();
        }
    }

    function _removeValidator(address validator) internal {
        ValidatorData memory vd = _validatorsData[validator];
        require(vd.tokenID != 0, "ValidatorPool: invalid validator");
        address lastValidator = _validators[_validators.length-1];
        _validators[vd.index] = lastValidator;
        _validatorsData[lastValidator].index = vd.index;
        _validators.pop();
        delete _validatorsData[validator];
    }
}