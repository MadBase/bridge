// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./MadByte.sol";


/*
todo:
invariant of mint and burn

ethIn / burn(mint(ethIn)) >= marketSpread;

*/
abstract contract BaseMock {
    MadByte public token;

    function setToken(MadByte _token) public {
        token = _token;
    }

    function transfer(address recipient, uint256 amount) public virtual returns(bool){
        return token.transfer(recipient, amount);
    }

    function burn(uint256 amount) public returns (uint256) {
        return token.burn(amount, 0);
    }

    function approve(address who, uint256 amount) public returns (bool) {
        return token.approve(who, amount);
    }

    function mint(uint256 minMB) payable public returns(uint256) {
        return token.mint{value: msg.value}(minMB);
    }

    receive() external virtual payable{}
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

    function doNastyStuff() internal {
        if (_count < 4) {
            _count++;
            token.burnTo(address(this), 20_000000000000000000, 0);
        } else {
            return;
        }
    }

    receive() external override payable{
        doNastyStuff();
    }
}


contract UserAccount is BaseMock {
    constructor() {}
}

contract MadByteTest is DSTest {

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

    function testFail_noAdminSetMinerStaking() public {
        (MadByte token,,,,) = getFixtureData();
        token.setMinerStaking(address(0x0));
    }

    function testFail_noAdminSetMadStaking() public {
        (MadByte token,,,,) = getFixtureData();
        token.setMadStaking(address(0x0));
    }

    function testFail_noAdminSetFoundation() public {
        (MadByte token,,,,) = getFixtureData();
        token.setFoundation(address(0x0));
    }

    function testFail_noAdminSetMinerSplit() public {
        (MadByte token,,,,) = getFixtureData();
        token.setMinerSplit(100);
    }

    function testAdminSetters() public {
        (,AdminAccount admin,,,) = getFixtureData();

        admin.setMinerStaking(address(0x0));
        admin.setMadStaking(address(0x0));
        admin.setFoundation(address(0x0));
        admin.setMinerSplit(100); // 100 = 10%, 1000 = 100%
    }

    function testMint() public {
        (MadByte token,,,,) = getFixtureData();

        uint256 madBytes = token.mint{value: 4 ether}(0);
        assertEq(madBytes, 863464958034876049000);
        assertEq(token.totalSupply(), madBytes);
        assertEq(address(token).balance, 4 ether);
        assertEq(token.getPoolBalance(), 1 ether);

        uint256 madBytes2 = token.mint{value: 4 ether}(0);
        assertEq(madBytes2, 863287915942434319000);
        assertEq(token.balanceOf(address(this)), madBytes2 + madBytes);
        assertEq(token.totalSupply(), madBytes2 + madBytes);
        assertEq(address(token).balance, 8 ether);
        assertEq(token.getPoolBalance(), 2 ether);

        // todo: fix this once the bonding curve equations are fixed
        // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());
    }

    function testMintWithBillionsOfEthereum() public {
        ( MadByte token, , , , ) = getFixtureData();
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        // Investing trillions of US dollars in ethereum
        uint256 madBytes = token.mint{value: 70_000_000_000 ether}(0);
        assertEq(madBytes, 175_001_207_106_766900832413351500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(address(token).balance, 70_000_000_000 ether);
        assertEq(token.getPoolBalance(), 17500000000000000000000000000);
    }

    function testMintTo() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);
        uint256 madBytes = token.mintTo{value: 4 ether}(address(acct1), 0);
        assertEq(madBytes, 863464958034876049000);
        assertEq(token.balanceOf(address(acct1)), 863464958034876049000);
        assertEq(token.totalSupply(), madBytes);
        assertEq(address(token).balance, 4 ether);
        assertEq(token.getPoolBalance(), 1 ether);

        uint256 madBytes2 = token.mintTo{value: 4 ether}(address(acct2), 0);
        assertEq(madBytes2, 863287915942434319000);
        assertEq(token.balanceOf(address(acct2)), 863287915942434319000);
        assertEq(token.totalSupply(), madBytes + madBytes2);
        assertEq(address(token).balance, 8 ether);
        assertEq(token.getPoolBalance(), 2 ether);
        // todo: fix this once the bonding curve equations are fixed
        // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());
    }

    function testMintToWithBillionsOfEthereum() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount user = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(user).balance, 0 ether);
        // Investing trillions of US dollars in ethereum
        uint256 madBytes = token.mintTo{value: 70_000_000_000 ether}(address(user), 0);
        assertEq(madBytes, 175_001_207_106_766900832413351500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(user)), madBytes);
        assertEq(address(token).balance, 70_000_000_000 ether);
        assertEq(token.getPoolBalance(), 17500000000000000000000000000);
    }

    function testFail_MintToZeroAddress() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);
        token.mintTo{value: 4 ether}(address(0), 0);
    }

    function testFail_MintToBigMinMBQuantity() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);
        token.mintTo{value: 4 ether}(address(acct1), 900*ONE_MB);
    }

    function testTransfer() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 4 ether}(0);
        assertEq(madBytes, 863_464958034876049000);
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

    function testTransferFrom() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 4 ether}(0);
        assertEq(madBytes, 863_464958034876049000);
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

    function testFail_TransferFromWithoutAllowance() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 4 ether}(0);
        assertEq(madBytes, 863_464958034876049000);
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

    function testFail_TransferMoreThanAllowance() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        // mint and transfer some tokens to the accounts
        uint256 madBytes = token.mint{value: 4 ether}(0);
        assertEq(madBytes, 863_464958034876049000);
        token.transfer(address(acct1), 2*ONE_MB);

        uint256 initialBalance1 = token.balanceOf(address(acct1));
        uint256 initialBalance2 = token.balanceOf(address(acct2));

        assertEq(initialBalance1, 2*ONE_MB);
        assertEq(initialBalance2, 0);

        acct1.approve(address(this), ONE_MB/2);
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
        uint256 madBytes = token.mint{value: 4 ether}(0);
        assertEq(863_464958034876049000, madBytes);
        assertEq(token.totalSupply(), madBytes);
        assertEq(address(token).balance, 4 ether);
        assertEq(token.getPoolBalance(), 1 ether);
        // todo: fix this once the bonding curve is right
        // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());

        (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();

        // todo: fix this once the bonding curve is right
        // assertEq(token.EthtoMB(token.getPoolBalance(), token.getPoolBalance()), token.totalSupply());

        // assert balances
        assertEq(stakingAmount, 1495500000000000000);
        assertEq(minerAmount, 1495500000000000000);
        assertEq(foundationAmount, 9000000000000000);

        assertEq(address(madStaking).balance, 1495500000000000000);
        assertEq(address(minerStaking).balance, 1495500000000000000);
        assertEq(address(foundation).balance, 9000000000000000);
        assertEq(address(token).balance, 1 ether);
        assertEq(token.getPoolBalance(), 1 ether);
    }

    function testDistributeWithMoreEthereum() public {
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
        uint256 madBytes = token.mint{value: 400 ether}(0);
        assertEq(madBytes, 85425_578832862009004000);
        assertEq(token.totalSupply(), madBytes);
        assertEq(address(token).balance, 400 ether);
        assertEq(token.getPoolBalance(), 100 ether);

        // todo: fix this once the bonding curve is right
        // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());
        (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();

        // todo: fix this once the bonding curve is right
        // assertEq(token.EthtoMB(token.getPoolBalance(), token.getPoolBalance()), token.totalSupply());

        // assert balances
        assertEq(stakingAmount, 149550000000000000000);
        assertEq(minerAmount, 149550000000000000000);
        assertEq(foundationAmount, 900000000000000000);

        assertEq(address(madStaking).balance, 149550000000000000000);
        assertEq(address(minerStaking).balance, 149550000000000000000);
        assertEq(address(foundation).balance, 900000000000000000);
        assertEq(address(token).balance, 100 ether);
        assertEq(token.getPoolBalance(), 100 ether);
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
        uint256 madBytes = token.mint{value: 400 ether}(0);
        assertEq(madBytes, 85425_578832862009004000);

        (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();
    }

    function testBurn() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount user = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(user).balance, 0 ether);
        uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(user)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        uint256 ethReceived = user.burn(madBytes - 100*ONE_MB);
        assertEq(ethReceived, 9_884198028223574273);
        assertEq(address(user).balance, ethReceived);
        assertEq(token.totalSupply(), 100*ONE_MB);
        assertEq(token.balanceOf(address(user)), 100*ONE_MB);
        assertEq(address(token).balance, 40 ether - ethReceived);
        assertEq(token.getPoolBalance(), 10 ether - ethReceived);
        ethReceived = user.burn(100*ONE_MB);
        assertEq(ethReceived, 10 ether - 9_884198028223574273);
        assertEq(address(user).balance, 10 ether);
        assertEq(address(token).balance, 30 ether);
        assertEq(token.balanceOf(address(user)), 0);
        assertEq(token.totalSupply(), 0);
        assertEq(token.getPoolBalance(), 0);
        token.distribute();
        assertEq(address(token).balance, 0);
    }

    function testFail_BurnMoreThanPossible() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount user = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(user).balance, 0 ether);
        uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(user)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        // trying to burn more than the max supply
        user.burn(madBytes + 100*ONE_MB);
    }

    function testFail_BurnZeroMBTokens() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount user = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(user).balance, 0 ether);
        uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(user)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        user.burn(0);
    }

    function testBurnTo() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount userTo = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(userTo).balance, 0 ether);
        uint256 madBytes = token.mint{value: 40 ether}(0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        uint256 ethReceived = token.burnTo(address(userTo), madBytes - 100*ONE_MB, 0);
        assertEq(ethReceived, 9_884198028223574273);
        assertEq(address(userTo).balance, ethReceived);
        assertEq(token.totalSupply(), 100*ONE_MB);
        assertEq(token.balanceOf(address(this)), 100*ONE_MB);
        assertEq(address(token).balance, 40 ether - ethReceived);
        assertEq(token.getPoolBalance(), 10 ether - ethReceived);
    }

    function testFail_BurnToMoreThanPossible() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount userTo = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(userTo).balance, 0 ether);
        uint256 madBytes = token.mintTo{value: 40 ether}(address(this), 0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        // trying to burn more than the max supply
        token.burnTo(address(userTo), madBytes + 100*ONE_MB, 0);
    }

    function testFail_BurnToZeroMBTokens() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount userTo = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(userTo).balance, 0 ether);
        uint256 madBytes = token.mintTo{value: 40 ether}(address(this), 0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        token.burnTo(address(userTo), 0, 0);
    }

    function testFail_BurnToZeroAddress() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount userTo = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(userTo).balance, 0 ether);
        uint256 madBytes = token.mint{value: 40 ether}(0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        token.burnTo(address(0), madBytes, 0);
    }

    function testFail_BurnWithBigMinEthAmount() public {
        ( MadByte token, , , , ) = getFixtureData();
        UserAccount userTo = newUserAccount(token);
        assertEq(token.totalSupply(), 0);
        assertEq(address(token).balance, 0 ether);
        assertEq(address(userTo).balance, 0 ether);
        uint256 madBytes = token.mintTo{value: 40 ether}(address(this), 0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token.totalSupply(), madBytes);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(address(token).balance, 40 ether);
        assertEq(token.getPoolBalance(), 10 ether);
        // trying to burn more than the max supply
        token.burnTo(address(userTo), 100*ONE_MB, 40 ether);
    }

    function testBurnReEntrant() public {
        ( MadByte token, , , , ) = getFixtureData();
        HackerAccountBurnReEntry hacker = new HackerAccountBurnReEntry();
        hacker.setToken(token);
        // assert balances
        assertEq(token.totalSupply(), 0);

        // mint some tokens to the accounts
        uint256 madBytesHacker = token.mintTo{value: 40 ether}(address(hacker), 0);
        assertEq(madBytesHacker, 8626_650710991812139500);
        assertEq(token.balanceOf(address(hacker)), madBytesHacker);
        // Transferring the excess to get only 100 MD on the hacker account to make checks easier
        hacker.transfer(address(this), madBytesHacker - 100*ONE_MB);
        assertEq(token.balanceOf(address(hacker)), 100*ONE_MB);
        emit log_named_uint("MadNet balance hacker:", token.balanceOf(address(hacker)));

        assertEq(address(token).balance, 40 ether);
        assertEq(address(hacker).balance, 0 ether);

        // burning with reentrancy 5 times
        uint256 ethReceivedHacker = hacker.burn(20*ONE_MB);

        assertEq(token.balanceOf(address(hacker)), 0*ONE_MB);
        assertEq(address(hacker).balance, 116038531362031928);
        emit log_named_uint("Real Hacker Balance ETH", address(hacker).balance);

        // If this check fails it means that the had a reentrancy issue
        assertEq(address(token).balance, 39_883961468637968072);

        //testing a honest user
        ( MadByte token2, , , , ) = getFixtureData();
        assertEq(token2.totalSupply(), 0);
        UserAccount honestUser = newUserAccount(token2);
        uint256 madBytes = token2.mintTo{value: 40 ether}(address(honestUser), 0);
        assertEq(madBytes, 8626_650710991812139500);
        assertEq(token2.balanceOf(address(honestUser)), madBytes);
        // Transferring the excess to get only 100 MD on the hacker account to make checks easier
        honestUser.transfer(address(this), madBytes - 100*ONE_MB);
        assertEq(address(token2).balance, 40 ether);
        assertEq(address(honestUser).balance, 0 ether);
        emit log_named_uint("Initial MadNet balance honestUser:", token2.balanceOf(address(honestUser)));

        uint256 totalBurnt = 0;
        for (uint256 i=0; i<5; i++){
            totalBurnt += honestUser.burn(20*ONE_MB);
        }
        assertEq(token2.balanceOf(address(honestUser)), 0);
        assertEq(address(honestUser).balance, address(hacker).balance);
        assertEq(address(token2).balance, address(token).balance);
        emit log_named_uint("Honest Balance ETH", address(honestUser).balance);
    }

    function testMarketSpreadWithMintAndBurn() public {
        ( MadByte token, , , , ) = getFixtureData();

        UserAccount user = newUserAccount(token);
        uint256 supply = token.totalSupply();
        assertEq(supply, 0);

        // mint
        uint256 mintedTokens = user.mint{value: 40 ether}(0);
        assertEq(mintedTokens, token.balanceOf(address(user)));

        // burn
        uint256 receivedEther = user.burn(mintedTokens);
        assertEq(receivedEther, 10 ether);
    }

    function test_ConversionMBToEthAndEthMB() public {
        ( MadByte token, , , , ) = getFixtureData();
        uint256 amountETH = 400 ether;
        assertEq(token.totalSupply(), 0);
        uint256 temp = amountETH;
        for (uint256 i=0; i<10; i++){
            amountETH = temp + i*(i+1001);
            uint256 madBytes = token.EthtoMB(10 ether, amountETH);
            uint256 madBytesInitial = token.EthtoMB(0, 10 ether);
            assertEq(madBytes+madBytesInitial, token.EthtoMB(0, 10 ether + amountETH));
            emit log_named_uint("madBytes", madBytes);
            //emit log_named_uint("token.totalSupply", token.totalSupply());

            uint256 returnedEth = token.MBtoEth(madBytesInitial+madBytes, madBytes);
            emit log_named_uint("returnedEth", returnedEth);
            emit log_named_uint("AmountETH", amountETH);
            // assertEq(returnedMadBytes, );
        }
            // fp(fx(x)) ~= x//marketSpread
    }

}