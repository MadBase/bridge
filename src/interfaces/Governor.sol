// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./GovernorEvents.sol";

import "../Registry.sol";

interface Governor is GovernorEvents {

    function updateValue(uint256 epoch, string memory name, string memory value) external;

}