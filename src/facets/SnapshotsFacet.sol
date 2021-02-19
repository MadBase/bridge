// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;
pragma experimental ABIEncoderV2;

import "../interfaces/SnapshotsEvents.sol";

import "./AccessControlLibrary.sol";
import "./SnapshotsLibrary.sol";
import "./StopLibrary.sol";

import "../Constants.sol";
import "../Crypto.sol";
import "../Registry.sol";

contract SnapshotsFacet is AccessControlled, Constants, SnapshotsEvents, Stoppable {

    function initializeSnapshots(Registry registry) external onlyOperator {
        require(address(registry) != address(0), "nil registry address");

        address cryptoAddress = registry.lookup(CRYPTO_CONTRACT);
        require(cryptoAddress != address(0), "nil crypto address");

        SnapshotsLibrary.setCrypto(cryptoAddress);
    }

    function setEpoch(uint256 ns) external onlyOperator {
        SnapshotsLibrary.setEpoch(ns);
    }

    function epoch() external view returns (uint256) {
        return SnapshotsLibrary.epoch();
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

    function snapshot(bytes calldata _signatureGroup, bytes calldata _bclaims) external onlyOperator returns (bool) {
        return SnapshotsLibrary.snapshot(_signatureGroup, _bclaims);
    }
}