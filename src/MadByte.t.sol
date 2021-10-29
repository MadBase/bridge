// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "../lib/ds-test/src/test.sol";

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

    function virtualMintDeposit(address to_, uint256 amount_) public returns (uint256) {
        return token.virtualMintDeposit(to_, amount_);
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
        require(amountETH >= 1, "MadByte: requires at least 4 WEI");
        madBytes = token.EthtoMB(poolBalance, amountETH);
        poolBalance += amountETH;
        totalSupply += madBytes;
    }

    function burn(uint256 amountMB) public returns (uint256 returnedEth){
        require(amountMB != 0, "MadByte: The number of MadBytes to be burn should be greater than 0!");
        require(totalSupply>= amountMB, "Underflow: totalSupply < amountMB");
        returnedEth = token.MBtoEth(poolBalance, totalSupply, amountMB);
        log("TokenPure: poolBalance      ", poolBalance);
        log("TokenPure: returnedEth      ", returnedEth);
        require(poolBalance>= returnedEth, "Underflow: poolBalance < returnedEth");
        poolBalance -= returnedEth;
        log("TokenPure: totalSupply      ", totalSupply);
        log("TokenPure: amountMB         ", amountMB);
        totalSupply -= amountMB;
        log("TokenPure: totalSupply After", totalSupply);
    }
}

contract EOA_SingleDeposit is DSTest {
    uint256 constant ONE_MB = 1*10**18;

    uint256 public madBytes = 0;

    // by calling the MadByte.deposit from a constructor, we make sure
    // the extcodesize() of address(this) is zero (thanks Hunter!).
    // this also means we can only test deposits using this approach,
    // and asserts won't work inside this constructor

    constructor(MadByte token) payable {
        // first deposit mint
        madBytes = token.mint{value: 10 ether}(0);
        emit log_named_uint("EOA MadBytes minted", madBytes);
        emit log_named_address("EOA Msg sender", msg.sender);
        assertEq(token.balanceOf(address(this)), madBytes);

        // deposit
        uint256 depositID = token.deposit(100 * ONE_MB);
        madBytes -= 100 * ONE_MB;
        assertEq(depositID, 1);
    }
}

