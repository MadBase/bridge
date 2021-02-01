// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma experimental ABIEncoderV2;

import "../Crypto.sol";

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
        address cryptoAddress;
    }

    function snapshotsStorage() internal pure returns (SnapshotsStorage storage ss) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ss.slot := position // From solidity 0.6 -> 0.7 syntax changes from '_' to '.'
        }
    }

}