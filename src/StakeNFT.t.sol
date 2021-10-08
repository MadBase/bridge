// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./StakeNFT.sol";
import "./lib/openzeppelin/token/ERC20/ERC20.sol";

uint256 constant ONE_MADTOKEN = 10**18;

contract MadTokenMock is ERC20 {
    constructor(address to_) ERC20("MadToken", "MAD") {
        _mint(to_, 220000000 * ONE_MADTOKEN);
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

    function mintTo(address to_, uint256 amount_, uint256 duration_) public returns(uint256) {
        return stakeNFT.mintTo(to_, amount_, duration_);
    }

    function burn(uint256 tokenID) public returns(uint256, uint256) {
        return stakeNFT.burn(tokenID);
    }

    function burnTo(address to_, uint256 tokenID) public returns(uint256, uint256) {
        return stakeNFT.burnTo(to_, tokenID);
    }

    function approve(address who, uint256 amount_) public returns(bool) {
        return madToken.approve(who, amount_);
    }

    function depositToken(uint256 amount_) public {
        stakeNFT.depositToken(42, amount_);
    }

    function depositEth(uint256 amount_) public {
        stakeNFT.depositEth{value: amount_}(42);
    }

    function collectToken(uint256 tokenID_) public returns(uint256 payout) {
        return stakeNFT.collectToken(tokenID_);
    }

    function collectEth(uint256 tokenID_) public returns(uint256 payout) {
        return stakeNFT.collectEth(tokenID_);
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

    function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) public {
        stakeNFT.lockPosition(caller_, tokenID_, lockDuration_);
    }
}

contract UserAccount is BaseMock {
    constructor() {}
}

contract BadEthCollectorAccount is BaseMock {
    uint256 tokenID;
    
    constructor() {}

    receive() external virtual payable{
        collectEth(tokenID);
    }

    function setTokenID(uint256 tokenID_) {
        tokenID = tokenID_;
    }


}

contract StakeNFTHugeAccumulator is StakeNFT {

    uint256 public constant offsetToOverflow = 1_000000000000000000;
    constructor(IERC20Transfer MadToken_, address admin_, address governance_) StakeNFT(MadToken_, admin_, governance_) {
        _tokenState.accumulator = uint256(type(uint168).max - offsetToOverflow);
        _ethState.accumulator = uint256(type(uint168).max - offsetToOverflow);
    }
    function getOffsetToOverflow() public view returns (uint256) {
        return offsetToOverflow;
    }
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

    function getFixtureDataWithHugeAccumulator()
    internal
    returns(
        StakeNFTHugeAccumulator stakeNFT,
        MadTokenMock madToken,
        AdminAccount admin,
        GovernanceAccount governance
    )
    {
        governance = new GovernanceAccount();
        admin = new AdminAccount();
        madToken = new MadTokenMock(address(this));
        stakeNFT = new StakeNFTHugeAccumulator(
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

    function setBlockNumber(uint256 bn) internal returns(bool) {
        // https://github.com/dapphub/dapptools/tree/master/src/hevm#cheat-codes
        address externalContract = address(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        (bool success, bytes memory returnedData) = externalContract.call(
            abi.encodeWithSignature("roll(uint256)", bn)
        );

        return success;
    }

    function getCurrentPosition(StakeNFT stakeNFT, uint256 tokenID) internal returns(StakeNFT.Position memory actual){
        (
            uint256 shares,
            uint256 freeAfter,
            uint256 accumulatorEth,
            uint256 accumulatorToken
        ) = stakeNFT.getPosition(tokenID);
        actual = StakeNFT.Position(uint224(shares), uint32(freeAfter), accumulatorEth, accumulatorToken);
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
        (StakeNFT stakeNFT, MadTokenMock madToken, AdminAccount admin, GovernanceAccount governance) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);
        admin.tripCB(); // open CB
        governance.lockPosition(address(0x0), 100, 0);
    }

    function testFail_tripDepositToken() public {
        (StakeNFT stakeNFT,, AdminAccount admin,) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.depositToken(42, 100);
    }

    function testFail_getPositionThatDoesNotExist() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        getCurrentPosition(stakeNFT, 4);
    }

    function testBasicERC721() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        assertEq(stakeNFT.name(), "MNStake");
        assertEq(stakeNFT.symbol(), "MNS");
    }

    function testMint() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mint(1000);
        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 0));

        assertEq(stakeNFT.balanceOf(address(this)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(this));
    }

    function testMintManyTokensSameUser() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        madToken.approve(address(stakeNFT), 1000);

        for (uint256 i=0; i < 10; i++) {
            uint256 tokenID = stakeNFT.mint(100);
            assertEq(stakeNFT.ownerOf(tokenID), address(this));
            assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(100, 1, 0, 0));
        }
        assertEq(stakeNFT.balanceOf(address(this)), 10);
    }

    function testFail_MintWithoutApproval() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        uint256 tokenID = stakeNFT.mint(1000);
    }

    function testFail_MintMoreMadTokensThanPossible() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.mint(2**32);
    }

    function testMintTo_WithoutLock() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
    }

    function testMintTo_WithLock() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 10);

        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 10, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
    }

    function testFail_MintToMoreMadTokensThanPossible() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        stakeNFT.mintTo(address(user), 2**32, 1);
    }

    function testFail_MintToWithoutApproval() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        stakeNFT.mintTo(address(user), 100, 1);
    }

    function testFail_MintToWithInvalidLockHeight() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);
        stakeNFT.mintTo(address(user), 100, 1051200 + 1);
    }

    // mint+burn
    function testFail_BurningRightAfterMinting() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mint(1000);
        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 0));

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

        user.burn(tokenID);
    }

    function testMintAndBurn() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mint(1000);
        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

        setBlockNumber(block.number+2);

        (uint256 payoutEth, uint256 payoutToken) = user.burn(tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    // mint+burnTo
    function testMintAndBurnTo() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);

        uint256 tokenID = user.mint(1000);
        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 0));

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

        setBlockNumber(block.number+2);

        (uint256 payoutEth, uint256 payoutToken) = user.burnTo(address(user2), tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    // mintTo + burn
    function testMintToAndBurn() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mintTo(address(user2), 1000, 1);
        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 0));

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

        setBlockNumber(block.number+2);

        (uint256 payoutEth, uint256 payoutToken) = user2.burn(tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    // mintTo + burnTo
    function testMintToAndBurnTo() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mintTo(address(user2), 1000, 1);
        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 0));

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

        setBlockNumber(block.number+2);

        (uint256 payoutEth, uint256 payoutToken) = user2.burnTo(address(user3), tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    // mintTo + burnTo + lock 10 blocks
    function testMintToAndBurnToWithLocking() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mintTo(address(user2), 1000, 10);
        assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 10, 0, 0));

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

        setBlockNumber(block.number+11);

        (uint256 payoutEth, uint256 payoutToken) = user2.burnTo(address(user3), tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    function test_CollectTokenWithMultipleUsers() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);
        UserAccount donator = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);
        madToken.transfer(address(user3), 100);
        madToken.transfer(address(donator), 100000);

        user1.approve(address(stakeNFT), 100);
        user2.approve(address(stakeNFT), 100);
        user3.approve(address(stakeNFT), 100);
        donator.approve(address(stakeNFT), 100000);

        uint256 sharesPerUser = 100;
        uint256 tokenID1 = user1.mint(sharesPerUser);
        assertPosition(getCurrentPosition(stakeNFT, tokenID1), StakeNFT.Position(100, 1, 0, 0));

        {
            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
        }


        donator.depositToken(50);
        {
            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, (50 * stakeNFT.accumulatorScaleFactor()) / sharesPerUser);
            assertEq(acc, 500000000000000000);
            assertEq(slush, 0);
            assertEq(slush + (acc * sharesPerUser), 50 * stakeNFT.accumulatorScaleFactor());
        }

        {
            uint256 stakeBalance = madToken.balanceOf(address(stakeNFT));
            assertEq(stakeBalance, 150);

            uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
            assertEq(payout, 50);
            payout = user1.collectToken(tokenID1);
            assertEq(payout, 50);

            assertEq(madToken.balanceOf(address(user1)), 50);
            assertEq(madToken.balanceOf(address(stakeNFT)), 100);
            assertEq(madToken.balanceOf(address(stakeNFT)), stakeBalance-payout);

            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 500000000000000000);
            assertEq(slush, 0);

            assertPosition(getCurrentPosition(stakeNFT, tokenID1), StakeNFT.Position(100, 1, 0, 500000000000000000));
        }

        uint256 tokenID2 = user2.mint(sharesPerUser);
        assertPosition(getCurrentPosition(stakeNFT, tokenID2), StakeNFT.Position(100, 1, 0, 500000000000000000));

        {
            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 500000000000000000);
            assertEq(slush, 0);
        }


        donator.depositToken(500);
        {
            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 3_000000000000000000);
            assertEq(slush, 0);
        }

        {
            uint256 stakeBalance = madToken.balanceOf(address(stakeNFT));
            assertEq(stakeBalance, 700);

            uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
            assertEq(payout, 250);
            payout = user1.collectToken(tokenID1);
            assertEq(payout, 250);

            assertEq(madToken.balanceOf(address(user1)), 300);
            assertEq(madToken.balanceOf(address(stakeNFT)), 450);
            assertEq(madToken.balanceOf(address(stakeNFT)), stakeBalance-payout);

            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 3_000000000000000000);
            assertEq(slush, 0);

            assertPosition(getCurrentPosition(stakeNFT, tokenID1), StakeNFT.Position(100, 1, 0, 3_000000000000000000));
        }

        {
            uint256 stakeBalance = madToken.balanceOf(address(stakeNFT));
            assertEq(stakeBalance, 450);

            uint256 payout2 = stakeNFT.estimateTokenCollection(tokenID2);
            assertEq(payout2, 250);
            payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 250);

            assertEq(madToken.balanceOf(address(user2)), 250);
            assertEq(madToken.balanceOf(address(stakeNFT)), 200);
            assertEq(madToken.balanceOf(address(stakeNFT)), stakeBalance-payout2);

            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 3_000000000000000000);
            assertEq(slush, 0);

            assertPosition(getCurrentPosition(stakeNFT, tokenID2), StakeNFT.Position(100, 1, 0, 3_000000000000000000));
        }

        uint256 tokenID3 = user3.mint(sharesPerUser);
        assertPosition(getCurrentPosition(stakeNFT, tokenID3), StakeNFT.Position(100, 1, 0, 3_000000000000000000));


        donator.depositToken(1000);
        {
            uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
            assertEq(payout, 333);
            payout = user1.collectToken(tokenID1);
            assertEq(payout, 333);
            uint256 payout2 = stakeNFT.estimateTokenCollection(tokenID2);
            assertEq(payout2, 333);
            payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 333);
            uint payout3 = stakeNFT.estimateTokenCollection(tokenID3);
            assertEq(payout3, 333);
            payout3 = user3.collectToken(tokenID3);
            assertEq(payout3, 333);
        }
        {
            donator.depositToken(1000);

            uint256 payout = user1.collectToken(tokenID1);
            assertEq(payout, 333);
            uint256 payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 333);
        }

        {
            donator.depositToken(3000-999-333-2);
            uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
            assertEq(payout, 555);
            payout = user1.collectToken(tokenID1);
            assertEq(payout, 555);
            uint256 payout2 = stakeNFT.estimateTokenCollection(tokenID2);
            assertEq(payout2, 555);
            payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 555);
            uint256 payout3 = stakeNFT.estimateTokenCollection(tokenID3);
            assertEq(payout3, 888);
            payout3 = user3.collectToken(tokenID3);
            assertEq(payout3, 888);
        }

    }

    function testBurnWithTripCB() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, AdminAccount admin,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount donator = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 1000 * ONE_MADTOKEN);
        madToken.transfer(address(user2), 1000 * ONE_MADTOKEN);
        madToken.transfer(address(donator), 1_000_000 * ONE_MADTOKEN);
        user1.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);
        user2.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);
        donator.approve(address(stakeNFT), 20000 * ONE_MADTOKEN);
        payable(address(donator)).transfer(2000 ether);

        // minting
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN );
        assertPosition(getCurrentPosition(stakeNFT, tokenID1), StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 0, 0));
        uint256 tokenID2 = user2.mint(800 * ONE_MADTOKEN);
        assertPosition(getCurrentPosition(stakeNFT, tokenID2), StakeNFT.Position(uint224(800 * ONE_MADTOKEN), 1, 0, 0));

        // depositing to move the accumulators
        donator.depositToken(1800 * ONE_MADTOKEN);
        donator.depositEth(1800 ether);

        setBlockNumber(block.number+2);
        // minting one more position to user 2
        uint256 tokenID3 = user2.mint(200 * ONE_MADTOKEN);
        assertPosition(getCurrentPosition(stakeNFT, tokenID3), StakeNFT.Position(uint224(200 * ONE_MADTOKEN), 1, 10**18, 10**18));

        donator.depositEth(200 ether);
        donator.depositToken(200 * ONE_MADTOKEN);

        assertEq(madToken.balanceOf(address(user1)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(stakeNFT.balanceOf(address(user1)), 1);
        assertEq(stakeNFT.balanceOf(address(user2)), 2);
        assertEq(address(user1).balance, 0 ether);
        assertEq(address(user2).balance, 0 ether);
        assertEq(madToken.balanceOf(address(stakeNFT)), 4000 * ONE_MADTOKEN);
        assertEq(address(stakeNFT).balance, 2000 ether);

        setBlockNumber(block.number+2);

        //e.g bug was found so we needed to trip the Circuit breaker
        admin.tripCB();

        // Only burn (which uses both collect) should work now
        (uint256 payoutEth, uint256 payoutToken) = user1.burn(tokenID1);
        assertEq(payoutEth, 1100 ether);
        assertEq(payoutToken, 2100 * ONE_MADTOKEN);
        assertEq(stakeNFT.balanceOf(address(user1)), 0);
        assertEq(address(user1).balance, 1100 ether);
        assertEq(madToken.balanceOf(address(user1)), 2100 * ONE_MADTOKEN);

        (payoutEth, payoutToken) = user2.burn(tokenID2);
        assertEq(payoutEth, 880 ether);
        assertEq(payoutToken, 1680 * ONE_MADTOKEN);
        assertEq(stakeNFT.balanceOf(address(user2)), 1);
        assertEq(address(user2).balance, 880 ether);
        assertEq(madToken.balanceOf(address(user2)), 1680 * ONE_MADTOKEN);

        (payoutEth, payoutToken) = user2.burn(tokenID3);
        assertEq(payoutEth, 20 ether);
        assertEq(payoutToken, 220 * ONE_MADTOKEN);
        assertEq(stakeNFT.balanceOf(address(user2)), 0);
        assertEq(address(user2).balance, 900 ether);
        assertEq(madToken.balanceOf(address(user2)), 1900 * ONE_MADTOKEN);

        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    function testFail_CollectNonOnwedToken() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 1000 * ONE_MADTOKEN);
        user1.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);

        // minting
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN );
        assertPosition(getCurrentPosition(stakeNFT, tokenID1), StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 0, 0));

        user2.collectToken(tokenID1);
    }

    function testFail_CollectNonOnwedEth() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 1000 * ONE_MADTOKEN);
        user1.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);

        // minting
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN );
        assertPosition(getCurrentPosition(stakeNFT, tokenID1), StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 0, 0));

        user2.collectEth(tokenID1);
    }

    function testFail_BurnNonOnwedPosition() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 1000 * ONE_MADTOKEN);
        user1.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);

        // minting
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN );
        assertPosition(getCurrentPosition(stakeNFT, tokenID1), StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 0, 0));

        user2.burn(tokenID1);
    }

    function testCollectTokensWithOverflowOnTheAccumulator() public {
        (StakeNFTHugeAccumulator stakeNFTHugeAcc, MadTokenMock madToken,,) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);
        madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN );

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        donator.approve(address(stakeNFTHugeAcc), 210_000_000 * ONE_MADTOKEN);

        uint256 expectedAccumulatorToken = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID1), StakeNFT.Position(user1Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getTokenAccumulator();
        assertEq(acc, expectedAccumulatorToken);
        assertEq(slush, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25;
        donator.depositToken(deposit1);
        expectedAccumulatorToken += (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor())/user1Shares;

        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID2), StakeNFT.Position(user2Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        {
            (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getTokenAccumulator();
            assertEq(acc, expectedAccumulatorToken);
            assertEq(slush, 0);
        }

        // the overflow should happen here. As we are incrementing the accumulator by 150 * 10**16
        uint256 deposit2 = 150;
        donator.depositToken(deposit2);
        expectedAccumulatorToken += (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor())/(user1Shares+user2Shares);
        expectedAccumulatorToken -= type(uint168).max;
        (acc, slush) = stakeNFTHugeAcc.getTokenAccumulator();
        assertEq(acc, expectedAccumulatorToken);
        assertEq(acc, 1000000000000000000);
        assertEq(slush, 0);

        // Testing collecting the dividends after the accumulator overflow Each
        // user has to call collect twice to get the right amount of funds
        // (before and after the overflow)
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID1), 100);
        assertEq(user1.collectToken(tokenID1), 100);
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID2), 75);
        assertEq(user2.collectToken(tokenID2), 75);
    }

    function testBurnTokensWithOverflowOnTheAccumulator() public {
        (StakeNFTHugeAccumulator stakeNFTHugeAcc, MadTokenMock madToken,,) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);
        madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN );

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        donator.approve(address(stakeNFTHugeAcc), 210_000_000 * ONE_MADTOKEN);

        uint256 expectedAccumulatorToken = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID1), StakeNFT.Position(user1Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getTokenAccumulator();
        assertEq(acc, expectedAccumulatorToken);
        assertEq(slush, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25;
        donator.depositToken(deposit1);
        expectedAccumulatorToken += (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor())/user1Shares;

        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID2), StakeNFT.Position(user2Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        {
            (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getTokenAccumulator();
            assertEq(acc, expectedAccumulatorToken);
            assertEq(slush, 0);
        }

        // the overflow should happen here as we are incrementing the accumulator by 150 * 10**16
        uint256 deposit2 = 150;
        donator.depositToken(deposit2);
        expectedAccumulatorToken += (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor())/(user1Shares+user2Shares);
        expectedAccumulatorToken -= type(uint168).max;
        (acc, slush) = stakeNFTHugeAcc.getTokenAccumulator();
        assertEq(acc, expectedAccumulatorToken);
        assertEq(acc, 1000000000000000000);
        assertEq(slush, 0);

        // Testing collecting the dividends after the accumulator overflow
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID1), 100);
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID2), 75);
        // advance block number
        require(setBlockNumber(block.number+2));
        (, uint256 payoutToken1) = user1.burn(tokenID1);
        assertEq(payoutToken1, 150);
        (, uint256 payoutToken2) = user2.burn(tokenID2);
        assertEq(payoutToken2, 125);
    }

    function testCollectEtherWithOverflowOnTheAccumulator() public {
        (StakeNFTHugeAccumulator stakeNFTHugeAcc, MadTokenMock madToken,,) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        payable(address(donator)).transfer(1000);

        uint256 expectedAccumulatorToken = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID1), StakeNFT.Position(user1Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(slush, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25; //wei
        donator.depositEth(deposit1);
        expectedAccumulatorETH += (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor())/user1Shares;

        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID2), StakeNFT.Position(user2Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        {
            (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getEthAccumulator();
            assertEq(acc, expectedAccumulatorETH);
            assertEq(slush, 0);
        }

        // the overflow should happen here as we are incrementing the accumulator by 150 * 10**16
        uint256 deposit2 = 150; //wei
        donator.depositEth(deposit2);
        expectedAccumulatorETH += (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor())/(user1Shares+user2Shares);
        expectedAccumulatorETH -= type(uint168).max;
        (acc, slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(acc, 1000000000000000000);
        assertEq(slush, 0);

        // Testing collecting the dividends after the accumulator overflow
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID1), 100);
        assertEq(user1.collectEth(tokenID1), 100);
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID2), 75);
        assertEq(user2.collectEth(tokenID2), 75);
    }

    function testBurnEtherWithOverflowOnTheAccumulator() public {
        (StakeNFTHugeAccumulator stakeNFTHugeAcc, MadTokenMock madToken,,) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        payable(address(donator)).transfer(1000);

        uint256 expectedAccumulatorToken = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max - stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID1), StakeNFT.Position(user1Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(slush, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25; //wei
        donator.depositEth(deposit1);
        expectedAccumulatorETH += (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor())/user1Shares;

        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(getCurrentPosition(stakeNFTHugeAcc, tokenID2), StakeNFT.Position(user2Shares, 1, expectedAccumulatorETH, expectedAccumulatorToken));
        {
            (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getEthAccumulator();
            assertEq(acc, expectedAccumulatorETH);
            assertEq(slush, 0);
        }

        // the overflow should happen here. As we are incrementing the accumulator by 150 * 10**16
        uint256 deposit2 = 150; //wei
        donator.depositEth(deposit2);
        expectedAccumulatorETH += (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor())/(user1Shares+user2Shares);
        expectedAccumulatorETH -= type(uint168).max;
        (acc, slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(acc, 1000000000000000000);
        assertEq(slush, 0);

        // Testing collecting the dividends after the accumulator overflow Each
        // user has to call collect twice to get the right amount of funds
        // (before and after the overflow)
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID1), 100);
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID2), 75);
        // advance block number
        require(setBlockNumber(block.number+2));

        (uint256 payoutEth1, uint256 payoutToken1) = user1.burn(tokenID1);
        assertEq(payoutEth1, 100);
        assertEq(payoutToken1, 50);
        (uint256 payoutEth2, uint256 payoutToken2) = user2.burn(tokenID2);
        assertEq(payoutEth2, 75);
        assertEq(payoutToken2, 50);
    }

    // function testEthFullCircle() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
    //     UserAccount user1 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user2 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user3 = newUserAccount(madToken, stakeNFT);

    //     // test contract has all the tokens, so it's going to transfer some
    //     madToken.transfer(address(user1), 10000 * ONE_MADTOKEN);
    //     madToken.transfer(address(user2), 10000 * ONE_MADTOKEN);
    //     madToken.transfer(address(user3), 10000 * ONE_MADTOKEN);

    //     //payable(address(user2)).transfer(50);

    //     user1.approve(address(stakeNFT), 10000 * ONE_MADTOKEN);
    //     user2.approve(address(stakeNFT), 10000 * ONE_MADTOKEN);
    //     user3.approve(address(stakeNFT), 10000 * ONE_MADTOKEN);

    //     madToken.approve(address(stakeNFT), 3000 * ONE_MADTOKEN);

    //     uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN);
    //     uint256 payoutToken = user1.collectToken(tokenID1);
    //     assertEq(payoutToken, 0);

    //     uint256 tokenID2 = user2.mint(1000 * ONE_MADTOKEN);
    //     uint256 tokenID3 = user3.mint(1000 * ONE_MADTOKEN);

    //     assertPosition(
    //         getCurrentPosition(stakeNFT, tokenID1),
    //         StakeNFT.Position(1000, 1, 0, 0)
    //     );
    //     assertPosition(
    //         getCurrentPosition(stakeNFT, tokenID2),
    //         StakeNFT.Position(1000, 1, 0, 0)
    //     );
    //     assertPosition(
    //         getCurrentPosition(stakeNFT, tokenID3),
    //         StakeNFT.Position(1000, 1, 0, 0)
    //     );

    //     // advance block number
    //     require(setBlockNumber(block.number+2));

    //     uint256 payout1 = stakeNFT.estimateEthCollection(tokenID1);
    //     assertEq(payout1, 0);
    //     uint256 payout2 = stakeNFT.estimateEthCollection(tokenID2);
    //     assertEq(payout2, 0);
    //     uint256 payout3 = stakeNFT.estimateEthCollection(tokenID3);
    //     assertEq(payout3, 0);

    //     // deposit tokens
    //     //stakeNFT.depositEth{value: 1000}(42);
    //     stakeNFT.depositEth{value: 1 ether}(42);
    //     (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
    //     emit log("Get eth 1");
    //     assertEq(acc, 333333333333333);
    //     assertEq(slush, 1000);


    //     payout1 = stakeNFT.estimateEthCollection(tokenID1);
    //     assertEq(payout1, 1 ether/3);
    //     payout2 = stakeNFT.estimateEthCollection(tokenID2);
    //     assertEq(payout2, 1 ether/3);
    //     payout3 = stakeNFT.estimateEthCollection(tokenID3);
    //     assertEq(payout3, 1 ether/3);

    //     stakeNFT.depositEth{value: 2 ether}(42);
    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     emit log("Get eth 1");
    //     assertEq(acc, 1000000000000000);
    //     assertEq(slush, 0);

    //     payout1 = stakeNFT.estimateEthCollection(tokenID1);
    //     assertEq(payout1, 1 ether);
    //     payout2 = stakeNFT.estimateEthCollection(tokenID2);
    //     assertEq(payout2, 1 ether);
    //     payout3 = stakeNFT.estimateEthCollection(tokenID3);
    //     assertEq(payout3, 1 ether);
    //     fail();
    // }

    function testLockPosition() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,, GovernanceAccount governance) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(getCurrentPosition(stakeNFT, tokenID),  StakeNFT.Position(1000, 1, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 172800);
    }

    function testLockPositionAndBurn() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,, GovernanceAccount governance) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(getCurrentPosition(stakeNFT, tokenID),  StakeNFT.Position(1000, 1, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 172800);
        setBlockNumber(block.number+172801);
        (uint256 payoutEth, uint256 payoutToken) = user.burn(tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertEq(stakeNFT.balanceOf(address(user)), 0);

    }

    function testFail_LockPositionAndTryToBurnBeforeLockHasFinished() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,, GovernanceAccount governance) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(getCurrentPosition(stakeNFT, tokenID),  StakeNFT.Position(1000, 1, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 800);

        setBlockNumber(block.number+750);

        user.burn(tokenID);
    }

    function testFail_LockPositionNotTheOwner() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,, GovernanceAccount governance) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(getCurrentPosition(stakeNFT, tokenID),  StakeNFT.Position(1000, 1, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(this), tokenID, 1);
    }

    function testFail_LockPositionInvalidLockHeight() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,, GovernanceAccount governance) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(getCurrentPosition(stakeNFT, tokenID),  StakeNFT.Position(1000, 1, 0, 0));
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 172800 + 1);
    }

    function testFail_LockNonExistentPosition() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,, GovernanceAccount governance) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        governance.lockPosition(address(user), 4, 172800);
    }

    function testReentrantCollectEth() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        BadEthCollectorAccount user = new BadEthCollectorAccount();
        user.setTokens(stakeNFT, madToken);
        
        madToken.transfer(address(user), 100);
        //madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN );

        user.approve(address(stakeNFTHugeAcc), 100);
        //donator.approve(address(stakeNFTHugeAcc), 210_000_000 * ONE_MADTOKEN);

        //payable(address(user)).transfer(2000 ether);
        payable(address(donator)).transfer(2000 ether);

        uint256 tokenID = user.mint(1000);

        donator.depositEth(1000 ether);

        user.collectEth(tokenID);

        assertEq(address(user).balance, 1000 ether);
        
    }
}