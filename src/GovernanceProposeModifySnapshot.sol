// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceProposal.sol";

contract GovernanceProposeModifySnapshot is GovernanceProposal {
    
    function _execute() internal override returns(bool) {
        address target = address(0);
        (bool success, ) = target.call(abi.encodeWithSignature("modifySnapShot()"));
        require(success, "CALL FAILED");
        return success;
    }   
}