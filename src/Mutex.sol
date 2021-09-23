// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.7.6;


abstract contract Mutex {
    
    uint8 constant locked = 1;
    uint8 constant unlocked = 2;
    uint8 _mutex;
    
    constructor() {
        _mutex = unlocked;
    }
    
    function _lock() internal {
        require(_mutex == unlocked);
        _mutex = locked;
    }
    
    function _unlock() internal {
        require(_mutex == locked);
        _mutex = unlocked;
    }
    
    modifier withLock() {
        _lock();
        _;
        _unlock();
    }
}