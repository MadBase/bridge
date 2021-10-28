// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./GovernanceManager.sol";
import "./GovernanceMaxLock.sol";
import "./GovernanceProposal.sol";
import "./GovernanceStorage.sol";
import "./Governance.sol";
import "./StakeNFT.sol";
import "./interfaces/INFTStake.sol";
import "./lib/openzeppelin/token/ERC20/ERC20.sol";

uint256 constant ONE_MADTOKEN = 10**18;

contract MadTokenMock is ERC20 {
    constructor(address to_) ERC20("MadToken", "MAD") {
        _mint(to_, 220000000 * ONE_MADTOKEN);
    }
}

contract MinerStake is INFTStake {

    StakeNFT stakeNFT;

    constructor(StakeNFT stakeNFT_) {
        stakeNFT = stakeNFT_;
    }

    function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) external override returns(uint256 numberShares) {
        return stakeNFT.lockPosition(caller_, tokenID_, lockDuration_);
    }

    function mintTo(address to_, uint256 amount_, uint256 lockDuration_) public returns(uint256 tokenID) {
        return stakeNFT.mintTo(to_, amount_, lockDuration_);
    }
}

contract MockGovernanceOnlyAction is Governance, DSTest {
    constructor(address _governance) Governance(address(_governance)) {}

    function dummy() public onlyGovernance returns(bool){
        emit log("Oh god, I got executed!");
        emit log_named_address("Dummy: msg.sender in the dummy", msg.sender);
        return true;
    }
}

contract MockProposalLogic is GovernanceProposal, DSTest {

    function execute(address self) public override virtual returns(bool) {
        return _execute();
    }

    function _execute() internal virtual returns(bool) {
        emit log_named_address("msg.sender", msg.sender);
        address _logic = 0x3A1148FE01e3c4721D93fe8A36c2b5C29109B6ae;
        (bool success, bytes memory data) = _logic.call(abi.encodeWithSignature("dummy()"));
        require(success, "GovernanceManager: CALL FAILED to execute proposal");
        emit log_named_bytes("Executed successful", data);
        return true;
    }
}

contract MockProposalLogicFailedLogic is GovernanceProposal, DSTest {

    function execute(address self) public override virtual returns(bool) {
        return _execute();
    }

    function _execute() internal virtual returns(bool) {
        revert("Proposal with failed logic!");
    }
}

contract MockProposalChangeGovernanceManagerStorage is GovernanceProposal, DSTest {

    function execute(address self) public override virtual returns(bool) {
        return _execute();
    }

    function _execute() internal virtual returns(bool) {
        _votemap[1][address(_Stake)][1]=false;
        _MinerStake=INFTStake(address(0x0));
        _proposals[1] = GovernanceStorage.Proposal(false, address(0x0), 0, 666);
        _threshold=1;
    }
}

contract MockProposalLogicWithAllowedProposals is GovernanceProposal, DSTest {

    function execute(address self) public override virtual returns(bool) {
        emit log_named_address("MockProposalLogicWithAllowedProposals: msg.sender", msg.sender);
        // Address of the deployed MockProposalLogicWithOutAllowedProposals
        // contract. This contract is a middle man that doesn't have governance
        // powers. See the contract bellow.
        address _logic = 0xbfFb01bB2DDb4EfA87cB78EeCB8115AFAe6d2032;
        // giving the _logic address governance powers to call governance methods
        allowedProposal = _logic;
        (bool success, bytes memory data) = _logic.call(abi.encodeWithSignature("dummyNoDelegate()"));
        require(success, "GovernanceManager: CALL FAILED to execute proposal");
        emit log_named_bytes("Executed successful", data);
        return success;
    }
}

contract MockProposalLogicWithOutAllowedProposals is GovernanceProposal, DSTest {
    function execute(address self) public override virtual returns(bool) {
        emit log_named_address("MockProposalLogicWithAllowedProposals: msg.sender", msg.sender);
        address _logic = 0xbfFb01bB2DDb4EfA87cB78EeCB8115AFAe6d2032;
        (bool success, bytes memory data) = _logic.call(abi.encodeWithSignature("dummyNoDelegate()"));
        require(success, "GovernanceManager: CALL FAILED to execute proposal");
        emit log_named_bytes("Executed successful", data);
        return success;
    }
}

