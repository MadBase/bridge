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

// ImmutableMadTokenMetaData contains all meta data concerning the ImmutableMadToken contract.
var ImmutableMadTokenMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]",
}

// ImmutableMadTokenABI is the input ABI used to generate the binding from.
// Deprecated: Use ImmutableMadTokenMetaData.ABI instead.
var ImmutableMadTokenABI = ImmutableMadTokenMetaData.ABI

// ImmutableMadToken is an auto generated Go binding around an Ethereum contract.
type ImmutableMadToken struct {
	ImmutableMadTokenCaller     // Read-only binding to the contract
	ImmutableMadTokenTransactor // Write-only binding to the contract
	ImmutableMadTokenFilterer   // Log filterer for contract events
}

// ImmutableMadTokenCaller is an auto generated read-only Go binding around an Ethereum contract.
type ImmutableMadTokenCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableMadTokenTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ImmutableMadTokenTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableMadTokenFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ImmutableMadTokenFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableMadTokenSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ImmutableMadTokenSession struct {
	Contract     *ImmutableMadToken // Generic contract binding to set the session for
	CallOpts     bind.CallOpts      // Call options to use throughout this session
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// ImmutableMadTokenCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ImmutableMadTokenCallerSession struct {
	Contract *ImmutableMadTokenCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts            // Call options to use throughout this session
}

// ImmutableMadTokenTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ImmutableMadTokenTransactorSession struct {
	Contract     *ImmutableMadTokenTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts            // Transaction auth options to use throughout this session
}

// ImmutableMadTokenRaw is an auto generated low-level Go binding around an Ethereum contract.
type ImmutableMadTokenRaw struct {
	Contract *ImmutableMadToken // Generic contract binding to access the raw methods on
}

// ImmutableMadTokenCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ImmutableMadTokenCallerRaw struct {
	Contract *ImmutableMadTokenCaller // Generic read-only contract binding to access the raw methods on
}

// ImmutableMadTokenTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ImmutableMadTokenTransactorRaw struct {
	Contract *ImmutableMadTokenTransactor // Generic write-only contract binding to access the raw methods on
}

// NewImmutableMadToken creates a new instance of ImmutableMadToken, bound to a specific deployed contract.
func NewImmutableMadToken(address common.Address, backend bind.ContractBackend) (*ImmutableMadToken, error) {
	contract, err := bindImmutableMadToken(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ImmutableMadToken{ImmutableMadTokenCaller: ImmutableMadTokenCaller{contract: contract}, ImmutableMadTokenTransactor: ImmutableMadTokenTransactor{contract: contract}, ImmutableMadTokenFilterer: ImmutableMadTokenFilterer{contract: contract}}, nil
}

// NewImmutableMadTokenCaller creates a new read-only instance of ImmutableMadToken, bound to a specific deployed contract.
func NewImmutableMadTokenCaller(address common.Address, caller bind.ContractCaller) (*ImmutableMadTokenCaller, error) {
	contract, err := bindImmutableMadToken(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableMadTokenCaller{contract: contract}, nil
}

// NewImmutableMadTokenTransactor creates a new write-only instance of ImmutableMadToken, bound to a specific deployed contract.
func NewImmutableMadTokenTransactor(address common.Address, transactor bind.ContractTransactor) (*ImmutableMadTokenTransactor, error) {
	contract, err := bindImmutableMadToken(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableMadTokenTransactor{contract: contract}, nil
}

// NewImmutableMadTokenFilterer creates a new log filterer instance of ImmutableMadToken, bound to a specific deployed contract.
func NewImmutableMadTokenFilterer(address common.Address, filterer bind.ContractFilterer) (*ImmutableMadTokenFilterer, error) {
	contract, err := bindImmutableMadToken(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ImmutableMadTokenFilterer{contract: contract}, nil
}

// bindImmutableMadToken binds a generic wrapper to an already deployed contract.
func bindImmutableMadToken(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ImmutableMadTokenABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableMadToken *ImmutableMadTokenRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableMadToken.Contract.ImmutableMadTokenCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableMadToken *ImmutableMadTokenRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableMadToken.Contract.ImmutableMadTokenTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableMadToken *ImmutableMadTokenRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableMadToken.Contract.ImmutableMadTokenTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableMadToken *ImmutableMadTokenCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableMadToken.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableMadToken *ImmutableMadTokenTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableMadToken.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableMadToken *ImmutableMadTokenTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableMadToken.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableMadToken *ImmutableMadTokenCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ImmutableMadToken.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableMadToken *ImmutableMadTokenSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableMadToken.Contract.GetMetamorphicContractAddress(&_ImmutableMadToken.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableMadToken *ImmutableMadTokenCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableMadToken.Contract.GetMetamorphicContractAddress(&_ImmutableMadToken.CallOpts, _salt, _factory)
}
