// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "../validatorPool/interfaces/IValidatorPool.sol";
import "../snapshots/interfaces/ISnapshots.sol";
import "../../../utils/immutableAuth.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "../../../proxy/Proxy.sol";
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

abstract contract ETHDKGStorage is Initializable, immutableFactory, immutableSnapshots, immutableValidatorPool {

    // ISnapshots internal immutable _snapshots;
    // IValidatorPool internal immutable _validatorPool;
    //address internal immutable _factory;
    uint256 internal constant  MIN_VALIDATOR = 4;

    uint64 internal _nonce;
    uint64 internal _phaseStartBlock;
    Phase internal _ethdkgPhase;
    uint32 internal _numParticipants;
    uint16 internal _badParticipants;
    uint16 internal _phaseLength;
    uint16 internal _confirmationLength;

    // Madnet height used to start the new validator set in arbitrary height points if the Madnet
    // Consensus is halted
    uint256 internal _customMadnetHeight;

    address internal _admin;

    uint256[4] internal _masterPublicKey;
    uint256[2] internal _mpkG1;

    mapping(address => Participant) internal _participants;

    constructor() immutableFactory(msg.sender) immutableSnapshots() immutableValidatorPool() {
        // _factory = msg.sender;
        // bytes32("Snapshots") = 0x536e617073686f74730000000000000000000000000000000000000000000000;
        // _snapshots = ISnapshots(getMetamorphicContractAddress(0x536e617073686f74730000000000000000000000000000000000000000000000, _factory));
        // bytes32("ValidatorPool") = 0x56616c696461746f72506f6f6c00000000000000000000000000000000000000;
        // _validatorPool = IValidatorPool(getMetamorphicContractAddress(0x56616c696461746f72506f6f6c00000000000000000000000000000000000000, _factory));
    }
}
