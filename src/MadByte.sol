// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;

//import "./lib/openzeppelin/token/ERC721/ERC721.sol";
import "./lib/openzeppelin/token/ERC20/ERC20.sol";
import "./Admin.sol";
import "./Mutex.sol";
import "./MagicEthTransfer.sol";
import "./EthSafeTransfer.sol";
import "./Sigmoid.sol";


contract MadByte is ERC20, Admin, Mutex, MagicEthTransfer, EthSafeTransfer, Sigmoid {

    uint256 constant marketSpread = 4;
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
        _safeTransferEthWithMagic(_foundation, foundationAmount);
        _safeTransferEthWithMagic(_minerStaking, minerAmount);
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

    function getPoolBalance() public view returns(uint256) {
        return _poolBalance;
    }

    function _EthtoMB(uint256 poolBalance_, uint256 numEth_) internal pure returns(uint256) {
      return _fx(poolBalance_ + numEth_) - _fx(poolBalance_);
    }

     // function _MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) internal pure returns(uint256 numEth) {
    //   require(totalSupply_ >= numMB_, "MadByte: The number of tokens to be burned is greater than the Total Supply!");
    //   //numEth = _min(_fp(totalSupply) - _fp(totalSupply_ - numMB_), poolBalance_);
    //   numEth = _min(_fp(totalSupply_) - _fp(totalSupply_ - numMB_), poolBalance_);
    //   return numEth;
    // }

    /*
    uint256 newPoolBalance = poolBalance_ - numEth_;
    uint256 expectedMBs = _EthtoMB(newPoolBalance, numEth_);
    log("newPoolBalance", newPoolBalance);
    log("expectedMBs", expectedMBs);

    if (expectedMBs < numMB_) {
        uint256 diff = numMB_ - expectedMBs;
        log("expectedMBs < numMB_ by:", diff);
    } else {
        uint256 diff = expectedMBs - numMB_;
        log("expectedMBs >= numMB_ by:", diff);
    }

    */

    function _MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) internal returns(uint256) {
        require(totalSupply_ >= numMB_, "MadByte: The number of tokens to be burned is greater than the Total Supply!");
        require(numMB_ <= totalSupply_, "MadByte: Cannot burn more than total supply");

        log("entering", 1);
        uint256 numEth_ = _fp(totalSupply_) - _fp(totalSupply_ - numMB_);

        // DEBUG!
        {
            uint256 newPoolBalance = poolBalance_ - numEth_;
            uint256 expectedMBs = _EthtoMB(newPoolBalance, numEth_);
            log("newPoolBalance", newPoolBalance);
            log("expectedMBs", expectedMBs);

            if (expectedMBs < numMB_) {
                uint256 diff = numMB_ - expectedMBs;
                log("expectedMBs < numMB_ by:", diff);
            } else {
                uint256 diff = expectedMBs - numMB_;
                log("expectedMBs >= numMB_ by:", diff);
            }
        }
        // DEBUG!

        log("entering", 2);
        if (numEth_ > poolBalance_) {
            numEth_ = poolBalance_;
        }
        uint256 tempMB_ = _fx(poolBalance_) - _fx(poolBalance_ - numEth_);

        log("poolBalance_", poolBalance_);
        log("totalSupply_", totalSupply_);
        log("numMB_", numMB_);
        log("numEth_", numEth_);
        log("tempMB_", tempMB_);

        if (tempMB_ > numMB_) {
            log("entering (tempMB_ > numMB_)", 1);
            
            uint256 diff = tempMB_ - numMB_;
            log("diff", diff);
            //if (2*diff > numMB_) {
            //    numMB_ = 2*diff;
            //}
            if (2*diff > numMB_) {
                if (diff > numMB_) {
                    if (diff/2 > numMB_) {
                        numMB_ = numMB_;
                    } else {
                        numMB_ -= diff/2; 
                    }
                } else {
                    numMB_ -= diff; 
                }
            } else {
                numMB_ -= 2*diff;
            }
            log("numMB_2", numMB_);
            numEth_ = _fp(totalSupply_) - _fp(totalSupply_ - numMB_);
            return _min(numEth_+1, poolBalance_);
        }
        //uint256 numEth = _min(_fp(totalSupply_) - _fp(totalSupply_ - tempMB_), poolBalance_);
    //   uint256 error_ = _safeAbsSub(numEth_, numEth);
    //   numEth_ -= error_ * 2;
        return _min(numEth_, poolBalance_);
    }

    function _computeError(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) internal pure returns(uint256 errorMB_, uint256 numEth_) {
        numEth_ = _fp(totalSupply_) - _fp(totalSupply_ - numMB_);
        uint256 tempMB_ = _fx(poolBalance_ - numEth_);
        errorMB_ = _safeAbsSub(tempMB_, totalSupply_ - numMB_);
    }

    /* function _MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) internal pure returns(uint256 numEth_) {
        require(totalSupply_ >= numMB_, "MadByte: The number of tokens to be burned is greater than the Total Supply!");
        uint256 tempNumMB = numMB_;
        for (uint256 i=0 ; i<10 ; i++) {
            uint256 xMax = 2* tempNumMB;
            uint256 xMin = tempNumMB /2;
            uint256 xMid = (xMax - xMin)/2;
            (uint256 errorMax_, uint256 numETHMax) = _computeError(poolBalance_, totalSupply_, xMax);
            (uint256 errorMin_, uint256 numETHMin) = _computeError(poolBalance_, totalSupply_, xMin);
            (uint256 errorMid_, uint256 numETHMid) = _computeError(poolBalance_, totalSupply_, xMid);
            if (errorMax_ == 0) {
                return numETHMax;
            }
            if (errorMin_ == 0) {
                return numETHMin;
            }
            if (errorMid_ == 0) {
                return numETHMid;
            }
            if (errorMax_ < errorMin_ && errorMax_ < errorMid_) {
                tempNumMB = xMax;
            } else if (errorMin_ <= errorMid_ && errorMin_ <= errorMax_) {
                tempNumMB = xMin;
            } else {
                tempNumMB = xMid;
            } 
        }

    //     while True:
    // xMax = int(x_*2)
    // xMin = int(x_*.5)
    // xMid = (xMax-xMin)//2 + xMin
    // sUpper = fx(xMax)
    // sMid = fx(xMid)
    // sLower = fx(xMin)
    // if sLower >= minv:
    //     x_ = xMin//2
    // elif sMid >= minv:
    //     x_ = (xMid-xMin)//2+xMin
    // elif sUpper >= minv:
    //     x_ = (xMax-xMid)//2+xMid
    // else:
    //     x_ = xMax*2
    // minvNew = max(min([sUpper,sLower,minv]),0)
    // if xMid == xMax or xMin == xMid or xMin == xMax or x_ < 3:
    //     minv=minvNew
    //     print(x_, fx(x_), fp(fx(x_)), x_/fp(fx(x_)))
    //     break
    // minv = minvNew
    // xa.append(x_)
    // y0.append(fx(x_))
    // y1.append(fp(fx(x_))) 
    // y2.append(x_/fp(fx(x_)))
    // printF(x_)
        
        //   uint256 numEth = _min(_fp(totalSupply_) - _fp(totalSupply_ - tempMB_), poolBalance_);
        //   uint256 error_ = _safeAbsSub(numEth_, numEth);
        //   numEth_ -= error_ * 2;
        return numEth_;
    } */



    // function _MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) internal pure returns(uint256 numEth) {
    //   require(totalSupply_ >= numMB_, "MadByte: The number of tokens to be burned is greater than the Total Supply!");
    //   //numEth = _min(_fp(totalSupply) - _fp(totalSupply_ - numMB_), poolBalance_);
    //   numEth = _min(_fp(totalSupply_) - _fp(totalSupply_ - numMB_), poolBalance_);
    //   return numEth;
    // }

    function MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) public returns(uint256 numEth) {
      return _MBtoEth(poolBalance_, totalSupply_, numMB_);
    }

    function EthtoMB(uint256 poolBalance_, uint256 numEth_) public pure returns(uint256) {
      return _EthtoMB(poolBalance_, numEth_);
    }

    event log_named_uint(string key, uint256 val);
    
    function log(string memory name, uint256 value) internal{
        emit log_named_uint(name, value);
    }
}
