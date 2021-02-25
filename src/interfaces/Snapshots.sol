// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./SnapshotsEvents.sol";

import "../Registry.sol";

interface Snapshots is SnapshotsEvents {

    function initializeSnapshots(Registry registry) external;

    function setMinEthSnapshotSize(uint256 _minSize) external;

    function minEthSnapshotSize() external view returns (uint256);

    function setMinMadSnapshotSize(uint256 _minSize) external;

    function minMadSnapshotSize() external view returns (uint256);

    function setEpoch(uint256 ns) external;

    function epoch() external view returns (uint256);

    function extractUint32(bytes memory src, uint idx) external pure returns (uint32 val);

    function extractUint256(bytes memory src, uint offset) external pure returns (uint256 val);

    function reverse(bytes memory orig) external pure returns (bytes memory reversed);

    function parseSignatureGroup(bytes memory _signatureGroup) external pure returns (uint256[4] memory publicKey, uint256[2] memory signature);

    function getChainIdFromSnapshot(uint256 snapshotNumber) external view returns (uint32);

    function getRawBlockClaimsSnapshot(uint256 snapshotNumber) external view returns (bytes memory);

    function getRawSignatureSnapshot(uint256 snapshotNumber) external view returns (bytes memory);

    function getHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint32);

    function getMadHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint32);

    function snapshot(bytes calldata _signatureGroup, bytes calldata _bclaims) external returns (bool);
}