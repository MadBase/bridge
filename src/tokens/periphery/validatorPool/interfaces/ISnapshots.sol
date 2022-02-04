// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "../../../../parsers/BClaimsParserLibrary.sol";

interface ISnapshots {
    event SnapshotTaken(
        uint256 chainId,
        uint256 indexed epoch,
        uint256 height,
        address indexed validator,
        bool safeToProceedConsensus
    );

    struct Snapshot {
        uint256 committedAt;
        BClaimsParserLibrary.BClaims blockClaims;
        uint256[2] signature;
    }

    function setEpochLength(uint32 epochLength_) external;

    function setSnapshotDesperationDelay(uint32 desperationDelay_) external;

    function getSnapshotDesperationDelay() external view returns (uint256);

    function setSnapshotDesperationFactor(uint32 desperationFactor_) external;

    function getSnapshotDesperationFactor() external view returns (uint256);

    function getChainId() external view returns (uint256);

    function getEpoch() external view returns (uint256);

    function getEpochLength() external view returns (uint256);

    function getChainIdFromSnapshot(uint256 snapshotNumber) external view returns (uint256);

    function getChainIdFromLatestSnapshot() external view returns (uint256);

    function getBlockClaimsFromSnapshot(uint256 snapshotNumber)
        external
        view
        returns (BClaimsParserLibrary.BClaims memory);

    function getBlockClaimsFromLatestSnapshot()
        external
        view
        returns (BClaimsParserLibrary.BClaims memory);

    function getSignatureFromSnapshot(uint256 snapshotNumber)
        external
        view
        returns (uint256[2] memory);

    function getSignatureFromLatestSnapshot() external view returns (uint256[2] memory);

    function getCommittedHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint256);

    function getCommittedHeightFromLatestSnapshot() external view returns (uint256);

    function getMadnetHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint256);

    function getMadnetHeightFromLatestSnapshot() external view returns (uint256);

    function getSnapshot(uint256 snapshotNumber) external view returns (Snapshot memory);

    function getLatestSnapshot() external view returns (Snapshot memory);

    function snapshot(bytes calldata signatureGroup_, bytes calldata bClaims_)
        external
        returns (bool);

    function mayValidatorSnapshot(
        int256 numValidators,
        int256 myIdx,
        int256 blocksSinceDesperation,
        bytes32 blsig,
        int256 desperationFactor
    ) external pure returns (bool);
}
