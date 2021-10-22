// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

import "ds-test/test.sol";

import "../interfaces/Validators.sol";
import "../interfaces/Snapshots.sol";

import "./ParticipantsFacet.t.sol";
import "./Setup.t.sol";
import "./SnapshotsFacet.sol";

contract MockUpGovernanceSetter {
    function setGovernance(address snapshotDiamond, address governance_) public {
        Snapshots(snapshotDiamond).setGovernance(governance_);
    }
}

contract SnapshotsFacetTest is Constants, DSTest, Setup {

    function testNextSnapshot() public {
        snapshots.setEpoch(13);
        assertEq(snapshots.epoch(), 13);
    }



    function testFailSnapshot() public {
        bytes memory bclaims =
            hex"00000000010004002b0000000a0000000d000000020100001900000002010000"
            hex"250000000201000031000000020100007565a2d7195f43727e1141f00228fd60"
            hex"da3ca7ada3fc0a5a34ea537e0cb82e8dc5d2460186f7233c927e7db2dcc703c0"
            hex"e500b653ca82273b7bfad8045d85a47000000000000000000000000000000000"
            hex"00000000000000000000000000000000ede353f57b9e2599f9165fde4ec80b60"
            hex"0e9c20418aa3f4d3d6aabee6981abff6";

        bytes memory signatureGroup =
            hex"2ee01ec6218252b7e263cb1d86e6082f7e05e0c86b17607c5490cd2a73ac14f6"
            hex"2cc0679acd5fb16c0c983806d13127354423e908fec273db1fc62c38fcee59d5"
            hex"2570a1763029316ee5cb6e44a74039f15935f110898ad495ffe837335ced059d"
            hex"0d426710c8a650cf96de6462406c3b707d4d1ae2231f3206c57b6551e12f593c"
            hex"1b3c547d051cc268a996a7494df22da5afc31650ba0963e1ee39a2404c4f6cd1"
            hex"22d313f80eb31f8cac30cd98686f815d38b8ea2d46748e9f8971db83f5311a24";

        assertEq(signatureGroup.length, 192);

        snapshots.snapshot(signatureGroup, bclaims);
    }

    function testSnapshot() public {

        bytes memory bclaims =
            hex"00000000010004002a000000050000000d000000020100001900000002010000"
            hex"250000000201000031000000020100007565a2d7195f43727e1141f00228fd60"
            hex"da3ca7ada3fc0a5a34ea537e0cb82e8dc5d2460186f7233c927e7db2dcc703c0"
            hex"e500b653ca82273b7bfad8045d85a47000000000000000000000000000000000"
            hex"00000000000000000000000000000000ede353f57b9e2599f9165fde4ec80b60"
            hex"0e9c20418aa3f4d3d6aabee6981abff6";

        bytes memory signatureGroup =
            hex"2ee01ec6218252b7e263cb1d86e6082f7e05e0c86b17607c5490cd2a73ac14f6"
            hex"2cc0679acd5fb16c0c983806d13127354423e908fec273db1fc62c38fcee59d5"
            hex"2570a1763029316ee5cb6e44a74039f15935f110898ad495ffe837335ced059d"
            hex"0d426710c8a650cf96de6462406c3b707d4d1ae2231f3206c57b6551e12f593c"
            hex"1b3c547d051cc268a996a7494df22da5afc31650ba0963e1ee39a2404c4f6cd1"
            hex"22d313f80eb31f8cac30cd98686f815d38b8ea2d46748e9f8971db83f5311a24";

        assertEq(signatureGroup.length, 192);

        uint256 epoch = snapshots.epoch();
        assertEq(epoch, 1);

        snapshots.snapshot(signatureGroup, bclaims);

        uint256 newEpoch = snapshots.epoch();
        assertEq(newEpoch, 2);

        bytes memory rawSig = snapshots.getRawSignatureSnapshot(epoch);
        assertEq(rawSig.length, signatureGroup.length);

        uint32 madHeight = snapshots.getMadHeightFromSnapshot(epoch);
        assertEq(uint256(madHeight), 5);

        uint32 height = snapshots.getHeightFromSnapshot(epoch);
        assertEq(uint256(height), 0);

        uint32 chainId = snapshots.getChainIdFromSnapshot(epoch);
        assertEq(uint256(chainId), 42);
    }

    function testSnapshot2() public {
        bytes memory bclaims =
            hex"00000000010004002a000000050000000d000000020100001900000002010000"
            hex"250000000201000031000000020100007565a2d7195f43727e1141f00228fd60"
            hex"da3ca7ada3fc0a5a34ea537e0cb82e8dc5d2460186f7233c927e7db2dcc703c0"
            hex"e500b653ca82273b7bfad8045d85a47000000000000000000000000000000000"
            hex"00000000000000000000000000000000ede353f57b9e2599f9165fde4ec80b60"
            hex"0e9c20418aa3f4d3d6aabee6981abff6";

        bytes memory signatureGroup =
            hex"2ee01ec6218252b7e263cb1d86e6082f7e05e0c86b17607c5490cd2a73ac14f6"
            hex"2cc0679acd5fb16c0c983806d13127354423e908fec273db1fc62c38fcee59d5"
            hex"2570a1763029316ee5cb6e44a74039f15935f110898ad495ffe837335ced059d"
            hex"0d426710c8a650cf96de6462406c3b707d4d1ae2231f3206c57b6551e12f593c"
            hex"1b3c547d051cc268a996a7494df22da5afc31650ba0963e1ee39a2404c4f6cd1"
            hex"22d313f80eb31f8cac30cd98686f815d38b8ea2d46748e9f8971db83f5311a24";

        assertEq(signatureGroup.length, 192);

        uint256 epoch = snapshots.epoch();
        assertEq(epoch, 1);

        snapshots.snapshot(signatureGroup, bclaims);

        uint256 newEpoch = snapshots.epoch();
        assertEq(newEpoch, 2);

        bytes memory rawSig = snapshots.getRawSignatureSnapshot(epoch);
        assertEq(rawSig.length, signatureGroup.length);

        uint256 madHeight = snapshots.getMadHeightFromSnapshot(epoch);
        assertEq(madHeight, 5);

        uint256 height = snapshots.getHeightFromSnapshot(epoch);
        assertEq(height, 0);

        uint256 chainId = snapshots.getChainIdFromSnapshot(epoch);
        assertEq(chainId, 42);
    }

    function testGoodSnapshot() public {
        // Create 4 validators
        Representative[] memory reps = new Representative[](4);
        for (uint256 i; i<4;i++) {
            reps[i] = createRepresentative(i);
        }

        // Add 'this' as validator, so the snapshot bonus goes to 'this' as well.
        uint256[2] memory madID;
        stakingToken.approve(address(staking), MINIMUM_STAKE);
        staking.lockStake(MINIMUM_STAKE);
        participants.addValidator(address(this), madID);

        uint256 ib = staking.balanceRewardFor(address(reps[0]));
        assertEq(ib, 0);

        goodSnapshot();

        ib = staking.balanceRewardFor(address(reps[0]));
        assertEq(ib, 13); // Reward is 13

        ib = staking.balanceRewardFor(address(this));
        assertEq(ib, 20); // Reward is 13, and the bonus is 7. 13+7=20.
    }

    function testGoodSnapshots() public {
        // Initially ethereum and madnet gap between snapshots is set to 0
        // goodSnapshot();
        goodSnapshot();
    }

    function testFailGoodSnapshots() public {
        snapshots.setMinEthSnapshotSize(1); // Allow snapshots on consecutive ethereum blocks
        goodSnapshot();
        goodSnapshot();
    }

    function goodSnapshot() internal {
        bytes memory bclaims =
            hex"00000000010004002a000000050000000d000000020100001900000002010000"
            hex"250000000201000031000000020100007565a2d7195f43727e1141f00228fd60"
            hex"da3ca7ada3fc0a5a34ea537e0cb82e8dc5d2460186f7233c927e7db2dcc703c0"
            hex"e500b653ca82273b7bfad8045d85a47000000000000000000000000000000000"
            hex"00000000000000000000000000000000ede353f57b9e2599f9165fde4ec80b60"
            hex"0e9c20418aa3f4d3d6aabee6981abff6";

        bytes memory signatureGroup =
            hex"2ee01ec6218252b7e263cb1d86e6082f7e05e0c86b17607c5490cd2a73ac14f6"
            hex"2cc0679acd5fb16c0c983806d13127354423e908fec273db1fc62c38fcee59d5"
            hex"2570a1763029316ee5cb6e44a74039f15935f110898ad495ffe837335ced059d"
            hex"0d426710c8a650cf96de6462406c3b707d4d1ae2231f3206c57b6551e12f593c"
            hex"1b3c547d051cc268a996a7494df22da5afc31650ba0963e1ee39a2404c4f6cd1"
            hex"22d313f80eb31f8cac30cd98686f815d38b8ea2d46748e9f8971db83f5311a24";

        snapshots.snapshot(signatureGroup, bclaims);
    }

    function generateMadID(uint256 id) internal pure returns (uint256[2] memory madID) {
        madID[0] = id;
        madID[1] = id;
    }

    function createRepresentative(uint representativeNumber) internal returns (Representative) {
        uint256[2] memory representativeID = generateMadID(representativeNumber);
        Representative rep = new Representative(participants, representativeID, stakingToken, staking, MINIMUM_STAKE);

        stakingToken.transfer(address(rep), MINIMUM_STAKE);

        uint256 b = stakingToken.balanceOf(address(rep));
        assertEq(b, MINIMUM_STAKE);

        rep.add();

        return rep;
    }

    function testFail_TrySetGovernanceWithoutPermissions() public {
        // Create a contract to mock up the msg.sender to be some one that does
        // not have rights to set the governance address in the snapshots
        // diamond.
        MockUpGovernanceSetter govSetter = new MockUpGovernanceSetter();
        govSetter.setGovernance(address(snapshots), address(this));
    }
}