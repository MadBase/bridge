// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package bindings

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// MadnetFactoryMetaData contains all meta data concerning the MadnetFactory contract.
var MadnetFactoryMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"selfAddr_\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"bytes32\",\"name\":\"salt\",\"type\":\"bytes32\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"name\":\"Deployed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"name\":\"DeployedProxy\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"name\":\"DeployedRaw\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"name\":\"DeployedStatic\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"name\":\"DeployedTemplate\",\"type\":\"event\"},{\"stateMutability\":\"nonpayable\",\"type\":\"fallback\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_target\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_value\",\"type\":\"uint256\"},{\"internalType\":\"bytes\",\"name\":\"_cdata\",\"type\":\"bytes\"}],\"name\":\"callAny\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"contracts\",\"outputs\":[{\"internalType\":\"bytes32[]\",\"name\":\"_contracts\",\"type\":\"bytes32[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_target\",\"type\":\"address\"},{\"internalType\":\"bytes\",\"name\":\"_cdata\",\"type\":\"bytes\"}],\"name\":\"delegateCallAny\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"delegator\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"_v\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"_deployCode\",\"type\":\"bytes\"}],\"name\":\"deployCreate\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"_value\",\"type\":\"uint256\"},{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"bytes\",\"name\":\"_deployCode\",\"type\":\"bytes\"}],\"name\":\"deployCreate2\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"}],\"name\":\"deployProxy\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"bytes\",\"name\":\"_initCallData\",\"type\":\"bytes\"}],\"name\":\"deployStatic\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"_deployCode\",\"type\":\"bytes\"}],\"name\":\"deployTemplate\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"contractAddr\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getImplementation\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getNumContracts\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"implementation\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"_v\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_contract\",\"type\":\"address\"},{\"internalType\":\"bytes\",\"name\":\"_initCallData\",\"type\":\"bytes\"}],\"name\":\"initializeContract\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"_name\",\"type\":\"string\"}],\"name\":\"lookup\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"addr\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes[]\",\"name\":\"_cdata\",\"type\":\"bytes[]\"}],\"name\":\"multiCall\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"_v\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_v\",\"type\":\"address\"}],\"name\":\"setDelegator\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_v\",\"type\":\"address\"}],\"name\":\"setImplementation\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_v\",\"type\":\"address\"}],\"name\":\"setOwner\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_newImpl\",\"type\":\"address\"},{\"internalType\":\"bytes\",\"name\":\"_initCallData\",\"type\":\"bytes\"}],\"name\":\"upgradeProxy\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// MadnetFactoryABI is the input ABI used to generate the binding from.
// Deprecated: Use MadnetFactoryMetaData.ABI instead.
var MadnetFactoryABI = MadnetFactoryMetaData.ABI

// MadnetFactory is an auto generated Go binding around an Ethereum contract.
type MadnetFactory struct {
	MadnetFactoryCaller     // Read-only binding to the contract
	MadnetFactoryTransactor // Write-only binding to the contract
	MadnetFactoryFilterer   // Log filterer for contract events
}

// MadnetFactoryCaller is an auto generated read-only Go binding around an Ethereum contract.
type MadnetFactoryCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MadnetFactoryTransactor is an auto generated write-only Go binding around an Ethereum contract.
type MadnetFactoryTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MadnetFactoryFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type MadnetFactoryFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MadnetFactorySession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type MadnetFactorySession struct {
	Contract     *MadnetFactory    // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// MadnetFactoryCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type MadnetFactoryCallerSession struct {
	Contract *MadnetFactoryCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts        // Call options to use throughout this session
}

// MadnetFactoryTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type MadnetFactoryTransactorSession struct {
	Contract     *MadnetFactoryTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts        // Transaction auth options to use throughout this session
}

// MadnetFactoryRaw is an auto generated low-level Go binding around an Ethereum contract.
type MadnetFactoryRaw struct {
	Contract *MadnetFactory // Generic contract binding to access the raw methods on
}

// MadnetFactoryCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type MadnetFactoryCallerRaw struct {
	Contract *MadnetFactoryCaller // Generic read-only contract binding to access the raw methods on
}

// MadnetFactoryTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type MadnetFactoryTransactorRaw struct {
	Contract *MadnetFactoryTransactor // Generic write-only contract binding to access the raw methods on
}

