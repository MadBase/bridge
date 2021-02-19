// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../interfaces/ParticipantsEvents.sol";

import "./AccessControlLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./StakingLibrary.sol";
import "./StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";

contract ParticipantsFacet is AccessControlled, Constants, ParticipantsEvents, Stoppable {

    function initializeParticipants(Registry registry) external onlyOwner {
        require(address(registry) != address(0), "nil registry address");
    }

    function confirmValidators() external returns (bool) {
        return ParticipantsLibrary.confirmValidators();
    }

    function isValidator(address validator) external view returns (bool) {
        return ParticipantsLibrary.isValidator(validator);
    }

    function addValidator(address _validator, uint256[2] calldata _madID) external returns (uint8) {
        return ParticipantsLibrary.addValidator(_validator, _madID);
    }

    function validatorCount() external view returns (uint8) {
        return ParticipantsLibrary.participantsStorage().validatorCount;
    }

    function validatorMaxCount() external view returns (uint8) {
        return ParticipantsLibrary.participantsStorage().validatorMaxCount;
    }

    function setValidatorMaxCount(uint8 max) external {
        ParticipantsLibrary.participantsStorage().validatorMaxCount = max;
    }

    function removeValidator(address _validator, uint256[2] calldata _madID) external returns (uint8) {
        return ParticipantsLibrary.removeValidator(_validator, _madID);
    }

    //
    function queueValidator(address _validator, uint256[2] calldata _madID) external returns (uint256) {
        return ParticipantsLibrary.queueValidator(_validator, _madID);
    }

    function getValidatorPublicKey(address _validator) external view returns (uint256[2] memory) {
        return ParticipantsLibrary.getValidatorPublicKey(_validator);
    }

    function getValidators() external view returns (address[] memory) {
        return ParticipantsLibrary.participantsStorage().validators;
    }
}