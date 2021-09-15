// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "./MerkleProofLibrary.sol";
import "./ParticipantsLibrary.sol";
import "./SnapshotsLibrary.sol";
import "../parsers/PClaimsParserLibrary.sol";
import "../parsers/RCertParserLibrary.sol";
import "../parsers/MerkleProofParserLibrary.sol";
import "../parsers/TXInPreImageParserLibrary.sol";
import "../CryptoLibrary.sol";

library AccusationLibrary {

    /// @dev Storage code to support diamond pattern
    bytes32 constant STORAGE_LOCATION = keccak256("accusation.storage");

    struct AccusationStorage {
        // Not sure exactly what storage is needed yet
        mapping(address => uint256) accusations;
    }

    /// @dev function to support the diamond pattern
    function accusationStorage() internal pure returns (AccusationStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }


    /// @notice This handles the accusation for a non existing UTXO
    ///
    ///
    function AccuseNonExistingUTXOConsumption(
        bytes memory _pClaims,
        bytes memory _pClaimsSig,
        bytes memory _bClaims,
        bytes memory _bClaimsSigGroup,
        bytes memory _proofAgainstStateRoot, //we don't know yet if it's a non
        bytes memory _proofInclusionTxRoot,
        bytes memory _proofOfInclusionTxHash,
        bytes memory _txInPreImage
        // todo: change this back to callback
    ) internal {
        // Require that the previous block is signed by correct group key for validator set.
        uint256[4] memory publicKey;
        uint256[2] memory signature;
        bytes memory blockHash = abi.encodePacked(keccak256(_bClaims));
        (publicKey, signature) = SnapshotsLibrary.parseSignatureGroup(_bClaimsSigGroup); //todo optimize this
        bool ok = CryptoLibrary.Verify(blockHash, signature, publicKey);
        require(ok, "Signature verification failed");

        // Require that height delta is 1.
        BClaimsParserLibrary.BClaims memory bClaims = BClaimsParserLibrary.extractBClaims(_bClaims);
        PClaimsParserLibrary.PClaims memory pClaims = PClaimsParserLibrary.extractPClaims(_pClaims);

        require(bClaims.height+1 == pClaims.bClaims.height, "Height delta should be 1");

        // Require that chainID is equal.
        require(bClaims.chainId == pClaims.bClaims.chainId, "ChainId should be the same");

        // Require that Proposal was signed by active validator.
        // address signerAccount = recoverMadNetSigner(_pClaimsSig, _pClaims);
        // require(ParticipantsLibrary.isValidator(signerAccount), "Invalid non-existing UTXO accusation, the signer of these proposal is not a valid validator!");

        MerkleProofParserLibrary.MerkleProof memory proofAgainstStateRoot = MerkleProofParserLibrary.extractMerkleProof(_proofAgainstStateRoot);
        TXInPreImageParserLibrary.TXInPreImage memory txInPreImage = TXInPreImageParserLibrary.extractTXInPreImage(_txInPreImage, TXInPreImageParserLibrary.CAPNPROTO_HEADER_SIZE);
        require(computeUTXOID(txInPreImage.consumedTxHash, txInPreImage.consumedTxIdx) == proofAgainstStateRoot.key, "The key of Merkle Proof should be equal to the UTXOID being spent!");

        // checking if we are consuming a deposit or an UTXO
        if (txInPreImage.consumedTxIdx == 0xFFFFFFFF){
            // Double spending problem, i.e, consuming a deposit that was already consumed
            MerkleProofLibrary.verifyInclusion(proofAgainstStateRoot, bClaims.stateRoot);
            // todo: deposit that doesn't exist in the chain
            // Maybe split this in separate functions?
        } else {
            //Consuming a non existing UTXO
            MerkleProofLibrary.verifyNonInclusion(proofAgainstStateRoot, bClaims.stateRoot);
        }

        // Validate ProofInclusionTxRoot against PClaims.BClaims.TxRoot.
        MerkleProofParserLibrary.MerkleProof memory proofInclusionTxRoot = MerkleProofParserLibrary.extractMerkleProof(_proofInclusionTxRoot);
        MerkleProofLibrary.verifyInclusion(proofInclusionTxRoot, pClaims.bClaims.txRoot);

        // Validate ProofOfInclusionTxHash against the target hash from ProofInclusionTxRoot.
        MerkleProofParserLibrary.MerkleProof memory proofOfInclusionTxHash = MerkleProofParserLibrary.extractMerkleProof(_proofOfInclusionTxHash);
        MerkleProofLibrary.verifyInclusion(proofOfInclusionTxHash, proofInclusionTxRoot.key);

        require(proofAgainstStateRoot.key == proofOfInclusionTxHash.key, "The UTXO should match!");

        //todo: deposit that doesn't exist in the chain
        //todo: check if bclaim values shift depending on value txCount. Check if they are 0 if they are still present
        //todo burn the validator's tokens
    }


    /// @notice This function validates an accusation of multiple proposals.
    /// @param _signature0 The signature of pclaims0
    /// @param _pClaims0 The PClaims of the accusation
    /// @param _signature1 The signature of pclaims1
    /// @param _pClaims1 The PClaims of the accusation
    /// @return the address of the signer
    function AccuseMultipleProposal(
        bytes calldata _signature0,
        bytes calldata _pClaims0,
        bytes calldata _signature1,
        bytes calldata _pClaims1
    ) internal view returns(address) {
        // ecrecover sig0/1 and ensure both are valid and accounts are equal
        address signerAccount0 = recoverMadNetSigner(_signature0, _pClaims0);
        address signerAccount1 = recoverMadNetSigner(_signature1, _pClaims1);

        require(signerAccount0 == signerAccount1, "Invalid multiple proposal accusation, the signers of the proposals are different!");

        // ensure the hashes of blob0/1 are different
        require(keccak256(_pClaims0) != keccak256(_pClaims1), "Invalid multiple proposal accusation, the PClaims are equal!");

        PClaimsParserLibrary.PClaims memory pClaims0 = PClaimsParserLibrary.extractPClaims(_pClaims0, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);
        PClaimsParserLibrary.PClaims memory pClaims1 = PClaimsParserLibrary.extractPClaims(_pClaims1, PClaimsParserLibrary.CAPNPROTO_HEADER_SIZE);

        // ensure the height of blob0/1 are equal using RCert sub object of PClaims
        require(pClaims0.rCert.rClaims.height == pClaims1.rCert.rClaims.height, "Invalid multiple proposal accusation, the block heights between the proposals are different!");

        // ensure the round of blob0/1 are equal using RCert sub object of PClaims
        require(pClaims0.rCert.rClaims.round == pClaims1.rCert.rClaims.round, "Invalid multiple proposal accusation, the round between the proposals are different!");

        // ensure the chainid of blob0/1 are equal using RCert sub object of PClaims
        require(pClaims0.rCert.rClaims.chainId == pClaims1.rCert.rClaims.chainId, "Invalid multiple proposal accusation, the chainId between the proposals are different!");

        // ensure the chainid of blob0 is correct for this chain using RCert sub object of PClaims
        uint32 chainId = ParticipantsLibrary.participantsStorage().chainId;
        require(pClaims0.rCert.rClaims.chainId == chainId, "Invalid multiple proposal accusation, the chainId is invalid for this chain!");

        // ensure both accounts are applicable to a currently locked validator - Note<may be done in different layer?>
        require(ParticipantsLibrary.isValidator(signerAccount0), "Invalid multiple proposal accusation, the signer of these proposals is not a valid validator!");

        return signerAccount0;
    }

    /// @notice Recovers the signer of a message
    /// @param signature The ECDSA signature
    /// @param prefix The prefix of the message
    /// @param message The message
    /// @return the address of the signer
    function recoverSigner(bytes memory signature, bytes memory prefix, bytes memory message) internal pure returns (address) {

        require(signature.length==65, "Signature should be 65 bytes");

        bytes32 hashedMessage = keccak256(abi.encodePacked(prefix, message));

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

        return ecrecover(hashedMessage, v, r, s);
    }


    /// @notice Recovers the signer of a message in MadNet
    /// @param signature The ECDSA signature
    /// @param message The message
    /// @return the address of the signer
    function recoverMadNetSigner(bytes memory signature, bytes memory message) internal pure returns (address) {
        return recoverSigner(signature, "Proposal" , message);
    }

    function computeUTXOID(bytes32 txHash, uint32 txIdx) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(txHash, txIdx));
    }

}