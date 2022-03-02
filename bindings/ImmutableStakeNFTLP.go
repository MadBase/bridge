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

// ImmutableStakeNFTLPMetaData contains all meta data concerning the ImmutableStakeNFTLP contract.
var ImmutableStakeNFTLPMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]",
}

// ImmutableStakeNFTLPABI is the input ABI used to generate the binding from.
// Deprecated: Use ImmutableStakeNFTLPMetaData.ABI instead.
var ImmutableStakeNFTLPABI = ImmutableStakeNFTLPMetaData.ABI

// ImmutableStakeNFTLP is an auto generated Go binding around an Ethereum contract.
type ImmutableStakeNFTLP struct {
	ImmutableStakeNFTLPCaller     // Read-only binding to the contract
	ImmutableStakeNFTLPTransactor // Write-only binding to the contract
	ImmutableStakeNFTLPFilterer   // Log filterer for contract events
}

// ImmutableStakeNFTLPCaller is an auto generated read-only Go binding around an Ethereum contract.
type ImmutableStakeNFTLPCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableStakeNFTLPTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ImmutableStakeNFTLPTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableStakeNFTLPFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ImmutableStakeNFTLPFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableStakeNFTLPSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ImmutableStakeNFTLPSession struct {
	Contract     *ImmutableStakeNFTLP // Generic contract binding to set the session for
	CallOpts     bind.CallOpts        // Call options to use throughout this session
	TransactOpts bind.TransactOpts    // Transaction auth options to use throughout this session
}

// ImmutableStakeNFTLPCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ImmutableStakeNFTLPCallerSession struct {
	Contract *ImmutableStakeNFTLPCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts              // Call options to use throughout this session
}

// ImmutableStakeNFTLPTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ImmutableStakeNFTLPTransactorSession struct {
	Contract     *ImmutableStakeNFTLPTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts              // Transaction auth options to use throughout this session
}

// ImmutableStakeNFTLPRaw is an auto generated low-level Go binding around an Ethereum contract.
type ImmutableStakeNFTLPRaw struct {
	Contract *ImmutableStakeNFTLP // Generic contract binding to access the raw methods on
}

// ImmutableStakeNFTLPCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ImmutableStakeNFTLPCallerRaw struct {
	Contract *ImmutableStakeNFTLPCaller // Generic read-only contract binding to access the raw methods on
}

// ImmutableStakeNFTLPTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ImmutableStakeNFTLPTransactorRaw struct {
	Contract *ImmutableStakeNFTLPTransactor // Generic write-only contract binding to access the raw methods on
}

// NewImmutableStakeNFTLP creates a new instance of ImmutableStakeNFTLP, bound to a specific deployed contract.
func NewImmutableStakeNFTLP(address common.Address, backend bind.ContractBackend) (*ImmutableStakeNFTLP, error) {
	contract, err := bindImmutableStakeNFTLP(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFTLP{ImmutableStakeNFTLPCaller: ImmutableStakeNFTLPCaller{contract: contract}, ImmutableStakeNFTLPTransactor: ImmutableStakeNFTLPTransactor{contract: contract}, ImmutableStakeNFTLPFilterer: ImmutableStakeNFTLPFilterer{contract: contract}}, nil
}

// NewImmutableStakeNFTLPCaller creates a new read-only instance of ImmutableStakeNFTLP, bound to a specific deployed contract.
func NewImmutableStakeNFTLPCaller(address common.Address, caller bind.ContractCaller) (*ImmutableStakeNFTLPCaller, error) {
	contract, err := bindImmutableStakeNFTLP(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFTLPCaller{contract: contract}, nil
}

// NewImmutableStakeNFTLPTransactor creates a new write-only instance of ImmutableStakeNFTLP, bound to a specific deployed contract.
func NewImmutableStakeNFTLPTransactor(address common.Address, transactor bind.ContractTransactor) (*ImmutableStakeNFTLPTransactor, error) {
	contract, err := bindImmutableStakeNFTLP(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFTLPTransactor{contract: contract}, nil
}

// NewImmutableStakeNFTLPFilterer creates a new log filterer instance of ImmutableStakeNFTLP, bound to a specific deployed contract.
func NewImmutableStakeNFTLPFilterer(address common.Address, filterer bind.ContractFilterer) (*ImmutableStakeNFTLPFilterer, error) {
	contract, err := bindImmutableStakeNFTLP(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ImmutableStakeNFTLPFilterer{contract: contract}, nil
}

// bindImmutableStakeNFTLP binds a generic wrapper to an already deployed contract.
func bindImmutableStakeNFTLP(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ImmutableStakeNFTLPABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableStakeNFTLP.Contract.ImmutableStakeNFTLPCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableStakeNFTLP.Contract.ImmutableStakeNFTLPTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableStakeNFTLP.Contract.ImmutableStakeNFTLPTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableStakeNFTLP.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableStakeNFTLP.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableStakeNFTLP.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ImmutableStakeNFTLP.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableStakeNFTLP.Contract.GetMetamorphicContractAddress(&_ImmutableStakeNFTLP.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableStakeNFTLP *ImmutableStakeNFTLPCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableStakeNFTLP.Contract.GetMetamorphicContractAddress(&_ImmutableStakeNFTLP.CallOpts, _salt, _factory)
}
