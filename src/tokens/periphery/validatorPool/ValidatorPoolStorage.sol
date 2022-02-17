// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;
import "../../../utils/DeterministicAddress.sol";
import "../../interfaces/INFTStake.sol";
import "../../interfaces/IERC20Transferable.sol";
import "../ethdkg/interfaces/IETHDKG.sol";

abstract contract ValidatorPoolStorage is DeterministicAddress {
    // _positionLockPeriod describes the maximum interval a STAKENFT Position may be locked after
    // being given back to validator exiting the pool
    uint256 public immutable _positionLockPeriod;
    // Interval in Madnet Epochs that a validator exiting the pool should before claiming is
    // STAKENFT position
    uint256 public immutable _claimPeriod;

    // Maximum number the ethereum blocks allowed without a validator committing a snapshot
    uint256 public immutable _maxIntervalWithoutSnapshot;

    address internal immutable _factory;
    INFTStake internal immutable _stakeNFT;
    INFTStake internal immutable _validatorsNFT;
    IERC20Transferable internal immutable _madToken;
    IETHDKG internal immutable _ethdkg;
    ISnapshots internal immutable _snapshots;

    // Minimum amount to stake
    uint256 internal _stakeAmount;
    // Max number of validators allowed in the pool
    uint256 internal _maxNumValidators;
    // Value in WEIs to be discounted of dishonest validator in case of slashing event. This value
    // is usually sent back to the disputer
    uint256 internal _disputerReward;

    // Boolean flag to be read by the snapshot contract in order to decide if the validator set
    // needs to be changed or not (i.e if a validator is going to be removed or added).
    bool internal _isMaintenanceScheduled;
    // Boolean flag to keep track if the consensus is running in the side chain or not. Validators
    // can only join or leave the pool in case this value is false.
    bool internal _isConsensusRunning;

    // The internal iterable mapping that tracks all ACTIVE validators in the Pool
    ValidatorDataMap internal _validators;

    // Mapping that keeps track of the validators leaving the Pool. Validators assets are hold by
    // `_claimPeriod` epochs before the user being able to claim the assets back in the form a new
    // STAKENFT position.
    mapping(address => ExitingValidatorData) internal _exitingValidatorsData;

    // Mapping to keep track of the active validators IPs.
    mapping(address => string) internal _ipLocations;

    address internal _admin;

    constructor() {
        _factory = msg.sender;
        // bytes32("Snapshots") = 0x536e617073686f74730000000000000000000000000000000000000000000000;
        _snapshots = ISnapshots(
            getMetamorphicContractAddress(
                0x536e617073686f74730000000000000000000000000000000000000000000000,
                _factory
            )
        );
        // bytes32("ETHDKG") = 0x455448444b470000000000000000000000000000000000000000000000000000;
        _ethdkg = IETHDKG(
            getMetamorphicContractAddress(
                0x455448444b470000000000000000000000000000000000000000000000000000,
                _factory
            )
        );
        // bytes32("StakeNFT") = 0x5374616b654e4654000000000000000000000000000000000000000000000000
        _stakeNFT = INFTStake(
            getMetamorphicContractAddress(
                0x5374616b654e4654000000000000000000000000000000000000000000000000,
                _factory
            )
        );

        // bytes32("ValidatorNFT") = 0x56616c696461746f724e46540000000000000000000000000000000000000000
        _validatorsNFT = INFTStake(
            getMetamorphicContractAddress(
                0x56616c696461746f724e46540000000000000000000000000000000000000000,
                _factory
            )
        );

        _madToken = IERC20Transferable(
            getMetamorphicContractAddress(
                0x4d6164546f6b656e000000000000000000000000000000000000000000000000,
                _factory
            )
        );

        _positionLockPeriod = 172800;
        _claimPeriod = 3;
        _maxIntervalWithoutSnapshot = 8192;
    }
}
