// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "../validatorPool/interfaces/IValidatorPool.sol";
import "../validatorPool/interfaces/ISnapshots.sol";

enum Phase {
    RegistrationOpen,
    ShareDistribution,
    DisputeShareDistribution,
    KeyShareSubmission,
    MPKSubmission,
    GPKJSubmission,
    DisputeGPKJSubmission,
    Completion
}

// State of key generation
struct Participant {
    uint256[2] publicKey;
    uint64 nonce;
    uint64 index;
    Phase phase;
    bytes32 distributedSharesHash;
    uint256[2] commitmentsFirstCoefficient;
    uint256[2] keyShares;
    uint256[4] gpkj;
}

abstract contract ETHDKGStorage {
    uint64 internal _nonce;
    uint64 internal _phaseStartBlock;
    Phase internal _ethdkgPhase;
    uint32 internal _numParticipants;
    uint16 internal _badParticipants;

    uint16 internal _minValidators;
    uint16 internal _phaseLength;
    uint16 internal _confirmationLength;

    // Madnet height used to start the new validator set in arbitrary height points if the Madnet
    // Consensus is halted
    uint256 internal _customMadnetHeight;

    // todo: use contract factory with create2 to get rid of this
    ISnapshots internal _snapshots;
    // todo: use contract factory with create2 to get rid of this
    IValidatorPool internal _validatorPool;
    // todo: use contract factory with create2 to get rid of this
    address internal _ethdkgAccusations;

    // todo: use contract factory with create2 to get rid of this
    address internal _ethdkgPhases;

    address internal _factory;

    address internal _admin;

    uint256[4] internal _masterPublicKey;
    uint256[2] internal _mpkG1;

    mapping(address => Participant) internal _participants;
}
