// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;


library ParsersLibrary {

    // base parsers

    function extract_uint32(bytes memory src, uint256 idx) internal pure returns(uint32 val) {
        val = uint8(src[idx+3]);
        val = (val << 8) | uint8(src[idx+2]);
        val = (val << 8) | uint8(src[idx+1]);
        val = (val << 8) | uint8(src[idx]);
    }

    function extract_uint256(bytes memory src, uint256 offset) internal pure returns (uint256 val) {
        for (uint idx = offset+31; idx > offset; idx--) {
            val = uint8(src[idx]) | (val << 8);
        }

        val = uint8(src[offset]) | (val << 8);
    }

    function reverse(bytes memory orig) internal pure returns (bytes memory reversed) {
        reversed = new bytes(orig.length);
        for (uint idx = 0; idx<orig.length; idx++) {
            reversed[orig.length-idx-1] = orig[idx];
        }
    }

/*
    // [PASS] test_extract_rclaim_prevBlock() (gas: 14035)
    function extract_bytes(bytes memory src, uint256 offset, uint256 howManyBytes) internal pure returns (bytes memory) {
        uint256 j=0;
        uint256 end = offset + howManyBytes;
        bytes memory val = new bytes(howManyBytes);

        // todo: I'm sure there's an assembly OPCODE to do this in a single instruction
        for (uint256 idx = offset; idx < end; idx++) {
            val[j] = src[idx];
            j++;
        }

        return val;
    }
*/
    // [PASS] test_extract_rclaim_prevBlock() (gas: 446)
    function extract_bytes(bytes memory src, uint256 offset, uint256 howManyBytes) internal pure returns (bytes memory) {
        bytes memory val = new bytes(howManyBytes);

        assembly {
            //mstore(add(add(val, offset), 32), add(src, 32))
            //mstore(val, howManyBytes)
            mstore(add(val, 32), add(add(src, 32), offset))
            //mstore(add(val, 32), add(src, offset))

            //return(val, 32)
        }

        return val;
    }

    // rclaims parsers

    function extract_rclaim_chainId(bytes memory src) internal pure returns(uint32) {
        return extract_uint32(src, 8);
    }

    function extract_rclaim_height(bytes memory src) internal pure returns(uint32) {
        return extract_uint32(src, 12);
    }

    function extract_rclaim_round(bytes memory src) internal pure returns(uint32) {
        return extract_uint32(src, 16);
    }

    function extract_rclaim_prevBlock(bytes memory src) internal pure returns(bytes memory) {
        return extract_bytes(src, 32, 32);
    }
}