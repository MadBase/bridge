// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./interfaces/Governor.sol";

import "./SimpleAuth.sol";

contract DirectGovernance is Governor, SimpleAuth {

    function updateValue(uint256 epoch, string memory name, string memory value) external override onlyOperator {
        emit ValueUpdated(epoch, name, value, msg.sender);
    }

}