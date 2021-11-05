// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

library DiamondStorageLibrary {

    bytes32 constant STORAGE_LOCATION = keccak256("diamond.storage");

    struct DiamondStorage {
        mapping(bytes4 => address) routing; // function selector to contract address with function
    }

    function diamondStorage() internal pure returns (DiamondStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

}