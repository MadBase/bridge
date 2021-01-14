// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.4;

import "./facets/SnapshotsFacet.sol";
import "./facets/ValidatorsUpdateFacet.sol";
import "./facets/ValidatorsStorageLibrary.sol";

contract ValidatorsDiamond {

    constructor() public payable {
        SnapshotsFacet s = new SnapshotsFacet();

        ValidatorsStorageLibrary.ValidatorsStorage storage vs = ValidatorsStorageLibrary.validatorsStorage();
        vs.routing[s.nextSnapshot.selector] = address(s);
        vs.routing[s.setNextSnapshot.selector] = address(s);
        vs.routing[s.extractUint256.selector] = address(s);
        vs.routing[s.extractUint32.selector] = address(s);
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