contract NoGovernanceDelegateCall is DSTest {
    function dummyNoDelegate() public returns (bool){
        emit log_named_address("NoGovernanceDelegateCall: msg.sender", msg.sender);
        address _logic = 0x3A1148FE01e3c4721D93fe8A36c2b5C29109B6ae;
        (bool success, bytes memory data) = _logic.call(abi.encodeWithSignature("dummy()"));
        require(success, "GovernanceManager: CALL FAILED to execute proposal");
        emit log_named_bytes("Executed successful", data);
        return success;
    }
}

contract MockProposalChangeGovernanceManagerStorageStake is GovernanceProposal, DSTest {

    function execute(address self) public override virtual returns(bool) {
        return _execute();
    }

    function _execute() internal virtual returns(bool) {
        _Stake=INFTStake(address(0x0));
    }
}

abstract contract BaseMock {
    StakeNFT public stakeNFT;
    MadTokenMock public madToken;
    GovernanceManager public governanceManager;

    function setTokens(MadTokenMock madToken_, StakeNFT stakeNFT_, GovernanceManager governanceManager_) public virtual {
        stakeNFT = stakeNFT_;
        madToken = madToken_;
        governanceManager = governanceManager_;
    }

    receive() external payable virtual {}
}

contract AdminAccount is BaseMock {
    constructor() {}

    function tripCB() public {
        stakeNFT.tripCB();
    }

    function setTokens(MadTokenMock madToken_, StakeNFT stakeNFT_, GovernanceManager governanceManager_) public override virtual {
        stakeNFT = stakeNFT_;
        madToken = madToken_;
        governanceManager = governanceManager_;
        setGovernance(address(governanceManager_));
    }

    function setGovernance(address governance_) public {
        stakeNFT.setGovernance(governance_);
    }
}

contract UserAccount is BaseMock {
    constructor() {}

    function voteAsMiner(uint256 proposalID_, uint256 tokenID_) public {
        governanceManager.voteAsMiner(proposalID_, tokenID_);
    }

    function voteAsStaker(uint256 proposalID_, uint256 tokenID_) public {
        governanceManager.voteAsStaker(proposalID_, tokenID_);
    }
}

