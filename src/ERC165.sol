// SPDX-License-Identifier: MIT-open-group
pragma solidity >=0.5.15;

interface ERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

library ERC165Library {

    bytes4 constant erc165ID = 0x01ffc9a7;

    function supportsInterface(
        address _contract, bytes4 _interfaceID
    ) internal view returns (bool) {
        uint256 ok;
        uint256 res;
        assembly { // solium-disable-line
            let x := mload(0x40)               // Find empty storage location using "free memory pointer"
            mstore(x, erc165ID)                // Place signature at beginning of empty storage
            mstore(add(x, 0x04), _interfaceID) // Place first argument directly next to signature

            ok := staticcall(
                    30000,         // 30k gas
                    _contract,     // To addr
                    x,             // Inputs are stored at location x
                    0x24,          // Inputs are 36 bytes long
                    x,             // Store output over input (saves space)
                    0x20)          // Outputs are 32 bytes long

            res := mload(x)        // Load the result
        }

        return ok==1 && res==1;
    }
}