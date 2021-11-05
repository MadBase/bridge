// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "lib/ds-test/test.sol";
import "src/parsers/BaseParserLibrary.sol";
import "src/parsers/TXInPreImageParserLibrary.sol";


contract TXInPreImageParserLibraryTest is DSTest {

    function exampleTXInPreImage() public returns(bytes memory) {
        // 000000000100010001000000ffffffff01000000020100000000000000000000000000000000000000000000000000000000000000000030
        bytes memory txBinary = hex"00000000"
            hex"01000100"
            hex"01000000" // ChainID
            hex"ffffffff" // ConsumedTxIdx
            hex"01000000"
            hex"02010000"
            hex"0000000000000000000000000000000000000000000000000000000000000030"; // ConsumedTxHash

        return txBinary;
    }

    function exampleTXInPreImageWithAdditionalData() public returns(bytes memory) {
        // 000000000100010001000000ffffffff01000000020100000000000000000000000000000000000000000000000000000000000000000030
        bytes memory txBinary =
            hex"deadbeef"
            hex"beefde"
            hex"0000000001000100"
            hex"01000000" // ChainID
            hex"ffffffff" // ConsumedTxIdx
            hex"01000000"
            hex"02010000"
            hex"0000000000000000000000000000000000000000000000000000000000000030" // ConsumedTxHash
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000"
            hex"deadbeefffffff0000000beefdeadbeefdeadbeefdeadbeefdeadbeefdead000";

        return txBinary;
    }

    function exampleTXInPreImageChainID0() public returns(bytes memory) {
        // 000000000100010001000000ffffffff01000000020100000000000000000000000000000000000000000000000000000000000000000030
        bytes memory txBinary = hex"00000000"
            hex"01000100"
            hex"00000000" // ChainID
            hex"ffffffff" // ConsumedTxIdx
            hex"01000000"
            hex"02010000"
            hex"0000000000000000000000000000000000000000000000000000000000000030"; // ConsumedTxHash

        return txBinary;
    }

    function exampleTXInPreImageWithMissingData() public returns(bytes memory) {
        // 000000000100010001000000ffffffff01000000020100000000000000000000000000000000000000000000000000000000000000000030
        bytes memory txBinary = hex"00000000"
            hex"01000100"
            hex"01000000" // ChainID
            hex"ffffffff" // ConsumedTxIdx
            hex"01000000"
            hex"02010000"
            hex"000000000000000000000000000000000000000000000000000000000030"; // ConsumedTxHash

        return txBinary;
    }

    function createExpectedTXInPreImage() public returns(TXInPreImageParserLibrary.TXInPreImage memory txInPreImage) {
        txInPreImage = TXInPreImageParserLibrary.TXInPreImage(
            1,
            0xffffffff,
            hex"0000000000000000000000000000000000000000000000000000000000000030"
        );
    }

    function assertEqTXInPreImage(TXInPreImageParserLibrary.TXInPreImage memory expected, TXInPreImageParserLibrary.TXInPreImage memory actual) public {
        assertEq(uint256(expected.chainId), uint256(actual.chainId));
        assertEq(uint256(expected.consumedTxIdx), uint256(actual.consumedTxIdx));
        assertEq(expected.consumedTxHash, actual.consumedTxHash);
    }

    function testExtractingTXInPreImage() public {
        bytes memory preImageCapnProto = exampleTXInPreImage();
        TXInPreImageParserLibrary.TXInPreImage memory expected = createExpectedTXInPreImage();
        TXInPreImageParserLibrary.TXInPreImage memory actual = TXInPreImageParserLibrary.extractTXInPreImage(preImageCapnProto);
        assertEqTXInPreImage(expected, actual);
    }

    function testExtractingTXInPreImageFromArbitraryLocation() public {
        TXInPreImageParserLibrary.TXInPreImage memory actual = TXInPreImageParserLibrary.extractInnerTXInPreImage(exampleTXInPreImageWithAdditionalData(), 15);
        TXInPreImageParserLibrary.TXInPreImage memory expected = createExpectedTXInPreImage();
        assertEqTXInPreImage(actual, expected);
    }

    function testFail_ExtractingTXInPreImageChainID0() public {
        TXInPreImageParserLibrary.extractTXInPreImage(exampleTXInPreImageChainID0());
    }

    function testFail_ExtractingTXInPreImageWithOutSideData() public {
        TXInPreImageParserLibrary.extractInnerTXInPreImage(exampleTXInPreImageWithAdditionalData(), 10000000000);
    }

    function testFail_ExtractingTXInPreImageWithOverflow() public {
        uint256 bigValue = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        TXInPreImageParserLibrary.extractInnerTXInPreImage(exampleTXInPreImageWithAdditionalData(), bigValue);
    }

    function testFail_ExtractingTXInPreImageWithoutHavingEnoughData() public {
        TXInPreImageParserLibrary.extractInnerTXInPreImage(exampleTXInPreImageWithMissingData(), TXInPreImageParserLibrary.CAPNPROTO_HEADER_SIZE);
    }
}
