pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "./ERC165.sol";
import "./Validator.sol";

contract ERC165Test is DSTest {

    using ERC165Library for address;

    bytes4 constant erc165ID    = 0x01ffc9a7;
    bytes4 constant validatorID = 0x35e11235;
    bytes4 constant fakeID      = 0x12345678;

    Validator validator;

    function setUp() public {
        uint256[2] memory madNetID;
        bytes memory signature;

        validator = new ValidatorStandin(madNetID, signature);
    }

    function testSupportsERC165Interface() public {
        address validatorAddr = address(validator);
        bool ok = validatorAddr.supportsInterface(erc165ID);

        assertTrue(ok);
    }

    function testSupportsValidatorInterface() public {
        address validatorAddr = address(validator);
        bool ok = validatorAddr.supportsInterface(validatorID);

        assertTrue(ok);
    }

    function testSupportsFakeInterface() public {
        address validatorAddr = address(validator);
        bool ok = validatorAddr.supportsInterface(fakeID);

        assertTrue(!ok);
    }
}