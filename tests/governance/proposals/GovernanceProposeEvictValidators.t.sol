// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "lib/ds-test/test.sol";

import "src/governance/GovernanceManager.sol";
import "src/governance/GovernanceMaxLock.sol";
import "src/governance/GovernanceProposal.sol";
import "src/governance/GovernanceStorage.sol";
import "src/governance/Governance.sol";
import "src/tokens/StakeNFT.sol";
import "src/tokens/interfaces/INFTStake.sol";
import "lib/openzeppelin/token/ERC20/ERC20.sol";
import "src/diamonds/facets/ParticipantsLibrary.sol";
import "./GovernanceProposeModifySnapshot.t.sol";


contract Representative {

    Participants pf;
    uint256[2] madID;
    BasicERC20 token;
    uint256 stakingAmount;
    Staking staking;

    constructor(Participants _pf, uint256[2] memory _madID, BasicERC20 _token, Staking _staking, uint256 _amount) {
        madID[0] = _madID[0];
        madID[1] = _madID[1];

        pf = _pf;
        token = _token;
        staking = _staking;
        stakingAmount = _amount;
    }

    function add() external returns (uint8) {
        token.approve(address(staking), stakingAmount);
        staking.lockStake(stakingAmount);
        return pf.addValidator(address(this), madID);
    }

    function remove() external returns (uint8) {
        return pf.removeValidator(address(this), madID);
    }
}

contract GovernanceProposeEvictAValidator is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the Validators Diamond.
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// SNAPSHOT REPLACEMENT LOGIC IN HERE!
    function callback() public override returns(bool) {
        removeValidator();
        return true;
    }

    function removeValidator() internal {
        // todo: unstake the validators prior removal?
        address _validator = 0x0aA3c032A48098855b3fA7410A33A120b34FB57D;
        uint256[2] memory _madID = [uint256(1), uint256(1)];
        ParticipantsLibrary.removeValidator(_validator, _madID);
    }
}

contract GovernanceProposeEvictASetValidator is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the Validators Diamond.
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// SNAPSHOT REPLACEMENT LOGIC IN HERE!
    function callback() public override returns(bool) {
        removeSetOfValidators();
        return true;
    }

    function removeSetOfValidators() internal {
        // todo: unstake the validators prior removal?
        address _validator1 = 0xF34003B00A3DbF6253Dd679F6BAe1c1e9992A7D1;
        uint256[2] memory _madID1 = [uint256(0), uint256(0)];
        ParticipantsLibrary.removeValidator(_validator1, _madID1);
        address _validator2 = 0xf1aD0f8622D9b0B56c7C5e23B5971648fCb55f47;
        uint256[2] memory _madID2 = [uint256(4), uint256(4)];
        ParticipantsLibrary.removeValidator(_validator2, _madID2);
        address _validator3 = 0xda566cF0927194a7E9B663881dB461a82Fc46b52;
        uint256[2] memory _madID3 = [uint256(7), uint256(7)];
        ParticipantsLibrary.removeValidator(_validator3, _madID3);
    }
}

contract GovernanceProposeEvictAllValidators is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the Validators Diamond.
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// SNAPSHOT REPLACEMENT LOGIC IN HERE!
    function callback() public override returns(bool) {
        removeAllValidators();
        return true;
    }

    function removeAllValidators() internal {
        // todo: unstake the validators prior removal?
        ParticipantsLibrary.ParticipantsStorage storage ps = ParticipantsLibrary.participantsStorage();
        uint256 count = ps.validatorCount;
        while (count > 0) {
            count = ParticipantsLibrary.removeValidator(ps.validators[0], ParticipantsLibrary.getValidatorPublicKey(ps.validators[0]));
        }
    }
}

