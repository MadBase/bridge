// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.7.4;

import "../SafeMath.sol";

import "../interfaces/DepositEvents.sol";
import "../interfaces/Token.sol";

library DepositLibrary {

    using SafeMath for uint256;

    bytes32 constant STORAGE_LOCATION = keccak256("deposit.storage");

    /// @notice Event emitted when a deposit is received
    event DepositReceived(uint256 depositID, address depositor, uint256 amount);

    struct DepositStorage {
        uint256 totalDeposited;
        uint256 depositID;                     // Monatomically increasing
        mapping(uint256 => uint256) deposits;  // Key is deposit id, value is amount deposited
        mapping(uint256 => address) depositor; // Key is deposit id, value is who deposited
        MintableERC20 token;                   // Minting only required for migration
    }

    function depositStorage() internal pure returns (DepositStorage storage s) {
        bytes32 position = STORAGE_LOCATION;
        assembly { // solium-disable-line
            s.slot := position
        }
    }

    function deposit(uint256 amount) internal returns (bool) {
        return depositFor(msg.sender, amount);
    }

    function depositFor(address who, uint256 amount) internal returns (bool) {
        DepositStorage storage ds = depositStorage();

        ds.deposits[ds.depositID] = amount;
        ds.depositor[ds.depositID] = who;
        ds.totalDeposited.add(amount);

        emit DepositReceived(ds.depositID, who, amount);

        ds.depositID.add(1);

        require(ds.token.transferFrom(who, address(this), amount), "Transfer failed");

        return true;
    }

    // function depositFor(uint256 depositID, address who, uint256 amount) internal returns (bool) {
    //     DepositStorage storage ds = depositStorage();

    //     ds.deposits[depositId] = amount;
    //     ds.depositor[depositId] = who;
    //     ds.totalDeposited.add(amount);

    //     emit DepositReceived(depositID, who, amount);

    //     ds.depositID.add(1);

    //     require(token.transferFrom(who, address(this), amount), "Transfer failed");

    //     return true;
    // }

}