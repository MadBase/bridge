// SPDX-License-Identifier: MIT-open-group
pragma solidity ^0.8.11;

import "../utils/DeterministicAddress.sol";
/** 
*@notice RUN OPTIMIZER OFF
 */
/**
 * @notice Proxy is a delegatecall reverse proxy implementation
 * the forwarding address is stored at the slot location of not(0)
 * if not(0) has a value stored in it that is of the form 0Xca11c0de15dead10cced0000< address >
 * the proxy may no longer be upgraded using the internal mechanism. This does not prevent the implementation
 * from upgrading the proxy by changing this slot.
 * The proxy may be directly upgraded ( if the lock is not set )
 * by calling the proxy from the factory address using the format
 * abi.encodeWithSelector(0xca11c0de, <address>);
 * All other calls will be proxied through to the implementation.
 * The implementation can not be locked using the internal upgrade mechanism due to the fact that the internal
 * mechanism zeros out the higher order bits. Therefore, the implementation itself must carry the locking mechanism that sets
 * the higher order bits to lock the upgrade capability of the proxy.
 */
contract Proxy {
    address private immutable factory_;
    constructor(address _factory) {
        factory_ = _factory;
    }

    fallback() external payable {
        // make local copy of factory since immutables
        // are not accessable in assembly as of yet
        address factory = factory_;
        assembly {
            // admin is the builtin logic to change the implementation
            function admin() {
                // this is an assignment to implementation
                let newImpl := shr(96, shl(96, calldataload(0x04)))
                if eq(shr(160, sload(not(returndatasize()))), 0xca11c0de15dead10cced0000) {
                    mstore(returndatasize(), "imploc")
                    revert(returndatasize(), 0x20)
                }
                // store address into slot
                sstore(not(returndatasize()), newImpl)
                stop()
            }

            // passthrough is the passthrough logic to delegate to the implementation
            function passthrough() {
                // load free memory pointer
                let _ptr := mload(0x40)
                // allocate memory proportionate to calldata
                mstore(0x40, add(_ptr, calldatasize()))
                // copy calldata into memory
                calldatacopy(_ptr, returndatasize(), calldatasize())
                let ret := delegatecall(
                    gas(),
                    sload(not(returndatasize())),
                    _ptr,
                    calldatasize(),
                    returndatasize(),
                    returndatasize()
                )
                returndatacopy(_ptr, 0x00, returndatasize())
                if iszero(ret) {
                    revert(_ptr, returndatasize())
                }
                return(_ptr, returndatasize())
            }

            // if caller is factory,
            // and has 0xca11c0de<address> as calldata
            // run admin logic and return
            if eq(caller(), factory) {
                if eq(calldatasize(), 0x24) {
                    if eq(shr(224, calldataload(0x00)), 0xca11c0de) {
                        admin()
                    }
                }
            }
            // admin logic was not run so fallthrough to delegatecall
            passthrough()
        }
    }
}

abstract contract ProxyUpgrader {
    function __upgrade(address _proxy, address _newImpl) internal {
        bytes memory cdata = abi.encodeWithSelector(0xca11c0de, _newImpl);
        assembly {
            if iszero(call(gas(), _proxy, 0, add(cdata, 0x20), mload(cdata), 0x00, 0x00)) {
                let ptr := mload(0x40)
                mstore(0x40, add(ptr, returndatasize()))
                returndatacopy(ptr, 0x00, returndatasize())
                revert(ptr, returndatasize())
            }
        }
    }
}

abstract contract DeterministicAccessControl is DeterministicAddress {
    modifier onlyContract(address _factory, bytes32 _salt) {
        require(
            msg.sender == DeterministicAddress.getMetamorphicContractAddress(_salt, _factory),
            "notAuth"
        );
        _;
    }
}

