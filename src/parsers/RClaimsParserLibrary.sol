// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

library RClaimsParserLibrary {

    struct RClaims {
        uint32 chainID;
        uint32 height;
        uint32 round;
        bytes prevBlock;
    }

    function extract_chainId(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 8);
    }

    function extract_height(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 12);
    }

    function extract_round(bytes memory src) internal pure returns(uint32) {
        return BaseParserLibrary.extract_uint32(src, 16);
    }

    function extract_prevBlock(bytes memory src) internal pure returns(bytes memory) {
        // todo Maybe we can change this to extract uint256?
        return BaseParserLibrary.extract_bytes(src, 32, 32);
    }

    function extract_rclaims(bytes memory src) internal pure returns(RClaims memory rclaims) {
        // todo measure gas cost of this 4 extract_* abstractions. We can call
        // the BaseParserLibrary directly
        rclaims.chainID = extract_chainId(src);
        rclaims.height = extract_height(src);
        rclaims.round = extract_round(src);
        rclaims.prevBlock = extract_prevBlock(src);
        return rclaims;
    }

}