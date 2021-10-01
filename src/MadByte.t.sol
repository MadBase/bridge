// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./MadByte.sol";


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

contract TokenPure {
    MadByte public token;
    uint256 public poolBalance;
    uint256 public totalSupply;

    event log_named_uint(string key, uint256 val);

    function log(string memory name, uint256 value) internal{
        emit log_named_uint(name, value);
    }

    constructor() {
        AdminAccount admin = new AdminAccount();
        MadStakingAccount madStaking = new MadStakingAccount();
        MinerStakingAccount minerStaking = new MinerStakingAccount();
        FoundationAccount foundation = new FoundationAccount();
        token = new MadByte(
            address(admin),
            address(madStaking),
            address(minerStaking),
            address(foundation)
        );
        admin.setToken(token);
        madStaking.setToken(token);
        minerStaking.setToken(token);
        foundation.setToken(token);
    }

    function mint(uint256 amountETH) public returns(uint256 madBytes){
        madBytes = token.EthtoMB(poolBalance, amountETH);
        poolBalance += amountETH;
        totalSupply += madBytes;
    }

    function burn(uint256 amountMB) public returns (uint256 returnedEth){
        require(totalSupply>= amountMB, "Underflow: totalSupply < amountMB");
        returnedEth = token.MBtoEth(poolBalance, totalSupply, amountMB);
        require(poolBalance>= returnedEth, "Underflow: poolBalance < returnedEth");
        log("TokenPure: poolBalance      ", poolBalance);
        log("TokenPure: returnedEth      ", returnedEth);
        poolBalance -= returnedEth;
        log("TokenPure: totalSupply      ", totalSupply);
        log("TokenPure: amountMB         ", amountMB);
        totalSupply -= amountMB;
        log("TokenPure: totalSupply After", totalSupply);
    }
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

    // function testMint() public {
    //     (MadByte token,,,,) = getFixtureData();

    //     uint256 madBytes = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes, 863464958034876049000);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 4 ether);
    //     assertEq(token.getPoolBalance(), 1 ether);

    //     uint256 madBytes2 = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes2, 863287915942434319000);
    //     assertEq(token.balanceOf(address(this)), madBytes2 + madBytes);
    //     assertEq(token.totalSupply(), madBytes2 + madBytes);
    //     assertEq(address(token).balance, 8 ether);
    //     assertEq(token.getPoolBalance(), 2 ether);

    //     // todo: fix this once the bonding curve equations are fixed
    //     // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());
    // }

    // function testMintWithBillionsOfEthereum() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     // Investing trillions of US dollars in ethereum
    //     uint256 madBytes = token.mint{value: 70_000_000_000 ether}(0);
    //     assertEq(madBytes, 175_001_207_106_766900832413351500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 70_000_000_000 ether);
    //     assertEq(token.getPoolBalance(), 17500000000000000000000000000);
    // }

    // function testMintTo() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     UserAccount acct1 = newUserAccount(token);
    //     UserAccount acct2 = newUserAccount(token);
    //     uint256 madBytes = token.mintTo{value: 4 ether}(address(acct1), 0);
    //     assertEq(madBytes, 863464958034876049000);
    //     assertEq(token.balanceOf(address(acct1)), 863464958034876049000);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 4 ether);
    //     assertEq(token.getPoolBalance(), 1 ether);

    //     uint256 madBytes2 = token.mintTo{value: 4 ether}(address(acct2), 0);
    //     assertEq(madBytes2, 863287915942434319000);
    //     assertEq(token.balanceOf(address(acct2)), 863287915942434319000);
    //     assertEq(token.totalSupply(), madBytes + madBytes2);
    //     assertEq(address(token).balance, 8 ether);
    //     assertEq(token.getPoolBalance(), 2 ether);
    //     // todo: fix this once the bonding curve equations are fixed
    //     // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());
    // }

    // function testMintToWithBillionsOfEthereum() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     // Investing trillions of US dollars in ethereum
    //     uint256 madBytes = token.mintTo{value: 70_000_000_000 ether}(address(user), 0);
    //     assertEq(madBytes, 175_001_207_106_766900832413351500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(user)), madBytes);
    //     assertEq(address(token).balance, 70_000_000_000 ether);
    //     assertEq(token.getPoolBalance(), 17500000000000000000000000000);
    // }

    // function testFail_MintToZeroAddress() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     UserAccount acct1 = newUserAccount(token);
    //     UserAccount acct2 = newUserAccount(token);
    //     token.mintTo{value: 4 ether}(address(0), 0);
    // }

    // function testFail_MintToBigMinMBQuantity() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     UserAccount acct1 = newUserAccount(token);
    //     UserAccount acct2 = newUserAccount(token);
    //     token.mintTo{value: 4 ether}(address(acct1), 900*ONE_MB);
    // }

    // function testTransfer() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     UserAccount acct1 = newUserAccount(token);
    //     UserAccount acct2 = newUserAccount(token);

    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes, 863_464958034876049000);
    //     token.transfer(address(acct1), 2*ONE_MB);

    //     uint256 initialBalance1 = token.balanceOf(address(acct1));
    //     uint256 initialBalance2 = token.balanceOf(address(acct2));

    //     assertEq(initialBalance1, 2*ONE_MB);
    //     assertEq(initialBalance2, 0);

    //     acct1.transfer(address(acct2), ONE_MB);

    //     uint256 finalBalance1 = token.balanceOf(address(acct1));
    //     uint256 finalBalance2 = token.balanceOf(address(acct2));

    //     assertEq(finalBalance1, initialBalance1-ONE_MB);
    //     assertEq(finalBalance2, initialBalance2+ONE_MB);

    //     assertEq(finalBalance1, ONE_MB);
    //     assertEq(finalBalance2, ONE_MB);
    // }

    // function testTransferFrom() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     UserAccount acct1 = newUserAccount(token);
    //     UserAccount acct2 = newUserAccount(token);

    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes, 863_464958034876049000);
    //     token.transfer(address(acct1), 2*ONE_MB);

    //     uint256 initialBalance1 = token.balanceOf(address(acct1));
    //     uint256 initialBalance2 = token.balanceOf(address(acct2));

    //     assertEq(initialBalance1, 2*ONE_MB);
    //     assertEq(initialBalance2, 0);

    //     acct1.approve(address(this), ONE_MB);

    //     token.transferFrom(address(acct1), address(acct2), ONE_MB);

    //     uint256 finalBalance1 = token.balanceOf(address(acct1));
    //     uint256 finalBalance2 = token.balanceOf(address(acct2));

    //     assertEq(finalBalance1, initialBalance1-ONE_MB);
    //     assertEq(finalBalance2, initialBalance2+ONE_MB);

    //     assertEq(finalBalance1, ONE_MB);
    //     assertEq(finalBalance2, ONE_MB);
    // }

    // function testFail_TransferFromWithoutAllowance() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     UserAccount acct1 = newUserAccount(token);
    //     UserAccount acct2 = newUserAccount(token);

    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes, 863_464958034876049000);
    //     token.transfer(address(acct1), 2*ONE_MB);

    //     uint256 initialBalance1 = token.balanceOf(address(acct1));
    //     uint256 initialBalance2 = token.balanceOf(address(acct2));

    //     assertEq(initialBalance1, 2*ONE_MB);
    //     assertEq(initialBalance2, 0);

    //     token.transferFrom(address(acct1), address(acct2), ONE_MB);

    //     uint256 finalBalance1 = token.balanceOf(address(acct1));
    //     uint256 finalBalance2 = token.balanceOf(address(acct2));

    //     assertEq(finalBalance1, initialBalance1-ONE_MB);
    //     assertEq(finalBalance2, initialBalance2+ONE_MB);

    //     assertEq(finalBalance1, ONE_MB);
    //     assertEq(finalBalance2, ONE_MB);
    // }

    // function testFail_TransferMoreThanAllowance() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     UserAccount acct1 = newUserAccount(token);
    //     UserAccount acct2 = newUserAccount(token);

    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes, 863_464958034876049000);
    //     token.transfer(address(acct1), 2*ONE_MB);

    //     uint256 initialBalance1 = token.balanceOf(address(acct1));
    //     uint256 initialBalance2 = token.balanceOf(address(acct2));

    //     assertEq(initialBalance1, 2*ONE_MB);
    //     assertEq(initialBalance2, 0);

    //     acct1.approve(address(this), ONE_MB/2);
    //     token.transferFrom(address(acct1), address(acct2), ONE_MB);

    //     uint256 finalBalance1 = token.balanceOf(address(acct1));
    //     uint256 finalBalance2 = token.balanceOf(address(acct2));

    //     assertEq(finalBalance1, initialBalance1-ONE_MB);
    //     assertEq(finalBalance2, initialBalance2+ONE_MB);

    //     assertEq(finalBalance1, ONE_MB);
    //     assertEq(finalBalance2, ONE_MB);
    // }

    // function testDistribute() public {
    //     (
    //         MadByte token,
    //         ,
    //         MadStakingAccount madStaking,
    //         MinerStakingAccount minerStaking,
    //         FoundationAccount foundation
    //     ) = getFixtureData();

    //     // assert balances
    //     assertEq(address(madStaking).balance, 0);
    //     assertEq(address(minerStaking).balance, 0);
    //     assertEq(address(foundation).balance, 0);

    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 4 ether}(0);
    //     assertEq(863_464958034876049000, madBytes);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 4 ether);
    //     assertEq(token.getPoolBalance(), 1 ether);
    //     // todo: fix this once the bonding curve is right
    //     // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());

    //     (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();

    //     // todo: fix this once the bonding curve is right
    //     // assertEq(token.EthtoMB(token.getPoolBalance(), token.getPoolBalance()), token.totalSupply());

    //     // assert balances
    //     assertEq(stakingAmount, 1495500000000000000);
    //     assertEq(minerAmount, 1495500000000000000);
    //     assertEq(foundationAmount, 9000000000000000);

    //     assertEq(address(madStaking).balance, 1495500000000000000);
    //     assertEq(address(minerStaking).balance, 1495500000000000000);
    //     assertEq(address(foundation).balance, 9000000000000000);
    //     assertEq(address(token).balance, 1 ether);
    //     assertEq(token.getPoolBalance(), 1 ether);
    // }

    // function testDistributeWithMoreEthereum() public {
    //     (
    //         MadByte token,
    //         ,
    //         MadStakingAccount madStaking,
    //         MinerStakingAccount minerStaking,
    //         FoundationAccount foundation
    //     ) = getFixtureData();

    //     // assert balances
    //     assertEq(address(madStaking).balance, 0);
    //     assertEq(address(minerStaking).balance, 0);
    //     assertEq(address(foundation).balance, 0);

    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 400 ether}(0);
    //     assertEq(madBytes, 85425_578832862009004000);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 400 ether);
    //     assertEq(token.getPoolBalance(), 100 ether);

    //     // todo: fix this once the bonding curve is right
    //     // assertEq(token.EthtoMB(token.getPoolBalance(), 1 ether), token.totalSupply());
    //     (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();

    //     // todo: fix this once the bonding curve is right
    //     // assertEq(token.EthtoMB(token.getPoolBalance(), token.getPoolBalance()), token.totalSupply());

    //     // assert balances
    //     assertEq(stakingAmount, 149550000000000000000);
    //     assertEq(minerAmount, 149550000000000000000);
    //     assertEq(foundationAmount, 900000000000000000);

    //     assertEq(address(madStaking).balance, 149550000000000000000);
    //     assertEq(address(minerStaking).balance, 149550000000000000000);
    //     assertEq(address(foundation).balance, 900000000000000000);
    //     assertEq(address(token).balance, 100 ether);
    //     assertEq(token.getPoolBalance(), 100 ether);
    // }

    // function testFail_DistributeReEntrant() public {
    //     (
    //         MadByte token,
    //         AdminAccount admin,
    //         MadStakingAccount madStaking,
    //         MinerStakingAccount minerStaking,
    //         FoundationAccount foundation
    //     ) = getFixtureData();

    //     HackerAccountDistributeReEntry hacker = new HackerAccountDistributeReEntry();
    //     hacker.setToken(token);
    //     admin.setFoundation(address(hacker));
    //     // assert balances
    //     assertEq(address(madStaking).balance, 0);
    //     assertEq(address(minerStaking).balance, 0);
    //     assertEq(address(foundation).balance, 0);

    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 400 ether}(0);
    //     assertEq(madBytes, 85425_578832862009004000);

    //     (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();
    // }

    // function testBurn() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(user)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     uint256 ethReceived = user.burn(madBytes - 100*ONE_MB);
    //     assertEq(ethReceived, 9_884198028223574273);
    //     assertEq(address(user).balance, ethReceived);
    //     assertEq(token.totalSupply(), 100*ONE_MB);
    //     assertEq(token.balanceOf(address(user)), 100*ONE_MB);
    //     assertEq(address(token).balance, 40 ether - ethReceived);
    //     assertEq(token.getPoolBalance(), 10 ether - ethReceived);
    //     ethReceived = user.burn(100*ONE_MB);
    //     assertEq(ethReceived, 10 ether - 9_884198028223574273);
    //     assertEq(address(user).balance, 10 ether);
    //     assertEq(address(token).balance, 30 ether);
    //     assertEq(token.balanceOf(address(user)), 0);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(token.getPoolBalance(), 0);
    //     token.distribute();
    //     assertEq(address(token).balance, 0);
    // }

    // /* function testBurnBillionsOfMadBytes() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     // Investing trillions of US dollars in ethereum
    //     uint256 madBytes = token.mintTo{value: 70_000_000_000 ether}(address(this), 0);
    //     // assertEq(madBytes, 175_001_207_106_766900832413351500);
    //     // assertEq(token.totalSupply(), madBytes);
    //     // assertEq(token.balanceOf(address(this)), madBytes);
    //     // assertEq(address(token).balance, 70_000_000_000 ether);
    //     // assertEq(token.getPoolBalance(), 17500000000000000000000000000);
    //     uint256 ethReceived = token.burnTo(address(user), madBytes, 0);
    // } */

    // function testFail_BurnMoreThanPossible() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(user)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     // trying to burn more than the max supply
    //     user.burn(madBytes + 100*ONE_MB);
    // }

    // function testFail_BurnZeroMBTokens() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(user)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     user.burn(0);
    // }

    // function testBurnTo() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount userTo = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(userTo).balance, 0 ether);
    //     uint256 madBytes = token.mint{value: 40 ether}(0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     uint256 ethReceived = token.burnTo(address(userTo), madBytes - 100*ONE_MB, 0);
    //     assertEq(ethReceived, 9_884198028223574273);
    //     assertEq(address(userTo).balance, ethReceived);
    //     assertEq(token.totalSupply(), 100*ONE_MB);
    //     assertEq(token.balanceOf(address(this)), 100*ONE_MB);
    //     assertEq(address(token).balance, 40 ether - ethReceived);
    //     assertEq(token.getPoolBalance(), 10 ether - ethReceived);
    // }

    // function testFail_BurnToMoreThanPossible() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount userTo = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(userTo).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(this), 0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     // trying to burn more than the max supply
    //     token.burnTo(address(userTo), madBytes + 100*ONE_MB, 0);
    // }

    // function testFail_BurnToZeroMBTokens() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount userTo = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(userTo).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(this), 0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     token.burnTo(address(userTo), 0, 0);
    // }

    // function testFail_BurnToZeroAddress() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount userTo = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(userTo).balance, 0 ether);
    //     uint256 madBytes = token.mint{value: 40 ether}(0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     token.burnTo(address(0), madBytes, 0);
    // }

    // function testFail_BurnWithBigMinEthAmount() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount userTo = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(userTo).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(this), 0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     // trying to burn more than the max supply
    //     token.burnTo(address(userTo), 100*ONE_MB, 40 ether);
    // }

    // function testBurnReEntrant() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     HackerAccountBurnReEntry hacker = new HackerAccountBurnReEntry();
    //     hacker.setToken(token);
    //     // assert balances
    //     assertEq(token.totalSupply(), 0);

    //     // mint some tokens to the accounts
    //     uint256 madBytesHacker = token.mintTo{value: 40 ether}(address(hacker), 0);
    //     assertEq(madBytesHacker, 8626_650710991812139500);
    //     assertEq(token.balanceOf(address(hacker)), madBytesHacker);
    //     // Transferring the excess to get only 100 MD on the hacker account to make checks easier
    //     hacker.transfer(address(this), madBytesHacker - 100*ONE_MB);
    //     assertEq(token.balanceOf(address(hacker)), 100*ONE_MB);
    //     emit log_named_uint("MadNet balance hacker:", token.balanceOf(address(hacker)));

    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(address(hacker).balance, 0 ether);

    //     // burning with reentrancy 5 times
    //     uint256 ethReceivedHacker = hacker.burn(20*ONE_MB);

    //     assertEq(token.balanceOf(address(hacker)), 0*ONE_MB);
    //     assertEq(address(hacker).balance, 116038531362031928);
    //     emit log_named_uint("Real Hacker Balance ETH", address(hacker).balance);

    //     // If this check fails it means that the had a reentrancy issue
    //     assertEq(address(token).balance, 39_883961468637968072);

    //     //testing a honest user
    //     ( MadByte token2, , , , ) = getFixtureData();
    //     assertEq(token2.totalSupply(), 0);
    //     UserAccount honestUser = newUserAccount(token2);
    //     uint256 madBytes = token2.mintTo{value: 40 ether}(address(honestUser), 0);
    //     assertEq(madBytes, 8626_650710991812139500);
    //     assertEq(token2.balanceOf(address(honestUser)), madBytes);
    //     // Transferring the excess to get only 100 MD on the hacker account to make checks easier
    //     honestUser.transfer(address(this), madBytes - 100*ONE_MB);
    //     assertEq(address(token2).balance, 40 ether);
    //     assertEq(address(honestUser).balance, 0 ether);
    //     emit log_named_uint("Initial MadNet balance honestUser:", token2.balanceOf(address(honestUser)));

    //     uint256 totalBurnt = 0;
    //     for (uint256 i=0; i<5; i++){
    //         totalBurnt += honestUser.burn(20*ONE_MB);
    //     }
    //     assertEq(token2.balanceOf(address(honestUser)), 0);
    //     assertEq(address(honestUser).balance, address(hacker).balance);
    //     assertEq(address(token2).balance, address(token).balance);
    //     emit log_named_uint("Honest Balance ETH", address(honestUser).balance);
    // }

    // function testMarketSpreadWithMintAndBurn() public {
    //     ( MadByte token, , , , ) = getFixtureData();

    //     UserAccount user = newUserAccount(token);
    //     uint256 supply = token.totalSupply();
    //     assertEq(supply, 0);

    //     // mint
    //     uint256 mintedTokens = user.mint{value: 40 ether}(0);
    //     assertEq(mintedTokens, token.balanceOf(address(user)));

    //     // burn
    //     uint256 receivedEther = user.burn(mintedTokens);
    //     assertEq(receivedEther, 10 ether);
    // }

    function test_ConversionMBToEthAndEthMB2() public {
        TokenPure token = new TokenPure();
        uint256 amountETH = 2_000_000;
        token.mint(amountETH);
        uint256 madBytes = token.mint(amountETH);

        uint256 maxIt = 100;
        uint256 cumulativeMBBurned = 0;
        uint256 cumulativeMBMinted = 0;
        uint256 cumulativeETHBurned = 0;
        uint256 cumulativeETHMinted = 0;
        uint256 amountBurned = madBytes/maxIt;
        uint256 amountMinted = 1;
        for (uint256 i=0; i<maxIt; i++) {
            cumulativeETHBurned += token.burn(amountBurned);
            cumulativeMBBurned += amountBurned;
            cumulativeMBMinted += token.mint(amountMinted);
            cumulativeETHMinted += amountMinted;
        }

        TokenPure token2 = new TokenPure();
        token2.mint(amountETH);
        token2.mint(amountETH);
        uint256 burnedMBDiff = cumulativeMBBurned-cumulativeMBMinted;
        uint256 burnedETH2 = token2.burn(burnedMBDiff);

        emit log("=======================================================");
        emit log_named_uint("amountMinted ETH   ", amountMinted);
        emit log_named_uint("amountBurned       ", amountBurned);
        emit log_named_uint("cumulativeMBBurned ", cumulativeMBBurned);
        emit log_named_uint("cumulativeMBMinted ", cumulativeMBMinted);
        emit log_named_uint("cumulativeETHBurned", cumulativeETHBurned);
        emit log_named_uint("cumulativeETHMinted", cumulativeETHMinted);
        emit log_named_uint("Diff MB after loop ", burnedMBDiff);
        emit log_named_uint("ETH burned token2  ", burnedETH2);
        emit log_named_uint("Token1 Balance:    ", token.poolBalance());
        emit log_named_uint("Token2 Balance:    ", token2.poolBalance());
        //fail();
    }

    function test_ConversionMBToEthAndEthMB3(/* uint96 amountETH */) public {
        TokenPure token = new TokenPure();
        uint256 amountETH = 0xa89984770802767127/* 2287_987654321987654311 */;
        token.mint(amountETH);

        uint256 maxIt = 10;
        uint256 cumulativeMBBurned = 0;
        uint256 cumulativeMBMinted = 0;
        uint256 cumulativeETHBurned = 0;
        uint256 cumulativeETHMinted = 0;
        uint256 countUser = 0;
        uint256 countPool = 0;
        uint256 amountMinted = amountETH/maxIt;
        for (uint256 i=0; i<maxIt; i++) {
            emit log("Minting");
            uint256 MBMinted = token.mint(amountMinted);
            cumulativeMBMinted += MBMinted;
            cumulativeETHMinted += amountMinted;
            emit log("Burning");
            uint256 ETHBurned = token.burn(MBMinted);
            cumulativeETHBurned += ETHBurned;
            cumulativeMBBurned += MBMinted;
            emit log("Updating counters");
            if (ETHBurned > amountMinted) {
                countUser++;
            } else {
                countPool++;
            }
        }
        assertEq(countUser, 0);
        TokenPure token2 = new TokenPure();
        token2.mint(amountETH);

        emit log("=======================================================");
        emit log_named_uint("amountMinted ETH   ", amountMinted);
        emit log_named_uint("cumulativeMBBurned ", cumulativeMBBurned);
        emit log_named_uint("cumulativeMBMinted ", cumulativeMBMinted);
        emit log_named_uint("cumulativeETHBurned", cumulativeETHBurned);
        emit log_named_uint("cumulativeETHMinted", cumulativeETHMinted);
        emit log_named_uint("countUser          ", countUser);
        emit log_named_uint("countPool          ", countPool);
        emit log_named_uint("Token1 Balance     ", token.poolBalance());
        emit log_named_uint("Token2 Balance     ", token2.poolBalance());
    }

    // function test_ConversionMBToEthAndEthMB() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     // 2000, 10000, 700_000_000
    //     // 79083974178645291203200560051632892360767082149044608353057640485045702118670
    //     // 79228162514264337593543950335
    //     uint256 amountETH = 2_000_000 ether; //2**122;
    //     assertEq(token.totalSupply(), 0);
    //     //Mining the first amount of MB
    //    // uint256 initialValue = amountETH;
    //     uint256 madBytesInitial = token.EthtoMB(0, amountETH);
    //     uint256 poolBalance = amountETH;
    //     uint256 totalSupply = madBytesInitial;
    //     //Mining the desired amount of MB
    //     uint256 madBytes = token.EthtoMB(poolBalance, amountETH);
    //     poolBalance += amountETH;
    //     totalSupply += madBytes;
    //     assertEq(madBytes+madBytesInitial, totalSupply);
    //     //Checking if generating the tokens from scrath yields the sum of
    //     //the MB generated in the steps above
    //     assertEq(totalSupply, token.EthtoMB(0, poolBalance));
    //     emit log_named_uint("madBytesInitial", madBytesInitial);
    //     emit log_named_uint("madBytes   ", madBytes);
    //     emit log_named_uint("Total Supply", totalSupply);
    //     emit log_named_uint("Pool Balance", poolBalance);
    //     emit log_named_uint("Invested amount", amountETH);
    //     // Simulating the burn
    //     // uint256 returnedEth = token.MBtoEth(poolBalance, totalSupply, madBytes);
    //     // if (amountETH >= returnedEth) {
    //     //     emit log_named_uint("Error", amountETH - returnedEth);
    //     //     assertTrue(amountETH - returnedEth < 100);
    //     // } else {
    //     //     emit log_named_uint("Error", returnedEth - amountETH);
    //     //     assertTrue(returnedEth - amountETH < 100);
    //     // }
    //     // poolBalance -= returnedEth;
    //     // totalSupply -= madBytes;
    //     emit log("=================");
    //     // emit log_named_uint("returnedEthMadBytes", returnedEth);
    //     emit log_named_uint("Pool Balance", poolBalance);
    //     // assertEq(returnedEth, amountETH); //todo: check it has to be less or equal.Result now is greater or equal!
    //     // assertEq(poolBalance, 10 ether); //todo: check it has to be greater or equal.Result now is less or equal!
    //     uint256 cummulativeMBBurned = 0;
    //     uint256 cummulativeMBMinted = 0;
    //     uint256 cummulativeETHBurned = 0;
    //     uint256 cummulativeETHMinted = 0;
    //     uint256 maxItt = 100;
    //     uint256 poolBalance2 = poolBalance;
    //     uint256 totalSupply2 = totalSupply;
    //     for (uint256 i=0; i<maxItt-1; i++) {
    //         uint256 madBytes2 = token.EthtoMB(poolBalance, 1 ether);
    //         poolBalance2 += 1 ether;
    //         cummulativeETHMinted += 1 ether;
    //         totalSupply2 += madBytes2;
    //         cummulativeMBMinted += madBytes2;

    //         uint256 returnedEth2 = token.MBtoEth(poolBalance2, totalSupply2, madBytes/maxItt);
    //         cummulativeETHBurned += returnedEth2;
    //         cummulativeMBBurned += madBytes/maxItt;
    //         poolBalance2 -= returnedEth2;
    //         totalSupply2 -= madBytes/maxItt;
    //     }
    //     //uint256 returnedLeftOver =token.MBtoEth(poolBalance2, totalSupply2, madBytes - cummulativeMBBurned);
    //     //emit log_named_uint("LeftOverETH", returnedLeftOver);
    //     //assertEq(cummulativeMBBurned, madBytes);
    //     poolBalance2 -= token.MBtoEth(poolBalance2, totalSupply2, cummulativeMBMinted);
    //     totalSupply2 -= cummulativeMBMinted;
    //     emit log_named_uint("Pool Balance 2 Before", poolBalance2);
    //     emit log("===========");
    //     uint256 returnedEth = token.MBtoEth(poolBalance +  cummulativeETHMinted - cummulativeETHBurned, totalSupply + cummulativeMBMinted - cummulativeMBBurned, cummulativeMBBurned);
    //     emit log("===========");
    //     poolBalance -= returnedEth;
    //     totalSupply -= madBytes;
    //     //emit log_named_uint("Error pool", returnedEth);
    //     if (poolBalance2 >= poolBalance) {
    //         emit log_named_uint("Pool Balance", poolBalance);
    //         emit log_named_uint("Pool Balance 2", poolBalance2);
    //         emit log_named_uint("Error2", poolBalance2 - poolBalance);
    //         assertTrue(poolBalance2 - poolBalance < 450);
    //     } else {
    //         emit log_named_uint("Error1", poolBalance - poolBalance2);
    //         assertTrue(poolBalance - poolBalance2 < 450);
    //     }

    //     // // emit log_named_uint("Error pool", returnedEth);
    //     // returnedEth = token.MBtoEth(poolBalance, totalSupply, totalSupply);
    //     // // assertTrue(amountETH - returnedEth < 10);
    //     // poolBalance -= returnedEth;
    //     // totalSupply -= madBytesInitial;
    //     // assertEq(totalSupply, 0);
    //     // assertEq(poolBalance, 0);
    //     // assertEq(returnedEth, 10 ether); //todo: check this. The last person to withdrawl is getting less ETH.
    //     // assertEq(poolBalance, 0);
    //     emit log_named_uint("returnedEthInitialMadBytes", returnedEth);
    //     emit log_named_uint("final Pool Balance", poolBalance);
    //     emit log_named_uint("final totalSupply", totalSupply);
    //     fail();
    // }

    // function testInvariantHold() public {
    //     /*
    //     tests if the invariant holds with mint and burn:
    //     ethIn / burn(mint(ethIn)) >= marketSpread;
    //     */

    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     UserAccount user2 = newUserAccount(token);

    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
    //     uint256 ethReceived = user.burn(madBytes);

    //     assertTrue(40 ether / ethReceived >= 4);

    //     madBytes = token.mintTo{value: 40 ether}(address(user2), 0);
    //     ethReceived = user2.burn(madBytes);

    //     assertTrue(40 ether / ethReceived >= 4);

    //     madBytes = token.mintTo{value: 40 ether}(address(user), 0);
    //     uint256 madBytes2 = token.mintTo{value: 40 ether}(address(user2), 0);
    //     uint256 ethReceived2 = user2.burn(madBytes2);
    //     ethReceived = user.burn(madBytes);

    //     emit log_named_uint("inv1.1:", 40 ether / ethReceived);
    //     emit log_named_uint("inv1.2:", 40 ether / ethReceived2);

    //     assertTrue(40 ether / ethReceived >= 4);
    //     assertTrue(40 ether / ethReceived2 >= 4);

    //     // amounts that are not multiple of 4
    //     madBytes = token.mintTo{value: 53 ether}(address(user), 0);
    //     madBytes2 = token.mintTo{value: 53 ether}(address(user2), 0);
    //     ethReceived2 = user2.burn(madBytes2);
    //     ethReceived = user.burn(madBytes);

    //     emit log_named_uint("inv1.1:", 53 ether / ethReceived);
    //     emit log_named_uint("inv1.2:", 53 ether / ethReceived2);

    //     assertTrue(53 ether / ethReceived >= 4);
    //     assertTrue(53 ether / ethReceived2 >= 4);
    // }

    // function testInvariantHold2() public {
    //     /*
    //     tests if the invariant holds with mint and burn:
    //     ethIn / burn(mint(ethIn)) >= marketSpread;
    //     */

    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     UserAccount user2 = newUserAccount(token);

    //     uint256 madBytes = token.mintTo{value: 4*2000 ether}(address(user), 0);
    //     uint256 ethReceived = user.burn(madBytes);

    //     emit log_named_uint("inv3:", 2000 ether / ethReceived);
    //     assertTrue(4*2000 ether / ethReceived >= 4);

    // }
}