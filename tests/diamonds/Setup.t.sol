// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

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
    ValidatorLocations validatorLocations;

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
        validatorLocations = ValidatorLocations(validatorsDiamond);

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
        address validatorLocationsFacet = address(new ValidatorLocationsFacet());

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

        // ValidatorLocations wiring
        update.addFacet(ValidatorLocations.setMyLocation.selector, validatorLocationsFacet);
        update.addFacet(ValidatorLocations.getMyLocation.selector, validatorLocationsFacet);
        update.addFacet(ValidatorLocations.getLocations.selector, validatorLocationsFacet);
        update.addFacet(ValidatorLocations.getLocation.selector, validatorLocationsFacet);

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
