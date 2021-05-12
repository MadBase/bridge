// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "./EthDKGCompletionFacet.sol";
import "./EthDKGGroupAccusationFacet.sol";
import "./EthDKGInformationFacet.sol";
import "./EthDKGInitializeFacet.sol";
import "./EthDKGMiscFacet.sol";
import "./EthDKGSubmitMPKFacet.sol";
import "./EthDKGSubmitDisputeFacet.sol";

import "./ParticipantsFacet.sol";
import "./SnapshotsFacet.sol";
import "./StakingFacet.sol";

import "../Constants.sol";
import "../EthDKGDiamond.sol";
import "../Registry.sol";
import "../Token.sol";
import "../ValidatorsDiamond.sol";

import "../interfaces/ETHDKG.sol";
import "../interfaces/Participants.sol";
import "../interfaces/Snapshots.sol";
import "../interfaces/Staking.sol";
import "../interfaces/Token.sol";
import "../interfaces/Validators.sol";

contract Setup is Constants {

    uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;
    uint constant MINIMUM_STAKE = 999_999_999;

    Registry registry;

    BasicERC20 stakingToken;
    BasicERC20 utilityToken;

    ETHDKG ethdkg;
    Participants participants;
    Snapshots snapshots;
    Staking staking;
    Validators validators;

    function setUp() public {
        registry = new Registry();

        setUpEthDKG(registry);
        setUpMisc(registry);
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

        address ethDKGDiamond = registry.lookup(ETHDKG_CONTRACT);
        ethdkg = ETHDKG(ethDKGDiamond);

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

    function setUpMisc(Registry _registry) public {
        _registry.register(STAKING_TOKEN, address(new Token("STK", "MadNet Staking")));
        _registry.register(UTILITY_TOKEN, address(new Token("UTL", "MadNet Utility")));
    }

    function setUpValidators(Registry _registry) public {

        address diamond = address(new ValidatorsDiamond());
        DiamondUpdateFacet update = DiamondUpdateFacet(diamond);

        // Create facets
        address participantsFacet = address(new ParticipantsFacet());
        address snapshotsFacet = address(new SnapshotsFacet());
        address stakingFacet = address(new StakingFacet());

        // SnapshotFacet Wiring
        update.addFacet(Snapshots.initializeSnapshots.selector, snapshotsFacet);
        update.addFacet(Snapshots.epoch.selector, snapshotsFacet);
        update.addFacet(Snapshots.extractUint256.selector, snapshotsFacet);
        update.addFacet(Snapshots.extractUint32.selector, snapshotsFacet);
        update.addFacet(Snapshots.setEpoch.selector, snapshotsFacet);
        update.addFacet(Snapshots.snapshot.selector, snapshotsFacet);
        update.addFacet(Snapshots.getRawSignatureSnapshot.selector, snapshotsFacet);
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

        // Wiring facets
        update.addFacet(ETHDKG.Group_Accusation_GPKj.selector, accusationFacet);
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

        _registry.register(ETHDKG_CONTRACT, diamond);
    }

}
