// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./ChainStatusLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./StakingLibrary.sol";

import "../CryptoLibrary.sol";
import "../Registry.sol";

library SnapshotsLibrary {
    bytes32 constant STORAGE_LOCATION = keccak256("snapshots.storage");

    event SnapshotTaken(uint32 chainId, uint256 indexed epoch, uint32 height, address indexed validator, bool startingETHDKG);

    struct Snapshot {
        bool saved;
        uint32 chainId;
        bytes rawBlockClaims;
        bytes rawSignature;
        uint32 ethHeight;
        uint32 madHeight;
    }

    struct SnapshotsStorage {
        mapping(uint256 => Snapshot) snapshots;
        // uint256 nextSnapshot;
        bool validatorsChanged;     // i.e. when we do nextSnapshot will there be different validators?
        uint256 minEthSnapshotSize;
        uint256 minMadSnapshotSize;
    }

    function snapshotsStorage() internal pure returns (SnapshotsStorage storage ss) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ss.slot := position
        }
    }

    //
    //
    //

    function extractUint32(bytes memory src, uint idx) internal pure returns (uint32 val) {
        val = uint8(src[idx+3]);
        val = (val << 8) | uint8(src[idx+2]);
        val = (val << 8) | uint8(src[idx+1]);
        val = (val << 8) | uint8(src[idx]);
    }

    function extractUint256(bytes memory src, uint offset) internal pure returns (uint256 val) {
        for (uint idx = offset+31; idx > offset; idx--) {
            val = uint8(src[idx]) | (val << 8);
        }

        val = uint8(src[offset]) | (val << 8);
    }

    function reverse(bytes memory orig) internal pure returns (bytes memory reversed) {
        reversed = new bytes(orig.length);
        for (uint idx = 0; idx<orig.length; idx++) {
            reversed[orig.length-idx-1] = orig[idx];
        }
    }

    function parseSignatureGroup(bytes memory _signatureGroup) internal pure returns (uint256[4] memory publicKey, uint256[2] memory signature) {

        // Go big.Ints are big endian but Solidity is little endian
        bytes memory signatureGroup = reverse(_signatureGroup);

        signature[1] = extractUint256(signatureGroup, 0);
        signature[0] = extractUint256(signatureGroup, 32);
        publicKey[3] = extractUint256(signatureGroup, 64);
        publicKey[2] = extractUint256(signatureGroup, 96);
        publicKey[1] = extractUint256(signatureGroup, 128);
        publicKey[0] = extractUint256(signatureGroup, 160);
    }

    function getChainIdFromSnapshot(uint256 snapshotNumber) internal view returns (uint32) {
        SnapshotsStorage storage ss = snapshotsStorage();
        Snapshot storage snapshotDetail = ss.snapshots[snapshotNumber];

        return snapshotDetail.chainId;
    }

    function getRawBlockClaimsSnapshot(uint256 snapshotNumber) internal view returns (bytes memory) {
        SnapshotsStorage storage ss = snapshotsStorage();
        Snapshot storage snapshotDetail = ss.snapshots[snapshotNumber];

        return snapshotDetail.rawBlockClaims;
    }

    function getRawSignatureSnapshot(uint256 snapshotNumber) internal view returns (bytes memory) {
        SnapshotsStorage storage ss = snapshotsStorage();
        Snapshot storage snapshotDetail = ss.snapshots[snapshotNumber];

        return snapshotDetail.rawSignature;
    }

    function getHeightFromSnapshot(uint256 snapshotNumber) internal view returns (uint32) {
        SnapshotsStorage storage ss = snapshotsStorage();
        Snapshot storage snapshotDetail = ss.snapshots[snapshotNumber];

        return snapshotDetail.ethHeight;
    }

    function getMadHeightFromSnapshot(uint256 snapshotNumber) internal view returns (uint32) {
        SnapshotsStorage storage ss = snapshotsStorage();
        Snapshot storage snapshotDetail = ss.snapshots[snapshotNumber];

        return snapshotDetail.madHeight;
    }

    /// @notice Saves next snapshot
    /// @param _signatureGroup The signature
    /// @param _bclaims The claims being made about given block
    /// @return Flag whether we should kick off another round of key generation

    function snapshot(bytes calldata _signatureGroup, bytes calldata _bclaims) internal returns (bool) {

        ChainStatusLibrary.ChainStatusStorage storage cs = ChainStatusLibrary.chainStatusStorage();
        SnapshotsStorage storage ss = snapshotsStorage();

        uint256[4] memory publicKey;
        uint256[2] memory signature;
        (publicKey, signature) = parseSignatureGroup(_signatureGroup);

        bytes memory blockHash = abi.encodePacked(keccak256(_bclaims));

        bool ok = CryptoLibrary.Verify(blockHash, signature, publicKey);
        require(ok, "Signature verification failed");

        // Extract
        uint32 chainId = extractUint32(_bclaims, 8);
        uint32 height = extractUint32(_bclaims, 12);

        // Store snapshot
        Snapshot storage currentSnapshot = ss.snapshots[cs.epoch];

        currentSnapshot.saved = true;
        currentSnapshot.rawBlockClaims = _bclaims;
        currentSnapshot.rawSignature = _signatureGroup;
        currentSnapshot.ethHeight = uint32(block.number);
        currentSnapshot.madHeight = height;
        currentSnapshot.chainId = chainId;

        if (cs.epoch > 1) {
            Snapshot memory previousSnapshot = ss.snapshots[cs.epoch-1];

            require(
                !previousSnapshot.saved || block.number >= previousSnapshot.ethHeight + ss.minEthSnapshotSize,
                "snapshot heights too close in Ethereum"
            );

            require(
                !previousSnapshot.saved || height >= previousSnapshot.madHeight + ss.minMadSnapshotSize,
                "snapshot heights too close in MadNet"
            );

        }

        ParticipantsLibrary.ParticipantsStorage storage ps = ParticipantsLibrary.participantsStorage();
        StakingLibrary.StakingStorage storage stakingS = StakingLibrary.stakingStorage();

        for (uint idx=0; idx<ps.validators.length; idx++) {
            if (msg.sender==ps.validators[idx]) {
                StakingLibrary.lockRewardFor(ps.validators[idx], stakingS.rewardAmount + stakingS.rewardBonus, cs.epoch+2);
            } else {
                StakingLibrary.lockRewardFor(ps.validators[idx], stakingS.rewardAmount, cs.epoch+2);
            }
        }

        bool reinitEthdkg;
        if (ss.validatorsChanged) {
            reinitEthdkg = true;
        }
        ss.validatorsChanged = false;

        emit SnapshotTaken(chainId, cs.epoch, height, msg.sender, ss.validatorsChanged);

        cs.epoch++;

        return reinitEthdkg;
    }

}
