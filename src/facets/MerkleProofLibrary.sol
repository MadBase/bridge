pragma solidity >= 0.5.15;


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

    function checkProof(
        bytes memory proofValue,
        bytes32 root,
        bytes32 keyHash,
        bytes32 key,
        bytes memory bitset,
        uint16 proofHeight,
        bool included,
        bytes32 proofKey
    ) internal pure returns (bool) {
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

        if (included == false) {
            for (uint256 i = 255; i >= 0; i--) {
                if (
                    bitSetBytes32(key, uint16(i)) !=
                    bitSetBytes32(proofKey, uint16(i))
                ) {
                    return false;
                }
            }
        }

        return h == root;
        // We can send a valid hash and key and say that it's invalid by sending a invalid proofKey and say that included is false!
    }
}