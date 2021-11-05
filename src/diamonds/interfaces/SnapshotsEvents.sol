// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;


/// @notice  Collection of all events that are considered for public use of system
interface SnapshotsEvents {

    /// @notice Event emmitted after taking a snapshot
    event SnapshotTaken(uint32 chainId, uint256 indexed epoch, uint32 height, address indexed validator, bool startingETHDKG);
}