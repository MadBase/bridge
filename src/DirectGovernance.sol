// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./interfaces/Governor.sol";

import "./SimpleAuth.sol";

contract DirectGovernance is Governor, SimpleAuth {

    function updateValue(uint256 epoch, uint256 key, bytes32 value) external override onlyOperator {
        emit ValueUpdated(epoch, key, value, msg.sender);
    }

}