// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./AccessControlLibrary.sol";

contract SudoFacet is AccessControlled {
    function modifyDiamondStorage(address _callback) external onlyGovernance returns (bool) {
        (bool success, ) = _callback.delegatecall(abi.encodeWithSignature("callback()"));
        require(success, "SudoFacet: CALL FAILED!");
        return success;
    }
}