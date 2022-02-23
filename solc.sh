#!/bin/sh

solc \
    --optimize \
    --optimize-runs 20000 \
    --pretty-json \
    --combined-json abi,bin \
    @openzeppelin/=$(pwd)/node_modules/@openzeppelin/ \
    -o ./out \
    --overwrite \
    ./src/Registry.sol \
    ./src/tokens/periphery/ethdkg/ETHDKG.sol \
    ./src/tokens/periphery/validatorPool/ValidatorPool.sol \
    ./src/tokens/periphery/snapshots/Snapshots.sol \
    ./src/tokens/periphery/governance/Governance.sol \
    ./src/tokens/MadByte.sol \
    ./src/tokens/MadToken.sol \
    ./src/tokens/StakeNFT.sol \
    ./src/tokens/ValidatorNFT.sol