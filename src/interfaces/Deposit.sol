// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./DepositEvents.sol";

/// @notice  Collection of all events that are considered for public use of system
interface Deposit is DepositEvents {
    function deposit(uint256 amount) external;

    function depositFor(address who, uint256 amount) external;
}