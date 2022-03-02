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

// BClaimsParserLibraryBClaims is an auto generated low-level Go binding around an user-defined struct.
type BClaimsParserLibraryBClaims struct {
	ChainId    uint32
	Height     uint32
	TxCount    uint32
	PrevBlock  [32]byte
	TxRoot     [32]byte
	StateRoot  [32]byte
	HeaderRoot [32]byte
}

// Snapshot is an auto generated low-level Go binding around an user-defined struct.
type Snapshot struct {
	CommittedAt *big.Int
	BlockClaims BClaimsParserLibraryBClaims
}

// ISnapshotsMetaData contains all meta data concerning the ISnapshots contract.
var ISnapshotsMetaData = &bind.MetaData{
	ABI: "[{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"chainId\",\"type\":\"uint256\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"epoch\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"height\",\"type\":\"uint256\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"validator\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"bool\",\"name\":\"isSafeToProceedConsensus\",\"type\":\"bool\"},{\"indexed\":false,\"internalType\":\"bytes\",\"name\":\"signatureRaw\",\"type\":\"bytes\"}],\"name\":\"SnapshotTaken\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"getBlockClaimsFromLatestSnapshot\",\"outputs\":[{\"components\":[{\"internalType\":\"uint32\",\"name\":\"chainId\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"height\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"txCount\",\"type\":\"uint32\"},{\"internalType\":\"bytes32\",\"name\":\"prevBlock\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"txRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"stateRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"headerRoot\",\"type\":\"bytes32\"}],\"internalType\":\"structBClaimsParserLibrary.BClaims\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"epoch_\",\"type\":\"uint256\"}],\"name\":\"getBlockClaimsFromSnapshot\",\"outputs\":[{\"components\":[{\"internalType\":\"uint32\",\"name\":\"chainId\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"height\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"txCount\",\"type\":\"uint32\"},{\"internalType\":\"bytes32\",\"name\":\"prevBlock\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"txRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"stateRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"headerRoot\",\"type\":\"bytes32\"}],\"internalType\":\"structBClaimsParserLibrary.BClaims\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getChainId\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getChainIdFromLatestSnapshot\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"epoch_\",\"type\":\"uint256\"}],\"name\":\"getChainIdFromSnapshot\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getCommittedHeightFromLatestSnapshot\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"epoch_\",\"type\":\"uint256\"}],\"name\":\"getCommittedHeightFromSnapshot\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getEpoch\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getEpochLength\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getLatestSnapshot\",\"outputs\":[{\"components\":[{\"internalType\":\"uint256\",\"name\":\"committedAt\",\"type\":\"uint256\"},{\"components\":[{\"internalType\":\"uint32\",\"name\":\"chainId\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"height\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"txCount\",\"type\":\"uint32\"},{\"internalType\":\"bytes32\",\"name\":\"prevBlock\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"txRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"stateRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"headerRoot\",\"type\":\"bytes32\"}],\"internalType\":\"structBClaimsParserLibrary.BClaims\",\"name\":\"blockClaims\",\"type\":\"tuple\"}],\"internalType\":\"structSnapshot\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getMadnetHeightFromLatestSnapshot\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"epoch_\",\"type\":\"uint256\"}],\"name\":\"getMadnetHeightFromSnapshot\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"epoch_\",\"type\":\"uint256\"}],\"name\":\"getSnapshot\",\"outputs\":[{\"components\":[{\"internalType\":\"uint256\",\"name\":\"committedAt\",\"type\":\"uint256\"},{\"components\":[{\"internalType\":\"uint32\",\"name\":\"chainId\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"height\",\"type\":\"uint32\"},{\"internalType\":\"uint32\",\"name\":\"txCount\",\"type\":\"uint32\"},{\"internalType\":\"bytes32\",\"name\":\"prevBlock\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"txRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"stateRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"headerRoot\",\"type\":\"bytes32\"}],\"internalType\":\"structBClaimsParserLibrary.BClaims\",\"name\":\"blockClaims\",\"type\":\"tuple\"}],\"internalType\":\"structSnapshot\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getSnapshotDesperationDelay\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getSnapshotDesperationFactor\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"numValidators\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"myIdx\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"blocksSinceDesperation\",\"type\":\"uint256\"},{\"internalType\":\"bytes32\",\"name\":\"blsig\",\"type\":\"bytes32\"},{\"internalType\":\"uint256\",\"name\":\"desperationFactor\",\"type\":\"uint256\"}],\"name\":\"mayValidatorSnapshot\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint32\",\"name\":\"desperationDelay_\",\"type\":\"uint32\"}],\"name\":\"setSnapshotDesperationDelay\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint32\",\"name\":\"desperationFactor_\",\"type\":\"uint32\"}],\"name\":\"setSnapshotDesperationFactor\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"signatureGroup_\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"bClaims_\",\"type\":\"bytes\"}],\"name\":\"snapshot\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// ISnapshotsABI is the input ABI used to generate the binding from.
// Deprecated: Use ISnapshotsMetaData.ABI instead.
var ISnapshotsABI = ISnapshotsMetaData.ABI

// ISnapshots is an auto generated Go binding around an Ethereum contract.
type ISnapshots struct {
	ISnapshotsCaller     // Read-only binding to the contract
	ISnapshotsTransactor // Write-only binding to the contract
	ISnapshotsFilterer   // Log filterer for contract events
}

// ISnapshotsCaller is an auto generated read-only Go binding around an Ethereum contract.
type ISnapshotsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ISnapshotsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ISnapshotsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ISnapshotsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ISnapshotsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ISnapshotsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ISnapshotsSession struct {
	Contract     *ISnapshots       // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ISnapshotsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ISnapshotsCallerSession struct {
	Contract *ISnapshotsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts     // Call options to use throughout this session
}

// ISnapshotsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ISnapshotsTransactorSession struct {
	Contract     *ISnapshotsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts     // Transaction auth options to use throughout this session
}