contract GovernanceManagerTest is DSTest {
    function getFixtureData()
        internal
        returns (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        )
    {

        admin = new AdminAccount();
        AdminAccount adminMiner = new AdminAccount();
        madToken = new MadTokenMock(address(this));
        stakeNFT = new StakeNFT(
            IERC20Transfer(address(madToken)),
            address(admin),
            address(address(0x0))
        );
        minerStake = MinerStake(address (new StakeNFT(
            IERC20Transfer(address(madToken)),
            address(adminMiner),
            address(address(0x0))
        )));
        governanceManager = new GovernanceManager(address(stakeNFT), address(minerStake));
        admin.setTokens(madToken, stakeNFT, governanceManager);
        adminMiner.setTokens(madToken, StakeNFT(address(minerStake)), governanceManager);
    }

    function newUserAccount(MadTokenMock madToken, StakeNFT stakeNFT, GovernanceManager governanceManager)
        private
        returns (UserAccount acct)
    {
        acct = new UserAccount();
        acct.setTokens(madToken, stakeNFT, governanceManager);
    }

    function newUserAccount(MadTokenMock madToken, MinerStake minerStake, GovernanceManager governanceManager)
        private
        returns (UserAccount acct)
    {
        acct = new UserAccount();
        acct.setTokens(madToken, StakeNFT(address(minerStake)), governanceManager);
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

    function assertProposal(GovernanceStorage.Proposal memory actual, GovernanceStorage.Proposal memory expected) public {
        assertTrue(actual.executed == expected.executed);
        assertEq(actual.logic, expected.logic);
        assertEq(actual.voteCount, expected.voteCount);
        assertEq(actual.blockEndVote, expected.blockEndVote);
    }

    function test_CreateProposal() public {
        (,,,,GovernanceManager governanceManager) = getFixtureData();
        MockProposalLogic logic = new MockProposalLogic();
        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
    }

    function testFail_CreateProposalWithLogicAddressZero() public {
        (,,,,GovernanceManager governanceManager) = getFixtureData();
        uint256 proposalID = governanceManager.propose(address(0x0));
    }

    function testVoteAsStaker() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        for (uint256 i =0; i < 10; i++){
            UserAccount user = newUserAccount(madToken, stakeNFT, governanceManager);
            madToken.approve(address(stakeNFT), 11_220_000 * 10**18);
            uint256 tokenID = stakeNFT.mintTo(address(user), 11_220_000 * 10**18, 1);
            user.voteAsStaker(proposalID, tokenID);
        }
    }

    function testVoteAsMiner() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        for (uint256 i =0; i < 10; i++){
            UserAccount user = newUserAccount(madToken, minerStake, governanceManager);
            madToken.approve(address(minerStake), 11_220_000 * 10**18);
            uint256 tokenID = minerStake.mintTo(address(user), 11_220_000 * 10**18, 1);
            user.voteAsMiner(proposalID, tokenID);
        }
    }

    function testSameUserVotesAsMinerAndStaker() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        UserAccount[10] memory users;
        madToken.approve(address(minerStake), 110_000_000 * 10**18);
        madToken.approve(address(stakeNFT), 110_000_000 * 10**18);
        for (uint256 i =0; i < 10; i++){
            users[i] = newUserAccount(madToken, minerStake, governanceManager);
            uint256 minerTokenId = minerStake.mintTo(address(users[i]), 11_000_000 * 10**18, 1);
            emit log_named_uint("miner token", minerTokenId);
            uint256 stakeTokenId = stakeNFT.mintTo(address(users[i]), 11_000_000 * 10**18, 1);
            emit log_named_uint("stake token", stakeTokenId);
            assertEq(minerTokenId, stakeTokenId);
        }
        for (uint256 i =0; i < 10; i++){
            users[i].voteAsMiner(proposalID, i+1);
            users[i].voteAsStaker(proposalID, i+1);
        }
    }

    function testFail_TryToVoteNonExistingProposalId() public {
        (,,,,GovernanceManager governanceManager) = getFixtureData();
        governanceManager.voteAsStaker(1000, 1001);
    }

    function testFail_ShouldNotBeAbleToVoteOnSameBlockAsProposalCreation() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));

        // 112 200 000
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112200000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112200000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);
    }

    function testFail_TryVoteAfterProposalHasExpired() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        setBlockNumber(block.number + 172800 + 1);
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112200000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112200000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);

    }

    function testFail_TryVoteOnExecutedProposal() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        // voting threshold = 112_200_000 * 10**18 shares
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112_201_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);
        uint256 tokenID2 = stakeNFT.mintTo(address(user1), 1000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);

        governanceManager.execute(proposalID);

        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                112_200_000 * 10**18,
                172800
            )
        );
        assertTrue(governanceManager.isProposalExecuted(proposalID));

        user1.voteAsStaker(proposalID, tokenID2);
    }

    function testSameUserVoteWithDifferentPositions() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        setBlockNumber(block.number + 1);
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        for (uint256 i =0; i < 10; i++){
            uint256 tokenID = stakeNFT.mintTo(address(user1), 112_20_000 * 10**18, 1);
            user1.voteAsStaker(proposalID, tokenID);
        }
    }

    function testFail_SameUserVoteWithSamePosition() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        setBlockNumber(block.number + 1);
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);
        user1.voteAsStaker(proposalID, tokenID);
        user1.voteAsStaker(proposalID, tokenID);
    }

    function testFail_UserVoteWithNotOwnedPosition() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        setBlockNumber(block.number + 1);
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        UserAccount user2 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 200_000_000 * 10**18);
        uint256 tokenID1 = stakeNFT.mintTo(address(user1), 100_200_000 * 10**18, 1);
        uint256 tokenID2 = stakeNFT.mintTo(address(user2), 12_000_000 * 10**18, 1);
        user1.voteAsStaker(proposalID, tokenID1);
        user1.voteAsStaker(proposalID, tokenID2);
    }

    function testExecuteProposal() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));
        emit log_named_address("dummy:", address(dummy));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        for (uint256 i =0; i < 10; i++){
            UserAccount user = newUserAccount(madToken, stakeNFT, governanceManager);
            madToken.approve(address(stakeNFT), 11_220_000 * 10**18);
            uint256 tokenID = stakeNFT.mintTo(address(user), 11_220_000 * 10**18, 1);
            user.voteAsStaker(proposalID, tokenID);
        }

        governanceManager.execute(proposalID);

        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                112_200_000 * 10**18,
                172800
            )
        );
        assertTrue(governanceManager.isProposalExecuted(proposalID));
    }

    function testVoteAndExecuteMultipleProposal() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic1 = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));
        MockProposalLogic logic2 = new MockProposalLogic();
        emit log_named_address("dummy:", address(dummy));

        uint256 proposalID1 = governanceManager.propose(address(logic1));
        assertProposal(
            governanceManager.getProposal(proposalID1),
            GovernanceStorage.Proposal(
                false,
                address(logic1),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID1));

        uint256 proposalID2 = governanceManager.propose(address(logic2));
        assertProposal(
            governanceManager.getProposal(proposalID2),
            GovernanceStorage.Proposal(
                false,
                address(logic2),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID2));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number+1);

        for (uint256 i =0; i < 10; i++){
            UserAccount user = newUserAccount(madToken, stakeNFT, governanceManager);
            madToken.approve(address(stakeNFT), 11_220_000 * 10**18);
            uint256 tokenID = stakeNFT.mintTo(address(user), 11_220_000 * 10**18, 1);
            user.voteAsStaker(proposalID1, tokenID);
            user.voteAsStaker(proposalID2, tokenID);
        }

        governanceManager.execute(proposalID1);

        assertProposal(
            governanceManager.getProposal(proposalID1),
            GovernanceStorage.Proposal(
                true,
                address(logic1),
                112_200_000 * 10**18,
                172800
            )
        );
        assertTrue(governanceManager.isProposalExecuted(proposalID1));

        governanceManager.execute(proposalID2);

        assertProposal(
            governanceManager.getProposal(proposalID2),
            GovernanceStorage.Proposal(
                true,
                address(logic2),
                112_200_000 * 10**18,
                172800
            )
        );
        assertTrue(governanceManager.isProposalExecuted(proposalID2));
    }

    function testExecuteProposalWhereSameUserVotesAsMinerAndStaker() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        UserAccount[10] memory users;
        madToken.approve(address(minerStake), 112_200_000 * 10**18);
        madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        for (uint256 i =0; i < 10; i++){
            users[i] = newUserAccount(madToken, minerStake, governanceManager);
            uint256 minerTokenId = minerStake.mintTo(address(users[i]), 5_610_000 * 10**18, 1);
            emit log_named_uint("miner token", minerTokenId);
            uint256 stakeTokenId = stakeNFT.mintTo(address(users[i]), 5_610_000 * 10**18, 1);
            emit log_named_uint("stake token", stakeTokenId);
            assertEq(minerTokenId, stakeTokenId);
        }
        for (uint256 i =0; i < 10; i++){
            users[i].voteAsMiner(proposalID, i+1);
            users[i].voteAsStaker(proposalID, i+1);
        }

        governanceManager.execute(proposalID);

        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                112_200_000 * 10**18,
                172800
            )
        );

        assertTrue(governanceManager.isProposalExecuted(proposalID));

    }

    function testFail_TryToExecuteNonExistingProposalId() public {
        (,,,,GovernanceManager governanceManager) = getFixtureData();
        governanceManager.execute(1000);
    }

    function testFail_ExecuteProposalWithoutVotingThreshold() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));

        setBlockNumber(block.number + 172800 + 1);

        governanceManager.execute(proposalID);
    }

    function testFail_ExecuteAgainExecutedProposal() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        // voting threshold = 112_200_000 * 10**18 shares
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);

        governanceManager.execute(proposalID);

        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                112_200_000 * 10**18,
                172800
            )
        );
        assertTrue(governanceManager.isProposalExecuted(proposalID));

        governanceManager.execute(proposalID);

    }

    function testFail_TryToExecuteProposalThatReverts() public {

        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogicFailedLogic logic = new MockProposalLogicFailedLogic();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        // voting threshold = 112_200_000 * 10**18 shares
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);

        governanceManager.execute(proposalID);
    }

    function testExecuteProposalThatModifyStorage() public {

        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalChangeGovernanceManagerStorage logic = new MockProposalChangeGovernanceManagerStorage();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));
        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        // voting threshold = 112_200_000 * 10**18 shares
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        emit log_named_address("Address:", address(user1));
        madToken.approve(address(stakeNFT), 220_000_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);

        // executing proposal that changes the stage. After execution, user
        // should be able to vote again in the proposal, we will be able to
        // rerun the proposal again, the stake and miner stake token should be
        // address 0, and threshold should be 1.
        governanceManager.execute(proposalID);
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        assertEq(governanceManager.getMinerStakeTokenAddress(), address(0x0));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(0x0),
                0,
                666
            )
        );
        user1.voteAsStaker(proposalID, tokenID);
        governanceManager.execute(proposalID);
        // Changing the Stake address (zero address)
        MockProposalChangeGovernanceManagerStorageStake logic2 = new MockProposalChangeGovernanceManagerStorageStake();
        uint256 proposalID2 = governanceManager.propose(address(logic2));
        setBlockNumber(block.number +10);
        assertTrue(!governanceManager.isProposalExecuted(proposalID2));
        user1.voteAsStaker(proposalID2, tokenID);
        governanceManager.execute(proposalID2);
        assertEq(governanceManager.getStakeTokenAddress(), address(0x0));
    }

    function testExecuteGovernanceAllowedProposal() public {

        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogicWithAllowedProposals logic = new MockProposalLogicWithAllowedProposals();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));
        emit log_named_address("Address dummy:", address(dummy));
        NoGovernanceDelegateCall dummyDelegate = new NoGovernanceDelegateCall();
        emit log_named_address("Address dummy delegate:", address(dummyDelegate));
        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        // voting threshold = 112_200_000 * 10**18 shares
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        emit log_named_address("Address:", address(user1));
        madToken.approve(address(stakeNFT), 220_000_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);

        assertEq(governanceManager.allowedProposal(), address(0x0));
        governanceManager.execute(proposalID);
        assertTrue(governanceManager.isProposalExecuted(proposalID));
        assertEq(governanceManager.allowedProposal(), address(0x0));
    }

    function testFail_ExecuteGovernanceWithoutAllowedProposal() public {

        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        MockProposalLogicWithOutAllowedProposals logic = new MockProposalLogicWithOutAllowedProposals();
        MockGovernanceOnlyAction dummy = new MockGovernanceOnlyAction(address(governanceManager));
        emit log_named_address("Address dummy:", address(dummy));
        NoGovernanceDelegateCall dummyDelegate = new NoGovernanceDelegateCall();
        emit log_named_address("Address dummy delegate:", address(dummyDelegate));
        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                0,
                172800
            )
        );
        assertTrue(!governanceManager.isProposalExecuted(proposalID));
        // We can only vote after 1 block has passed from the proposal creation
        setBlockNumber(block.number +1);
        // voting threshold = 112_200_000 * 10**18 shares
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        emit log_named_address("Address:", address(user1));
        madToken.approve(address(stakeNFT), 220_000_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);

        assertEq(governanceManager.allowedProposal(), address(0x0));
        governanceManager.execute(proposalID);
    }

}
