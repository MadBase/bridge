// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "./AccusationLibrary.sol";
import "../interfaces/AccusationEvents.sol";
import "../SafeMath.sol";

contract AccusationInvalidTransactionConsumptionFacet is AccusationEvents {

    using SafeMath for uint256;

    /// @notice This function validates an accusation of non-existent utxo consumption, as well as invalid deposit consumption.
    /// @param _pClaims the PClaims of the accusation
    /// @param _pClaimsSig the signature of Pclaims
    /// @param _bClaims the BClaims of the accusation
    /// @param _bClaimsSigGroup the signature group of Pclaims
    /// @param _txInPreImage the TXInPreImage for this accusation
    /// @param _proofs an array of merkle proof structs in the following order: proof against StateRoot, proof of inclusion in TXRoot, proof of inclusion in TXHash
    /// @dev Execution cost: 36608 gas
    function AccuseInvalidTransactionConsumption(
        bytes memory _pClaims,
        bytes memory _pClaimsSig,
        bytes memory _bClaims,
        bytes memory _bClaimsSigGroup,
        bytes memory _txInPreImage,
        bytes[3] memory _proofs
    ) external {
        AccusationLibrary.AccusationStorage storage s = AccusationLibrary.accusationStorage();
        address signer = AccusationLibrary.AccuseInvalidTransactionConsumption(
            _pClaims,
            _pClaimsSig,
            _bClaims,
            _bClaimsSigGroup,
            _txInPreImage,
            _proofs
        );
        s.accusations[signer] = s.accusations[signer].add(1);
        emit InvalidTransactionConsumption(signer);
    }
}