// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../governance/GovernanceMaxLock.sol";
import "../utils/DeterministicAddress.sol";
import "./utils/EthSafeTransfer.sol";
import "./utils/ERC20SafeTransfer.sol";
import "./utils/MagicValue.sol";
import "./interfaces/ICBOpener.sol";
import "./interfaces/INFTStake.sol";


abstract contract MNERC721 is ERC721 {
 constructor() ERC721("MNSTAKE", "MNS") {}
}

abstract contract StakeNFTStorage {

        // Position describes a staked position
    struct Position {
        // number of madToken
        uint224 shares;
        // block number after which the position may be burned.
        // prevents double spend of voting weight
        uint32 freeAfter;
        // block number after which the position may be collected or burned.
        uint256 withdrawFreeAfter;
        // the last value of the ethState accumulator this account performed a
        // withdraw at
        uint256 accumulatorEth;
        // the last value of the tokenState accumulator this account performed a
        // withdraw at
        uint256 accumulatorToken;
    }

    // Accumulator is a struct that allows values to be collected such that the
    // remainders of floor division may be cleaned up
    struct Accumulator {
        // accumulator is a sum of all changes always increasing
        uint256 accumulator;
        // slush stores division remainders until they may be distributed evenly
        uint256 slush;
    }

    // _admin is a privileged role
    address _admin;

    // monotonically increasing counter
    uint256 _counter;

     // cb is the circuit breaker
    // cb is a set only object
    bool _cb;

    // _shares stores total amount of MadToken staked in contract
    uint256 _shares;

    // _tokenState tracks distribution of MadToken that originate from slashing
    // events
    Accumulator _tokenState;

    // _ethState tracks the distribution of Eth that originate from the sale of
    // MadBytes
    Accumulator _ethState;

    // _positions tracks all staked positions based on tokenID
    mapping(uint256 => Position) _positions;

    // state to keep track of the amount of Eth deposited and collected from the
    // contract
    uint256 _reserveEth;

    // state to keep track of the amount of MadTokens deposited and collected
    // from the contract
    uint256 _reserveToken;

}

