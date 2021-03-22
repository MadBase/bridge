// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./MigrateETHDKG.sol";

import "../facets/Setup.t.sol";

import "../Constants.sol";
import "../interfaces/ETHDKG.sol";
import "../Registry.sol";

contract MigrateETHDKGTest is Constants, DSTest, Setup {

    function testMigrator() public {

        uint256 sz = 7;

        address diamond = address(ethdkg);
        DiamondUpdateFacet update = DiamondUpdateFacet(diamond);
        address facet = address(new MigrateETHDKG());

        update.addFacet(MigrateETHDKG.migrate.selector, facet);

        // Values
        uint256 epoch = 3;
        uint32 ethHeight = 9_600_000;
        uint32 madHeight = 2048;
        uint256[4] memory master_public_key;
        address[] memory addresses = new address[](sz);
        uint256[4][] memory gpkj = new uint256[4][](sz);

        master_public_key = [uint256(1), 1, 1, 1];

        // Build member specific info
        for (uint160 idx; idx < sz; idx++) {
            addresses[idx] = address(9-idx);
            gpkj[idx] = [uint256(idx), idx+1, idx+2, idx+3];
        }

        // Make the call
        MigrateETHDKG wrapper = MigrateETHDKG(address(ethdkg));
        wrapper.migrate(
            epoch, ethHeight, madHeight, master_public_key, addresses, gpkj);

        // Verify
        assertEq(ethdkg.master_public_key(0), 1, "wrong mpk");
        assertEq(ethdkg.master_public_key(1), 1, "wrong mpk");
        assertEq(ethdkg.master_public_key(2), 1, "wrong mpk");
        assertEq(ethdkg.master_public_key(3), 1, "wrong mpk");

        assertEq(ethdkg.gpkj_submissions(address(8), 0), 1, "wrong gpkj");
        assertEq(ethdkg.gpkj_submissions(address(8), 1), 2, "wrong gpkj");
        assertEq(ethdkg.gpkj_submissions(address(8), 2), 3, "wrong gpkj");
        assertEq(ethdkg.gpkj_submissions(address(8), 3), 4, "wrong gpkj");
    }
}