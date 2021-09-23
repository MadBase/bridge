// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.7.6;

import "./MagicValue.sol";
import "./interfaces/IERC20Transfer.sol";
import "./interfaces/IMagicTokenTransfer.sol";


abstract contract MagicTokenTransfer is MagicValue {

    function _safeTransferTokenhWithMagic(IERC20Transfer token_, IMagicTokenTransfer to_, uint256 amount_) internal {
        bool success = token_.approve(address(to_), amount_);
        require(success, "Transfer failed.");
        to_.depositToken(_getMagic(), amount_);
        token_.approve(address(to_), 0);
    }
    
}