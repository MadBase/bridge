// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "./AccusationLibrary.sol";
import "../interfaces/AccusationEvents.sol";
import "../SafeMath.sol";

contract AccusationInvalidTransactionConsumptionFacet is AccusationEvents {

    using SafeMath for uint256;

    ///
    ///
    ///
    function AccuseInvalidTransactionConsumption(
        bytes memory _pClaims,
        bytes memory _pClaimsSig,
        bytes memory _bClaims,
        bytes memory _bClaimsGroupSig,
        bytes memory _txInPreImage,
        bytes[3] memory _proofs
    ) external {
        AccusationLibrary.AccusationStorage storage s = AccusationLibrary.accusationStorage();
        address signer = AccusationLibrary.AccuseInvalidTransactionConsumption(
            _pClaims,
            _pClaimsSig,
            _bClaims,
            _bClaimsGroupSig,
            _txInPreImage,
            _proofs
        );
        s.accusations[signer] = s.accusations[signer].add(1);
        emit InvalidTransactionConsumption(signer);
    }
}