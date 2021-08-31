// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./AccusationLibrary.sol";

contract AccusationMultipleProposalFacet {

    // 
    function AccuseMultipleProposal(
        bytes calldata _signatureGroup0,
        bytes calldata _rClaims0,
        bytes calldata _signatureGroup1,
        bytes calldata _rClaims1
    ) external {
        AccusationLibrary.AccusationStorage storage s = AccusationLibrary.accusationStorage();

        s.accusations[msg.sender]++;
    }
}
