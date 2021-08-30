// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./AccusationLibrary.sol";

contract AccusationMultipleProposalFacet {

    //
    function AccuseMultipleProposal(
        bytes calldata _pClaims0,
        bytes calldata _pClaims1
    ) external {
        AccusationLibrary.AccusationStorage storage s = AccusationLibrary.accusationStorage();
        AccusationLibrary.AccuseMultipleProposal(_pClaims0, _pClaims1);
        s.accusations[msg.sender]++;
    }
}
