// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;
import "./RCertParserLibrary.sol";
import "./ParticipantsLibrary.sol";

library AccusationLibrary {

    //
    // Storage code to support diamond pattern
    //
    bytes32 constant STORAGE_LOCATION = keccak256("accusation.storage");

    struct AccusationStorage {
        // Not sure exactly what storage is needed yet
        mapping(address => int) accusations;
    }

    function accusationStorage() internal pure returns (AccusationStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

    //
    //
    //
    function AccuseMultipleProposal(
        bytes calldata _pClaim0,
        bytes calldata _pClaim1
    ) internal {
        // ecrecover sig0/1 and ensure both are valid and accounts are equal
        // ensure the hashes of blob0/1 are different
        // ensure the height of blob0/1 are equal using RCert sub object of PClaims
        // ensure the round of blob0/1 are equal using RCert sub object of PClaims
        // ensure the chainid of blob0/1 are equal using RCert sub object of PClaims
        // ensure the chainid of blob0 is correct for this chain using RCert sub object of PClaims
        // ensure both accounts are applicable to a currently locked validator - Note<may be done in different layer?>
        PClaimsParserLibrary.PClaims memory pClaims0 = PClaimsParserLibrary.extractPClaims(_pClaims0, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);
        PClaimsParserLibrary.PClaims memory pClaims1 = PClaimsParserLibrary.extractPClaims(_pClaims1, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);

        // todo: figure it out how to call this function and which is the data used
        // address signerAccount = recoverSigner(_signatureGroup0, abi.encodePacked(rCert.prevBlock))

        address signerAccount;
        // todo: figure it out what data is used to compute the hash (probably BClaims capandproData)

        require(rClaims0.RCert.RClaims.height == rClaims1.RCert.RClaims.height, "Invalid multiple proposal accusation, the block heights between the proposals are different!");
        require(rClaims0.RCert.RClaims.round == rClaims1.RCert.RClaims.round, "Invalid multiple proposal accusation, the round between the proposals are different!");
        require(rClaims0.RCert.RClaims.chainId == rClaims1.RCert.RClaims.chainId, "Invalid multiple proposal accusation, the chainId between the proposals are different!");

        // todo: double check what is the right chainId and if we have it stored somewhere else.
        require(rClaims0.RCert.RClaims.chainId == 42, "Invalid multiple proposal accusation, the chainId is invalid for this chain!");


        require(ParticipantsLibrary.isValidator(signerAccount), "Invalid multiple proposal accusation, the signer of these proposals is not a valid validator!");

    }

    //
    //
    //
    function recoverSigner(bytes memory signature, bytes memory message) internal pure returns (address) {

        bytes32 prefixedMessage = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message))
        );

        require(signature.length==65, "Signature should be 65 bytes");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly { // solium-disable-line
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        v = (v < 27) ? (v + 27) : v;

        require(v == 27 || v == 28, "Signature uses invalid version");

        return ecrecover(prefixedMessage, v, r, s);
    }

}