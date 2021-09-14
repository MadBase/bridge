// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

library BaseParserLibrary {
    // Size of a word, in bytes.
    uint256 internal constant WORD_SIZE = 32;
    // Size of the header of a 'bytes' array.
    uint256 internal constant BYTES_HEADER_SIZE = 32;

    /// Returns a uint32 extracted from `src`'s `offset` (~559 gas)
    function extractUInt32(bytes memory src, uint256 offset)
        internal
        pure
        returns (uint32 val)
    {
        require(
            offset + 4 > offset,
            "BaseParserLibrary: An overflow happened with the offset parameter!"
        );
        require(
            src.length >= offset + 4,
            "BaseParserLibrary: Trying to read an offset out of boundaries in the src binary!"
        );

        assembly {
            val := shr(sub(256, 32), mload(add(add(src, 0x20), offset)))
            val := or(
                or(
                    or(
                        shr(24, and(val, 0xff000000)),
                        shr(8, and(val, 0x00ff0000))
                    ),
                    shl(8, and(val, 0x0000ff00))
                ),
                shl(24, and(val, 0x000000ff))
            )
        }
    }

    /// Returns a uint16 extracted from `src`'s `offset` (~204 gas)
    function extractUInt16(bytes memory src, uint256 offset)
        internal
        pure
        returns (uint16 val)
    {
        require(
            offset + 2 > offset,
            "BaseParserLibrary: Error extracting uin16! An overflow happened with the offset parameter!"
        );
        require(
            src.length >= offset + 2,
            "BaseParserLibrary: Error extracting uin16! Trying to read an offset out of boundaries in the src binary!"
        );

        assembly {
            val := shr(sub(256, 16), mload(add(add(src, 0x20), offset)))
            val := or(
                        shr(8, and(val, 0xff00)),
                        shl(8, and(val, 0x00ff))
            )
        }
    }

    /// Returns a uint16 (which was encoded as BigEndian) from `src`'s `offset` (~204 gas)
    function extractUInt16FromBigEndian(bytes memory src, uint256 offset)
        internal
        pure
        returns (uint16 val)
    {
        require(
            offset + 2 > offset,
            "BaseParserLibrary: Error extracting uin16! An overflow happened with the offset parameter!"
        );
        require(
            src.length >= offset + 2,
            "BaseParserLibrary: Error extracting uin16! Trying to read an offset out of boundaries in the src binary!"
        );

        assembly {
            val := and(shr(sub(256, 16), mload(add(add(src, 0x20), offset))), 0xffff)
        }
    }

    /// Returns a boolean extracted from `src`'s `offset` (~204 gas)
    function extractBool(bytes memory src, uint256 offset)
        internal
        pure
        returns (bool)
    {
        require(
            offset + 1 > offset,
            "BaseParserLibrary: Error extracting bool! An overflow happened with the offset parameter!"
        );
        require(
            src.length >= offset + 1,
            "BaseParserLibrary: Error extracting bool! Trying to read an offset out of boundaries in the src binary!"
        );
        uint256 val;
        assembly {
            val := shr(sub(256, 8), mload(add(add(src, 0x20), offset)))
            val := and(val, 0x01)
        }
        return val == 1;
    }

    /// Returns a uint256 extracted from `src`'s `offset` (~5155 gas)
    function extractUInt256(bytes memory src, uint256 offset)
        internal
        pure
        returns (uint256 val)
    {
        require(
            offset + 31 > offset,
            "BaseParserLibrary: An overflow happened with the offset parameter!"
        );
        require(
            src.length > offset + 31,
            "BaseParserLibrary: Trying to read an offset out of boundaries!"
        );
        for (uint256 idx = offset + 31; idx > offset; idx--) {
            val = uint8(src[idx]) | (val << 8);
        }
        val = uint8(src[offset]) | (val << 8);
    }

    /// Returns a bytes array reverted from `orig` (~13832 gas)
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
    function copy(
        uint256 src,
        uint256 dest,
        uint256 len
    ) internal pure {
        // Copy word-length chunks while possible
        for (; len >= WORD_SIZE; len -= WORD_SIZE) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += WORD_SIZE;
            src += WORD_SIZE;
        }
        // Returning earlier if there's no leftover bytes to copy
        if (len == 0) {
            return;
        }
        // Copy remaining bytes
        uint256 mask = 256**(WORD_SIZE - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    /// Returns a memory pointer to the data portion of the provided bytes array.
    function dataPtr(bytes memory bts) internal pure returns (uint256 addr) {
        assembly {
            addr := add(bts, BYTES_HEADER_SIZE)
        }
    }

    /// Returns a new bytes array with length `howManyBytes`, extracted from `src`'s `offset` forward.
    /// Extracting the 32-64th bytes out of a 64 bytes array takes ~7828 gas.
    function extractBytes(
        bytes memory src,
        uint256 offset,
        uint256 howManyBytes
    ) internal pure returns (bytes memory out) {
        require(
            offset + howManyBytes >= offset,
            "BaseParserLibrary: An overflow happened with the offset or the howManyBytes parameter!"
        );
        require(
            src.length >= offset + howManyBytes,
            "BaseParserLibrary: Not enough bytes to extract in the src binary"
        );
        out = new bytes(howManyBytes);
        uint256 start;

        assembly {
            start := add(add(src, offset), BYTES_HEADER_SIZE)
        }

        copy(start, dataPtr(out), howManyBytes);
    }

    /// Returns a new bytes32 extracted from `src`'s `offset` forward. (~439 gas)
    function extractBytes32(bytes memory src, uint256 offset)
        internal
        pure
        returns (bytes32 out)
    {
        require(
            offset + 32 > offset,
            "BaseParserLibrary: An overflow happened with the offset parameter!"
        );
        require(
            src.length >= (offset + 32),
            "BaseParserLibrary: not enough bytes to extract"
        );
        assembly {
            out := mload(add(add(src, BYTES_HEADER_SIZE), offset))
        }
    }
}
