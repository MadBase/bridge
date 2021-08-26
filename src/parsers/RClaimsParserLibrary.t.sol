// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RClaimsParserLibrary.sol";


contract RClaimsParserLibraryTest is DSTest {

    function exampleRClaim() private returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rClaimCapnProto;
    }

    function testExtractChainId() public {
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extractChainId(exampleRClaim(), 8);
        assertEq(uint256(actual), uint256(expected));
    }

    function testExtractHeight() public {
        uint32 expected = 2;
        uint32 actual = RClaimsParserLibrary.extractHeight(exampleRClaim(), 12);

        assertEq(uint256(actual), uint256(expected));
    }

    function testExtractRound() public {
        uint32 expected = 1;
        uint32 actual = RClaimsParserLibrary.extractRound(exampleRClaim(), 16);

        assertEq(uint256(actual), uint256(expected));
    }

    function testExtractPrevBlock() public {
        bytes32 expected = hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        bytes32 actual = RClaimsParserLibrary.extractPrevBlock(exampleRClaim(), 32);

        assertEq(actual, expected);
    }

    function testExtractRClaim() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.parseRClaims(exampleRClaim());
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");

        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.round), uint256(expected.round));
        assertEq(actual.prevBlock, expected.prevBlock);
    }
}