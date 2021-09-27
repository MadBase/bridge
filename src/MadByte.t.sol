// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./MadByte.sol";
import "./Sigmoid.sol";


abstract contract BaseMock {
    MadByte public token;

    function setToken(MadByte _token) public {
        token = _token;
    }

    function transfer(address recipient, uint256 amount) public virtual returns(bool){
        return token.transfer(recipient, amount);
    }
}

contract AdminAccount is BaseMock {
    constructor() {}

    function setMinerStaking(address addr) public {
        token.setMinerStaking(addr);
    }

    function setMadStaking(address addr) public {
        token.setMadStaking(addr);
    }

    function setFoundation(address addr) public {
        token.setFoundation(addr);
    }

    function setMinerSplit(uint256 split) public {
        token.setMinerSplit(split);
    }
}

contract MadStakingAccount is BaseMock, IMagicEthTransfer, MagicValue {
    constructor() {}

    function depositEth(uint8 magic_) override external payable checkMagic(magic_) {

    }
}

contract MinerStakingAccount is BaseMock, IMagicEthTransfer, MagicValue {
    constructor() {}

    function depositEth(uint8 magic_) override external payable checkMagic(magic_) {

    }
}

contract FoundationAccount is BaseMock, IMagicEthTransfer, MagicValue {
    constructor() {}

    function depositEth(uint8 magic_) override external payable checkMagic(magic_) {

    }
}

contract HackerAccountDistributeReEntry is BaseMock, IMagicEthTransfer, MagicValue {

    uint256 public _count = 0;
    constructor() {}

    function doNastyStuff() internal {
        if (_count < 5) {
            token.distribute();
            _count++;
        } else {
            _count = 0;
        }
    }

    function depositEth(uint8 magic_) override external payable checkMagic(magic_) {
        doNastyStuff();
    }
}

contract HackerAccountBurnReEntry is BaseMock, DSTest {

    uint256 public _count = 0;
    constructor() {}

    function doNastyStuffBurn() internal {
        if (_count < 5) {
            _count++;
            emit log_named_uint("Balance Madbytes before calling distribute:", token.balanceOf(address(this)));
            emit log_named_uint("Balance Hacker before calling distribute:", address(this).balance);
            emit log_named_uint("Balance Token before calling distribute:", address(token).balance);
            token.burnTo(address(this), 20_000000000000000000, 0);
            emit log_named_uint("Balance Madbytes after calling distribute:", token.balanceOf(address(this)));
            emit log_named_uint("Balance Hacker after calling distribute:", address(this).balance);
            emit log_named_uint("Balance Token after calling distribute:", address(token).balance);
        } else {
            return;
        }
    }

    receive() external payable{
        doNastyStuffBurn();
    }
}



contract UserAccount is BaseMock {
    constructor() {}

    function transfer(address to, uint256 amount) public override returns(bool) {
        return token.transfer(to, amount);
    }

    function approve(address who, uint256 amount) public returns (bool) {
        return token.approve(who, amount);
    }

    function burn(uint256 amount) public returns (uint256) {
        return token.burn(amount, 0);
    }

    receive() external payable{}
}

