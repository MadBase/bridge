// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./StakeNFT.sol";

contract ValidatorNFT is StakeNFT {
    // solhint-disable no-empty-blocks
    constructor(
        string memory name_,
        string memory symbol_,
        IERC20Transferable madToken_,
        address admin_,
        address governance_
    ) StakeNFT(name_, symbol_, madToken_, admin_, governance_) {}

    /// mint allows a staking position to be opened. This function
    /// requires the caller to have performed an approve invocation against
    /// MadToken into this contract. This function will fail if the circuit
    /// breaker is tripped.
    function mint(uint256 amount_) public override withCB onlyAdmin returns (uint256 tokenID) {
        return _mintNFT(msg.sender, amount_);
    }

    /// mintTo allows a staking position to be opened in the name of an
    /// account other than the caller. This method also allows a lock to be
    /// placed on the position up to _maxMintLock . This function requires the
    /// caller to have performed an approve invocation against MadToken into
    /// this contract. This function will fail if the circuit breaker is
    /// tripped.
    function mintTo(
        address to_,
        uint256 amount_,
        uint256 lockDuration_
    ) public override withCB onlyAdmin returns (uint256 tokenID) {
        require(
            lockDuration_ <= _maxMintLock,
            "StakeNFT: The lock duration must be less or equal than the maxMintLock!"
        );
        tokenID = _mintNFT(to_, amount_);
        if (lockDuration_ > 0) {
            _lockPosition(tokenID, lockDuration_);
        }
        return tokenID;
    }

    /// burn exits a staking position such that all accumulated value is
    /// transferred to the owner on burn.
    function burn(uint256 tokenID_)
        public
        override
        onlyAdmin
        returns (uint256 payoutEth, uint256 payoutMadToken)
    {
        return _burn(msg.sender, msg.sender, tokenID_);
    }

    /// burnTo exits a staking position such that all accumulated value
    /// is transferred to a specified account on burn
    function burnTo(address to_, uint256 tokenID_)
        public
        override
        onlyAdmin
        returns (uint256 payoutEth, uint256 payoutMadToken)
    {
        return _burn(msg.sender, to_, tokenID_);
    }

    function collectEthTo(address to_, uint256 tokenID_) public returns (uint256 payout) {
        address owner = ownerOf(tokenID_);
        require(msg.sender == owner, "StakeNFT: Error sender is not the owner of the tokenID!");
        Position memory position = _positions[tokenID_];
        require(
            _positions[tokenID_].withdrawFreeAfter < block.number,
            "StakeNFT: Cannot withdraw at the moment."
        );

        // get values and update state
        (_positions[tokenID_], payout) = _collectEth(_shares, position);
        _reserveEth -= payout;
        // perform transfer and return amount paid out
        _safeTransferEth(to_, payout);
        return payout;
    }

    /// collectToken returns all due MadToken allocations to caller. The
    /// caller of this function must be the owner of the tokenID
    function collectTokenTo(address to_, uint256 tokenID_) public returns (uint256 payout) {
        address owner = ownerOf(tokenID_);
        require(msg.sender == owner, "StakeNFT: Error sender is not the owner of the tokenID!");
        Position memory position = _positions[tokenID_];
        require(
            position.withdrawFreeAfter < block.number,
            "StakeNFT: Cannot withdraw at the moment."
        );

        // get values and update state
        (_positions[tokenID_], payout) = _collectToken(_shares, position);
        _reserveToken -= payout;
        // perform transfer and return amount paid out
        _safeTransferERC20(_MadToken, to_, payout);
        return payout;
    }
}
