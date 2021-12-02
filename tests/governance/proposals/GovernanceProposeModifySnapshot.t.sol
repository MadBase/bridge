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

import "src/diamonds/facets/EthDKGCompletionFacet.sol";
import "src/diamonds/facets/EthDKGGroupAccusationFacet.sol";
import "src/diamonds/facets/EthDKGInformationFacet.sol";
import "src/diamonds/facets/EthDKGInitializeFacet.sol";
import "src/diamonds/facets/EthDKGMiscFacet.sol";
import "src/diamonds/facets/EthDKGSubmitMPKFacet.sol";
import "src/diamonds/facets/EthDKGSubmitDisputeFacet.sol";

import "src/diamonds/facets/ParticipantsFacet.sol";
import "src/diamonds/facets/SnapshotsFacet.sol";
import "src/diamonds/facets/StakingFacet.sol";
import "src/diamonds/facets/SudoFacet.sol";
import "src/diamonds/facets/AccusationMultipleProposalFacet.sol";
import "src/diamonds/facets/AccusationInvalidTransactionConsumptionFacet.sol";
import "src/diamonds/facets/ValidatorLocationsFacet.sol";

import "src/diamonds/EthDKGDiamond.sol";
import "src/diamonds/ValidatorsDiamond.sol";
import "src/Constants.sol";
import "src/Registry.sol";
import "src/Token.sol";

import "src/diamonds/interfaces/ETHDKG.sol";
import "src/diamonds/interfaces/Participants.sol";
import "src/diamonds/interfaces/Snapshots.sol";
import "src/diamonds/interfaces/Staking.sol";
import "src/diamonds/interfaces/Token.sol";
import "src/diamonds/interfaces/Validators.sol";
import "src/diamonds/interfaces/Accusation.sol";
import "src/diamonds/interfaces/Sudo.sol";
import "src/diamonds/interfaces/ValidatorLocations.sol";

