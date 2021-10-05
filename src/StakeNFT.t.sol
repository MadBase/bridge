// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./StakeNFT.sol";
import "./lib/openzeppelin/token/ERC20/ERC20.sol";


contract MadTokenMock is ERC20 {
    constructor(address to_) ERC20("MadToken", "MAD") {
        _mint(to_, 220000000);
    }
}

abstract contract BaseMock {
    StakeNFT public stakeNFT;
    MadTokenMock public madToken;
    
    function setTokens(MadTokenMock madToken_, StakeNFT stakeNFT_) public {
        stakeNFT = stakeNFT_;
        madToken = madToken_;
    }
    
    receive() external virtual payable{}

    function mint(uint256 amount_) public returns(uint256) {
        return stakeNFT.mint(amount_);
    }

    function approve(address who, uint256 amount_) public returns(bool) {
        return madToken.approve(who, amount_);
    }
}

contract AdminAccount is BaseMock {
    constructor() {}

    function tripCB() public {
        stakeNFT.tripCB();
    }

    function setGovernance(address governance_) public {
        stakeNFT.setGovernance(governance_);
    }
}

contract GovernanceAccount is BaseMock {
    constructor() {}
}

contract UserAccount is BaseMock {
    constructor() {}
}

contract StakeNFTTest is DSTest {

    function getFixtureData()
    internal
    returns(
        StakeNFT stakeNFT,
        MadTokenMock madToken,
        AdminAccount admin,
        GovernanceAccount governance
    )
    {
        governance = new GovernanceAccount();
        admin = new AdminAccount();
        madToken = new MadTokenMock(address(this));
        stakeNFT = new StakeNFT(
            IERC20Transfer(address(madToken)),
            address(admin),
            address(governance)
        );

        admin.setTokens(madToken, stakeNFT);
        governance.setTokens(madToken, stakeNFT);
    }

    function newUserAccount(MadTokenMock madToken, StakeNFT stakeNFT) private returns(UserAccount acct) {
        acct = new UserAccount();
        acct.setTokens(madToken, stakeNFT);
    }

    function getCurrentPosition(StakeNFT stakeNFT, uint256 tokenID) internal returns(StakeNFT.Position memory actual){
        (
            uint32 shares,
            uint32 freeAfter,
            uint256 accumulatorEth,
            uint256 accumulatorToken
        ) = stakeNFT.getPosition(tokenID);
        actual = StakeNFT.Position(shares, freeAfter, accumulatorEth, accumulatorToken);
    }

    function assertPosition(StakeNFT.Position memory p, StakeNFT.Position memory expected) internal {
        assertEq(p.shares, expected.shares);
        assertEq(p.freeAfter, expected.freeAfter);
        assertEq(p.accumulatorEth, expected.accumulatorEth);
        assertEq(p.accumulatorToken, expected.accumulatorToken);
    }

    function testAdminTripCBAndChangeGovernance() public {
        (StakeNFT stakeNFT,, AdminAccount admin,) = getFixtureData();
        admin.tripCB();
        admin.setGovernance(address(0x0));
    }

    function testFail_noAdminTripCB() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.tripCB();
    }

    function testFail_noAdminSetGovernance() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.setGovernance(address(0x0));
    }

    function testFail_noAdminSkimExcessOtherERC20() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.skimExcessOtherERC20(address(0x0), address(0x0), 0);
    }

    function testFail_noAdminSkimExcessOtherERC721() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.skimExcessOtherERC721(address(0x0), address(0x0), 0);
    }

    function testFail_noAdminSkimExcessEth() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.skimExcessEth(address(0x0));
    }

    function testFail_noAdminSkimExcessToken() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.skimExcessToken(address(0x0));
    }

    function testFail_noGovernanceLockPosition() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.lockPosition(address(0x0), 0, 0);
    }

    function testFail_tripCBDepositEth() public {
        (StakeNFT stakeNFT,, AdminAccount admin,) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.depositEth(42);
    }

    function testFail_tripCBMint() public {
        (StakeNFT stakeNFT,, AdminAccount admin,) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.mint(100);
    }

    function testFail_tripCBMintTo() public {
        (StakeNFT stakeNFT,, AdminAccount admin,) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.mintTo(address(0x0), 100, 0);
    }

    function testFail_tripCBLockPosition() public {
        (StakeNFT stakeNFT,, AdminAccount admin,) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.lockPosition(address(0x0), 100, 0);
    }

    function testFail_tripDepositToken() public {
        (StakeNFT stakeNFT,, AdminAccount admin,) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.depositToken(42, 100);
    }

    function testFail_MintWithoutApprove() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.mint(100);
    }

    function testFail_MintMoreMadTokensThanPossible() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.mint(2**32);
    }

    //todo: Create testFail_MintWithoutApprove and testFail_MintMoreMadTokensThanPossible for mintTo

    function testFail_getPositionThatDoesNotExist() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        getCurrentPosition(stakeNFT, 4);
    }

    function testMint() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mint(1000);
        StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
        StakeNFT.Position memory expected = StakeNFT.Position(1000, 1, 0, 0);
        assertPosition(actual, expected);
    }

    function testMintTo_WithoutLock() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
        StakeNFT.Position memory expected = StakeNFT.Position(1000, 1, 0, 0);

        assertPosition(actual, expected);

        assertEq(stakeNFT.ownerOf(tokenID), address(user));
    }

    function testMintTo_WithLock() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 10);

        StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
        StakeNFT.Position memory expected = StakeNFT.Position(1000, 10, 0, 0);

        assertPosition(actual, expected);

        assertEq(stakeNFT.ownerOf(tokenID), address(user));
    }

    // todo: test mint with slush skim
    function testMint_WithSlushSkim() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);
        madToken.transfer(address(user3), 100);

        user1.approve(address(stakeNFT), 100);
        user2.approve(address(stakeNFT), 100);
        user3.approve(address(stakeNFT), 100);
        
        uint256 tokenID1 = user1.mint(100);
        (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
        assertEq(acc, 0);
        assertEq(slush, 0);
        (acc, slush) = stakeNFT.getTokenAccumulator();
        assertEq(acc, 0);
        assertEq(slush, 0);

        uint256 tokenID2 = user2.mint(100);
        (acc, slush) = stakeNFT.getEthAccumulator();
        assertEq(acc, 0);
        assertEq(slush, 0);
        (acc, slush) = stakeNFT.getTokenAccumulator();
        assertEq(acc, 0);
        assertEq(slush, 0);

        uint256 tokenID3 = user3.mint(100);
        (acc, slush) = stakeNFT.getEthAccumulator();
        assertEq(acc, 0);
        assertEq(slush, 0);
        (acc, slush) = stakeNFT.getTokenAccumulator();
        assertEq(acc, 0);
        assertEq(slush, 0);

        //StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
        //StakeNFT.Position memory expected = StakeNFT.Position(1000, 1, 0, 0);
    }

    // todo: burn, burnTo, *withoutLock, *withLock, *with slush skim
}