contract StakeNFT is
    MNERC721,
    StakeNFTStorage,
    DeterministicAddress,
    MagicValue,
    EthSafeTransfer,
    ERC20SafeTransfer,
    GovernanceMaxLock,
    ICBOpener,
    INFTStake
{
    // _maxMintLock describes the maximum interval a Position may be locked
    // during a call to mintTo
    uint256 constant _maxMintLock = 1051200;
    // 10**18
    uint256 constant _accumulatorScaleFactor = 1000000000000000000;
    // constants for the cb state
    bool constant open = true;
    bool constant closed = false;
    // _governance is a privileged contract
    address immutable _governance;
    // _governance is a privileged contract
    address immutable _factory;
    // simple wrapper around MadToken ERC20 contract
    IERC20Transferable immutable _MadToken;

    constructor(address factory_) MNERC721() {
        _factory = factory_;
        _admin = factory_;
        _MadToken = getMetamorphicContractAddress(0x4d6164546f6b656e000000000000000000000000000000000000000000000000);
        _governance = getMetamorphicContractAddress(0x476f7665726e616e636500000000000000000000000000000000000000000000);
        if (_cb == 0) {
            _cb = closed;
        }
    }

    //  onlyGovernance is a modifier that enforces a call
    // must be performed by the governance contract
    modifier onlyGovernance() {
        require(msg.sender == _governance || isAllowedProposal(msg.sender), "Governance: Action must be performed by the governance contract!");
        _;
    }

    // withCB is a modifier to enforce the CB must
    // be set for a call to succeed
    modifier withCB() {
        require(_cb == closed, "CircuitBreaker: The Circuit breaker is opened!");
        _;
    }
    
    /// @dev onlyAdmin enforces msg.sender is _admin
    modifier onlyAdmin() {
        require(msg.sender == _admin, "Must be admin");
        _;
    }

    // get getGovernance returns the current Governance contract
    function getGovernance() public view returns(address) {
        return _governance;
    }

    function isAllowedProposal(address addr) public view returns(bool) {
        return _isAllowedProposal(addr);
    }
    

    function cbState() public view returns(bool) {
        return _cb;
    }

    /// @dev getAdmin returns the current _admin
    function getAdmin() public view returns(address) {
        return _admin;
    }

    /// gets the _accumulatorScaleFactor used to scale the ether and tokens
    /// deposited on this contract to reduce the integer division errors.
    function accumulatorScaleFactor() public pure returns (uint256) {
        return _accumulatorScaleFactor;
    }

    /// gets the total amount of MadToken staked in contract
    function getTotalShares() public view returns (uint256) {
        return _shares;
    }

    /// gets the total amount of Ether staked in contract
    function getTotalReserveEth() public view returns (uint256) {
        return _reserveEth;
    }

    /// gets the total amount of MadToken staked in contract
    function getTotalReserveMadToken() public view returns (uint256) {
        return _reserveToken;
    }

    /// estimateEthCollection returns the amount of eth a tokenID may withdraw
    function estimateEthCollection(uint256 tokenID_) public view returns (uint256 payout) {
        require(_exists(tokenID_), "StakeNFT: Error, NFT token doesn't exist!");
        Position memory p = _positions[tokenID_];
        (, , , payout) = _collect(_shares, _ethState, p, p.accumulatorEth);
        return payout;
    }

    /// estimateTokenCollection returns the amount of MadToken a tokenID may withdraw
    function estimateTokenCollection(uint256 tokenID_) public view returns (uint256 payout) {
        require(_exists(tokenID_), "StakeNFT: Error, NFT token doesn't exist!");
        Position memory p = _positions[tokenID_];
        (, , , payout) = _collect(_shares, _tokenState, p, p.accumulatorToken);
        return payout;
    }

    /// estimateExcessToken returns the amount of MadToken that is held in the
    /// name of this contract. The value returned is the value that would be
    /// returned by a call to skimExcessToken.
    function estimateExcessToken() public view returns (uint256 excess) {
        (, excess) = _estimateExcessToken();
        return excess;
    }

    /// estimateExcessEth returns the amount of Eth that is held in the name of
    /// this contract. The value returned is the value that would be returned by
    /// a call to skimExcessEth.
    function estimateExcessEth() public view returns (uint256 excess) {
        return _estimateExcessEth();
    }

    /// @dev assigns a new admin may only be called by _admin
    function setAdmin(address admin_) public virtual onlyAdmin {
        _setAdmin(admin_);
    }

    /// @dev tripCB opens the circuit breaker may only be called by _admin
    function tripCB() public override onlyAdmin {
        _tripCB();
    }

    /// @dev sets the governance contract, must only be called by _admin
    function setGovernance(address governance_) public onlyAdmin {
        _setGovernance(governance_);
    }

    /// skimExcessEth will send to the address passed as to_ any amount of Eth
    /// held by this contract that is not tracked by the Accumulator system. This
    /// function allows the Admin role to refund any Eth sent to this contract in
    /// error by a user. This method can not return any funds sent to the contract
    /// via the depositEth method. This function should only be necessary if a
    /// user somehow manages to accidentally selfDestruct a contract with this
    /// contract as the recipient.
    function skimExcessEth(address to_) public onlyAdmin returns (uint256 excess) {
        excess = _estimateExcessEth();
        _safeTransferEth(to_, excess);
        return excess;
    }

    /// skimExcessToken will send to the address passed as to_ any amount of
    /// MadToken held by this contract that is not tracked by the Accumulator
    /// system. This function allows the Admin role to refund any MadToken sent to
    /// this contract in error by a user. This method can not return any funds
    /// sent to the contract via the depositToken method.
    function skimExcessToken(address to_) public onlyAdmin returns (uint256 excess) {
        IERC20Transferable MadToken;
        (MadToken, excess) = _estimateExcessToken();
        _safeTransferERC20(MadToken, to_, excess);
        return excess;
    }

    /// lockPosition is called by governance system when a governance
    /// vote is cast. This function will lock the specified Position for up to
    /// _maxGovernanceLock. This method may only be called by the governance
    /// contract. This function will fail if the circuit breaker is tripped
    function lockPosition(
        address caller_,
        uint256 tokenID_,
        uint256 lockDuration_
    ) public override withCB onlyGovernance returns (uint256) {
        require(
            caller_ == ownerOf(tokenID_),
            "StakeNFT: Error, token doesn't exist or doesn't belong to the caller!"
        );
        require(
            lockDuration_ <= _maxGovernanceLock,
            "StakeNFT: Lock Duration is greater than the amount allowed!"
        );
        return _lockPosition(tokenID_, lockDuration_);
    }


    /// This function will lock an owned Position for up to _maxGovernanceLock. This method may
    /// only be called by the owner of the Position. This function will fail if the circuit breaker
    /// is tripped
    function lockOwnPosition(
        uint256 tokenID_,
        uint256 lockDuration_
    ) public withCB returns (uint256) {
        require(
            msg.sender == ownerOf(tokenID_),
            "StakeNFT: Error, token doesn't exist or doesn't belong to the caller!"
        );
        require(
            lockDuration_ <= _maxGovernanceLock,
            "StakeNFT: Lock Duration is greater than the amount allowed!"
        );
        return _lockPosition(tokenID_, lockDuration_);
    }

    /// This function will lock withdraws on the specified Position for up to
    /// _maxGovernanceLock. This function will fail if the circuit breaker is tripped
    function lockWithdraw(uint256 tokenID_, uint256 lockDuration_)
        public
        withCB
        returns (uint256)
    {
        require(
            msg.sender == ownerOf(tokenID_),
            "StakeNFT: Error, token doesn't exist or doesn't belong to the caller!"
        );
        require(
            lockDuration_ <= _maxGovernanceLock,
            "StakeNFT: Lock Duration is greater than the amount allowed!"
        );
        return _lockWithdraw(tokenID_, lockDuration_);
    }

    /// DO NOT CALL THIS METHOD UNLESS YOU ARE MAKING A DISTRIBUTION AS ALL VALUE
    /// WILL BE DISTRIBUTED TO STAKERS EVENLY. depositToken distributes MadToken
    /// to all stakers evenly should only be called during a slashing event. Any
    /// MadToken sent to this method in error will be lost. This function will
    /// fail if the circuit breaker is tripped. The magic_ parameter is intended
    /// to stop some one from successfully interacting with this method without
    /// first reading the source code and hopefully this comment
    function depositToken(uint8 magic_, uint256 amount_) public withCB checkMagic(magic_) {
        // collect tokens
        _safeTransferFromERC20(_MadToken, msg.sender, amount_);
        // update state
        _tokenState = _deposit(_shares, amount_, _tokenState);
        _reserveToken += amount_;
    }

    /// DO NOT CALL THIS METHOD UNLESS YOU ARE MAKING A DISTRIBUTION ALL VALUE
    /// WILL BE DISTRIBUTED TO STAKERS EVENLY depositEth distributes Eth to all
    /// stakers evenly should only be called by MadBytes contract any Eth sent to
    /// this method in error will be lost this function will fail if the circuit
    /// breaker is tripped the magic_ parameter is intended to stop some one from
    /// successfully interacting with this method without first reading the
    /// source code and hopefully this comment
    function depositEth(uint8 magic_) public payable withCB checkMagic(magic_) {
        _ethState = _deposit(_shares, msg.value, _ethState);
        _reserveEth += msg.value;
    }

    /// mint allows a staking position to be opened. This function
    /// requires the caller to have performed an approve invocation against
    /// MadToken into this contract. This function will fail if the circuit
    /// breaker is tripped.
    function mint(uint256 amount_) public virtual withCB returns (uint256 tokenID) {
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
    ) public virtual withCB returns (uint256 tokenID) {
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
        virtual
        returns (uint256 payoutEth, uint256 payoutMadToken)
    {
        return _burn(msg.sender, msg.sender, tokenID_);
    }

    /// burnTo exits a staking position such that all accumulated value
    /// is transferred to a specified account on burn
    function burnTo(address to_, uint256 tokenID_)
        public
        virtual
        returns (uint256 payoutEth, uint256 payoutMadToken)
    {
        return _burn(msg.sender, to_, tokenID_);
    }

    /// collectEth returns all due Eth allocations to caller. The caller
    /// of this function must be the owner of the tokenID
    function collectEth(uint256 tokenID_) public returns (uint256 payout) {
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
        _safeTransferEth(owner, payout);
        return payout;
    }

    /// collectToken returns all due MadToken allocations to caller. The
    /// caller of this function must be the owner of the tokenID
    function collectToken(uint256 tokenID_) public returns (uint256 payout) {
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
        _safeTransferERC20(_MadToken, owner, payout);
        return payout;
    }

    /// collectEth returns all due Eth allocations to the to_ address. The caller
    /// of this function must be the owner of the tokenID
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

    /// collectTokenTo returns all due MadToken allocations to the to_ address. The
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

    /// gets the position struct given a tokenID. The tokenId must
    /// exist.
    function getPosition(uint256 tokenID_)
        public
        view
        returns (
            uint256 shares,
            uint256 freeAfter,
            uint256 withdrawFreeAfter,
            uint256 accumulatorEth,
            uint256 accumulatorToken
        )
    {
        require(_exists(tokenID_), "StakeNFT: Token ID doesn't exist!");
        Position memory p = _positions[tokenID_];
        shares = uint256(p.shares);
        freeAfter = uint256(p.freeAfter);
        withdrawFreeAfter = uint256(p.withdrawFreeAfter);
        accumulatorEth = p.accumulatorEth;
        accumulatorToken = p.accumulatorToken;
    }

    /// gets the current value for the Eth accumulator
    function getEthAccumulator() external view returns (uint256 accumulator, uint256 slush) {
        accumulator = _ethState.accumulator;
        slush = _ethState.slush;
    }

    /// gets the current value for the Token accumulator
    function getTokenAccumulator() external view returns (uint256 accumulator, uint256 slush) {
        accumulator = _tokenState.accumulator;
        slush = _tokenState.slush;
    }

    // _lockPosition prevents a position from being burned for duration_ number
    // of blocks by setting the freeAfter field on the Position struct returns
    // the number of shares in the locked Position so that governance vote
    // counting may be performed when setting a lock
    function _lockPosition(uint256 tokenID_, uint256 duration_) internal returns (uint256 shares) {
        require(_exists(tokenID_), "StakeNFT: Token ID doesn't exist!");
        Position memory p = _positions[tokenID_];
        uint32 freeDur = uint32(block.number) + uint32(duration_);
        p.freeAfter = freeDur > p.freeAfter ? freeDur : p.freeAfter;
        _positions[tokenID_] = p;
        return p.shares;
    }

    // _lockWithdraw prevents a position from being collected and burned for duration_ number of blocks
    // by setting the withdrawFreeAfter field on the Position struct.
    // returns the number of shares in the locked Position so that
    function _lockWithdraw(uint256 tokenID_, uint256 duration_) internal returns (uint256 shares) {
        require(_exists(tokenID_), "StakeNFT: Token ID doesn't exist!");
        Position memory p = _positions[tokenID_];
        uint256 freeDur = block.number + duration_;
        p.withdrawFreeAfter = freeDur > p.withdrawFreeAfter ? freeDur : p.withdrawFreeAfter;
        _positions[tokenID_] = p;
        return p.shares;
    }

    // _mintNFT performs the mint operation and invokes the inherited _mint method
    function _mintNFT(address to_, uint256 amount_) internal returns (uint256 tokenID) {
        // this is to allow struct packing and is safe due to MadToken having a
        // total distribution of 220M
        require(
            amount_ <= 2**224 - 1,
            "StakeNFT: The amount exceeds the maximum number of MadTokens that will ever exist!"
        );
        // transfer the number of tokens specified by amount_ into contract
        // from the callers account
        _safeTransferFromERC20(_MadToken, msg.sender, amount_);

        // get local copy of storage vars to save gas
        uint256 shares = _shares;
        Accumulator memory ethState = _ethState;
        Accumulator memory tokenState = _tokenState;

        // get new tokenID from counter
        tokenID = _increment();

        // update storage
        shares += amount_;
        _shares = shares;
        _positions[tokenID] = Position(
            uint224(amount_),
            1,
            1,
            ethState.accumulator,
            tokenState.accumulator
        );
        _reserveToken += amount_;
        // invoke inherited method and return
        ERC721._mint(to_, tokenID);
        return tokenID;
    }

    // _burn performs the burn operation and invokes the inherited _burn method
    function _burn(
        address from_,
        address to_,
        uint256 tokenID_
    ) internal returns (uint256 payoutEth, uint256 payoutToken) {
        require(from_ == ownerOf(tokenID_), "StakeNFT: User is not the owner of the tokenID!");

        // collect state
        Position memory p = _positions[tokenID_];
        // enforce freeAfter to prevent burn during lock
        require(
            p.freeAfter < block.number && p.withdrawFreeAfter < block.number,
            "StakeNFT: The position is not ready to be burned!"
        );

        // get copy of storage to save gas
        uint256 shares = _shares;

        // calc Eth amounts due
        (p, payoutEth) = _collectEth(shares, p);

        // calc token amounts due
        (p, payoutToken) = _collectToken(shares, p);

        // add back to token payout the original stake position
        payoutToken += p.shares;

        // debit global shares counter and delete from mapping
        _shares -= p.shares;
        _reserveToken -= payoutToken;
        _reserveEth -= payoutEth;
        delete _positions[tokenID_];

        // invoke inherited burn method
        ERC721._burn(tokenID_);

        // transfer out all eth and tokens owed
        _safeTransferERC20(_MadToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);
        return (payoutEth, payoutToken);
    }

    // _estimateExcessEth returns the amount of Eth that is held in the name of
    // this contract
    function _estimateExcessEth() internal view returns (uint256 excess) {
        uint256 reserve = _reserveEth;
        uint256 balance = address(this).balance;
        require(
            balance >= reserve,
            "StakeNFT: The balance of the contract is less then the tracked reserve!"
        );
        excess = balance - reserve;
    }

    // _estimateExcessToken returns the amount of MadToken that is held in the
    // name of this contract
    function _estimateExcessToken()
        internal
        view
        returns (IERC20Transferable MadToken, uint256 excess)
    {
        uint256 reserve = _reserveToken;
        MadToken = _MadToken;
        uint256 balance = MadToken.balanceOf(address(this));
        require(
            balance >= reserve,
            "StakeNFT: The balance of the contract is less then the tracked reserve!"
        );
        excess = balance - reserve;
        return (MadToken, excess);
    }

    function _collectToken(uint256 shares_, Position memory p_)
        internal
        returns (Position memory p, uint256 payout)
    {
        uint256 acc;
        (_tokenState, p, acc, payout) = _collect(shares_, _tokenState, p_, p_.accumulatorToken);
        p.accumulatorToken = acc;
        return (p, payout);
    }

    // _collectEth performs call to _collect and updates state during a request
    // for an eth distribution
    function _collectEth(uint256 shares_, Position memory p_)
        internal
        returns (Position memory p, uint256 payout)
    {
        uint256 acc;
        (_ethState, p, acc, payout) = _collect(shares_, _ethState, p_, p_.accumulatorEth);
        p.accumulatorEth = acc;
        return (p, payout);
    }

    // _collect performs calculations necessary to determine any distributions
    // due to an account such that it may be used for both token and eth
    // distributions this prevents the need to keep redundant logic
    function _collect(
        uint256 shares_,
        Accumulator memory state_,
        Position memory p_,
        uint256 positionAccumulatorValue_
    )
        internal
        pure
        returns (
            Accumulator memory,
            Position memory,
            uint256,
            uint256
        )
    {
        // determine number of accumulator steps this Position needs distributions from
        uint256 accumulatorDelta = 0;
        if (positionAccumulatorValue_ > state_.accumulator) {
            accumulatorDelta = type(uint168).max - positionAccumulatorValue_;
            accumulatorDelta += state_.accumulator;
            positionAccumulatorValue_ = accumulatorDelta;
        } else {
            accumulatorDelta = state_.accumulator - positionAccumulatorValue_;
            // update accumulator value for calling method
            positionAccumulatorValue_ += accumulatorDelta;
        }
        // calculate payout based on shares held in position
        uint256 payout = accumulatorDelta * p_.shares;
        // if there are no shares other than this position, flush the slush fund
        // into the payout and update the in memory state object
        if (shares_ == p_.shares) {
            payout += state_.slush;
            state_.slush = 0;
        }

        uint256 payoutReminder = payout;
        // reduce payout by scale factor
        payout /= _accumulatorScaleFactor;
        // Computing and saving the numeric error from the floor division in the
        // slush.
        payoutReminder -= payout * _accumulatorScaleFactor;
        state_.slush += payoutReminder;

        return (state_, p_, positionAccumulatorValue_, payout);
    }

    // _deposit allows an Accumulator to be updated with new value if there are
    // no currently staked positions, all value is stored in the slush
    function _deposit(
        uint256 shares_,
        uint256 delta_,
        Accumulator memory state_
    ) internal pure returns (Accumulator memory) {
        state_.slush += (delta_ * _accumulatorScaleFactor);

        if (shares_ > 0) {
            (state_.accumulator, state_.slush) = _slushSkim(
                shares_,
                state_.accumulator,
                state_.slush
            );
        }
        // Slush should be never be above 2**167 to protect against overflow in
        // the later code.
        require(state_.slush < 2**167, "StakeNFT: slush too large");
        return state_;
    }

    // _slushSkim flushes value from the slush into the accumulator if there are
    // no currently staked positions, all value is stored in the slush
    function _slushSkim(
        uint256 shares_,
        uint256 accumulator_,
        uint256 slush_
    ) internal pure returns (uint256, uint256) {
        if (shares_ > 0) {
            uint256 deltaAccumulator = slush_ / shares_;
            slush_ -= deltaAccumulator * shares_;
            accumulator_ += deltaAccumulator;
            // avoiding accumulator_ overflow.
            if (accumulator_ > type(uint168).max) {
                // The maximum allowed value for the accumulator is 2**168-1.
                // This hard limit was set to not overflow the operation
                // `accumulator * shares` that happens later in the code.
                accumulator_ = accumulator_ % type(uint168).max;
            }
        }
        return (accumulator_, slush_);
    }

    function _isAllowedProposal(address addr) internal view returns(bool) {
        return IGovernanceManager(_governance).allowedProposal() == addr;
    }

    // setGovernance allows governance address to be updated
    function _setGovernance(address governance_) internal {
        _governance = governance_;
    }

    function _tripCB() internal {
        require(_cb == closed, "CircuitBreaker: The Circuit breaker is opened!");
        _cb = open;
    }

    function _resetCB() internal {
        require(_cb == open, "CircuitBreaker: The Circuit breaker is closed!");
        _cb = closed;
    }

    // _newTokenID increments the counter and returns the new value
    function _increment() internal returns (uint256 count) {
        count = _counter;
        count += 1;
        _counter = count;
        return count;
    }

    function _getCount() internal view returns (uint256) {
        return _counter;
    }

    // assigns a new admin may only be called by _admin
    function _setAdmin(address admin_) internal {
        _admin = admin_;
    }
}
