// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

import "ds-stop/stop.sol";

import "./Constants.sol";
import "./Crypto.sol";
import "./ETHDKG.sol";
import "./QueueLibrary.sol";
import "./Registry.sol";
import "./Staking.sol";
import "./SignatureLibrary.sol";
import "./SimpleAuth.sol";

interface ValidatorEvents {
    event ValidatorCreated(address indexed validator, address indexed signer, uint256[2] madID);
    event ValidatorJoined(address indexed validator, uint256[2] madID);
    event ValidatorLeft(address indexed validator, uint256[2] pkHash);
    event ValidatorQueued(address indexed validator, uint256[2] pkHash);
    event SnapshotTaken(uint32 chainId, uint256 indexed epoch, uint32 height, address indexed validator, bool startingETHDKG);
}

contract ValidatorsStorage is Constants, ValidatorEvents {

    using QueueLibrary for QueueLibrary.Queue;
    using SignatureLibrary for bytes;

    // Required contracts
    QueueLibrary.Queue queue;
    Crypto crypto;
    ETHDKG ethdkg;
    Registry registry;
    Staking staking;

    // Values that should be configurable
    uint256 public minimumStake;
    uint256 public majorStakeFine;
    uint256 public minorStakeFine;
    uint256 public rewardAmount;
    uint256 public rewardBonus;
    uint8 public validatorMaxCount;

    // Validators specific constants
    uint32 constant ETH_SNAPSHOT_SIZE = 256;
    uint32 constant MAD_SNAPSHOT_SIZE = 1024;

    // Core state details and storage of Validators
    uint256 public epoch;
    uint256 committedRewards;
    bool validatorsChanged;
    address[] validators;
    mapping(address => uint256) validatorIndex;
    mapping(address => bool) validatorPresent;
    mapping(address => uint256[2]) validatorPublicKey;

    // Just keeps track of how many validators we currently have in the ring
    uint8 public validatorCount;

    // Validators will need this to delegate a call
    address validatorsSnapshot;

    // Content of snapshot
    struct Snapshot {
        bool saved;
        uint32 chainId;
        bytes rawBlockClaims;
        bytes rawSignature;
        uint32 ethHeight;
        uint32 madHeight;
    }
    mapping(uint256 => Snapshot) internal snapshots; // Key is epoch

    // Utility functions that just return values
    function getRawBlockClaimsSnapshot(uint256 _epoch) public view returns (bytes memory) {
        return snapshots[_epoch].rawBlockClaims;
    }

    function getRawSignatureSnapshot(uint256 _epoch) public view returns (bytes memory) {
        return snapshots[_epoch].rawSignature;
    }

    function getChainIdFromSnapshot(uint256 _epoch) public view returns (uint32) {
        return snapshots[_epoch].chainId;
    }

    function getHeightFromSnapshot(uint256 _epoch) public view returns (uint32) {
        return snapshots[_epoch].ethHeight;
    }

    function getMadHeightFromSnapshot(uint256 _epoch) public view returns (uint32) {
        return snapshots[_epoch].madHeight;
    }
}