// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "lib/ds-test/test.sol";

import "src/tokens/StakeNFT.sol";
import "lib/openzeppelin/token/ERC20/ERC20.sol";
import "lib/openzeppelin/token/ERC721/IERC721Receiver.sol";

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

    receive() external payable virtual {}

    function mint(uint256 amount_) public returns (uint256) {
        return stakeNFT.mint(amount_);
    }

    function mintTo(
        address to_,
        uint256 amount_,
        uint256 duration_
    ) public returns (uint256) {
        return stakeNFT.mintTo(to_, amount_, duration_);
    }

    function burn(uint256 tokenID) public returns (uint256, uint256) {
        return stakeNFT.burn(tokenID);
    }

    function burnTo(address to_, uint256 tokenID)
        public
        returns (uint256, uint256)
    {
        return stakeNFT.burnTo(to_, tokenID);
    }

    function approve(address who, uint256 amount_) public returns (bool) {
        return madToken.approve(who, amount_);
    }

    function depositToken(uint256 amount_) public {
        stakeNFT.depositToken(42, amount_);
    }

    function depositEth(uint256 amount_) public {
        stakeNFT.depositEth{value: amount_}(42);
    }

    function collectToken(uint256 tokenID_) public returns (uint256 payout) {
        return stakeNFT.collectToken(tokenID_);
    }

    function collectEth(uint256 tokenID_) public returns (uint256 payout) {
        return stakeNFT.collectEth(tokenID_);
    }

    function approveNFT(address to, uint256 tokenID_) public{
        return stakeNFT.approve(to, tokenID_);
    }

    function setApprovalForAll(address to, bool approve_) public{
        return stakeNFT.setApprovalForAll(to, approve_);
    }

    function transferFrom(address from, address to, uint256 tokenID_) public {
        return stakeNFT.transferFrom(from, to, tokenID_);
    }

    function safeTransferFrom(address from, address to, uint256 tokenID_, bytes calldata data) public {
        return stakeNFT.safeTransferFrom(from, to, tokenID_, data);
    }

    function lockWithdraw(uint256 tokenID, uint256 lockDuration) public returns(uint256) {
        return stakeNFT.lockWithdraw(tokenID, lockDuration);
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

    function skimExcessEth(address to_) public returns(uint256 excess) {
        return stakeNFT.skimExcessEth(to_);
    }

    function skimExcessToken(address to_) public returns(uint256 excess) {
        return stakeNFT.skimExcessToken(to_);
    }
}

contract GovernanceAccount is BaseMock {
    constructor() {}

    function lockPosition(
        address caller_,
        uint256 tokenID_,
        uint256 lockDuration_
    ) public {
        stakeNFT.lockPosition(caller_, tokenID_, lockDuration_);
    }
}

contract UserAccount is BaseMock {
    constructor() {}
}

contract ReentrantLoopEthCollectorAccount is BaseMock {
    uint256 tokenID;

    constructor() {}

    receive() external payable virtual override {
        collectEth(tokenID);
    }

    function setTokenID(uint256 tokenID_) public {
        tokenID = tokenID_;
    }
}

contract ReentrantFiniteEthCollectorAccount is BaseMock {
    uint256 tokenID;
    uint256 public _count = 0;

    constructor() {}

    receive() external payable virtual override {
        if (_count < 2) {
            _count++;
            collectEth(1);
        } else {
            return;
        }
    }

    function setTokenID(uint256 tokenID_) public {
        tokenID = tokenID_;
    }
}

contract ReentrantLoopBurnAccount is BaseMock {
    uint256 tokenID;

    constructor() {}

    receive() external payable virtual override {
        burn(tokenID);
    }

    function setTokenID(uint256 tokenID_) public {
        tokenID = tokenID_;
    }
}

contract ReentrantFiniteBurnAccount is BaseMock {
    uint256 tokenID;
    uint256 public _count = 0;

    constructor() {}

    receive() external payable virtual override {
        if (_count < 2) {
            _count++;
            burn(tokenID);
        } else {
            return;
        }
    }

    function setTokenID(uint256 tokenID_) public {
        tokenID = tokenID_;
    }
}

