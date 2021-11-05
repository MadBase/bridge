// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.6.4;

import "./facets/AccessControlLibrary.sol";
import "./facets/DiamondUpdateFacet.sol";
import "./facets/DiamondStorageLibrary.sol";

contract Diamond {

    constructor() payable {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();
        ac.owner = msg.sender;
        ac.operators[msg.sender] = true;

        DiamondStorageLibrary.DiamondStorage storage vs = DiamondStorageLibrary.diamondStorage();

        // Wire in the updatability functions
        DiamondUpdateFacet update = new DiamondUpdateFacet();

        vs.routing[update.addFacet.selector] = address(update);
        vs.routing[update.removeFacet.selector] = address(update);
        vs.routing[update.replaceFacet.selector] = address(update);
    }

    fallback() external payable {
        // Load storage
        DiamondStorageLibrary.DiamondStorage storage vs = DiamondStorageLibrary.diamondStorage();

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