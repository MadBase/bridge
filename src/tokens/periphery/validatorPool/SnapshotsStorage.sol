// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;


import "./interfaces/IValidatorPool.sol";
import "../ethdkg/interfaces/IETHDKG.sol";
import "../../../utils/DeterministicAddress.sol";


abstract contract SnapshotsStorage is DeterministicAddress {
    uint32 internal _epoch;
    // after how many eth blocks of not having a snapshot will we start allowing more validators to
    // make it
    uint32 internal _snapshotDesperationDelay;
    // how quickly more validators will be allowed to make a snapshot, once
    // _snapshotDesperationDelay has passed
    uint32 internal _snapshotDesperationFactor;

    mapping(uint256 => Snapshot) internal _snapshots;

    address internal _admin;

    address internal immutable _factory;
    IETHDKG internal immutable _ethdkg;
    IValidatorPool internal immutable _validatorPool;
    uint256 internal immutable _epochLength;
    uint256 internal immutable _chainId;

    constructor(uint256 chainId_, uint256 epochLength_) {
        _factory = msg.sender;
        // bytes32("ETHDKG") = 0x455448444b470000000000000000000000000000000000000000000000000000;
        _ethdkg = IETHDKG(
            getMetamorphicContractAddress(
                0x455448444b470000000000000000000000000000000000000000000000000000,
                _factory
            )
        );
        // bytes32("ValidatorPool") = 0x56616c696461746f72506f6f6c00000000000000000000000000000000000000;
        _validatorPool = IValidatorPool(
            getMetamorphicContractAddress(
                0x56616c696461746f72506f6f6c00000000000000000000000000000000000000,
                _factory
            )
        );
        _chainId = chainId_;
        _epochLength = epochLength_;
    }
}