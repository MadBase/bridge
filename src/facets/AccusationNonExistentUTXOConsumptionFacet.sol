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
        bytes calldata _proofAgainstStateRoot,
        bytes calldata _proofInclusionTxRoot,
        bytes calldata _proofOfInclusionTxHash,
        bytes calldata _txInPreImage
    ) external {
        AccusationLibrary.AccuseNonExistingUTXOConsumption(_pClaims, _pClaimsSig, _bClaims, _bClaimsGroupSig, _proofAgainstStateRoot, _proofInclusionTxRoot, _proofOfInclusionTxHash, _txInPreImage);
    }
}