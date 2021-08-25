// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

library BaseParserLibrary {

    // Size of a word, in bytes.
    uint internal constant WORD_SIZE = 32;
    // Size of the header of a 'bytes' array.
    uint internal constant BYTES_HEADER_SIZE = 32;

    function extract_uint32(bytes memory src, uint256 idx)
        internal
        pure
        returns (uint32 val)
    {
        val = uint8(src[idx + 3]);
        val = (val << 8) | uint8(src[idx + 2]);
        val = (val << 8) | uint8(src[idx + 1]);
        val = (val << 8) | uint8(src[idx]);
    }

    function extract_uint256(bytes memory src, uint256 offset)
        internal
        pure
        returns (uint256 val)
    {
        for (uint256 idx = offset + 31; idx > offset; idx--) {
            val = uint8(src[idx]) | (val << 8);
        }
        val = uint8(src[offset]) | (val << 8);
    }

    function reverse(bytes memory orig)
        internal
        pure
        returns (bytes memory reversed)
    {
        reversed = new bytes(orig.length);
        for (uint256 idx = 0; idx < orig.length; idx++) {
            reversed[orig.length - idx - 1] = orig[idx];
        }
    }

    // Copy 'len' bytes from memory address 'src', to address 'dest'.
    // This function does not check the or destination, it only copies
    // the bytes.
    function copy(uint src, uint dest, uint len) internal pure {
        // Copy word-length chunks while possible
        for (; len >= WORD_SIZE; len -= WORD_SIZE) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += WORD_SIZE;
            src += WORD_SIZE;
        }

        // Copy remaining bytes
        uint mask = 256 ** (WORD_SIZE - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    // Returns a memory pointer to the data portion of the provided bytes array.
    function dataPtr(bytes memory bts) internal pure returns(uint addr) {
        assembly {
            addr := add(bts, BYTES_HEADER_SIZE)
        }
    }

    // Returns a new bytes array with length `howManyBytes`, extracted from `src`'s `offset` forward.
    // Extracting the 32-64th bytes out of a 64 bytes array takes ~7828 gas.
    function extract_bytes(
        bytes memory src,
        uint256 offset,
        uint256 howManyBytes
    ) internal pure returns (bytes memory out) {
        out = new bytes(howManyBytes);
        uint256 start;

        assembly {
            start := add(add(src, offset), BYTES_HEADER_SIZE)
        }
        
        copy(start, dataPtr(out), howManyBytes);
    }
}
