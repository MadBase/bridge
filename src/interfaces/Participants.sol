// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;


import "./ParticipantsEvents.sol";

import "../Registry.sol";

interface Participants is ParticipantsEvents {

    function initializeParticipants(Registry registry) external;

    function confirmValidators() external returns (bool);

    function isValidator(address validator) external view returns (bool);

    function addValidator(address _validator, uint256[2] memory _madID) external returns (uint8);

    function validatorCount() external returns (uint8);

    function validatorMaxCount() external returns (uint8);

    function setValidatorMaxCount(uint8 max) external;

    function removeValidator(address _validator, uint256[2] calldata _madID) external returns (uint8);

    function queueValidator(address _validator, uint256[2] calldata _madID) external returns (uint256);

    function getValidatorPublicKey(address _validator) external view returns (uint256[2] memory);

    function getValidators() external view returns (address[] memory);

}