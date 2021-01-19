// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.15;

contract SimpleAuth  {

    mapping(address => bool) private authorizedOperators_;
    uint private authorizedOperatorCount_;

    address private owner_;

    constructor() public {
        owner_ = msg.sender;
        grantOperator(owner_);
    }

    function grantOperator(address _operator) public virtual onlyOperator {
        authorizedOperators_[_operator] = true;
        authorizedOperatorCount_++;
    }

    function revokeOperator(address _operator) public virtual onlyOperator {
        require(authorizedOperatorCount_ > 1, "Can't remove all operators");
        delete authorizedOperators_[_operator];
        authorizedOperatorCount_--;
    }

    modifier onlyOperator() {
        require(msg.sender == owner_ || authorizedOperators_[msg.sender],
            "Functionality restricted to authorized operators.");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner_, "Functionality restricted to authorized operators.");
        _;
    }
}