contract EOA_DoubleDeposit is DSTest {
    uint256 constant ONE_MB = 1*10**18;

    uint256 public madBytes = 0;

    constructor(MadByte token) payable {
        // first deposit
        // mint
        madBytes = token.mint{value: 10 ether}(0);
        emit log_named_uint("EOA MadBytes minted", madBytes);
        emit log_named_address("EOA Msg sender", msg.sender);

        // deposits
        token.deposit(100 * ONE_MB);
        madBytes -= 100 * ONE_MB;
        token.deposit(199 * ONE_MB);
        madBytes -= 199 * ONE_MB;
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

    function assertEqBNAddress(MadByte.BNAddress memory actual, MadByte.BNAddress memory expected) public {
        assertEq(actual.to0, expected.to0);
        assertEq(actual.to1, expected.to1);
        assertEq(actual.to2, expected.to2);
        assertEq(actual.to3, expected.to3);
    }

    // test functions

    // function testFail_noAdminSetMinerStaking() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     token.setMinerStaking(address(0x0));
    // }

    // function testFail_noAdminSetMadStaking() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     token.setMadStaking(address(0x0));
    // }

    // function testFail_noAdminSetFoundation() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     token.setFoundation(address(0x0));
    // }

    // function testFail_noAdminSetMinerSplit() public {
    //     (MadByte token,,,,) = getFixtureData();
    //     token.setMinerSplit(100);
    // }

    // function testAdminSetters() public {
    //     (,AdminAccount admin,,,) = getFixtureData();

    //     admin.setMinerStaking(address(0x0));
    //     admin.setMadStaking(address(0x0));
    //     admin.setFoundation(address(0x0));
    //     admin.setMinerSplit(100); // 100 = 10%, 1000 = 100%
    // }

    // function testFail_SettingMinerSplitGreaterThanMadUnitOne() public {
    //     (,AdminAccount admin,,,) = getFixtureData();
    //     admin.setMinerSplit(1000);
    // }

    // function testMint() public {
    //     (MadByte token,,,,) = getFixtureData();

    //     uint256 madBytes = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes, 399028731704364116575);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 4 ether);
    //     assertEq(token.getPoolBalance(), 1 ether);

    //     uint256 madBytes2 = token.mint{value: 4 ether}(0);
    //     assertEq(madBytes2, 399027176702820751481);
    //     assertEq(token.balanceOf(address(this)), madBytes2 + madBytes);
    //     assertEq(token.totalSupply(), madBytes2 + madBytes);
    //     assertEq(address(token).balance, 8 ether);
    //     assertEq(token.getPoolBalance(), 2 ether);
    // }

    // function testMintExpectedBondingCurvePoints() public {
    //     (MadByte token1,,,,) = getFixtureData();
    //     (MadByte token2,,,,) = getFixtureData();
    //     (MadByte token3,,,,) = getFixtureData();

    //     uint256 madBytes = token1.mint{value: 10_000 ether}(0);
    //     assertEq(madBytes, 936764568799449143863271);
    //     assertEq(token1.totalSupply(), madBytes);
    //     assertEq(address(token1).balance, 10_000 ether);
    //     assertEq(token1.getPoolBalance(), 2_500 ether);

    //     // at 20k ether we have a nice rounding value for madbytes generated
    //     madBytes = token1.mint{value: 10_000 ether}(0);
    //     assertEq(madBytes, 1005000000000000000000000 - 936764568799449143863271);
    //     assertEq(token1.totalSupply(), 1005000000000000000000000);
    //     assertEq(address(token1).balance, 20_000 ether);
    //     assertEq(token1.getPoolBalance(), 5_000 ether);

    //     // the only nice value when minting happens when we mint 20k ether
    //     madBytes = token2.mint{value: 20_000 ether}(0);
    //     assertEq(madBytes, 1005000000000000000000000);
    //     assertEq(token2.totalSupply(), madBytes);
    //     assertEq(address(token2).balance, 20_000 ether);
    //     assertEq(token2.getPoolBalance(), 5_000 ether);

    //     madBytes = token3.mint{value: 25_000 ether}(0);
    //     assertEq(madBytes, 1007899288252135716968558);
    //     assertEq(token3.totalSupply(), madBytes);
    //     assertEq(address(token3).balance, 25_000 ether);
    //     assertEq(token3.getPoolBalance(), 6_250 ether);

    // }

    // function testMintWithBillionsOfEthereum() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     // Investing trillions of US dollars in ethereum
    //     uint256 madBytes = token.mint{value: 70_000_000_000 ether}(0);
    //     assertEq(madBytes, 17501004975246203818081563855);
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
    //     assertEq(madBytes, 399028731704364116575);
    //     assertEq(token.balanceOf(address(acct1)), 399028731704364116575);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 4 ether);
    //     assertEq(token.getPoolBalance(), 1 ether);

    //     uint256 madBytes2 = token.mintTo{value: 4 ether}(address(acct2), 0);
    //     assertEq(madBytes2, 399027176702820751481);
    //     assertEq(token.balanceOf(address(acct2)), 399027176702820751481);
    //     assertEq(token.totalSupply(), madBytes + madBytes2);
    //     assertEq(address(token).balance, 8 ether);
    //     assertEq(token.getPoolBalance(), 2 ether);
    // }

    // function testMintToWithBillionsOfEthereum() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     // Investing trillions of US dollars in ethereum
    //     uint256 madBytes = token.mintTo{value: 70_000_000_000 ether}(address(user), 0);
    //     assertEq(madBytes, 17501004975246203818081563855);
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
    //     assertEq(madBytes, 399_028731704364116575);
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
    //     assertEq(madBytes, 399_028731704364116575);
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
    //     assertEq(madBytes, 399_028731704364116575);
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
    //     assertEq(madBytes, 399_028731704364116575);
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
    //     assertEq(399_028731704364116575, madBytes);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 4 ether);
    //     assertEq(token.getPoolBalance(), 1 ether);

    //     assertEq(token.MBtoEth(token.getPoolBalance(), token.totalSupply(), token.totalSupply()), token.getPoolBalance());

    //     (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();

    //     assertEq(token.MBtoEth(token.getPoolBalance(), token.totalSupply(), token.totalSupply()), token.getPoolBalance());

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
    //     assertEq(token.MBtoEth(token.getPoolBalance(), token.totalSupply(), token.totalSupply()), token.getPoolBalance());
    //     // mint and transfer some tokens to the accounts
    //     uint256 madBytes = token.mint{value: 400 ether}(0);
    //     assertEq(token.MBtoEth(token.getPoolBalance(), token.totalSupply(), token.totalSupply()), token.getPoolBalance());
    //     assertEq(madBytes, 39894_868089775762639314);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(address(token).balance, 400 ether);
    //     assertEq(token.getPoolBalance(), 100 ether);

    //     assertEq(token.MBtoEth(token.getPoolBalance(), token.totalSupply(), token.totalSupply()), token.getPoolBalance());
    //     (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();
    //     assertEq(token.MBtoEth(token.getPoolBalance(), token.totalSupply(), token.totalSupply()), token.getPoolBalance());

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
    //     assertEq(madBytes, 39894_868089775762639314);

    //     (uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) = token.distribute();
    // }

    // function testBurn() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
    //     assertEq(madBytes, 3990_217121585928137263);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(user)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     uint256 ethReceived = user.burn(madBytes - 100*ONE_MB);
    //     assertEq(ethReceived, 9_749391845405398553);
    //     assertEq(address(user).balance, ethReceived);
    //     assertEq(token.totalSupply(), 100*ONE_MB);
    //     assertEq(token.balanceOf(address(user)), 100*ONE_MB);
    //     assertEq(address(token).balance, 40 ether - ethReceived);
    //     assertEq(token.getPoolBalance(), 10 ether - ethReceived);
    //     ethReceived = user.burn(100*ONE_MB);
    //     assertEq(ethReceived, 10 ether - 9_749391845405398553);
    //     assertEq(address(user).balance, 10 ether);
    //     assertEq(address(token).balance, 30 ether);
    //     assertEq(token.balanceOf(address(user)), 0);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(token.getPoolBalance(), 0);
    //     token.distribute();
    //     assertEq(address(token).balance, 0);
    // }

    // function testBurnBillionsOfMadBytes() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     // Investing trillions of US dollars in ethereum
    //     uint256 madBytes = token.mintTo{value: 70_000_000_000 ether}(address(this), 0);
    //     assertEq(madBytes, 17501004975246203818081563855);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 70_000_000_000 ether);
    //     assertEq(token.getPoolBalance(), 17500000000000000000000000000);
    //     uint256 ethReceived = token.burnTo(address(user), madBytes, 0);
    // }

    // function testFail_BurnMoreThanPossible() public {
    //     ( MadByte token, , , , ) = getFixtureData();
    //     UserAccount user = newUserAccount(token);
    //     assertEq(token.totalSupply(), 0);
    //     assertEq(address(token).balance, 0 ether);
    //     assertEq(address(user).balance, 0 ether);
    //     uint256 madBytes = token.mintTo{value: 40 ether}(address(user), 0);
    //     assertEq(madBytes, 3990_217121585928137263);
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
    //     assertEq(madBytes, 3990_217121585928137263);
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
    //     assertEq(madBytes, 3990_217121585928137263);
    //     assertEq(token.totalSupply(), madBytes);
    //     assertEq(token.balanceOf(address(this)), madBytes);
    //     assertEq(address(token).balance, 40 ether);
    //     assertEq(token.getPoolBalance(), 10 ether);
    //     uint256 ethReceived = token.burnTo(address(userTo), madBytes - 100*ONE_MB, 0);
    //     assertEq(ethReceived, 9_749391845405398553);
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
    //     assertEq(madBytes, 3990_217121585928137263);
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
    //     assertEq(madBytes, 3990_217121585928137263);
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
    //     assertEq(madBytes, 3990_217121585928137263);
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
    //     assertEq(madBytes, 3990_217121585928137263);
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
    //     assertEq(madBytesHacker, 3990_217121585928137263);
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
    //     assertEq(address(hacker).balance, 250617721342188290);
    //     emit log_named_uint("Real Hacker Balance ETH", address(hacker).balance);

    //     // If this check fails we had a reentrancy issue
    //     assertEq(address(token).balance, 39_749382278657811710);

    //     // testing a honest user
    //     ( MadByte token2, , , , ) = getFixtureData();
    //     assertEq(token2.totalSupply(), 0);
    //     UserAccount honestUser = newUserAccount(token2);
    //     uint256 madBytes = token2.mintTo{value: 40 ether}(address(honestUser), 0);
    //     assertEq(madBytes, 3990_217121585928137263);
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
    //     // the honest user must have the same balance as the hacker
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

    // function test_MintAndBurnALotThanBurnEverything(uint96 amountETH) public {
    //     if (amountETH == 0) {
    //         return;
    //     }
    //     uint256 maxIt = 10;
    //     if (amountETH <= maxIt) {
    //         amountETH = amountETH+uint96(maxIt)**2+1;
    //     }
    //     TokenPure token = new TokenPure();
    //     uint256 initialMB = token.mint(amountETH);
    //     emit log_named_uint("Initial supply:    ", token.totalSupply());
    //     uint256 madBytes = token.mint(amountETH);
    //     emit log_named_uint("Mb generated 2:   ", madBytes);
    //     emit log_named_uint("Initial supply2:   ", token.totalSupply());

    //     uint256 cumulativeMBBurned = 0;
    //     uint256 cumulativeMBMinted = 0;
    //     uint256 cumulativeETHBurned = 0;
    //     uint256 cumulativeETHMinted = 0;
    //     uint256 amountBurned = madBytes/maxIt;
    //     uint256 amountMinted = amountETH/10000;
    //     if (amountMinted == 0) {
    //         amountMinted=1;
    //     }
    //     for (uint256 i=0; i<maxIt; i++) {
    //         amountBurned = _min(amountBurned, token.totalSupply());
    //         cumulativeETHBurned += token.burn(amountBurned);
    //         cumulativeMBBurned += amountBurned;
    //         cumulativeMBMinted += token.mint(amountMinted);
    //         cumulativeETHMinted += amountMinted;
    //     }
    //     int256 burnedMBDiff = int256(cumulativeMBBurned)-int256(cumulativeMBMinted);
    //     if (burnedMBDiff < 0) {
    //         burnedMBDiff *= -1;
    //     }
    //     uint256 burnedETH = token.burn(token.totalSupply());

    //     emit log("=======================================================");
    //     emit log_named_uint("Token Balance:    ", token.totalSupply());
    //     emit log_named_uint("amountMinted ETH   ", amountMinted);
    //     emit log_named_uint("amountBurned       ", amountBurned);
    //     emit log_named_uint("cumulativeMBBurned ", cumulativeMBBurned);
    //     emit log_named_uint("cumulativeMBMinted ", cumulativeMBMinted);
    //     emit log_named_uint("cumulativeETHBurned", cumulativeETHBurned);
    //     emit log_named_uint("cumulativeETHMinted", cumulativeETHMinted);
    //     emit log_named_int("Diff MB after loop ", burnedMBDiff);
    //     emit log_named_uint("Final ETH burned   ", burnedETH);
    //     emit log_named_uint("Token1 Balance:    ", token.poolBalance());
    //     emit log_named_uint("Token1 supply:     ", token.totalSupply());
    //     assertTrue(token.poolBalance() >= 0);
    //     assertEq(token.totalSupply(), 0);
    // }

    // function test_ConversionMBToEthAndEthMBFunctions(uint96 amountEth) public {
    //     ( MadByte token, , , , ) = getFixtureData();

    //     if (amountEth == 0) {
    //         return;
    //     }
    //     uint256 poolBalance = amountEth;
    //     uint256 totalSupply = token.EthtoMB(0, amountEth);
    //     uint256 poolBalanceAfter = uint256(keccak256(abi.encodePacked(amountEth))) % amountEth;
    //     uint256 totalSupplyAfter = _fx(poolBalanceAfter);
    //     uint256 mb = totalSupply - totalSupplyAfter;
    //     uint256 returnedEth = token.MBtoEth(poolBalance, totalSupply, mb);
    //     emit log_named_uint("Diff:", poolBalance - returnedEth);
    //     assertTrue(poolBalance - returnedEth == poolBalanceAfter);
    // }

    // function test_ConversionMBToEthAndEthMBToken(uint96 amountEth) public {
    //     TokenPure token = new TokenPure();
    //     if (amountEth == 0) {
    //         return;
    //     }
    //     uint256 totalSupply = token.mint(amountEth);
    //     uint256 poolBalanceAfter = uint256(keccak256(abi.encodePacked(amountEth))) % amountEth;
    //     uint256 totalSupplyAfter = _fx(poolBalanceAfter);
    //     uint256 mb = totalSupply - totalSupplyAfter;
    //     uint256 poolBalanceBeforeBurn = token.poolBalance();
    //     uint256 returnedEth = token.burn(mb);
    //     emit log_named_uint("Tt supply after", totalSupplyAfter);
    //     emit log_named_uint("MB burned      ", mb);
    //     emit log_named_uint("Pool balance   ", poolBalanceBeforeBurn);
    //     emit log_named_uint("Pool After     ", poolBalanceAfter);
    //     emit log_named_uint("returnedEth    ", returnedEth);
    //     emit log_named_uint("Diff           ", poolBalanceBeforeBurn - returnedEth);
    //     emit log_named_uint("ExpectedDiff   ", poolBalanceAfter);
    //     emit log_named_int("Delta          ", int256(poolBalanceAfter) - int256(poolBalanceBeforeBurn - returnedEth));
    //     assertTrue(poolBalanceBeforeBurn - returnedEth == poolBalanceAfter);
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

    function testFail_QueryNonexistingDepositId() public {
        ( MadByte token, , , , ) = getFixtureData();
        token.getDeposit(1000);
    }

    function testFail_GetOwnerWithNonexistingDepositId() public {
        ( MadByte token, , , , ) = getFixtureData();
        token.getDepositOwner(1000);
    }

    function testFail_DepositToContract() public {
        ( MadByte token, , , , ) = getFixtureData();
        uint256 madBytes = token.mint{value: 10 ether}(0);
        // contracting simulating an user
        UserAccount user1 = newUserAccount(token);
        token.depositTo(address(user1), 10 * ONE_MB);

    }

    function testFail_DepositContract() public {
        ( MadByte token, , , , ) = getFixtureData();
        uint256 madBytes = token.mint{value: 10 ether}(0);
        token.deposit(10 * ONE_MB);
    }

    function testFail_virtualMintDepositContract() public {
        ( MadByte token, AdminAccount admin , , , ) = getFixtureData();
        uint256 madBytes = token.mintTo{value: 10 ether}(address(admin), 0);
        // contracting simulating an user
        UserAccount user1 = newUserAccount(token);
        admin.virtualMintDeposit(address(user1), 10 * ONE_MB);
    }

    function testFail_MintDepositContract() public {
        ( MadByte token, , , , ) = getFixtureData();
        uint256 madBytes = token.mintDeposit{value: 10 ether}(address(this), 0);
    }

    function testFail_DepositWithoutFunds() public {
        ( MadByte token, , , , ) = getFixtureData();
        uint256 madBytes = token.mint{value: 10 ether}(0);
        token.depositTo(address(0xd39f14dCd02B9fC8A11bd95604D3E3E12Fd938EE), 1000 * ONE_MB);
    }

    function testFail_noAdminVirtualMintDeposit() public {
        (MadByte token,,,,) = getFixtureData();
        token.virtualMintDeposit(address(0x0), 100);
    }

    function testMakeDepositTo() public {
        ( MadByte token, , , , ) = getFixtureData();
        address user = 0x00a329c0648769A73afAc7F9381E08FB43dBEA72;
        uint256 madBytes = token.mint{value: 10 ether}(0);
        emit log_named_uint("MadBytes minted", madBytes);
        assertEq(token.balanceOf(address(this)), madBytes);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        uint256 depositID = token.depositTo(user, 100 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 1);
        assertEq(token.balanceOf(address(this)), madBytes - 100 * ONE_MB);
        assertEq(token.balanceOf(user), 0);
        assertEq(token.balanceOf(address(token)), 100 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 100 * ONE_MB);
        assertEq(token.getDeposit(depositID), 100 * ONE_MB);
        (address depositOwner, ) = token.getDepositOwner(depositID);
        assertEq(depositOwner, user);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        uint256 depositID2 = token.depositTo(user, 199 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID2, 2);
        assertEq(token.balanceOf(address(this)), madBytes - 299 * ONE_MB);
        assertEq(token.balanceOf(user), 0);
        assertEq(token.balanceOf(address(token)), 299 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 299 * ONE_MB);
        assertEq(token.getDeposit(depositID2), 199 * ONE_MB);
        (address depositOwner2, ) = token.getDepositOwner(depositID2);
        assertEq(depositOwner2, user);
    }

    function testSingleDeposit() public {
        (MadByte token,,,,) = getFixtureData();
        assertEq(token.getPoolBalance(), 0);
        EOA_SingleDeposit user = new EOA_SingleDeposit{value: 10 ether}(token);
        assertEq(token.getPoolBalance(), 2_500000000000000000);

        assertEq(token.balanceOf(address(user)), user.madBytes());
        assertEq(token.balanceOf(address(token)), 100 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 100 * ONE_MB);
        assertEq(token.getDeposit(1), 100 * ONE_MB);
        (address depositOwner, ) = token.getDepositOwner(1);
        assertEq(depositOwner, address(user));
    }

    function testDoubleDeposit() public {
        (MadByte token,,,,) = getFixtureData();
        assertEq(token.getPoolBalance(), 0);
        EOA_DoubleDeposit user = new EOA_DoubleDeposit{value: 10 ether}(token);
        assertEq(token.getPoolBalance(), 2_500000000000000000);

        // first deposit
        assertEq(token.balanceOf(address(user)), user.madBytes());
        assertEq(token.balanceOf(address(token)), 299 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 299 * ONE_MB);
        assertEq(token.getDeposit(1), 100 * ONE_MB);
        (address depositOwner, ) = token.getDepositOwner(1);
        assertEq(depositOwner, address(user));

        // second deposit
        assertEq(token.balanceOf(address(user)), user.madBytes());
        assertEq(token.balanceOf(address(token)), 299 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 299 * ONE_MB);
        assertEq(token.getDeposit(2), 199 * ONE_MB);
        (address depositOwner2, ) = token.getDepositOwner(2);
        assertEq(depositOwner2, address(user));
    }

    function testDepositTo() public {
        (MadByte token,,,,) = getFixtureData();
        address user = address(0xd39f14dCd02B9fC8A11bd95604D3E3E12Fd938EE);
        uint256 madBytes = token.mint{value: 10 ether}(0);
        emit log_named_uint("EOA MadBytes minted", madBytes);
        emit log_named_address("EOA Msg sender", msg.sender);
        assertEq(token.balanceOf(address(this)), madBytes);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        // first deposit
        uint256 depositID = token.depositTo(user, 100 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 1);
        assertEq(token.balanceOf(user), 0);
        assertEq(token.balanceOf(address(this)), madBytes - (100 * ONE_MB));
        assertEq(token.balanceOf(address(token)), 100 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 100 * ONE_MB);
        assertEq(token.getDeposit(1), 100 * ONE_MB);
        (address depositOwner, ) = token.getDepositOwner(1);
        assertEq(depositOwner, user);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        // second deposit
        depositID = token.depositTo(user, 199 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 2);
        assertEq(token.balanceOf(user), 0);
        assertEq(token.balanceOf(address(this)), madBytes - (299 * ONE_MB));
        assertEq(token.balanceOf(address(token)), 299 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 299 * ONE_MB);
        assertEq(token.getDeposit(2), 199 * ONE_MB);
        (address depositOwner2, ) = token.getDepositOwner(2);
        assertEq(depositOwner2, user);
    }

    function testDepositToBN() public {
        (MadByte token,,,,) = getFixtureData();
        MadByte.BNAddress memory user = MadByte.BNAddress(bytes32("0x1"), bytes32("0x2"), bytes32("0x3"), bytes32("0x4"));
        uint256 madBytes = token.mint{value: 10 ether}(0);
        emit log_named_uint("EOA MadBytes minted", madBytes);
        emit log_named_address("EOA Msg sender", msg.sender);
        assertEq(token.balanceOf(address(this)), madBytes);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        // first deposit
        uint256 depositID = token.depositToBN(user.to0, user.to1, user.to2, user.to3, 100 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 1);
        assertEq(token.balanceOf(address(this)), madBytes - (100 * ONE_MB));
        assertEq(token.balanceOf(address(token)), 100 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 100 * ONE_MB);
        assertEq(token.getDeposit(1), 100 * ONE_MB);
        (, MadByte.BNAddress memory depositOwner) = token.getDepositOwner(1);
        assertEqBNAddress(depositOwner, user);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        // second deposit
        depositID = token.depositToBN(user.to0, user.to1, user.to2, user.to3, 199 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 2);
        assertEq(token.balanceOf(address(this)), madBytes - (299 * ONE_MB));
        assertEq(token.balanceOf(address(token)), 299 * ONE_MB);
        assertEq(token.getTotalMadBytesDeposited(), 299 * ONE_MB);
        assertEq(token.getDeposit(2), 199 * ONE_MB);
        (, MadByte.BNAddress memory depositOwner2) = token.getDepositOwner(2);
        assertEqBNAddress(depositOwner2, user);
    }

    function testDepositZeroMadBytes() public {
        (MadByte token,,,,) = getFixtureData();
        address user = address(0xd39f14dCd02B9fC8A11bd95604D3E3E12Fd938EE);
        uint256 madBytes = token.mint{value: 10 ether}(0);
        emit log_named_uint("EOA MadBytes minted", madBytes);
        emit log_named_address("EOA Msg sender", msg.sender);
        assertEq(token.balanceOf(address(this)), madBytes);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        // first deposit
        uint256 depositID = token.depositTo(user, 0);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 1);
        assertEq(token.balanceOf(user), 0);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(token.balanceOf(address(token)), 0);
        assertEq(token.getTotalMadBytesDeposited(), 0);
        assertEq(token.getDeposit(1), 0);
        (address depositOwner, ) = token.getDepositOwner(1);
        assertEq(depositOwner, user);
    }

    function testVirtualMintDeposit() public {
        (MadByte token, AdminAccount admin,,,) = getFixtureData();
        address user = address(0xd39f14dCd02B9fC8A11bd95604D3E3E12Fd938EE);
        uint256 madBytes = token.mint{value: 10 ether}(0);
        assertEq(token.balanceOf(address(this)), madBytes);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        // first deposit
        uint256 depositID = admin.virtualMintDeposit(user, 100 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 1);
        assertEq(token.balanceOf(user), 0);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(token.balanceOf(address(token)), 0);
        assertEq(token.getTotalMadBytesDeposited(), 100 * ONE_MB);
        assertEq(token.getDeposit(1), 100 * ONE_MB);
        (address depositOwner, ) = token.getDepositOwner(1);
        assertEq(depositOwner, user);

        assertEq(token.getPoolBalance(), 2_500000000000000000);
        // second deposit
        depositID = admin.virtualMintDeposit(user, 199 * ONE_MB);
        assertEq(token.getPoolBalance(), 2_500000000000000000);
        assertEq(depositID, 2);
        assertEq(token.balanceOf(user), 0);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(token.balanceOf(address(token)), 0);
        assertEq(token.getTotalMadBytesDeposited(), 299 * ONE_MB);
        assertEq(token.getDeposit(2), 199 * ONE_MB);
        (address depositOwner2, ) = token.getDepositOwner(2);
        assertEq(depositOwner2, user);
    }

    function testMintDeposit() public {
        (MadByte token,,,,) = getFixtureData();
        address user = address(0xd39f14dCd02B9fC8A11bd95604D3E3E12Fd938EE);
        assertEq(token.getPoolBalance(), 0);
        uint256 depositID = token.mintDeposit{value: 10 ether}(user, 0);
        assertEq(token.getPoolBalance(), 0);
        assertEq(depositID, 1);
        assertEq(token.balanceOf(address(user)), 0);
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.getTotalMadBytesDeposited(), token.getDeposit(1));
        (address depositOwner, ) = token.getDepositOwner(depositID);
        assertEq(depositOwner, user);

        assertEq(token.getPoolBalance(), 0);
        uint256 depositID2 = token.mintDeposit{value: 10 ether}(user, 0);
        assertEq(token.getPoolBalance(), 0);
        assertEq(depositID2, 2);
        assertEq(token.balanceOf(address(user)), 0);
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.getTotalMadBytesDeposited(), token.getDeposit(1)+token.getDeposit(2));
        (address depositOwner2, ) = token.getDepositOwner(depositID2);

        assertEq(depositOwner2, user);
        assertEq(token.getDeposit(2), token.getDeposit(1));
        emit log_named_uint("Amount deposit 1", token.getDeposit(1));
        emit log_named_uint("Amount deposit 2", token.getDeposit(2));

        // testing if we are getting the same amount of MB from the normal mint
        uint256 madBytes = token.mint{value: 10 ether}(0);
        assertEq(token.balanceOf(address(this)), madBytes);
        assertEq(token.getDeposit(1), madBytes);

    }


}
