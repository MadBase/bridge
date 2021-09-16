pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";

/// @title Library to parse the BClaims structure from a blob of capnproto data
library BClaimsParserLibrary {
    /** @dev size in bytes of a BCLAIMS cap'npro structure without the cap'n
      proto header bytes*/
    uint256 internal constant BCLAIMS_SIZE = 176;
    /** @dev Number of bytes of a capnproto header, the data starts after the
      header */
    uint256 internal constant CAPNPROTO_HEADER_SIZE = 8;

    struct BClaims {
        uint32 chainId;
        uint32 height;
        bytes32 prevBlock;
        uint32 txCount;
        bytes32 txRoot;
        bytes32 stateRoot;
        bytes32 headerRoot;
    }

    /**
    @notice This function is for serializing data directly from capnproto
            BClaims. It will skip the first 8 bytes (capnproto headers) and
            deserialize the BClaims Data. If BClaims is being extracted from
            inside of other structure (E.g PClaims capnproto) use the
            `extractBClaims(bytes, uint)` instead.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @dev Execution cost: 2167 gas
    function extractBClaims(bytes memory src)
        internal
        pure
        returns (BClaims memory bClaims)
    {
        // Size in capnproto words (16 bytes) of the data section
        uint16 dataSectionSize = BaseParserLibrary.extractUInt16(src, 4);
        require(dataSectionSize > 0 && dataSectionSize <= 2, "BClaimsParserLibrary: The size of the data section should be 1 or 2 words!");
        uint16 pointerOffsetAdjustment;
        // In case the txCount is 0, the value is not included in the binary
        // blob by capnproto. Therefore, we need to deduce 8 bytes from the
        // pointer's offset.
        if (dataSectionSize == 1){
            pointerOffsetAdjustment = 8;
        } else {
            pointerOffsetAdjustment = 0;
        }
        return extractBClaims(src, CAPNPROTO_HEADER_SIZE, pointerOffsetAdjustment);
    }

    /**
    @notice This function is for serializing the BClaims struct from an defined
            location inside a binary blob. E.G Extract BClaims from inside of
            other structure (E.g PClaims capnproto) or skipping the capnproto
            headers.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @param dataOffset offset to start reading the BClaims data from inside src
    /// @dev Execution cost: 1930 gas
    function extractBClaims(bytes memory src, uint256 dataOffset, uint16 pointerOffsetAdjustment)
        internal
        pure
        returns (BClaims memory bClaims)
    {
        require(
            dataOffset + BCLAIMS_SIZE - pointerOffsetAdjustment > dataOffset,
            "BClaimsParserLibrary: Invalid deserialization. Overflow on the dataOffset parameter"
        );
        require(
            src.length >= dataOffset + BCLAIMS_SIZE - pointerOffsetAdjustment,
            "BClaimsParserLibrary: Invalid deserialization. Not enough bytes to extract BClaims"
        );

        // In case the txCount is 0, the value is not included in the binary
        // blob by capnproto.
        if (pointerOffsetAdjustment == 0){
            bClaims.txCount = BaseParserLibrary.extractUInt32(src, dataOffset + 8);
        } else {
            bClaims.txCount = 0;
        }

        bClaims.chainId = BaseParserLibrary.extractUInt32(src, dataOffset);
        require(bClaims.chainId > 0, "BClaimsParserLibrary: Invalid deserialization. The chainId should be greater than 0!");
        bClaims.height = BaseParserLibrary.extractUInt32(src, dataOffset + 4);
        require(bClaims.height > 0, "BClaimsParserLibrary: Invalid deserialization. The height should be greater than 0!");
        bClaims.prevBlock = BaseParserLibrary.extractBytes32(src, dataOffset + 48 - pointerOffsetAdjustment);
        bClaims.txRoot = BaseParserLibrary.extractBytes32(src, dataOffset + 80 - pointerOffsetAdjustment);
        bClaims.stateRoot = BaseParserLibrary.extractBytes32(src, dataOffset + 112 - pointerOffsetAdjustment);
        bClaims.headerRoot = BaseParserLibrary.extractBytes32(src, dataOffset + 144 - pointerOffsetAdjustment);
    }
}
