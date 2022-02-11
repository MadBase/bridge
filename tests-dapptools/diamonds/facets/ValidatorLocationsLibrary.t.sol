// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "lib/ds-test/test.sol";
import "../Setup.t.sol";
import "src/diamonds/facets/ValidatorLocationsLibrary.sol";


contract StakingTokenMock is Token {

    constructor(bytes32 symbol, bytes32 name) Token(symbol, name) {}

    function approveFor(address owner, address who, uint wad) external returns (bool) {
        allowance[owner][who] = wad;

        emit Approval(owner, who, wad);

        return true;
    }

}

contract User {
    ValidatorLocations _vl;

    constructor(ValidatorLocations vl_) {
        _vl = vl_;
    }

    function setMyLocation(string calldata ip) external {
        _vl.setMyLocation(ip);
    }
    function getMyLocation() external view returns(string memory) {
        return _vl.getMyLocation();
    }
    function getLocation(address a) external view returns(string memory) {
        return _vl.getLocation(a);
    }
    function getLocations(address[] calldata a) external view returns(string[] memory) {
        return _vl.getLocations(a);
    }
}

contract ValidatorLocationsTest is DSTest, Setup {
    function setUp() public override {
        setUp(address(new StakingTokenMock("STK", "MadNet Staking")));
    }

    function makeUserValidator(User u) internal {
        StakingTokenMock mock = StakingTokenMock(registry.lookup(STAKING_TOKEN));
        address signer = address(u);
        uint256[2] memory madID = generateMadID(987654321);
        stakingToken.transfer(signer, MINIMUM_STAKE);
        uint256 b = stakingToken.balanceOf(signer);
        assertEq(b, MINIMUM_STAKE);
        mock.approveFor(signer, address(staking), MINIMUM_STAKE);
        staking.lockStakeFor(signer, MINIMUM_STAKE);
        participants.addValidator(signer, madID);
        assertTrue(participants.isValidator(signer), "Not a validator");
        participants.setChainId(1);
    }

    function generateMadID(uint256 id) internal pure returns (uint256[2] memory madID) {
        madID[0] = id;
        madID[1] = id;
    }

    function testFailNotAValidator() public {
        User u2 = new User(validatorLocations);

        u2.setMyLocation("192.168.0.1:1337");
    }

    function testGetMyLocation() public {
        User u = new User(validatorLocations);
        makeUserValidator(u);

        u.setMyLocation("192.168.0.1:1337");
        assertEq(u.getMyLocation(), "192.168.0.1:1337");
    }

    function testGetLocation() public {
        User u = new User(validatorLocations);
        makeUserValidator(u);

        User u2 = new User(validatorLocations);
        makeUserValidator(u2);

        u.setMyLocation("192.168.0.1:1337");
        u2.setMyLocation("192.168.0.2:1337");
        assertEq(u.getLocation(address(u2)), "192.168.0.2:1337");
        assertEq(u.getLocation(address(u)), "192.168.0.1:1337");
    }

    function testGetLocations() public {
        User u = new User(validatorLocations);
        makeUserValidator(u);

        User u2 = new User(validatorLocations);
        makeUserValidator(u2);

        User u3 = new User(validatorLocations);
        makeUserValidator(u3);

        u.setMyLocation("192.168.0.1:1337");
        u2.setMyLocation("192.168.0.2:1337");
        u3.setMyLocation("192.168.0.3:1337");

        address[] memory input = new address[](2);
        input[0] = address(u3);
        input[1] = address(u);

        string[] memory output = u.getLocations(input);
        assertEq(output.length, 2);
        assertEq(output[0], "192.168.0.3:1337");
        assertEq(output[1], "192.168.0.1:1337");
    }


}