contract Setup is Constants {

    uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;
    uint constant MINIMUM_STAKE = 999_999_999;

    Registry registry;

    BasicERC20 stakingToken;
    BasicERC20 utilityToken;

    ETHDKG ethdkg;
    Accusation accusation;
    Participants participants;
    Snapshots snapshots;
    Staking staking;
    Validators validators;
    Sudo sudo;
    Sudo sudoETHDKG;

    function setUp() public virtual {
        setUp(address(new Token("STK", "MadNet Staking")));
    }

    function setUp(address stakeToken) public virtual {
        registry = new Registry();

        setUpEthDKG(registry);
        setUpMisc(registry, stakeToken);
        setUpValidators(registry);

        address stakingTokenAddress = registry.lookup(STAKING_TOKEN);
        stakingToken = BasicERC20(stakingTokenAddress);

        address utilityTokenAddress = registry.lookup(UTILITY_TOKEN);
        utilityToken = BasicERC20(utilityTokenAddress);

        address validatorsDiamond = registry.lookup(VALIDATORS_CONTRACT);
        participants = Participants(validatorsDiamond);
        snapshots = Snapshots(validatorsDiamond);
        staking = Staking(validatorsDiamond);
        validators = Validators(validatorsDiamond);
        accusation = Accusation(validatorsDiamond);
        sudo = Sudo(validatorsDiamond);

        address ethDKGDiamond = registry.lookup(ETHDKG_CONTRACT);
        ethdkg = ETHDKG(ethDKGDiamond);
        sudoETHDKG = Sudo(ethDKGDiamond);

        // Initialize
        participants.initializeParticipants(registry);
        snapshots.initializeSnapshots(registry);
        staking.initializeStaking(registry);


        // Base scenario setup
        stakingToken.approve(address(staking), INITIAL_AMOUNT);
        utilityToken.approve(address(staking), INITIAL_AMOUNT);

        snapshots.setEpoch(1);
        participants.setValidatorMaxCount(10);
        staking.setMinimumStake(MINIMUM_STAKE);

        staking.setRewardAmount(13);
        staking.setRewardBonus(7);
    }

    function setUpMisc(Registry _registry, address _stakeToken) public {
        _registry.register(STAKING_TOKEN, _stakeToken);
        _registry.register(UTILITY_TOKEN, address(new Token("UTL", "MadBytes")));
    }

    function setUpValidators(Registry _registry) public {

        address diamond = address(new ValidatorsDiamond());
        DiamondUpdateFacet update = DiamondUpdateFacet(diamond);

        // Create facets
        address participantsFacet = address(new ParticipantsFacet());
        address snapshotsFacet = address(new SnapshotsFacet());
        address stakingFacet = address(new StakingFacet());
        address sudoFacet = address(new SudoFacet());
        address accusationMultipleProposalFacet = address(new AccusationMultipleProposalFacet());
        address accusationInvalidTransactionConsumptionFacet = address(new AccusationInvalidTransactionConsumptionFacet());

        // SnapshotFacet Wiring
        update.addFacet(Snapshots.initializeSnapshots.selector, snapshotsFacet);
        update.addFacet(Snapshots.epoch.selector, snapshotsFacet);
        update.addFacet(Snapshots.extractUint256.selector, snapshotsFacet);
        update.addFacet(Snapshots.extractUint32.selector, snapshotsFacet);
        update.addFacet(Snapshots.setEpoch.selector, snapshotsFacet);
        update.addFacet(Snapshots.snapshot.selector, snapshotsFacet);
        update.addFacet(Snapshots.getRawSignatureSnapshot.selector, snapshotsFacet);
        update.addFacet(Snapshots.getRawBlockClaimsSnapshot.selector, snapshotsFacet);
        update.addFacet(Snapshots.getMadHeightFromSnapshot.selector, snapshotsFacet);
        update.addFacet(Snapshots.getHeightFromSnapshot.selector, snapshotsFacet);
        update.addFacet(Snapshots.getChainIdFromSnapshot.selector, snapshotsFacet);

        // StakingFacet Wiring
        update.addFacet(Staking.initializeStaking.selector, stakingFacet);
        update.addFacet(Staking.balanceRewardFor.selector, stakingFacet);
        update.addFacet(Staking.balanceStakeFor.selector, stakingFacet);
        update.addFacet(Staking.balanceUnlockedFor.selector, stakingFacet);
        update.addFacet(Staking.balanceUnlockedRewardFor.selector, stakingFacet);
        update.addFacet(Staking.lockRewardFor.selector, stakingFacet);
        update.addFacet(Staking.lockStake.selector, stakingFacet);
        update.addFacet(Staking.lockStakeFor.selector, stakingFacet);
        update.addFacet(Staking.minimumStake.selector, stakingFacet);
        update.addFacet(Staking.unlockRewardFor.selector, stakingFacet);
        update.addFacet(Staking.unlockStakeFor.selector, stakingFacet);
        update.addFacet(Staking.requestUnlockStakeFor.selector, stakingFacet);
        update.addFacet(Staking.setEpochDelay.selector, stakingFacet);
        update.addFacet(Staking.setMinimumStake.selector, stakingFacet);
        update.addFacet(Staking.setRewardAmount.selector, stakingFacet);
        update.addFacet(Staking.setRewardBonus.selector, stakingFacet);
        update.addFacet(Staking.burn.selector, stakingFacet);

        // Accusation Wiring
        update.addFacet(Accusation.AccuseMultipleProposal.selector, accusationMultipleProposalFacet);
        update.addFacet(Accusation.AccuseInvalidTransactionConsumption.selector, accusationInvalidTransactionConsumptionFacet);

        // ParticipantsFacet Wiring
        update.addFacet(Participants.initializeParticipants.selector, participantsFacet);
        update.addFacet(Participants.addValidator.selector, participantsFacet);
        update.addFacet(Participants.confirmValidators.selector, participantsFacet);
        update.addFacet(Participants.getValidators.selector, participantsFacet);
        update.addFacet(Participants.getValidatorPublicKey.selector, participantsFacet);
        update.addFacet(Participants.isValidator.selector, participantsFacet);
        update.addFacet(Participants.removeValidator.selector, participantsFacet);
        update.addFacet(Participants.setValidatorMaxCount.selector, participantsFacet);
        update.addFacet(Participants.validatorCount.selector, participantsFacet);
        update.addFacet(Participants.getChainId.selector, participantsFacet);
        update.addFacet(Participants.setChainId.selector, participantsFacet);


        // SudoFacet Wiring
        update.addFacet(Sudo.modifyDiamondStorage.selector, sudoFacet);
        update.addFacet(Sudo.setGovernance.selector, sudoFacet);

        _registry.register(VALIDATORS_CONTRACT, diamond);
    }

    function setUpEthDKG(Registry _registry) public {

        address diamond = address(new EthDKGDiamond());
        DiamondUpdateFacet update = DiamondUpdateFacet(diamond);

        // Create facets
        address accusationFacet = address(new EthDKGGroupAccusationFacet());
        address completionFacet = address(new EthDKGCompletionFacet());
        address initFacet = address(new EthDKGInitializeFacet());
        address mpkFacet = address(new EthDKGSubmitMPKFacet());
        address disputeFacet = address(new EthDKGSubmitDisputeFacet());
        address miscFacet = address(new EthDKGMiscFacet());
        address infoFacet = address(new EthDKGInformationFacet());
        address sudoFacet = address(new SudoFacet());

        // Wiring facets
        update.addFacet(ETHDKG.Group_Accusation_GPKj.selector, accusationFacet);
        update.addFacet(ETHDKG.Group_Accusation_GPKj_Comp.selector, accusationFacet);

        update.addFacet(ETHDKG.Successful_Completion.selector, completionFacet);
        update.addFacet(ETHDKG.initializeEthDKG.selector, initFacet);
        update.addFacet(ETHDKG.updatePhaseLength.selector, initFacet);
        update.addFacet(ETHDKG.submit_dispute.selector, disputeFacet);
        update.addFacet(ETHDKG.submit_master_public_key.selector, mpkFacet);

        update.addFacet(ETHDKG.register.selector, miscFacet);
        update.addFacet(ETHDKG.distribute_shares.selector, miscFacet);
        update.addFacet(ETHDKG.submit_key_share.selector, miscFacet);
        update.addFacet(ETHDKG.Submit_GPKj.selector, miscFacet);

        update.addFacet(ETHDKG.master_public_key.selector, infoFacet);
        update.addFacet(ETHDKG.gpkj_submissions.selector, infoFacet);
        update.addFacet(ETHDKG.getPhaseLength.selector, infoFacet);

        // SudoFacet Wiring
        update.addFacet(Sudo.modifyDiamondStorage.selector, sudoFacet);
        update.addFacet(Sudo.setGovernance.selector, sudoFacet);

        _registry.register(ETHDKG_CONTRACT, diamond);
    }

}

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

