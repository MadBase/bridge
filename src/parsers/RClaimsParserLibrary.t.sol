// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RClaimsParserLibrary.sol";


contract RClaimsParserLibraryTest is DSTest {

    function example_rclaim() private returns(bytes memory) {
        bytes memory rclaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // Data
            hex"02000000"
            hex"01000000"

            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // Data
        return rclaimCapnProto;
    }

    function test_extract_chainId() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extract_chainId(rclaimCapnProto);
        assertEqUint32(expected, actual);
    }

    function test_extract_height() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 2;
        uint32 actual = RClaimsParserLibrary.extract_height(rclaimCapnProto);

        assertEqUint32(expected, actual);
    }

    function test_extract_round() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extract_round(rclaimCapnProto);

        assertEqUint32(expected, actual);
    }

    function test_extract_prevBlock() public {
        bytes memory rclaimCapnProto = example_rclaim();
        bytes memory expected = hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        bytes memory actual = RClaimsParserLibrary.extract_prevBlock(rclaimCapnProto);

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
        //assertEq0(expected, actual);
        //assertEqUint32(howManyBytes, howManyBytes2);
    }
}