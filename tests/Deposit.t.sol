// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "lib/ds-test/test.sol";

import "src/Constants.sol";
import "src/Deposit.sol";
import "src/SafeMath.sol";
import "src/Token.sol";

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

    function testDirectDeposit() public {
        // Make sure plain deposits are good
        assertEq(deposit.depositID(), 1);
        deposit.deposit(5);
        deposit.deposit(5);
        deposit.deposit(5);
        assertEq(deposit.depositID(), 4);
        assertEq(deposit.totalDeposited(), 15);

        // Reduce deposit 3 from 5 -> 4
        deposit.directDeposit(3, msg.sender, 4);
        assertEq(deposit.totalDeposited(), 14);

        // Increase deposit 2 from 5 -> 7
        deposit.directDeposit(2, msg.sender, 7);
        assertEq(deposit.totalDeposited(), 16);

        // Create a brand new deposit 911
        deposit.directDeposit(911, msg.sender, 100);
        assertEq(deposit.totalDeposited(), 116);
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