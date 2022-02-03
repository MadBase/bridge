// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "lib/ds-test/test.sol";
import "src/parsers/BClaimsParserLibrary.sol";

contract BClaimsParserLibraryTest is DSTest {

    function exampleBClaims() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // chainId
            hex"02000000" // height
            hex"01000000" // txCount
            hex"00000000" // zero pads for the txCount slot since every capnproto word is 8 bytes
            hex"0d00000002010000" //List(uint8) definition for prevBlock
            hex"1900000002010000" //List(uint8) definition for txRoot
            hex"2500000002010000" //List(uint8) definition for stateRoot
            hex"3100000002010000" //List(uint8) definition for headerRoot
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"; // headerRoot
        return bClaimsCapnProto;
    }

    function exampleBClaimsWithTxCount0() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000001000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // chainId
            hex"01000000" // height
            hex"0d00000002010000" //List(uint8) definition for prevBlock
            hex"1900000002010000" //List(uint8) definition for txRoot
            hex"2500000002010000" //List(uint8) definition for stateRoot
            hex"3100000002010000" //List(uint8) definition for headerRoot
            hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d" // prevBlock
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // txRoot
            hex"b58904fe94d4dca4102566c56402dfa153037d18263b3f6d5574fd9e622e5627" // stateRoot
            hex"3e9768bd0513722b012b99bccc3f9ccbff35302f7ec7d75439178e5a80b45800"; // headerRoot
        return bClaimsCapnProto;
    }

    function exampleBClaimsWithAdditionalData() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"deadbeef"
            hex"beefbeef"
            hex"ffffbeef"
            hex"deadbe"
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // chainId
            hex"02000000" // height
            hex"01000000" // txCount
            hex"00000000" // zero pads for the txCount slot since every capnproto word is 8 bytes
            hex"0d00000002010000" //List(uint8) definition for prevBlock
            hex"1900000002010000" //List(uint8) definition for txRoot
            hex"2500000002010000" //List(uint8) definition for stateRoot
            hex"3100000002010000" //List(uint8) definition for headerRoot
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // headerRoot
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef"
            hex"deadbeefbeefbeefafdeafdeffff0000deadbeefbeefaaaabbbbccccddddeeef";
        return bClaimsCapnProto;
    }

    function exampleBClaimsWithMissingData() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // chainId
            hex"02000000" // height
            hex"01000000" // txCount
            hex"00000000"
            hex"0d000000"
            hex"020100"
            hex"19000000"
            hex"02010000"
            hex"25000000"
            hex"02010000"
            hex"31000000"
            hex"02010000" //48
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c9e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"; // headerRoot
        return bClaimsCapnProto;
    }

    function exampleBClaimsHeight0() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"01000000" // chainId
            hex"00000000" // height
            hex"01000000" // txCount
            hex"00000000" // zero pads for the txCount slot since every capnproto word is 8 bytes
            hex"0d00000002010000" //List(uint8) definition for prevBlock
            hex"1900000002010000" //List(uint8) definition for txRoot
            hex"2500000002010000" //List(uint8) definition for stateRoot
            hex"3100000002010000" //List(uint8) definition for headerRoot
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"; // headerRoot
        return bClaimsCapnProto;
    }

    function exampleBClaimsChainID0() private pure returns(bytes memory) {
        bytes memory bClaimsCapnProto =
            hex"0000000002000400" // struct definition capn proto https://capnproto.org/encoding.html
            hex"00000000" // chainId
            hex"01000000" // height
            hex"01000000" // txCount
            hex"00000000" // zero pads for the txCount slot since every capnproto word is 8 bytes
            hex"0d00000002010000" //List(uint8) definition for prevBlock
            hex"1900000002010000" //List(uint8) definition for txRoot
            hex"2500000002010000" //List(uint8) definition for stateRoot
            hex"3100000002010000" //List(uint8) definition for headerRoot
            hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16" // prevBlock
            hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec" // txRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470" // stateRoot
            hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"; // headerRoot
        return bClaimsCapnProto;
    }

    function assertEqBClaims(BClaimsParserLibrary.BClaims memory actual, BClaimsParserLibrary.BClaims memory expected) internal {
        assertEq(uint256(actual.chainId), uint256(expected.chainId));
        assertEq(uint256(actual.height), uint256(expected.height));
        assertEq(uint256(actual.txCount), uint256(expected.txCount));
        assertEq(actual.prevBlock, expected.prevBlock);
        assertEq(actual.txRoot, expected.txRoot);
        assertEq(actual.stateRoot, expected.stateRoot);
        assertEq(actual.headerRoot, expected.headerRoot);
    }

    function createExpectedBClaims() internal pure returns(BClaimsParserLibrary.BClaims memory){
        return BClaimsParserLibrary.BClaims(
                1,
                2,
                1,
                hex"f75f3eb17cd8136aeb15cca22b01ad5b45c795cb78787e74e55e088a7aa5fa16",
                hex"de8b68a6643fa528a513f99a1ea30379927197a097ca86d9108e4c29d684b1ec",
                hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470",
                hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"
        );
    }

    function createExpectedBClaimsWithTxCount0() internal pure returns(BClaimsParserLibrary.BClaims memory){
        return BClaimsParserLibrary.BClaims(
                1,
                1,
                0,
                hex"41b1a0649752af1b28b3dc29a1556eee781e4a4c3a1f7f53f90fa834de098c4d",
                hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470",
                hex"b58904fe94d4dca4102566c56402dfa153037d18263b3f6d5574fd9e622e5627",
                hex"3e9768bd0513722b012b99bccc3f9ccbff35302f7ec7d75439178e5a80b45800"
        );
    }

    function testGetPointerOffsetAdjustment() public {
        uint16 pointerOffsetAdjustment = BClaimsParserLibrary.getPointerOffsetAdjustment(exampleBClaims(), 4);
        assertTrue(pointerOffsetAdjustment == 0);
        uint16 pointerOffsetAdjustmentWithoutTxCount = BClaimsParserLibrary.getPointerOffsetAdjustment(exampleBClaimsWithTxCount0(), 4);
        assertTrue(pointerOffsetAdjustmentWithoutTxCount == 8);
    }

    function testFail_getPointerOffsetAdjustmentWithDataSectionGreaterThan2() public {
        bytes memory exampleCapnProtoHeader =  hex"0000000003000400";
        BClaimsParserLibrary.getPointerOffsetAdjustment(exampleCapnProtoHeader, 4);
    }

    function testFail_getPointerOffsetAdjustmentWithDataSection0() public {
        bytes memory exampleCapnProtoHeader =  hex"0000000000000400";
        BClaimsParserLibrary.getPointerOffsetAdjustment(exampleCapnProtoHeader, 4);
    }

    function testDecodingBClaims() public {
        BClaimsParserLibrary.BClaims memory actual = BClaimsParserLibrary.extractBClaims(exampleBClaims());
        BClaimsParserLibrary.BClaims memory expected = createExpectedBClaims();
        assertEqBClaims(actual, expected);
    }

    function testDecodingBClaimsWithoutTxCount() public {
        BClaimsParserLibrary.BClaims memory actual = BClaimsParserLibrary.extractBClaims(exampleBClaimsWithTxCount0());
        BClaimsParserLibrary.BClaims memory expected = createExpectedBClaimsWithTxCount0();
        assertEqBClaims(actual, expected);
    }

    function testDecodingBClaimsFromArbitraryLocation() public {
        uint256 startGas = gasleft();
        BClaimsParserLibrary.BClaims memory actual = BClaimsParserLibrary.extractInnerBClaims(exampleBClaimsWithAdditionalData(), 23, 0);
        uint256 endGas = gasleft();
        emit log_named_uint("BClaims gas", startGas - endGas);
        BClaimsParserLibrary.BClaims memory expected = createExpectedBClaims();
        assertEqBClaims(actual, expected);
    }

    function testFail_ExtractingBClaimsHeight0() public {
        BClaimsParserLibrary.extractBClaims(exampleBClaimsHeight0());
    }

    function testFail_ExtractingBClaimsChainID0() public {
        BClaimsParserLibrary.extractBClaims(exampleBClaimsChainID0());
    }

    function testFail_ExtractingBClaimsWithOutSideData() public {
        BClaimsParserLibrary.extractInnerBClaims(exampleBClaimsWithAdditionalData(), 10000000000, 0);
    }

    function testFail_ExtractingBClaimsWithOverflow() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        BClaimsParserLibrary.extractInnerBClaims(exampleBClaimsWithAdditionalData(), bigValue, 0);
    }

    function testFail_ExtractingBClaimsWithoutHavingEnoughData() public {
        BClaimsParserLibrary.extractBClaims(exampleBClaimsWithMissingData());
    }
}