// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.4;

library AccessControlLibrary {

    bytes32 constant STORAGE_LOCATION = keccak256("access.storage");

    struct AccessStorage {
        mapping(address => bool) operators;
        address owner;
    }

    function accessStorage() internal pure returns (AccessStorage storage ac) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            ac.slot := position
        }
    }

}

contract AccessControlled {

    constructor() {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        ac.owner = msg.sender;
        ac.operators[msg.sender] = true;
    }

    function grantOperator(address who) external onlyOperator {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        ac.operators[who] = true;
    }

    function revokeOperator(address who) external onlyOperator {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        delete ac.operators[who];
    }

    modifier onlyOwner {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        require(ac.owner == msg.sender, "only owner is allowed");
        _;
    }

    modifier onlyOperator {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        require(ac.operators[msg.sender], "only operators allowed");
        _;
    }
}