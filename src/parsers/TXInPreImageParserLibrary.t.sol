// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./BaseParserLibrary.sol";
import "./TXInPreImageParserLibrary.sol";


contract TXInPreImageParserLibraryTest is DSTest {
    
    function createTXInPreImageExample() public returns(bytes memory, TXInPreImageParserLibrary.TXInPreImage memory) {
        // 000000000100010001000000ffffffff01000000020100000000000000000000000000000000000000000000000000000000000000000030
        bytes memory txBinary = hex"00000000"
            hex"01000100"
            hex"01000000" // ChainID
            hex"ffffffff" // ConsumedTxIdx
            hex"01000000"
            hex"02010000"
            hex"0000000000000000000000000000000000000000000000000000000000000030"; // ConsumedTxHash
        
        TXInPreImageParserLibrary.TXInPreImage memory txInPreImage = TXInPreImageParserLibrary.TXInPreImage(
            1,
            0xffffffff,
            hex"0000000000000000000000000000000000000000000000000000000000000030"
        );

        return (txBinary, txInPreImage);
    }

    function assertEqTXInPreImage(TXInPreImageParserLibrary.TXInPreImage memory expected, TXInPreImageParserLibrary.TXInPreImage memory actual) public {
        assertEq(uint256(expected.chainId), uint256(actual.chainId));
        assertEq(uint256(expected.consumedTxIdx), uint256(actual.consumedTxIdx));
        assertEq(expected.consumedTxHash, actual.consumedTxHash);
    }

    function testParser() public {
        bytes memory preImageCapnProto;
        TXInPreImageParserLibrary.TXInPreImage memory expected;
        (preImageCapnProto, expected) = createTXInPreImageExample();

        TXInPreImageParserLibrary.TXInPreImage memory actual = TXInPreImageParserLibrary.extractTXInPreImage(preImageCapnProto);

        assertEqTXInPreImage(expected, actual);
    }
}
