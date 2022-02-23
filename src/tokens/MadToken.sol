// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "./utils/Admin.sol";

abstract contract MadTokenBase is ERC20Upgradeable, Admin {

}

/// @custom:salt MadToken
/// @custom:deploy-type deployStatic
contract MadToken is MadTokenBase {
    constructor() Admin(msg.sender){
    }
    function initialize(address owner_) public onlyAdmin initializer {
        __ERC20_init("MadToken", "MT");
        _mint(owner_, 220000000 * 10 ** decimals());
    }
}