contract MadByteTest is DSTest, Sigmoid {

    uint256 constant ONE_MB = 1*10**18;

    // helper functions

    function getFixtureData()
    internal
    returns(
        MadByte token,
        AdminAccount admin,
        MadStakingAccount madStaking,
        MinerStakingAccount minerStaking,
        FoundationAccount foundation
    )
    {
        admin = new AdminAccount();
        madStaking = new MadStakingAccount();
        minerStaking = new MinerStakingAccount();
        foundation = new FoundationAccount();
        token = new MadByte(
            address(admin),
            address(madStaking),
            address(minerStaking),
            address(foundation)
        );

        assertEq(1*10**token.decimals(), ONE_MB);

        admin.setToken(token);
        madStaking.setToken(token);
        minerStaking.setToken(token);
        foundation.setToken(token);
    }

    function newUserAccount(MadByte token) private returns(UserAccount acct) {
        acct = new UserAccount();
        acct.setToken(token);
    }

    // test functions

    function testFail_AdminSetters() public {
        (MadByte token,,,,) = getFixtureData();

        token.setMinerStaking(address(0x0));
        token.setMadStaking(address(0x0));
        token.setFoundation(address(0x0));
    }

    function testAdminSetters() public {
        (,AdminAccount admin,,,) = getFixtureData();

        // todo: validate if 0x0 address should be allowed
        admin.setMinerStaking(address(0x0));
        admin.setMadStaking(address(0x0));
        admin.setFoundation(address(0x0));
        admin.setMinerSplit(100); // 100 = 10%, 1000 = 100%
    }

    function testMint() public {
        (MadByte token,,,,) = getFixtureData();

        uint256 madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25666259041293710500);

        madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25682084669534371500);

        /*for (uint256 i=1 ether; i<100000 ether; i += 1 ether) {
            emit log_named_uint("i", _fx(i));
        }*/

        //fail();
    }

    function testTransfer() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25_666259041293710500);
        token.transfer(address(acct1), 2*ONE_MB);

        uint256 initialBalance1 = token.balanceOf(address(acct1));
        uint256 initialBalance2 = token.balanceOf(address(acct2));

        assertEq(initialBalance1, 2*ONE_MB);
        assertEq(initialBalance2, 0);

        acct1.transfer(address(acct2), ONE_MB);

        uint256 finalBalance1 = token.balanceOf(address(acct1));
        uint256 finalBalance2 = token.balanceOf(address(acct2));

        assertEq(finalBalance1, initialBalance1-ONE_MB);
        assertEq(finalBalance2, initialBalance2+ONE_MB);

        assertEq(finalBalance1, ONE_MB);
        assertEq(finalBalance2, ONE_MB);
    }

    function testFail_TransferFromWithoutAllowance() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25_666259041293710500);
        token.transfer(address(acct1), 2*ONE_MB);

        uint256 initialBalance1 = token.balanceOf(address(acct1));
        uint256 initialBalance2 = token.balanceOf(address(acct2));

        assertEq(initialBalance1, 2*ONE_MB);
        assertEq(initialBalance2, 0);

        token.transferFrom(address(acct1), address(acct2), ONE_MB);

        uint256 finalBalance1 = token.balanceOf(address(acct1));
        uint256 finalBalance2 = token.balanceOf(address(acct2));

        assertEq(finalBalance1, initialBalance1-ONE_MB);
        assertEq(finalBalance2, initialBalance2+ONE_MB);

        assertEq(finalBalance1, ONE_MB);
        assertEq(finalBalance2, ONE_MB);
    }

    function testTransferFrom() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25_666259041293710500);
        token.transfer(address(acct1), 2*ONE_MB);

        uint256 initialBalance1 = token.balanceOf(address(acct1));
        uint256 initialBalance2 = token.balanceOf(address(acct2));

        assertEq(initialBalance1, 2*ONE_MB);
        assertEq(initialBalance2, 0);

        acct1.approve(address(this), ONE_MB);

        token.transferFrom(address(acct1), address(acct2), ONE_MB);

        uint256 finalBalance1 = token.balanceOf(address(acct1));
        uint256 finalBalance2 = token.balanceOf(address(acct2));

        assertEq(finalBalance1, initialBalance1-ONE_MB);
        assertEq(finalBalance2, initialBalance2+ONE_MB);

        assertEq(finalBalance1, ONE_MB);
        assertEq(finalBalance2, ONE_MB);
    }

    function testDistribute() public {
        (
            MadByte token,
            ,
            MadStakingAccount madStaking,
            MinerStakingAccount minerStaking,
            FoundationAccount foundation
        ) = getFixtureData();

        // assert balances
        assertEq(address(madStaking).balance, 0);
        assertEq(address(minerStaking).balance, 0);
        assertEq(address(foundation).balance, 0);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25_666259041293710500);

        (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();

        // assert balances
        assertEq(stakingAmount, 997000000000000000);
        assertEq(minerAmount, 997000000000000000);
        assertEq(foundationAmount, 6000000000000000);

        assertEq(address(madStaking).balance, 997000000000000000);
        assertEq(address(minerStaking).balance, 997000000000000000);
        assertEq(address(foundation).balance, 6000000000000000);
    }

    function testDistribute2() public {
        (
            MadByte token,
            ,
            MadStakingAccount madStaking,
            MinerStakingAccount minerStaking,
            FoundationAccount foundation
        ) = getFixtureData();

        // assert balances
        assertEq(address(madStaking).balance, 0);
        assertEq(address(minerStaking).balance, 0);
        assertEq(address(foundation).balance, 0);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 300 ether}(0);
        assertEq(madBytes, 2647_334933607070027500);

        (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();

        // assert balances
        assertEq(stakingAmount, 99700000000000000000);
        assertEq(minerAmount, 99700000000000000000);
        assertEq(foundationAmount, 600000000000000000);

        assertEq(address(madStaking).balance, 99700000000000000000);
        assertEq(address(minerStaking).balance, 99700000000000000000);
        assertEq(address(foundation).balance, 600000000000000000);
    }

    function testFail_DistributeReEntrant() public {
        (
            MadByte token,
            AdminAccount admin,
            MadStakingAccount madStaking,
            MinerStakingAccount minerStaking,
            FoundationAccount foundation
        ) = getFixtureData();

        HackerAccountDistributeReEntry hacker = new HackerAccountDistributeReEntry();
        hacker.setToken(token);
        admin.setFoundation(address(hacker));
        // assert balances
        assertEq(address(madStaking).balance, 0);
        assertEq(address(minerStaking).balance, 0);
        assertEq(address(foundation).balance, 0);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 300 ether}(0);
        assertEq(madBytes, 2647_334933607070027500);

        (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();
    }

    function test_BurnReEntrant() public {
        (
            MadByte token,
            AdminAccount admin,
            MadStakingAccount madStaking,
            MinerStakingAccount minerStaking,
            FoundationAccount foundation
        ) = getFixtureData();

        HackerAccountBurnReEntry hacker = new HackerAccountBurnReEntry();
        hacker.setToken(token);
        // admin.setFoundation(address(hacker));
        // assert balances
        assertEq(address(madStaking).balance, 0);
        assertEq(address(minerStaking).balance, 0);
        assertEq(address(foundation).balance, 0);

        UserAccount user = newUserAccount(token);
        // bootstrap to have some tokens before minting to other account
        uint256 madBytes = token.mintTo{value: 300 ether}(address(user), 0);
        assertEq(madBytes, 2647_334933607070027500);
        emit log_named_uint("MadNet balance user:", token.balanceOf(address(user)));

        // mint and transfer some tokens to the accounts
        uint256 madBytes2 = token.mintTo{value: 300 ether}(address(hacker), 0);
        assertEq(madBytes2, 2820_709714053816234500);
        // Transferring the excess to get only 100 MD on the hacker account to make checks easier
        hacker.transfer(address(user), 2720_709714053816234500);
        emit log_named_uint("MadNet balance user:", token.balanceOf(address(user)));
        user.burn(2720_709714053816234500);

        uint256 initialMDHackerBalance = token.balanceOf(address(hacker));
        assertEq(initialMDHackerBalance, 100000000000000000000);

        uint256 initialTokenBalance = address(token).balance;
        assertEq(initialTokenBalance, 600000000000000000000);
        uint256 initialHackerBalance = address(hacker).balance;
        assertEq(initialHackerBalance, 0);

        emit log_named_uint("initialTokenBalance", initialTokenBalance);
        emit log_named_uint("initialHackerBalanceETH", initialHackerBalance);
        emit log_named_uint("initialHackerBalanceMadBytes", initialMDHackerBalance);

        // burning with reentrancy 5 times
        uint256 MDburnt = token.burnTo(address(hacker), 20_000000000000000000, 0);

        uint256 finalMDHackerBalance = token.balanceOf(address(hacker));
        assertEq(finalMDHackerBalance, 0);
        uint256 finalTokenBalance = address(token).balance;
        uint256 finalHackerBalance = address(hacker).balance;

        // uint256 madBytes3 = token.mintTo{value: 300 ether}(address(hacker), 0);
        // assertEq(madBytes3, 2647_334933607070027500);
        // hacker.transfer(address(this), 2620_709714053816234500);
        // uint256 initialMDHackerBalance2 = token.balanceOf(address(hacker));
        // assertEq(initialMDHackerBalance2, 200000000000000000000);

        emit log_named_uint("finalTokenBalance", finalTokenBalance);
        emit log_named_uint("finalHackerBalanceETH", finalHackerBalance);
        emit log_named_uint("finalHackerBalanceMadBytes", finalMDHackerBalance);

        //assertEq(finalBalance, finalPoolBalance);
        fail();
    }
}