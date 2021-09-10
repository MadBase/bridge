// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

/// @title Library to parse the MerkleProof structure from a blob of binary data
library MerkleProofParserLibrary {
    /** @dev minimum size in bytes of a MERKLE_PROOF binary structure
      (considering no proofs and not bitset array) */
    uint256 internal constant MERKLE_PROOF_SIZE = 103;

    struct MerkleProof {
        bool included;
        uint16 keyHeight;
        bytes32 key;
        bytes32 proofKey;
        bytes32 proofValue;
        bytes bitmap;
        bytes auditPath;
    }

    /**
    @notice This function is for serializing the MerkleProof struct from a
            binary blob.
    */
    /// @param src Blob of binary data with a MerkleProof serialization
    /// @dev Execution cost: 1332 gas
    function extractMerkleProof(bytes memory src)
        internal
        pure
        returns (MerkleProof memory mProof)
    {
        require(
            src.length >= MERKLE_PROOF_SIZE,
            "MerkleProofLibrary: Not enough bytes to extract MerkleProof"
        );
        // mProof.included = BaseParserLibrary.extractBytes(src, 0);
        // mProof.keyHeight = BaseParserLibrary.extractUInt16(src, 1);

        // rClaims.chainId = BaseParserLibrary.extractUInt32(src, dataOffset);
        // rClaims.height = BaseParserLibrary.extractUInt32(src, dataOffset + 4);
        // rClaims.round = BaseParserLibrary.extractUInt32(src, dataOffset + 8);
        // rClaims.prevBlock = BaseParserLibrary.extractBytes32(
        //     src,
        //     dataOffset + 24
        // );
    }
}
