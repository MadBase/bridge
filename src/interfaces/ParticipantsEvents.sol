// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;


/// @notice  Collection of all events that are considered for public use of system
interface ParticipantsEvents {

    /// @notice Events emmitted while maintaining validator set
    event ValidatorCreated(address indexed validator, address indexed signer, uint256[2] madID);
    event ValidatorJoined(address indexed validator, uint256[2] madID);
    event ValidatorLeft(address indexed validator, uint256[2] pkHash);
    event ValidatorQueued(address indexed validator, uint256[2] pkHash);
}