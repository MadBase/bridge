// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.4;
pragma experimental ABIEncoderV2;

import "../QueueLibrary.sol";

library ParticipantsStorageLibrary {
    bytes32 constant STORAGE_LOCATION = keccak256("participants.storage");

    struct ParticipantsStorage {
        address[] validators;
        mapping(address => uint256) validatorIndex;
        mapping(address => bool) validatorPresent;
        mapping(address => uint256[2]) validatorPublicKey;
        uint8 validatorCount;
        uint8 validatorMaxCount;
        bool validatorsChanged; // TODO need to centralize where this is stored
        QueueLibrary.Queue queue;
        address stakingAddress;
        uint256 minimumStake;
    }

    function participantsStorage() internal pure returns (ParticipantsStorage storage ps) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ps.slot := position // From solidity 0.6 -> 0.7 syntax changes from '_' to '.'
        }
    }

}