// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./ChainStatusLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./StakingLibrary.sol";
import "../../parsers/RCertParserLibrary.sol";

import "../../CryptoLibrary.sol";
import "../../Registry.sol";

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
        bool validatorsChanged;            // i.e. when we do nextSnapshot will there be different validators?
        uint256 minEthSnapshotSize;        // i.e. how many mad blocks between each snapshot (aka EpochLength)
        uint256 minMadSnapshotSize;        // i.e. the bare minimum amount of eth blocks to have been passed between snapshots
        uint256 snapshotDesperationDelay;  // i.e. after how many eth blocks of not having a snapshot will we start allowing more validators to make it
        uint256 snapshotDesperationFactor; // i.e. how quickly more validators will be allowed to make a snapshot, once snapshotDesperationDelay has passed
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
    
    event log(string _message, int _i);

    /// @notice Saves next snapshot
    /// @param _signatureGroup The signature
    /// @param _bclaims The claims being made about given block
    /// @return Flag whether we should kick off another round of key generation
    function snapshot(bytes calldata _signatureGroup, bytes calldata _bclaims) internal returns (bool) {

        ChainStatusLibrary.ChainStatusStorage storage cs = ChainStatusLibrary.chainStatusStorage();
        SnapshotsStorage storage ss = snapshotsStorage();

        {
            uint256[4] memory publicKey;
            uint256[2] memory signature;
            (publicKey, signature) = RCertParserLibrary.extractSigGroup(_signatureGroup, 0);

            bytes memory blockHash = abi.encodePacked(keccak256(_bclaims));

            require(CryptoLibrary.Verify(blockHash, signature, publicKey), "Signature verification failed");
        }

        // Extract
        uint32 madHeight = extractUint32(_bclaims, 12);

        // Store snapshot
        uint32 chainId = extractUint32(_bclaims, 8);
        {
            Snapshot storage currentSnapshot = ss.snapshots[cs.epoch];

            currentSnapshot.saved = true;
            currentSnapshot.rawBlockClaims = _bclaims;
            currentSnapshot.rawSignature = _signatureGroup;
            currentSnapshot.ethHeight = uint32(block.number);
            currentSnapshot.madHeight = madHeight;
            currentSnapshot.chainId = chainId;
        }

        uint ethBlocksSinceLastSnapshot;
        {
            Snapshot memory previousSnapshot = ss.snapshots[cs.epoch-1];
            if (cs.epoch > 1) {
                ethBlocksSinceLastSnapshot = block.number - previousSnapshot.ethHeight;

                require(
                    !previousSnapshot.saved || ethBlocksSinceLastSnapshot >= ss.minEthSnapshotSize,
                    "snapshot heights too close in Ethereum"
                );

                require(
                    !previousSnapshot.saved || madHeight - previousSnapshot.madHeight >= ss.minMadSnapshotSize,
                    "snapshot heights too close in MadNet"
                );
            }
        }

        {
            int index = -1;
            
            ParticipantsLibrary.ParticipantsStorage storage ps = ParticipantsLibrary.participantsStorage();
            {
                StakingLibrary.StakingStorage storage stakingS = StakingLibrary.stakingStorage();
                for (uint idx=0; idx<ps.validators.length; idx++) {
                    if (msg.sender==ps.validators[idx]) {
                        index = int(idx);
                        StakingLibrary.lockRewardFor(ps.validators[idx], stakingS.rewardAmount + stakingS.rewardBonus, cs.epoch+2);
                    } else {
                        StakingLibrary.lockRewardFor(ps.validators[idx], stakingS.rewardAmount, cs.epoch+2);
                    }
                }
            }
            {
                emit log("index", index);
            }
            require(index != -1, "unknown validator");
            require(
                mayValidatorSnapshot(int(ps.validators.length), index, int(ethBlocksSinceLastSnapshot)-int(ss.snapshotDesperationDelay), _signatureGroup, int(ss.snapshotDesperationFactor)),
                string(abi.encodePacked("validator not among allowed ", int2str(index), ", ", int2str(int(ethBlocksSinceLastSnapshot)-int(ss.snapshotDesperationDelay)), ", ", int2str(int(ss.snapshotDesperationFactor))))
            );
        }
        

        bool reinitEthdkg;
        if (ss.validatorsChanged) {
            reinitEthdkg = true;
        }
        ss.validatorsChanged = false;

        emit SnapshotTaken(chainId, cs.epoch, madHeight, msg.sender, ss.validatorsChanged);

        cs.epoch++;

        return reinitEthdkg;
    }

    function mayValidatorSnapshot(int numValidators, int myIdx, int blocksSinceDesperation, bytes memory blsig, int desperationFactor) public pure returns (bool) {        
        int numValidatorsAllowed = 1;
        
        for (int i = blocksSinceDesperation; i > 0;) {
            i -= desperationFactor/numValidatorsAllowed;
            numValidatorsAllowed++;
            
            if (numValidatorsAllowed > numValidators/3) break;
        }
        
        uint rand;
        require(blsig.length >= 32, "slicing out of range");
        assembly {
            rand := mload(add(blsig, 0x20)) // load underlying memory buffer as uint256, but skip first 32 bytes as these define the length
        }

        int start = int(rand%uint(numValidators));
        int end = (start + numValidatorsAllowed)%numValidators;
        if (end > start) {
            return myIdx >= start && myIdx < end;
        } else {
            return myIdx >= start || myIdx < end;
        }
    }
    
    
    /////////////////////////////
    function int2str(int a) public pure returns (string memory) {
        if (a == 0) return "0";
        bool neg = a < 0;
        uint u = uint(neg ? -a : a);

        uint len;
        for (uint i = u; i != 0; i /= 10) len++;
        if (neg) ++len;
        
        bytes memory b = new bytes(len);
        uint j = len;
        for (uint i = u; i != 0; i /= 10) {
            b[--j] = bytes1(uint8(48 + i % 10));
        }
        if (neg) b[0] = '-';
        
        return string(b);
    }

    function uint2str(uint a) public pure returns (string memory) {
        if (a == 0) return "0";

        uint len;
        for (uint i = a; i != 0; i /= 10) len++;
        
        bytes memory b = new bytes(len);
        uint j = len;
        for (uint i = a; i != 0; i /= 10) {
            b[--j] = bytes1(uint8(48 + i % 10));
        }
        
        return string(b);
    }


    function bytes2str(bytes memory a) public pure returns (string memory) {
        uint len = 2 + a.length*2;
        bytes memory b = new bytes(len);
        b[0] = "0";
        b[1] = "x";

        uint j = 2;
        for (uint i = 0; i < a.length; i++) {
            uint8 u = uint8(a[i]);

            uint8 x = u / 16;
            b[j++] = bytes1(x + (x >= 10 ? 55 : 48));

            x = u % 16;
            b[j++] = bytes1(x + (x >= 10 ? 55 : 48));
        }
        
        return string(b);
    }

}
