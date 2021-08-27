// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./RClaimsParserLibrary.sol";


contract RClaimsParserLibraryTest is DSTest {

    function exampleRClaim() private pure returns(bytes memory) {
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

    function badExampleRClaim() private pure returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"deadbeef"
            hex"beefde"
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // PrevBlock
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000";
        return rClaimCapnProto;
    }

    function exampleRClaimWithAdditionalData() private pure returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // PrevBlock
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000";
        return rClaimCapnProto;
    }

    function exampleRClaimWithMissingData() private pure returns(bytes memory) {
        bytes memory rClaimCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"deadbeef"
            hex"beefdead"
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        return rClaimCapnProto;
    }

    // function testExtractRClaimsOutOffBounds() public {
    //     RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(badExampleRClaim(), 10000000000);
    //     //Should fail
    // }

    // function testExtractRClaimsWithOverflowOffset() public {
    //     uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    //     RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(badExampleRClaim(), bigValue);
    //     //Should fail
    // }

    function testExtractRClaimsFromArbitraryLocation() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(badExampleRClaim(), 15);
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");

        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.round), uint256(expected.round));
        assertEq(actual.prevBlock, expected.prevBlock);
    }

    function testRawSerializedRClaims() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaim());
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");

        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.round), uint256(expected.round));
        assertEq(actual.prevBlock, expected.prevBlock);
    }

    function testRawSerializedRClaimsWithAdditionalRandomData() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaimWithAdditionalData());
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");

        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.round), uint256(expected.round));
        assertEq(actual.prevBlock, expected.prevBlock);
    }

    // function testRawSerializedRClaimsWithMissingData() public {
    //     RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaimWithMissingData());
    //     //Should fail
    // }
}