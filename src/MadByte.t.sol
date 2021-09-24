// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "ds-test/test.sol";

import "./MadByte.sol";
import "./Sigmoid.sol";


abstract contract BaseMock {
    MadByte public token;

    function setToken(MadByte _token) public {
        token = _token;
    }
}

contract AdminAccount is BaseMock {
    constructor() {}

    function setMinerStaking(address addr) public {
        token.setMinerStaking(addr);
    }

    function setMadStaking(address addr) public {
        token.setMadStaking(addr);
    }

    function setFoundation(address addr) public {
        token.setFoundation(addr);
    }
    
    function setMinerSplit(uint256 split) public {
        token.setMinerSplit(split);
    }
}

contract MadStakingAccount is BaseMock {
    constructor() {}
}

contract MinerStakingAccount is BaseMock {
    constructor() {}
}

contract FoundationAccount is BaseMock {
    constructor() {}
}

contract UserAccount is BaseMock {
    constructor() {}

    function transfer(address to, uint256 amount) public returns(bool) {
        return token.transfer(to, amount);
    }
}

contract MadByteTest is DSTest, Sigmoid {

    // helper functions

    function getFixtureData()
    internal
    returns(
        MadByte token,
        AdminAccount admin,
        MadStakingAccount madStaking,
        MinerStakingAccount minerStaking,
        FoundationAccount foundation
    )
    {
        admin = new AdminAccount();
        madStaking = new MadStakingAccount();
        minerStaking = new MinerStakingAccount();
        foundation = new FoundationAccount();
        token = new MadByte(
            address(admin),
            address(madStaking),
            address(minerStaking),
            address(foundation)
        );

        admin.setToken(token);
        madStaking.setToken(token);
        minerStaking.setToken(token);
        foundation.setToken(token);
    }

    function newUserAccount(MadByte token) private returns(UserAccount acct) {
        acct = new UserAccount();
        acct.setToken(token);
    }

    // test functions

    function testFail_AdminSetters() public {
        (MadByte token,,,,) = getFixtureData();

        token.setMinerStaking(address(0x0));
        token.setMadStaking(address(0x0));
        token.setFoundation(address(0x0));
    }

    function testAdminSetters() public {
        (,AdminAccount admin,,,) = getFixtureData();

        // todo: validate if 0x0 address should be allowed
        admin.setMinerStaking(address(0x0));
        admin.setMadStaking(address(0x0));
        admin.setFoundation(address(0x0));
        admin.setMinerSplit(100); // 100 = 10%, 1000 = 100%
    }

    function testMint() public {
        (MadByte token,,,,) = getFixtureData();

        uint256 madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25666259041293710500);
        
        madBytes = token.mint{value: 3 ether}(0);
        assertEq(madBytes, 25682084669534371500);
        
        /*for (uint256 i=1 ether; i<100000 ether; i += 1 ether) {
            emit log_named_uint("i", _fx(i));
        }*/

        //fail();
    }

    function testTransfer() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        uint256 initialBalance1 = token.balanceOf(address(acct1));
        uint256 initialBalance2 = token.balanceOf(address(acct2));

        acct1.transfer(address(acct2), 1);
        
        uint256 finalBalance1 = token.balanceOf(address(acct1));
        uint256 finalBalance2 = token.balanceOf(address(acct2));

        assertEq(finalBalance1, initialBalance1-1);
        assertEq(finalBalance2, initialBalance2+1);
    }

    /*function testTransferFrom() public {
        (MadByte token,,,,) = getFixtureData();
        UserAccount acct1 = newUserAccount(token);
        UserAccount acct2 = newUserAccount(token);

        uint256 initialBalance1 = token.balanceOf(address(acct1));
        uint256 initialBalance2 = token.balanceOf(address(acct2));

        token.transferFrom(address(acct1), address(acct2), 1);
        
        uint256 finalBalance1 = token.balanceOf(address(acct1));
        uint256 finalBalance2 = token.balanceOf(address(acct2));

        assertEq(finalBalance1, initialBalance1-1);
        assertEq(finalBalance2, initialBalance2+1);
    }*/

}