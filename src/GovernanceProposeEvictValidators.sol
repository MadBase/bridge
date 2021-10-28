// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceProposal.sol";

contract GovernanceProposeEvictValidators is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    function execute(address self) public override returns(bool) {
        address target = address(0);
        (bool success, ) = target.call(abi.encodeWithSignature("evictValidators()"));
        require(success, "CALL FAILED");
        return success;
    }
}