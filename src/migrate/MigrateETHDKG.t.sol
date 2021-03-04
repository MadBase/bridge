// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";

import "./MigrateETHDKG.sol";

import "../Constants.sol";
import "../ETHDKG.sol";
import "../Registry.sol";

contract MigrateETHDKGTest is Constants, DSTest {

    string constant MIGRATOR_SIG = "migrate(address,uint256,uint32,uint32,uint256[4],address[],uint256[4][])";

    ETHDKG private ethdkg;
    MigrateETHDKG private migrator;
    Registry private registry;

    function setUp() public {
        registry = new Registry();

        ethdkg = new ETHDKG(registry);
        migrator = new MigrateETHDKG();
    }


    function testMigrator() public {

        uint256 sz = 7;

        // Values
        uint256 epoch = 3;
        uint32 ethHeight = 9_600_000;
        uint32 madHeight = 2048;
        uint256[4] memory master_public_key;
        address[] memory addresses = new address[](sz);
        uint256[4][] memory gpkj = new uint256[4][](sz);

        master_public_key[0] = 1;
        master_public_key[1] = 1;
        master_public_key[2] = 1;
        master_public_key[3] = 1;

        // Build member specific info
        // -- Member 7's gpkj is 7, 6, 5, 4
        for (uint160 idx; idx < sz; idx++) {
            addresses[idx] = address(9-idx);
            gpkj[idx][0] = idx;
            gpkj[idx][1] = idx;
            gpkj[idx][2] = idx;
            gpkj[idx][3] = idx;
        }

        // Encode
        bytes memory cd = abi.encodeWithSignature(
            MIGRATOR_SIG, 
            address(migrator), 
            epoch, ethHeight, madHeight, master_public_key, addresses, gpkj);

        // Call
        bool ok;
        (ok,) = address(ethdkg).call(cd); // solium-disable-line
        assertTrue(ok);

        // Verify
        assertEq(ethdkg.master_public_key(0), 1, "");
    }
}