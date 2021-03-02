// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-stop/stop.sol";

import "./interfaces/Token.sol";
import "./interfaces/ValidatorsEvents.sol";

import "./Constants.sol";
import "./Registry.sol";
import "./SafeMath.sol";

contract Deposit is Constants, DSStop, RegistryClient, SimpleAuth, ValidatorsEvents {

    using SafeMath for uint256;

    Registry public registry;
    BasicERC20 public token;

    struct DepositDetails {
        uint256 amount;
    }

    uint256 public totalDeposited;
    uint256 public depositID = 1;                       // Monatomically increasing
    mapping(uint256 => DepositDetails) public deposits; // Key is depositID

    constructor(Registry registry_) {
        registry = registry_;
    }

    function reloadRegistry() external override onlyOperator {
        // Lookup Token -- this is the utility token NOT the staking token
        token = BasicERC20(registry.lookup(UTILITY_TOKEN));
        require(address(token) != address(0), "invalid address for token");
    }

    function deposit(uint256 amount) external stoppable returns (bool) {
        bool success = _deposit(depositID, msg.sender, amount);

        depositID++;

        return success;
    }

    function deposit(address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        bool success = _deposit(depositID, who, amount);

        depositID++;

        return success;
    }

    function deposit(uint256 depositId, address who, uint256 amount) external onlyOperator stoppable returns (bool) {
        return _deposit(depositID, who, amount);
    }

    function _deposit(uint256 depositId, address who, uint256 amount) internal returns (bool) {

        DepositDetails storage details = deposits[depositID];
        details.amount = amount;

        totalDeposited = totalDeposited.add(amount);

        emit DepositReceived(depositID, who, amount);

        require(token.transferFrom(who, address(this), amount), "Transfer failed");

        return true;
    }
}