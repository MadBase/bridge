// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./GovernanceManager.sol";
import "./GovernanceMaxLock.sol";
import "./GovernanceProposal.sol";
import "./GovernanceStorage.sol";
import "./StakeNFT.sol";
import "./interfaces/INFTStake.sol";
import "./lib/openzeppelin/token/ERC20/ERC20.sol";
//import "./lib/openzeppelin/token/ERC721/IERC721Receiver.sol";

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
}

contract MockProposalLogic is GovernanceProposal, DSTest {

    bool _isExecuted = false;

    function execute() public override virtual returns(bool) {
        return _execute();
    }

    function _execute() internal override virtual returns(bool) {
        require(!_isExecuted, "MockProposal: cannot execute more than once!");
        emit log_named_uint("mock executing", 1);
        _isExecuted = true;
        return true;
    }

    function isExecuted() external returns(bool) {
        return _isExecuted;
    }
}

contract ReadSharedStateRaceConditionProposalLogic is GovernanceProposal, DSTest {

    // not initializing this to capture what's in storage
    bool _isExecuted;

    function execute() public override virtual returns(bool) {
        return _execute();
    }

    function _execute() internal override virtual returns(bool) {
        require(_isExecuted == false, "ReadSharedStateRaceConditionProposalLogic: this variable should have been initialized to false, but is true because of a race condition in GovernanceProposals executing from GovernanceManager's context (delegatecall).");
        return true;
    }

    // when called from inside the contract, it should return whatever is already 
    // stored inside `_isExecuted`, assuming there's a boolean on the first 
    // storage slot.
    // When called from outside, it should return false.
    function isExecuted() external returns(bool) {
        return _isExecuted;
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
        madToken = new MadTokenMock(address(this));
        stakeNFT = new StakeNFT(
            IERC20Transfer(address(madToken)),
            address(admin),
            address(address(0x0))
        );
        minerStake = new MinerStake(stakeNFT);
        governanceManager = new GovernanceManager(address(stakeNFT), address(minerStake));
        admin.setTokens(madToken, stakeNFT, governanceManager);
        //admin.setGovernance(address(governanceManager)); // implicit on previous line
    }

    function newUserAccount(MadTokenMock madToken, StakeNFT stakeNFT, GovernanceManager governanceManager)
        private
        returns (UserAccount acct)
    {
        acct = new UserAccount();
        acct.setTokens(madToken, stakeNFT, governanceManager);
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
        assertTrue(actual.notExecuted == expected.notExecuted);
        assertEq(actual.logic, expected.logic);
        assertEq(actual.voteCount, expected.voteCount);
        assertEq(actual.blockEndVote, expected.blockEndVote);
    }

    function testFail_ExecuteOngoingProposal() public {
        (,,,,GovernanceManager governanceManager) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        assertTrue(!logic.isExecuted());

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                0,
                172800
            )
        );

        governanceManager.execute(proposalID);
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
        assertTrue(!logic.isExecuted());

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                0,
                172800
            )
        );

        setBlockNumber(block.number + 172800 + 1);

        governanceManager.execute(proposalID);
    }

    function testFail_ShouldNotBeAbleTo_VoteOnSameBlockAsProposalCreation() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager            
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        assertTrue(!logic.isExecuted());

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                0,
                172800
            )
        );

        // 112 200 000
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112200000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112200000 * 10**18, 1);

        user1.voteAsStaker(proposalID, tokenID);
    }

    function testVoteAndExecuteAfter1Block() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager            
        ) = getFixtureData();

        MockProposalLogic logic = new MockProposalLogic();
        assertTrue(!logic.isExecuted());

        uint256 proposalID = governanceManager.propose(address(logic));
        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                true,
                address(logic),
                0,
                172800
            )
        );

        // voting threshold = 112_200_000 * 10**18 shares
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        uint256 tokenID = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);

        setBlockNumber(block.number +1);

        user1.voteAsStaker(proposalID, tokenID);

        assertTrue(!logic.isExecuted());

        governanceManager.execute(proposalID);

        assertProposal(
            governanceManager.getProposal(proposalID),
            GovernanceStorage.Proposal(
                false,
                address(logic),
                112_200_000 * 10**18,
                172800
            )
        );

        /*
            This holds true because the logic is executed by a delegate call 
            inside GovernanceManager, therefore using GovernanceManager's 
            context (storage, caller, etc). Every state variables inside 
            logic contracts will be allocated after the GovernanceStorage 
            slots inside GovernanceManager, and that's where they live.
            As a consequence of this, we cannot inspect the current state 
            of the logic contract by calling it directly as shown by the 
            next line of code, i.e. from outside the GovernanceManager's 
            context (storage, caller, etc).
            Also worth noting that every logic contract (GovernanceProposal) 
            shares the same storage slots for state variables, exposing them 
            to race conditions. Better to keep logic contracts stateless.
        */
        assertTrue(!logic.isExecuted());
    }

    /// @dev check for race condition on GornanceProposal logic contracts
    /// by sharing state under GorvernanceManager's context.
    function testShouldNotLetProposalLogicShareStorageSlots() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager            
        ) = getFixtureData();

        MockProposalLogic logic1 = new MockProposalLogic();
        ReadSharedStateRaceConditionProposalLogic logic2 = new ReadSharedStateRaceConditionProposalLogic();
        assertTrue(!logic1.isExecuted());
        assertTrue(!logic2.isExecuted());

        uint256 proposalID1 = governanceManager.propose(address(logic1));
        assertProposal(
            governanceManager.getProposal(proposalID1),
            GovernanceStorage.Proposal(
                true,
                address(logic1),
                0,
                172800
            )
        );

        uint256 proposalID2 = governanceManager.propose(address(logic2));
        assertProposal(
            governanceManager.getProposal(proposalID2),
            GovernanceStorage.Proposal(
                true,
                address(logic2),
                0,
                172800
            )
        );

        // voting threshold = 112_200_000 * 10**18 shares
        // here we prepare enough shares to vote on 2 proposals
        UserAccount user1 = newUserAccount(madToken, stakeNFT, governanceManager);
        madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        uint256 tokenID1 = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);
        // madToken.approve(address(stakeNFT), 112_200_000 * 10**18);
        // uint256 tokenID2 = stakeNFT.mintTo(address(user1), 112_200_000 * 10**18, 1);

        setBlockNumber(block.number +1);

        user1.voteAsStaker(proposalID1, tokenID1);

        assertProposal(
            governanceManager.getProposal(proposalID1),
            GovernanceStorage.Proposal(
                true,
                address(logic1),
                112_200_000 * 10**18,
                172800
            )
        );

        assertTrue(!logic1.isExecuted());

        governanceManager.execute(proposalID1);

        assertProposal(
            governanceManager.getProposal(proposalID1),
            GovernanceStorage.Proposal(
                false,
                address(logic1),
                112_200_000 * 10**18,
                172800
            )
        );

        /*
            This holds true because the logic is executed by a delegate call 
            inside GovernanceManager, therefore using GovernanceManager's 
            context (storage, caller, etc). Every state variables inside 
            logic contracts will be allocated after the GovernanceStorage 
            slots inside GovernanceManager, and that's where they live.
            As a consequence of this, we cannot inspect the current state 
            of the logic contract by calling it directly as shown by the 
            next line of code, i.e. from outside the GovernanceManager's 
            context (storage, caller, etc).
            Also worth noting that every logic contract (GovernanceProposal) 
            shares the same storage slots for state variables, exposing them 
            to race conditions. Better to keep logic contracts stateless.
        */
        assertTrue(!logic1.isExecuted());

        assertTrue(!logic2.isExecuted());

        // now the same with the second proposal logic

        user1.voteAsStaker(proposalID2, tokenID1);

        assertTrue(!logic2.isExecuted());

        // reverts here
        governanceManager.execute(proposalID2);
    }

}
