// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.4;

import "./facets/SnapshotsFacet.sol";
import "./facets/ValidatorsUpdateFacet.sol";
import "./facets/ValidatorsStorageLibrary.sol";

contract ValidatorsDiamond {

    constructor() public payable {
        ValidatorsStorageLibrary.ValidatorsStorage storage vs = ValidatorsStorageLibrary.validatorsStorage();
        
        // Wire in the updatability functions
        ValidatorsUpdateFacet update = new ValidatorsUpdateFacet();

        vs.routing[update.addFacet.selector] = address(update);
        vs.routing[update.removeFacet.selector] = address(update);
        vs.routing[update.replaceFacet.selector] = address(update);
    }

    fallback() external payable {
        // Load storage
        ValidatorsStorageLibrary.ValidatorsStorage storage vs = ValidatorsStorageLibrary.validatorsStorage();

        // Lookup facet
        address facet = vs.routing[msg.sig];
        require(facet != address(0), "no facet for selector");

        // Delegatecall to facet
        assembly {
            calldatacopy(0, 0, calldatasize())
            
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }

    receive() external payable {}
   
}