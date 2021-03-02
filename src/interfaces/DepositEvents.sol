// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

/// @notice  Collection of all events that are considered for public use of system
interface DepositEvents {

    /// @notice Event emitted when a deposit is received
    event DepositReceived(uint256 depositID, address depositor, uint256 amount);
}