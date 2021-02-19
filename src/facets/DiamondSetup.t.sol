// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "./ParticipantsFacet.sol";
import "./SnapshotsFacet.sol";
import "./StakingFacet.sol";

import "../Constants.sol";
import "../Registry.sol";
import "../Token.sol";
import "../ValidatorsDiamond.sol";

import "../interfaces/Participants.sol";
import "../interfaces/Snapshots.sol";
import "../interfaces/Staking.sol";
import "../interfaces/Token.sol";
import "../interfaces/Validators.sol";

contract DiamondSetup is Constants {

    uint constant INITIAL_AMOUNT = 1_000_000_000_000_000_000_000_000;

    Registry registry;

    BasicERC20 stakingToken;
    BasicERC20 utilityToken;

    Participants participants;
    Snapshots snapshots;
    Staking staking;
    Validators validators;
    ValidatorsUpdateFacet update;


    address diamond;

    function setUp() public {

        diamond = address(new ValidatorsDiamond());

        address participantsFacet = address(new ParticipantsFacet());
        address snapshotsFacet = address(new SnapshotsFacet());
        address stakingFacet = address(new StakingFacet());

        update = ValidatorsUpdateFacet(diamond);

        stakingToken = BasicERC20(address(new Token("STK", "MadNet Staking")));
        utilityToken = BasicERC20(address(new Token("UTL", "MadNet Utility")));

        registry = new Registry();
        
        registry.register(CRYPTO_CONTRACT, address(new Crypto()));

        registry.register(STAKING_CONTRACT, diamond);
        registry.register(VALIDATORS_CONTRACT, diamond);

        registry.register(STAKING_TOKEN, address(stakingToken));
        registry.register(UTILITY_TOKEN, address(utilityToken));

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
        update.addFacet(Staking.lockStakeFor.selector, stakingFacet);
        update.addFacet(Staking.minimumStake.selector, stakingFacet);
        update.addFacet(Staking.unlockRewardFor.selector, stakingFacet);
        update.addFacet(Staking.setEpochDelay.selector, stakingFacet);
        update.addFacet(Staking.setMinimumStake.selector, stakingFacet);

        // ParticipantsFacet Wiring
        update.addFacet(Participants.initializeParticipants.selector, participantsFacet);
        update.addFacet(Participants.addValidator.selector, participantsFacet);
        update.addFacet(Participants.confirmValidators.selector, participantsFacet);
        update.addFacet(Participants.getValidators.selector, participantsFacet);
        update.addFacet(Participants.getValidatorPublicKey.selector, participantsFacet);
        update.addFacet(Participants.isValidator.selector, participantsFacet);
        update.addFacet(Participants.queueValidator.selector, participantsFacet);
        update.addFacet(Participants.removeValidator.selector, participantsFacet);
        update.addFacet(Participants.setValidatorMaxCount.selector, participantsFacet);
        update.addFacet(Participants.validatorCount.selector, participantsFacet);

        participants = Participants(diamond);
        snapshots = Snapshots(diamond);
        staking = Staking(diamond);
        validators = Validators(diamond);

        participants.initializeParticipants(registry);
        snapshots.initializeSnapshots(registry);
        staking.initializeStaking(registry);

        // Base scenario setup
        stakingToken.approve(address(staking), INITIAL_AMOUNT);
        utilityToken.approve(address(staking), INITIAL_AMOUNT);

        snapshots.setEpoch(1);
        participants.setValidatorMaxCount(10);
        staking.setMinimumStake(999_999_999);
    }

}
