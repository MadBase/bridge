// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceStorage.sol";

abstract contract GovernanceProposal is GovernanceStorage {
    
    function execute() public virtual returns(bool) {
        return _execute();
    }
    
    function _execute() internal virtual returns(bool) {
        return true;
    }
}