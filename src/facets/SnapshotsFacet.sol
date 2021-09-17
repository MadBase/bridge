// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma abicoder v2;

import "../interfaces/SnapshotsEvents.sol";

import "./AccessControlLibrary.sol";
import "./ChainStatusLibrary.sol";
import "./SnapshotsLibrary.sol";
import "./StopLibrary.sol";

import "../Constants.sol";
import "../CryptoLibrary.sol";
import "../Registry.sol";

contract SnapshotsFacet is AccessControlled, Constants, SnapshotsEvents, Stoppable {

    function initializeSnapshots(Registry registry) external onlyOperator {
        require(address(registry) != address(0), "nil registry address");
    }

    function setMinEthSnapshotSize(uint256 _minSize) external onlyOperator {
        SnapshotsLibrary.snapshotsStorage().minEthSnapshotSize = _minSize;
    }

    function minEthSnapshotSize() external view returns (uint256) {
        return SnapshotsLibrary.snapshotsStorage().minEthSnapshotSize;
    }

    function setMinMadSnapshotSize(uint256 _minSize) external onlyOperator {
        SnapshotsLibrary.snapshotsStorage().minMadSnapshotSize = _minSize;
    }

    function minMadSnapshotSize() external view returns (uint256) {
        return SnapshotsLibrary.snapshotsStorage().minMadSnapshotSize;
    }

    function setEpoch(uint256 ns) external onlyOperator {
        ChainStatusLibrary.setEpoch(ns);
    }

    function epoch() external view returns (uint256) {
        return ChainStatusLibrary.epoch();
    }

    function extractUint32(bytes calldata src, uint idx) external pure returns (uint32 val) {
        return SnapshotsLibrary.extractUint32(src, idx);
    }

    function extractUint256(bytes calldata src, uint offset) external pure returns (uint256 val) {
        return SnapshotsLibrary.extractUint256(src, offset);
    }

    function reverse(bytes memory orig) external pure returns (bytes memory reversed) {
        return SnapshotsLibrary.reverse(orig);
    }

    function parseSignatureGroup(bytes memory _signatureGroup) external pure returns (uint256[4] memory publicKey, uint256[2] memory signature) {
        return SnapshotsLibrary.parseSignatureGroup(_signatureGroup);
    }

    function getChainIdFromSnapshot(uint256 snapshotNumber) external view returns (uint32) {
        return SnapshotsLibrary.getChainIdFromSnapshot(snapshotNumber);
    }

    function getRawBlockClaimsSnapshot(uint256 snapshotNumber) external view returns (bytes memory) {
        return SnapshotsLibrary.getRawBlockClaimsSnapshot(snapshotNumber);
    }

    function getRawSignatureSnapshot(uint256 snapshotNumber) external view returns (bytes memory) {
        return SnapshotsLibrary.getRawSignatureSnapshot(snapshotNumber);
    }

    function getHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint32) {
        return SnapshotsLibrary.getHeightFromSnapshot(snapshotNumber);
    }

    function getMadHeightFromSnapshot(uint256 snapshotNumber) external view returns (uint32) {
        return SnapshotsLibrary.getMadHeightFromSnapshot(snapshotNumber);
    }

    function snapshot(bytes calldata _signatureGroup, bytes calldata _bclaims) external participantOrOperator returns (bool) {
        return SnapshotsLibrary.snapshot(_signatureGroup, _bclaims);
    }
}
