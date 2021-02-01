// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "./SimpleAuth.sol";

interface RegistryClient {
    function reloadRegistry() external;
}

contract Registry is SimpleAuth {

    mapping(string => address) private registry;

    function lookup(string memory name) public view returns (address) {
        return registry[name];
    }

    function register(string memory name, address dst) public onlyOperator {
            registry[name] = dst;
    }

    function remove(string memory name) public onlyOperator {
        delete registry[name];
    }

}