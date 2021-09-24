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

contract UserAccount is BaseMock {
    constructor() {}

    function transfer(address to, uint256 amount) public returns(bool) {
        return token.transfer(to, amount);
    }

    function approve(address who, uint256 amount) public returns (bool) {
        return token.approve(who, amount);
    }
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
    

}