// NewMadnetFactory creates a new instance of MadnetFactory, bound to a specific deployed contract.
func NewMadnetFactory(address common.Address, backend bind.ContractBackend) (*MadnetFactory, error) {
	contract, err := bindMadnetFactory(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &MadnetFactory{MadnetFactoryCaller: MadnetFactoryCaller{contract: contract}, MadnetFactoryTransactor: MadnetFactoryTransactor{contract: contract}, MadnetFactoryFilterer: MadnetFactoryFilterer{contract: contract}}, nil
}

// NewMadnetFactoryCaller creates a new read-only instance of MadnetFactory, bound to a specific deployed contract.
func NewMadnetFactoryCaller(address common.Address, caller bind.ContractCaller) (*MadnetFactoryCaller, error) {
	contract, err := bindMadnetFactory(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryCaller{contract: contract}, nil
}

// NewMadnetFactoryTransactor creates a new write-only instance of MadnetFactory, bound to a specific deployed contract.
func NewMadnetFactoryTransactor(address common.Address, transactor bind.ContractTransactor) (*MadnetFactoryTransactor, error) {
	contract, err := bindMadnetFactory(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryTransactor{contract: contract}, nil
}

// NewMadnetFactoryFilterer creates a new log filterer instance of MadnetFactory, bound to a specific deployed contract.
func NewMadnetFactoryFilterer(address common.Address, filterer bind.ContractFilterer) (*MadnetFactoryFilterer, error) {
	contract, err := bindMadnetFactory(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryFilterer{contract: contract}, nil
}

// bindMadnetFactory binds a generic wrapper to an already deployed contract.
func bindMadnetFactory(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(MadnetFactoryABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_MadnetFactory *MadnetFactoryRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _MadnetFactory.Contract.MadnetFactoryCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_MadnetFactory *MadnetFactoryRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MadnetFactory.Contract.MadnetFactoryTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_MadnetFactory *MadnetFactoryRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _MadnetFactory.Contract.MadnetFactoryTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_MadnetFactory *MadnetFactoryCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _MadnetFactory.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_MadnetFactory *MadnetFactoryTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MadnetFactory.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_MadnetFactory *MadnetFactoryTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _MadnetFactory.Contract.contract.Transact(opts, method, params...)
}

// Contracts is a free data retrieval call binding the contract method 0x6c0f79b6.
//
// Solidity: function contracts() view returns(bytes32[] _contracts)
func (_MadnetFactory *MadnetFactoryCaller) Contracts(opts *bind.CallOpts) ([][32]byte, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "contracts")

	if err != nil {
		return *new([][32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([][32]byte)).(*[][32]byte)

	return out0, err

}

// Contracts is a free data retrieval call binding the contract method 0x6c0f79b6.
//
// Solidity: function contracts() view returns(bytes32[] _contracts)
func (_MadnetFactory *MadnetFactorySession) Contracts() ([][32]byte, error) {
	return _MadnetFactory.Contract.Contracts(&_MadnetFactory.CallOpts)
}

// Contracts is a free data retrieval call binding the contract method 0x6c0f79b6.
//
// Solidity: function contracts() view returns(bytes32[] _contracts)
func (_MadnetFactory *MadnetFactoryCallerSession) Contracts() ([][32]byte, error) {
	return _MadnetFactory.Contract.Contracts(&_MadnetFactory.CallOpts)
}

// Delegator is a free data retrieval call binding the contract method 0xce9b7930.
//
// Solidity: function delegator() view returns(address _v)
func (_MadnetFactory *MadnetFactoryCaller) Delegator(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "delegator")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Delegator is a free data retrieval call binding the contract method 0xce9b7930.
//
// Solidity: function delegator() view returns(address _v)
func (_MadnetFactory *MadnetFactorySession) Delegator() (common.Address, error) {
	return _MadnetFactory.Contract.Delegator(&_MadnetFactory.CallOpts)
}

// Delegator is a free data retrieval call binding the contract method 0xce9b7930.
//
// Solidity: function delegator() view returns(address _v)
func (_MadnetFactory *MadnetFactoryCallerSession) Delegator() (common.Address, error) {
	return _MadnetFactory.Contract.Delegator(&_MadnetFactory.CallOpts)
}

// GetImplementation is a free data retrieval call binding the contract method 0xaaf10f42.
//
// Solidity: function getImplementation() view returns(address)
func (_MadnetFactory *MadnetFactoryCaller) GetImplementation(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "getImplementation")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetImplementation is a free data retrieval call binding the contract method 0xaaf10f42.
//
// Solidity: function getImplementation() view returns(address)
func (_MadnetFactory *MadnetFactorySession) GetImplementation() (common.Address, error) {
	return _MadnetFactory.Contract.GetImplementation(&_MadnetFactory.CallOpts)
}

// GetImplementation is a free data retrieval call binding the contract method 0xaaf10f42.
//
// Solidity: function getImplementation() view returns(address)
func (_MadnetFactory *MadnetFactoryCallerSession) GetImplementation() (common.Address, error) {
	return _MadnetFactory.Contract.GetImplementation(&_MadnetFactory.CallOpts)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_MadnetFactory *MadnetFactoryCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_MadnetFactory *MadnetFactorySession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _MadnetFactory.Contract.GetMetamorphicContractAddress(&_MadnetFactory.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_MadnetFactory *MadnetFactoryCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _MadnetFactory.Contract.GetMetamorphicContractAddress(&_MadnetFactory.CallOpts, _salt, _factory)
}

// GetNumContracts is a free data retrieval call binding the contract method 0xcfe10b30.
//
// Solidity: function getNumContracts() view returns(uint256)
func (_MadnetFactory *MadnetFactoryCaller) GetNumContracts(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "getNumContracts")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetNumContracts is a free data retrieval call binding the contract method 0xcfe10b30.
//
// Solidity: function getNumContracts() view returns(uint256)
func (_MadnetFactory *MadnetFactorySession) GetNumContracts() (*big.Int, error) {
	return _MadnetFactory.Contract.GetNumContracts(&_MadnetFactory.CallOpts)
}

// GetNumContracts is a free data retrieval call binding the contract method 0xcfe10b30.
//
// Solidity: function getNumContracts() view returns(uint256)
func (_MadnetFactory *MadnetFactoryCallerSession) GetNumContracts() (*big.Int, error) {
	return _MadnetFactory.Contract.GetNumContracts(&_MadnetFactory.CallOpts)
}

// Implementation is a free data retrieval call binding the contract method 0x5c60da1b.
//
// Solidity: function implementation() view returns(address _v)
func (_MadnetFactory *MadnetFactoryCaller) Implementation(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "implementation")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Implementation is a free data retrieval call binding the contract method 0x5c60da1b.
//
// Solidity: function implementation() view returns(address _v)
func (_MadnetFactory *MadnetFactorySession) Implementation() (common.Address, error) {
	return _MadnetFactory.Contract.Implementation(&_MadnetFactory.CallOpts)
}

// Implementation is a free data retrieval call binding the contract method 0x5c60da1b.
//
// Solidity: function implementation() view returns(address _v)
func (_MadnetFactory *MadnetFactoryCallerSession) Implementation() (common.Address, error) {
	return _MadnetFactory.Contract.Implementation(&_MadnetFactory.CallOpts)
}

// Lookup is a free data retrieval call binding the contract method 0xf67187ac.
//
// Solidity: function lookup(string _name) view returns(address addr)
func (_MadnetFactory *MadnetFactoryCaller) Lookup(opts *bind.CallOpts, _name string) (common.Address, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "lookup", _name)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Lookup is a free data retrieval call binding the contract method 0xf67187ac.
//
// Solidity: function lookup(string _name) view returns(address addr)
func (_MadnetFactory *MadnetFactorySession) Lookup(_name string) (common.Address, error) {
	return _MadnetFactory.Contract.Lookup(&_MadnetFactory.CallOpts, _name)
}

// Lookup is a free data retrieval call binding the contract method 0xf67187ac.
//
// Solidity: function lookup(string _name) view returns(address addr)
func (_MadnetFactory *MadnetFactoryCallerSession) Lookup(_name string) (common.Address, error) {
	return _MadnetFactory.Contract.Lookup(&_MadnetFactory.CallOpts, _name)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address _v)
func (_MadnetFactory *MadnetFactoryCaller) Owner(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MadnetFactory.contract.Call(opts, &out, "owner")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address _v)
func (_MadnetFactory *MadnetFactorySession) Owner() (common.Address, error) {
	return _MadnetFactory.Contract.Owner(&_MadnetFactory.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address _v)
func (_MadnetFactory *MadnetFactoryCallerSession) Owner() (common.Address, error) {
	return _MadnetFactory.Contract.Owner(&_MadnetFactory.CallOpts)
}

// CallAny is a paid mutator transaction binding the contract method 0x12e6bf6a.
//
// Solidity: function callAny(address _target, uint256 _value, bytes _cdata) returns()
func (_MadnetFactory *MadnetFactoryTransactor) CallAny(opts *bind.TransactOpts, _target common.Address, _value *big.Int, _cdata []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "callAny", _target, _value, _cdata)
}

// CallAny is a paid mutator transaction binding the contract method 0x12e6bf6a.
//
// Solidity: function callAny(address _target, uint256 _value, bytes _cdata) returns()
func (_MadnetFactory *MadnetFactorySession) CallAny(_target common.Address, _value *big.Int, _cdata []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.CallAny(&_MadnetFactory.TransactOpts, _target, _value, _cdata)
}

// CallAny is a paid mutator transaction binding the contract method 0x12e6bf6a.
//
// Solidity: function callAny(address _target, uint256 _value, bytes _cdata) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) CallAny(_target common.Address, _value *big.Int, _cdata []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.CallAny(&_MadnetFactory.TransactOpts, _target, _value, _cdata)
}

// DelegateCallAny is a paid mutator transaction binding the contract method 0x4713ee7a.
//
// Solidity: function delegateCallAny(address _target, bytes _cdata) returns()
func (_MadnetFactory *MadnetFactoryTransactor) DelegateCallAny(opts *bind.TransactOpts, _target common.Address, _cdata []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "delegateCallAny", _target, _cdata)
}

// DelegateCallAny is a paid mutator transaction binding the contract method 0x4713ee7a.
//
// Solidity: function delegateCallAny(address _target, bytes _cdata) returns()
func (_MadnetFactory *MadnetFactorySession) DelegateCallAny(_target common.Address, _cdata []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DelegateCallAny(&_MadnetFactory.TransactOpts, _target, _cdata)
}

// DelegateCallAny is a paid mutator transaction binding the contract method 0x4713ee7a.
//
// Solidity: function delegateCallAny(address _target, bytes _cdata) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) DelegateCallAny(_target common.Address, _cdata []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DelegateCallAny(&_MadnetFactory.TransactOpts, _target, _cdata)
}

// DeployCreate is a paid mutator transaction binding the contract method 0x27fe1822.
//
// Solidity: function deployCreate(bytes _deployCode) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactor) DeployCreate(opts *bind.TransactOpts, _deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "deployCreate", _deployCode)
}

// DeployCreate is a paid mutator transaction binding the contract method 0x27fe1822.
//
// Solidity: function deployCreate(bytes _deployCode) returns(address contractAddr)
func (_MadnetFactory *MadnetFactorySession) DeployCreate(_deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployCreate(&_MadnetFactory.TransactOpts, _deployCode)
}

// DeployCreate is a paid mutator transaction binding the contract method 0x27fe1822.
//
// Solidity: function deployCreate(bytes _deployCode) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactorSession) DeployCreate(_deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployCreate(&_MadnetFactory.TransactOpts, _deployCode)
}

// DeployCreate2 is a paid mutator transaction binding the contract method 0x56f2a761.
//
// Solidity: function deployCreate2(uint256 _value, bytes32 _salt, bytes _deployCode) payable returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactor) DeployCreate2(opts *bind.TransactOpts, _value *big.Int, _salt [32]byte, _deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "deployCreate2", _value, _salt, _deployCode)
}

// DeployCreate2 is a paid mutator transaction binding the contract method 0x56f2a761.
//
// Solidity: function deployCreate2(uint256 _value, bytes32 _salt, bytes _deployCode) payable returns(address contractAddr)
func (_MadnetFactory *MadnetFactorySession) DeployCreate2(_value *big.Int, _salt [32]byte, _deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployCreate2(&_MadnetFactory.TransactOpts, _value, _salt, _deployCode)
}

// DeployCreate2 is a paid mutator transaction binding the contract method 0x56f2a761.
//
// Solidity: function deployCreate2(uint256 _value, bytes32 _salt, bytes _deployCode) payable returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactorSession) DeployCreate2(_value *big.Int, _salt [32]byte, _deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployCreate2(&_MadnetFactory.TransactOpts, _value, _salt, _deployCode)
}

