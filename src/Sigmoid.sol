// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.7.6;


abstract contract Sigmoid {
    // constants of the sigmoid function
    uint256 constant a = 500;
    uint256 constant b = 3*10**21;
    uint256 constant c = 10**42;
    uint256 constant C1 =  1_581_138_830_084_189_665_999_000; // a*(sqrt(b**2 + c));
    uint256 constant C2 = 40_569_415_042_094_832_999_500_000; // a*C1 - a**2*b;
    uint256 constant C3 =      3_162_277_660_168_379_331_998; // (sqrt(b**2 + c);
    
    // _fx is the integral of the sigmoidal price function
    // this function calculates the amount of eth that should
    // be in the pool for a given totalSupply
    function _fx(uint256 x_) internal pure returns(uint256) {
      uint256 tmp0 = 0; 
      // (b - x)**2 + c) == (x - b)**2 + c)
      if (b > x_) {
        tmp0 = (b - x_)**2 + c;
      } else {
        tmp0 = (x_ - b)**2 + c;
      }
      tmp0 = a * (_sqrt(tmp0) + x_);
      // breaks down at approx 2**128
      // input to this method is Eth, so this should not be a
      // concern - there is only ~100M Eth at this time and 
      // the rate of generation means the system will be at a
      // stable price for a very long time before this limit
      // is reached. Thus, if the problem ever does occur, 
      // we can migrate the equations smoothly with no impact
      // on system operation.
      return tmp0 - C1;
    }
    
    // _fp is the solution for x of the function defined in fx
    // this function calculates the amount of mb that should
    // be in the totalSupply for a given balance in the pool
    function _fp(uint256 p_) internal pure returns(uint256) {
      uint256 n = (p_**2)/2 + p_*C1;
      uint256 d = C2 + a*p_;
      return n/d;
    }
    
    function _min(uint256 a_, uint256 b_) internal pure returns(uint256) {
      if (a_ <= b_) {
        return a_;
      }
      return b_;
    }
    
    function _sqrt(uint256 y_) internal pure returns(uint256 z) {
        z=0;
        if (y_ > 3) {
            z = y_;
            uint256 x = y_ / 2 + 1;
            while (x < z) {
                z = x;
                x = (y_ / x + x) / 2;
            }
        } else if (y_ != 0) {
            z = 1;   
        }
        return z;
    }
    
}