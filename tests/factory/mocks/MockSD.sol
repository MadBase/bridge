pragma solidity ^0.8.11;

import "../../../src/proxy/ProxyInternalUpgradeLock.sol";
import "../../../src/proxy/ProxyInternalUpgradeUnlock.sol";

contract MockSD is ProxyInternalUpgradeLock, ProxyInternalUpgradeUnlock {
    address factory_;
    uint256 public v;
    uint256 public immutable i;

    constructor(uint256 _i, bytes memory ) {
        i = _i;
        factory_ = msg.sender;
    }

    function setv(uint256 _v) public {
        v = _v;
    }

    function lock() public {
        __lockImplementation();
    }

    function unlock() public {
        __unlockImplementation();
    }

    function setFactory(address _factory) public {
        factory_ = _factory;
    }
    function getFactory() external view returns (address) {
        return factory_;
    }
}