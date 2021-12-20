// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./utils/Admin.sol";
import "./utils/Mutex.sol";
import "./utils/MagicEthTransfer.sol";
import "./utils/EthSafeTransfer.sol";
import "./math/Sigmoid.sol";

contract MadByte is ERC20, Admin, Mutex, MagicEthTransfer, EthSafeTransfer, Sigmoid {
    /// @notice Event emitted when a deposit is received
    event DepositReceived(uint256 indexed depositID, address indexed depositor, uint256 amount);
    event DepositReceivedBN(
        uint256 indexed depositID,
        uint256 to0,
        uint256 to1,
        uint256 to2,
        uint256 to3,
        uint256 amount
    );

    // multiply factor for the selling/minting bonding curve
    uint256 constant marketSpread = 4;

    // Scaling factor to get the staking percentages
    uint256 constant madUnitOne = 1000;

    // Balance in ether that is hold in the contract after minting and burning
    uint256 _poolBalance = 0;

    // Value of the percentages that will send to each staking contract. Divide
    // this value by madUnitOne = 1000 to get the corresponding percentages.
    // These values must sum to 1000.
    uint256 _minerStakingSplit = 333;
    uint256 _madStakingSplit = 332;
    uint256 _lpStakingSplit = 332;
    uint256 _protocolFee = 3;

    // struct to define a BNAddress
    struct BNAddress {
        uint256 to0;
        uint256 to1;
        uint256 to2;
        uint256 to3;
    }

    // Monotonically increasing variable to track the MadBytes deposits.
    uint256 _depositID = 0;
    // Total amount of MadBytes that were deposited in the MadNet chain. The
    // MadBytes deposited in the Madnet are burned by this contract.
    uint256 _totalDeposited = 0;

    // Tracks the amount of each deposit. Key is deposit id, value is amount
    // deposited.
    mapping(uint256 => uint256) _deposits;
    // Tracks the owner of each deposit. Key is deposit id, value is the address
    // of the owner of a deposit.
    mapping(uint256 => address) _depositors;
    // Tracks the owner of each deposit. This mapping is required to keep track
    // of owners with BN addresses. Key is deposit id, value is the BN address
    // (4x bytes32) of owner of a deposit.
    mapping(uint256 => BNAddress) _depositorsBN;

    // Staking contracts addresses
    IMagicEthTransfer _madStaking;
    IMagicEthTransfer _minerStaking;
    IMagicEthTransfer _lpStaking;
    // Foundation contract address
    IMagicEthTransfer _foundation;

    constructor(
        address admin_,
        address madStaking_,
        address minerStaking_,
        address lpStaking_,
        address foundation_
    ) ERC20("MadByte", "MB") Admin(admin_) Mutex() {
        _madStaking = IMagicEthTransfer(madStaking_);
        _minerStaking = IMagicEthTransfer(minerStaking_);
        _lpStaking = IMagicEthTransfer(lpStaking_);
        _foundation = IMagicEthTransfer(foundation_);
    }

    /// @dev sets the miner staking contract, must only be called by _admin.
    function setMinerStaking(address minerStaking_) public onlyAdmin {
        _minerStaking = IMagicEthTransfer(minerStaking_);
    }

    /// @dev sets the staking contract, must only be called by _admin.
    function setMadStaking(address madStaking_) public onlyAdmin {
        _madStaking = IMagicEthTransfer(madStaking_);
    }

    /// @dev sets the foundation contract, must only be called by _admin.
    function setFoundation(address foundation_) public onlyAdmin {
        _foundation = IMagicEthTransfer(foundation_);
    }

    /// @dev sets the liquidity provider contract, must only be called by
    /// _admin.
    function setLPStaking(address lpStaking_) public onlyAdmin {
        _lpStaking = IMagicEthTransfer(lpStaking_);
    }

    /// @dev sets the percentage that will be divided between all the staking
    /// contracts, must only be called by _admin
    function setSplits(
        uint256 minerStakingSplit_,
        uint256 madStakingSplit_,
        uint256 lpStakingSplit_,
        uint256 protocolFee_
    ) public onlyAdmin {
        require(
            minerStakingSplit_ + madStakingSplit_ + lpStakingSplit_ + protocolFee_ == madUnitOne,
            "MadByte: All the split values must sum to madUnitOne!"
        );
        _minerStakingSplit = minerStakingSplit_;
        _madStakingSplit = madStakingSplit_;
        _lpStakingSplit = lpStakingSplit_;
        _protocolFee = protocolFee_;
    }

    /// Converts an amount of Madbytes in ether given a point in the bonding
    /// curve (poolbalance and totalsupply at given time).
    /// @param poolBalance_ The pool balance (in ether) at a given moment
    /// where we want to compute the amount of ether.
    /// @param totalSupply_ The total supply of MadBytes at a given moment
    /// where we want to compute the amount of ether.
    /// @param numMB_ Amount of Madbytes that we want to convert in ether
    function MBtoEth(
        uint256 poolBalance_,
        uint256 totalSupply_,
        uint256 numMB_
    ) public pure returns (uint256 numEth) {
        return _MBtoEth(poolBalance_, totalSupply_, numMB_);
    }

    /// Converts an amount of ether in Madbytes given a point in the bonding
    /// curve (poolbalance at given time).
    /// @param poolBalance_ The pool balance (in ether) at a given moment
    /// where we want to compute the amount of madbytes.
    /// @param numEth_ Amount of ether that we want to convert in MadBytes
    function EthtoMB(uint256 poolBalance_, uint256 numEth_) public pure returns (uint256) {
        return _EthtoMB(poolBalance_, numEth_);
    }

    /// Gets the pool balance in ether
    function getPoolBalance() public view returns (uint256) {
        return _poolBalance;
    }

    /// Gets the total amount of MadBytes that were deposited in the Madnet
    /// blockchain. Since MadBytes are burned when deposited, this value will be
    /// different from the total supply of MadBytes.
    function getTotalMadBytesDeposited() public view returns (uint256) {
        return _totalDeposited;
    }

    /// Gets the deposited amount given a depositID.
    /// @param depositID The Id of the deposit
    function getDeposit(uint256 depositID) public view returns (uint256) {
        require(depositID <= _depositID, "MadByte: Invalid deposit ID!");
        return _deposits[depositID];
    }

    /// Gets the owner of a given depositID. It returns 2 types of
    /// address. The former is in case the owner has a normal address 20 bytes
    /// long address. The later is in case the owner has a BN address (4x
    /// uint256).
    /// @param depositID The Id of the deposit
    function getDepositOwner(uint256 depositID) public view returns (address, BNAddress memory) {
        require(depositID <= _depositID, "MadByte: Invalid deposit ID!");
        return (_depositors[depositID], _depositorsBN[depositID]);
    }

    /// Distributes the yields of the MadBytes sale to all stakeholders
    /// (miners, stakers, lp stakers, foundation, etc).
    function distribute()
        public
        returns (
            uint256 minerAmount,
            uint256 stakingAmount,
            uint256 lpStakingAmount,
            uint256 foundationAmount
        )
    {
        return _distribute();
    }

    /// Deposits a MadByte amount into the MadNet blockchain. The Madbyte amount
    /// is deducted from the sender and it is burned by this contract. The
    /// created deposit Id is owned by the sender.
    /// @param amount_ The amount of Madbytes to be deposited
    /// Return The deposit ID of the deposit created
    function deposit(uint256 amount_) public returns (uint256) {
        return _deposit(msg.sender, amount_);
    }

    /// Deposits a MadByte amount into the MadNet blockchain. The Madbyte amount
    /// is deducted from the sender and it is burned by this contract. The
    /// created deposit Id is owned by the to_ address.
    /// @param to_ The address of the account that will own the deposit
    /// @param amount_ The amount of Madbytes to be deposited
    /// Return The deposit ID of the deposit created
    function depositTo(address to_, uint256 amount_) public returns (uint256) {
        return _deposit(to_, amount_);
    }

    /// Deposits a MadByte amount into the MadNet blockchain to a BN address.
    /// The Madbyte amount is deducted from the sender and it is burned by this
    /// contract. The created deposit Id is owned by the toX_ address.
    /// @param to0_ Part of the BN address
    /// @param to1_ Part of the BN address
    /// @param to2_ Part of the BN address
    /// @param to3_ Part of the BN address
    /// @param amount_ The amount of Madbytes to be deposited
    /// Return The deposit ID of the deposit created
    function depositToBN(
        uint256 to0_,
        uint256 to1_,
        uint256 to2_,
        uint256 to3_,
        uint256 amount_
    ) public returns (uint256) {
        return _depositBN(to0_, to1_, to2_, to3_, amount_);
    }

    /// Allows deposits to be minted in a virtual manner and sent to the Madnet
    /// chain by simply emitting a Deposit event without actually minting or
    /// burning any tokens, must only be called by _admin.
    /// @param to_ The address of the account that will own the deposit
    /// @param amount_ The amount of Madbytes to be deposited
    /// Return The deposit ID of the deposit created
    function virtualMintDeposit(address to_, uint256 amount_) public onlyAdmin returns (uint256) {
        return _virtualDeposit(to_, amount_);
    }

    /// Allows deposits to be minted in a virtual manner and sent to the Madnet
    /// chain by simply emitting a Deposit event without actually minting or
    /// burning any tokens. This function receives ether in the transaction and
    /// converts them into a deposit of MadBytes in the Madnet chain.
    /// This function has the same effect as calling mint (creating the
    /// tokens) + deposit (burning the tokens) functions but spending less gas.
    /// @param to_ The address of the account that will own the deposit
    /// @param minMB_ The amount of Madbytes to be deposited
    /// Return The deposit ID of the deposit created
    function mintDeposit(address to_, uint256 minMB_) public payable returns (uint256) {
        return _mintDeposit(to_, minMB_, msg.value);
    }

    /// Mints MadBytes. This function receives ether in the transaction and
    /// converts them into MadBytes using a bonding price curve.
    /// @param minMB_ Minimum amount of MadBytes that you wish to mint given an
    /// amount of ether. If its not possible to mint the desired amount with the
    /// current price in the bonding curve, the transaction is reverted. If the
    /// minMB_ is met, the whole amount of ether sent will be converted in MadBytes.
    /// Return The number of MadBytes minted
    function mint(uint256 minMB_) public payable returns (uint256 nuMB) {
        nuMB = _mint(msg.sender, msg.value, minMB_);
        return nuMB;
    }

    /// Mints MadBytes. This function receives ether in the transaction and
    /// converts them into MadBytes using a bonding price curve.
    /// @param to_ The account to where the tokens will be minted
    /// @param minMB_ Minimum amount of MadBytes that you wish to mint given an
    /// amount of ether. If its not possible to mint the desired amount with the
    /// current price in the bonding curve, the transaction is reverted. If the
    /// minMB_ is met, the whole amount of ether sent will be converted in MadBytes.
    /// Return The number of MadBytes minted
    function mintTo(address to_, uint256 minMB_) public payable returns (uint256 nuMB) {
        nuMB = _mint(to_, msg.value, minMB_);
        return nuMB;
    }

    /// Burn MadBytes. This function sends ether corresponding to the amount of
    /// Madbytes being burned using a bonding price curve.
    /// @param amount_ The amount of MadBytes being burned
    /// @param minEth_ Minimum amount ether that you expect to receive given the
    /// amount of MadBytes being burned. If the amount of MadBytes being burned
    /// worth less than this amount the transaction is reverted.
    /// Return The number of ether being received
    function burn(uint256 amount_, uint256 minEth_) public returns (uint256 numEth) {
        numEth = _burn(msg.sender, msg.sender, amount_, minEth_);
        return numEth;
    }

    /// Burn MadBytes and send the ether received to other account. This
    /// function sends ether corresponding to the amount of Madbytes being
    /// burned using a bonding price curve.
    /// @param to_ The account to where the ether from the burning will send
    /// @param amount_ The amount of MadBytes being burned
    /// @param minEth_ Minimum amount ether that you expect to receive given the
    /// amount of MadBytes being burned. If the amount of MadBytes being burned
    /// worth less than this amount the transaction is reverted.
    /// Return The number of ether being received
    function burnTo(
        address to_,
        uint256 amount_,
        uint256 minEth_
    ) public returns (uint256 numEth) {
        numEth = _burn(msg.sender, to_, amount_, minEth_);
        return numEth;
    }

    /// Distributes the yields from the MadBytes minting to all stake holders.
    function _distribute()
        internal
        withLock
        returns (
            uint256 minerAmount,
            uint256 stakingAmount,
            uint256 lpStakingAmount,
            uint256 foundationAmount
        )
    {
        // make a local copy to save gas
        uint256 poolBalance = _poolBalance;

        // find all value in excess of what is needed in pool
        uint256 excess = address(this).balance - poolBalance;

        // take out protocolFee from excess and decrement excess
        foundationAmount = (excess * _protocolFee) / madUnitOne;

        // split remaining between miners, stakers and lp stakers
        stakingAmount = (excess * _madStakingSplit) / madUnitOne;
        lpStakingAmount = (excess * _lpStakingSplit) / madUnitOne;
        // then give miners the difference of the original and the sum of the
        // stakingAmount
        minerAmount = excess - (stakingAmount + lpStakingAmount + foundationAmount);

        _safeTransferEthWithMagic(_foundation, foundationAmount);
        _safeTransferEthWithMagic(_minerStaking, minerAmount);
        _safeTransferEthWithMagic(_madStaking, stakingAmount);
        _safeTransferEthWithMagic(_lpStaking, lpStakingAmount);
        require(address(this).balance >= poolBalance);

        // invariants hold
        return (minerAmount, stakingAmount, lpStakingAmount, foundationAmount);
    }

    // Check if addr_ is EOA (Externally Owned Account) or a contract.
    function _isContract(address addr_) internal returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr_)
        }
        return size > 0;
    }

    // Burn the tokens during deposits without sending ether back to user as the
    // normal burn function. The ether will be distributed in the distribute
    // method.
    function _destroyTokens(uint256 nuMB_) internal returns (bool) {
        require(nuMB_ != 0, "MadByte: The number of MadBytes to be burn should be greater than 0!");
        _poolBalance -= _MBtoEth(_poolBalance, totalSupply(), nuMB_);
        ERC20._burn(msg.sender, nuMB_);
        return true;
    }

    // Internal function that does the deposit in the Madnet Chain, i.e emit the
    // event DepositReceived. All the Madbytes sent to this function are burned.
    function _deposit(address to_, uint256 amount_) internal returns (uint256) {
        require(!_isContract(to_), "MadByte: Contracts cannot make MadBytes deposits!");
        require(amount_ > 0, "MadByte: The deposit amount must be greater than zero!");
        require(_destroyTokens(amount_), "MadByte: Burn failed during the deposit!");
        // copying state to save gas
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositors[depositID] = to_;
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceived(depositID, to_, amount_);
        return depositID;
    }

    // Internal function that does the deposit in the Madnet Chain for user
    // using BN addresses, i.e emit the event DepositReceivedBN. All the
    // Madbytes sent to this function are burned.
    function _depositBN(
        uint256 to0_,
        uint256 to1_,
        uint256 to2_,
        uint256 to3_,
        uint256 amount_
    ) internal returns (uint256) {
        require(amount_ > 0, "MadByte: The deposit amount must be greater than zero!");
        require(_destroyTokens(amount_), "MadByte: Transfer failed!");
        // copying state to save gas
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositorsBN[depositID] = BNAddress(to0_, to1_, to2_, to3_);
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceivedBN(depositID, to0_, to1_, to2_, to3_, amount_);
        return depositID;
    }

    // does a virtual deposit into the Madnet Chain without actually minting or
    // burning any token.
    function _virtualDeposit(address to_, uint256 amount_) internal returns (uint256) {
        require(!_isContract(to_), "MadByte: Contracts cannot make MadBytes deposits!");
        require(amount_ > 0, "MadByte: The deposit amount must be greater than zero!");
        // copying state to save gas
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositors[depositID] = to_;
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceived(depositID, to_, amount_);
        return depositID;
    }

    // Mints a virtual deposit into the Madnet Chain without actually minting or
    // burning any token. This function converts ether sent in Madbytes.
    function _mintDeposit(
        address to_,
        uint256 minMB_,
        uint256 numEth_
    ) internal returns (uint256) {
        require(!_isContract(to_), "MadByte: Contracts cannot make MadBytes deposits!");
        require(numEth_ >= marketSpread, "MadByte: requires at least 4 WEI");
        numEth_ = numEth_ / marketSpread;
        uint256 amount_ = _EthtoMB(_poolBalance, numEth_);
        require(
            amount_ >= minMB_,
            "MadByte: could not mint deposit with minimum MadBytes given the ether sent!"
        );
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositors[depositID] = to_;
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceived(depositID, to_, amount_);
        return depositID;
    }

    // Internal function that mints the MadByte tokens following the bounding
    // price curve.
    function _mint(
        address to_,
        uint256 numEth_,
        uint256 minMB_
    ) internal returns (uint256 nuMB) {
        require(numEth_ >= marketSpread, "MadByte: requires at least 4 WEI");
        numEth_ = numEth_ / marketSpread;
        uint256 poolBalance = _poolBalance;
        nuMB = _EthtoMB(poolBalance, numEth_);
        require(nuMB >= minMB_, "MadByte: could not mint minimum MadBytes");
        poolBalance += numEth_;
        _poolBalance = poolBalance;
        ERC20._mint(to_, nuMB);
        return nuMB;
    }

    // Internal function that burns the MadByte tokens following the bounding
    // price curve.
    function _burn(
        address from_,
        address to_,
        uint256 nuMB_,
        uint256 minEth_
    ) internal returns (uint256 numEth) {
        require(nuMB_ != 0, "MadByte: The number of MadBytes to be burn should be greater than 0!");
        uint256 poolBalance = _poolBalance;
        numEth = _MBtoEth(poolBalance, totalSupply(), nuMB_);
        require(numEth >= minEth_, "MadByte: Couldn't burn the minEth amount");
        poolBalance -= numEth;
        _poolBalance = poolBalance;
        ERC20._burn(from_, nuMB_);
        _safeTransferEth(to_, numEth);
        return numEth;
    }

    // Internal function that converts an ether amount into MadByte tokens
    // following the bounding price curve.
    function _EthtoMB(uint256 poolBalance_, uint256 numEth_) internal pure returns (uint256) {
        return _fx(poolBalance_ + numEth_) - _fx(poolBalance_);
    }

    // Internal function that converts a MadByte amount into ether following the
    // bounding price curve.
    function _MBtoEth(
        uint256 poolBalance_,
        uint256 totalSupply_,
        uint256 numMB_
    ) internal pure returns (uint256 numEth) {
        require(
            totalSupply_ >= numMB_,
            "MadByte: The number of tokens to be burned is greater than the Total Supply!"
        );
        return _min(poolBalance_, _fp(totalSupply_) - _fp(totalSupply_ - numMB_));
    }
}
