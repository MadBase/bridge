// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./MigrateSnapshotsFacet.sol";

import "../facets/ValidatorsSetup.t.sol";

import "../Constants.sol";
import "../ETHDKG.sol";
import "../Registry.sol";

contract MigrateSnapshotsFacetTest is Constants, DSTest, ValidatorsSetup {

    function testSnapshot() public {

        // Setup snapshot migrator
        address msf = address(new MigrateSnapshotsFacet());
        update.addFacet(MigrateSnapshotsFacet.snapshot.selector, msf);

        // Spot check assumptions
        assertEq(snapshots.epoch(), 1, "Next snapshot should be 1");
        assertEq(snapshots.getRawSignatureSnapshot(3).length, 0, "foo");

        // Let's do a unverifiable snapshot of sorts
        MigrateSnapshotsFacet migrator = MigrateSnapshotsFacet(diamond);

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

        // Signature isn't valid
        migrator.snapshot(3, signatureGroup, bclaims);

        // Make sure it's there
        assertEq(snapshots.epoch(), 1, "Next snapshot should be 1");

        uint256 chainId = snapshots.getChainIdFromSnapshot(3); 
        assertEq(chainId, 43, "ChainID should be 43");

        uint256 chainHeight = snapshots.getMadHeightFromSnapshot(3); 
        assertEq(chainHeight, 10, "Chain height should be 10");
    }
}