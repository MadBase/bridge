// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;


abstract contract Governance {

    // _governance is a privileged contract
    address _governance;

    constructor(address governance_) {
        _governance = governance_;
    }

    // onlyGovernance is a modifer that enforces a call
    // must be performed by the governance contract
    modifier onlyGovernance() {
        require(msg.sender == getGovernance());
        _;
    }

    // setGovernance allows governance address to be updated
    function _setGovernance(address governance_) internal {
        _governance = governance_;
    }

    // get getGovernance returns the current Governance contract
    function getGovernance() public view returns(address) {
        return _governance;
    }

    function setGovernance(address governance_) public virtual onlyGovernance {
        _setGovernance(governance_);
    }
}