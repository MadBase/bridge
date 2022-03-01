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

// ImmutableETHDKGMetaData contains all meta data concerning the ImmutableETHDKG contract.
var ImmutableETHDKGMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]",
}

// ImmutableETHDKGABI is the input ABI used to generate the binding from.
// Deprecated: Use ImmutableETHDKGMetaData.ABI instead.
var ImmutableETHDKGABI = ImmutableETHDKGMetaData.ABI

// ImmutableETHDKG is an auto generated Go binding around an Ethereum contract.
type ImmutableETHDKG struct {
	ImmutableETHDKGCaller     // Read-only binding to the contract
	ImmutableETHDKGTransactor // Write-only binding to the contract
	ImmutableETHDKGFilterer   // Log filterer for contract events
}

// ImmutableETHDKGCaller is an auto generated read-only Go binding around an Ethereum contract.
type ImmutableETHDKGCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableETHDKGTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ImmutableETHDKGTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableETHDKGFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ImmutableETHDKGFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableETHDKGSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ImmutableETHDKGSession struct {
	Contract     *ImmutableETHDKG  // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ImmutableETHDKGCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ImmutableETHDKGCallerSession struct {
	Contract *ImmutableETHDKGCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts          // Call options to use throughout this session
}

// ImmutableETHDKGTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ImmutableETHDKGTransactorSession struct {
	Contract     *ImmutableETHDKGTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts          // Transaction auth options to use throughout this session
}

// ImmutableETHDKGRaw is an auto generated low-level Go binding around an Ethereum contract.
type ImmutableETHDKGRaw struct {
	Contract *ImmutableETHDKG // Generic contract binding to access the raw methods on
}

// ImmutableETHDKGCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ImmutableETHDKGCallerRaw struct {
	Contract *ImmutableETHDKGCaller // Generic read-only contract binding to access the raw methods on
}

// ImmutableETHDKGTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ImmutableETHDKGTransactorRaw struct {
	Contract *ImmutableETHDKGTransactor // Generic write-only contract binding to access the raw methods on
}

// NewImmutableETHDKG creates a new instance of ImmutableETHDKG, bound to a specific deployed contract.
func NewImmutableETHDKG(address common.Address, backend bind.ContractBackend) (*ImmutableETHDKG, error) {
	contract, err := bindImmutableETHDKG(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ImmutableETHDKG{ImmutableETHDKGCaller: ImmutableETHDKGCaller{contract: contract}, ImmutableETHDKGTransactor: ImmutableETHDKGTransactor{contract: contract}, ImmutableETHDKGFilterer: ImmutableETHDKGFilterer{contract: contract}}, nil
}

// NewImmutableETHDKGCaller creates a new read-only instance of ImmutableETHDKG, bound to a specific deployed contract.
func NewImmutableETHDKGCaller(address common.Address, caller bind.ContractCaller) (*ImmutableETHDKGCaller, error) {
	contract, err := bindImmutableETHDKG(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableETHDKGCaller{contract: contract}, nil
}

// NewImmutableETHDKGTransactor creates a new write-only instance of ImmutableETHDKG, bound to a specific deployed contract.
func NewImmutableETHDKGTransactor(address common.Address, transactor bind.ContractTransactor) (*ImmutableETHDKGTransactor, error) {
	contract, err := bindImmutableETHDKG(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableETHDKGTransactor{contract: contract}, nil
}

// NewImmutableETHDKGFilterer creates a new log filterer instance of ImmutableETHDKG, bound to a specific deployed contract.
func NewImmutableETHDKGFilterer(address common.Address, filterer bind.ContractFilterer) (*ImmutableETHDKGFilterer, error) {
	contract, err := bindImmutableETHDKG(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ImmutableETHDKGFilterer{contract: contract}, nil
}

// bindImmutableETHDKG binds a generic wrapper to an already deployed contract.
func bindImmutableETHDKG(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ImmutableETHDKGABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableETHDKG *ImmutableETHDKGRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableETHDKG.Contract.ImmutableETHDKGCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableETHDKG *ImmutableETHDKGRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableETHDKG.Contract.ImmutableETHDKGTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableETHDKG *ImmutableETHDKGRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableETHDKG.Contract.ImmutableETHDKGTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableETHDKG *ImmutableETHDKGCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableETHDKG.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableETHDKG *ImmutableETHDKGTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableETHDKG.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableETHDKG *ImmutableETHDKGTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableETHDKG.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableETHDKG *ImmutableETHDKGCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ImmutableETHDKG.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableETHDKG *ImmutableETHDKGSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableETHDKG.Contract.GetMetamorphicContractAddress(&_ImmutableETHDKG.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableETHDKG *ImmutableETHDKGCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableETHDKG.Contract.GetMetamorphicContractAddress(&_ImmutableETHDKG.CallOpts, _salt, _factory)
}
