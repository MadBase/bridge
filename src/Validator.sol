pragma solidity >=0.5.15;

import "./ERC165.sol";

interface Validator {
    function getOwner() external view returns (address);              // 893d20e8
    function getMadNetID() external view returns (uint256[2] memory); // 369205b4
    function getSignature() external view returns (bytes memory);     // 8a4e3769
}

contract ValidatorStandin is ERC165, Validator {

    bytes4 constant ValidatorIterfaceId = 0x35e11235;

    address private owner;
    uint256[2] private madNetID;
    bytes private signature = bytes("");

    constructor(uint256[2] memory _madNetID, bytes memory _signature) public {
        owner = msg.sender;
        madNetID = _madNetID;
        signature = _signature;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function getMadNetID() external view returns (uint256[2] memory) {
        return madNetID;
    }

    function getSignature() external view returns (bytes memory) {
        return signature;
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == ValidatorIterfaceId || interfaceID == 0x01ffc9a7;
    }
}