// DeployProxy is a paid mutator transaction binding the contract method 0x39cab472.
//
// Solidity: function deployProxy(bytes32 _salt) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactor) DeployProxy(opts *bind.TransactOpts, _salt [32]byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "deployProxy", _salt)
}

// DeployProxy is a paid mutator transaction binding the contract method 0x39cab472.
//
// Solidity: function deployProxy(bytes32 _salt) returns(address contractAddr)
func (_MadnetFactory *MadnetFactorySession) DeployProxy(_salt [32]byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployProxy(&_MadnetFactory.TransactOpts, _salt)
}

// DeployProxy is a paid mutator transaction binding the contract method 0x39cab472.
//
// Solidity: function deployProxy(bytes32 _salt) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactorSession) DeployProxy(_salt [32]byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployProxy(&_MadnetFactory.TransactOpts, _salt)
}

// DeployStatic is a paid mutator transaction binding the contract method 0xfa481da5.
//
// Solidity: function deployStatic(bytes32 _salt, bytes _initCallData) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactor) DeployStatic(opts *bind.TransactOpts, _salt [32]byte, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "deployStatic", _salt, _initCallData)
}

// DeployStatic is a paid mutator transaction binding the contract method 0xfa481da5.
//
// Solidity: function deployStatic(bytes32 _salt, bytes _initCallData) returns(address contractAddr)
func (_MadnetFactory *MadnetFactorySession) DeployStatic(_salt [32]byte, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployStatic(&_MadnetFactory.TransactOpts, _salt, _initCallData)
}

