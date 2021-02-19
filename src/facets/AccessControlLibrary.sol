// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

library AccessControlLibrary {

    bytes32 constant STORAGE_LOCATION = keccak256("access.storage");

    struct AccessStorage {
        mapping(address => bool) operators;
        address owner;
        address pendingOwner;
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
    }

    function grantOwner(address who) external onlyOwner {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        ac.pendingOwner = who;
    }

    function takeOwnership() external {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        require(msg.sender == ac.pendingOwner, "ownership not granted");

        ac.owner = msg.sender;
    }

    function grantOperator(address who) external ownerOrOperator {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        ac.operators[who] = true;
    }

    function revokeOperator(address who) external ownerOrOperator {
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

    modifier ownerOrOperator {
        AccessControlLibrary.AccessStorage storage ac = AccessControlLibrary.accessStorage();

        require(ac.owner == msg.sender || ac.operators[msg.sender], "only owner or operator allowed");
        _;
    }
}