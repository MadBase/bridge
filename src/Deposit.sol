// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.5.15;

import "ds-stop/stop.sol";

import "./Constants.sol";
import "./Registry.sol";
import "./SafeMath.sol";
import "./Token.sol";

interface DepositEvents {
    event DepositReceived(uint256 depositID, address depositor, uint256 amount);
}

contract Deposit is Constants, DepositEvents, DSStop, RegistryClient, SimpleAuth {

    using SafeMath for uint256;

    Registry public registry;
    BasicERC20 public token;

    struct DepositDetails {
        uint256 amount;
    }

    uint256 public totalDeposited;
    uint256 public depositID = 1;                       // Monatomically increasing
    mapping(uint256 => DepositDetails) public deposits; // Key is depositID

    constructor(Registry registry_) public {
        registry = registry_;
    }

    function reloadRegistry() external override onlyOperator {
        // Lookup Token -- this is the utility token NOT the staking token
        token = BasicERC20(registry.lookup(UTILITY_TOKEN));
        require(address(token) != address(0), "invalid address for token");
    }

    function deposit(uint256 amount) external stoppable returns (bool) {
        return _deposit(msg.sender, amount);
    }

    function _deposit(address sender, uint256 amount) internal returns (bool) {

        DepositDetails storage details = deposits[depositID];
        details.amount = amount;

        totalDeposited = totalDeposited.add(amount);

        emit DepositReceived(depositID, sender, amount);
        depositID++;

        require(token.transferFrom(sender, address(this), amount), "Transfer failed");

        return true;
    }
}