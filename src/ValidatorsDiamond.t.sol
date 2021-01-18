// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./facets/SnapshotsFacet.sol";
import "./facets/ValidatorsUpdateFacet.sol";
import "./Staking.sol";
import "./ValidatorsDiamond.sol";

contract ValidatorsDiamondTest is DSTest{

    ValidatorsDiamond vd;
    SnapshotsFacet sf;
    ValidatorsUpdateFacet vu;

    function setUp() public {
        vd = new ValidatorsDiamond();
        sf = SnapshotsFacet(address(vd));
        vu = ValidatorsUpdateFacet(address(vd));

        // Add facets for Snapshots
        SnapshotsFacet snapshots = new SnapshotsFacet();
        vu.addFacet(SnapshotsFacet.extractUint256.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.extractUint32.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.nextSnapshot.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.setNextSnapshot.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.snapshot.selector, address(snapshots));
        
        vu.addFacet(SnapshotsFacet.getChainIdFromSnapshot.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.getHeightFromSnapshot.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.getMadHeightFromSnapshot.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.getRawBlockClaimsSnapshot.selector, address(snapshots));
        vu.addFacet(SnapshotsFacet.getRawSignatureSnapshot.selector, address(snapshots));

        // Initialize
        sf.setNextSnapshot(1);
    }

    function testBuild() public {
        ValidatorsDiamond vd2 = new ValidatorsDiamond();
        SnapshotsFacet sf2 = SnapshotsFacet(address(vd2));
        ValidatorsUpdateFacet vu2 = ValidatorsUpdateFacet(address(vd2));

        // Add facets for Snapshots
        SnapshotsFacet snapshots = new SnapshotsFacet();
        vu2.addFacet(SnapshotsFacet.extractUint256.selector, address(snapshots));
        vu2.addFacet(SnapshotsFacet.extractUint32.selector, address(snapshots));
        vu2.addFacet(SnapshotsFacet.nextSnapshot.selector, address(snapshots));
        vu2.addFacet(SnapshotsFacet.setNextSnapshot.selector, address(snapshots));
    }

    function testSetSnapshot() public {

        sf.setNextSnapshot(13);

        assertEq(sf.nextSnapshot(), 13);
    }

    function testFailNotFacet() public {
        Staking s = Staking(address(vd)); // Staking is not a facet of ValidatorsDiamond so calls should fail

        s.balanceReward();
    }

    function testExtractUint32() public {
        bytes memory b = hex"01020400";

        uint expected = 262657;
        uint32 actual = sf.extractUint32(b, 0);

        assertEq(actual, expected);
    }

    function testExtractUint256() public {
        bytes memory b = 
            hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        uint256 expected = 0xd8d6b02811ca34cef0bcbc79cc5dfaf2dc6b8133ea46d552ebfc96f1c2b2d710;
        uint256 actual = sf.extractUint256(b, 0);

        assertEq(actual, expected);
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

        // sf.setNextSnapshot(1);

        uint256 epoch = sf.nextSnapshot();
        assertEq(epoch, 1);

        sf.snapshot(signatureGroup, bclaims);

        uint256 newEpoch = sf.nextSnapshot();
        assertEq(newEpoch, 2);

        bytes memory rawSig = sf.getRawSignatureSnapshot(epoch);
        assertEq(rawSig.length, signatureGroup.length);

        uint32 madHeight = sf.getMadHeightFromSnapshot(epoch);
        assertEq(int(madHeight), 5);

        uint32 height = sf.getHeightFromSnapshot(epoch);
        assertEq(int(height), 0);

        uint32 chainId = sf.getChainIdFromSnapshot(epoch);
        assertEq(int(chainId), 42);
    }

}