// ISnapshotsRaw is an auto generated low-level Go binding around an Ethereum contract.
type ISnapshotsRaw struct {
	Contract *ISnapshots // Generic contract binding to access the raw methods on
}

// ISnapshotsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ISnapshotsCallerRaw struct {
	Contract *ISnapshotsCaller // Generic read-only contract binding to access the raw methods on
}

// ISnapshotsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ISnapshotsTransactorRaw struct {
	Contract *ISnapshotsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewISnapshots creates a new instance of ISnapshots, bound to a specific deployed contract.
func NewISnapshots(address common.Address, backend bind.ContractBackend) (*ISnapshots, error) {
	contract, err := bindISnapshots(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ISnapshots{ISnapshotsCaller: ISnapshotsCaller{contract: contract}, ISnapshotsTransactor: ISnapshotsTransactor{contract: contract}, ISnapshotsFilterer: ISnapshotsFilterer{contract: contract}}, nil
}

// NewISnapshotsCaller creates a new read-only instance of ISnapshots, bound to a specific deployed contract.
func NewISnapshotsCaller(address common.Address, caller bind.ContractCaller) (*ISnapshotsCaller, error) {
	contract, err := bindISnapshots(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ISnapshotsCaller{contract: contract}, nil
}

// NewISnapshotsTransactor creates a new write-only instance of ISnapshots, bound to a specific deployed contract.
func NewISnapshotsTransactor(address common.Address, transactor bind.ContractTransactor) (*ISnapshotsTransactor, error) {
	contract, err := bindISnapshots(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ISnapshotsTransactor{contract: contract}, nil
}

// NewISnapshotsFilterer creates a new log filterer instance of ISnapshots, bound to a specific deployed contract.
func NewISnapshotsFilterer(address common.Address, filterer bind.ContractFilterer) (*ISnapshotsFilterer, error) {
	contract, err := bindISnapshots(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ISnapshotsFilterer{contract: contract}, nil
}

// bindISnapshots binds a generic wrapper to an already deployed contract.
func bindISnapshots(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ISnapshotsABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ISnapshots *ISnapshotsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ISnapshots.Contract.ISnapshotsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ISnapshots *ISnapshotsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ISnapshots.Contract.ISnapshotsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ISnapshots *ISnapshotsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ISnapshots.Contract.ISnapshotsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ISnapshots *ISnapshotsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ISnapshots.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ISnapshots *ISnapshotsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ISnapshots.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ISnapshots *ISnapshotsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ISnapshots.Contract.contract.Transact(opts, method, params...)
}

// GetBlockClaimsFromLatestSnapshot is a free data retrieval call binding the contract method 0xc2ea6603.
//
// Solidity: function getBlockClaimsFromLatestSnapshot() view returns((uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32))
func (_ISnapshots *ISnapshotsCaller) GetBlockClaimsFromLatestSnapshot(opts *bind.CallOpts) (BClaimsParserLibraryBClaims, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getBlockClaimsFromLatestSnapshot")

	if err != nil {
		return *new(BClaimsParserLibraryBClaims), err
	}

	out0 := *abi.ConvertType(out[0], new(BClaimsParserLibraryBClaims)).(*BClaimsParserLibraryBClaims)

	return out0, err

}

// GetBlockClaimsFromLatestSnapshot is a free data retrieval call binding the contract method 0xc2ea6603.
//
// Solidity: function getBlockClaimsFromLatestSnapshot() view returns((uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32))
func (_ISnapshots *ISnapshotsSession) GetBlockClaimsFromLatestSnapshot() (BClaimsParserLibraryBClaims, error) {
	return _ISnapshots.Contract.GetBlockClaimsFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetBlockClaimsFromLatestSnapshot is a free data retrieval call binding the contract method 0xc2ea6603.
//
// Solidity: function getBlockClaimsFromLatestSnapshot() view returns((uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32))
func (_ISnapshots *ISnapshotsCallerSession) GetBlockClaimsFromLatestSnapshot() (BClaimsParserLibraryBClaims, error) {
	return _ISnapshots.Contract.GetBlockClaimsFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetBlockClaimsFromSnapshot is a free data retrieval call binding the contract method 0x45dfc599.
//
// Solidity: function getBlockClaimsFromSnapshot(uint256 epoch_) view returns((uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32))
func (_ISnapshots *ISnapshotsCaller) GetBlockClaimsFromSnapshot(opts *bind.CallOpts, epoch_ *big.Int) (BClaimsParserLibraryBClaims, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getBlockClaimsFromSnapshot", epoch_)

	if err != nil {
		return *new(BClaimsParserLibraryBClaims), err
	}

	out0 := *abi.ConvertType(out[0], new(BClaimsParserLibraryBClaims)).(*BClaimsParserLibraryBClaims)

	return out0, err

}

// GetBlockClaimsFromSnapshot is a free data retrieval call binding the contract method 0x45dfc599.
//
// Solidity: function getBlockClaimsFromSnapshot(uint256 epoch_) view returns((uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32))
func (_ISnapshots *ISnapshotsSession) GetBlockClaimsFromSnapshot(epoch_ *big.Int) (BClaimsParserLibraryBClaims, error) {
	return _ISnapshots.Contract.GetBlockClaimsFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetBlockClaimsFromSnapshot is a free data retrieval call binding the contract method 0x45dfc599.
//
// Solidity: function getBlockClaimsFromSnapshot(uint256 epoch_) view returns((uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32))
func (_ISnapshots *ISnapshotsCallerSession) GetBlockClaimsFromSnapshot(epoch_ *big.Int) (BClaimsParserLibraryBClaims, error) {
	return _ISnapshots.Contract.GetBlockClaimsFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetChainId is a free data retrieval call binding the contract method 0x3408e470.
//
// Solidity: function getChainId() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetChainId(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getChainId")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetChainId is a free data retrieval call binding the contract method 0x3408e470.
//
// Solidity: function getChainId() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetChainId() (*big.Int, error) {
	return _ISnapshots.Contract.GetChainId(&_ISnapshots.CallOpts)
}

// GetChainId is a free data retrieval call binding the contract method 0x3408e470.
//
// Solidity: function getChainId() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetChainId() (*big.Int, error) {
	return _ISnapshots.Contract.GetChainId(&_ISnapshots.CallOpts)
}

// GetChainIdFromLatestSnapshot is a free data retrieval call binding the contract method 0xd9c11657.
//
// Solidity: function getChainIdFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetChainIdFromLatestSnapshot(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getChainIdFromLatestSnapshot")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetChainIdFromLatestSnapshot is a free data retrieval call binding the contract method 0xd9c11657.
//
// Solidity: function getChainIdFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetChainIdFromLatestSnapshot() (*big.Int, error) {
	return _ISnapshots.Contract.GetChainIdFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetChainIdFromLatestSnapshot is a free data retrieval call binding the contract method 0xd9c11657.
//
// Solidity: function getChainIdFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetChainIdFromLatestSnapshot() (*big.Int, error) {
	return _ISnapshots.Contract.GetChainIdFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetChainIdFromSnapshot is a free data retrieval call binding the contract method 0x19f74669.
//
// Solidity: function getChainIdFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetChainIdFromSnapshot(opts *bind.CallOpts, epoch_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getChainIdFromSnapshot", epoch_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetChainIdFromSnapshot is a free data retrieval call binding the contract method 0x19f74669.
//
// Solidity: function getChainIdFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetChainIdFromSnapshot(epoch_ *big.Int) (*big.Int, error) {
	return _ISnapshots.Contract.GetChainIdFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetChainIdFromSnapshot is a free data retrieval call binding the contract method 0x19f74669.
//
// Solidity: function getChainIdFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetChainIdFromSnapshot(epoch_ *big.Int) (*big.Int, error) {
	return _ISnapshots.Contract.GetChainIdFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetCommittedHeightFromLatestSnapshot is a free data retrieval call binding the contract method 0x026c2b7e.
//
// Solidity: function getCommittedHeightFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetCommittedHeightFromLatestSnapshot(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getCommittedHeightFromLatestSnapshot")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetCommittedHeightFromLatestSnapshot is a free data retrieval call binding the contract method 0x026c2b7e.
//
// Solidity: function getCommittedHeightFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetCommittedHeightFromLatestSnapshot() (*big.Int, error) {
	return _ISnapshots.Contract.GetCommittedHeightFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetCommittedHeightFromLatestSnapshot is a free data retrieval call binding the contract method 0x026c2b7e.
//
// Solidity: function getCommittedHeightFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetCommittedHeightFromLatestSnapshot() (*big.Int, error) {
	return _ISnapshots.Contract.GetCommittedHeightFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetCommittedHeightFromSnapshot is a free data retrieval call binding the contract method 0xe18c697a.
//
// Solidity: function getCommittedHeightFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetCommittedHeightFromSnapshot(opts *bind.CallOpts, epoch_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getCommittedHeightFromSnapshot", epoch_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetCommittedHeightFromSnapshot is a free data retrieval call binding the contract method 0xe18c697a.
//
// Solidity: function getCommittedHeightFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetCommittedHeightFromSnapshot(epoch_ *big.Int) (*big.Int, error) {
	return _ISnapshots.Contract.GetCommittedHeightFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetCommittedHeightFromSnapshot is a free data retrieval call binding the contract method 0xe18c697a.
//
// Solidity: function getCommittedHeightFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetCommittedHeightFromSnapshot(epoch_ *big.Int) (*big.Int, error) {
	return _ISnapshots.Contract.GetCommittedHeightFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetEpoch is a free data retrieval call binding the contract method 0x757991a8.
//
// Solidity: function getEpoch() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetEpoch(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getEpoch")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetEpoch is a free data retrieval call binding the contract method 0x757991a8.
//
// Solidity: function getEpoch() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetEpoch() (*big.Int, error) {
	return _ISnapshots.Contract.GetEpoch(&_ISnapshots.CallOpts)
}

// GetEpoch is a free data retrieval call binding the contract method 0x757991a8.
//
// Solidity: function getEpoch() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetEpoch() (*big.Int, error) {
	return _ISnapshots.Contract.GetEpoch(&_ISnapshots.CallOpts)
}

// GetEpochLength is a free data retrieval call binding the contract method 0xcfe8a73b.
//
// Solidity: function getEpochLength() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetEpochLength(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getEpochLength")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetEpochLength is a free data retrieval call binding the contract method 0xcfe8a73b.
//
// Solidity: function getEpochLength() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetEpochLength() (*big.Int, error) {
	return _ISnapshots.Contract.GetEpochLength(&_ISnapshots.CallOpts)
}

// GetEpochLength is a free data retrieval call binding the contract method 0xcfe8a73b.
//
// Solidity: function getEpochLength() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetEpochLength() (*big.Int, error) {
	return _ISnapshots.Contract.GetEpochLength(&_ISnapshots.CallOpts)
}

// GetLatestSnapshot is a free data retrieval call binding the contract method 0xd518f243.
//
// Solidity: function getLatestSnapshot() view returns((uint256,(uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32)))
func (_ISnapshots *ISnapshotsCaller) GetLatestSnapshot(opts *bind.CallOpts) (Snapshot, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getLatestSnapshot")

	if err != nil {
		return *new(Snapshot), err
	}

	out0 := *abi.ConvertType(out[0], new(Snapshot)).(*Snapshot)

	return out0, err

}

// GetLatestSnapshot is a free data retrieval call binding the contract method 0xd518f243.
//
// Solidity: function getLatestSnapshot() view returns((uint256,(uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32)))
func (_ISnapshots *ISnapshotsSession) GetLatestSnapshot() (Snapshot, error) {
	return _ISnapshots.Contract.GetLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetLatestSnapshot is a free data retrieval call binding the contract method 0xd518f243.
//
// Solidity: function getLatestSnapshot() view returns((uint256,(uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32)))
func (_ISnapshots *ISnapshotsCallerSession) GetLatestSnapshot() (Snapshot, error) {
	return _ISnapshots.Contract.GetLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetMadnetHeightFromLatestSnapshot is a free data retrieval call binding the contract method 0x9c262671.
//
// Solidity: function getMadnetHeightFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetMadnetHeightFromLatestSnapshot(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getMadnetHeightFromLatestSnapshot")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetMadnetHeightFromLatestSnapshot is a free data retrieval call binding the contract method 0x9c262671.
//
// Solidity: function getMadnetHeightFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetMadnetHeightFromLatestSnapshot() (*big.Int, error) {
	return _ISnapshots.Contract.GetMadnetHeightFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetMadnetHeightFromLatestSnapshot is a free data retrieval call binding the contract method 0x9c262671.
//
// Solidity: function getMadnetHeightFromLatestSnapshot() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetMadnetHeightFromLatestSnapshot() (*big.Int, error) {
	return _ISnapshots.Contract.GetMadnetHeightFromLatestSnapshot(&_ISnapshots.CallOpts)
}

// GetMadnetHeightFromSnapshot is a free data retrieval call binding the contract method 0xa8c07fc3.
//
// Solidity: function getMadnetHeightFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetMadnetHeightFromSnapshot(opts *bind.CallOpts, epoch_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getMadnetHeightFromSnapshot", epoch_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetMadnetHeightFromSnapshot is a free data retrieval call binding the contract method 0xa8c07fc3.
//
// Solidity: function getMadnetHeightFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetMadnetHeightFromSnapshot(epoch_ *big.Int) (*big.Int, error) {
	return _ISnapshots.Contract.GetMadnetHeightFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetMadnetHeightFromSnapshot is a free data retrieval call binding the contract method 0xa8c07fc3.
//
// Solidity: function getMadnetHeightFromSnapshot(uint256 epoch_) view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetMadnetHeightFromSnapshot(epoch_ *big.Int) (*big.Int, error) {
	return _ISnapshots.Contract.GetMadnetHeightFromSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetSnapshot is a free data retrieval call binding the contract method 0x76f10ad0.
//
// Solidity: function getSnapshot(uint256 epoch_) view returns((uint256,(uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32)))
func (_ISnapshots *ISnapshotsCaller) GetSnapshot(opts *bind.CallOpts, epoch_ *big.Int) (Snapshot, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getSnapshot", epoch_)

	if err != nil {
		return *new(Snapshot), err
	}

	out0 := *abi.ConvertType(out[0], new(Snapshot)).(*Snapshot)

	return out0, err

}

// GetSnapshot is a free data retrieval call binding the contract method 0x76f10ad0.
//
// Solidity: function getSnapshot(uint256 epoch_) view returns((uint256,(uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32)))
func (_ISnapshots *ISnapshotsSession) GetSnapshot(epoch_ *big.Int) (Snapshot, error) {
	return _ISnapshots.Contract.GetSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetSnapshot is a free data retrieval call binding the contract method 0x76f10ad0.
//
// Solidity: function getSnapshot(uint256 epoch_) view returns((uint256,(uint32,uint32,uint32,bytes32,bytes32,bytes32,bytes32)))
func (_ISnapshots *ISnapshotsCallerSession) GetSnapshot(epoch_ *big.Int) (Snapshot, error) {
	return _ISnapshots.Contract.GetSnapshot(&_ISnapshots.CallOpts, epoch_)
}

// GetSnapshotDesperationDelay is a free data retrieval call binding the contract method 0xd17fcc56.
//
// Solidity: function getSnapshotDesperationDelay() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetSnapshotDesperationDelay(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getSnapshotDesperationDelay")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetSnapshotDesperationDelay is a free data retrieval call binding the contract method 0xd17fcc56.
//
// Solidity: function getSnapshotDesperationDelay() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetSnapshotDesperationDelay() (*big.Int, error) {
	return _ISnapshots.Contract.GetSnapshotDesperationDelay(&_ISnapshots.CallOpts)
}

// GetSnapshotDesperationDelay is a free data retrieval call binding the contract method 0xd17fcc56.
//
// Solidity: function getSnapshotDesperationDelay() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetSnapshotDesperationDelay() (*big.Int, error) {
	return _ISnapshots.Contract.GetSnapshotDesperationDelay(&_ISnapshots.CallOpts)
}

// GetSnapshotDesperationFactor is a free data retrieval call binding the contract method 0x7cc4cce6.
//
// Solidity: function getSnapshotDesperationFactor() view returns(uint256)
func (_ISnapshots *ISnapshotsCaller) GetSnapshotDesperationFactor(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "getSnapshotDesperationFactor")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetSnapshotDesperationFactor is a free data retrieval call binding the contract method 0x7cc4cce6.
//
// Solidity: function getSnapshotDesperationFactor() view returns(uint256)
func (_ISnapshots *ISnapshotsSession) GetSnapshotDesperationFactor() (*big.Int, error) {
	return _ISnapshots.Contract.GetSnapshotDesperationFactor(&_ISnapshots.CallOpts)
}

// GetSnapshotDesperationFactor is a free data retrieval call binding the contract method 0x7cc4cce6.
//
// Solidity: function getSnapshotDesperationFactor() view returns(uint256)
func (_ISnapshots *ISnapshotsCallerSession) GetSnapshotDesperationFactor() (*big.Int, error) {
	return _ISnapshots.Contract.GetSnapshotDesperationFactor(&_ISnapshots.CallOpts)
}

// MayValidatorSnapshot is a free data retrieval call binding the contract method 0xf45fa246.
//
// Solidity: function mayValidatorSnapshot(uint256 numValidators, uint256 myIdx, uint256 blocksSinceDesperation, bytes32 blsig, uint256 desperationFactor) pure returns(bool)
func (_ISnapshots *ISnapshotsCaller) MayValidatorSnapshot(opts *bind.CallOpts, numValidators *big.Int, myIdx *big.Int, blocksSinceDesperation *big.Int, blsig [32]byte, desperationFactor *big.Int) (bool, error) {
	var out []interface{}
	err := _ISnapshots.contract.Call(opts, &out, "mayValidatorSnapshot", numValidators, myIdx, blocksSinceDesperation, blsig, desperationFactor)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// MayValidatorSnapshot is a free data retrieval call binding the contract method 0xf45fa246.
//
// Solidity: function mayValidatorSnapshot(uint256 numValidators, uint256 myIdx, uint256 blocksSinceDesperation, bytes32 blsig, uint256 desperationFactor) pure returns(bool)
func (_ISnapshots *ISnapshotsSession) MayValidatorSnapshot(numValidators *big.Int, myIdx *big.Int, blocksSinceDesperation *big.Int, blsig [32]byte, desperationFactor *big.Int) (bool, error) {
	return _ISnapshots.Contract.MayValidatorSnapshot(&_ISnapshots.CallOpts, numValidators, myIdx, blocksSinceDesperation, blsig, desperationFactor)
}

// MayValidatorSnapshot is a free data retrieval call binding the contract method 0xf45fa246.
//
// Solidity: function mayValidatorSnapshot(uint256 numValidators, uint256 myIdx, uint256 blocksSinceDesperation, bytes32 blsig, uint256 desperationFactor) pure returns(bool)
func (_ISnapshots *ISnapshotsCallerSession) MayValidatorSnapshot(numValidators *big.Int, myIdx *big.Int, blocksSinceDesperation *big.Int, blsig [32]byte, desperationFactor *big.Int) (bool, error) {
	return _ISnapshots.Contract.MayValidatorSnapshot(&_ISnapshots.CallOpts, numValidators, myIdx, blocksSinceDesperation, blsig, desperationFactor)
}

// SetSnapshotDesperationDelay is a paid mutator transaction binding the contract method 0xc2e8fef2.
//
// Solidity: function setSnapshotDesperationDelay(uint32 desperationDelay_) returns()
func (_ISnapshots *ISnapshotsTransactor) SetSnapshotDesperationDelay(opts *bind.TransactOpts, desperationDelay_ uint32) (*types.Transaction, error) {
	return _ISnapshots.contract.Transact(opts, "setSnapshotDesperationDelay", desperationDelay_)
}

// SetSnapshotDesperationDelay is a paid mutator transaction binding the contract method 0xc2e8fef2.
//
// Solidity: function setSnapshotDesperationDelay(uint32 desperationDelay_) returns()
func (_ISnapshots *ISnapshotsSession) SetSnapshotDesperationDelay(desperationDelay_ uint32) (*types.Transaction, error) {
	return _ISnapshots.Contract.SetSnapshotDesperationDelay(&_ISnapshots.TransactOpts, desperationDelay_)
}

// SetSnapshotDesperationDelay is a paid mutator transaction binding the contract method 0xc2e8fef2.
//
// Solidity: function setSnapshotDesperationDelay(uint32 desperationDelay_) returns()
func (_ISnapshots *ISnapshotsTransactorSession) SetSnapshotDesperationDelay(desperationDelay_ uint32) (*types.Transaction, error) {
	return _ISnapshots.Contract.SetSnapshotDesperationDelay(&_ISnapshots.TransactOpts, desperationDelay_)
}

// SetSnapshotDesperationFactor is a paid mutator transaction binding the contract method 0x3fa7a1ad.
//
// Solidity: function setSnapshotDesperationFactor(uint32 desperationFactor_) returns()
func (_ISnapshots *ISnapshotsTransactor) SetSnapshotDesperationFactor(opts *bind.TransactOpts, desperationFactor_ uint32) (*types.Transaction, error) {
	return _ISnapshots.contract.Transact(opts, "setSnapshotDesperationFactor", desperationFactor_)
}

// SetSnapshotDesperationFactor is a paid mutator transaction binding the contract method 0x3fa7a1ad.
//
// Solidity: function setSnapshotDesperationFactor(uint32 desperationFactor_) returns()
func (_ISnapshots *ISnapshotsSession) SetSnapshotDesperationFactor(desperationFactor_ uint32) (*types.Transaction, error) {
	return _ISnapshots.Contract.SetSnapshotDesperationFactor(&_ISnapshots.TransactOpts, desperationFactor_)
}

// SetSnapshotDesperationFactor is a paid mutator transaction binding the contract method 0x3fa7a1ad.
//
// Solidity: function setSnapshotDesperationFactor(uint32 desperationFactor_) returns()
func (_ISnapshots *ISnapshotsTransactorSession) SetSnapshotDesperationFactor(desperationFactor_ uint32) (*types.Transaction, error) {
	return _ISnapshots.Contract.SetSnapshotDesperationFactor(&_ISnapshots.TransactOpts, desperationFactor_)
}

// Snapshot is a paid mutator transaction binding the contract method 0x08ca1f25.
//
// Solidity: function snapshot(bytes signatureGroup_, bytes bClaims_) returns(bool)
func (_ISnapshots *ISnapshotsTransactor) Snapshot(opts *bind.TransactOpts, signatureGroup_ []byte, bClaims_ []byte) (*types.Transaction, error) {
	return _ISnapshots.contract.Transact(opts, "snapshot", signatureGroup_, bClaims_)
}

// Snapshot is a paid mutator transaction binding the contract method 0x08ca1f25.
//
// Solidity: function snapshot(bytes signatureGroup_, bytes bClaims_) returns(bool)
func (_ISnapshots *ISnapshotsSession) Snapshot(signatureGroup_ []byte, bClaims_ []byte) (*types.Transaction, error) {
	return _ISnapshots.Contract.Snapshot(&_ISnapshots.TransactOpts, signatureGroup_, bClaims_)
}

// Snapshot is a paid mutator transaction binding the contract method 0x08ca1f25.
//
// Solidity: function snapshot(bytes signatureGroup_, bytes bClaims_) returns(bool)
func (_ISnapshots *ISnapshotsTransactorSession) Snapshot(signatureGroup_ []byte, bClaims_ []byte) (*types.Transaction, error) {
	return _ISnapshots.Contract.Snapshot(&_ISnapshots.TransactOpts, signatureGroup_, bClaims_)
}

// ISnapshotsSnapshotTakenIterator is returned from FilterSnapshotTaken and is used to iterate over the raw logs and unpacked data for SnapshotTaken events raised by the ISnapshots contract.
type ISnapshotsSnapshotTakenIterator struct {
	Event *ISnapshotsSnapshotTaken // Event containing the contract specifics and raw log

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
func (it *ISnapshotsSnapshotTakenIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ISnapshotsSnapshotTaken)
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
		it.Event = new(ISnapshotsSnapshotTaken)
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
func (it *ISnapshotsSnapshotTakenIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ISnapshotsSnapshotTakenIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ISnapshotsSnapshotTaken represents a SnapshotTaken event raised by the ISnapshots contract.
type ISnapshotsSnapshotTaken struct {
	ChainId                  *big.Int
	Epoch                    *big.Int
	Height                   *big.Int
	Validator                common.Address
	IsSafeToProceedConsensus bool
	SignatureRaw             []byte
	Raw                      types.Log // Blockchain specific contextual infos
}

// FilterSnapshotTaken is a free log retrieval operation binding the contract event 0x24b0dff7469a7007db81d741ef90d7966936fb78bc19d667f4575ecbf56ab350.
//
// Solidity: event SnapshotTaken(uint256 chainId, uint256 indexed epoch, uint256 height, address indexed validator, bool isSafeToProceedConsensus, bytes signatureRaw)
func (_ISnapshots *ISnapshotsFilterer) FilterSnapshotTaken(opts *bind.FilterOpts, epoch []*big.Int, validator []common.Address) (*ISnapshotsSnapshotTakenIterator, error) {

	var epochRule []interface{}
	for _, epochItem := range epoch {
		epochRule = append(epochRule, epochItem)
	}

	var validatorRule []interface{}
	for _, validatorItem := range validator {
		validatorRule = append(validatorRule, validatorItem)
	}

	logs, sub, err := _ISnapshots.contract.FilterLogs(opts, "SnapshotTaken", epochRule, validatorRule)
	if err != nil {
		return nil, err
	}
	return &ISnapshotsSnapshotTakenIterator{contract: _ISnapshots.contract, event: "SnapshotTaken", logs: logs, sub: sub}, nil
}

// WatchSnapshotTaken is a free log subscription operation binding the contract event 0x24b0dff7469a7007db81d741ef90d7966936fb78bc19d667f4575ecbf56ab350.
//
// Solidity: event SnapshotTaken(uint256 chainId, uint256 indexed epoch, uint256 height, address indexed validator, bool isSafeToProceedConsensus, bytes signatureRaw)
func (_ISnapshots *ISnapshotsFilterer) WatchSnapshotTaken(opts *bind.WatchOpts, sink chan<- *ISnapshotsSnapshotTaken, epoch []*big.Int, validator []common.Address) (event.Subscription, error) {

	var epochRule []interface{}
	for _, epochItem := range epoch {
		epochRule = append(epochRule, epochItem)
	}

	var validatorRule []interface{}
	for _, validatorItem := range validator {
		validatorRule = append(validatorRule, validatorItem)
	}

	logs, sub, err := _ISnapshots.contract.WatchLogs(opts, "SnapshotTaken", epochRule, validatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ISnapshotsSnapshotTaken)
				if err := _ISnapshots.contract.UnpackLog(event, "SnapshotTaken", log); err != nil {
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

// ParseSnapshotTaken is a log parse operation binding the contract event 0x24b0dff7469a7007db81d741ef90d7966936fb78bc19d667f4575ecbf56ab350.
//
// Solidity: event SnapshotTaken(uint256 chainId, uint256 indexed epoch, uint256 height, address indexed validator, bool isSafeToProceedConsensus, bytes signatureRaw)
func (_ISnapshots *ISnapshotsFilterer) ParseSnapshotTaken(log types.Log) (*ISnapshotsSnapshotTaken, error) {
	event := new(ISnapshotsSnapshotTaken)
	if err := _ISnapshots.contract.UnpackLog(event, "SnapshotTaken", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