contract ERC721ReceiverAccount is BaseMock, IERC721Receiver {

    constructor() {}

    // receive() external payable virtual override {

    // }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override pure returns (bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}

contract ReentrantLoopBurnERC721ReceiverAccount is BaseMock, IERC721Receiver {
    uint256 _tokenId;
    constructor() {}

    receive() external payable virtual override {
        stakeNFT.burn(_tokenId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        _tokenId = tokenId;
        stakeNFT.burn(tokenId);
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}

contract ReentrantFiniteBurnERC721ReceiverAccount is BaseMock, IERC721Receiver {
    uint256 _tokenId;
    uint256 _count = 0;
    constructor() {}

    receive() external payable virtual override {
        stakeNFT.burn(_tokenId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        if (_count < 2) {
            _count++;
            _tokenId = tokenId;
            stakeNFT.burn(tokenId);
        }

        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}

contract ReentrantLoopCollectEthERC721ReceiverAccount is BaseMock, IERC721Receiver {
    uint256 _tokenId;
    constructor() {}

    receive() external payable virtual override {
        stakeNFT.collectEth(_tokenId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        _tokenId = tokenId;
        stakeNFT.collectEth(tokenId);
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}

contract AdminAccountReEntrant is BaseMock {
    uint256 public _count = 0;

    constructor() {}

    function skimExcessEth(address to_) public returns(uint256 excess) {
        return stakeNFT.skimExcessEth(to_);
    }

    receive() external payable virtual override {
        if (_count < 2) {
            _count++;
            stakeNFT.skimExcessEth(address(this));
        } else {
            return;
        }
    }
}

contract StakeNFTHugeAccumulator is StakeNFT {
    uint256 public constant offsetToOverflow = 1_000000000000000000;

    constructor(
        IERC20Transferable MadToken_,
        address admin_,
        address governance_
    ) StakeNFT(MadToken_, admin_, governance_) {
        _tokenState.accumulator = uint256(type(uint168).max - offsetToOverflow);
        _ethState.accumulator = uint256(type(uint168).max - offsetToOverflow);
    }

    function getOffsetToOverflow() public pure returns (uint256) {
        return offsetToOverflow;
    }
}

contract StakeNFTTest is DSTest {
    function getFixtureData()
        internal
        returns (
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
            IERC20Transferable(address(madToken)),
            address(admin),
            address(governance)
        );

        admin.setTokens(madToken, stakeNFT);
        governance.setTokens(madToken, stakeNFT);
    }

    function getFixtureDataWithHugeAccumulator()
        internal
        returns (
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
            IERC20Transferable(address(madToken)),
            address(admin),
            address(governance)
        );

        admin.setTokens(madToken, stakeNFT);
        governance.setTokens(madToken, stakeNFT);
    }

    function getFixtureDataAdminReEntrant()
        internal
        returns (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            AdminAccountReEntrant admin,
            GovernanceAccount governance
        )
    {
        governance = new GovernanceAccount();
        admin = new AdminAccountReEntrant();
        madToken = new MadTokenMock(address(this));
        stakeNFT = new StakeNFT(
            IERC20Transferable(address(madToken)),
            address(admin),
            address(governance)
        );

        admin.setTokens(madToken, stakeNFT);
        governance.setTokens(madToken, stakeNFT);
    }

    function newUserAccount(MadTokenMock madToken, StakeNFT stakeNFT)
        private
        returns (UserAccount acct)
    {
        acct = new UserAccount();
        acct.setTokens(madToken, stakeNFT);
    }

    function setBlockNumber(uint256 bn) internal returns (bool) {
        // https://github.com/dapphub/dapptools/tree/master/src/hevm#cheat-codes
        address externalContract = address(
            0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
        );
        (bool success, /*bytes memory returnedData*/) = externalContract.call(
            abi.encodeWithSignature("roll(uint256)", bn)
        );

        return success;
    }

    function getCurrentPosition(StakeNFT stakeNFT, uint256 tokenID)
        internal view
        returns (StakeNFT.Position memory actual)
    {
        (
            uint256 shares,
            uint256 freeAfter,
            uint256 withdrawFreeAfter,
            uint256 accumulatorEth,
            uint256 accumulatorToken
        ) = stakeNFT.getPosition(tokenID);
        actual = StakeNFT.Position(
            uint224(shares),
            uint32(freeAfter),
            uint32(withdrawFreeAfter),
            accumulatorEth,
            accumulatorToken
        );
    }

    function assertPosition(
        StakeNFT.Position memory p,
        StakeNFT.Position memory expected
    ) internal {
        assertEq(p.shares, expected.shares);
        assertEq(p.freeAfter, expected.freeAfter);
        assertEq(p.withdrawFreeAfter, expected.withdrawFreeAfter);
        assertEq(p.accumulatorEth, expected.accumulatorEth);
        assertEq(p.accumulatorToken, expected.accumulatorToken);
    }

    function assertTokenAccumulator(StakeNFT stakeNFT, uint256 expectedAccumulator, uint256 expectedSlush) internal {
        (uint256 acc, uint256 slush) = stakeNFT.getTokenAccumulator();
        assertEq(acc, expectedAccumulator);
        assertEq(slush, expectedSlush);
    }

    function assertEthAccumulator(StakeNFT stakeNFT, uint256 expectedAccumulator, uint256 expectedSlush) internal {
        (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
        assertEq(acc, expectedAccumulator);
        assertEq(slush, expectedSlush);
    }

    function assertReserveAndExcessZero(StakeNFT stakeNFT, uint256 reserveAmountToken, uint256 reserveAmountEth) internal{
        assertEq(stakeNFT.getTotalReserveMadToken(), reserveAmountToken);
        assertEq(stakeNFT.getTotalReserveEth(), reserveAmountEth);
        assertEq(stakeNFT.estimateExcessToken(), 0);
        assertEq(stakeNFT.estimateExcessEth(), 0);
    }

    function assertReserveAndExcess(StakeNFT stakeNFT, uint256 reserveAmountToken, uint256 reserveAmountEth, uint256 excessToken, uint256 excessEth ) internal{
        assertEq(stakeNFT.getTotalReserveMadToken(), reserveAmountToken);
        assertEq(stakeNFT.getTotalReserveEth(), reserveAmountEth);
        assertEq(stakeNFT.estimateExcessToken(), excessToken);
        assertEq(stakeNFT.estimateExcessEth(), excessEth);
    }

    function testAdminTripCBAndChangeGovernance() public {
        (, , AdminAccount admin, ) = getFixtureData();
        admin.tripCB();
        admin.setGovernance(address(0x0));
    }

    function testFail_noAdminTripCB() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.tripCB();
    }

    function testFail_noAdminSetGovernance() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.setGovernance(address(0x0));
    }

    function testFail_noAdminSkimExcessEth() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.skimExcessEth(address(0));
    }

    function testFail_noAdminSkimExcessToken() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.skimExcessToken(address(0));
    }

    function testFail_noGovernanceLockPosition() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.lockPosition(address(0x0), 0, 0);
    }

    function testFail_tripCBDepositEth() public {
        (StakeNFT stakeNFT, , AdminAccount admin, ) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.depositEth(42);
    }

    function testFail_tripCBMint() public {
        (StakeNFT stakeNFT, , AdminAccount admin, ) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.mint(100);
    }

    function testFail_tripCBMintTo() public {
        (StakeNFT stakeNFT, , AdminAccount admin, ) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.mintTo(address(0x0), 100, 0);
    }

    function testFail_tripCBLockPosition() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        madToken.approve(address(stakeNFT), 1000);
        stakeNFT.mintTo(address(user), 1000, 0);
        admin.tripCB(); // open CB
        governance.lockPosition(address(0x0), 100, 0);
    }

    function testFail_tripDepositToken() public {
        (StakeNFT stakeNFT, , AdminAccount admin, ) = getFixtureData();
        admin.tripCB(); // open CB
        stakeNFT.depositToken(42, 100);
    }

    function testFail_getPositionThatDoesNotExist() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        getCurrentPosition(stakeNFT, 4);
    }

    function testBasicERC721() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        assertEq(stakeNFT.name(), "MNStake");
        assertEq(stakeNFT.symbol(), "MNS");
    }

    function testDeposit() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        madToken.approve(address(stakeNFT), 100000);
        stakeNFT.depositToken(42, 100000);
        stakeNFT.depositEth{value: 10 ether}(42);
        assertEq(madToken.balanceOf(address(stakeNFT)), 100000);
        assertEq(address(stakeNFT).balance, 10 ether);
        assertReserveAndExcessZero(stakeNFT, 100000, 10 ether);
    }

    function testFail_DepositTokenWithWrongMagicNumber() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        madToken.approve(address(stakeNFT), 100000);
        stakeNFT.depositToken(41, 100000);
    }

    function testFail_DepositEthWithWrongMagicNumber() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.depositEth{value: 10 ether}(41);
    }

    function testMint() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mint(1000);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );

        assertEq(stakeNFT.balanceOf(address(this)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(this));
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);
    }

    function testMintManyTokensSameUser() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        madToken.approve(address(stakeNFT), 1000);

        for (uint256 i = 0; i < 10; i++) {
            uint256 tokenID = stakeNFT.mint(100);
            assertEq(stakeNFT.ownerOf(tokenID), address(this));
            assertPosition(
                getCurrentPosition(stakeNFT, tokenID),
                StakeNFT.Position(100, 1, 1, 0, 0)
            );
        }
        assertEq(stakeNFT.balanceOf(address(this)), 10);
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);
    }

    function testFail_MintWithoutApproval() public {
        (StakeNFT stakeNFT,,,) = getFixtureData();
        stakeNFT.mint(1000);
    }

    function testFail_MintMoreMadTokensThanPossible() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.mint(2**32);
    }

    function testMintTo_WithoutLock() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);
    }

    function testMintTo_WithLock() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 10);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 10, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);
    }

    function testFail_MintToMoreMadTokensThanPossible() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        stakeNFT.mintTo(address(user), 2**32, 1);
    }

    function testFail_MintToWithoutApproval() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        stakeNFT.mintTo(address(user), 100, 1);
    }

    function testFail_MintToWithInvalidLockHeight() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);
        stakeNFT.mintTo(address(user), 100, 1051200 + 1);
    }

    // mint+burn
    function testFail_BurningRightAfterMinting() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mint(1000);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);

        user.burn(tokenID);
    }

    function testMintAndBurn() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mint(1000);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);

        setBlockNumber(block.number + 2);

        (uint256 payoutEth, uint256 payoutToken) = user.burn(tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);
        assertReserveAndExcessZero(stakeNFT, 0, 0 ether);
        assertEq(madToken.balanceOf(address(user)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);

    }

    // mint+burnTo
    function testMintAndBurnTo() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);

        uint256 tokenID = user.mint(1000);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);

        setBlockNumber(block.number + 2);

        (uint256 payoutEth, uint256 payoutToken) = user.burnTo(
            address(user2),
            tokenID
        );
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertReserveAndExcessZero(stakeNFT, 0, 0 ether);
    }

    // mintTo + burn
    function testMintToAndBurn() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mintTo(address(user2), 1000, 1);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);

        setBlockNumber(block.number + 2);

        (uint256 payoutEth, uint256 payoutToken) = user2.burn(tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertReserveAndExcessZero(stakeNFT, 0, 0 ether);
    }

    // mintTo + burnTo
    function testMintToAndBurnTo() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mintTo(address(user2), 1000, 1);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);

        setBlockNumber(block.number + 2);

        (uint256 payoutEth, uint256 payoutToken) = user2.burnTo(
            address(user3),
            tokenID
        );
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertReserveAndExcessZero(stakeNFT, 0, 0 ether);
    }

    // mintTo + burnTo + lock 10 blocks
    function testMintToAndBurnToWithLocking() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 1000);
        user.approve(address(stakeNFT), 1000);

        uint256 tokenID = user.mintTo(address(user2), 1000, 10);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 10, 1, 0, 0)
        );

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000);
        assertReserveAndExcessZero(stakeNFT, 1000, 0 ether);

        setBlockNumber(block.number + 11);

        (uint256 payoutEth, uint256 payoutToken) = user2.burnTo(
            address(user3),
            tokenID
        );
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(madToken.balanceOf(address(user3)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertReserveAndExcessZero(stakeNFT, 0, 0 ether);
    }

    function test_SharesInvariance() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        madToken.transfer(address(donator), 10000000 * ONE_MADTOKEN);
        donator.approve(address(stakeNFT), 10000000 * ONE_MADTOKEN);
        payable(address(donator)).transfer(100000 ether);

        UserAccount[50] memory users;
        uint256 shares=0;
        // Minting a lot
        for (uint256 i=0; i < 50; i++){
            users[i] = newUserAccount(madToken, stakeNFT);
            madToken.transfer(address(users[i]), (1_000_000 * ONE_MADTOKEN)+i);
            users[i].approve(address(stakeNFT), (1_000_000 * ONE_MADTOKEN)+i);
            users[i].mint((1_000_000 * ONE_MADTOKEN)+i);
            shares += (1_000_000 * ONE_MADTOKEN)+i;
        }
        assertEq(shares, stakeNFT.getTotalShares());
        assertReserveAndExcessZero(stakeNFT, shares, 0 ether);
        setBlockNumber(block.number+2);
        // burning some of the NFTs
        for (uint256 i=0; i < 50; i++){
            if (i % 3 == 0){
                users[i].burn(i+1);
                shares -= (1_000_000 * ONE_MADTOKEN)+i;
            }
        }
        assertReserveAndExcessZero(stakeNFT, shares, 0 ether);
        assertEq(shares, stakeNFT.getTotalShares());
    }

    function test_SlushFlushIntoAccumulator() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);
        UserAccount donator = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);
        madToken.transfer(address(user3), 100);
        madToken.transfer(address(donator), 100000 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 100);
        user2.approve(address(stakeNFT), 100);
        user3.approve(address(stakeNFT), 100);
        donator.approve(address(stakeNFT), 100000 * ONE_MADTOKEN);
        payable(address(donator)).transfer(1000 ether);

        uint256 sharesPerUser = 10;
        uint256 tokenID1 = user1.mint(sharesPerUser);
        uint256 tokenID2 = user2.mint(sharesPerUser);
        uint256 tokenID3 = user3.mint(sharesPerUser);
        assertReserveAndExcessZero(stakeNFT, 30, 0 ether);

        setBlockNumber(block.number+2);

        uint256 credits = 0;
        uint256 debits = 0;
        for (uint256 i =0; i < 2; i++){
            donator.depositEth(1000);
            credits += 1000;
            uint256 payout = user1.collectEth(tokenID1);
            assertEq(payout, 333);
            debits += payout;
            uint256 payout2 = user2.collectEth(tokenID2);
            assertEq(payout2, 333);
            debits += payout2;
            uint256 payout3 = user3.collectEth(tokenID3);
            assertEq(payout3, 333);
            debits += payout3;
        }
        {
            emit log_named_uint("Balance ETH: ", address(stakeNFT).balance);
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(slush, (credits - debits) * 10**18);
            assertReserveAndExcessZero(stakeNFT, 30, (credits - debits));
        }
        {
            donator.depositEth(2000);
            credits += 2000;
            assertReserveAndExcessZero(stakeNFT, 30, (credits - debits));
            uint256 payout = user1.collectEth(tokenID1);
            assertEq(payout, 667);
            debits += payout;
            uint256 payout2 = user2.collectEth(tokenID2);
            assertEq(payout2, 667);
            debits += payout2;
            uint256 payout3 = user3.collectEth(tokenID3);
            assertEq(payout3, 667);
            debits += payout3;
            emit log_named_uint("Balance ETH After: ", address(stakeNFT).balance);
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(slush, (credits - debits) * 10**18);
            assertEq(slush, 1 ether);
        }
        {
            assertReserveAndExcessZero(stakeNFT, 30, (credits - debits));
        }
    }

    function test_SlushInvariance() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);
        UserAccount donator = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 3333);
        madToken.transfer(address(user2), 111);
        madToken.transfer(address(user3), 7);
        madToken.transfer(address(donator), 100000 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 3333);
        user2.approve(address(stakeNFT), 111);
        user3.approve(address(stakeNFT), 7);
        donator.approve(address(stakeNFT), 100000 * ONE_MADTOKEN);
        payable(address(donator)).transfer(10000000000 ether);

        uint256 tokenID1 = user1.mint(3333);
        uint256 tokenID2 = user2.mint(111);
        uint256 tokenID3 = user3.mint(7);
        assertReserveAndExcessZero(stakeNFT, 3333 + 111 + 7, 0 ether);
        setBlockNumber(block.number+2);

        uint256 credits = 0;
        uint256 debits = 0;
        {
            for (uint256 i =0; i < 37; i++){
                donator.depositEth(7 ether);
                credits += 7 ether;
                uint256 payout = user1.collectEth(tokenID1);
                debits += payout;
                uint256 payout2 = user2.collectEth(tokenID2);
                debits += payout2;
                uint256 payout3 = user3.collectEth(tokenID3);
                debits += payout3;
            }
            {
                emit log_named_uint("Balance ETH: ", address(stakeNFT).balance);
                (, uint256 slush) = stakeNFT.getEthAccumulator();
                // As long as all the users have withdrawal their dividends this should hold true
                assertEq(slush, (credits - debits) * 10**18);
                assertReserveAndExcessZero(stakeNFT, 3333 + 111 + 7, (credits - debits));
            }
            {
                donator.depositEth(credits);
                credits += credits;
                uint256 payout = user1.collectEth(tokenID1);
                debits += payout;
                uint256 payout2 = user2.collectEth(tokenID2);
                debits += payout2;
                uint256 payout3 = user3.collectEth(tokenID3);
                debits += payout3;
                (, uint256 slush) = stakeNFT.getEthAccumulator();
                assertEq(slush, (credits - debits) * 10**18);
                assertReserveAndExcessZero(stakeNFT, 3333 + 111 + 7, (credits - debits));
            }
        }
        {
            donator.depositEth(13457811);
            credits += 13457811;
            uint256 payout = user1.collectEth(tokenID1);
            debits += payout;
            uint256 payout2 = user2.collectEth(tokenID2);
            debits += payout2;
            uint256 payout3 = user3.collectEth(tokenID3);
            debits += payout3;
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(slush, (credits - debits) * 10**18);
            assertReserveAndExcessZero(stakeNFT, 3333 + 111 + 7, (credits - debits));
        }
        {
            donator.depositEth(1381_209873167895423687);
            credits += 1381_209873167895423687;
            uint256 payout = user1.collectEth(tokenID1);
            debits += payout;
            uint256 payout2 = user2.collectEth(tokenID2);
            debits += payout2;
            uint256 payout3 = user3.collectEth(tokenID3);
            debits += payout3;
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            // As long as all the users have withdrawal their dividends this should hold true
            assertEq(slush, (credits - debits) * 10**18);
            assertReserveAndExcessZero(stakeNFT, 3333 + 111 + 7, (credits - debits));
        }
        {
            donator.depositEth(1111_209873167895423687);
            credits += 1111_209873167895423687;
            uint256 payout = user1.collectEth(tokenID1);
            debits += payout;
            uint256 payout2 = user2.collectEth(tokenID2);
            debits += payout2;
            donator.depositEth(11_209873167895423687);
            credits += 11_209873167895423687;
            payout = user1.collectEth(tokenID1);
            debits += payout;
            donator.depositEth(156_209873167895423687);
            credits += 156_209873167895423687;
            payout = user1.collectEth(tokenID1);
            debits += payout;
            payout2 = user2.collectEth(tokenID2);
            debits += payout2;
            uint256 payout3 = user3.collectEth(tokenID3);
            debits += payout3;
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            // As long as all the users have withdrawal their dividends this should hold true
            assertEq(slush, (credits - debits) * 10**18);
            assertReserveAndExcessZero(stakeNFT, 3333 + 111 + 7, (credits - debits));
        }
    }


    function test_CollectTokensAndBurnPositionWithMultipleUsersSameProportion() public {
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
        payable(address(donator)).transfer(1000 ether);
        setBlockNumber(block.number+2);
        uint256 sharesPerUser = 100;
        uint256 tokenID1 = user1.mint(sharesPerUser);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID1),
            StakeNFT.Position(100, 1, 1, 0, 0)
        );
        assertReserveAndExcessZero(stakeNFT, 100, 0 ether);

        {
            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
        }

        donator.depositToken(50);
        assertReserveAndExcessZero(stakeNFT, 150, 0 ether);
        {
            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(
                acc,
                (50 * stakeNFT.accumulatorScaleFactor()) / sharesPerUser
            );
            assertEq(acc, 500000000000000000);
            assertEq(slush, 0);
            assertEq(
                slush + (acc * sharesPerUser),
                50 * stakeNFT.accumulatorScaleFactor()
            );
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
            assertReserveAndExcessZero(stakeNFT, 100, 0 ether);
            assertEq(
                madToken.balanceOf(address(stakeNFT)),
                stakeBalance - payout
            );

            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 500000000000000000);
            assertEq(slush, 0);

            assertPosition(
                getCurrentPosition(stakeNFT, tokenID1),
                StakeNFT.Position(100, 1, 1, 0, 500000000000000000)
            );
        }

        uint256 tokenID2 = user2.mint(sharesPerUser);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID2),
            StakeNFT.Position(100, 1, 1, 0, 500000000000000000)
        );
        assertReserveAndExcessZero(stakeNFT, 200, 0 ether);
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
            assertReserveAndExcessZero(stakeNFT, 700, 0 ether);

            uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
            assertEq(payout, 250);
            payout = user1.collectToken(tokenID1);
            assertEq(payout, 250);

            assertEq(madToken.balanceOf(address(user1)), 300);
            assertEq(madToken.balanceOf(address(stakeNFT)), 450);
            assertReserveAndExcessZero(stakeNFT, 450, 0 ether);
            assertEq(
                madToken.balanceOf(address(stakeNFT)),
                stakeBalance - payout
            );

            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 3_000000000000000000);
            assertEq(slush, 0);

            assertPosition(
                getCurrentPosition(stakeNFT, tokenID1),
                StakeNFT.Position(100, 1, 1, 0, 3_000000000000000000)
            );
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
            assertReserveAndExcessZero(stakeNFT, 200, 0 ether);
            assertEq(
                madToken.balanceOf(address(stakeNFT)),
                stakeBalance - payout2
            );

            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 0);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 3_000000000000000000);
            assertEq(slush, 0);

            assertPosition(
                getCurrentPosition(stakeNFT, tokenID2),
                StakeNFT.Position(100, 1, 1, 0, 3_000000000000000000)
            );
        }

        uint256 tokenID3 = user3.mint(sharesPerUser);
        assertReserveAndExcessZero(stakeNFT, 300, 0 ether);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID3),
            StakeNFT.Position(100, 1, 1, 0, 3_000000000000000000)
        );

        donator.depositToken(1000);
        assertReserveAndExcessZero(stakeNFT, 1300, 0 ether);
        {
            uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
            assertEq(payout, 333);
            payout = user1.collectToken(tokenID1);
            assertEq(payout, 333);
            assertReserveAndExcessZero(stakeNFT, 967, 0 ether);
            uint256 payout2 = stakeNFT.estimateTokenCollection(tokenID2);
            assertEq(payout2, 333);
            payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 333);
            assertReserveAndExcessZero(stakeNFT, 634, 0 ether);
            uint256 payout3 = stakeNFT.estimateTokenCollection(tokenID3);
            assertEq(payout3, 333);
            payout3 = user3.collectToken(tokenID3);
            assertEq(payout3, 333);
            assertReserveAndExcessZero(stakeNFT, 301, 0 ether);
        }
        {
            donator.depositToken(1000);
            assertReserveAndExcessZero(stakeNFT, 1301, 0 ether);
            uint256 payout = user1.collectToken(tokenID1);
            assertEq(payout, 333);
            assertReserveAndExcessZero(stakeNFT, 968, 0 ether);
            uint256 payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 333);
            assertReserveAndExcessZero(stakeNFT, 635, 0 ether);
        }

        {
            donator.depositToken(3000 - 999 - 333 - 2);
            assertReserveAndExcessZero(stakeNFT, 2301, 0 ether);
            uint256 payout = stakeNFT.estimateTokenCollection(tokenID1);
            assertEq(payout, 555);
            payout = user1.collectToken(tokenID1);
            assertEq(payout, 555);
            assertReserveAndExcessZero(stakeNFT, 1746, 0 ether);
            uint256 payout2 = stakeNFT.estimateTokenCollection(tokenID2);
            assertEq(payout2, 555);
            payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 555);
            assertReserveAndExcessZero(stakeNFT, 1191, 0 ether);
            uint256 payout3 = stakeNFT.estimateTokenCollection(tokenID3);
            assertEq(payout3, 889);
            payout3 = user3.collectToken(tokenID3);
            assertEq(payout3, 889);
            assertReserveAndExcessZero(stakeNFT, 302, 0 ether);
        }

        {
            setBlockNumber(block.number+2);
            donator.depositEth(1000 ether);
            assertReserveAndExcessZero(stakeNFT, 302, 1000 ether);
            (uint256 payoutEth, uint256 payoutToken) = user1.burn(tokenID1);
            assertEq(payoutEth, 333_333333333333333333);
            assertEq(payoutToken, 100);
            assertEq(stakeNFT.balanceOf(address(user1)), 0);
            assertEq(address(user1).balance, 333_333333333333333333);
            assertReserveAndExcessZero(stakeNFT, 202, 666_666666666666666667);

            (payoutEth, payoutToken) = user2.burn(tokenID2);
            assertEq(payoutEth, 333_333333333333333333);
            assertEq(payoutToken, 100);
            assertEq(stakeNFT.balanceOf(address(user2)), 0);
            assertEq(address(user2).balance, 333_333333333333333333);
            assertReserveAndExcessZero(stakeNFT, 102, 333_333333333333333334);


            // last user gets the slush as well
            (payoutEth, payoutToken) = user3.burn(tokenID3);
            assertEq(payoutEth, 333_333333333333333334);
            assertEq(payoutToken, 102);
            assertEq(stakeNFT.balanceOf(address(user3)), 0);
            assertEq(address(user3).balance, 333_333333333333333334);
            assertReserveAndExcessZero(stakeNFT, 0, 0);
        }
        {
            (uint256 acc, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(acc, 3333333333333333333333333333333333333);
            assertEq(slush, 0);
            (acc, slush) = stakeNFT.getTokenAccumulator();
            assertEq(acc, 15227777777777777777);
            assertEq(slush, 0);
            assertEq(madToken.balanceOf(address(stakeNFT)), 0);
            assertEq(address(stakeNFT).balance, 0);
        }
    }

    function testBurnWithTripCB() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            AdminAccount admin,

        ) = getFixtureData();
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
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID1),
            StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertReserveAndExcessZero(stakeNFT, 1000 * ONE_MADTOKEN, 0);
        uint256 tokenID2 = user2.mint(800 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID2),
            StakeNFT.Position(uint224(800 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertReserveAndExcessZero(stakeNFT, 1800 * ONE_MADTOKEN, 0);

        // depositing to move the accumulators
        donator.depositToken(1800 * ONE_MADTOKEN);
        donator.depositEth(1800 ether);
        assertReserveAndExcessZero(stakeNFT, 3600 * ONE_MADTOKEN, 1800 ether);

        setBlockNumber(block.number + 2);
        // minting one more position to user 2
        uint256 tokenID3 = user2.mint(200 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID3),
            StakeNFT.Position(uint224(200 * ONE_MADTOKEN), 1, 1, 10**18, 10**18)
        );
        assertReserveAndExcessZero(stakeNFT, 3800 * ONE_MADTOKEN, 1800 ether);

        donator.depositEth(200 ether);
        donator.depositToken(200 * ONE_MADTOKEN);
        assertReserveAndExcessZero(stakeNFT, 4000 * ONE_MADTOKEN, 2000 ether);

        assertEq(madToken.balanceOf(address(user1)), 0);
        assertEq(madToken.balanceOf(address(user2)), 0);
        assertEq(stakeNFT.balanceOf(address(user1)), 1);
        assertEq(stakeNFT.balanceOf(address(user2)), 2);
        assertEq(address(user1).balance, 0 ether);
        assertEq(address(user2).balance, 0 ether);
        assertEq(madToken.balanceOf(address(stakeNFT)), 4000 * ONE_MADTOKEN);
        assertEq(address(stakeNFT).balance, 2000 ether);

        setBlockNumber(block.number + 2);

        //e.g bug was found so we needed to trip the Circuit breaker
        admin.tripCB();

        // Only burn (which uses both collect) should work now
        (uint256 payoutEth, uint256 payoutToken) = user1.burn(tokenID1);
        assertEq(payoutEth, 1100 ether);
        assertEq(payoutToken, 2100 * ONE_MADTOKEN);
        assertEq(stakeNFT.balanceOf(address(user1)), 0);
        assertEq(address(user1).balance, 1100 ether);
        assertEq(madToken.balanceOf(address(user1)), 2100 * ONE_MADTOKEN);
        assertReserveAndExcessZero(stakeNFT, 1900 * ONE_MADTOKEN, 900 ether);

        (payoutEth, payoutToken) = user2.burn(tokenID2);
        assertEq(payoutEth, 880 ether);
        assertEq(payoutToken, 1680 * ONE_MADTOKEN);
        assertEq(stakeNFT.balanceOf(address(user2)), 1);
        assertEq(address(user2).balance, 880 ether);
        assertEq(madToken.balanceOf(address(user2)), 1680 * ONE_MADTOKEN);
        assertReserveAndExcessZero(stakeNFT, 220 * ONE_MADTOKEN, 20 ether);

        (payoutEth, payoutToken) = user2.burn(tokenID3);
        assertEq(payoutEth, 20 ether);
        assertEq(payoutToken, 220 * ONE_MADTOKEN);
        assertEq(stakeNFT.balanceOf(address(user2)), 0);
        assertEq(address(user2).balance, 900 ether);
        assertEq(madToken.balanceOf(address(user2)), 1900 * ONE_MADTOKEN);

        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertReserveAndExcessZero(stakeNFT, 0, 0 ether);
    }

    function test_MintCollectBurnALot() public {
        (StakeNFT stakeNFT, MadTokenMock madToken,,) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        madToken.transfer(address(donator), 10000000 * ONE_MADTOKEN);
        donator.approve(address(stakeNFT), 10000000 * ONE_MADTOKEN);
        payable(address(donator)).transfer(100000 ether);

        UserAccount[50] memory users;
        uint256[100] memory tokenIDs;
        uint256 j=0;
        uint256 iterations = 21;
        uint256 reserveEth = 0;
        uint256 reserveToken = 0;
        // Minting a lot
        for (uint256 i=0; i < iterations; i++){
            users[i] = newUserAccount(madToken, stakeNFT);
            madToken.transfer(address(users[i]), (1_000_000 * ONE_MADTOKEN)+i);
            users[i].approve(address(stakeNFT), (1_000_000 * ONE_MADTOKEN)+i);
            tokenIDs[j] = users[i].mint((500_000 * ONE_MADTOKEN)-i);
            reserveToken += (500_000 * ONE_MADTOKEN)-i;
            tokenIDs[j+1] = users[i].mint((500_000 * ONE_MADTOKEN)+i);
            reserveToken += (500_000 * ONE_MADTOKEN)+i;
            j += 2;
        }
        assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
        setBlockNumber(block.number+2);
        j=0;
        // depositing and collecting some
        for (uint256 i=0; i < iterations; i++){
            if (i % 3 == 0){
                donator.depositEth(i * 1 ether);
                reserveEth += i * 1 ether;
                donator.depositToken(i * ONE_MADTOKEN);
                reserveToken += i * ONE_MADTOKEN;
                reserveEth -= users[i].collectEth(tokenIDs[j]);
                reserveToken -= users[i].collectToken(tokenIDs[j]);
                reserveEth -= users[i].collectEth(tokenIDs[j+1]);
                reserveToken -= users[i].collectToken(tokenIDs[j+1]);
            }
            j += 2;
        }
        assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
        setBlockNumber(block.number+2);
        j=0;
        // burning some amount of Positions
        for (uint256 i=0; i < iterations; i++){
            if (i % 7 == 0){
                (uint256 payoutEth, uint256 payoutToken) = users[i].burn(tokenIDs[j]);
                reserveToken -= payoutToken;
                reserveEth -= payoutEth;
                (payoutEth, payoutToken) = users[i].burn(tokenIDs[j+1]);
                reserveToken -= payoutToken;
                reserveEth -= payoutEth;
            }
            j += 2;
        }
        assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
        setBlockNumber(block.number+2);
        j=0;
        //mint more tokens again
        for (uint256 i=0; i < iterations; i++){
            if (i % 7 == 0){
                users[i] = newUserAccount(madToken, stakeNFT);
                madToken.transfer(address(users[i]), (1_000_000 * ONE_MADTOKEN)+i);
                users[i].approve(address(stakeNFT), (1_000_000 * ONE_MADTOKEN)+i);
                tokenIDs[j] = users[i].mint((500_000 * ONE_MADTOKEN)-i);
                reserveToken += (500_000 * ONE_MADTOKEN)-i;
                tokenIDs[j+1] = users[i].mint((500_000 * ONE_MADTOKEN)+i);
                reserveToken += (500_000 * ONE_MADTOKEN)+i;
                donator.depositEth(i * 1 ether);
                reserveEth += i * 1 ether;
                donator.depositToken(i * ONE_MADTOKEN);
                reserveToken += i * ONE_MADTOKEN;
            }
            j +=2;
        }
        assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
        setBlockNumber(block.number+2);
        j=0;
        // collecting all the existing tokens
        for (uint256 i=0; i < iterations; i++){
            reserveEth -= users[i].collectEth(tokenIDs[j]);
            reserveToken -= users[i].collectToken(tokenIDs[j]);
            reserveEth -= users[i].collectEth(tokenIDs[j+1]);
            reserveToken -= users[i].collectToken(tokenIDs[j+1]);
            j += 2;
        }
        assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
        j=0;
        // burning all token expect 1
        for (uint256 i=0; i < iterations-1; i++){
            (uint256 payoutEth, uint256 payoutToken) = users[i].burn(tokenIDs[j]);
            reserveToken -= payoutToken;
            reserveEth -= payoutEth;
            assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
            (payoutEth, payoutToken) = users[i].burn(tokenIDs[j+1]);
            reserveToken -= payoutToken;
            reserveEth -= payoutEth;
            assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
            j += 2;
        }
        assertReserveAndExcessZero(stakeNFT, reserveToken, reserveEth);
        users[iterations-1].burn(tokenIDs[(iterations-1)*2]);
        users[iterations-1].burn(tokenIDs[(iterations-1)*2+1]);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertEq(address(stakeNFT).balance, 0);
        assertEq(stakeNFT.getTotalShares(), 0);
        assertReserveAndExcessZero(stakeNFT, 0, 0);
    }

    function testFail_CollectNonOwnedToken() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 1000 * ONE_MADTOKEN);
        user1.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);

        // minting
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID1),
            StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user2.collectToken(tokenID1);
    }

    function testFail_CollectNonOwnedEth() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 1000 * ONE_MADTOKEN);
        user1.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);

        // minting
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID1),
            StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user2.collectEth(tokenID1);
    }

    function testFail_BurnNonOwnedPosition() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 1000 * ONE_MADTOKEN);
        user1.approve(address(stakeNFT), 1000 * ONE_MADTOKEN);

        // minting
        uint256 tokenID1 = user1.mint(1000 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID1),
            StakeNFT.Position(uint224(1000 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user2.burn(tokenID1);
    }

    function testFail_estimateEthCollectionNonExistentToken() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.estimateEthCollection(100);
    }

    function testFail_estimateTokenCollectionNonExistentToken() public {
        (StakeNFT stakeNFT, , , ) = getFixtureData();
        stakeNFT.estimateTokenCollection(100);
    }

    function testCollectTokensWithOverflowOnTheAccumulator() public {
        (
            StakeNFTHugeAccumulator stakeNFTHugeAcc,
            MadTokenMock madToken,
            ,

        ) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);
        madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN);

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        donator.approve(address(stakeNFTHugeAcc), 210_000_000 * ONE_MADTOKEN);

        uint256 expectedAccumulatorToken = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID1),
            StakeNFT.Position(
                user1Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares, 0);
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getTokenAccumulator();
        assertEq(acc, expectedAccumulatorToken);
        assertEq(slush, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25;
        donator.depositToken(deposit1);
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + deposit1, 0);
        expectedAccumulatorToken +=
            (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
            user1Shares;

        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID2),
            StakeNFT.Position(
                user2Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        {
            (uint256 acc_, uint256 slush_) = stakeNFTHugeAcc
                .getTokenAccumulator();
            assertEq(acc_, expectedAccumulatorToken);
            assertEq(slush_, 0);
        }
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + deposit1 + user2Shares, 0);

        // the overflow should happen here. As we are incrementing the accumulator by 150 * 10**16
        uint256 deposit2 = 150;
        donator.depositToken(deposit2);
        expectedAccumulatorToken +=
            (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
            (user1Shares + user2Shares);
        expectedAccumulatorToken -= type(uint168).max;
        (acc, slush) = stakeNFTHugeAcc.getTokenAccumulator();
        assertEq(acc, expectedAccumulatorToken);
        assertEq(acc, 1000000000000000000);
        assertEq(slush, 0);
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + deposit1 + user2Shares + deposit2, 0);

        setBlockNumber(block.number+2);

        // Testing collecting the dividends after the accumulator overflow Each
        // user has to call collect twice to get the right amount of funds
        // (before and after the overflow)
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID1), 100);
        assertReserveAndExcessZero(stakeNFTHugeAcc, 275, 0);
        assertEq(user1.collectToken(tokenID1), 100);

        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID2), 75);
        assertEq(user2.collectToken(tokenID2), 75);
        assertReserveAndExcessZero(stakeNFTHugeAcc, 100, 0);
    }

    function testBurnTokensWithOverflowOnTheAccumulator() public {
        (
            StakeNFTHugeAccumulator stakeNFTHugeAcc,
            MadTokenMock madToken,
            ,

        ) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);
        madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN);

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        donator.approve(address(stakeNFTHugeAcc), 210_000_000 * ONE_MADTOKEN);

        uint256 expectedAccumulatorToken = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID1),
            StakeNFT.Position(
                user1Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getTokenAccumulator();
        assertEq(acc, expectedAccumulatorToken);
        assertEq(slush, 0);
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25;
        donator.depositToken(deposit1);
        expectedAccumulatorToken +=
            (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
            user1Shares;
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + deposit1, 0);
        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID2),
            StakeNFT.Position(
                user2Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + deposit1 + user2Shares, 0);
        {
            (uint256 acc_, uint256 slush_) = stakeNFTHugeAcc
                .getTokenAccumulator();
            assertEq(acc_, expectedAccumulatorToken);
            assertEq(slush_, 0);
        }

        {
            // the overflow should happen here as we are incrementing the accumulator by 150 * 10**16
            uint256 deposit2 = 150;
            donator.depositToken(deposit2);
            expectedAccumulatorToken +=
                (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
                (user1Shares + user2Shares);
            expectedAccumulatorToken -= type(uint168).max;
            (acc, slush) = stakeNFTHugeAcc.getTokenAccumulator();
            assertEq(acc, expectedAccumulatorToken);
            assertEq(acc, 1000000000000000000);
            assertEq(slush, 0);
            assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + deposit1 + user2Shares + deposit2, 0);
        }

        //setBlockNumber(block.number+2);

        // Testing collecting the dividends after the accumulator overflow
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID1), 100);
        assertEq(stakeNFTHugeAcc.estimateTokenCollection(tokenID2), 75);
        // advance block number
        require(setBlockNumber(block.number + 2));
        {
            assertReserveAndExcessZero(stakeNFTHugeAcc, 275, 0);
            (, uint256 payoutToken1) = user1.burn(tokenID1);
            assertEq(payoutToken1, 150);
            assertReserveAndExcessZero(stakeNFTHugeAcc, 125, 0);
        }
        {
            (, uint256 payoutToken2) = user2.burn(tokenID2);
            assertEq(payoutToken2, 125);
        }
        assertReserveAndExcessZero(stakeNFTHugeAcc, 0, 0);
    }

    function testCollectEtherWithOverflowOnTheAccumulator() public {
        (
            StakeNFTHugeAccumulator stakeNFTHugeAcc,
            MadTokenMock madToken,
            ,

        ) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        payable(address(donator)).transfer(1000);

        uint256 expectedAccumulatorToken = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID1),
            StakeNFT.Position(
                user1Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares, 0);
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(slush, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25; //wei
        donator.depositEth(deposit1);
        expectedAccumulatorETH +=
            (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
            user1Shares;
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares, deposit1);

        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID2),
            StakeNFT.Position(
                user2Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        {
            (uint256 acc_, uint256 slush_) = stakeNFTHugeAcc.getEthAccumulator();
            assertEq(acc_, expectedAccumulatorETH);
            assertEq(slush_, 0);
        }
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + user2Shares, deposit1);
        // the overflow should happen here as we are incrementing the accumulator by 150 * 10**16
        uint256 deposit2 = 150; //wei
        donator.depositEth(deposit2);
        expectedAccumulatorETH +=
            (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
            (user1Shares + user2Shares);
        expectedAccumulatorETH -= type(uint168).max;
        (acc, slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(acc, 1000000000000000000);
        assertEq(slush, 0);
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + user2Shares, deposit1 + deposit2);

        setBlockNumber(block.number+2);

        // Testing collecting the dividends after the accumulator overflow
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID1), 100);
        assertEq(user1.collectEth(tokenID1), 100);
        assertReserveAndExcessZero(stakeNFTHugeAcc, 100, 75);
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID2), 75);
        assertEq(user2.collectEth(tokenID2), 75);
        assertReserveAndExcessZero(stakeNFTHugeAcc, 100, 0);
    }

    function testBurnEtherWithOverflowOnTheAccumulator() public {
        (
            StakeNFTHugeAccumulator stakeNFTHugeAcc,
            MadTokenMock madToken,
            ,

        ) = getFixtureDataWithHugeAccumulator();
        UserAccount user1 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount user2 = newUserAccount(madToken, stakeNFTHugeAcc);
        UserAccount donator = newUserAccount(madToken, stakeNFTHugeAcc);

        madToken.transfer(address(user1), 100);
        madToken.transfer(address(user2), 100);

        user1.approve(address(stakeNFTHugeAcc), 100);
        user2.approve(address(stakeNFTHugeAcc), 100);
        payable(address(donator)).transfer(1000);

        uint256 expectedAccumulatorToken = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint256 expectedAccumulatorETH = type(uint168).max -
            stakeNFTHugeAcc.getOffsetToOverflow();
        uint224 user1Shares = 50;
        uint256 tokenID1 = user1.mint(user1Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID1),
            StakeNFT.Position(
                user1Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares, 0);
        (uint256 acc, uint256 slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(slush, 0);

        //moving the accumulator closer to the overflow
        uint256 deposit1 = 25; //wei
        donator.depositEth(deposit1);
        expectedAccumulatorETH +=
            (deposit1 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
            user1Shares;
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares, deposit1);
        uint224 user2Shares = 50;
        uint256 tokenID2 = user2.mint(user2Shares);
        assertPosition(
            getCurrentPosition(stakeNFTHugeAcc, tokenID2),
            StakeNFT.Position(
                user2Shares,
                1,
                1,
                expectedAccumulatorETH,
                expectedAccumulatorToken
            )
        );
        {
            (uint256 acc_, uint256 slush_) = stakeNFTHugeAcc
                .getEthAccumulator();
            assertEq(acc_, expectedAccumulatorETH);
            assertEq(slush_, 0);
        }
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + user2Shares, deposit1);

        // the overflow should happen here. As we are incrementing the accumulator by 150 * 10**16
        uint256 deposit2 = 150; //wei
        donator.depositEth(deposit2);
        expectedAccumulatorETH +=
            (deposit2 * stakeNFTHugeAcc.accumulatorScaleFactor()) /
            (user1Shares + user2Shares);
        expectedAccumulatorETH -= type(uint168).max;
        (acc, slush) = stakeNFTHugeAcc.getEthAccumulator();
        assertEq(acc, expectedAccumulatorETH);
        assertEq(acc, 1000000000000000000);
        assertEq(slush, 0);
        assertReserveAndExcessZero(stakeNFTHugeAcc, user1Shares + user2Shares, deposit1 + deposit2);

        //setBlockNumber(block.number+2);

        // Testing collecting the dividends after the accumulator overflow Each
        // user has to call collect twice to get the right amount of funds
        // (before and after the overflow)
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID1), 100);
        assertEq(stakeNFTHugeAcc.estimateEthCollection(tokenID2), 75);
        // advance block number
        require(setBlockNumber(block.number + 2));
       {
            (uint256 payoutEth1, uint256 payoutToken1) = user1.burn(tokenID1);
            assertEq(payoutEth1, 100);
            assertEq(payoutToken1, 50);
        }
        assertReserveAndExcessZero(stakeNFTHugeAcc, 50, 75);
        {
            (uint256 payoutEth2, uint256 payoutToken2) = user2.burn(tokenID2);
            assertEq(payoutEth2, 75);
            assertEq(payoutToken2, 50);
        }
        assertReserveAndExcessZero(stakeNFTHugeAcc, 0, 0);
    }

    function testLockPosition() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        assertReserveAndExcessZero(stakeNFT, 1000, 0);

        governance.lockPosition(address(user), tokenID, 172800);
    }

    function testLockPositionAndBurn() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        assertReserveAndExcessZero(stakeNFT, 1000, 0);

        governance.lockPosition(address(user), tokenID, 172800);
        setBlockNumber(block.number + 172801);
        (uint256 payoutEth, uint256 payoutToken) = user.burn(tokenID);
        assertEq(payoutEth, 0);
        assertEq(payoutToken, 1000);

        assertEq(madToken.balanceOf(address(user)), 1000);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
        assertEq(stakeNFT.balanceOf(address(user)), 0);
        assertReserveAndExcessZero(stakeNFT, 0, 0);
    }

    function testFail_LockPositionAndTryToBurnBeforeLockHasFinished() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 800);

        setBlockNumber(block.number + 750);

        user.burn(tokenID);
    }

    function testFail_LockPositionNotTheOwner() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(this), tokenID, 1);
    }

    function testFail_LockPositionInvalidLockHeight() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 172800 + 1);
    }

    function testFail_LockNonExistentPosition() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        governance.lockPosition(address(user), 4, 172800);
    }

    function testFail_ReentrantLoopCollectEth() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        ReentrantLoopEthCollectorAccount user = new ReentrantLoopEthCollectorAccount();
        user.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user), 100);
        //madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN );

        user.approve(address(stakeNFT), 100);
        //donator.approve(address(stakeNFT), 210_000_000 * ONE_MADTOKEN);

        //payable(address(user)).transfer(2000 ether);
        payable(address(donator)).transfer(2000 ether);

        uint256 tokenID = user.mint(100);
        setBlockNumber(block.number+2);
        donator.depositEth(1000 ether);

        user.collectEth(tokenID);

        // it should not get here
    }

    function test_ReentrantFiniteCollectEth() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        UserAccount honestUser = newUserAccount(madToken, stakeNFT);
        ReentrantFiniteEthCollectorAccount user = new ReentrantFiniteEthCollectorAccount();
        user.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user), 100);
        madToken.transfer(address(honestUser), 100);

        user.approve(address(stakeNFT), 100);
        honestUser.approve(address(stakeNFT), 100);

        payable(address(donator)).transfer(2000 ether);

        uint256 tokenID = user.mint(100);
        uint256 honestTokenID = honestUser.mint(100);
        setBlockNumber(block.number+2);
        donator.depositEth(1000 ether);
        // the result with re-entrance should be the same as calling collectEth only once
        uint256 payout = user.collectEth(tokenID);
        assertEq(payout, 500 ether);
        assertEq(address(user).balance, 500 ether);
        payout = honestUser.collectEth(honestTokenID);
        assertEq(payout, 500 ether);
        assertEq(address(honestUser).balance, 500 ether);
    }

    function testFail_ReentrantLoopBurn() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        ReentrantLoopBurnAccount user = new ReentrantLoopBurnAccount();
        user.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user), 100);
        //madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN );

        user.approve(address(stakeNFT), 100);
        //donator.approve(address(stakeNFT), 210_000_000 * ONE_MADTOKEN);

        //payable(address(user)).transfer(2000 ether);
        payable(address(donator)).transfer(2000 ether);

        uint256 tokenID = user.mint(100);
        setBlockNumber(block.number+2);
        donator.depositEth(1000 ether);

        user.burn(tokenID);

        // it should not get here
    }

    function testFail_ReentrantFiniteBurn() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        ReentrantFiniteBurnAccount user = new ReentrantFiniteBurnAccount();
        user.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user), 100);
        //madToken.transfer(address(donator), 210_000_000 * ONE_MADTOKEN );

        user.approve(address(stakeNFT), 100);
        //donator.approve(address(stakeNFT), 210_000_000 * ONE_MADTOKEN);

        //payable(address(user)).transfer(2000 ether);
        payable(address(donator)).transfer(2000 ether);

        uint256 tokenID = user.mint(100);

        donator.depositEth(1000 ether);
        setBlockNumber(block.number+2);
        user.burn(tokenID);

        // it should not get here

        //assertEq(payout, 1000 ether);

        //assertEq(address(user).balance, 1000 ether);
    }


    function testFail_SafeTransferPosition_WithoutApproval() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        user1.approve(address(stakeNFT), 100);
        uint256 tokenID = user1.mint(100);

        stakeNFT.safeTransferFrom(address(user1), address(user2), tokenID);
    }

    function testFail_SafeTransferPosition_toNonERC721Receiver() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        user1.approve(address(stakeNFT), 100);
        uint256 tokenID = user1.mint(100);

        setBlockNumber(block.number+2);

        user1.approveNFT(address(this), tokenID);

        stakeNFT.safeTransferFrom(address(user1), address(user2), tokenID);
    }

    function testSafeTransferPosition_toERC721Receiver() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        ERC721ReceiverAccount user2 = new ERC721ReceiverAccount();
        user2.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        user1.approve(address(stakeNFT), 100);
        uint256 tokenID = user1.mint(100);
        assertReserveAndExcessZero(stakeNFT, 100, 0);

        setBlockNumber(block.number+2);

        user1.approveNFT(address(this), tokenID);

        stakeNFT.safeTransferFrom(address(user1), address(user2), tokenID);

        assertEq(stakeNFT.ownerOf(tokenID), address(user2));
        assertEq(stakeNFT.balanceOf(address(user1)), 0);
        assertEq(stakeNFT.balanceOf(address(user2)), 1);
        assertEq(stakeNFT.balanceOf(address(stakeNFT)), 0);
        assertReserveAndExcessZero(stakeNFT, 100, 0);
    }

    function testFail_SafeTransferPosition_toReentrantLoopBurnERC721Receiver() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        ReentrantLoopBurnERC721ReceiverAccount user2 = new ReentrantLoopBurnERC721ReceiverAccount();
        user2.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        user1.approve(address(stakeNFT), 100);
        uint256 tokenID = user1.mint(100);

        payable(donator).transfer(100 ether);
        donator.depositEth(100 ether);

        setBlockNumber(block.number+2);

        user1.approveNFT(address(this), tokenID);
        stakeNFT.safeTransferFrom(address(user1), address(user2), tokenID);
    }

    function testFail_SafeTransferPosition_toReentrantFiniteBurnERC721Receiver() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        ReentrantFiniteBurnERC721ReceiverAccount user2 = new ReentrantFiniteBurnERC721ReceiverAccount();
        user2.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        user1.approve(address(stakeNFT), 100);
        uint256 tokenID = user1.mint(100);

        payable(donator).transfer(100 ether);
        donator.depositEth(100 ether);

        setBlockNumber(block.number+2);

        user1.approveNFT(address(this), tokenID);
        stakeNFT.safeTransferFrom(address(user1), address(user2), tokenID);
    }

    function testSafeTransferPosition_toReentrantLoopCollectEthERC721Receiver() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        ReentrantLoopCollectEthERC721ReceiverAccount user2 = new ReentrantLoopCollectEthERC721ReceiverAccount();
        user2.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user1), 100);
        user1.approve(address(stakeNFT), 100);
        uint256 tokenID = user1.mint(100);

        payable(donator).transfer(100 ether);
        donator.depositEth(100 ether);

        setBlockNumber(block.number+2);

        user1.approveNFT(address(this), tokenID);
        stakeNFT.safeTransferFrom(address(user1), address(user2), tokenID);

        assertEq(stakeNFT.ownerOf(tokenID), address(user2));
        assertEq(stakeNFT.balanceOf(address(user1)), 0);
        assertEq(stakeNFT.balanceOf(address(user2)), 1);
        assertEq(stakeNFT.balanceOf(address(stakeNFT)), 0);

        assertEq(address(user2).balance, 100 ether);
        assertEq(address(user1).balance, 0);
        assertEq(address(donator).balance, 0);
        assertEq(address(stakeNFT).balance, 0);
    }

   function testTransferPosition() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100 * ONE_MADTOKEN);
        madToken.transfer(address(user2), 100 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 100 * ONE_MADTOKEN);
        user2.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 token1User1 = user1.mint(100 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, token1User1),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user1)), 1);
        assertEq(stakeNFT.ownerOf(token1User1), address(user1));
        assertEq(stakeNFT.balanceOf(address(user2)), 0);
        assertReserveAndExcessZero(stakeNFT, 100 * ONE_MADTOKEN, 0);

        user1.transferFrom(address(user1), address(user2), token1User1);

        assertEq(stakeNFT.balanceOf(address(user1)), 0);
        assertEq(stakeNFT.ownerOf(token1User1), address(user2));
        assertEq(stakeNFT.balanceOf(address(user2)), 1);
        assertReserveAndExcessZero(stakeNFT, 100 * ONE_MADTOKEN, 0);
    }

    function testApproveTransferPosition() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100 * ONE_MADTOKEN);
        madToken.transfer(address(user2), 100 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 100 * ONE_MADTOKEN);
        user2.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 token1User1 = user1.mint(100 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, token1User1),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user1)), 1);
        assertEq(stakeNFT.ownerOf(token1User1), address(user1));
        assertEq(stakeNFT.balanceOf(address(user2)), 0);
        assertReserveAndExcessZero(stakeNFT, 100 * ONE_MADTOKEN, 0);

        //approving user2 to transfer user1 token
        user1.approveNFT(address(user2), token1User1);
        user1.transferFrom(address(user1), address(user2), token1User1);

        assertEq(stakeNFT.balanceOf(address(user1)), 0);
        assertEq(stakeNFT.ownerOf(token1User1), address(user2));
        assertEq(stakeNFT.balanceOf(address(user2)), 1);
        assertReserveAndExcessZero(stakeNFT, 100 * ONE_MADTOKEN, 0);
    }

    function testApproveAllTransferPosition() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100 * ONE_MADTOKEN);
        madToken.transfer(address(user2), 100 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 100 * ONE_MADTOKEN);
        user2.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 token1User1 = user1.mint(50 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, token1User1),
            StakeNFT.Position(uint224(50 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user1)), 1);
        assertEq(stakeNFT.ownerOf(token1User1), address(user1));
        assertReserveAndExcessZero(stakeNFT, 50  * ONE_MADTOKEN, 0);

        uint256 token2User1 = user1.mint(50 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, token2User1),
            StakeNFT.Position(uint224(50 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user1)), 2);
        assertEq(stakeNFT.ownerOf(token2User1), address(user1));
        assertEq(stakeNFT.balanceOf(address(user2)), 0);
        assertReserveAndExcessZero(stakeNFT, 100  * ONE_MADTOKEN, 0);

        //approving the test contract to transfer all user1 token
        user1.setApprovalForAll(address(this), true);
        stakeNFT.transferFrom(address(user1), address(user2), token1User1);
        stakeNFT.transferFrom(address(user1), address(this), token2User1);

        assertEq(stakeNFT.balanceOf(address(user1)), 0);
        assertEq(stakeNFT.ownerOf(token1User1), address(user2));
        assertEq(stakeNFT.balanceOf(address(user2)), 1);
        assertEq(stakeNFT.ownerOf(token2User1), address(this));
        assertEq(stakeNFT.balanceOf(address(this)), 1);
        assertReserveAndExcessZero(stakeNFT, 100 * ONE_MADTOKEN, 0);
    }

    function testFail_TransferNotOwnedPositionWithoutApproval() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100 * ONE_MADTOKEN);
        madToken.transfer(address(user2), 100 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 100 * ONE_MADTOKEN);
        user2.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 token1User1 = user1.mint(50 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, token1User1),
            StakeNFT.Position(uint224(50 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user1)), 1);
        assertEq(stakeNFT.ownerOf(token1User1), address(user1));

        // test contract was not approved to run the transfer method
        stakeNFT.transferFrom(address(user1), address(user2), token1User1);
    }

    function testFail_TransferNotOwnedPositionWithoutApproval2() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 100 * ONE_MADTOKEN);
        madToken.transfer(address(user2), 100 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 100 * ONE_MADTOKEN);
        user2.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 token1User1 = user1.mint(50 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, token1User1),
            StakeNFT.Position(uint224(50 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user1)), 1);
        assertEq(stakeNFT.ownerOf(token1User1), address(user1));

        uint256 token2User1 = user1.mint(50 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, token2User1),
            StakeNFT.Position(uint224(50 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user1)), 2);
        assertEq(stakeNFT.ownerOf(token2User1), address(user1));
        assertEq(stakeNFT.balanceOf(address(user2)), 0);

        user1.approveNFT(address(this), token1User1);
        // test contract was not approved to transfer token 2 only token1
        stakeNFT.transferFrom(address(user1), address(user2), token2User1);
    }

    function testFail_BurnLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);

        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user.lockWithdraw(tokenID, 10);

        user.burn(tokenID);
    }

    function testBurnLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);

        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user.lockWithdraw(tokenID, 10);

        setBlockNumber(block.number+11);

        user.burn(tokenID);

        assertEq(madToken.balanceOf(address(user)), 100 * ONE_MADTOKEN);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    function testFail_CollectEthLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);

        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user.lockWithdraw(tokenID, 10);

        user.collectEth(tokenID);
    }

    function testFail_CollectTokensLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);

        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user.lockWithdraw(tokenID, 10);

        user.collectToken(tokenID);
    }

    function testCollectLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);

        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        user.lockWithdraw(tokenID, 10);

        setBlockNumber(block.number+11);

        user.collectEth(tokenID);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 100 * ONE_MADTOKEN);
    }

    function testCollectRewardsAfterMinting() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        payable(address(user2)).transfer(10 ether);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);

        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );

        setBlockNumber(block.number+2);

        user2.depositEth(10 ether);

        user.collectEth(tokenID);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(address(user).balance, 10 ether);
        assertEq(address(user2).balance, 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 100 * ONE_MADTOKEN);
    }

    function testCollectRewardsAfterMintingTo() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        payable(address(user2)).transfer(10 ether);

        madToken.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = stakeNFT.mintTo(address(user), 100 * ONE_MADTOKEN, 10);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 10, 1, 0, 0)
        );

        setBlockNumber(block.number+2);

        user2.depositEth(10 ether);

        user.collectEth(tokenID);

        assertEq(madToken.balanceOf(address(user)), 0);
        assertEq(address(user).balance, 10 ether);
        assertEq(address(user2).balance, 0);
        assertEq(madToken.balanceOf(address(stakeNFT)), 100 * ONE_MADTOKEN);
    }

    function testSkimExcessEth() public {
        // transferring money before the contract is created
        payable(address(0xf5a2fE45F4f1308502b1C136b9EF8af136141382)).transfer(100 ether + 1);
        (StakeNFT stakeNFT, MadTokenMock madToken, AdminAccount admin , ) = getFixtureData();
        assertEq(address(stakeNFT).balance, 100 ether + 1);
        assertReserveAndExcess(stakeNFT, 0, 0, 0, 100 ether + 1);
        UserAccount user = newUserAccount(madToken, stakeNFT);
        assertEq(address(user).balance, 0);
        admin.skimExcessEth(address(user));
        assertEq(address(user).balance, 100 ether + 1);
        assertEq(address(stakeNFT).balance, 0);
    }

    function testSkimExcessToken() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, AdminAccount admin , ) = getFixtureData();
        // transferring Token excess
        madToken.transfer(address(0xf5a2fE45F4f1308502b1C136b9EF8af136141382), 1000 * ONE_MADTOKEN + 1);
        assertEq(madToken.balanceOf(address(stakeNFT)), 1000 * ONE_MADTOKEN + 1);
        assertReserveAndExcess(stakeNFT, 0, 0, 1000 * ONE_MADTOKEN + 1, 0);
        UserAccount user = newUserAccount(madToken, stakeNFT);
        assertEq(madToken.balanceOf(address(user)), 0);
        admin.skimExcessToken(address(user));
        assertEq(madToken.balanceOf(address(user)), 1000 * ONE_MADTOKEN + 1);
        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    function testSkimExcessWithMintBurnCollectAndDeposit() public {
        // transferring money before the contract is created
        payable(address(0xf5a2fE45F4f1308502b1C136b9EF8af136141382)).transfer(100 ether + 1);
        (StakeNFT stakeNFT, MadTokenMock madToken, AdminAccount admin , ) = getFixtureData();
        // transferring Token excess
        madToken.transfer(address(0xf5a2fE45F4f1308502b1C136b9EF8af136141382), 1000 * ONE_MADTOKEN + 1);
        assertEq(address(stakeNFT).balance, 100 ether + 1);
        assertReserveAndExcess(stakeNFT, 0, 0, 1000 * ONE_MADTOKEN + 1, 100 ether + 1);

        UserAccount user1 = newUserAccount(madToken, stakeNFT);
        assertEq(address(user1).balance, 0);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);
        UserAccount user3 = newUserAccount(madToken, stakeNFT);
        UserAccount donator = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user1), 10 * ONE_MADTOKEN);
        madToken.transfer(address(user2), 10 * ONE_MADTOKEN);
        madToken.transfer(address(user3), 10 * ONE_MADTOKEN);
        madToken.transfer(address(donator), 100000 * ONE_MADTOKEN);

        user1.approve(address(stakeNFT), 10 * ONE_MADTOKEN);
        user2.approve(address(stakeNFT), 10 * ONE_MADTOKEN);
        user3.approve(address(stakeNFT), 10 * ONE_MADTOKEN);
        donator.approve(address(stakeNFT), 100000 * ONE_MADTOKEN);
        payable(address(donator)).transfer(100000 ether);

        uint256 sharesPerUser = 10 * ONE_MADTOKEN;
        uint256 tokenID1 = user1.mint(sharesPerUser);
        setBlockNumber(block.number+2);
        {
            uint256 payout = user1.collectToken(tokenID1);
            assertEq(payout, 0);
            payout = user1.collectEth(tokenID1);
            assertEq(payout, 0);
        }
        uint256 tokenID2 = user2.mint(sharesPerUser);
        uint256 tokenID3 = user3.mint(sharesPerUser);
        assertReserveAndExcess(stakeNFT, 30 * ONE_MADTOKEN, 0 ether, 1000 * ONE_MADTOKEN + 1, 100 ether + 1);

        setBlockNumber(block.number+2);

        uint256 credits = 0;
        uint256 debits = 0;
        for (uint256 i =0; i < 2; i++){
            donator.depositEth(1000);
            credits += 1000;
            uint256 payout = user1.collectEth(tokenID1);
            assertEq(payout, 330);
            debits += payout;
            uint256 payout2 = user2.collectEth(tokenID2);
            assertEq(payout2, 330);
            debits += payout2;
            uint256 payout3 = user3.collectEth(tokenID3);
            assertEq(payout3, 330);
            debits += payout3;
        }
        {
            emit log_named_uint("Balance ETH: ", address(stakeNFT).balance);
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(slush, (credits - debits) * 10**18);
            assertReserveAndExcess(stakeNFT, 30 * ONE_MADTOKEN, (credits - debits), 1000 * ONE_MADTOKEN + 1, 100 ether + 1);
        }
        {
            donator.depositEth(2000);
            credits += 2000;
            assertReserveAndExcess(stakeNFT, 30 * ONE_MADTOKEN, (credits - debits), 1000 * ONE_MADTOKEN + 1, 100 ether + 1);
            uint256 payout = user1.collectEth(tokenID1);
            assertEq(payout, 670);
            debits += payout;
            uint256 payout2 = user2.collectEth(tokenID2);
            assertEq(payout2, 670);
            debits += payout2;
            uint256 payout3 = user3.collectEth(tokenID3);
            assertEq(payout3, 670);
            debits += payout3;
        }
        {
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(slush, (credits - debits) * 10**18);
            assertEq(slush, 10 * 10**18);
        }
        {
            donator.depositToken(2000);
            assertReserveAndExcess(stakeNFT, 30 * ONE_MADTOKEN + 2000, (credits - debits), 1000 * ONE_MADTOKEN + 1, 100 ether + 1);
            uint256 payout = user1.collectToken(tokenID1);
            assertEq(payout, 660);
            uint256 payout2 = user2.collectToken(tokenID2);
            assertEq(payout2, 660);
            uint256 payout3 = user3.collectToken(tokenID3);
            assertEq(payout3, 660);
        }
        assertReserveAndExcess(stakeNFT, 30 * ONE_MADTOKEN + 20, (credits - debits), 1000 * ONE_MADTOKEN + 1, 100 ether + 1);
        {
            (, uint256 slush) = stakeNFT.getEthAccumulator();
            assertEq(slush, (credits - debits) * 10**18);
            assertEq(slush, 10 * 10**18);
        }
        {
            (, uint256 slush) = stakeNFT.getTokenAccumulator();
            assertEq(slush, 20 * 10**18);
        }

        assertEq(madToken.balanceOf(address(stakeNFT)), 1000 * ONE_MADTOKEN + 1 + 30 * ONE_MADTOKEN + 20);
        admin.skimExcessToken(address(user2));
        assertEq(madToken.balanceOf(address(user2)), 1000 * ONE_MADTOKEN + 1 + 660);
        assertEq(madToken.balanceOf(address(stakeNFT)), 30 * ONE_MADTOKEN + 20);
        assertReserveAndExcess(stakeNFT, 30 * ONE_MADTOKEN + 20, (credits - debits), 0, 100 ether + 1);

        madToken.transfer(address(0xf5a2fE45F4f1308502b1C136b9EF8af136141382), 100 * ONE_MADTOKEN + 1);
        {
            (uint256 payoutEth, uint256 payoutToken) = user1.burn(tokenID1);
            assertEq(payoutEth, 0);
            assertEq(payoutToken, 10 * ONE_MADTOKEN);
            assertEq(stakeNFT.balanceOf(address(user1)), 0);
            assertReserveAndExcess(stakeNFT, 20 * ONE_MADTOKEN + 20, (credits - debits), 100 * ONE_MADTOKEN + 1, 100 ether + 1);

            (payoutEth, payoutToken) = user2.burn(tokenID2);
            assertEq(payoutEth, 0);
            assertEq(payoutToken, 10 * ONE_MADTOKEN);
            assertEq(stakeNFT.balanceOf(address(user2)), 0);
            assertReserveAndExcess(stakeNFT, 10 * ONE_MADTOKEN + 20, (credits - debits), 100 * ONE_MADTOKEN + 1, 100 ether + 1);


            // last user gets the slush as well
            (payoutEth, payoutToken) = user3.burn(tokenID3);
            assertEq(payoutEth, (credits - debits));
            assertEq(payoutToken, 10 * ONE_MADTOKEN + 20);
            assertEq(stakeNFT.balanceOf(address(user3)), 0);
            assertReserveAndExcess(stakeNFT, 0, 0, 100 * ONE_MADTOKEN + 1, 100 ether + 1);
        }

        assertEq(address(stakeNFT).balance, 100 ether + 1);
        admin.skimExcessEth(address(user1));
        assertEq(address(user1).balance, 1330 + 100 ether + 1);
        assertEq(address(stakeNFT).balance, 0);

        assertEq(madToken.balanceOf(address(stakeNFT)), 100 * ONE_MADTOKEN + 1);
        admin.skimExcessToken(address(user3));
        assertEq(madToken.balanceOf(address(user3)), (100 * ONE_MADTOKEN + 1) + 660 + (10 * ONE_MADTOKEN) + 20);
        assertReserveAndExcess(stakeNFT, 0, 0, 0, 0);

        assertEq(madToken.balanceOf(address(stakeNFT)), 0);
    }

    function test_ReentrantSkimExcessEth() public {
        // transferring money before the contract is created
        payable(address(0xf5a2fE45F4f1308502b1C136b9EF8af136141382)).transfer(100 ether);
        (StakeNFT stakeNFT, MadTokenMock madToken, AdminAccountReEntrant admin, ) = getFixtureDataAdminReEntrant();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        UserAccount honestUser = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(honestUser), 100);
        honestUser.approve(address(stakeNFT), 100);
        payable(address(donator)).transfer(2000 ether);

        uint256 tokenID1 = honestUser.mint(50);
        uint256 TokenID2 = honestUser.mint(50);
        setBlockNumber(block.number+2);
        donator.depositEth(1000 ether);

        // calling with reentrancy should yield the same result as calling it normally
        admin.skimExcessEth(address(admin));
        assertEq(address(admin).balance, 100 ether);

        uint256 payout = honestUser.collectEth(tokenID1);
        assertEq(payout, 500 ether);
        assertEq(address(honestUser).balance, 500 ether);
        payout = honestUser.collectEth(TokenID2);
        assertEq(payout, 500 ether);
        assertEq(address(honestUser).balance, 1000 ether);

    }

    function testFail_ReentrantNoAdmin() public {
        // transferring money before the contract is created
        payable(address(0xf5a2fE45F4f1308502b1C136b9EF8af136141382)).transfer(100 ether);
        (StakeNFT stakeNFT, MadTokenMock madToken, AdminAccount admin , ) = getFixtureData();
        UserAccount donator = newUserAccount(madToken, stakeNFT);
        UserAccount honestUser = newUserAccount(madToken, stakeNFT);
        AdminAccountReEntrant user = new AdminAccountReEntrant();
        user.setTokens(madToken, stakeNFT);

        madToken.transfer(address(user), 100);
        madToken.transfer(address(honestUser), 100);

        user.approve(address(stakeNFT), 100);
        honestUser.approve(address(stakeNFT), 100);

        payable(address(donator)).transfer(2000 ether);

        uint256 tokenID = user.mint(100);
        uint256 honestTokenID = honestUser.mint(100);

        setBlockNumber(block.number+2);
        donator.depositEth(1000 ether);
        admin.skimExcessEth(address(user));
    }

    function testCanEstimateEthWithoutNewBlocks() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);

        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);
        assertEq(stakeNFT.estimateTokenCollection(tokenID), 0);
    }

    function testFail_ExOwnerShouldNotLockWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);
        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        user.transferFrom(address(user), address(user2), tokenID);
        assertEq(stakeNFT.ownerOf(tokenID), address(user2));
        // old user should not be able to withdraw after transfer
        user.lockWithdraw(tokenID, 10);
    }

    function testFail_ExOwnerShouldNotCollectEthLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);
        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        //Old user locks the position
        user.lockWithdraw(tokenID, 10);

        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        user.transferFrom(address(user), address(user2), tokenID);
        assertEq(stakeNFT.ownerOf(tokenID), address(user2));

        // old user trying to collect ETh after transferring the token
        user.collectEth(tokenID);
    }

    function testFail_NewOwnerShouldNotCollectEthLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);
        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        //Old user locks the position
        user.lockWithdraw(tokenID, 10);

        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        user.transferFrom(address(user), address(user2), tokenID);
        assertEq(stakeNFT.ownerOf(tokenID), address(user2));
        setBlockNumber(block.number+9);
        user2.collectEth(tokenID);
    }

    function testFail_NewOwnerShouldNotBurnLockedWithdraw() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);
        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        //Old user locks the position
        user.lockWithdraw(tokenID, 10);

        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        user.transferFrom(address(user), address(user2), tokenID);
        assertEq(stakeNFT.ownerOf(tokenID), address(user2));
        setBlockNumber(block.number+9);
        user2.burn(tokenID);
    }

    function testNewOwnerCanBurnLockedWithdrawOnceItsTime() public {
        (StakeNFT stakeNFT, MadTokenMock madToken, , ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount user2 = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(user), 100 * ONE_MADTOKEN);
        user.approve(address(stakeNFT), 100 * ONE_MADTOKEN);

        uint256 tokenID = user.mint(100 * ONE_MADTOKEN);
        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(uint224(100 * ONE_MADTOKEN), 1, 1, 0, 0)
        );
        //Old user locks the position
        user.lockWithdraw(tokenID, 10);

        assertEq(stakeNFT.ownerOf(tokenID), address(user));
        user.transferFrom(address(user), address(user2), tokenID);
        assertEq(stakeNFT.ownerOf(tokenID), address(user2));

        setBlockNumber(block.number+11);
        user2.burn(tokenID);
    }

    function testCollectAfterLockPosition() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 800);

        setBlockNumber(block.number + 2);

        user.collectEth(tokenID);
    }

    function testLockWithdrawAfterLockPosition() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 800);
        user.lockWithdraw(tokenID, 850);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 800, 850, 0, 0)
        );
    }

    function testFail_LockWithdrawAfterLockPosition() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 800);
        user.lockWithdraw(tokenID, 850);

        setBlockNumber(block.number + 801);

        user.collectEth(tokenID);
    }

    function testCollectAfterLockPosition_AndLater_BurnAfterLockedWithdraw() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 850);
        user.lockWithdraw(tokenID, 800);

        setBlockNumber(block.number + 802);

        user.collectEth(tokenID);

        setBlockNumber(block.number + 51);

        user.burn(tokenID);
    }

    function testCollectAfterLockPosition_AndLater_CollectAfterLockedWithdraw() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        governance.lockPosition(address(user), tokenID, 850);
        user.lockWithdraw(tokenID, 800);

        setBlockNumber(block.number + 801);

        user.collectEth(tokenID);

        setBlockNumber(block.number + 51);

        user.collectEth(tokenID);
    }

    function testCollectAfterLockPosition_AndLater_CollectAndBurnAfterLockedWithdraw() public {
        (
            StakeNFT stakeNFT,
            MadTokenMock madToken,
            ,
            GovernanceAccount governance
        ) = getFixtureData();
        UserAccount user = newUserAccount(madToken, stakeNFT);
        UserAccount donator = newUserAccount(madToken, stakeNFT);

        madToken.transfer(address(donator), 100000 * ONE_MADTOKEN);
        donator.approve(address(stakeNFT), 100000 * ONE_MADTOKEN);
        payable(address(donator)).transfer(100000 ether);

        madToken.approve(address(stakeNFT), 1000);
        uint256 tokenID = stakeNFT.mintTo(address(user), 1000, 0);

        assertPosition(
            getCurrentPosition(stakeNFT, tokenID),
            StakeNFT.Position(1000, 1, 1, 0, 0)
        );
        assertEq(stakeNFT.balanceOf(address(user)), 1);
        assertEq(stakeNFT.ownerOf(tokenID), address(user));

        donator.depositEth(10 ether);
        donator.depositToken(10 * ONE_MADTOKEN);

        governance.lockPosition(address(user), tokenID, 850);
        user.lockWithdraw(tokenID, 800);

        assertEq(stakeNFT.estimateTokenCollection(tokenID), 10 * ONE_MADTOKEN);
        assertEq(stakeNFT.estimateEthCollection(tokenID), 10 ether);

        setBlockNumber(block.number + 801);

        user.collectEth(tokenID);

        setBlockNumber(block.number + 51);

        user.collectEth(tokenID);
        user.burn(tokenID);
    }
}
