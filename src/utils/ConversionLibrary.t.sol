// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "ds-test/test.sol";
import "./ConversionLibrary.sol";


contract ConversionLibraryTest is DSTest {

    function testUInt16ToBytes() public {
        uint16 x = 0xff00;
        bytes memory expected = hex"00ff";
        bytes memory actual = ConversionLibrary.uint16ToBytes(x);

        emit log_named_bytes("expected", expected);
        emit log_named_bytes("actual  ", actual);

        fail();//assertEq(actual, expected);
    }

}
