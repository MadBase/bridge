// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "../GovernanceProposal.sol";
import "../../diamonds/facets/EthDKGLibrary.sol";

contract GovernanceProposeRestartETHDKG is GovernanceProposal {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!

    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. See the
    /// GovernanceProposal.sol file fore more details.
    function execute(address self) public override returns(bool) {
        // Replace the following line with the address of the ETHDKG Diamond.
        address target = address(0x0);
        (bool success, ) = target.call(abi.encodeWithSignature("modifyDiamondStorage(address)", self));
        require(success, "GovernanceProposeModifySnapshot: CALL FAILED!");
        return success;
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! See the GovernanceProposal.sol file fore more details. PLACE THE
    /// LOGIC TO RESTART THE ETHDKG IN HERE!
    function callback() public override returns(bool) {
        EthDKGLibrary.initializeState();
        return true;
    }
}