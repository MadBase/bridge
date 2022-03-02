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

// ImmutableSnapshotsMetaData contains all meta data concerning the ImmutableSnapshots contract.
var ImmutableSnapshotsMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]",
}

// ImmutableSnapshotsABI is the input ABI used to generate the binding from.
// Deprecated: Use ImmutableSnapshotsMetaData.ABI instead.
var ImmutableSnapshotsABI = ImmutableSnapshotsMetaData.ABI

// ImmutableSnapshots is an auto generated Go binding around an Ethereum contract.
type ImmutableSnapshots struct {
	ImmutableSnapshotsCaller     // Read-only binding to the contract
	ImmutableSnapshotsTransactor // Write-only binding to the contract
	ImmutableSnapshotsFilterer   // Log filterer for contract events
}

// ImmutableSnapshotsCaller is an auto generated read-only Go binding around an Ethereum contract.
type ImmutableSnapshotsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableSnapshotsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ImmutableSnapshotsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableSnapshotsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ImmutableSnapshotsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ImmutableSnapshotsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ImmutableSnapshotsSession struct {
	Contract     *ImmutableSnapshots // Generic contract binding to set the session for
	CallOpts     bind.CallOpts       // Call options to use throughout this session
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// ImmutableSnapshotsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ImmutableSnapshotsCallerSession struct {
	Contract *ImmutableSnapshotsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts             // Call options to use throughout this session
}

// ImmutableSnapshotsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ImmutableSnapshotsTransactorSession struct {
	Contract     *ImmutableSnapshotsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts             // Transaction auth options to use throughout this session
}

// ImmutableSnapshotsRaw is an auto generated low-level Go binding around an Ethereum contract.
type ImmutableSnapshotsRaw struct {
	Contract *ImmutableSnapshots // Generic contract binding to access the raw methods on
}

// ImmutableSnapshotsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ImmutableSnapshotsCallerRaw struct {
	Contract *ImmutableSnapshotsCaller // Generic read-only contract binding to access the raw methods on
}

// ImmutableSnapshotsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ImmutableSnapshotsTransactorRaw struct {
	Contract *ImmutableSnapshotsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewImmutableSnapshots creates a new instance of ImmutableSnapshots, bound to a specific deployed contract.
func NewImmutableSnapshots(address common.Address, backend bind.ContractBackend) (*ImmutableSnapshots, error) {
	contract, err := bindImmutableSnapshots(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ImmutableSnapshots{ImmutableSnapshotsCaller: ImmutableSnapshotsCaller{contract: contract}, ImmutableSnapshotsTransactor: ImmutableSnapshotsTransactor{contract: contract}, ImmutableSnapshotsFilterer: ImmutableSnapshotsFilterer{contract: contract}}, nil
}

// NewImmutableSnapshotsCaller creates a new read-only instance of ImmutableSnapshots, bound to a specific deployed contract.
func NewImmutableSnapshotsCaller(address common.Address, caller bind.ContractCaller) (*ImmutableSnapshotsCaller, error) {
	contract, err := bindImmutableSnapshots(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableSnapshotsCaller{contract: contract}, nil
}

// NewImmutableSnapshotsTransactor creates a new write-only instance of ImmutableSnapshots, bound to a specific deployed contract.
func NewImmutableSnapshotsTransactor(address common.Address, transactor bind.ContractTransactor) (*ImmutableSnapshotsTransactor, error) {
	contract, err := bindImmutableSnapshots(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ImmutableSnapshotsTransactor{contract: contract}, nil
}

// NewImmutableSnapshotsFilterer creates a new log filterer instance of ImmutableSnapshots, bound to a specific deployed contract.
func NewImmutableSnapshotsFilterer(address common.Address, filterer bind.ContractFilterer) (*ImmutableSnapshotsFilterer, error) {
	contract, err := bindImmutableSnapshots(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ImmutableSnapshotsFilterer{contract: contract}, nil
}

// bindImmutableSnapshots binds a generic wrapper to an already deployed contract.
func bindImmutableSnapshots(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ImmutableSnapshotsABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableSnapshots *ImmutableSnapshotsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableSnapshots.Contract.ImmutableSnapshotsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableSnapshots *ImmutableSnapshotsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableSnapshots.Contract.ImmutableSnapshotsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableSnapshots *ImmutableSnapshotsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableSnapshots.Contract.ImmutableSnapshotsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ImmutableSnapshots *ImmutableSnapshotsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ImmutableSnapshots.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ImmutableSnapshots *ImmutableSnapshotsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ImmutableSnapshots.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ImmutableSnapshots *ImmutableSnapshotsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ImmutableSnapshots.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableSnapshots *ImmutableSnapshotsCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ImmutableSnapshots.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableSnapshots *ImmutableSnapshotsSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableSnapshots.Contract.GetMetamorphicContractAddress(&_ImmutableSnapshots.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ImmutableSnapshots *ImmutableSnapshotsCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ImmutableSnapshots.Contract.GetMetamorphicContractAddress(&_ImmutableSnapshots.CallOpts, _salt, _factory)
}
