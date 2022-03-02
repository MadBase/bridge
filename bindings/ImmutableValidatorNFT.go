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

// ImmutableValidatorNFTMetaData contains all meta data concerning the ImmutableValidatorNFT contract.
var ImmutableValidatorNFTMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]",
}

// ImmutableValidatorNFTABI is the input ABI used to generate the binding from.
// Deprecated: Use ImmutableValidatorNFTMetaData.ABI instead.
var ImmutableValidatorNFTABI = ImmutableValidatorNFTMetaData.ABI

// ImmutableValidatorNFT is an auto generated Go binding around an Ethereum contract.
type ImmutableValidatorNFT struct {
	ImmutableValidatorNFTCaller     // Read-only binding to the contract
	ImmutableValidatorNFTTransactor // Write-only binding to the contract
	ImmutableValidatorNFTFilterer   // Log filterer for contract events
}

// ImmutableValidatorNFTCaller is an auto generated read-only Go binding around an Ethereum contract.
type ImmutableValidatorNFTCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableValidatorNFTTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ImmutableValidatorNFTTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableValidatorNFTFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ImmutableValidatorNFTFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableValidatorNFTSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ImmutableValidatorNFTSession struct {
	Contract     *ImmutableValidatorNFT // Generic contract binding to set the session for
	CallOpts     bind.CallOpts          // Call options to use throughout this session
	TransactOpts bind.TransactOpts      // Transaction auth options to use throughout this session
}

// ImmutableValidatorNFTCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ImmutableValidatorNFTCallerSession struct {
	Contract *ImmutableValidatorNFTCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts                // Call options to use throughout this session
}

// ImmutableValidatorNFTTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ImmutableValidatorNFTTransactorSession struct {
	Contract     *ImmutableValidatorNFTTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts                // Transaction auth options to use throughout this session
}

// ImmutableValidatorNFTRaw is an auto generated low-level Go binding around an Ethereum contract.
type ImmutableValidatorNFTRaw struct {
	Contract *ImmutableValidatorNFT // Generic contract binding to access the raw methods on
}

// ImmutableValidatorNFTCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ImmutableValidatorNFTCallerRaw struct {
	Contract *ImmutableValidatorNFTCaller // Generic read-only contract binding to access the raw methods on
}

// ImmutableValidatorNFTTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ImmutableValidatorNFTTransactorRaw struct {
	Contract *ImmutableValidatorNFTTransactor // Generic write-only contract binding to access the raw methods on
}

// NewImmutableValidatorNFT creates a new instance of ImmutableValidatorNFT, bound to a specific deployed contract.
func NewImmutableValidatorNFT(address common.Address, backend bind.ContractBackend) (*ImmutableValidatorNFT, error) {
	contract, err := bindImmutableValidatorNFT(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ImmutableValidatorNFT{ImmutableValidatorNFTCaller: ImmutableValidatorNFTCaller{contract: contract}, ImmutableValidatorNFTTransactor: ImmutableValidatorNFTTransactor{contract: contract}, ImmutableValidatorNFTFilterer: ImmutableValidatorNFTFilterer{contract: contract}}, nil
}

// NewImmutableValidatorNFTCaller creates a new read-only instance of ImmutableValidatorNFT, bound to a specific deployed contract.
func NewImmutableValidatorNFTCaller(address common.Address, caller bind.ContractCaller) (*ImmutableValidatorNFTCaller, error) {
	contract, err := bindImmutableValidatorNFT(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableValidatorNFTCaller{contract: contract}, nil
}

// NewImmutableValidatorNFTTransactor creates a new write-only instance of ImmutableValidatorNFT, bound to a specific deployed contract.
func NewImmutableValidatorNFTTransactor(address common.Address, transactor bind.ContractTransactor) (*ImmutableValidatorNFTTransactor, error) {
	contract, err := bindImmutableValidatorNFT(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableValidatorNFTTransactor{contract: contract}, nil
}

// NewImmutableValidatorNFTFilterer creates a new log filterer instance of ImmutableValidatorNFT, bound to a specific deployed contract.
func NewImmutableValidatorNFTFilterer(address common.Address, filterer bind.ContractFilterer) (*ImmutableValidatorNFTFilterer, error) {
	contract, err := bindImmutableValidatorNFT(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ImmutableValidatorNFTFilterer{contract: contract}, nil
}

// bindImmutableValidatorNFT binds a generic wrapper to an already deployed contract.
func bindImmutableValidatorNFT(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ImmutableValidatorNFTABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableValidatorNFT *ImmutableValidatorNFTRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableValidatorNFT.Contract.ImmutableValidatorNFTCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableValidatorNFT *ImmutableValidatorNFTRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableValidatorNFT.Contract.ImmutableValidatorNFTTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableValidatorNFT *ImmutableValidatorNFTRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableValidatorNFT.Contract.ImmutableValidatorNFTTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableValidatorNFT *ImmutableValidatorNFTCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableValidatorNFT.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableValidatorNFT *ImmutableValidatorNFTTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableValidatorNFT.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableValidatorNFT *ImmutableValidatorNFTTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableValidatorNFT.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableValidatorNFT *ImmutableValidatorNFTCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ImmutableValidatorNFT.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableValidatorNFT *ImmutableValidatorNFTSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableValidatorNFT.Contract.GetMetamorphicContractAddress(&_ImmutableValidatorNFT.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableValidatorNFT *ImmutableValidatorNFTCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableValidatorNFT.Contract.GetMetamorphicContractAddress(&_ImmutableValidatorNFT.CallOpts, _salt, _factory)
}