// DeployStatic is a paid mutator transaction binding the contract method 0xfa481da5.
//
// Solidity: function deployStatic(bytes32 _salt, bytes _initCallData) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactorSession) DeployStatic(_salt [32]byte, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployStatic(&_MadnetFactory.TransactOpts, _salt, _initCallData)
}

// DeployTemplate is a paid mutator transaction binding the contract method 0x17cff2c5.
//
// Solidity: function deployTemplate(bytes _deployCode) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactor) DeployTemplate(opts *bind.TransactOpts, _deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "deployTemplate", _deployCode)
}

// DeployTemplate is a paid mutator transaction binding the contract method 0x17cff2c5.
//
// Solidity: function deployTemplate(bytes _deployCode) returns(address contractAddr)
func (_MadnetFactory *MadnetFactorySession) DeployTemplate(_deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployTemplate(&_MadnetFactory.TransactOpts, _deployCode)
}

// DeployTemplate is a paid mutator transaction binding the contract method 0x17cff2c5.
//
// Solidity: function deployTemplate(bytes _deployCode) returns(address contractAddr)
func (_MadnetFactory *MadnetFactoryTransactorSession) DeployTemplate(_deployCode []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.DeployTemplate(&_MadnetFactory.TransactOpts, _deployCode)
}

