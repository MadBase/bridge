// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.5.15;

import "ds-test/test.sol";

import "./Constants.sol";
import "./Deposit.sol";
import "./SafeMath.sol";
import "./Token.sol";

contract DepositTest is Constants, DSTest {

    using SafeMath for uint256;

    Deposit deposit;
    Registry reg;
    Token token;

    function setUp() public {
        reg = new Registry();
        token = new Token("UTL", "MadNet Utility");

        reg.register(UTILITY_TOKEN, address(token));

        deposit = new Deposit(reg);
        deposit.reloadRegistry();

        token.approve(address(deposit), 10000);
    }

    function testDeposit() public {
        assertEq(deposit.depositID(), 1);
        deposit.deposit(5);
        assertEq(deposit.depositID(), 2);
    }

    function testDeposit2() public {
        assertEq(deposit.depositID(), 1);
        deposit.deposit(5);
        deposit.deposit(5);
        assertEq(deposit.depositID(), 3);
    }

    function testDeposit3() public {
        assertEq(deposit.depositID(), 1);
        deposit.deposit(5);
        deposit.deposit(5);
        deposit.deposit(5);
        assertEq(deposit.depositID(), 4);
    }

    function testDepositAmount() public {
        deposit.deposit(13);

        uint256 amount;

        amount = deposit.deposits(1);
        assertEq(uint256(amount), 13);
    }

    function testTotalDepositAmount() public {
        assertEq(deposit.depositID(), 1);
        deposit.deposit(13);
        deposit.deposit(13);
        deposit.deposit(13);
        deposit.deposit(13);
        assertEq(deposit.depositID(), 5);

        assertEq(deposit.totalDeposited(), 52);
    }

    function testSafeMath() public {
        uint256 total;
        uint256 num = 13;

        total = total.add(num);
        assertEq(total, 13);

        uint256 num2 = 13;

        total = total.add(num2);
        assertEq(total, 26);
    }
}