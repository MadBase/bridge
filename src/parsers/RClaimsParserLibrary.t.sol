// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RClaimsParserLibrary.sol";


contract RClaimsParserLibraryTest is DSTest {

    function example_rclaim() private returns(bytes memory) {
        bytes memory rclaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // ChainID
            hex"02000000" // Height
            hex"01000000" // Round

            hex"00000000"
            hex"01000000"
            hex"02010000"

            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rclaimCapnProto;
    }

    function test_extract_chainId() public {
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extract_chainID(example_rclaim());
        assertEqUint32(actual, expected);
    }

    function test_extract_height() public {
        uint32 expected = 2;
        uint32 actual = RClaimsParserLibrary.extract_height(example_rclaim());

        assertEqUint32(actual, expected);
    }

    function test_extract_round() public {
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extract_round(example_rclaim());

        assertEqUint32(actual, expected);
    }

    function test_extract_prevBlock() public {
        bytes memory expected = hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        bytes memory actual = RClaimsParserLibrary.extract_prevBlock(example_rclaim());

        assertEq0(actual, expected);
    }

    function test_extract_rclaim() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extract_rclaims(example_rclaim());
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");
        
        assertEqUint32(actual.chainID, expected.chainID);
        assertEqUint32(actual.height, expected.height);
        assertEqUint32(actual.round, expected.round);
        assertEq0(actual.prevBlock, expected.prevBlock);
    }
}