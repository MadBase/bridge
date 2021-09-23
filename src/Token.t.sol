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
        string memory symbol = "UTL";
        string memory name = "MadNet Utility";
        assertTrue(uToken.symbol() == symbol);
        assertTrue(uToken.name() == name);
        assertTrue(uToken.decimals() == 18);

        symbol = "STK";
        name = "MadNet Staking";
        assertTrue(sToken.symbol() == symbol);
        assertTrue(sToken.name() == name);
        assertTrue(sToken.decimals() == 18);
    }
}
