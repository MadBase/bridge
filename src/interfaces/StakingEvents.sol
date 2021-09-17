// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;


/// @notice  Collection of all events that are considered for public use of system
interface StakingEvents {

    /// @notice Events used by Staking
    event LockedStake(address indexed who, uint256 amount);
    event LockedReward(address indexed who, uint256 amount);
    event UnlockedStake(address indexed who, uint256 amount);
    event UnlockedReward(address indexed who, uint256 amount);
    event BurntStake(address indexed who, uint256 amount);
    event Fined(address indexed who, bytes32 why, uint256 amount);
    event RequestedUnlockStake(address indexed who);

}