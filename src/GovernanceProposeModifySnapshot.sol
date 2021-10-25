// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceProposal.sol";

contract GovernanceProposeModifySnapshot is GovernanceProposal {

    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the Snapshot contract. E.g 0xEAC31aabA7442B58Bd7A8431d1D3Db3Bf3262667
        address target = address(0x0);
        (bool success, ) = target.call(abi.encodeWithSignature("modifySnapshot(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    function _modifySnapshot() public returns(bool) {
        SnapshotsLibrary.SnapshotsStorage storage s = SnapshotsLibrary.snapshotsStorage();
        // // We now have access to modify de Snapshot storage in whatever way we want. E.g:
        // bytes memory sig = "0xbeefdead";
        // bytes memory bclaims = "0xdeadbeef";
        // s.snapshots[1] = SnapshotsLibrary.Snapshot(true, 123, bclaims, sig, 456, 789);
        return true;
    }
}