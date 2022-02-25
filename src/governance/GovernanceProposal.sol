// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceStorage.sol";

abstract contract GovernanceProposal is GovernanceStorage {

    // PROPOSALS MUST NOT HAVE ANY STATE VARIABLE TO AVOID POTENTIAL STORAGE
    // COLLISION!


    /// @dev function that is called when a proposal is executed. It's only
    /// meant to be called by the Governance Manager contract. This function has
    /// access to the Governance Manager Storage and context. In other words, we
    /// can arbitrarily change the Governance Manager state inside this
    /// function.
    /// @param self: The address of the deployed proposal.
    /// Used to redirect the callee contract back to {callback} method. This
    /// address is required since address(this) will yield the GovernanceManager
    /// address instead of the address of deployed proposal contract.
    function execute(address self) public virtual returns(bool) {
        self; //no-op to silence compiling warnings
        return callback();
    }

    /// @dev function that is called back by another contract with DELEGATE CALL
    /// rights! This function doesn't have access to Governance Manager Storage,
    /// only the storage/context of the contract that called this function. This
    /// function will not execute with the Governance powers. Therefore, if
    /// there's a need to call functions that rely on governance powers from
    /// inside this function, set `allowedProposal` state variable in the {execute}
    /// method before calling the contract that calls this function.
    /// For more details about the `allowedProposal` usage see
    /// testExecuteGovernanceAllowedProposal in the GovernanceManager.t.sol
    /// file.
    function callback() public virtual returns(bool) {
        return true;
    }
}