// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "./interfaces/IDirectGovernor.sol";

/// @custom:salt DirectGovernance
/// @custom:deploy-type deployUpgradeable
contract DirectGovernance is IDirectGovernor {
    address internal immutable _factory;

    constructor() {
        _factory = msg.sender;
    }

    function updateValue(uint256 epoch, uint256 key, bytes32 value) external {
        require(msg.sender == _factory , "DirectGovernance: Only factory allowed!");
        emit ValueUpdated(epoch, key, value, msg.sender);
    }
}