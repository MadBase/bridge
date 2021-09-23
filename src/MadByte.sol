// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.7.6;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "./Admin.sol";
import "./Mutex.sol";
import "./MagicEthTransfer.sol";
import "./EthSafeTransfer.sol";
import "./Sigmoid.sol";


contract MadByte is ERC20, Admin, Mutex, MagicEthTransfer, EthSafeTransfer, Sigmoid {
    
    uint256 constant marketSpread = 3;
    uint256 constant madUnitOne = 1000;
    uint256 constant protocolFee = 3;
    
    uint256 _poolBalance = 0;
    uint256 _minerSplit = 500;
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
        require(split_ < madUnitOne);
        _minerSplit = split_;
    }
    
    function distribute() public returns(uint256 foundationAmount, uint256 minerAmount, uint256 stakingAmount) {
        return _distribute();
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
        
        // send out payout in super paranoid manner
        require(address(this).balance >= poolBalance + foundationAmount + minerAmount + stakingAmount);
        _safeTransferEthWithMagic(_foundation, foundationAmount);
        require(address(this).balance >= poolBalance + minerAmount + stakingAmount);
        _safeTransferEthWithMagic(_minerStaking, minerAmount);
        require(address(this).balance >= poolBalance + stakingAmount);
        _safeTransferEthWithMagic(_madStaking, stakingAmount);
        require(address(this).balance >= poolBalance);
        
        // invariants hold
        return (foundationAmount, minerAmount, stakingAmount);
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
    
    function _mint(address to_, uint256 numEth_, uint256 minMB_) internal returns(uint256 nuMB) {
        require(numEth_ >= 3, "MadByte: requires at least 3 WEI");
        numEth_ = numEth_/marketSpread;
        uint256 poolBalance = _poolBalance;
        nuMB = _EthtoMB(_poolBalance, numEth_);
        require(nuMB >= minMB_, "MadByte: could not mint minimum MadBytes");
        poolBalance += numEth_;
        _poolBalance = poolBalance;
        ERC20._mint(to_, nuMB);
        return nuMB;
    }
    
    function _burn(address from_,  address to_, uint256 nuMB_,  uint256 minEth_) internal returns(uint256 numEth) {
        require(nuMB_ != 0);
        uint256 poolBalance = _poolBalance;
        numEth = _MBtoEth(poolBalance, nuMB_);
        require(numEth >= minEth_);
        poolBalance -= numEth;
        _poolBalance = poolBalance;
        ERC20._burn(from_, nuMB_);
        _safeTransferEth(to_, numEth);
        return numEth;
    }
    
    function _EthtoMB(uint256 poolBalance_, uint256 numEth_) internal pure returns(uint256) {
      return _fx(poolBalance_ + numEth_) - _fx(poolBalance_);
    }
    
    function _MBtoEth(uint256 poolBalance_, uint256 numMB_) internal view returns(uint256 numEth) {
      uint256 totalSupply = totalSupply();
      require(totalSupply >= numMB_);
      numEth = _min(_fp(totalSupply) - _fp(totalSupply - numMB_), poolBalance_);
      return numEth;
    }
}
