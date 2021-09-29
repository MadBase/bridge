// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.0;


abstract contract Sigmoid {
    function _fx(uint256 x) internal pure returns(uint256) {
      return 510*x + 707106781186547515392000 - 500*_sqrt(_safeAbsSub(1000000000000000000000,x)**2 + 999999999999999949038280487211713907654656);
    }

    function _fp(uint256 p) internal pure returns(uint256) {
      return (51*p + 50*_sqrt(p**2 + 1491448916810278452444696754723766787380976025600 - 2434213562373095030784000*p) - 61062445840513923284992000)/ 1010;
    }

    function _safeAbsSub(uint256 a, uint256 b) internal pure returns(uint256) {
      return _max(a,b)- _min(a,b);
    }

    function _min(uint256 a_, uint256 b_) internal pure returns(uint256) {
      if (a_ <= b_) {
        return a_;
      }
      return b_;
    }

    function _max(uint256 a_, uint256 b_) internal pure returns(uint256) {
      if (a_ >= b_) {
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