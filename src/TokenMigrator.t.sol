// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./Token.sol";
import "./TokenMigrator.sol";

contract TokenMigratorTest is DSTest {

    TokenMigrator private migrator;

    BasicERC20 private src;
    MintableERC20 private dst;

    UserRepresentative user;

    uint constant amount = 1_234;

    function setUp() public {
        migrator = new TokenMigrator();
        src = BasicERC20(address(new Token("SRC", "Source")));
        dst = MintableERC20(address(new Token("DST", "Destination")));
        dst.grantOperator(address(migrator));

        user = new UserRepresentative();

        src.transfer(address(user), amount);

    }

    function testStart() public {
        migrator.start(address(src), address(dst));
    }

    function testFailStartDouble() public {
        migrator.start(address(src), address(dst));
        migrator.start(address(src), address(dst));
    }

    function testFailStartInvalidToken() public {
        migrator.start(address(src), address(this));
    }

    function testStop() public {
        migrator.start(address(src), address(dst));
        migrator.stop();
    }

    function testFailStop() public {
        migrator.start(address(src), address(dst));
        migrator.stop();
        migrator.stop();
    }

    function testMigrate() public {
        migrator.start(address(src), address(dst));

        // Prove balances, i.e. src=1234, dst=0
        assertEq(src.balanceOf(address(user)), amount);
        assertEq(dst.balanceOf(address(user)), 0);

        // Approve and migrate
        user.approve(src, address(migrator), amount);
        user.migrate(migrator, 5);

        // Prove balances, i.e. src=0, dst=1234
        assertEq(src.balanceOf(address(user)), amount - 5);
        assertEq(dst.balanceOf(address(user)), 5);
    }

    function testFailMigrate() public {
        migrator.start(address(src), address(dst));

        // Prove balances, i.e. src=1234
        assertEq(src.balanceOf(address(user)), amount);
        
        // Try to migrate 2468, so fail
        user.migrate(migrator, amount * 2);
    }

    function testMigrateAll() public {
        migrator.start(address(src), address(dst));

        // Prove balances, i.e. src=1234, dst=0
        assertEq(src.balanceOf(address(user)), amount);
        assertEq(dst.balanceOf(address(user)), 0);

        // Approve and migrate
        user.approve(src, address(migrator), amount);
        user.migrateAll(migrator);

        // Prove balances, i.e. src=0, dst=1234
        assertEq(src.balanceOf(address(user)), 0);
        assertEq(dst.balanceOf(address(user)), amount);
    }

    function testMigrateAllSupplyIncrease() public {
        migrator.start(address(src), address(dst));

        // Store original supply of destination
        uint originalSupply = dst.totalSupply();

        // Approve and migrate
        user.approve(src, address(migrator), amount);
        user.migrateAll(migrator);

        // Make sure tokens are being minted
        uint newSupply = dst.totalSupply();
        uint newExpectedSupply = originalSupply + amount;

        assertEq(newSupply, newExpectedSupply);
    }

    function testFailMigrateAllUnapproved() public {
        // An unapproved migration
        user.migrateAll(migrator);
    }
}

contract UserRepresentative {
    function approve(BasicERC20 token, address who, uint amount) public {
        token.approve(who, amount);
    }

    function migrate(TokenMigrator migrator, uint amount) public {
        migrator.migrate(amount);
    }

    function migrateAll(TokenMigrator migrator) public {
        migrator.migrateAll();
    }
}