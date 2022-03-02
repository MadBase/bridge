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

// ImmutableStakeNFTMetaData contains all meta data concerning the ImmutableStakeNFT contract.
var ImmutableStakeNFTMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]",
}

// ImmutableStakeNFTABI is the input ABI used to generate the binding from.
// Deprecated: Use ImmutableStakeNFTMetaData.ABI instead.
var ImmutableStakeNFTABI = ImmutableStakeNFTMetaData.ABI

// ImmutableStakeNFT is an auto generated Go binding around an Ethereum contract.
type ImmutableStakeNFT struct {
	ImmutableStakeNFTCaller     // Read-only binding to the contract
	ImmutableStakeNFTTransactor // Write-only binding to the contract
	ImmutableStakeNFTFilterer   // Log filterer for contract events
}

// ImmutableStakeNFTCaller is an auto generated read-only Go binding around an Ethereum contract.
type ImmutableStakeNFTCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableStakeNFTTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ImmutableStakeNFTTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableStakeNFTFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ImmutableStakeNFTFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableStakeNFTSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ImmutableStakeNFTSession struct {
	Contract     *ImmutableStakeNFT // Generic contract binding to set the session for
	CallOpts     bind.CallOpts      // Call options to use throughout this session
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// ImmutableStakeNFTCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ImmutableStakeNFTCallerSession struct {
	Contract *ImmutableStakeNFTCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts            // Call options to use throughout this session
}

// ImmutableStakeNFTTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ImmutableStakeNFTTransactorSession struct {
	Contract     *ImmutableStakeNFTTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts            // Transaction auth options to use throughout this session
}

// ImmutableStakeNFTRaw is an auto generated low-level Go binding around an Ethereum contract.
type ImmutableStakeNFTRaw struct {
	Contract *ImmutableStakeNFT // Generic contract binding to access the raw methods on
}

// ImmutableStakeNFTCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ImmutableStakeNFTCallerRaw struct {
	Contract *ImmutableStakeNFTCaller // Generic read-only contract binding to access the raw methods on
}

// ImmutableStakeNFTTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ImmutableStakeNFTTransactorRaw struct {
	Contract *ImmutableStakeNFTTransactor // Generic write-only contract binding to access the raw methods on
}

// NewImmutableStakeNFT creates a new instance of ImmutableStakeNFT, bound to a specific deployed contract.
func NewImmutableStakeNFT(address common.Address, backend bind.ContractBackend) (*ImmutableStakeNFT, error) {
	contract, err := bindImmutableStakeNFT(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFT{ImmutableStakeNFTCaller: ImmutableStakeNFTCaller{contract: contract}, ImmutableStakeNFTTransactor: ImmutableStakeNFTTransactor{contract: contract}, ImmutableStakeNFTFilterer: ImmutableStakeNFTFilterer{contract: contract}}, nil
}

// NewImmutableStakeNFTCaller creates a new read-only instance of ImmutableStakeNFT, bound to a specific deployed contract.
func NewImmutableStakeNFTCaller(address common.Address, caller bind.ContractCaller) (*ImmutableStakeNFTCaller, error) {
	contract, err := bindImmutableStakeNFT(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFTCaller{contract: contract}, nil
}

// NewImmutableStakeNFTTransactor creates a new write-only instance of ImmutableStakeNFT, bound to a specific deployed contract.
func NewImmutableStakeNFTTransactor(address common.Address, transactor bind.ContractTransactor) (*ImmutableStakeNFTTransactor, error) {
	contract, err := bindImmutableStakeNFT(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFTTransactor{contract: contract}, nil
}

// NewImmutableStakeNFTFilterer creates a new log filterer instance of ImmutableStakeNFT, bound to a specific deployed contract.
func NewImmutableStakeNFTFilterer(address common.Address, filterer bind.ContractFilterer) (*ImmutableStakeNFTFilterer, error) {
	contract, err := bindImmutableStakeNFT(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFTFilterer{contract: contract}, nil
}

// bindImmutableStakeNFT binds a generic wrapper to an already deployed contract.
func bindImmutableStakeNFT(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ImmutableStakeNFTABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableStakeNFT *ImmutableStakeNFTRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableStakeNFT.Contract.ImmutableStakeNFTCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableStakeNFT *ImmutableStakeNFTRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableStakeNFT.Contract.ImmutableStakeNFTTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableStakeNFT *ImmutableStakeNFTRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableStakeNFT.Contract.ImmutableStakeNFTTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableStakeNFT *ImmutableStakeNFTCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableStakeNFT.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableStakeNFT *ImmutableStakeNFTTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableStakeNFT.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableStakeNFT *ImmutableStakeNFTTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableStakeNFT.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableStakeNFT *ImmutableStakeNFTCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ImmutableStakeNFT.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableStakeNFT *ImmutableStakeNFTSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableStakeNFT.Contract.GetMetamorphicContractAddress(&_ImmutableStakeNFT.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableStakeNFT *ImmutableStakeNFTCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableStakeNFT.Contract.GetMetamorphicContractAddress(&_ImmutableStakeNFT.CallOpts, _salt, _factory)
}
