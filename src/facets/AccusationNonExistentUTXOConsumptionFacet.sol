// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./AccusationLibrary.sol";

contract AccusationNonExistentUTXOConsumptionFacet {

    ///
    ///
    ///
    function AccuseNonExistingUTXOConsumption(
        bytes calldata _pClaims,
        bytes calldata _pClaimsSig,
        bytes calldata _bClaims,
        bytes calldata _bClaimsGroupSig,
        bytes calldata ProofNonInclusionUTXOStateRoot,
        bytes calldata ProofInclusionTxRoot,
        bytes calldata ProofOfInclusionTxHash
    ) external {
        AccusationLibrary.AccuseNonExistingUTXOConsumption(_pClaims, _pClaimsSig, _bClaims, _bClaimsGroupSig, ProofNonInclusionUTXOStateRoot, ProofInclusionTxRoot, ProofOfInclusionTxHash);
    }
}