// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "./interfaces/ISnapshots.sol";
import "./interfaces/IValidatorPool.sol";
import "../ethdkg/interfaces/IETHDKG.sol";
import "../../../parsers/RCertParserLibrary.sol";
import "../../../parsers/BClaimsParserLibrary.sol";
import "../../../CryptoLibrary.sol";


contract Snapshots is ISnapshots {
    uint32 internal _epoch;
    uint32 internal _epochLength;

    // after how many eth blocks of not having a snapshot will we start allowing more validators to
    // make it
    uint32 internal _snapshotDesperationDelay;
    // how quickly more validators will be allowed to make a snapshot, once
    // _snapshotDesperationDelay has passed
    uint32 internal _snapshotDesperationFactor;

    mapping(uint256 => Snapshot) internal _snapshots;

    address internal _admin;

    IETHDKG internal immutable _ethdkg;
    IValidatorPool internal immutable _validatorPool;
    uint256 internal immutable _chainId;

    constructor(
        IETHDKG ethdkg_,
        IValidatorPool validatorPool_,
        uint32 chainID_,
        address factory_
    ) {
        _ethdkg = ethdkg_;
        _validatorPool = validatorPool_;
        _chainId = chainID_;
        _epochLength = 1024;
        _admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Snapshots: Only admin allowed!");
        _;
    }

    function setEpochLength(uint32 epochLength_) public onlyAdmin {
        _epochLength = epochLength_;
    }

    function setSnapshotDesperationDelay(uint32 desperationDelay_) public onlyAdmin {
        _snapshotDesperationDelay = desperationDelay_;
    }

    function getSnapshotDesperationDelay() public view returns (uint256) {
        return _snapshotDesperationDelay;
    }

    function setSnapshotDesperationFactor(uint32 desperationFactor_) public onlyAdmin {
        _snapshotDesperationFactor = desperationFactor_;
    }

    function getSnapshotDesperationFactor() public view returns (uint256) {
        return _snapshotDesperationFactor;
    }

    function getChainId() public view returns (uint256) {
        return _chainId;
    }

    function getEpoch() public view returns (uint256) {
        return _epoch;
    }

    function getEpochLength() public view returns (uint256) {
        return _epochLength;
    }

    function getChainIdFromSnapshot(uint256 snapshotNumber) public view returns (uint256) {
        return _snapshots[snapshotNumber].blockClaims.chainId;
    }

    function getChainIdFromLatestSnapshot() public view returns (uint256) {
        return _snapshots[_epoch].blockClaims.chainId;
    }

    function getBlockClaimsFromSnapshot(uint256 snapshotNumber)
        public
        view
        returns (BClaimsParserLibrary.BClaims memory)
    {
        return _snapshots[snapshotNumber].blockClaims;
    }

    function getBlockClaimsFromLatestSnapshot()
        public
        view
        returns (BClaimsParserLibrary.BClaims memory)
    {
        return _snapshots[_epoch].blockClaims;
    }

    function getSignatureFromSnapshot(uint256 snapshotNumber)
        public
        view
        returns (uint256[2] memory)
    {
        return _snapshots[snapshotNumber].signature;
    }

    function getSignatureFromLatestSnapshot() public view returns (uint256[2] memory) {
        return _snapshots[_epoch].signature;
    }

    function getCommittedHeightFromSnapshot(uint256 snapshotNumber) public view returns (uint256) {
        return _snapshots[snapshotNumber].committedAt;
    }

    function getCommittedHeightFromLatestSnapshot() public view returns (uint256) {
        return _snapshots[_epoch].committedAt;
    }

    function getMadnetHeightFromSnapshot(uint256 snapshotNumber) public view returns (uint256) {
        return _snapshots[snapshotNumber].blockClaims.height;
    }

    function getMadnetHeightFromLatestSnapshot() public view returns (uint256) {
        return _snapshots[_epoch].blockClaims.height;
    }

    function getSnapshot(uint256 snapshotNumber) public view returns (Snapshot memory) {
        return _snapshots[snapshotNumber];
    }

    function getLatestSnapshot() public view returns (Snapshot memory) {
        return _snapshots[_epoch];
    }

    /// @notice Saves next snapshot
    /// @param groupSignature_ The group signature used to sign the snapshots' block claims
    /// @param bClaims_ The claims being made about given block
    /// @return Flag whether we should kick off another round of key generation
    function snapshot(bytes calldata groupSignature_, bytes calldata bClaims_)
        public
        returns (bool)
    {
        require(_validatorPool.isValidator(msg.sender), "Snapshots: Only validators allowed!");
        require(!_ethdkg.isETHDKGRunning(), "Snapshots: There's an ETHDKG round running!");

        (bool success, uint256 validatorIndex) = _ethdkg.tryGetParticipantIndex(msg.sender);
        require(success, "Snapshots: Caller didn't participate in the last ethdkg round!");

        //todo: are we going to snapshot on epoch 0?
        uint32 epoch = _epoch + 1;
        uint256 ethBlocksSinceLastSnapshot = block.number - _snapshots[epoch - 1].committedAt;
        int256 blocksSinceDesperation = int256(ethBlocksSinceLastSnapshot) -
            int256(uint256(_snapshotDesperationDelay));
        // Check if sender is the elected validator allowed to make the snapshot
        require(
            _mayValidatorSnapshot(
                int256(_validatorPool.getValidatorsCount()),
                int256(validatorIndex) - 1,
                blocksSinceDesperation,
                keccak256(bClaims_),
                int256(uint256(_snapshotDesperationFactor))
            ),
            "Snapshots: Validator not elected to do snapshot!"
        );

        (uint256[4] memory masterPublicKey, uint256[2] memory signature) = RCertParserLibrary
            .extractSigGroup(groupSignature_, 0);

        require(
            keccak256(abi.encodePacked(masterPublicKey)) ==
                keccak256(abi.encodePacked(_ethdkg.getMasterPublicKey())),
            "Snapshots: Wrong master public key!"
        );

        require(
            CryptoLibrary.Verify(abi.encodePacked(keccak256(bClaims_)), signature, masterPublicKey),
            "Snapshots: Signature verification failed!"
        );

        BClaimsParserLibrary.BClaims memory blockClaims = BClaimsParserLibrary.extractBClaims(
            bClaims_
        );

        require(
            blockClaims.height % _epochLength == 0,
            "Snapshots: Incorrect Madnet height for snapshot!"
        );

        require(blockClaims.chainId == _chainId, "Snapshots: Incorrect chainID for snapshot!");

        bool isSafeToProceedConsensus = true;
        if (_validatorPool.isMaintenanceScheduled()) {
            isSafeToProceedConsensus = false;
            _validatorPool.pauseConsensus();
        }

        _snapshots[epoch] = Snapshot(block.number, blockClaims, signature);
        _epoch = epoch;

        emit SnapshotTaken(
            _chainId,
            epoch,
            blockClaims.height,
            msg.sender,
            isSafeToProceedConsensus
        );
        return isSafeToProceedConsensus;
    }

    function mayValidatorSnapshot(
        int256 numValidators,
        int256 myIdx,
        int256 blocksSinceDesperation,
        bytes32 blsig,
        int256 desperationFactor
    ) public pure returns (bool) {
        return
            _mayValidatorSnapshot(
                numValidators,
                myIdx,
                blocksSinceDesperation,
                blsig,
                desperationFactor
            );
    }

    function _mayValidatorSnapshot(
        int256 numValidators,
        int256 myIdx,
        int256 blocksSinceDesperation,
        bytes32 blsig,
        int256 desperationFactor
    ) internal pure returns (bool) {
        int256 numValidatorsAllowed = 1;

        for (int256 i = blocksSinceDesperation; i >= 0; ) {
            i -= desperationFactor / numValidatorsAllowed;
            numValidatorsAllowed++;

            if (numValidatorsAllowed > numValidators / 3) break;
        }

        //blocksSinceDesperation - desperationFactor - desperationFactor/2 - desperationFactor/3
        uint256 rand = uint256(blsig);
        int256 start = int256(rand % uint256(numValidators));
        int256 end = (start + numValidatorsAllowed) % numValidators;

        if (end > start) {
            return myIdx >= start && myIdx < end;
        } else {
            return myIdx >= start || myIdx < end;
        }
    }
}
