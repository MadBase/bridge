
// SPDX-License-Identifier: MIT-open-group
pragma solidity 0.8.11;

import "./DeterministicAddress.sol";

abstract contract immutableFactory is DeterministicAddress {

    address private immutable _factory;

    constructor(address factory_) {
        _factory = factory_;
    }

    modifier onlyFactory() {
        require(msg.sender == _factory);
        _;
    }

    function _factoryAddress() internal returns(address) {
        return _factory;
    }

}


abstract contract immutableValidatorNFT is immutableFactory {
    
    address private immutable _ValidatorNFT;

    constructor() {
        _ValidatorNFT = getMetamorphicContractAddress(0x56616c696461746f724e46540000000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyValidatorNFT() {
        require(msg.sender == _ValidatorNFT);
        _;
    }

    function _ValidatorNFTAddress() internal view returns(address) {
        return _ValidatorNFT;
    }

    function _saltForValidatorNFT() internal pure returns(bytes32) {
        return 0x56616c696461746f724e46540000000000000000000000000000000000000000;
    }
    
}



abstract contract immutableMadToken is immutableFactory {
    
    address private immutable _MadToken;

    constructor() {
        _MadToken = getMetamorphicContractAddress(0x4d6164546f6b656e000000000000000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyMadToken() {
        require(msg.sender == _MadToken);
        _;
    }

    function _MadTokenAddress() internal view returns(address) {
        return _MadToken;
    }

    function _saltForMadToken() internal pure returns(bytes32) {
        return 0x4d6164546f6b656e000000000000000000000000000000000000000000000000;
    }
    
}



abstract contract immutableStakeNFT is immutableFactory {
    
    address private immutable _StakeNFT;

    constructor() {
        _StakeNFT = getMetamorphicContractAddress(0x5374616b654e4654000000000000000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyStakeNFT() {
        require(msg.sender == _StakeNFT);
        _;
    }

    function _StakeNFTAddress() internal view returns(address) {
        return _StakeNFT;
    }

    function _saltForStakeNFT() internal pure returns(bytes32) {
        return 0x5374616b654e4654000000000000000000000000000000000000000000000000;
    }
    
}



abstract contract immutableMadByte is immutableFactory {
    
    address private immutable _MadByte;

    constructor() {
        _MadByte = getMetamorphicContractAddress(0x4d61644279746500000000000000000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyMadByte() {
        require(msg.sender == _MadByte);
        _;
    }

    function _MadByteAddress() internal view returns(address) {
        return _MadByte;
    }

    function _saltForMadByte() internal pure returns(bytes32) {
        return 0x4d61644279746500000000000000000000000000000000000000000000000000;
    }
    
}



abstract contract immutableGovernance is immutableFactory {
    
    address private immutable _Governance;

    constructor() {
        _Governance = getMetamorphicContractAddress(0x476f7665726e616e636500000000000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyGovernance() {
        require(msg.sender == _Governance);
        _;
    }

    function _GovernanceAddress() internal view returns(address) {
        return _Governance;
    }

    function _saltForGovernance() internal pure returns(bytes32) {
        return 0x476f7665726e616e636500000000000000000000000000000000000000000000;
    }
    
}



abstract contract immutableValidatorPool is immutableFactory {
    
    address private immutable _ValidatorPool;

    constructor() {
        _ValidatorPool = getMetamorphicContractAddress(0x56616c696461746f72506f6f6c00000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyValidatorPool() {
        require(msg.sender == _ValidatorPool);
        _;
    }

    function _ValidatorPoolAddress() internal view returns(address) {
        return _ValidatorPool;
    }

    function _saltForValidatorPool() internal pure returns(bytes32) {
        return 0x56616c696461746f72506f6f6c00000000000000000000000000000000000000;
    }
    
}



abstract contract immutableETHDKG is immutableFactory {
    
    address private immutable _ETHDKG;

    constructor() {
        _ETHDKG = getMetamorphicContractAddress(0x455448444b470000000000000000000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyETHDKG() {
        require(msg.sender == _ETHDKG);
        _;
    }

    function _ETHDKGAddress() internal view returns(address) {
        return _ETHDKG;
    }

    function _saltForETHDKG() internal pure returns(bytes32) {
        return 0x455448444b470000000000000000000000000000000000000000000000000000;
    }
    
}



abstract contract immutableETHDKGAccusations is immutableFactory {
    
    address private immutable _ETHDKGAccusations;

    constructor() {
        _ETHDKGAccusations = getMetamorphicContractAddress(0x455448444b4741636375736174696f6e73000000000000000000000000000000, _factoryAddress());
    }

    modifier onlyETHDKGAccusations() {
        require(msg.sender == _ETHDKGAccusations);
        _;
    }

    function _ETHDKGAccusationsAddress() internal view returns(address) {
        return _ETHDKGAccusations;
    }

    function _saltForETHDKGAccusations() internal pure returns(bytes32) {
        return 0x455448444b4741636375736174696f6e73000000000000000000000000000000;
    }
    
}



abstract contract immutableSnapshots is immutableFactory {
    
    address private immutable _Snapshots;

    constructor() {
        _Snapshots = getMetamorphicContractAddress(0x536e617073686f74730000000000000000000000000000000000000000000000, _factoryAddress());
    }

    modifier onlySnapshots() {
        require(msg.sender == _Snapshots);
        _;
    }

    function _SnapshotsAddress() internal view returns(address) {
        return _Snapshots;
    }

    function _saltForSnapshots() internal pure returns(bytes32) {
        return 0x536e617073686f74730000000000000000000000000000000000000000000000;
    }
    
}


