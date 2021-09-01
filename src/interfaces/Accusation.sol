// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;
pragma abicoder v2;

import "./AccusationEvents.sol";
import "../Registry.sol";

interface Accusation is AccusationEvents {

    function initializeAccusation(Registry registry) external;

    function AccuseMultipleProposal(
        bytes calldata _signatureGroup0,
        bytes calldata _rClaims0,
        bytes calldata _signatureGroup1,
        bytes calldata _rClaims1
    ) external;

}