// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./MadByte.sol";

contract MadByteTest is DSTest {

    function testUpdateValue() public {

        Governor gov = new DirectGovernance();

        gov.updateValue(2, 4, "value");
    }

}