contract GovernanceProposeModifySnapshot is GovernanceProposal {

    function execute(address self) public override returns(bool) {
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "CALL FAILED");
        return success;
    }

    function callback() public override returns(bool) {
        SnapshotsLibrary.SnapshotsStorage storage s = SnapshotsLibrary.snapshotsStorage();
        ChainStatusLibrary.ChainStatusStorage storage cs = ChainStatusLibrary.chainStatusStorage();
        cs.epoch = 666;
        bytes memory sig = "0xbeefdead";
        bytes memory bclaims = "0xdeadbeef";
        s.snapshots[1] = SnapshotsLibrary.Snapshot(true, 123, bclaims, sig, 456, 789);
        return true;
    }
}

contract GovernanceProposeModifySnapshotCopy is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// SNAPSHOT REPLACEMENT LOGIC IN HERE!
    function callback() public override returns(bool) {
        // This function is called back by the Validators Diamond. Inside this
        // function, we have fully access to all the Validators Diamond Storage
        // including the the snapshots mapping arbitrarily.
        // Example:
        //
        //    SnapshotsLibrary.SnapshotsStorage storage s = SnapshotsLibrary.snapshotsStorage();
        //    bytes memory sig = "0xbeefdead";
        //    bytes memory bclaims = "0xdeadbeef";
        //    s.snapshots[1] = SnapshotsLibrary.Snapshot(true, 123, bclaims, sig, 456, 789);
        return true;
    }
}