contract Factory is DeterministicAddress, ProxyUpgrader {

    /**
    @dev owner role for priveledged access to functions  
    */
    address public owner_;

    /**
    @dev delegator role for priveledged access to delegateCallAny
    */
    address public delegator_;

    /**
    @dev slot for storing implementation address
    */
    address public implementation_;

    /**
    @dev reference to proxy deploycode
    */
    address immutable proxyTemplate_;
    address public template_;
    address public static_;
    bytes8 constant universalDeployCode_ = 0x38585839386009f3;
    event DeployedTemplate(address contractAddr);
    event DeployedProxy(address contractAddr);
    event DeployedRaw(address indexed contractAddr);
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

    function requireAuth(bool _ok) internal pure {
        require(_ok, "unauthorized");
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
    * @dev deployProxy allows the owner to deploy a metamorphic contract that copies code 
    * from the deployed proxyTemplate contract
    * @param _salt: salt used to generate the address of the create2 metamorphic contract
    * 
    */
    function deployProxy(bytes32 _salt) public onlyOwner returns (address contractAddr) {
        //bring in the proxyTemplate address from global state
        address proxyTemplate = proxyTemplate_;
        assembly {
            // store proxy template address as implementation,
            //store the proxyTemplate Address in the implementation slot 
            //so that the metamorphic contract can retrieve the template address 
            //through the fallback function
            sstore(implementation_.slot, proxyTemplate)
            //get the free memory pointers
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, 0x20))
            // put metamorphic code as initcode
            //push1 20 
            mstore(ptr, shl(72, 0x6020363636335afa1536363636515af43d36363e3d36f3))
            contractAddr := create2(0, ptr, 0x17, _salt)
        }
        //TODO: determine if we should check if there is code at contractAddr
        emit DeployedProxy(contractAddr);
        return contractAddr;
    }

    //0a008a5d
    function upgradeProxy(bytes32 _salt, address _newImpl) public onlyOwner {
        address proxy = DeterministicAddress.getMetamorphicContractAddress(_salt, address(this));
        __upgrade(proxy, _newImpl);
    }

    function initializeContract(address _contract, bytes calldata _initCallData) public onlyOwnerOrDelegator {
        assembly {
            if iszero(iszero(_initCallData.length)) {
                let ptr := mload(0x40)
                mstore(0x40, add(_initCallData.length, ptr))
                calldatacopy(ptr, _initCallData.offset, _initCallData.length)
                if iszero(call(gas(), _contract, 0, ptr, _initCallData.length, 0x00, 0x00)) {
                    ptr := mload(0x40)
                    mstore(0x40, add(returndatasize(), ptr))
                    returndatacopy(ptr, 0x00, returndatasize())
                    revert(ptr, returndatasize())
                }
            }
        }
    }

    function deployTemplate(bytes calldata _deployCode) public onlyOwner returns (address contractAddr) {
        assembly {
            //get the next free pointer
            let basePtr := mload(0x40)
            mstore(0x40, add(basePtr, add(_deployCode.length, 0x28)))
            let ptr := basePtr
            // modify runtime to contain the tail jump operation
            //codesize, pc,  pc, codecopy, codesize, push1 09, return push2 <codesize> 56 5b
            mstore(ptr, hex"38585839386009f3")
            //0x38585839386009f3
            ptr := add(ptr, 0x08)
            //copy the initialization code of the implementation contract
            calldatacopy(ptr,  _deployCode.offset, _deployCode.length)
            // Move the ptr to the end of the code in memory
            ptr := add(ptr, _deployCode.length)
            // put address on constructor
            mstore(ptr, address())
            ptr := add(ptr, 0x20)
            
            contractAddr := create(0, basePtr, sub(ptr, basePtr))
            if iszero(contractAddr) {
                revert(0, 0x20)
            }
        }
        emit DeployedTemplate(contractAddr);
        template_ = contractAddr;
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

    //27fe1822
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

    function extCodeSize(address target) public view returns (uint256){ 
        assembly{
            let size := extcodesize(target)
            mstore(0x00, size)
            return(0x00, 0x20)
        }
    }
    /**  
    * @dev codeSizeZeroRevert reverts if false and returns csize0 error message
    * @param _ok boolean false to cause revert 
    */
    function codeSizeZeroRevert(bool _ok) internal pure {
        require(_ok, "csize0");
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

abstract contract ProxyInternalUpgradeLock {
    function __lockImplementation() internal {
        assembly {
            let implSlot := not(0x00)
            sstore(
                implSlot,
                or(
                    0xca11c0de15dead10cced00000000000000000000000000000000000000000000,
                    sload(implSlot)
                )
            )
        }
    }
}

abstract contract ProxyInternalUpgradeUnlock {
    function __unlockImplementation() internal {
        assembly {
            let implSlot := not(0x00)
            sstore(
                implSlot,
                and(
                    0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff,
                    sload(implSlot)
                )
            )
        }
    }
}
/// @custom:salt kungfu
contract Mock is ProxyInternalUpgradeLock, ProxyInternalUpgradeUnlock {
    address factory_;
    uint256 public v;
    uint256 public immutable i;
    string p;
    constructor(uint256 _i, string memory _p) {
        p= _p;
        i = _i;
        factory_ = msg.sender;
    }

    function setv(uint256 _v) public {
        v = _v;
    }

    function lock() public {
        __lockImplementation();
    }

    function unlock() public {
        __unlockImplementation();
    }

    function setFactory(address _factory) public {
        factory_ = _factory;
    }
    function getFactory() external view returns (address) {
        return factory_;
    }
}

contract MockInitializable is ProxyInternalUpgradeLock, ProxyInternalUpgradeUnlock {
    address factory_;
    uint256 public v;
    uint256 public i;
    address public immutable factoryAddress = 0x0BBf39118fF9dAfDC8407c507068D47572623069;
   /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
        // contract may have been reentered.
        require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} modifier, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    function _isConstructor() private view returns (bool) {
        return !isContract(address(this));
    }

    function initialize(uint256 i) public virtual initializer{
        __Mock_init(i);
    }

    function __Mock_init(uint256 _i) internal onlyInitializing {
        __Mock_init_unchained(_i);
    }

    function __Mock_init_unchained(uint256 _i) internal onlyInitializing {
       i = _i;
        factory_ = msg.sender;
    }

    function setv(uint256 _v) public {
        v = _v;
    }

    function lock() public {
        __lockImplementation();
    }

    function unlock() public {
        __unlockImplementation();
    }

    function setFactory(address _factory) public {
        factory_ = _factory;
    }
    function getFactory() external view returns (address) {
        return factory_;
    }
}

contract MockSD is ProxyInternalUpgradeLock, ProxyInternalUpgradeUnlock {
    address factory_;
    uint256 public v;
    uint256 public immutable i;
    
    constructor(uint256 _i, bytes memory ) {
        i = _i;
        factory_ = msg.sender;
    }

    function setv(uint256 _v) public {
        v = _v;
    }

    function lock() public {
        __lockImplementation();
    }

    function unlock() public {
        __unlockImplementation();
    }

    function setFactory(address _factory) public {
        factory_ = _factory;
    }
    function getFactory() external view returns (address) {
        return factory_;
    }
}

interface MockI {
    function v() external returns (uint256);

    function i() external returns (uint256);

    function setv(uint256 _v) external;

    function lock() external;

    function unlock() external;

    function fail() external;
}
/*
contract TestProxy is ProxyUpgrader {

    Proxy immutable public proxy;
    MockI immutable mock0;
    MockI immutable mock1;

    constructor() {
        proxy  = new Proxy(address(this));
        Mock m0 = new Mock(0);
        Mock m1 = new Mock(1);
        mock0 = MockI(address(m0));
        mock1 = MockI(address(m1));
    }

    function assertMock(MockI m, uint256 i, uint256 v) internal {
        require(m.i() == i, "bad value for i");
        require(m.v() == v, "bad value for v");
        m.setv(v+1);
        require(m.i() == i, "bad value for i");
        require(m.v() == v+1, "bad value for v");
        m.setv(v);
        require(m.i() == i, "bad value for i");
        require(m.v() == v, "bad value for v");
        try m.fail() {
            require(false, "should have thrown");
        } catch {
            // do nothing
        }
    }

    function test() public {
        MockI m = MockI(address(proxy));
        //////////////////////////////////////////
        this.upgrade(address(mock0));
        assertMock(m, 0, 0);
        m.lock();
        try this.upgrade(address(mock1)) {
            require(false, "should have thrown");
        } catch {
            assertMock(m, 0, 0);
            m.unlock();
        }
        //////////////////////////////////////////
        this.upgrade(address(mock1));
        assertMock(m, 1, 0);
        m.lock();
        try this.upgrade(address(mock0)) {
            require(false, "should have thrown");
        } catch {
            assertMock(m, 1, 0);
            m.unlock();
        }
        //////////////////////////////////////////
        this.upgrade(address(mock0));
        assertMock(m, 0, 0);
        m.lock();
        try this.upgrade(address(mock1)) {
            require(false, "should have thrown");
        } catch {
            assertMock(m, 0, 0);
            m.unlock();
        }
    }

    function upgrade(address m) public {
        require(msg.sender == address(this));
        __upgrade(address(proxy), m);
    }
        
}


contract TestProxyFactory is ProxyUpgrader {

    MockI immutable mock0;
    MockI immutable mock1;
    ProxyFactory immutable factory;

    constructor() {
        factory = new ProxyFactory();
        factory.initializeProxyTemplate();
        Mock m0 = new Mock(0);
        m0.setFactory(address(factory));
        Mock m1 = new Mock(1);
        m1.setFactory(address(factory));
        mock0 = MockI(address(m0));
        mock1 = MockI(address(m1));
    }

    function assertMock(MockI m, uint256 i, uint256 v) internal {
        require(m.i() == i, "bad value for i");
        require(m.v() == v, "bad value for v");
        m.setv(v+1);
        require(m.i() == i, "bad value for i");
        require(m.v() == v+1, "bad value for v");
        m.setv(v);
        require(m.i() == i, "bad value for i");
        require(m.v() == v, "bad value for v");
        try m.fail() {
            require(false, "should have thrown");
        } catch {
            // do nothing
        }
    }

    function test() public {
        address proxy = factory.deployProxy(0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff);
        MockI m = MockI(address(proxy));
        //////////////////////////////////////////
        factory.upgrade(0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff, address(mock0));
        assertMock(m, 0, 0);
        m.lock();
        try factory.upgrade(0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff, address(mock1)) {
            require(false, "should have thrown");
        } catch {
            assertMock(m, 0, 0);
            m.unlock();
        }
        // //////////////////////////////////////////
        factory.upgrade(0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff, address(mock1));
        assertMock(m, 1, 0);
        m.lock();
        try factory.upgrade(0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff, address(mock0)) {
            require(false, "should have thrown");
        } catch {
            assertMock(m, 1, 0);
            m.unlock();
        }
        // //////////////////////////////////////////
        factory.upgrade(0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff, address(mock0));
        assertMock(m, 0, 0);
        m.lock();
        try factory.upgrade(0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff, address(mock1)) {
            require(false, "should have thrown");
        } catch {
            assertMock(m, 0, 0);
            m.unlock();
        }
    }
        
}


function deployTemplate(bytes calldata _deployCode) public returns (address contractAddr) {
        assembly {
            //get the next free pointer
            let basePtr := mload(0x40)
            mstore(0x40, add(basePtr, add(_deployCode.length, 0x80)))
            let ptr := basePtr
            // modify runtime to contain the tail jump operation
            //codesize, pc,  pc, codecopy, codesize, push1 09, return push2 <codesize> 56 5b
            mstore(
                ptr,
                shl(
                    152,
                    or(
                        0x38585839386009f3610000565b,
                        shl(16, and(add(0x20, _deployCode.length), 0xffff))
                    )
                )
            )
            ptr := add(ptr, 0x0d)
            //copy the initialization code of the implementation contract
            calldatacopy(ptr, add(0x05, _deployCode.offset), sub(_deployCode.length, 0x05))
            // Move the ptr to the end of the code in memory
            ptr := add(ptr, sub(_deployCode.length, 0x05))
            // put address on constructor
            mstore(ptr, address())
            ptr := add(ptr, 0x20)
            // finish the code with the terminate sequence
            // jumpdest < oldhead > caller push20 <factory> eq calldatasize iszero iszero and iszero push1<04> jumpi caller selfdestruct invalid
            // 5b < old head > 33 73 <factory> 14 36 15 6004 57 33 ff fe
            mstore8(ptr, 0x5b)
            ptr := add(ptr, 0x01)
            calldatacopy(ptr, _deployCode.offset, 0x05)
            ptr := add(ptr, 0x05)
            mstore(
                ptr,
                or(
                    0x3373000000000000000000000000000000000000000014361515161560045733,
                    shl(80, address())
                )
            )
            ptr := add(ptr, 0x20)
            mstore8(ptr, 0xff)
            ptr := add(ptr, 0x01)
            mstore8(ptr, 0xfe)
            ptr := add(ptr, 0x01)
            contractAddr := create(0, basePtr, sub(ptr, basePtr))
            if iszero(contractAddr) {
                revert(0, 0x20)
            }
        }
        emit DeployedTemplate(contractAddr);
        implementation_ = contractAddr;
        return contractAddr;
    }

    function deployStatic(bytes32 _salt) public returns (address contractAddr) {
        address addressIpml = implementation_;
        assembly {
            // store proxy template address as implementation,
            //sstore(implementation_.slot, _impl)
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, 0x20))
            // put metamorphic code as initcode
            mstore(ptr, shl(72, 0x6020363636335afa1536363636515af43d36363e3d36f3))
            contractAddr := create2(0, ptr, 0x17, _salt)
            if iszero(contractAddr) {
                mstore(0, "yeet2")
                revert(0, 0x20)
            }
            if iszero(call(gas(), addressIpml, 0, 0x00, 0x01, 0x00, 0x00)) {
                mstore(0x40, add(ptr, returndatasize()))
                returndatacopy(ptr, 0x00, returndatasize())
                //revert(ptr, returndatasize())
            }
        }
        implementation_ = contractAddr;
        return contractAddr;
    }

*/


