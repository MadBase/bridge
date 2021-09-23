// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.7.6;


abstract contract Admin {
    
    // _admin is a priveledged role
    address _admin;
    
    constructor(address admin_) {
        _admin = admin_;
    }

    // onlyAdmin enforces msg.sender is _admin
    modifier onlyAdmin() {
        require(msg.sender == _admin, "Must be admin");
        _;
    }
    
    // assigns a new admin
    // may only be called by _admin
    function _setAdmin(address admin_) internal {
        _admin = admin_;
    }
    
    // getAdmin returns the current _admin
    function getAdmin() public view returns(address) {
        return _admin;
    }
    
    function setAdmin(address admin_) public virtual onlyAdmin {
        _setAdmin(admin_);
    }
}