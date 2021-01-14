// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./facets/SnapshotsFacet.sol";
import "./Staking.sol";
import "./ValidatorsDiamond.sol";

contract ValidatorsDiamondTest is DSTest{

    SnapshotsFacet sf;
    ValidatorsDiamond vd;

    function setUp() public {
        vd = new ValidatorsDiamond();
        sf = SnapshotsFacet(address(vd));
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

}
