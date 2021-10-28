// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

import "./lib/openzeppelin/token/ERC20/ERC20.sol";
import "./Admin.sol";
import "./Mutex.sol";
import "./MagicEthTransfer.sol";
import "./EthSafeTransfer.sol";
import "./Sigmoid.sol";


contract MadByte is ERC20, Admin, Mutex, MagicEthTransfer, EthSafeTransfer, Sigmoid {

    /// @notice Event emitted when a deposit is received
    event DepositReceived(uint256 indexed depositID, address indexed depositor, uint256 amount);
    event DepositReceivedBN(uint256 indexed depositID, bytes32 to0, bytes32 to1, bytes32 to2, bytes32 to3, uint256 amount);

    uint256 constant marketSpread = 4;
    uint256 constant madUnitOne = 1000;
    uint256 constant protocolFee = 3;

    uint256 _poolBalance = 0;
    uint256 _minerSplit = 500;

    struct BNAddress {
        bytes32 to0;
        bytes32 to1;
        bytes32 to2;
        bytes32 to3;
    }

    // Monotonically increasing variable to track the MadBytes deposits.
    uint256 _depositID;
    // Total amount of MadBytes that were deposited in this contract.
    uint256 _totalDeposited;

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

    IMagicEthTransfer _madStaking;
    IMagicEthTransfer _minerStaking;
    IMagicEthTransfer _foundation;

    constructor(address admin_, address madStaking_, address minerStaking_, address foundation_) ERC20("MadByte", "MB") Admin(admin_) Mutex() {
        _madStaking = IMagicEthTransfer(madStaking_);
        _minerStaking = IMagicEthTransfer(minerStaking_);
        _foundation = IMagicEthTransfer(foundation_);
    }

    function setMinerStaking(address minerStaking_) public onlyAdmin {
        _minerStaking = IMagicEthTransfer(minerStaking_);
    }

    function setMadStaking(address madStaking_) public onlyAdmin {
        _madStaking = IMagicEthTransfer(madStaking_);
    }

    function setFoundation(address foundation_) public onlyAdmin {
        _foundation = IMagicEthTransfer(foundation_);
    }

    function setMinerSplit(uint256 split_) public onlyAdmin {
        require(split_ < madUnitOne, "MadByte: The split value should be less than the madUnitOne!");
        _minerSplit = split_;
    }

    function MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) public pure returns(uint256 numEth) {
      return _MBtoEth(poolBalance_, totalSupply_, numMB_);
    }

    function EthtoMB(uint256 poolBalance_, uint256 numEth_) public pure returns(uint256) {
      return _EthtoMB(poolBalance_, numEth_);
    }

    function getPoolBalance() public view returns(uint256) {
        return _poolBalance;
    }

    function getTotalMadBytesDeposited() public view returns(uint256) {
        return _totalDeposited;
    }

    function getDeposit(uint256 depositID) public view returns(uint256) {
        require(depositID <= _depositID, "MadByte: Invalid deposit ID!");
        return _deposits[depositID];
    }

    function getDepositOwner(uint256 depositID) public view returns(address, BNAddress memory) {
        require(depositID <= _depositID, "MadByte: Invalid deposit ID!");
        return (_depositors[depositID], _depositorsBN[depositID]);
    }

    function distribute() public returns(uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) {
        return _distribute();
    }

    function deposit(uint256 amount_) public returns (bool) {
        return _deposit(msg.sender, amount_);
    }

    function depositTo(address to_, uint256 amount_) public returns (bool) {
        return _deposit(to_, amount_);
    }

    function depositToBN(bytes32 to0_, bytes32 to1_, bytes32 to2_, bytes32 to3_, uint256 amount_) public returns (bool) {
        return _depositBN(to0_, to1_, to2_, to3_, amount_);
    }

    function virtualMintDeposit(address to_, uint256 amount_) public onlyAdmin returns (bool) {
        return _virtualDeposit(to_, amount_);
    }

    function mintDeposit(address to_, uint256 amountMin_) public payable returns (bool) {
        return _mintDeposit(to_, amountMin_, msg.value);
    }

    function mint(uint256 minMB_) public payable returns(uint256 nuMB) {
        nuMB = _mint(msg.sender, msg.value, minMB_);
        return nuMB;
    }

    function mintTo(address to_, uint256 minMB_) public payable returns(uint256 nuMB) {
        nuMB = _mint(to_, msg.value, minMB_);
        return nuMB;
    }

    function burn(uint256 amount_, uint256 minEth_) public returns(uint256 numEth) {
        numEth = _burn(msg.sender, msg.sender, amount_, minEth_);
        return numEth;
    }

    function burnTo(address to_, uint256 amount_, uint256 minEth_) public returns(uint256 numEth) {
        numEth = _burn(msg.sender, to_,  amount_, minEth_);
        return numEth;
    }

    function _distribute() internal withLock returns(uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) {
        // make a local copy to save gas
        uint256 poolBalance = _poolBalance;

        // find all value in excess of what is needed in pool
        uint256 excess = address(this).balance - poolBalance;

        // take out protocolFee from excess and decrement excess
        foundationAmount = (excess * protocolFee)/madUnitOne;
        excess -= foundationAmount;

        // split remaining between miners and stakers
        // first take out the miner cut but pass floor division
        // losses into stakers
        stakingAmount = excess - (excess * _minerSplit)/madUnitOne;
        // then give miners the difference of the original and the
        // stakingAmount
        minerAmount = excess - stakingAmount;

        _safeTransferEthWithMagic(_foundation, foundationAmount);
        _safeTransferEthWithMagic(_minerStaking, minerAmount);
        _safeTransferEthWithMagic(_madStaking, stakingAmount);
        require(address(this).balance >= poolBalance);

        // invariants hold
        return (foundationAmount, minerAmount, stakingAmount);
    }

    function _isContract(address addr_) internal returns (bool) {
        uint256 size;
        assembly{
            size := extcodesize(addr_)
        }
        return size > 0;
    }

    function _deposit(address to_, uint256 amount_) internal returns (bool) {
        require(!_isContract(to_), "MadByte: Contracts cannot make MadBytes deposits!");
        require(transferFrom(msg.sender, address(this), amount_), "MadByte: Transfer failed!");
        // copying state to save gas
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositors[depositID] = to_;
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceived(depositID, to_, amount_);
        return true;
    }

    function _depositBN(bytes32 to0_, bytes32 to1_, bytes32 to2_, bytes32 to3_, uint256 amount_) internal returns (bool) {
        require(transferFrom(msg.sender, address(this), amount_), "MadByte: Transfer failed!");
        // copying state to save gas
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositorsBN[depositID] = BNAddress(to0_, to1_, to2_, to3_);
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceivedBN(depositID, to0_, to1_, to2_, to3_, amount_);
        return true;
    }

    function _virtualDeposit(address to_, uint256 amount_) internal returns (bool) {
        require(!_isContract(to_), "MadByte: Contracts cannot make MadBytes deposits!");
        // copying state to save gas
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositors[depositID] = to_;
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceived(depositID, to_, amount_);
        return true;
    }

    function _mintDeposit(address to_, uint256 minMB_, uint256 numEth_) internal returns (bool) {
        require(!_isContract(to_), "MadByte: Contracts cannot make MadBytes deposits!");
        require(numEth_ >= marketSpread, "MadByte: requires at least 4 WEI");
        numEth_ = numEth_/marketSpread;
        uint256 amount_ = _EthtoMB(_poolBalance, numEth_);
        require(amount_ >= minMB_, "MadByte: could not mint deposit with minimum MadBytes given the ether sent!");
        uint256 depositID = _depositID + 1;
        _deposits[depositID] = amount_;
        _depositors[depositID] = to_;
        _totalDeposited += amount_;
        _depositID = depositID;
        emit DepositReceived(depositID, to_, amount_);
        return true;
    }

    function _mint(address to_, uint256 numEth_, uint256 minMB_) internal returns(uint256 nuMB) {
        require(numEth_ >= marketSpread, "MadByte: requires at least 4 WEI");
        numEth_ = numEth_/marketSpread;
        uint256 poolBalance = _poolBalance;
        nuMB = _EthtoMB(poolBalance, numEth_);
        require(nuMB >= minMB_, "MadByte: could not mint minimum MadBytes");
        poolBalance += numEth_;
        _poolBalance = poolBalance;
        ERC20._mint(to_, nuMB);
        return nuMB;
    }

    function _burn(address from_,  address to_, uint256 nuMB_,  uint256 minEth_) internal returns(uint256 numEth) {
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

    function _EthtoMB(uint256 poolBalance_, uint256 numEth_) internal pure returns(uint256) {
      return _fx(poolBalance_ + numEth_) - _fx(poolBalance_);
    }

    function _MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) internal pure returns(uint256 numEth) {
      require(totalSupply_ >= numMB_, "MadByte: The number of tokens to be burned is greater than the Total Supply!");
      return _min(poolBalance_, _fp(totalSupply_) - _fp(totalSupply_ - numMB_));
    }
}
