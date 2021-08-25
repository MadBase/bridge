// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

library BaseParserLibrary {
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

    // [PASS] test_extract_rclaim_prevBlock() (gas: 14035)
    function extract_bytes(
        bytes memory src,
        uint256 offset,
        uint256 howManyBytes
    ) internal pure returns (bytes memory) {
        uint256 end = offset + howManyBytes;
        bytes memory val = new bytes(howManyBytes);

        uint256 j = 0;
        // todo: I'm sure there's an assembly OPCODE to do this in a single instruction
        for (uint256 idx = offset; idx < end; idx++) {
            val[j] = src[idx];
            j++;
        }

        return val;
    }
}
