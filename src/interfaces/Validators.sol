// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./ValidatorsEvents.sol";

interface Validators is ValidatorsEvents {

    // Functions mostly related to the validator pool
    function addValidator(address _validator, uint256[2] calldata _madID) external returns (uint8);

    function confirmValidators() external returns (bool);

    function validatorMaxCount() external returns (uint8);

    function validatorCount() external returns (uint8);

    function setValidatorMaxCount(uint8 _validatorMaxCount) external;

    function isValidator(address validator) external view returns (bool);

    function removeValidator(address _validator, uint256[2] calldata _madID) external returns (uint8);

    function queueValidator(address _validator, uint256[2] calldata _madID) external returns (uint256);

    function getValidatorPublicKey(address _validator) external view returns (uint256[2] memory);

    function getValidators() external view returns (address[] memory);

    // Snapshot related
    function epoch() external returns (uint256);

    function snapshot(bytes calldata _signatureGroup, bytes calldata _bclaims) external;

    function getRawBlockClaimsSnapshot(uint256 _epoch) external view returns (bytes memory);

    function getRawSignatureSnapshot(uint256 _epoch) external view returns (bytes memory);

    function getChainIdFromSnapshot(uint256 _epoch) external view returns (uint32);

    function getHeightFromSnapshot(uint256 _epoch) external view returns (uint32);

    function getMadHeightFromSnapshot(uint256 _epoch) external view returns (uint32);

    // Functions mostly related to staking
    function burn(address who) external;

    function majorFine(address who) external;

    function minorFine(address who) external;
}