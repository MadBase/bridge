pragma solidity ^0.8.11;

contract Proxy {
    address immutable private factory_;
    
    constructor(address _impl, bytes memory) {
        factory_ = msg.sender;
        assembly {
            sstore(not(caller()), _impl)
        }
    }

    fallback() payable external {
        address factory = factory_;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, returndatasize(), calldatasize())
            let slot := not(factory)
            if eq(caller(), factory) {
                let newImp := mload(ptr)
                sstore(slot, newImp)
                return(ptr, calldatasize())
            }
            let zero := returndatasize()
            let ret := delegatecall(gas(), sload(slot), ptr, calldatasize(), returndatasize(), returndatasize())
            returndatacopy(ptr, zero, returndatasize())
            if iszero(ret) {
                revert(ptr, returndatasize())
            }
            return(ptr, returndatasize())
        }
    }
}
