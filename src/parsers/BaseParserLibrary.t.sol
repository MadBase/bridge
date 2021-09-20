// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./BaseParserLibrary.sol";

contract BaseParserLibraryTest is DSTest {
    function testExtractUInt32() public {
        bytes memory b = hex"01020400";
        uint256 expected = 262657;
        uint32 actual = BaseParserLibrary.extractUInt32(b, 0);
        assertEq(actual, expected);
    }

    function testExtractUInt32WithTrashData() public {
        bytes memory b = hex"01020400deadbeef";
        uint256 expected = 262657;
        uint32 actual = BaseParserLibrary.extractUInt32(b, 0);
        assertEq(actual, expected);
    }

    function testExtractUInt32InArbitraryPosition() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        uint256 expected = 262657;
        uint32 actual = BaseParserLibrary.extractUInt32(b, 4);
        assertEq(actual, expected);
    }

    function testFail_ExtractUInt32OutSideData() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        uint32 actual = BaseParserLibrary.extractUInt32(b, 10000000000);
    }

    function testFail_ExtractUInt32WithOverflow() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        uint32 actual = BaseParserLibrary.extractUInt32(b, bigValue);
    }

    function testFail_ExtractUInt32WithoutEnoughData() public {
        bytes memory b = hex"010204";
        uint32 actual = BaseParserLibrary.extractUInt32(b, 0);
    }

    function testFail_ExtractUInt32FromMiddleWithoutEnoughData() public {
        bytes memory b = hex"01020400";
        uint32 actual = BaseParserLibrary.extractUInt32(b, 4);
    }

    function testExtractUInt16() public {
        bytes memory b = hex"0102";
        uint256 expected = 0x0201;
        uint16 actual = BaseParserLibrary.extractUInt16(b, 0);
        assertEq(actual, expected);
    }

    function testExtractUInt16WithTrashData() public {
        bytes memory b = hex"0102deadbeef";
        uint256 expected = 0x0201;
        uint16 actual = BaseParserLibrary.extractUInt16(b, 0);
        assertEq(actual, expected);
    }

    function testExtractUInt16InArbitraryPosition() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        uint256 expected = 513; //hex 0x0201
        uint16 actual = BaseParserLibrary.extractUInt16(b, 4);
        assertEq(actual, expected);
    }

    function testFail_ExtractUInt16OutSideData() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        uint16 actual = BaseParserLibrary.extractUInt16(b, 10000000000);
    }

    function testFail_ExtractUInt16WithOverflow() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        uint16 actual = BaseParserLibrary.extractUInt16(b, bigValue);
    }

    function testFail_ExtractUInt16WithoutEnoughData() public {
        bytes memory b = hex"01";
        uint16 actual = BaseParserLibrary.extractUInt16(b, 0);
    }

    function testFail_ExtractUInt16FromMiddleWithoutEnoughData() public {
        bytes memory b = hex"beef0102";
        uint16 actual = BaseParserLibrary.extractUInt16(b, 3);
    }

    function testExtractBool() public {
        bytes memory b = hex"01";
        bool actual = BaseParserLibrary.extractBool(b, 0);
        assertTrue(actual);
    }

    function testExtractUBoolWithTrashData() public {
        bytes memory b = hex"0002deadbeef";
        bool actual = BaseParserLibrary.extractBool(b, 0);
        assertTrue(!actual);
    }

    function testExtractBoolInArbitraryPosition() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        bool expected = true;
        bool actual = BaseParserLibrary.extractBool(b, 4);
        assertTrue(actual);
    }

    function testFail_ExtractBoolOutSideData() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        bool actual = BaseParserLibrary.extractBool(b, 10000000000);
    }

    function testFail_ExtractBoolWithOverflow() public {
        bytes memory b = hex"beefdead01020400deadbeef";
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        bool actual = BaseParserLibrary.extractBool(b, bigValue);
    }

    function testFail_ExtractBoolWithoutEnoughData() public {
        bytes memory b = hex"";
        bool actual = BaseParserLibrary.extractBool(b, 0);
    }

    function testFail_ExtractBoolFromMiddleWithoutEnoughData() public {
        bytes memory b = hex"beef0102";
        bool actual = BaseParserLibrary.extractBool(b, 4);
    }

    function testExtractUInt256() public {
        bytes
            memory b = hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        uint256 expected = 0x10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8;
        uint256 actual = BaseParserLibrary.extractUInt256(b, 0);

        assertEq(expected, actual);
    }

    function testExtractUInt256FromBigEndian() public {
        bytes memory b = hex"1000000000000000000000000000000000000000000000000000000000000001"
            hex"0000";
        uint256 expected = 0x0100000000000000000000000000000000000000000000000000000000000010;
        uint256 actual = BaseParserLibrary.extractUInt256FromBigEndian(b, 0);

        assertEq(actual, expected);
    }

    function testExtractUInt256FromBigEndian2() public {
        bytes memory b = hex"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
            hex"0000";
        uint256 expected = 0x1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
        uint256 actual = BaseParserLibrary.extractUInt256FromBigEndian(b, 0);

        assertEq(actual, expected);
    }

    function testReverse() public {
        bytes
            memory b = hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8";
        bytes
            memory expected = hex"d8d6b02811ca34cef0bcbc79cc5dfaf2dc6b8133ea46d552ebfc96f1c2b2d710";
        bytes memory actual = BaseParserLibrary.reverse(b);

        assertEq0(actual, expected);
    }

    function exampleBytesArray() private pure returns (bytes memory b) {
        return
            hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";
    }

    function testExtractBytes() public {
        bytes memory expected = hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f";
        bytes memory actual = BaseParserLibrary.extractBytes(
            exampleBytesArray(),
            32,
            32
        );
        assertEq0(expected, actual);
    }

    function testExtractArbitraryNumberOfBytes() public {
        bytes
            memory expected = hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b3";
        bytes memory actual = BaseParserLibrary.extractBytes(
            exampleBytesArray(),
            32,
            29
        );
        assertEq0(expected, actual);
    }

    function testFail_ExtractBytesOutSideData() public {
        BaseParserLibrary.extractBytes(exampleBytesArray(), 10000000000, 32);
    }

    function testFail_ExtractBytesOutSideData2() public {
        BaseParserLibrary.extractBytes(exampleBytesArray(), 32, 10000000000);
    }

    function testFail_ExtractBytesWithOverflow() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        BaseParserLibrary.extractBytes(exampleBytesArray(), bigValue, 20);
    }

    function testFail_ExtractBytesWithOverflow2() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        BaseParserLibrary.extractBytes(exampleBytesArray(), 20, bigValue);
    }

    function testFail_ExtractBytesWithOverflow3() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        BaseParserLibrary.extractBytes(exampleBytesArray(), bigValue, bigValue);
    }

    function testFail_ExtractBytesWithoutEnoughData() public {
        bytes memory b = hex"deadbeefff00ff00deadbeefdeadbeefff00ff00deadbeef";
        BaseParserLibrary.extractBytes(hex"deadbeefff00ff00deadbeef", 4, 10);
    }

    function test_ExtractBytesFromMiddleWithoutEnoughData() public {
        bytes memory b = hex"deadbeefff00ff00deadbeef";
        BaseParserLibrary.extractBytes(exampleBytesArray(), 6, 8);
    }

    function testExtractBytes32() public {
        bytes memory b = exampleBytesArray();
        bytes32 expected = hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f";
        bytes32 actual = BaseParserLibrary.extractBytes32(b, 32);

        assertEq(expected, actual);
    }

    function testFail_ExtractBytes32OutSideData() public {
        BaseParserLibrary.extractBytes32(exampleBytesArray(), 10000000000);
    }

    function testFail_ExtractBytes32WithOverflow() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        BaseParserLibrary.extractBytes32(exampleBytesArray(), bigValue);
    }

    function test_ExtractBytes32WithoutEnoughData() public {
        bytes memory b = hex"deadbeefff00ff00deadbeefdeadbeefff00ff00deadbeef";
        BaseParserLibrary.extractBytes32(exampleBytesArray(), 4);
    }

    function test_ExtractBytes32FromMiddleWithoutEnoughData() public {
        bytes memory b = hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f";
        BaseParserLibrary.extractBytes32(exampleBytesArray(), 6);
    }

    //todo: Add more fail tests convert uint256
}
