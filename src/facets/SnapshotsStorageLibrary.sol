// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

library SnapshotsStorageLibrary {
    bytes32 constant STORAGE_LOCATION = keccak256("snapshots.storage");

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
        uint256 nextSnapshot;
        bool validatorsChanged;     // i.e. when we do nextSnapshot will there be different validators?
        uint256 minEthSnapshotSize;
        uint256 minMadSnapshotSize;
    }

    function snapshotsStorage() internal pure returns (SnapshotsStorage storage ss) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ss_slot := position // From solidity 0.6 -> 0.7 syntax changes from '_' to '.'
        }
    }

}