// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./ParsersLibrary.sol";


contract ParsersLibraryTest is DSTest {

    // base parsers

    function test_extract_uint32() public {
        bytes memory b = hex"01020400";

        uint expected = 262657;
        uint32 actual = ParsersLibrary.extract_uint32(b, 0);

        assertEq(expected, actual);
    }

    function test_extract_uint256() public {
        bytes memory b = 
            hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        uint256 expected = 0xd8d6b02811ca34cef0bcbc79cc5dfaf2dc6b8133ea46d552ebfc96f1c2b2d710;
        uint256 actual = ParsersLibrary.extract_uint256(b, 0);

        assertEq(expected, actual);
    }

    /*function test_reverse() public {
        // todo
    }

    function test_extract_bytes() public {
        // todo
    }*/

    // rclaims parsers

    function example_rclaim() private returns(bytes memory) {
        bytes memory rclaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000"
            hex"02000000"
            hex"01000000"

            hex"00000000"
            hex"01000000"
            hex"02010000"

            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        return rclaimCapnProto;
    }

    function test_extract_rclaim_chainId() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 1;
        uint32 actual = ParsersLibrary.extract_rclaim_chainId(rclaimCapnProto);

        assertEqUint32(expected, actual);
    }

    function test_extract_rclaim_height() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 2;
        uint32 actual = ParsersLibrary.extract_rclaim_height(rclaimCapnProto);

        assertEqUint32(expected, actual);
    }

    function test_extract_rclaim_round() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 1;
        uint32 actual = ParsersLibrary.extract_rclaim_round(rclaimCapnProto);

        assertEqUint32(expected, actual);
    }

    function test_extract_rclaim_prevBlock() public {
        bytes memory rclaimCapnProto = example_rclaim();
        bytes memory expected = hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        bytes memory actual = ParsersLibrary.extract_rclaim_prevBlock(rclaimCapnProto);
        
        //uint32 howManyBytes = 32;
        //uint32 howManyBytes2 = 31;
        /*bytes memory val = new bytes(32);
        uint256 howManyBytes = 32;
        uint256 offset = 32;

        assembly {
            //mstore(add(add(val, offset), 32), add(src, 32))
            mstore(val, howManyBytes)
            //mstore(val, add(rclaimCapnProto, offset))
            mstore(add(val, 32), add(add(rclaimCapnProto, 32), offset))
        }

        emit log_named_bytes ("valxxx", val);
        */
        assertEq0(expected, actual);
        //assertEqUint32(howManyBytes, howManyBytes2);
    }
}