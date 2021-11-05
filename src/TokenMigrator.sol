// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "lib/ds-token/token.sol";

import "./SafeMath.sol";
import "./SimpleAuth.sol";
import "./diamonds/interfaces/Token.sol";

contract TokenMigratorEvents {
    event Started(address source, address destination, address who);
    event Stopped(address who);
}

contract TokenMigrator is SimpleAuth, TokenMigratorEvents {

    using SafeMath for uint256;

    bool private started;

    address[] migratedAccounts;
    mapping(address => bool) hasMigrated;
    mapping(address => uint256) migratedAmounts;

    BasicERC20 private source;
    MintableERC20 private destination; // TODO Make an interface that is ERC20 + Mintable

    function start(address src, address dst) public onlyOperator {
        require(isProbablyERC20(src), "source does not appear to be an ERC20 (failed call to totalSupply())");
        require(isProbablyERC20(dst), "destination does not appear to be an ERC20 (failed call to totalSupply())");
        require(!started, "migration has already started");

        started = true;
        source = BasicERC20(src);
        destination = MintableERC20(dst);

        emit Started(src, dst, msg.sender);
    }

    function stop() public onlyOperator {
        require(started, "migration not started");

        started = false;
        source = BasicERC20(address(0));
        destination = MintableERC20(address(0));

        emit Stopped(msg.sender);
    }

    function getSource() public view returns (address) {
        return address(source);
    }

    function getDestination() public view returns (address) {
        return address(destination);
    }

    function migrate(uint amount) public {
        _migrate(msg.sender, amount);
    }

    function migrateAll() public {
        // Determine how much to migrate
        address who = msg.sender;
        uint256 sourceBalance = source.balanceOf(who);
        uint256 sourceAllowance = source.allowance(who, address(this));
        uint256 amount = sourceAllowance.min(sourceBalance);

        require(amount > 0, "no tokens available to migrate");

        // Do the deed
        _migrate(who, amount);
    }

    function _migrate(address who, uint amount) internal {

        // Bookkeeping
        if (!hasMigrated[who]) {
            migratedAccounts.push(msg.sender);
            hasMigrated[who] = true;
        }
        migratedAmounts[who] += amount;

        // Do the deed
        source.transferFrom(who, address(this), amount);
        destination.mint(who, amount);
    }

    // I don't want to rely on ERC165 so hoping totalSupply() is a good indicator
    // TODO Use ERC165 also
    function isProbablyERC20(address token) internal returns (bool) {
        bool ok;
        bytes memory res;

        (ok, res) = address(token).call( // solium-disable-line
            abi.encodeWithSignature("totalSupply()"));

        uint supply = abi.decode(res, (uint));

        return ok && supply > 0;
    }
}