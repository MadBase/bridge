// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./GovernanceManager.sol";

abstract contract OldGovernance {

    // _governance is a privileged contract
    address _governance;

    constructor(address governance_) {
        _governance = governance_;
    }

    function _isAllowedProposal(address addr) internal view returns(bool) {
        return GovernanceManager(_governance).allowedProposal() == addr;
    }

    function isAllowedProposal(address addr) public view returns(bool) {
        return _isAllowedProposal(addr);
    }

    // onlyGovernance is a modifier that enforces a call
    // must be performed by the governance contract
    modifier onlyGovernance() {
        require(msg.sender == _governance || isAllowedProposal(msg.sender), "Governance: Action must be performed by the governance contract!");
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