// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RClaimsParserLibrary.sol";


contract RClaimsParserLibraryTest is DSTest {

    function example_rclaim() private returns(bytes memory) {
        bytes memory rclaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rclaimCapnProto;
    }

    function test_extract_chainId() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extract_chainID(example_rclaim());
        assertEq(uint256(actual), uint256(expected));
    }

    function test_extract_height() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 2;
        uint32 actual = RClaimsParserLibrary.extract_height(rclaimCapnProto);

        assertEq(uint256(actual), uint256(expected));
    }

    function test_extract_round() public {
        bytes memory rclaimCapnProto = example_rclaim();
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extract_round(rclaimCapnProto);

        assertEq(uint256(actual), uint256(expected));
    }

    function test_extract_prevBlock() public {
        bytes32 expected = hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        bytes32 actual = RClaimsParserLibrary.extract_prevBlock(example_rclaim());

        assertEq(actual, expected);
    }

    function test_extract_rclaim() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extract_rclaims(example_rclaim());
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");

        assertEq(uint256(actual.chainID), uint256(expected.chainID));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.round), uint256(expected.round));
        assertEq(actual.prevBlock, expected.prevBlock);
    }
}