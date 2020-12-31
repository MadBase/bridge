pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./Persistence.sol";

contract PersistanceTest is DSTest {

    Persistence persistance;

    function setUp() public {
        persistance = new Persistence();
        persistance.setUint32("a", 2);
    }

    function testPersistingUint32s() public {
        assertTrue(2 == persistance.getUint32("a"));
    }

    function testPersistingBytes32s() public {
        persistance.setBytes32("b", "foo");
        assertTrue(bytes32("foo") == persistance.getBytes32("b"));
    }

    function testPersistingBytesMany() public {

        // bytes32[2] memory foo;

        // foo[0] = "abc";
        // foo[1] = "defg";

        // persistance.setBytes32Array("b", "aaa0", bar);

        // bytes32[] memory bar = persistance.getBytes32Array("b", "aaa0");
        // assertTrue(bar[0] == bytes32("abc"));
        // assertTrue(bar[1] == bytes32("defg"));
    }
}
