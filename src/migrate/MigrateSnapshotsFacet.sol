// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../facets/AccessControlLibrary.sol";
import "../facets/SnapshotsLibrary.sol";

import "../Constants.sol";

contract MigrateSnapshotsFacet is AccessControlled, Constants {

    /// @notice Saves a specific snapshot skipping validation
    /// @param snapshotId The snapshot to save
    /// @param _signatureGroup The signature
    /// @param _bclaims The claims being made about given block
    function snapshot(
        uint256 snapshotId, 
        bytes calldata _signatureGroup, 
        bytes calldata _bclaims
    ) external onlyOperator {

        SnapshotsLibrary.SnapshotsStorage storage ss = SnapshotsLibrary.snapshotsStorage();

        // Extract
        uint32 chainId = SnapshotsLibrary.extractUint32(_bclaims, 8);
        uint32 height = SnapshotsLibrary.extractUint32(_bclaims, 12);

        // Store snapshot
        SnapshotsLibrary.Snapshot storage currentSnapshot = ss.snapshots[snapshotId];

        currentSnapshot.saved = true;
        currentSnapshot.rawBlockClaims = _bclaims;
        currentSnapshot.rawSignature = _signatureGroup;
        currentSnapshot.ethHeight = uint32(block.number);
        currentSnapshot.madHeight = height;
        currentSnapshot.chainId = chainId;

        bool reinitEthdkg;
        if (ss.validatorsChanged) {
            reinitEthdkg = true;
        }
        ss.validatorsChanged = false;

        emit SnapshotsLibrary.SnapshotTaken(chainId, snapshotId, height, msg.sender, ss.validatorsChanged);
    }
}