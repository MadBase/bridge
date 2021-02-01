// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "ds-test/test.sol";

contract ConStorage {
    uint256 public number;
    address special;

    constructor() {
        number = 5;
    }
}

contract ConBase is ConStorage {

    constructor(address special_) {
        special = special_;
    }

    function increment() public {
        (bool ok, ) = special.delegatecall(abi.encodeWithSignature("increment()"));
        require(ok, "delegated call failed for increment()");
    }
}

contract ConSpecial is ConStorage {
    function increment() public {
        number++;
    }
}

contract ConbaseTest is DSTest {

    ConBase base;

    function setUp() public {
        base = new ConBase(address(new ConSpecial()));
    }

    function testWeird() public {
        assertEq(base.number(), 5);
        base.increment();
        assertEq(base.number(), 6);
    }
}