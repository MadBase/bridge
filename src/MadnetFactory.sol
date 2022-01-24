// SPDX-License-Identifier: MIT-open-group
pragma solidity  ^0.8.11;
import "../lib/utils/DeterministicAddress.sol";
import "./Proxy.sol";

interface MadnetFacInterface {
    function deploy(address _implementation, bytes32 _salt, bytes calldata _initCallData) external payable returns (address contractAddr);
}

contract MadnetFactory is DeterministicAddress, ProxyUpgrader {

    /**
    @dev owner role for priveledged access to functions  
    */
    address public owner_;

    /**
    @dev delegator role for priveledged access to delegateCallAny
    */
    address public delegator_;

    /**
    @dev array to store list of contracts 
    */
    bytes32[] public contracts_;
    
    /**
    @dev slot for storing implementation address
    */
    address private implementation_;

    /**
    @dev events that notify of contract deployment
    */
    address immutable proxyTemplate_;
    address public template_;
    address public static_;
    bytes8 constant universalDeployCode_ = 0x38585839386009f3;
    event Deployed(bytes32 salt , address contractAddr);
    event DeployedTemplate(address contractAddr);
    event DeployedRaw(address contractAddr);
    event DeployedProxy(address contractAddr);
    // modifier restricts caller to owner or self via multicall
    modifier onlyOwner() {
        requireAuth(msg.sender == address(this) || msg.sender == owner_);
        _;
    }

    // modifier restricts caller to owner or self via multicall
    modifier onlyOwnerOrDelegator() {
        requireAuth(msg.sender == address(this) || msg.sender == owner_ || msg.sender == delegator_);
        _;
    }

    /**
    * @dev sets the value of owner_ to the sender address
    */
    constructor(address selfAddr_) {
        bytes memory proxyDeployCode = abi.encodePacked(
            universalDeployCode_,
            type(Proxy).creationCode,
            bytes32(uint256(uint160(selfAddr_)))
        );
        address addr;
        assembly {
            addr := create(0, add(proxyDeployCode, 0x20), mload(proxyDeployCode))
            if iszero(addr) {
                revert(0x00, 0x00)
            }
        }
        proxyTemplate_ = addr;
        owner_ = msg.sender;
    }

    /**
    * @dev setOwner sets the owner_ global variable with a new address
    * @param _new: address of new owner
    */
    function setOwner(address _new) public onlyOwner {
        owner_ = _new;
    }

    /**
    * @dev update the delegator global variable
    * @param _new: address of new owner
    */
    function setDelegator(address _new) public onlyOwner {
        delegator_ = _new;
    }

    /**  
    * @dev delegateCallAny is a access restricted wrapper function for delegateCallAnyInternal
    * @param _target: the address of the contract to call
    * @param _cdata: the call data for the delegate call
    */
    function delegateCallAny(address _target, bytes calldata _cdata) public onlyOwnerOrDelegator {
        bytes memory cdata = _cdata;
        delegateCallAnyInternal(_target, cdata);
        assembly {
            returndatacopy(0x00, 0x00, returndatasize())
            return(0x00, returndatasize())
        }
    }
    /**  
    * @dev callAny is a access restricted wrapper function for callAnyInternal 
    * @param _target: the address of the contract to call
    * @param _value: value to send with the call
    * @param _cdata: the call data for the delegate call
    */
    function callAny(address _target, uint256 _value, bytes calldata _cdata) public onlyOwner {
        bytes memory cdata = _cdata;
        callAnyInternal(_target, _value, cdata);
        assembly {
            returndatacopy(0x00, 0x00, returndatasize())
            return(0x00, returndatasize())
        }
    }
    
    /**  
    * @dev multiCall allows EOA to make multiple function calls within a single transaction **in this contract**, and only returns the result of the last call 
    * @param _cdata: array of function calls 
    * returns the result of the last call 
    */
    function multiCall(bytes[] calldata _cdata) external onlyOwner {
        for (uint256 i = 0; i < _cdata.length; i++) {
            bytes memory cdata = _cdata[i];
            callAnyInternal(address(this), 0, cdata);
        }
        assembly {
            returndatacopy(0x00, 0x00, returndatasize())
            return(0x00, returndatasize())
        }
    }

    /**  
    * @dev requireAuth reverts if false and returns csize0 error message 
    * @param _ok boolean false to cause revert
    */
    function requireAuth(bool _ok) internal pure {
        require(_ok, "unauthorized");
    }

    /**  
    * @dev codeSizeZeroRevert reverts if false and returns csize0 error message
    * @param _ok boolean false to cause revert 
    */
    function codeSizeZeroRevert(bool _ok) internal pure {
        require(_ok, "csize0");
    }
 
    /**  
    * @dev getContractAddress retrieves the address of the contract specified by its 32 byte salt derived from its name  
    * @param _salt the 32 byte ascii representation of the contract name  
    * @return the address of the contract referenced by _salt    
    */
    function getContractAddress(bytes32 _salt) external view returns (address) {
        return getMetamorphicContractAddress(_salt, address(this));
    }
 
    /**  
    * @dev getNumContracts retrieves the address of the contract specified by its 32 byte salt derived from its name    
    */
    function getNumContracts() external view returns (uint256) {
        return contracts_.length;
    }

    //returns implementation contracts address
    /**  
    * @dev deployTemplate deploys intermediate contract with the implementation contracts deploy code as its runtime code
    such that the implemention runtime code is returned using its constructor, if a bare empty delegate call is made into it
    with the factory as msg.sender. The intermediate contract will self destruct if a call is made with a none zero call data is made into it 
    with the factory as msg.sender.   
    * @param _deployCode the deploy code of the implementation contract. the contract must have a constructor and the constructor must be the last      
    */
    function deployTemplate(bytes calldata _deployCode) public onlyOwner returns (address contractAddr) {
        assembly{
            //get the next free pointer
            let basePtr := mload(0x40)
            let ptr := basePtr
            //codesize, PC,  pc, codecopy, codesize, push1 09, return push2
            mstore(ptr, shl(168, or(0x38585839386009f3610000, _deployCode.length)))
            ptr := add(ptr, 0x0b)
            // modify runtime to contain the tail jump operation
            // <codesize other> 56 5b 
            // account for array offset
            mstore8(ptr, 0x56)
            ptr := add(ptr, 0x01)
            mstore8(ptr, 0x5b)
            ptr := add(ptr, 0x01)
            //copies the initialization code of the implementation contract
            calldatacopy(ptr, add(0x05, _deployCode.offset), sub(_deployCode.length, 0x05))
            // Move the ptr to the end of the code in memory
            // account for the previously added values to offset the copy
            // account for the need to change the constructor dynamic byte array
            // store the length of the initcode modifier
            ptr := add(ptr, sub(_deployCode.length, 0x05))
            ptr := sub(ptr, 0x20)
            mstore(ptr, 0x28)
            ptr := add(ptr, 0x20)
            // finish the code with the terminate sequence  
            // 5b 60 80 60 40 52 60 05 33 73 <factory> 14 15 57 33 ff fe
            mstore8(ptr, 0x5b)
            ptr := add(ptr, 0x01)
            calldatacopy(ptr, _deployCode.offset, 0x05)
            ptr := add(ptr, 0x05)
            mstore(ptr, or(or(shl(240, 0x3373), shl(80, address())), shl(48, 0x14156004)))
            ptr := add(ptr, 0x1a)
            mstore(ptr, shl(192, 0x57361560045733ff))
            ptr := add(ptr, 0x08)
            contractAddr := create(0, basePtr, sub(ptr, basePtr))
        }
        codeSizeZeroRevert(uint160(contractAddr) != 0);
        emit DeployedTemplate(contractAddr);
        implementation_ = contractAddr;
        return contractAddr;      
    }
    function deployStatic(bytes32 _salt) public onlyOwner returns (address contractAddr) {
        assembly {
            // store proxy template address as implementation,
            //sstore(implementation_.slot, _impl)
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, 0x20))
            // put metamorphic code as initcode
            mstore(ptr, shl(72, 0x6020363636335afa1536363636515af43d36363e3d36f3))
            contractAddr := create2(0, ptr, 0x17, _salt)
            //if the returndatasize is not 0 revert with the error message
            if iszero(iszero(returndatasize())){
                returndatacopy(0x00, 0x00, returndatasize())
                revert(0, returndatasize())
            }
            //if contractAddr or code size at contractAddr is 0 revert with deploy fail message
            if or(iszero(contractAddr), iszero(extcodesize(contractAddr))) {
                mstore(0, "Static deploy failed")
                revert(0, 0x20)
            }
        }
        static_ = contractAddr;
        return contractAddr;
    }

    function deployProxy(bytes32 _salt) public onlyOwner returns (address contractAddr) {
        address proxyTemplate = proxyTemplate_;
        assembly {
            // store proxy template address as implementation,
            sstore(implementation_.slot, proxyTemplate)
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, 0x20))
            // put metamorphic code as initcode
            //push1 20
            mstore(ptr, shl(72, 0x6020363636335afa1536363636515af43d36363e3d36f3))
            contractAddr := create2(0, ptr, 0x17, _salt)
        }
        emit DeployedProxy(contractAddr);
        return contractAddr;
    }
    function upgradeProxy(bytes32 _salt, address _newImpl) public onlyOwner {
        address proxy = DeterministicAddress.getMetamorphicContractAddress(_salt, address(this));
        __upgrade(proxy, _newImpl);
    }
    /**  
    * @dev deployCreate deploys a contract from the factory address using create
    * @param _deployCode bytecode to deploy using create
    */
    function deployCreate(bytes calldata _deployCode) public onlyOwner returns (address contractAddr) {
        assembly{
            //get the next free pointer
            let basePtr := mload(0x40)
            let ptr := basePtr
            
            //copies the initialization code of the implementation contract
            calldatacopy(ptr, _deployCode.offset, _deployCode.length)

            //Move the ptr to the end of the code in memory
            ptr := add(ptr, _deployCode.length)
            
            contractAddr := create(0, basePtr, sub(ptr, basePtr))
        }
        codeSizeZeroRevert(uint160(contractAddr) != 0);
        emit DeployedRaw(contractAddr);
        return contractAddr;        
    }

    /**  
    * @dev deployCreate2 deploys a contract from the factory address using create
    * @param _value endowment value for created contract
    * @param _salt salt for create2 deployment, used to distinguish contracts deployed from this factory 
    * @param _deployCode bytecode to deploy using create2
    */
    function deployCreate2(uint256 _value, bytes32 _salt, bytes calldata _deployCode) public payable onlyOwner returns (address contractAddr) {
        assembly{
            //get the next free pointer
            let basePtr := mload(0x40)
            let ptr := basePtr
            
            //copies the initialization code of the implementation contract
            calldatacopy(ptr, _deployCode.offset, _deployCode.length)

            //Move the ptr to the end of the code in memory
            ptr := add(ptr, _deployCode.length)
            
            contractAddr := create2(_value, basePtr, sub(ptr, basePtr), _salt)
        }
        codeSizeZeroRevert(uint160(contractAddr) != 0);
        emit DeployedRaw(contractAddr);
        return contractAddr;        
    }

    /**  
    * @dev deploy uses create2 to deploy a metamorphic contract to a deterministic location 
    * once deployed the metamorphic contract will static call into the factory fall back to retrieve 
    * the address of the most recent template deployment
    * the metamorphic contract will then make a delegate call into the template contract to triger the deploycode which will 
    * return the runtime code.
    * after  deployment is done, if Init call data 
    * @param _implementation the implementation contract address, to copy runtime code from.
    if the 0 address is used, the last addressed stored on the global state is used    
    * @param _salt salt used for create2 param, (ascii representation of the contract name padded to 32 bytes) 
    * @param _initCallData call data used for making a initialization call to initializable contracts 
    * @return contractAddr the address of the created contract 
    */
    function deploy(address _implementation, bytes32 _salt, bytes calldata _initCallData) public payable onlyOwner returns (address contractAddr) {
        assembly {
            // store non-zero address as implementation,
            if iszero(iszero(_implementation)) {
                    sstore(implementation_.slot, _implementation)
            }
            let ptr := mload(0x40)
            // put metamorphic code as initcode
            //push1 20 
            mstore(ptr, shl(72, 0x6020363636335afa1536363636515af43d36363e3d36f3))
            contractAddr := create2(0, ptr, 0x17, _salt)
            //if the _initCallData is non zero make a initialization call 
            if iszero(iszero(_initCallData.length)) {
                //copy the arguement over from the call data in the context of the deploy function call
                calldatacopy(ptr, _initCallData.offset, _initCallData.length)
                if iszero(call(gas(), contractAddr, 0, ptr, _initCallData.length, 0x00, 0x00)) {
                    revert(0x00, returndatasize())
                }
            }
        }
        codeSizeZeroRevert(uint160(contractAddr) != 0);
        //add the salt to the list of contract names
        contracts_.push(_salt);
        emit Deployed(_salt, contractAddr);
        return contractAddr;
    }

     /**  
    * @dev destroy calls the template contract with arbitrary which will cause it to self destruct 
    * @param _contractAddr the address of the contract to self destruct 
    */
    function destroy(address _contractAddr) public onlyOwner {
        assembly{
            if iszero(_contractAddr) {
                _contractAddr := sload(implementation_.slot)
            }
            let ret := call(gas(), _contractAddr, 0, 0x40, 0x20, 0x00, 0x00) 
            if iszero(ret) {
                revert(0x00, 0x00)
            }
        }
    }

    /**  
    * @dev delegateCallAnyInternal allows the logic of this contract to be updated
    * in the event that our update/deploy mechanism is invalidated
    * this function poses a risk, but does not grant any additional
    * capability beyond that which is present due to other features 
    * present at this time
    * @param _target: the address of the contract to call
    * @param _cdata: the call data for the delegate call
    */
    function delegateCallAnyInternal(address _target, bytes memory _cdata) internal {
        assembly{
            let size := mload(_cdata)
            let ptr := add(0x20, _cdata)
            if iszero(delegatecall(gas(), _target, ptr, size, 0x00, 0x00)) {
                returndatacopy(0x00, 0x00, returndatasize())
                revert(0x00, returndatasize())
            }
        }
    }

    /**  
    * @dev callAnyInternal internal functions that allows the factory contract to make arbitray calls to other contracts 
    * @param _target: the address of the contract to call
    * @param _value: value to send with the call 
    * @param _cdata: the call data for the delegate call
    */
    function callAnyInternal(address _target, uint256 _value, bytes memory _cdata) internal {
        assembly{
            let size := mload(_cdata)
            let ptr := add(0x20, _cdata)
            if iszero(call(gas(), _target, _value, ptr, size, 0x00, 0x00)) {
                returndatacopy(0x00, 0x00, returndatasize())
                revert(0x00, returndatasize())
            }
        }
    }
    /**  
    * @dev fallback function returns the address of the most recent deployment of a template 
    */
    fallback() external {
        assembly {
            mstore(returndatasize(), sload(implementation_.slot))
            return(returndatasize(), 0x20)
        }
    }
}

