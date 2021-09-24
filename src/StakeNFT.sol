// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./lib/openzeppelin//token/ERC721/ERC721.sol";
import "./lib/openzeppelin//token/ERC20/ERC20.sol";


contract StakeNFT is ERC721, MagicValue, Admin, Governance, CircuitBreaker, AtomicCounter, EthSafeTransfer, ERC20SafeTransfer, GovernanceMaxLock, ICBOpener {

    // _maxMintLock describes the maximum interval
    // a Position may be locked during a call to
    // mintTo
    uint256 constant _maxMintLock = 1051200;

    // Position describes a staked position
    struct Position {
        // number of madToken
        uint32 shares;

        // block number after which the position may be burned
        // prevents double spend of voting weight
        uint32 freeAfter;

        // the last value of the ethState accumulator this
        // account performed a withdraw at
        uint256 accumulatorEth;

        // the last value of the tokenState accumulator this
        // account performed a withdraw at
        uint256 accumulatorToken;
    }

    // Accumulator is a struct that allows values
    // to be collected such that the remainders
    // of floor division may be cleaned up
    struct Accumulator {
        // accumulator is a sum of all changes
        // always increasing
        uint256 accumulator;

        // slush stores division remainders
        // until they may be distributed evenly
        uint256 slush;
    }

    // _shares stores total amount of MadToken staked in contract
    uint256 _shares = 0;

    // _tokenState tracks distribution of MadToken that
    // originate from slashing events
    Accumulator _tokenState;

    // _ethState tracks the distribution of Eth that
    // originate from the sale of MadBytes
    Accumulator _ethState;

    // simple wrapper around MadToken ERC20 contract
    IERC20Transfer _MadToken;

    // _positions tracks all staked positions
    // based on tokenID
    mapping (uint256=>Position) _positions;


    constructor(IERC20Transfer MadToken_, address admin_, address governance_) ERC721("MNStake","MNS") Governance(governance_) Admin(admin_) {
        _MadToken = MadToken_;
    }

    // tripCB opens the circuit breaker
    // may only be called by an _admin
    function tripCB() public override onlyAdmin {
        _tripCB();
    }

    function setGovernance(address governance_) public override onlyAdmin {
        _setGovernance(governance_);
    }

    // estimateEthCollection returns the amount of eth a tokenID may withdraw
    function estimateEthCollection(uint256 tokenID_) public view returns(uint256 payout) {
        require(_exists(tokenID_));
        Position memory p = _positions[tokenID_];
        (, , , payout) = _collect(_shares, _ethState, p, p.accumulatorEth);
        return payout;
    }

    // estimateTokenCollection returns the amount of MadToken a tokenID may withdraw
    function estimateTokenCollection(uint256 tokenID_) public view returns(uint256 payout) {
        require(_exists(tokenID_));
        Position memory p = _positions[tokenID_];
        (, , , payout) = _collect(_shares, _tokenState, p, p.accumulatorToken);
        return payout;
    }

    // estimateExcessToken returns the amount of MadToken that is held in the name of this
    // contract
    // this is the value that would be returned by a call to skimExcessToken
    function estimateExcessToken() public view returns(uint256 excess) {
        ( , excess) = _estimateExcessToken();
        return excess;
    }

    // estimateExcessEth returns the amount of Eth that is held in the name of this
    // contract
    // this is the value that would be returned by a call to skimExcessEth
    function estimateExcessEth() public view returns(uint256 excess) {
        return _estimateExcessEth();
    }

    // skimExcessOtherERC20 sends amount_ of an external ERC20 (other than MadToken) that is held in the name of this
    // contract to the address defined as to_
    // This function allows the Admin role to refund any ERC20 asset sent to this contract in error by a user
    function skimExcessOtherERC20(address tokenAddress_, address to_, uint256 amount_) public onlyAdmin {
        require(tokenAddress_ != address(_MadToken));
        IERC20Transfer token = IERC20Transfer(tokenAddress_);
        _safeTransferERC20(token, to_, amount_);
    }

    // skimExcessOtherERC721 sends ERC721 asset with tokenID_ from contract located at tokenAddress_ fro the ownership of this
    // contract to the address defined as to_
    // This function allows the Admin role to refund any asset ERC721 sent to this contract in error by a user
    function skimExcessOtherERC721(address tokenAddress_, address to_, uint256 tokenID_) public onlyAdmin {
        IERC721Transfer token = IERC721Transfer(tokenAddress_);
        token.safeTransferFrom(address(this), to_, tokenID_);
    }

    // skimExcessEth will send to the address passed as to_ any amount of Eth
    // held by this contract that is not tracked by the Accumulator system
    // This function allows the Admin role to refund any Eth sent to this
    // contract in error by a user
    // this method can not return any funds sent to the contract via the depositEth method
    // this function should only be necessary if a user somehow manages to accidentally
    // selfDestruct a contract with this contract as the reciepient
    function skimExcessEth(address to_) public onlyAdmin returns(uint256 excess) {
        excess = _estimateExcessEth();
        _safeTransferEth(to_, excess);
        return excess;
    }

    // skimExcessToken will send to the address passed as to_ any amount of MadToken
    // held by this contract that is not tracked by the Accumulator system
    // This function allows the Admin role to refund any MadToken sent to this
    // contract in error by a user
    // this method can not return any funds sent to the contract via the depositToken method
    function skimExcessToken(address to_) public onlyAdmin returns(uint256 excess) {
        IERC20Transfer MadToken;
        (MadToken, excess) = _estimateExcessToken();
        _safeTransferERC20(MadToken, to_, excess);
        return excess;
    }

    // lockPosition is called by governance system when a governance vote is cast
    // this function will lock the specified Position for up to _maxGovernanceLock
    // this method may only be called by the governance contract
    // this function will fail if the circuit breaker is tripped
    function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) public withCB onlyGovernance returns(uint256 numberShares) {
        require(caller_ == ownerOf(tokenID_));
        require(lockDuration_ <= _maxGovernanceLock);
        return _lockPosition(tokenID_, lockDuration_);
    }

    // DO NOT CALL THIS METHOD UNLESS YOU ARE MAKING A DISTRIBUTION
    // ALL VALUE WILL BE DISTRIBUTED TO STAKERS EVENLY
    // depositToken distribues MadToken to all stakers evenly
    // should only be called during a slashing event
    // any MadToken sent to this method in error will be lost
    // this function will fail if the circuit breaker is tripped
    // the magic_ parameter is intended to stop some one from
    // successfully interacting with this method without first reading
    // the source code and hopefully this comment
    function depositToken(uint8 magic_, uint256 amount_) public withCB checkMagic(magic_) {
        // collect tokens
        _safeTransferFromERC20(_MadToken, msg.sender, amount_);
        // update state
        _tokenState = _deposit(_shares, amount_, _tokenState);
    }

    // DO NOT CALL THIS METHOD UNLESS YOU ARE MAKING A DISTRIBUTION
    // ALL VALUE WILL BE DISTRIBUTED TO STAKERS EVENLY
    // depositEth distribues Eth to all stakers evenly
    // should only be called by MadBytes contract
    // any Eth sent to this method in error will be lost
    // this function will fail if the circuit breaker is tripped
    // the magic_ parameter is intended to stop some one from
    // successfully interacting with this method without first reading
    // the source code and hopefully this comment
    function depositEth(uint8 magic_) public payable withCB checkMagic(magic_) {
        _ethState = _deposit(_shares, msg.value, _ethState);
    }

    // mint allows a staking position to be opened
    // this function requires the caller to have performed
    // an approve invocation against MadBytes into this contract
    // this function will fail if the circuit breaker is tripped
    function mint(uint256 amount_) public withCB returns(uint256 tokenID) {
        return _mintNFT(msg.sender, amount_);
    }

    // mintTo allows a staking position to be opened
    // in the name of an account other than the caller
    // this method also allows a lock to be placed on the
    // position up to _maxMintLock
    // this function requires the caller to have performed
    // an approve invocation against MadBytes into this contract
    // this function will fail if the circuit breaker is tripped
    function mintTo(address to_, uint256 amount_, uint256 lockDuration_) public withCB returns(uint256 tokenID) {
        require(lockDuration_ <= _maxMintLock);
        tokenID = _mintNFT(to_, amount_);
        if (lockDuration_ > 0) {
            _lockPosition(tokenID, lockDuration_);
        }
        return tokenID;
    }

    // burn exits a staking position such that
    // all accumulated value is transferred to the owner on burn
    function burn(uint256 tokenID_) public returns(uint256 payoutEth, uint256 payoutMadToken) {
        return _burn(msg.sender, msg.sender, tokenID_);
    }

    // burnTo exits a staking position such that
    // all accumulated value is transferred to a specified
    // account on burn
    function burnTo(address to_, uint256 tokenID_) public returns(uint256 payoutEth, uint256 payoutMadToken) {
        return _burn(msg.sender, to_, tokenID_);
    }

    // collectEth returns all due Eth allocations to caller
    function collectEth(uint256 tokenID_) public returns(uint256 payout) {
        address owner = ownerOf(tokenID_);
        require(msg.sender == owner);

        // get values and update state
        (_positions[tokenID_], payout) = _collectEth(_shares, _positions[tokenID_]);

        // perform transfer and return amount paid out
        _safeTransferEth(owner, payout);
        return payout;
    }

    // collectToken returns all due MadToken allocations to caller
    function collectToken(uint256 tokenID_) public returns(uint256 payout) {
        address owner = ownerOf(tokenID_);
        require(msg.sender == owner);

        // get values and update state
        (_positions[tokenID_], payout) = _collectToken(_shares, _positions[tokenID_]);

        // perform transfer and return amount paid out
        _safeTransferERC20(_MadToken, owner, payout);
        return payout;
    }

    // _lockPosition prevents a position from being burned for duration_ number of blocks
    // by setting the freeAfter field on the Position struct
    // returns the number of shares in the locked Position so that goverance vote counting
    // may be performed when setting a lock
    function _lockPosition(uint256 tokenID_, uint256 duration_) internal returns(uint256 shares) {
        require(_exists(tokenID_));
        Position memory p = _positions[tokenID_];
        uint32 freeDur = uint32(block.number) + uint32(duration_);
        p.freeAfter = freeDur > p.freeAfter ? freeDur : p.freeAfter;
        _positions[tokenID_] = p;
        return p.shares;
    }

    // _mintNFT performs the mint operation and invokes the inheritted _mint method
    function _mintNFT(address to_, uint256 amount_) internal returns(uint256 tokenID) {
        // amount must be less than maxUInt32 - this is to allow struct packing
        // and is safe due to MadToken having a total distribution of 220M
        require(amount_ <= 2**32-1);

        // transfer the number of tokens specified by amount_ into contract
        // from the callers account
        _safeTransferFromERC20(_MadToken, msg.sender, amount_);

        // get local copy of storage vars to save gas
        uint256 shares = _shares;
        Accumulator memory ethState = _ethState;
        (ethState.accumulator, ethState.slush) = _slushSkim(shares, ethState.accumulator, ethState.slush);
        Accumulator memory tokenState = _tokenState;
        (tokenState.accumulator, tokenState.slush) = _slushSkim(shares, tokenState.accumulator, tokenState.slush);

        // get new tokeID from counter
        tokenID = _increment();

        // update storage
        _shares += amount_;
        _ethState = ethState;
        _tokenState = tokenState;
        _positions[tokenID] = Position(uint32(amount_), 1, ethState.accumulator, tokenState.accumulator);

        // invoke inheritted method and return
        ERC721._mint(to_, tokenID);
        return tokenID;
    }

    // _burn performs the burn operation and invokes the inheritted _burn method
    function _burn(address from_, address to_, uint256 tokenID_) internal returns(uint256 payoutEth, uint256 payoutToken) {
        require(from_ == ownerOf(tokenID_));

        // collect state
        Position memory p = _positions[tokenID_];
        // enforce freeAfter to prevent burn during lock
        require(p.freeAfter < block.number);

        // get copy of storage to save gas
        uint256 shares = _shares;

        // calc amounts due
        (p, payoutEth) = _collectEth(shares, p);
        (p, payoutToken) = _collectToken(shares, p);

        // debit global shares counter and delete from mapping
        _shares -= p.shares;
        delete _positions[tokenID_];

        // invoke inheritted burn method
        ERC721._burn(tokenID_);

        // transfer out all eth and tokens owed
        _safeTransferERC20(_MadToken, to_, payoutToken);
        _safeTransferEth(to_, payoutEth);
        return (payoutEth, payoutToken);
    }

     // _estimateExcessEth returns the amount of Eth that is held in the name of this
    // contract
    function _estimateExcessEth() internal view returns(uint256 excess) {
        Accumulator memory state = _ethState;
        uint256 balance = address(this).balance;
        excess = _estimateExcess(state, balance);
        return excess;
    }

    // _estimateExcessToken returns the amount of MadToken that is held in the name of this
    // contract
    function _estimateExcessToken() internal view returns(IERC20Transfer MadToken, uint256 excess) {
        Accumulator memory state = _tokenState;
        MadToken = _MadToken;
        uint256 balance = MadToken.balanceOf(address(this));
        excess = _estimateExcess(state, balance);
        return (MadToken, excess);
    }

     // _estimateExcess calculates excess value for an asset in a type agnostic manner to reduce redundant logic
    function _estimateExcess(Accumulator memory state_, uint256 balance_) internal view returns(uint256 excess) {
        uint256 shares = _shares;
        excess = balance_ - shares * state_.accumulator + state_.slush;
        return excess;
    }

    // _collectToken performs call to _collect and updates state during a request for a token distribution
    function _collectToken(uint256 shares_, Position memory p_) internal returns(Position memory p, uint256 payout) {
        (_tokenState, p, p.accumulatorEth, payout) = _collect(shares_, _tokenState, p_, p_.accumulatorToken);
        return (p, payout);
    }

    // _collectEth performs call to _collect and updates state during a request for an eth distribution
    function _collectEth(uint256 shares_, Position memory p_) internal returns(Position memory p, uint256 payout) {
        (_ethState, p, p.accumulatorEth, payout) = _collect(shares_, _ethState, p_, p_.accumulatorEth);
        return (p, payout);
    }

    // _collect performs calculations necessary to determine any distributions due to an account
    // such that it may be used for both token and eth distributions
    // this prevents the need to keep redundant logic
    function _collect(uint256 shares_, Accumulator memory state_, Position memory p_, uint256 positionAccumulatorValue_) internal pure returns(Accumulator memory, Position memory, uint256, uint256) {
        // skim slush into accumulator
        (state_.accumulator, state_.slush) = _slushSkim(shares_, state_.accumulator, state_.slush);

        // determine number of sccumulator steps this Position needs distributions from
        uint256 accumulatorDelta = state_.accumulator - positionAccumulatorValue_;

        // calculate payout based on shares held in position
        uint256 payout = accumulatorDelta * p_.shares;

        // update accumulator value for calling method
        positionAccumulatorValue_ += accumulatorDelta;

        // if there are no shares other than this position,
        // flush the slush fund into the payout
        // and update the in memory state object
        if (shares_ == p_.shares) {
            payout += state_.slush;
            state_.slush = 0;
        }
        return (state_, p_, positionAccumulatorValue_, payout);
    }

    // _deposit allows an Accumulator to be updated with new value
    // if there are no currently staked positions, all value is stored in the slush
    function _deposit(uint256 shares_, uint256 delta_, Accumulator memory state_) internal pure returns(Accumulator memory){
        state_.slush += delta_;
        if (shares_ > 0) {
            (state_.accumulator, state_.slush) = _slushSkim(shares_, state_.accumulator, state_.slush);
        }
        return state_;
    }

    // _slushSkim flushes value from the slush into the accumulator
    // if there are no currently staked positions, all value is stored in the slush
    function _slushSkim(uint256 shares_, uint256 accumulator_, uint256 slush_) internal pure returns(uint256, uint256) {
        if (shares_ > 0) {
            uint256 deltaAccumulator = 0;
            (deltaAccumulator, slush_) = _rdiv(slush_,shares_);
            accumulator_ += deltaAccumulator;
        }
        return (accumulator_, slush_);
    }

    // rdiv performs remainder division and returns floor(a,b) and a - floor(a,b)
    function _rdiv(uint256 a_, uint256 b_) internal pure returns(uint256,uint256) {
        uint256 c = (a_/b_) * b_;
        uint256 d = a_ - c;
        return (c, d);
    }

}