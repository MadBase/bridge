// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./BaseParserLibrary.sol";


contract BaseParserLibraryTest is DSTest {

    function test_extract_uint32() public {
        bytes memory b = hex"01020400";

        uint expected = 262657;
        uint32 actual = BaseParserLibrary.extract_uint32(b, 0);

        assertEq(actual, expected);
    }

    function test_extract_uint256() public {
        bytes memory b =
            hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        uint256 expected = 0xd8d6b02811ca34cef0bcbc79cc5dfaf2dc6b8133ea46d552ebfc96f1c2b2d710;
        uint256 actual = BaseParserLibrary.extract_uint256(b, 0);

        assertEq(actual, expected);
    }

    function test_reverse() public {
        bytes memory b = hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8";
        bytes memory expected = hex"d8d6b02811ca34cef0bcbc79cc5dfaf2dc6b8133ea46d552ebfc96f1c2b2d710";
        bytes memory actual = BaseParserLibrary.reverse(b);

        assertEq0(actual, expected);
    }
    
    function test_extract_bytes() public {
        bytes memory b =
            hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        bytes memory expected = hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f";
        bytes memory actual = BaseParserLibrary.extract_bytes(b, 32, 32);

        assertEq0(actual, expected);
    }

    function test_extract_bytes32() public {
        bytes memory b =
            hex"10d7b2c2f196fceb52d546ea33816bdcf2fa5dcc79bcbcf0ce34ca1128b0d6d8"
            hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f"
            hex"105a55d55c282005a5813480b48ee1efd61046d06b6084bafcf3c10dac57584b"
            hex"0f0bb886f1f1e04bcfa575020e3f47cceb3c11cd5cba496e5aedddc3a04d5b5c";

        bytes32 expected = hex"2d8652a0c5193001a55c0c43b5e0450297d3824a039d924b08d46520b354251f";
        bytes32 actual = BaseParserLibrary.extract_bytes32(b, 32);

        assertEq(actual, expected);
    }

}