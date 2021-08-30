pragma solidity >=0.7.4;
pragma abicoder v2;

import "./BaseParserLibrary.sol";
import "./BClaimsParserLibrary.sol";
import "./RCertParserLibrary.sol";

/// @title Library to parse the PClaims structure from a blob of capnproto data
library PClaimsParserLibrary {
    /** @dev size in bytes of a PCLAIMS cap'npro structure without the cap'n
      proto header bytes*/
    uint256 internal constant PCLAIMS_SIZE = 440;
    /** @dev Number of bytes of a capnproto header, the data starts after the
      header */
    uint256 internal constant CAPNPROTO_HEADER_SIZE = 24;

    struct PClaims {
        BClaimsParserLibrary.BClaims bClaims;
        RCertParserLibrary.RCert rCert;
    }

    /**
    @notice This function is for serializing data directly from capnproto
            PClaims. It will skip the first 24 bytes (capnproto headers) and
            deserialize the PClaims Data. If PClaims is being extracted from
            inside of other structure (E.g Proposal capnproto) use the
            `extractPClaims(bytes, uint)` instead. This function more gas than
            `extractPClaims(bytes, uint)`.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @dev Execution cost: 6986 gas
    function extractPClaims(bytes memory src)
        internal
        pure
        returns (PClaims memory pClaims)
    {
        return extractPClaims(src, CAPNPROTO_HEADER_SIZE);
    }

    /**
    @notice This function is for serializing the PClaims struct from an defined
            location inside a binary blob. E.G Extract PClaims from inside of
            other structure (E.g Proposal capnproto) or skipping the capnproto
            headers.
    */
    /// @param src Blob of binary data with a capnproto serialization
    /// @param dataOffset offset to start reading the PClaims data from inside src
    /// @dev Execution cost: 6299 gas
    function extractPClaims(bytes memory src, uint256 dataOffset)
        internal
        pure
        returns (PClaims memory pClaims)
    {
        require(
            dataOffset + PCLAIMS_SIZE > dataOffset,
            "PClaimsParserLibrary: Overflow on the dataOffset parameter"
        );
        require(
            src.length >= dataOffset + PCLAIMS_SIZE,
            "PClaimsParserLibrary: Not enough bytes to extract PClaims"
        );
        pClaims.bClaims = BClaimsParserLibrary.extractBClaims(src, dataOffset);
        pClaims.rCert = RCertParserLibrary.extractRCert(
            src,
            dataOffset + BClaimsParserLibrary.BCLAIMS_SIZE
        );
    }
}