// InitializeContract is a paid mutator transaction binding the contract method 0xe1d7a8e4.
//
// Solidity: function initializeContract(address _contract, bytes _initCallData) returns()
func (_MadnetFactory *MadnetFactoryTransactor) InitializeContract(opts *bind.TransactOpts, _contract common.Address, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "initializeContract", _contract, _initCallData)
}

// InitializeContract is a paid mutator transaction binding the contract method 0xe1d7a8e4.
//
// Solidity: function initializeContract(address _contract, bytes _initCallData) returns()
func (_MadnetFactory *MadnetFactorySession) InitializeContract(_contract common.Address, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.InitializeContract(&_MadnetFactory.TransactOpts, _contract, _initCallData)
}

// InitializeContract is a paid mutator transaction binding the contract method 0xe1d7a8e4.
//
// Solidity: function initializeContract(address _contract, bytes _initCallData) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) InitializeContract(_contract common.Address, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.InitializeContract(&_MadnetFactory.TransactOpts, _contract, _initCallData)
}

// MultiCall is a paid mutator transaction binding the contract method 0x348a0cdc.
//
// Solidity: function multiCall(bytes[] _cdata) returns()
func (_MadnetFactory *MadnetFactoryTransactor) MultiCall(opts *bind.TransactOpts, _cdata [][]byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "multiCall", _cdata)
}

// MultiCall is a paid mutator transaction binding the contract method 0x348a0cdc.
//
// Solidity: function multiCall(bytes[] _cdata) returns()
func (_MadnetFactory *MadnetFactorySession) MultiCall(_cdata [][]byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.MultiCall(&_MadnetFactory.TransactOpts, _cdata)
}

// MultiCall is a paid mutator transaction binding the contract method 0x348a0cdc.
//
// Solidity: function multiCall(bytes[] _cdata) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) MultiCall(_cdata [][]byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.MultiCall(&_MadnetFactory.TransactOpts, _cdata)
}

// SetDelegator is a paid mutator transaction binding the contract method 0x83cd9cc3.
//
// Solidity: function setDelegator(address _v) returns()
func (_MadnetFactory *MadnetFactoryTransactor) SetDelegator(opts *bind.TransactOpts, _v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "setDelegator", _v)
}

// SetDelegator is a paid mutator transaction binding the contract method 0x83cd9cc3.
//
// Solidity: function setDelegator(address _v) returns()
func (_MadnetFactory *MadnetFactorySession) SetDelegator(_v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.Contract.SetDelegator(&_MadnetFactory.TransactOpts, _v)
}

// SetDelegator is a paid mutator transaction binding the contract method 0x83cd9cc3.
//
// Solidity: function setDelegator(address _v) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) SetDelegator(_v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.Contract.SetDelegator(&_MadnetFactory.TransactOpts, _v)
}

// SetImplementation is a paid mutator transaction binding the contract method 0xd784d426.
//
// Solidity: function setImplementation(address _v) returns()
func (_MadnetFactory *MadnetFactoryTransactor) SetImplementation(opts *bind.TransactOpts, _v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "setImplementation", _v)
}

// SetImplementation is a paid mutator transaction binding the contract method 0xd784d426.
//
// Solidity: function setImplementation(address _v) returns()
func (_MadnetFactory *MadnetFactorySession) SetImplementation(_v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.Contract.SetImplementation(&_MadnetFactory.TransactOpts, _v)
}

// SetImplementation is a paid mutator transaction binding the contract method 0xd784d426.
//
// Solidity: function setImplementation(address _v) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) SetImplementation(_v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.Contract.SetImplementation(&_MadnetFactory.TransactOpts, _v)
}

// SetOwner is a paid mutator transaction binding the contract method 0x13af4035.
//
// Solidity: function setOwner(address _v) returns()
func (_MadnetFactory *MadnetFactoryTransactor) SetOwner(opts *bind.TransactOpts, _v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "setOwner", _v)
}

// SetOwner is a paid mutator transaction binding the contract method 0x13af4035.
//
// Solidity: function setOwner(address _v) returns()
func (_MadnetFactory *MadnetFactorySession) SetOwner(_v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.Contract.SetOwner(&_MadnetFactory.TransactOpts, _v)
}

