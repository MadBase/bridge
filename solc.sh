#!/bin/sh

solc \
    --optimize-runs 2000000 \
    --pretty-json \
    --combined-json abi,bin \
    @openzeppelin/=$(pwd)/node_modules/@openzeppelin/ \
    -o ./out \
    --overwrite \
    ./src/Registry.sol \
    ./src/DirectGovernance.sol \
    ./src/SimpleAuth.sol \
    ./src/Token.sol \
    ./src/TokenMigrator.sol \
    ./src/diamonds/Diamond.sol \
    ./src/ERC165.sol \
    ./src/Crypto.sol \
    ./src/SafeMath.sol \
    ./src/Constants.sol \
    ./src/Deposit.sol \
    ./src/diamonds/ValidatorsDiamond.sol \
    ./src/diamonds/migrate/MigrateSnapshotsFacet.sol \
    ./src/diamonds/migrate/MigrateStakingFacet.sol \
    ./src/diamonds/migrate/MigrateParticipantsFacet.sol \
    ./src/diamonds/migrate/MigrateETHDKG.sol \
    ./src/diamonds/facets/SnapshotsFacet.sol \
    ./src/diamonds/facets/StakingFacet.sol \
    ./src/diamonds/facets/ParticipantsFacet.sol \
    ./src/diamonds/facets/DiamondUpdateFacet.sol \
    ./src/diamonds/interfaces/StakingEvents.sol \
    ./src/diamonds/interfaces/Validators.sol \
    ./src/diamonds/interfaces/ValidatorsEvents.sol \
    ./src/diamonds/interfaces/ValidatorLocations.sol \
    ./src/diamonds/facets/ValidatorLocationsFacet.sol \
    ./src/diamonds/interfaces/Token.sol \
    ./src/diamonds/interfaces/Participants.sol \
    ./src/diamonds/interfaces/SnapshotsEvents.sol \
    ./src/diamonds/interfaces/Staking.sol \
    ./src/diamonds/interfaces/ParticipantsEvents.sol \
    ./src/diamonds/interfaces/Snapshots.sol \
    ./src/tokens/periphery/ethdkg/ETHDKG.sol \
    ./src/tokens/periphery/ethdkg/ETHDKGAccusations.sol \
    ./src/tokens/periphery/ethdkg/ETHDKGPhases.sol \
    ./src/tokens/periphery/validatorPool/mocks/ValidatorPoolMock.sol