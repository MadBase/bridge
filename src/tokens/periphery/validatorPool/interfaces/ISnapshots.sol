// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

interface ISnapshots {
    function setMinEthSnapshotSize(uint256 minSize_) external;

    function minEthSnapshotSize() external view returns (uint256);

    function setSnapshotDesperationDelay(uint256 minSize_) external;

    function snapshotDesperationDelay() external view returns (uint256);

    function setSnapshotDesperationFactor(uint256 minSize_) external;

    function snapshotDesperationFactor() external view returns (uint256);

    function setMinMadSnapshotSize(uint256 minSize_) external;

    function minMadSnapshotSize() external view returns (uint256);

    function setEpoch(uint256 ns) external;

    function getEpoch() external view returns (uint256);

    function getChainIdFromSnapshot(uint256 snapshotNumber) external view returns (uint32);

    function getRawBlockClaimsSnapshot(uint256 snapshotNumber) external view returns (bytes memory);

    function getRawSignatureSnapshot(uint256 snapshotNumber) external view returns (bytes memory);

    function getHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint32);

    function getMadHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint32);

    function getChainIdFromLatestSnapshot(uint256 snapshotNumber) external view returns (uint32);

    function getRawBlockClaimsFromLatestSnapshot() external view returns (bytes memory);

    function getRawSignatureFromLatestSnapshot() external view returns (bytes memory);

    function getHeightFromLatestSnapshot() external view returns (uint32);

    function getMadHeightFromLatestSnapshot() external view returns (uint32);

    function snapshot(bytes calldata signatureGroup_, bytes calldata bClaims_)
        external
        returns (bool);
}