// SetOwner is a paid mutator transaction binding the contract method 0x13af4035.
//
// Solidity: function setOwner(address _v) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) SetOwner(_v common.Address) (*types.Transaction, error) {
	return _MadnetFactory.Contract.SetOwner(&_MadnetFactory.TransactOpts, _v)
}

// UpgradeProxy is a paid mutator transaction binding the contract method 0x043c9414.
//
// Solidity: function upgradeProxy(bytes32 _salt, address _newImpl, bytes _initCallData) returns()
func (_MadnetFactory *MadnetFactoryTransactor) UpgradeProxy(opts *bind.TransactOpts, _salt [32]byte, _newImpl common.Address, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.Transact(opts, "upgradeProxy", _salt, _newImpl, _initCallData)
}

// UpgradeProxy is a paid mutator transaction binding the contract method 0x043c9414.
//
// Solidity: function upgradeProxy(bytes32 _salt, address _newImpl, bytes _initCallData) returns()
func (_MadnetFactory *MadnetFactorySession) UpgradeProxy(_salt [32]byte, _newImpl common.Address, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.UpgradeProxy(&_MadnetFactory.TransactOpts, _salt, _newImpl, _initCallData)
}

// UpgradeProxy is a paid mutator transaction binding the contract method 0x043c9414.
//
// Solidity: function upgradeProxy(bytes32 _salt, address _newImpl, bytes _initCallData) returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) UpgradeProxy(_salt [32]byte, _newImpl common.Address, _initCallData []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.UpgradeProxy(&_MadnetFactory.TransactOpts, _salt, _newImpl, _initCallData)
}

// Fallback is a paid mutator transaction binding the contract fallback function.
//
// Solidity: fallback() returns()
func (_MadnetFactory *MadnetFactoryTransactor) Fallback(opts *bind.TransactOpts, calldata []byte) (*types.Transaction, error) {
	return _MadnetFactory.contract.RawTransact(opts, calldata)
}

// Fallback is a paid mutator transaction binding the contract fallback function.
//
// Solidity: fallback() returns()
func (_MadnetFactory *MadnetFactorySession) Fallback(calldata []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.Fallback(&_MadnetFactory.TransactOpts, calldata)
}

// Fallback is a paid mutator transaction binding the contract fallback function.
//
// Solidity: fallback() returns()
func (_MadnetFactory *MadnetFactoryTransactorSession) Fallback(calldata []byte) (*types.Transaction, error) {
	return _MadnetFactory.Contract.Fallback(&_MadnetFactory.TransactOpts, calldata)
}

