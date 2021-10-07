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

    function burn(uint256 tokenID) public returns(uint256, uint256) {
        return stakeNFT.burn(tokenID);
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
}

contract UserAccount is BaseMock {
    constructor() {}
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
        payable(address(acct)).transfer(10 ether);
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

    // function testFail_noAdminSkimExcessToken() public {
    //     (StakeNFT stakeNFT,,,) = getFixtureData();
    //     stakeNFT.skimExcessToken(address(0x0));
    // }

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

    function testBasicERC721() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        assertEq(stakeNFT.name(), "MNStake");
        assertEq(stakeNFT.symbol(), "MNS");
    }

    function testMint() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mint(1000);
        StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
        StakeNFT.Position memory expected = StakeNFT.Position(1000, 1, 0, 0);
        assertPosition(actual, expected);
        uint256 balanceNFT = stakeNFT.balanceOf(address(this));
        assertEq(balanceNFT, 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(this));
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

    // // todo: test mint with slush skim
    // function testMint_WithoutSlushSkim() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
    //     UserAccount user1 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user2 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user3 = newUserAccount(madToken, stakeNFT);

    //     madToken.transfer(address(user1), 100);
    //     madToken.transfer(address(user2), 100);
    //     madToken.transfer(address(user3), 100);

    //     user1.approve(address(stakeNFT), 100);
    //     user2.approve(address(stakeNFT), 100);
    //     user3.approve(address(stakeNFT), 100);

    //     uint256 tokenID1 = user1.mint(100);
    //     (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);

    //     uint256 tokenID2 = user2.mint(99);
    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);

    //     uint256 tokenID3 = user3.mint(100);
    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    // }

    // function testMint_WithTokenSlushSkim() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
    //     UserAccount user1 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user2 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user3 = newUserAccount(madToken, stakeNFT);

    //     madToken.transfer(address(user1), 100);
    //     madToken.transfer(address(user2), 100);
    //     madToken.transfer(address(user3), 100);

    //     user1.approve(address(stakeNFT), 100);
    //     user2.approve(address(stakeNFT), 100);
    //     user3.approve(address(stakeNFT), 100);

    //     uint256 shares = 100;
    //     uint256 tokenID1 = user1.mint(shares);
    //     (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);

    //     uint256 tokenDeposit = 50;
    //     user2.depositToken(tokenDeposit);
    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     // assertEq(acc, (tokenDeposit * stakeNFT.accumulatorScaleFactor()) / shares); // 50*10**18 // 100
    //     // assertEq(slush, 0);
    //     // assertEq(slush + (acc * shares), tokenDeposit * stakeNFT.accumulatorScaleFactor());
    //     //assertEq( (slush + acc) / (stakeNFT.accumulatorScaleFactor * 100, 50);

    //     uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
    //     assertEq(payout, 50); // ((acc * 100)/ 10**18)
    //     payout = user1.collectToken(tokenID1);
    //     assertEq(payout, 50);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 500000000000000000); // 50*10**18 // 100
    //     assertEq(slush, 0); // 50*10**18 - 50*10**18 // 100


    //     uint256 tokenID3 = user3.mint(100);
    //     StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID3);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc,     500000000000000000);
    //     assertEq(slush, 49005000000000000000);
    //     uint256 payout2 = stakeNFT.estimateTokenCollection(tokenID3);
    //     assertEq(payout2, 0);

    // }


    function testMint_MultipleUsers() public {
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


    // function testMint_WithEthSlushSkim() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
    //     UserAccount user1 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user2 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user3 = newUserAccount(madToken, stakeNFT);

    //     madToken.transfer(address(user1), 100);
    //     madToken.transfer(address(user2), 100);
    //     madToken.transfer(address(user3), 100);

    //     payable(address(user2)).transfer(50);

    //     user1.approve(address(stakeNFT), 100);
    //     user2.approve(address(stakeNFT), 100);
    //     user3.approve(address(stakeNFT), 100);

    //     uint256 tokenID1 = user1.mint(100);
    //     (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);

    //     user2.depositEth(50);
    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 50);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);

    //     uint256 tokenID3 = user3.mint(100);
    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 50);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    // }

    function testMintWithHugeAccumulatorDistributingTokens() public {
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

    function testBurnWithHugeAccumulatorDistributingTokens() public {
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
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID2), 75);
        // advance block number
        require(setBlockNumber(block.number+2));
        (, uint256 payoutToken1) = user1.burn(tokenID1);
        assertEq(payoutToken1, 150);
        (, uint256 payoutToken2) = user2.burn(tokenID2);
        assertEq(payoutToken2, 125);
    }

    function testMintWithHugeAccumulatorDistributingEther() public {
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
        assertEq(user1.collectEth(tokenID1), 100);
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID2), 75);
        assertEq(user2.collectEth(tokenID2), 75);
    }

    function testBurnWithHugeAccumulatorDistributingEther() public {
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

    // todo: burn, burnTo, *withoutLock, *withLock, *with slush skim
    // function testBurn() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();

    //     madToken.approve(address(stakeNFT), 1000);
    //     uint256 tokenID = stakeNFT.mint(1000);

    //     StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
    //     StakeNFT.Position memory expected = StakeNFT.Position(1000, 1, 0, 0);
    //     assertPosition(actual, expected);

    //     (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 1000);

    //     uint256 balanceNFT = stakeNFT.balanceOf(address(this));
    //     assertEq(balanceNFT, 1);
    //     assertEq(stakeNFT.ownerOf(tokenID), address(this));
    //     assertEq(madToken.balanceOf(address(this)), 220000000-1000);
    //     assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

    //     // advance block number
    //     require(setBlockNumber(block.number+2));

    //     uint256 payout = stakeNFT.estimateTokenCollection(tokenID);
    //     assertEq(payout, 1000);
    //     //payout = stakeNFT.collectToken(tokenID);
    //     //assertEq(payout, 1000);

    //     (uint256 payoutEth, uint256 payoutMadToken) = stakeNFT.burn(tokenID);
    //     assertEq(payoutMadToken, 1000);
    //     assertEq(madToken.balanceOf(address(this)), 220000000);
    // }

    // function testBurn2() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();

    //     madToken.approve(address(stakeNFT), 1000);
    //     uint256 tokenID = stakeNFT.mint(1000);

    //     StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
    //     StakeNFT.Position memory expected = StakeNFT.Position(1000, 1, 0, 0);
    //     assertPosition(actual, expected);

    //     (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 1000);

    //     uint256 balanceNFT = stakeNFT.balanceOf(address(this));
    //     assertEq(balanceNFT, 1);
    //     assertEq(stakeNFT.ownerOf(tokenID), address(this));
    //     assertEq(madToken.balanceOf(address(this)), 220000000-1000);
    //     assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

    //     // advance block number
    //     require(setBlockNumber(block.number+2));

    //     uint256 payout = stakeNFT.estimateTokenCollection(tokenID);
    //     assertEq(payout, 1000);
    //     payout = stakeNFT.collectToken(tokenID);
    //     assertEq(payout, 1000);

    //     actual = getCurrentPosition(stakeNFT, tokenID);
    //     expected = StakeNFT.Position(1000, 1, 0, 1);
    //     assertPosition(actual, expected);

    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 1);
    //     assertEq(slush, 0);

    //     assertEq(madToken.balanceOf(address(this)), 220000000);
    //     assertEq(madToken.balanceOf(address(stakeNFT)), 0);

    //     (uint256 payoutEth, uint256 payoutMadToken) = stakeNFT.burn(tokenID);
    //     assertEq(payoutMadToken, 0);
    //     assertEq(payoutEth, 0);
    //     assertEq(madToken.balanceOf(address(this)), 220000000);
    //     assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    // }

    // function testBurnMultipleUsers() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
    //     UserAccount user1 = newUserAccount(madToken, stakeNFT);

    //     madToken.transfer(address(user1), 3000);
    //     user1.approve(address(stakeNFT), 3000);

    //     madToken.approve(address(stakeNFT), 1000);

    //     uint256 tokenID = stakeNFT.mint(1000);
    //     StakeNFT.Position memory actual = getCurrentPosition(stakeNFT, tokenID);
    //     StakeNFT.Position memory expected = StakeNFT.Position(1000, 1, 0, 0);
    //     assertPosition(actual, expected);
    //     assertEq(stakeNFT.balanceOf(address(this)), 1);
    //     assertEq(stakeNFT.ownerOf(tokenID), address(this));
    //     assertEq(madToken.balanceOf(address(this)), 220000000-2000);
    //     assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

    //     (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 1000);

    //     uint256 tokenIDUser = user1.mint(3000);
    //     assertPosition(getCurrentPosition(stakeNFT, tokenIDUser), StakeNFT.Position(3000, 1, 0, 4));
    //     assertEq(stakeNFT.balanceOf(address(user1)), 1);
    //     assertEq(stakeNFT.ownerOf(tokenIDUser), address(user1));
    //     assertEq(madToken.balanceOf(address(user1)), 0);
    //     assertEq(madToken.balanceOf(address(stakeNFT)), 4000);


    //     // advance block number
    //     require(setBlockNumber(block.number+2));

    //     uint256 payout = stakeNFT.estimateTokenCollection(tokenID);
    //     assertEq(payout, 4000);
    //     uint256 payoutUser = stakeNFT.estimateTokenCollection(tokenIDUser);
    //     assertEq(payoutUser, 0);
    //     payout = stakeNFT.collectToken(tokenID);
    //     assertEq(payout, 4000);
    //     payoutUser = user1.collectToken(tokenIDUser);
    //     assertEq(payoutUser, 0);

    //     assertPosition(getCurrentPosition(stakeNFT, tokenID), StakeNFT.Position(1000, 1, 0, 4));
    //     assertPosition(getCurrentPosition(stakeNFT, tokenIDUser), StakeNFT.Position(1000, 1, 0, 4));

    //     (acc, slush) = stakeNFT.getEthAccumulator();
    //     assertEq(acc, 0);
    //     assertEq(slush, 0);
    //     (acc, slush) = stakeNFT.getTokenAccumulator();
    //     assertEq(acc, 4);
    //     assertEq(slush, 0);

    //     assertEq(madToken.balanceOf(address(this)), 220000000);
    //     assertEq(madToken.balanceOf(address(stakeNFT)), 0);

    //     (uint256 payoutEth, uint256 payoutMadToken) = stakeNFT.burn(tokenID);
    //     assertEq(payoutMadToken, 0);
    //     assertEq(payoutEth, 0);
    //     // assertEq(madToken.balanceOf(address(this)), 220000000);
    //     // assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    // }

    // function testTokenFullCircle() public {
    //     (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();

    //     UserAccount user1 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user2 = newUserAccount(madToken, stakeNFT);
    //     UserAccount user3 = newUserAccount(madToken, stakeNFT);

    //     madToken.transfer(address(user1), 10000);
    //     madToken.transfer(address(user2), 10000);
    //     madToken.transfer(address(user3), 10000);

    //     //payable(address(user2)).transfer(50);

    //     user1.approve(address(stakeNFT), 1000);
    //     user2.approve(address(stakeNFT), 1000);
    //     user3.approve(address(stakeNFT), 1000);

    //     madToken.approve(address(stakeNFT), 3000);

    //     uint256 tokenID1 = user1.mint(1000);
    //     uint256 payoutToken = user1.collectToken(tokenID1);
    //     assertEq(payoutToken, 0);

    //     uint256 tokenID2 = user2.mint(1000);
    //     uint256 tokenID3 = user3.mint(1000);

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

    //     uint256 payout1 = stakeNFT.estimateTokenCollection(tokenID1);
    //     assertEq(payout1, 0);
    //     uint256 payout2 = stakeNFT.estimateTokenCollection(tokenID2);
    //     assertEq(payout2, 0);
    //     uint256 payout3 = stakeNFT.estimateTokenCollection(tokenID3);
    //     assertEq(payout3, 0);

    //     // deposit tokens
    //     //stakeNFT.depositEth{value: 1000}(42);
    //     stakeNFT.depositToken(42, 1000);

    //     payout1 = stakeNFT.estimateTokenCollection(tokenID1);
    //     assertEq(payout1, 0);
    //     payout2 = stakeNFT.estimateTokenCollection(tokenID2);
    //     assertEq(payout2, 0);
    //     payout3 = stakeNFT.estimateTokenCollection(tokenID3);
    //     assertEq(payout3, 0);

    //     stakeNFT.depositToken(42, 2000);

    //     payout1 = stakeNFT.estimateTokenCollection(tokenID1);
    //     assertEq(payout1, 1000);
    //     payout2 = stakeNFT.estimateTokenCollection(tokenID2);
    //     assertEq(payout2, 1000);
    //     payout3 = stakeNFT.estimateTokenCollection(tokenID3);
    //     assertEq(payout3, 1000);
    // }

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
}