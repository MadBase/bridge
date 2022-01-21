object "constructor" {
    code {
        //call the factory call back to get the tempAddr
        let ret := staticcall(gas(), caller(), calldatasize(), calldatasize(), calldatasize(), 0x20)
        //delegatecall the temp contract to hit the init code
        ret := delegatecall(gas(), mload(calldatasize()), calldatasize(), calldatasize(), calldatasize(), calldatasize())
        returndatacopy(calldatasize(), calldatasize(), returndatasize())
        return(calldatasize(), returndatasize())
    }
    object "runtime" {
        code {}
    }
}
// 6020363636335afa1536363636515af43d36363e3d36f3