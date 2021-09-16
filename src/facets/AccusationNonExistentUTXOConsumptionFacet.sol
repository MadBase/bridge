// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "./AccusationLibrary.sol";

contract AccusationNonExistentUTXOConsumptionFacet {

    ///
    ///
    ///
    function AccuseNonExistingUTXOConsumption(
        bytes memory _pClaims,
        bytes memory _pClaimsSig,
        bytes memory _bClaims,
        bytes memory _bClaimsGroupSig,
        bytes memory _txInPreImage,
        bytes[3] memory _proofs
    ) external {
        AccusationLibrary.AccuseNonExistingUTXOConsumption(
            _pClaims,
            _pClaimsSig,
            _bClaims,
            _bClaimsGroupSig,
            _txInPreImage,
            _proofs
        );
    }
}