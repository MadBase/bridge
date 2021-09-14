pragma solidity >= 0.5.15;

import "../parsers/MerkleProofParserLibrary.sol";

library MerkleProofLibrary {
    // Check if the bit at the given 'index' in 'self' is set.
    // Returns:
    //  'true' - if the value of the bit is '1'
    //  'false' - if the value of the bit is '0'
    function bitSet(bytes memory self, uint16 index) internal pure returns (bool) {
        uint256 val;
        assembly {
            val := shr(sub(255, index), and(mload(add(self, 0x20)), shl(sub(255, index), 1)))
        }
        return val == 1;
    }

    function bitSetBytes32(bytes32 self, uint16 index) internal pure returns (bool) {
        uint256 val;
        assembly {
            val := shr(sub(255, index), and(self, shl(sub(255, index), 1)))
        }
        return val == 1;
    }

    function computeLeafHash(bytes32 _key, bytes32 value, uint16 proofHeight) internal pure returns (bytes32){
        require(proofHeight <= 256 && proofHeight > 0, "Invalid proofHeight, the values should be greater 0 and less than 256")
        return keccak256(abi.encodePacked(_key, value, uint8(256 - proofHeight)));
        //question is possible to have a proof Lenght of 0. E.g when there's only one value in the trie
    }

    function checkProofAbs(MerkleProofParserLibrary.MerkleProof memory _proof, bytes32 root) internal pure {
        if (_proof.proofKey == 0 && _proof.proofValue == 0) {
            // Non-inclusion default value
            bytes32 _keyHash = bytes32(
                hex"bc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a"
            );
            bool result = checkProof(_proof.auditPath, root, _keyHash,  _proof.key, _proof.bitmap, _proof.keyHeight);
            require(result, "Proof is not valid 1");
            // if result == true our key is not in there
        } else if (_proof.proofKey != 0 && _proof.proofValue != 0) {
            // Non-inclusion leaf node
            bytes32 _keyHash = computeLeafHash(_proof.proofKey, _proof.proofValue, _proof.keyHeight);
            bool result = checkProof(_proof.auditPath, root, _keyHash,  _proof.key, _proof.bitmap, _proof.keyHeight);
            require(result, "Proof is not valid 2");
        } else if (_proof.proofKey == 0 && _proof.proofValue != 0) {
            bytes32 _keyHash = computeLeafHash(_proof.key, _proof.proofValue, _proof.keyHeight);
            bool result = checkProof(_proof.auditPath, root, _keyHash,  _proof.key, _proof.bitmap, _proof.keyHeight);
            require(result, "Proof is not valid 3");
        }
        require(_proof.proofKey != 0 && _proof.proofValue == 0, "Proof is not valid 4");
    }

    function checkProof(
        bytes memory proofValue,
        bytes32 root,
        bytes32 keyHash,
        bytes32 key,
        bytes memory bitset,
        uint16 proofHeight
    ) internal pure returns(bool){
        bytes32 el;
        bytes32 h = keyHash;

        bytes32 defaultLeaf = bytes32(
            hex"bc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a"
        );

        uint16 proofIdx = 0;

        require(proofHeight > 0 && proofHeight <= 256, "");
        for (uint256 i = 0; i < proofHeight; i++) {
            if (bitSet(bitset, uint16(i))) {
                proofIdx += 32;
                assembly {
                    el := mload(add(proofValue, proofIdx))
                }
            } else {
                el = defaultLeaf;
            }

            if (bitSetBytes32(key, proofHeight - 1 - uint16(i))) {
                h = keccak256(abi.encodePacked(el, h));
            } else {
                h = keccak256(abi.encodePacked(h, el));
            }
        }
        return h == root;
        //require(h == root, "Proof is not valid");
        // We can send a valid hash and key and say that it's invalid by sending a invalid proofKey and say that included is false!
    }
}