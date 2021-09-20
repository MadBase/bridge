// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "./AccusationEvents.sol";
import "../Registry.sol";

interface Accusation is AccusationEvents {

    function AccuseMultipleProposal(
        bytes calldata _signature0,
        bytes calldata _pClaims0,
        bytes calldata _signature1,
        bytes calldata _pClaims1
    ) external;

    function AccuseInvalidTransactionConsumption(
        bytes calldata _pClaims,
        bytes calldata _pClaimsSig,
        bytes calldata _bClaims,
        bytes calldata _bClaimsSigGroup,
        bytes calldata _txInPreImage,
        bytes[3] calldata _proofs
    ) external;
}