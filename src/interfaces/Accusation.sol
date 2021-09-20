// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "./AccusationEvents.sol";
import "../Registry.sol";

interface Accusation is AccusationEvents {

    /// @notice This function validates an accusation of multiple proposals.
    /// @param _signature0 The signature of pclaims0
    /// @param _pClaims0 The PClaims of the accusation
    /// @param _signature1 The signature of pclaims1
    /// @param _pClaims1 The PClaims of the accusation
    function AccuseMultipleProposal(
        bytes calldata _signature0,
        bytes calldata _pClaims0,
        bytes calldata _signature1,
        bytes calldata _pClaims1
    ) external;

    /// @notice This function validates an accusation of non-existent utxo consumption, as well as invalid deposit consumption.
    /// @param _pClaims the PClaims of the accusation
    /// @param _pClaimsSig the signature of PClaims
    /// @param _bClaims the BClaims of the accusation
    /// @param _bClaimsSigGroup the signature group of PClaims
    /// @param _txInPreImage the TXInPreImage consuming the invalid transaction
    /// @param _proofs an array of merkle proof structs in the following order:
    /// proof against StateRoot: Proof of inclusion or exclusion of the deposit or UTXO in the stateTrie
    /// proof of inclusion in TXRoot: Proof of inclusion of the transaction that included the invalid input in the txRoot trie.
    /// proof of inclusion in TXHash: Proof of inclusion of the invalid input (txIn) in the txHash trie (transaction tested against the TxRoot).
    function AccuseInvalidTransactionConsumption(
        bytes calldata _pClaims,
        bytes calldata _pClaimsSig,
        bytes calldata _bClaims,
        bytes calldata _bClaimsSigGroup,
        bytes calldata _txInPreImage,
        bytes[3] calldata _proofs
    ) external;
}