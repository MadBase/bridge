// SPDX-License-Identifier: MIT-open-group
pragma solidity >= 0.5.15;

import "ds-stop/stop.sol";

import "./diamonds/interfaces/Token.sol";
import "./diamonds/interfaces/ValidatorsEvents.sol";

import "./Constants.sol";
import "./Registry.sol";
import "./SafeMath.sol";

contract Deposit is Constants, DSStop, RegistryClient, SimpleAuth, ValidatorsEvents {

    /// @notice Event emitted when a deposit is received
    event DepositReceived(uint256 depositID, address depositor, uint256 amount);

    using SafeMath for uint256;

    Registry registry;

    bytes32 constant STORAGE_LOCATION = keccak256("deposit.storage");

    struct DepositStorage {
        uint256 totalDeposited;
        uint256 depositID;                     // Monatomically increasing
        mapping(uint256 => uint256) deposits;  // Key is deposit id, value is amount deposited
        mapping(uint256 => address) depositor; // Key is deposit id, value is who deposited
        BasicERC20 token;                      // Minting only required for migration
    }

    function depositStorage() internal pure returns (DepositStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

    constructor(Registry registry_) {
        registry = registry_;

        DepositStorage storage ds = depositStorage();
        ds.depositID = 1;
    }

    function reloadRegistry() external override onlyOperator {
        DepositStorage storage ds = depositStorage();

        ds.token = BasicERC20(registry.lookup(UTILITY_TOKEN));
        require(address(ds.token) != address(0), "invalid address for token");
    }

    function deposit(uint256 amount) external stoppable returns (bool) {
        return _deposit(msg.sender, amount);
    }

    function depositFor(address who, uint256 amount) external stoppable returns (bool) {
        return _deposit(msg.sender, amount);
    }

    function _deposit(address who, uint256 amount) internal returns (bool) {
        DepositStorage storage ds = depositStorage();

        ds.deposits[ds.depositID] = amount;
        ds.depositor[ds.depositID] = who;
        ds.totalDeposited = ds.totalDeposited.add(amount);

        emit DepositReceived(ds.depositID, who, amount);

        ds.depositID = ds.depositID.add(1);

        require(ds.token.transferFrom(who, address(this), amount), "Transfer failed");

        return true;
    }

    function directDeposit(
        uint256 _depositID,
        address who,
        uint256 amount
    ) external stoppable onlyOperator returns (bool) {

        emit DepositReceived(_depositID, who, amount);

        DepositStorage storage ds = depositStorage();

        uint256 originalAmount = ds.deposits[_depositID];

        ds.deposits[_depositID] = amount;
        ds.depositor[_depositID] = who;

        if (amount > originalAmount) {
            uint256 tmp = amount.sub(originalAmount);
            ds.totalDeposited = ds.totalDeposited.add(tmp);
        } else if (amount < originalAmount) {
            uint256 tmp = originalAmount.sub(amount);
            ds.totalDeposited = ds.totalDeposited.sub(tmp);
        }

        MintableERC20 mintable = MintableERC20(address(ds.token));
        mintable.mint(address(this), amount);
    }

    function deposits(uint256 _depositID) external view returns (uint256) {
        return depositStorage().deposits[_depositID];
    }

    function depositID() external view returns (uint256) {
        return depositStorage().depositID;
    }

    function setDepositID(uint256 _depositID) external onlyOperator {
        depositStorage().depositID = _depositID;
    }

    function totalDeposited() external view returns (uint256) {
        return depositStorage().totalDeposited;
    }

}