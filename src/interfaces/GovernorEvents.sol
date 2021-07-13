// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "../Registry.sol";

interface GovernorEvents {

    event ValueUpdated(uint256 indexed epoch, string name, string value, address who);

}