contract TryModifyStakeAfterStorage is GovernanceProposal {

    function execute(address self) public override returns(bool) {
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "CALL FAILED");
        return success;
    }

    function callback() public override returns(bool) {
        // assume we update the diamond storage here

        // now we lock some staking position
        StakeNFT stake = StakeNFT(address(0xB85bEA9a5a75c5Daf146dBab68B3a9661682c0b8));
        stake.lockPosition(address(0xd5D575E71245442009EE208E8DCEBFbcF958b8B6), 1, 10);
        return true;
    }
}

contract ModifyStakeAfterStorage is GovernanceProposal {

    function execute(address self) public override returns(bool) {
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;
        allowedProposal = target;
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "CALL FAILED");
        return success;
    }

    function callback() public override returns(bool) {
        // assume we update the diamond storage here

        // now we lock some staking position
        StakeNFT stake = StakeNFT(address(0xe36D078E72C5BD2386d2bFB68573f0699B64c70C));
        stake.lockPosition(address(0xF34003B00A3DbF6253Dd679F6BAe1c1e9992A7D1), 1, 10);
        return true;
    }
}

contract DoSomething {

    function something() public {
        StakeNFT stake = StakeNFT(address(0xe36D078E72C5BD2386d2bFB68573f0699B64c70C));
        stake.lockPosition(address(0x0aA3c032A48098855b3fA7410A33A120b34FB57D), 1, 10);
    }
}

contract ModifyStakeAfterStorageFromOutside is GovernanceProposal {

    function execute(address self) public override returns(bool) {
        address target = 0xE9E697933260a720d42146268B2AAAfA4211DE1C;//0xEAC31aabA7442B58Bd7A8431d1D3Db3Bf3262667;
        allowedProposal = address(0xd5D575E71245442009EE208E8DCEBFbcF958b8B6);
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "CALL FAILED");
        return success;
    }

    function callback() public override returns(bool) {
        // assume we update the diamond storage here

        // now we lock some staking position
        DoSomething x = DoSomething(address(0xd5D575E71245442009EE208E8DCEBFbcF958b8B6));
        x.something();

        return true;
    }
}

uint256 constant ONE_MADTOKEN = 10**18;

