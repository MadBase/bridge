// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "lib/ds-test/test.sol";
import "src/parsers/RClaimsParserLibrary.sol";

contract RClaimsParserLibraryTest is DSTest {

    function exampleRClaims() private pure returns(bytes memory) {
        bytes memory rClaimsCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rClaimsCapnProto;
    }

    function exampleRClaimsChainID0() private pure returns(bytes memory) {
        bytes memory rClaimsCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"00000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rClaimsCapnProto;
    }

    function exampleRClaimsHeight0() private pure returns(bytes memory) {
        bytes memory rClaimsCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"00000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rClaimsCapnProto;
    }

    function exampleRClaimsRound0() private pure returns(bytes memory) {
        bytes memory rClaimsCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"00000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16"; // PrevBlock

        return rClaimsCapnProto;
    }

    function exampleRClaimsWithRandomData() private pure returns(bytes memory) {
        bytes memory rClaimsCapnProto =
            hex"deadbeef"
            hex"beefde"
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"01000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // PrevBlock
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000";
        return rClaimsCapnProto;
    }

    function exampleRClaimsWithAdditionalData() private pure returns(bytes memory) {
        bytes memory rClaimsCapnProto =
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
        return rClaimsCapnProto;
    }

    function exampleRClaimsWithMissingData() private pure returns(bytes memory) {
        bytes memory rClaimsCapnProto =
            hex"0000000002000100" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" //chainId
            hex"02000000" //height
            hex"01000000" //round
            hex"00000000"
            hex"02010000"
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16";
        return rClaimsCapnProto;
    }

    function assertEqRClaims(RClaimsParserLibrary.RClaims memory actual, RClaimsParserLibrary.RClaims memory expected) internal {
        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.round), uint256(expected.round));
        assertEq(actual.prevBlock, expected.prevBlock);
    }

    function testDecodingRClaims() public {
        uint256 startGas = gasleft();
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaims());
        uint256 endGas = gasleft();
        emit log_named_uint("RClaims gas", startGas - endGas);
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");
        assertEqRClaims(actual, expected);
    }

    function testDecodingRClaimsWithAdditionalRandomData() public {
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractRClaims(exampleRClaimsWithAdditionalData());
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");
        assertEqRClaims(actual, expected);
    }

    function testDecodingRClaimsFromArbitraryLocation() public {
        uint256 startGas = gasleft();
        RClaimsParserLibrary.RClaims memory actual = RClaimsParserLibrary.extractInnerRClaims(exampleRClaimsWithRandomData(), 15);
        uint256 endGas = gasleft();
        emit log_named_uint("RClaims gas", startGas - endGas);
        RClaimsParserLibrary.RClaims memory expected = RClaimsParserLibrary.RClaims(1, 2, 1, hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16");
        assertEqRClaims(actual, expected);
    }

    function testFail_ExtractingRClaimsHeight0() public {
        RClaimsParserLibrary.extractRClaims(exampleRClaimsHeight0());
    }

    function testFail_ExtractingRClaimsChainID0() public {
        RClaimsParserLibrary.extractRClaims(exampleRClaimsChainID0());
    }

    function testFail_ExtractingRClaimsRound0() public {
        RClaimsParserLibrary.extractRClaims(exampleRClaimsRound0());
    }

    function testFail_ExtractingRClaimsWithOutSideData() public {
        RClaimsParserLibrary.extractInnerRClaims(exampleRClaimsWithAdditionalData(), 10000000000);
    }

    function testFail_ExtractingRClaimsWithOverflow() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        RClaimsParserLibrary.extractInnerRClaims(exampleRClaimsWithAdditionalData(), bigValue);
    }

    function testFail_ExtractingRClaimsWithoutHavingEnoughData() public {
        RClaimsParserLibrary.extractInnerRClaims(exampleRClaimsWithMissingData(), RClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);
    }
}
