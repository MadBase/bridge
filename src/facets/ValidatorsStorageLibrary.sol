// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

library ValidatorsStorageLibrary {

    bytes32 constant STORAGE_LOCATION = keccak256("validators.storage");

    struct ValidatorsStorage {
        mapping(bytes4 => address) routing; // function selector to contract address with function
    }

    function validatorsStorage() internal pure returns (ValidatorsStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

}