contract factoryLogic {

    constructor()  {
        // create proxy template
    }

    function deployUpgradable(bytes32 _salt, bytes calldata _runtime, bytes calldata _initCallData) public {
        // deploy impl
        // deploy proxy
        // bind proxy against impl 
        // invoke init on proxy
    }

    function deployNonUpgradable(bytes32 _salt, bytes calldata _runtime, bytes calldata _initCallData) public {
        // deploy 
    }

}

contract utils {
    function getCodeSize(address target) public view returns (uint256) {
        uint256 csize;
        assembly{
            csize := extcodesize(target)
        }
        return csize;
    }
    function getCode(address target) public payable returns (bytes memory) {
        assembly{
            extcodecopy(target, 0x120, 0x00, extcodesize(target))
            let s := mul(div(extcodesize(target), 32), 32)
            if iszero(iszero(mod(extcodesize(target), 32))) {
                s := add(s,32)
            }
            mstore(0x100, extcodesize(target))
            return(0x00, add(s,0x20))
        }
    }
    function encodeProxyDeploy(address impl) public view returns(bytes memory) { 
        bytes memory filler;
        return epd(impl, filler);
    }

    function epd(address impl, bytes memory filler) internal pure returns(bytes memory) { 
            bytes memory code = (
            hex"60a060405234801561001057600080fd5b506040516101ee3803806101ee83398101604081905261002f91610053565b503360808190521955610145565b634e487b7160e01b600052604160045260246000fd5b6000806040838503121561006657600080fd5b82516001600160a01b038116811461007d57600080fd5b602084810151919350906001600160401b038082111561009c57600080fd5b818601915086601f8301126100b057600080fd5b8151818111156100c2576100c261003d565b604051601f8201601f19908116603f011681019083821181831017156100ea576100ea61003d565b81604052828152898684870101111561010257600080fd5b600093505b828410156101245784840186015181850187015292850192610107565b828411156101355760008684830101525b8096505050505050509250929050565b608051609161015d60003960006009015260916000f3fe60806040526040517f000000000000000000000000000000000000000000000000000000000000000090363d8237811982331415603e57815181553682f35b3d3d3d368585545af491503d81843e50806056573d82fd5b503d81f3fea2646970667358221220bdc9f5e3b8432af0970b67d5af169636847415b0b28c116d89b918908fc8343564736f6c634300080b0033"
            );
            return abi.encodePacked(code, abi.encode(impl, filler));
    }
        
    
}