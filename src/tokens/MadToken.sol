// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


/// @custom:salt MadToken
/// @custom:deploy-type deployStatic
contract MadToken is ERC20 {

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        _mint(msg.sender, 220000000 * 10 ** decimals());
    }
}
