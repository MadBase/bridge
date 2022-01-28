// SPDX-License-Identifier: MIT-open-group
pragma solidity 0.8.11;

import "./interfaces/IValidatorPool.sol";
import "./interfaces/IDutchAuction.sol";
import "../ethdkg/interfaces/IETHDKG.sol";

contract DutchAuction is IDutchAuction {
    address internal _admin;
    IValidatorPool internal _validatorPool;
    IETHDKG internal _ethdkg;
    uint256 internal _auctionBasePrice;
    uint256 internal _auctionDecayRate;
    uint256 internal _auctionStartBlock;
    uint256 internal _auctionPhaseLength;

    bool internal _urgentMode;

    constructor(
        IValidatorPool validatorPool,
        IETHDKG ethdkg,
        bytes memory hook
    ) {
        //auction parameters
        _auctionDecayRate = 1;
        _auctionBasePrice = 1 ether;
        _auctionStartBlock = 0;
        _urgentMode = false;
        _validatorPool = validatorPool;
        _ethdkg = ethdkg;
        _auctionPhaseLength = _ethdkg.getPhaseLength();
        //todo: replace this with a access control abstract contract
        _admin = msg.sender;
    }

    modifier onlyValidatorPool() {
        require(msg.sender == address(_validatorPool), "DutchAuction: Only validatorPool allowed!");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "ValidatorsPool: Requires admin privileges");
        _;
    }

    function setAuctionDecayRate(uint256 decayRate) public onlyAdmin {
        require(decayRate > 0, "ValidatorPool: Decay rate should be greater than 0!");
        _auctionDecayRate = decayRate;
    }

    function setAuctionPhaseLength(uint256 phaseLength) public onlyAdmin {
        require(phaseLength > 0, "ValidatorPool: Phase length should be greater than 0!");
        _auctionPhaseLength = phaseLength;
    }

    function setAuctionBasePrice(uint256 basePrice) public onlyAdmin {
        _auctionBasePrice = basePrice;
    }
    function startAuction() public onlyValidatorPool {
        _startAuction();
    }

    function getAuctionPrice() public view returns (uint256) {
        return _getAuctionPrice();
    }

    function getAuctionPhaseLength() public view returns(uint256) {
        return _auctionPhaseLength;
    }

    function getAuctionStartBlock() public view returns(uint256) {
        return _auctionStartBlock;
    }

    function getAuctionEndBlock() public view returns(uint256) {
        return _auctionStartBlock + _auctionPhaseLength;
    }

    function isAuctionRunning() public view returns (bool) {
        return _isAuctionRunning();
    }

    function _startAuction() internal {
        _urgentMode = _validatorPool.getValidatorsCount() < _ethdkg.getMinValidators();
        _auctionStartBlock = block.number;
        emit AuctionStarted(block.number);
    }

    function _isAuctionRunning() internal view returns (bool) {
        return
            block.number >= _auctionStartBlock &&
            block.number < _auctionStartBlock + _auctionPhaseLength;
    }

    function _getAuctionPrice() internal view returns (uint256) {
        if (_urgentMode) {
            return 0;
        }
        //todo: Get a good math function to rule the decay
        uint256 elapsedTime = block.number - _auctionStartBlock;
        //+1 to avoid elapsedTime equals 0
        uint256 decay = elapsedTime * (1000000 / _auctionDecayRate) + 1;
        return _auctionBasePrice / decay;
    }
}
