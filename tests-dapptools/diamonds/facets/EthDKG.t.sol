// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

import "lib/ds-test/test.sol";
import "../Setup.t.sol";


contract EthDKG is Constants, DSTest, Setup {

    address me = address(this);

    function testGetDefaultPhaseLength() public {
        ethdkg.initializeEthDKG(registry);
        assertEq(ethdkg.getPhaseLength(), 40);
    }

    function testSetPhaseLength() public {
        ethdkg.initializeEthDKG(registry);

        ethdkg.updatePhaseLength(4);
        assertEq(ethdkg.getPhaseLength(), 4);
    }

}