contract GovernanceProposeEvictValidatorsTest is DSTest, Setup {

    uint representativeNumber;

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
            "Stake",
            "MAD",
            IERC20Transferable(address(madToken)),
            address(admin),
            address(address(0x0))
        );
        minerStake = MinerStake(address (new StakeNFT(
            "Stake",
            "MAD",
            IERC20Transferable(address(madToken)),
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

    function createRepresentative() internal returns (Representative) {
        uint256[2] memory representativeID = generateMadID(representativeNumber++);
        Representative rep = new Representative(participants, representativeID, stakingToken, staking, MINIMUM_STAKE);

        stakingToken.transfer(address(rep), MINIMUM_STAKE);
        emit log_named_address("Representative", address(rep));
        uint256 b = stakingToken.balanceOf(address(rep));
        assertEq(b, MINIMUM_STAKE);

        rep.add();

        return rep;
    }

    function generateMadID(uint256 id) internal pure returns (uint256[2] memory madID) {
        madID[0] = id;
        madID[1] = id;
    }

    function createValidators(uint256 numberOfValidators) internal returns(Representative[] memory reps){
        reps = new Representative[](numberOfValidators);
        for (uint256 i; i<numberOfValidators; i++) {
            emit log_named_uint("i", i);
            reps[i] = createRepresentative();
        }
    }

    function goodSnapshots(uint number) internal {
        bytes memory bclaims =
            hex"00000000010004002a000000050000000d000000020100001900000002010000"
            hex"250000000201000031000000020100007565a2d7195f43727e1141f00228fd60"
            hex"da3ca7ada3fc0a5a34ea537e0cb82e8dc5d2460186f7233c927e7db2dcc703c0"
            hex"e500b653ca82273b7bfad8045d85a47000000000000000000000000000000000"
            hex"00000000000000000000000000000000ede353f57b9e2599f9165fde4ec80b60"
            hex"0e9c20418aa3f4d3d6aabee6981abff6";

        bytes memory signatureGroup =
            hex"2ee01ec6218252b7e263cb1d86e6082f7e05e0c86b17607c5490cd2a73ac14f6"
            hex"2cc0679acd5fb16c0c983806d13127354423e908fec273db1fc62c38fcee59d5"
            hex"2570a1763029316ee5cb6e44a74039f15935f110898ad495ffe837335ced059d"
            hex"0d426710c8a650cf96de6462406c3b707d4d1ae2231f3206c57b6551e12f593c"
            hex"1b3c547d051cc268a996a7494df22da5afc31650ba0963e1ee39a2404c4f6cd1"
            hex"22d313f80eb31f8cac30cd98686f815d38b8ea2d46748e9f8971db83f5311a24";

        for(uint count=0; count<number; count++) {
            snapshots.snapshot(signatureGroup, bclaims);
        }
    }

    function testExecuteProposalEvictAValidator() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        GovernanceProposeEvictAValidator logic = new GovernanceProposeEvictAValidator();
        emit log_named_address("Contract address", address(logic));
        emit log_named_address("Snapshot address", address(validators));
        Representative[] memory reps = createValidators(10);
        assertEq(participants.validatorCount(), 10);
        // Checking if the validator that we are going to remove is indeed a validator
        assertTrue(participants.isValidator(0x0aA3c032A48098855b3fA7410A33A120b34FB57D));
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

        // unstaking the validator before removing it
        // todo: change this logic once we have the new stakeNFT in place
        staking.requestUnlockStakeFor(0x0aA3c032A48098855b3fA7410A33A120b34FB57D);
        staking.unlockStakeFor(0x0aA3c032A48098855b3fA7410A33A120b34FB57D, MINIMUM_STAKE);

        governanceManager.execute(proposalID);
        assertTrue(governanceManager.isProposalExecuted(proposalID));
        assertEq(participants.validatorCount(), 9);
        assertTrue(!participants.isValidator(0x0aA3c032A48098855b3fA7410A33A120b34FB57D));
    }

    function testExecuteProposalEvictASetOfValidators() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        GovernanceProposeEvictASetValidator logic = new GovernanceProposeEvictASetValidator();
        Representative[] memory reps = createValidators(10);
        assertEq(participants.validatorCount(), 10);
        // Checking if all the validator that we are going to remove are indeed validators
        address evictedValidator1 = 0xF34003B00A3DbF6253Dd679F6BAe1c1e9992A7D1;
        address evictedValidator2 = 0xf1aD0f8622D9b0B56c7C5e23B5971648fCb55f47;
        address evictedValidator3 = 0xda566cF0927194a7E9B663881dB461a82Fc46b52;
        assertTrue(participants.isValidator(evictedValidator1));
        assertTrue(participants.isValidator(evictedValidator2));
        assertTrue(participants.isValidator(evictedValidator3));
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

        // unstaking all the validators before removing them
        // todo: change this logic once we have the new stakeNFT in place
        staking.requestUnlockStakeFor(evictedValidator1);
        staking.unlockStakeFor(evictedValidator1, MINIMUM_STAKE);
        staking.requestUnlockStakeFor(evictedValidator2);
        staking.unlockStakeFor(evictedValidator2, MINIMUM_STAKE);
        staking.requestUnlockStakeFor(evictedValidator3);
        staking.unlockStakeFor(evictedValidator3, MINIMUM_STAKE);

        governanceManager.execute(proposalID);
        assertTrue(governanceManager.isProposalExecuted(proposalID));
        assertEq(participants.validatorCount(), 7);
        assertTrue(!participants.isValidator(evictedValidator1));
        assertTrue(!participants.isValidator(evictedValidator2));
        assertTrue(!participants.isValidator(evictedValidator3));
    }

    function testExecuteProposalEvictAllValidators() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        GovernanceProposeEvictAllValidators logic = new GovernanceProposeEvictAllValidators();
        Representative[] memory reps = createValidators(10);
        assertEq(participants.validatorCount(), 10);
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

        // unstaking all the validators before removing them
        // todo: change this logic once we have the new stakeNFT in place
        for (uint256 i=0; i<10; i++){
            staking.requestUnlockStakeFor(address(reps[i]));
            staking.unlockStakeFor(address(reps[i]), MINIMUM_STAKE);
        }

        governanceManager.execute(proposalID);
        assertTrue(governanceManager.isProposalExecuted(proposalID));
        assertEq(participants.validatorCount(), 0);
    }

    function testFail_ExecuteProposalEvictValidatorsWithoutPermission() public {
        sudo.modifyDiamondStorage(address(this));
    }
}
