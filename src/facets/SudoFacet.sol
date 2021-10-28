// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./AccessControlLibrary.sol";

contract SudoFacet is AccessControlled {
    function modifyDiamondStorage(address callback_) external onlyGovernance returns (bool) {
        (bool success, ) = callback_.delegatecall(abi.encodeWithSignature("callback()"));
        require(success, "SudoFacet: CALL FAILED!");
        return success;
    }
}