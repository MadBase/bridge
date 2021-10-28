// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceProposal.sol";
import "./facets/SnapshotsLibrary.sol";

contract GovernanceProposeModifySnapshot is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the Validators Diamond.
        address target = address(0x0);
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// SNAPSHOT REPLACEMENT LOGIC IN HERE!
    function callback() public override returns(bool) {
        // This function is called back by the Validators Diamond. Inside this
        // function, we have fully access to all the Validators Diamond Storage
        // including the the snapshots mapping arbitrarily.
        // Example:
        //
        //    SnapshotsLibrary.SnapshotsStorage storage s = SnapshotsLibrary.snapshotsStorage();
        //    bytes memory sig = "0xbeefdead";
        //    bytes memory bclaims = "0xdeadbeef";
        //    s.snapshots[1] = SnapshotsLibrary.Snapshot(true, 123, bclaims, sig, 456, 789);
        return true;
    }
}