contract GovernanceProposeModifySnapshotTest is DSTest, Setup {
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
            IERC20Transferable(address(madToken)),
            address(admin),
            address(address(0x0))
        );
        minerStake = MinerStake(address (new StakeNFT(
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

    function testExecuteProposalModifySnapshot() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        GovernanceProposeModifySnapshot logic = new GovernanceProposeModifySnapshot();
        emit log_named_address("Contract address", address(logic));
        emit log_named_address("Snapshot address", address(snapshots));
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

        uint256 epoch = snapshots.epoch();
        assertEq(epoch, 1);
        emit log_named_uint("epoch", epoch);

        snapshots.snapshot(signatureGroup, bclaims);

        uint256 newEpoch = snapshots.epoch();
        assertEq(newEpoch, 2);

        assertEq0(snapshots.getRawSignatureSnapshot(epoch), signatureGroup);
        assertEq0(snapshots.getRawBlockClaimsSnapshot(epoch), bclaims);
        assertEq(uint256(snapshots.getChainIdFromSnapshot(epoch)), 42);
        assertEq(uint256(snapshots.getHeightFromSnapshot(epoch)), 1);
        assertEq(uint256(snapshots.getMadHeightFromSnapshot(epoch)), 5);

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

        assertEq(snapshots.epoch(), 666);
        assertEq0("0xbeefdead", snapshots.getRawSignatureSnapshot(epoch));
        assertEq0("0xdeadbeef", snapshots.getRawBlockClaimsSnapshot(epoch));
        assertEq(uint256(snapshots.getChainIdFromSnapshot(epoch)), 123);
        assertEq(uint256(snapshots.getHeightFromSnapshot(epoch)), 456);
        assertEq(uint256(snapshots.getMadHeightFromSnapshot(epoch)), 789);
    }

    function testExecuteProposalModifySnapshotFromCopyOfTheTemplate() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        GovernanceProposeModifySnapshotCopy logic = new GovernanceProposeModifySnapshotCopy();
        emit log_named_address("Contract address", address(logic));
        emit log_named_address("Snapshot address", address(snapshots));
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

    function testFail_ExecuteProposalModifySnapshotWithoutGovernance() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();

        GovernanceProposeModifySnapshot logic = new GovernanceProposeModifySnapshot();
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

        uint256 epoch = snapshots.epoch();
        assertEq(epoch, 1);

        governanceManager.execute(proposalID);
    }

    function testFail_ExecuteProposalModifySnapshotWithoutPermission() public {
        sudo.modifyDiamondStorage(address(this));
    }

    function testFail_ExecuteModifyStakeAfterStorageWithoutGovernanceOnCallback() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        //emit log_named_address("stakeNFT", address(stakeNFT));

        TryModifyStakeAfterStorage logic = new TryModifyStakeAfterStorage();
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
            //emit log_named_address("user", address(user));
            madToken.approve(address(stakeNFT), 11_220_000 * 10**18);
            uint256 tokenID = stakeNFT.mintTo(address(user), 11_220_000 * 10**18, 1);
            user.voteAsStaker(proposalID, tokenID);
        }

        uint256 epoch = snapshots.epoch();
        assertEq(epoch, 1);

        governanceManager.execute(proposalID);
    }

    function testExecuteModifyStakeAfterStorageWithAllowedProposal() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        emit log_named_address("stakeNFT", address(stakeNFT));

        ModifyStakeAfterStorage logic = new ModifyStakeAfterStorage();
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
            emit log_named_address("user", address(user));
            madToken.approve(address(stakeNFT), 11_220_000 * 10**18);
            uint256 tokenID = stakeNFT.mintTo(address(user), 11_220_000 * 10**18, 1);
            user.voteAsStaker(proposalID, tokenID);
        }

        uint256 epoch = snapshots.epoch();
        assertEq(epoch, 1);

        governanceManager.execute(proposalID);
    }

    function testExecuteModifyStakeAfterStorageFromOutsideWithAllowedProposal() public {
        (
            StakeNFT stakeNFT,
            MinerStake minerStake,
            MadTokenMock madToken,
            AdminAccount admin,
            GovernanceManager governanceManager
        ) = getFixtureData();
        sudo.setGovernance(address(governanceManager));
        DoSomething ds = new DoSomething();

        emit log_named_address("ds", address(ds));
        ModifyStakeAfterStorageFromOutside logic = new ModifyStakeAfterStorageFromOutside();
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
            emit log_named_address("user", address(user));
            madToken.approve(address(stakeNFT), 11_220_000 * 10**18);
            uint256 tokenID = stakeNFT.mintTo(address(user), 11_220_000 * 10**18, 1);
            emit log_named_uint("tokenID", tokenID);
            user.voteAsStaker(proposalID, tokenID);
        }

        uint256 epoch = snapshots.epoch();
        assertEq(epoch, 1);

        governanceManager.execute(proposalID);
    }
}
