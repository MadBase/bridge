// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./BaseParserLibrary.sol";

/// @dev Aux contract to test unit test that must fail!
contract TestsThatMustFail {
    function extractUInt32(bytes memory src, uint256 dataOffset)
        public
        pure
        returns (uint32)
    {
        return BaseParserLibrary.extractUInt32(src, dataOffset);
    }

    function extractBytes(
        bytes memory src,
        uint256 offset,
        uint256 howManyBytes
    ) public pure returns (bytes memory) {
        return BaseParserLibrary.extractBytes(src, offset, howManyBytes);
    }

    function extractBytes32(bytes memory src, uint256 offset) public pure returns (bytes32) {
        return BaseParserLibrary.extractBytes32(src, offset);
    }
}

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

    function testExtractUInt32WithIncorrectData() public {
        // Testing unit tests that must fail
        TestsThatMustFail lib = new TestsThatMustFail();
        bool ok;
        // Trying to read memory outside our data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractUInt32(bytes,uint256)",
                hex"beefdead01020400deadbeef",
                10000000000
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to fail when trying to read data outside its bounds!"
        );

        // Trying to force and overflow to manipulate data
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractUInt32(bytes,uint256)",
                hex"beefdead01020400deadbeef",
                bigValue
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to be fail safe against offset overflow"
        );

        // Trying to decode uint32 without having enough Data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractUInt32(bytes,uint256)",
                hex"010204",
                0
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was not supposed to serialize uint32 if the data is incomplete"
        );

        // Trying to decode uint32 from the middle of the data where the conversion will pass the data size
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractUInt32(bytes,uint256)",
                hex"01020400",
                4
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was not supposed to serialize uint32 if the data is incomplete"
        );
    }

    function testExtractUInt256() public {
        bytes
            memory b = hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        uint256 expected = 0xd8d6b02811ca34cef0bcbc79cc5dfaf2dc6b8133ea46d552ebfc96f1c2b2d710;
        uint256 actual = BaseParserLibrary.extractUInt256(b, 0);

        assertEq(expected, actual);
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

    function testExtractBytesWithIncorrectData() public {
        // Testing unit tests that must fail
        TestsThatMustFail lib = new TestsThatMustFail();
        bool ok;
        // Trying to read memory outside our data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes(bytes,uint256,uint256)",
                exampleBytesArray(),
                10000000000,
                32
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to fail when trying to read data outside its bounds!"
        );

        // Trying to read bytes outside our data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes(bytes,uint256,uint256)",
                exampleBytesArray(),
                32,
                100000000000
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to fail when trying to read bytes outside its bounds!"
        );

        // Trying to force and overflow to manipulate data
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes(bytes,uint256,uint256)",
                exampleBytesArray(),
                bigValue,
                bigValue
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to be fail safe against offset overflow"
        );

        // Trying to force and overflow to manipulate data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes(bytes,uint256,uint256)",
                exampleBytesArray(),
                16,
                bigValue
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to be fail safe against offset overflow"
        );

        // Trying to force and overflow to manipulate data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes(bytes,uint256,uint256)",
                exampleBytesArray(),
                bigValue,
                16
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to be fail safe against offset overflow"
        );

        // Trying to decode bytes without having enough Data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes(bytes,uint256,uint256)",
                hex"deadbeefff00ff00deadbeef",
                4,
                10
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was not supposed to serialize bytes if the data is incomplete"
        );

        // Trying to extract bytes from the middle of the data where the conversion will pass the data size
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes(bytes,uint256,uint256)",
                hex"deadbeefff00ff00deadbeef",
                6,
                8
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was not supposed to serialize bytes if the data is incomplete"
        );
    }

    function testExtractBytes32() public {
        bytes memory b = exampleBytesArray();
        bytes32 expected = hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f";
        bytes32 actual = BaseParserLibrary.extractBytes32(b, 32);

        assertEq(expected, actual);
    }

    function testExtractBytes32WithIncorrectData() public {
        // Testing unit tests that must fail
        TestsThatMustFail lib = new TestsThatMustFail();
        bool ok;
        // Trying to read memory outside our data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes32(bytes,uint256)",
                exampleBytesArray(),
                10000000000
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to fail when trying to read data outside its bounds!"
        );

        // Trying to force and overflow to manipulate data
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes32(bytes,uint256)",
                exampleBytesArray(),
                bigValue
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was supposed to be fail safe against offset overflow"
        );

        // Trying to decode bytes32 without having enough Data
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes32(bytes,uint256)",
                hex"deadbeefff00ff00deadbeefdeadbeefff00ff00deadbeef",
                4
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was not supposed to serialize bytes if the data is incomplete"
        );

        // Trying to extract bytes32 from the middle of the data where the conversion will pass the data size
        (ok, ) = address(lib).delegatecall(
            abi.encodeWithSignature(
                "extractBytes32(bytes,uint256)",
                hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f",
                6
            )
        );
        assertTrue(
            !ok,
            "Function call succeed! The function was not supposed to serialize bytes if the data is incomplete"
        );
    }
}
