pragma solidity >= 0.5.15;


library MerkleTreeLibrary {
    // Check if the bit at the given 'index' in 'self' is set.
    // Returns:
    //  'true' - if the value of the bit is '1'
    //  'false' - if the value of the bit is '0'
    function bitSet(uint256 self, uint16 index) public pure returns (bool) {
        return (self >> (255 - index)) & 1 == 1;
    }

    function checkProof(
        bytes memory proof, // [c6136f4517a635e3e56d0011b93c95a03922694646a8d902a4ec2ccfdfaa75db ed37516ea28daa4edc94a63b91d9e63645f4b7a04e3d9739d76b7e2efbb3ab20]
        bytes32 root, // 51f16d008cec2409af8104a0bca9facec585e02c12d2fa5221707672410dc692
        bytes32 hash, // 82f8a0dcf79808641766767fd284413ffc6a7ccc3e170001c5d5acae0ff65a8a
        uint256 key, // 7a6315f5d19bf3f3bed9ef4e6002ebf76d4d05a7f7e84547e20b40fde2c34411
        uint256 bitset, // 3
        uint256 height, // 2
        bool included, // true
        uint256 proofKey // 0
    ) public pure returns (bool) {
        bytes32 el;
        bytes32 h = hash;

        bytes32 defaultLeaf = bytes32(
            hex"bc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a"
        );

        uint16 proofIdx = 0;

        for (uint256 i = 0; i < height; i++) {
            if (bitSet(bitset, 255 - uint16(i))) {
                proofIdx += 32;
                assembly {
                    el := mload(add(proof, proofIdx))
                }
            } else {
                el = defaultLeaf;
            }

            if (bitSet(key, 255 - uint16(i))) {
                h = keccak256(abi.encodePacked(el, h));
            } else {
                h = keccak256(abi.encodePacked(h, el));
            }
        }

        if (included == false) {
            for (uint256 i = 0; i < 256; i++) {
                if (
                    bitSet(key, 255 - uint16(i)) !=
                    bitSet(proofKey, 255 - uint16(i))
                ) {
                    return false;
                }
            }
        }

        return h == root;
    }
}