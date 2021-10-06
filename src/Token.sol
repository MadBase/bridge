// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./lib/ds-token/token.sol";

import "./SimpleAuth.sol";

contract TokenAuthority is DSAuthority, SimpleAuth {

   function canCall(address, address, bytes4) public override onlyOperator view returns (bool) {
        return true;
    }
}

contract Token is DSToken, SimpleAuth {

    uint constant initialSupply = 1_000_000_000_000_000_000_000_000_000_000;
    TokenAuthority authority_ = new TokenAuthority();

    constructor(bytes32 symbol_, bytes32 name_) DSToken(symbol_) {
        setAuthority(authority_);
        name = name_;

        authority_.grantOperator(msg.sender);

        decimals = 18;

        mint(msg.sender, initialSupply);
    }

    function grantOperator(address _operator) public override onlyOperator {
        authority_.grantOperator(_operator);
        super.grantOperator(_operator);
    }

    function revokeOperator(address _operator) public override onlyOperator {
        authority_.revokeOperator(_operator);
        super.revokeOperator(_operator);
    }

}