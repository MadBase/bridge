// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-test/test.sol";

import "./AccusationLibrary.sol";
import "./AccusationMultipleProposalFacet.sol";

contract TestAccusationLibrary is DSTest {

    function testAccuseMultipleProposal() public {
        AccusationMultipleProposalFacet f = new AccusationMultipleProposalFacet();

        bytes memory sig0;
        bytes memory rclaims0;

        bytes memory sig1;
        bytes memory rclaims1;

        f.AccuseMultipleProposal(sig0, rclaims0, sig1, rclaims1);

        assertTrue(true);
    }

}