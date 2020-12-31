pragma solidity >=0.5.15;

import "./SimpleAuth.sol";

contract Persistence is SimpleAuth {

    mapping(bytes32 => uint) uints;
    mapping(bytes32 => uint32) uint32s;
    mapping(bytes32 => uint256) uint256s;
    mapping(bytes32 => uint8) uint8s;
    mapping(bytes32 => bytes32) bytes32s;
    mapping(bytes32 => bytes4) bytes4s;
    mapping(bytes32 => bytes32[]) bytesMany;
    mapping(bytes32 => bytes[]) data;

    // setter/getter for uint
    function setUint(bytes32 _item, uint _val) public onlyOperator {
        uints[_item] = _val;
    }

    function getUint(bytes32 _item) public view returns (uint) {
        return uints[_item];
    }

    function removeUint(bytes32 _item) public onlyOperator {
        delete uints[_item];
    }

    // setter/getter for uint32
    function setUint32(bytes32 _item, uint32 _val) public onlyOperator {
        uint32s[_item] = _val;
    }

    function getUint32(bytes32 _item) public view returns (uint32) {
        return uint32s[_item];
    }

    function removeUint32(bytes32 _item) public onlyOperator {
        delete uint32s[_item];
    }

    // setter/getter for uint256
    function setUint256(bytes32 _item, uint256 _val) public onlyOperator {
        uint256s[_item] = _val;
    }

    function getUint256(bytes32 _item) public view returns (uint256) {
        return uint256s[_item];
    }

    function removeUint256s(bytes32 _item) public onlyOperator {
        delete uint256s[_item];
    }

    // setter/getter for bytes32
    function setBytes32(bytes32 _item, bytes32 _val) public onlyOperator {
        bytes32s[_item] = _val;
    }

    function getBytes32(bytes32 _item) public view returns (bytes32) {
        return bytes32s[_item];
    }

    function removeBytes32s(bytes32 _item) public onlyOperator {
        delete bytes32s[_item];
    }

    // setter/getter for bytes32[]
    function setBytes32Array(bytes32 _item, bytes32[] memory _val) public onlyOperator {
        bytesMany[_item] = _val;
    }

    function getBytes32Array(bytes32 _item) public view returns (bytes32[] memory) {
        return bytesMany[_item];
    }
}