// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "lib/ds-test/test.sol";

import "src/Registry.sol";

contract RegistryTest is DSTest {

    Registry private reg;

    function setUp() public {
        reg = new Registry();
    }

    function testRegister() public {
        reg.register("one", address(1));
        reg.register("two", address(2));

        assertEq(address(1), reg.lookup("one"));
        assertEq(address(2), reg.lookup("two"));
    }

    function testRemove() public {
        reg.register("one", address(1));
        reg.register("two", address(2));

        reg.remove("two");

        assertEq(address(1), reg.lookup("one"));
        assertEq(address(0), reg.lookup("two"));
        assertEq(address(0), reg.lookup("three"));
    }

}