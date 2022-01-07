pragma solidity ^0.8.11;

contract endPoint {
    uint i; 
    constructor(){
        i = 0;
    }
    function addOne() public {
        i++;
    }
    fallback() payable external {
        i = i + 2;
    }

}