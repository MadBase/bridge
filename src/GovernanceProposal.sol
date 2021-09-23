// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.7.6;

import "./GovernanceStorage.sol";

abstract contract GovernanceProposal is GovernanceStorage {
    
    function execute() public returns(bool) {
        return _execute();
    }
    
    function _execute() internal virtual returns(bool) {
        return true;
    }
}