// MadnetFactoryDeployedIterator is returned from FilterDeployed and is used to iterate over the raw logs and unpacked data for Deployed events raised by the MadnetFactory contract.
type MadnetFactoryDeployedIterator struct {
	Event *MadnetFactoryDeployed // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *MadnetFactoryDeployedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadnetFactoryDeployed)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(MadnetFactoryDeployed)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *MadnetFactoryDeployedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadnetFactoryDeployedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadnetFactoryDeployed represents a Deployed event raised by the MadnetFactory contract.
type MadnetFactoryDeployed struct {
	Salt         [32]byte
	ContractAddr common.Address
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterDeployed is a free log retrieval operation binding the contract event 0xe491e278e37782abe0872fe7c7b549cd7b0713d0c5c1e84a81899a5fdf32087b.
//
// Solidity: event Deployed(bytes32 salt, address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) FilterDeployed(opts *bind.FilterOpts) (*MadnetFactoryDeployedIterator, error) {

	logs, sub, err := _MadnetFactory.contract.FilterLogs(opts, "Deployed")
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryDeployedIterator{contract: _MadnetFactory.contract, event: "Deployed", logs: logs, sub: sub}, nil
}

// WatchDeployed is a free log subscription operation binding the contract event 0xe491e278e37782abe0872fe7c7b549cd7b0713d0c5c1e84a81899a5fdf32087b.
//
// Solidity: event Deployed(bytes32 salt, address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) WatchDeployed(opts *bind.WatchOpts, sink chan<- *MadnetFactoryDeployed) (event.Subscription, error) {

	logs, sub, err := _MadnetFactory.contract.WatchLogs(opts, "Deployed")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadnetFactoryDeployed)
				if err := _MadnetFactory.contract.UnpackLog(event, "Deployed", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDeployed is a log parse operation binding the contract event 0xe491e278e37782abe0872fe7c7b549cd7b0713d0c5c1e84a81899a5fdf32087b.
//
// Solidity: event Deployed(bytes32 salt, address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) ParseDeployed(log types.Log) (*MadnetFactoryDeployed, error) {
	event := new(MadnetFactoryDeployed)
	if err := _MadnetFactory.contract.UnpackLog(event, "Deployed", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MadnetFactoryDeployedProxyIterator is returned from FilterDeployedProxy and is used to iterate over the raw logs and unpacked data for DeployedProxy events raised by the MadnetFactory contract.
type MadnetFactoryDeployedProxyIterator struct {
	Event *MadnetFactoryDeployedProxy // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *MadnetFactoryDeployedProxyIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadnetFactoryDeployedProxy)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(MadnetFactoryDeployedProxy)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *MadnetFactoryDeployedProxyIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadnetFactoryDeployedProxyIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadnetFactoryDeployedProxy represents a DeployedProxy event raised by the MadnetFactory contract.
type MadnetFactoryDeployedProxy struct {
	ContractAddr common.Address
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterDeployedProxy is a free log retrieval operation binding the contract event 0x06690e5b52be10a3d5820ec875c3dd3327f3077954a09f104201e40e5f7082c6.
//
// Solidity: event DeployedProxy(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) FilterDeployedProxy(opts *bind.FilterOpts) (*MadnetFactoryDeployedProxyIterator, error) {

	logs, sub, err := _MadnetFactory.contract.FilterLogs(opts, "DeployedProxy")
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryDeployedProxyIterator{contract: _MadnetFactory.contract, event: "DeployedProxy", logs: logs, sub: sub}, nil
}

// WatchDeployedProxy is a free log subscription operation binding the contract event 0x06690e5b52be10a3d5820ec875c3dd3327f3077954a09f104201e40e5f7082c6.
//
// Solidity: event DeployedProxy(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) WatchDeployedProxy(opts *bind.WatchOpts, sink chan<- *MadnetFactoryDeployedProxy) (event.Subscription, error) {

	logs, sub, err := _MadnetFactory.contract.WatchLogs(opts, "DeployedProxy")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadnetFactoryDeployedProxy)
				if err := _MadnetFactory.contract.UnpackLog(event, "DeployedProxy", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDeployedProxy is a log parse operation binding the contract event 0x06690e5b52be10a3d5820ec875c3dd3327f3077954a09f104201e40e5f7082c6.
//
// Solidity: event DeployedProxy(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) ParseDeployedProxy(log types.Log) (*MadnetFactoryDeployedProxy, error) {
	event := new(MadnetFactoryDeployedProxy)
	if err := _MadnetFactory.contract.UnpackLog(event, "DeployedProxy", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MadnetFactoryDeployedRawIterator is returned from FilterDeployedRaw and is used to iterate over the raw logs and unpacked data for DeployedRaw events raised by the MadnetFactory contract.
type MadnetFactoryDeployedRawIterator struct {
	Event *MadnetFactoryDeployedRaw // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *MadnetFactoryDeployedRawIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadnetFactoryDeployedRaw)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(MadnetFactoryDeployedRaw)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *MadnetFactoryDeployedRawIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadnetFactoryDeployedRawIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadnetFactoryDeployedRaw represents a DeployedRaw event raised by the MadnetFactory contract.
type MadnetFactoryDeployedRaw struct {
	ContractAddr common.Address
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterDeployedRaw is a free log retrieval operation binding the contract event 0xd3acf0da590cfcd8f020afd7f40b7e6e4c8bd2fc9eb7aec9836837b667685b3a.
//
// Solidity: event DeployedRaw(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) FilterDeployedRaw(opts *bind.FilterOpts) (*MadnetFactoryDeployedRawIterator, error) {

	logs, sub, err := _MadnetFactory.contract.FilterLogs(opts, "DeployedRaw")
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryDeployedRawIterator{contract: _MadnetFactory.contract, event: "DeployedRaw", logs: logs, sub: sub}, nil
}

// WatchDeployedRaw is a free log subscription operation binding the contract event 0xd3acf0da590cfcd8f020afd7f40b7e6e4c8bd2fc9eb7aec9836837b667685b3a.
//
// Solidity: event DeployedRaw(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) WatchDeployedRaw(opts *bind.WatchOpts, sink chan<- *MadnetFactoryDeployedRaw) (event.Subscription, error) {

	logs, sub, err := _MadnetFactory.contract.WatchLogs(opts, "DeployedRaw")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadnetFactoryDeployedRaw)
				if err := _MadnetFactory.contract.UnpackLog(event, "DeployedRaw", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDeployedRaw is a log parse operation binding the contract event 0xd3acf0da590cfcd8f020afd7f40b7e6e4c8bd2fc9eb7aec9836837b667685b3a.
//
// Solidity: event DeployedRaw(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) ParseDeployedRaw(log types.Log) (*MadnetFactoryDeployedRaw, error) {
	event := new(MadnetFactoryDeployedRaw)
	if err := _MadnetFactory.contract.UnpackLog(event, "DeployedRaw", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MadnetFactoryDeployedStaticIterator is returned from FilterDeployedStatic and is used to iterate over the raw logs and unpacked data for DeployedStatic events raised by the MadnetFactory contract.
type MadnetFactoryDeployedStaticIterator struct {
	Event *MadnetFactoryDeployedStatic // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *MadnetFactoryDeployedStaticIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadnetFactoryDeployedStatic)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(MadnetFactoryDeployedStatic)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *MadnetFactoryDeployedStaticIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadnetFactoryDeployedStaticIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadnetFactoryDeployedStatic represents a DeployedStatic event raised by the MadnetFactory contract.
type MadnetFactoryDeployedStatic struct {
	ContractAddr common.Address
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterDeployedStatic is a free log retrieval operation binding the contract event 0xe8b9cb7d60827a7d55e211f1382dd0f129adb541af9fe45a09ab4a18b76e7c65.
//
// Solidity: event DeployedStatic(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) FilterDeployedStatic(opts *bind.FilterOpts) (*MadnetFactoryDeployedStaticIterator, error) {

	logs, sub, err := _MadnetFactory.contract.FilterLogs(opts, "DeployedStatic")
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryDeployedStaticIterator{contract: _MadnetFactory.contract, event: "DeployedStatic", logs: logs, sub: sub}, nil
}

// WatchDeployedStatic is a free log subscription operation binding the contract event 0xe8b9cb7d60827a7d55e211f1382dd0f129adb541af9fe45a09ab4a18b76e7c65.
//
// Solidity: event DeployedStatic(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) WatchDeployedStatic(opts *bind.WatchOpts, sink chan<- *MadnetFactoryDeployedStatic) (event.Subscription, error) {

	logs, sub, err := _MadnetFactory.contract.WatchLogs(opts, "DeployedStatic")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadnetFactoryDeployedStatic)
				if err := _MadnetFactory.contract.UnpackLog(event, "DeployedStatic", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDeployedStatic is a log parse operation binding the contract event 0xe8b9cb7d60827a7d55e211f1382dd0f129adb541af9fe45a09ab4a18b76e7c65.
//
// Solidity: event DeployedStatic(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) ParseDeployedStatic(log types.Log) (*MadnetFactoryDeployedStatic, error) {
	event := new(MadnetFactoryDeployedStatic)
	if err := _MadnetFactory.contract.UnpackLog(event, "DeployedStatic", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MadnetFactoryDeployedTemplateIterator is returned from FilterDeployedTemplate and is used to iterate over the raw logs and unpacked data for DeployedTemplate events raised by the MadnetFactory contract.
type MadnetFactoryDeployedTemplateIterator struct {
	Event *MadnetFactoryDeployedTemplate // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *MadnetFactoryDeployedTemplateIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadnetFactoryDeployedTemplate)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(MadnetFactoryDeployedTemplate)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *MadnetFactoryDeployedTemplateIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadnetFactoryDeployedTemplateIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadnetFactoryDeployedTemplate represents a DeployedTemplate event raised by the MadnetFactory contract.
type MadnetFactoryDeployedTemplate struct {
	ContractAddr common.Address
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterDeployedTemplate is a free log retrieval operation binding the contract event 0x6cd94ea1c5d9f99038bb4629d8a759399654d3861b73bf3a2b0cf484dae72138.
//
// Solidity: event DeployedTemplate(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) FilterDeployedTemplate(opts *bind.FilterOpts) (*MadnetFactoryDeployedTemplateIterator, error) {

	logs, sub, err := _MadnetFactory.contract.FilterLogs(opts, "DeployedTemplate")
	if err != nil {
		return nil, err
	}
	return &MadnetFactoryDeployedTemplateIterator{contract: _MadnetFactory.contract, event: "DeployedTemplate", logs: logs, sub: sub}, nil
}

// WatchDeployedTemplate is a free log subscription operation binding the contract event 0x6cd94ea1c5d9f99038bb4629d8a759399654d3861b73bf3a2b0cf484dae72138.
//
// Solidity: event DeployedTemplate(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) WatchDeployedTemplate(opts *bind.WatchOpts, sink chan<- *MadnetFactoryDeployedTemplate) (event.Subscription, error) {

	logs, sub, err := _MadnetFactory.contract.WatchLogs(opts, "DeployedTemplate")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadnetFactoryDeployedTemplate)
				if err := _MadnetFactory.contract.UnpackLog(event, "DeployedTemplate", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDeployedTemplate is a log parse operation binding the contract event 0x6cd94ea1c5d9f99038bb4629d8a759399654d3861b73bf3a2b0cf484dae72138.
//
// Solidity: event DeployedTemplate(address contractAddr)
func (_MadnetFactory *MadnetFactoryFilterer) ParseDeployedTemplate(log types.Log) (*MadnetFactoryDeployedTemplate, error) {
	event := new(MadnetFactoryDeployedTemplate)
	if err := _MadnetFactory.contract.UnpackLog(event, "DeployedTemplate", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
