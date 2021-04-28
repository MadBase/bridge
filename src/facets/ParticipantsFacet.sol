// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../interfaces/Participants.sol";

import "./AccessControlLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./StakingLibrary.sol";
import "./StopLibrary.sol";

import "../Constants.sol";
import "../Registry.sol";

contract ParticipantsFacet is AccessControlled, Constants, Participants, Stoppable {

    function initializeParticipants(Registry registry) external onlyOwner override {
        require(address(registry) != address(0), "nil registry address");
    }

    function confirmValidators() external override returns (bool) {
        return ParticipantsLibrary.confirmValidators();
    }

    function isValidator(address validator) external view override returns (bool) {
        return ParticipantsLibrary.isValidator(validator);
    }

    function addValidator(address _validator, uint256[2] calldata _madID) external override returns (uint8) {
        require(ParticipantsLibrary.addOrQueueValidator(_validator, _madID),"failed to add or queue");

        return 0;
    }

    function validatorCount() external view override returns (uint8) {
        return ParticipantsLibrary.participantsStorage().validatorCount;
    }

    function validatorMaxCount() external view override returns (uint8) {
        return ParticipantsLibrary.participantsStorage().validatorMaxCount;
    }

    function setValidatorMaxCount(uint8 max) external override {
        ParticipantsLibrary.participantsStorage().validatorMaxCount = max;
    }

    function removeValidator(address _validator, uint256[2] calldata _madID) external override returns (uint8) {
        return ParticipantsLibrary.removeValidator(_validator, _madID);
    }

    function getValidatorPublicKey(address _validator) external view override returns (uint256[2] memory) {
        return ParticipantsLibrary.getValidatorPublicKey(_validator);
    }

    function getValidators() external view override returns (address[] memory) {
        return ParticipantsLibrary.participantsStorage().validators;
    }
}