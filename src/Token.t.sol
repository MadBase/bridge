// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./Token.sol";

contract TokenTest is DSTest {
    Token uToken;
    Token sToken;

    function setUp() public {
        uToken = new Token("UTL", "MadNet Utility");
        sToken = new Token("STK", "MadNet Staking");
    }

    function testInitialization() public {
        assertTrue(uToken.symbol() == "UTL");
        assertTrue(uToken.name() == "MadNet Utility");
        assertTrue(uToken.decimals() == 18);

        assertTrue(sToken.symbol() == "STK");
        assertTrue(sToken.name() == "MadNet Staking");
        assertTrue(sToken.decimals() == 18);
    }
}
