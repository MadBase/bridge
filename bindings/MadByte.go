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

// MadByteDeposit is an auto generated low-level Go binding around an user-defined struct.
type MadByteDeposit struct {
	AccountType uint8
	Account     common.Address
	Value       *big.Int
}

// MadByteMetaData contains all meta data concerning the MadByte contract.
var MadByteMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"depositID\",\"type\":\"uint256\"},{\"indexed\":true,\"internalType\":\"uint8\",\"name\":\"accountType\",\"type\":\"uint8\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"depositor\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"DepositReceived\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"poolBalance_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"numEth_\",\"type\":\"uint256\"}],\"name\":\"EthtoMB\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"poolBalance_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"totalSupply_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"numMB_\",\"type\":\"uint256\"}],\"name\":\"MBtoEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"numEth\",\"type\":\"uint256\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"minEth_\",\"type\":\"uint256\"}],\"name\":\"burn\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"numEth\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"minEth_\",\"type\":\"uint256\"}],\"name\":\"burnTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"numEth\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"subtractedValue\",\"type\":\"uint256\"}],\"name\":\"decreaseAllowance\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"accountType_\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"deposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"distribute\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"minerAmount\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"stakingAmount\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lpStakingAmount\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"foundationAmount\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getAdmin\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"depositID\",\"type\":\"uint256\"}],\"name\":\"getDeposit\",\"outputs\":[{\"components\":[{\"internalType\":\"uint8\",\"name\":\"accountType\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"}],\"internalType\":\"structMadByte.Deposit\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getPoolBalance\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalMadBytesDeposited\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"addedValue\",\"type\":\"uint256\"}],\"name\":\"increaseAllowance\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"initialize\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"minMB_\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"nuMB\",\"type\":\"uint256\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"accountType_\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"minMB_\",\"type\":\"uint256\"}],\"name\":\"mintDeposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"minMB_\",\"type\":\"uint256\"}],\"name\":\"mintTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"nuMB\",\"type\":\"uint256\"}],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"admin_\",\"type\":\"address\"}],\"name\":\"setAdmin\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"minerStakingSplit_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"madStakingSplit_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lpStakingSplit_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"protocolFee_\",\"type\":\"uint256\"}],\"name\":\"setSplits\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"accountType_\",\"type\":\"uint8\"},{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"virtualMintDeposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// MadByteABI is the input ABI used to generate the binding from.
// Deprecated: Use MadByteMetaData.ABI instead.
var MadByteABI = MadByteMetaData.ABI

// MadByte is an auto generated Go binding around an Ethereum contract.
type MadByte struct {
	MadByteCaller     // Read-only binding to the contract
	MadByteTransactor // Write-only binding to the contract
	MadByteFilterer   // Log filterer for contract events
}

// MadByteCaller is an auto generated read-only Go binding around an Ethereum contract.
type MadByteCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MadByteTransactor is an auto generated write-only Go binding around an Ethereum contract.
type MadByteTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MadByteFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type MadByteFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// MadByteSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type MadByteSession struct {
	Contract     *MadByte          // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// MadByteCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type MadByteCallerSession struct {
	Contract *MadByteCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts  // Call options to use throughout this session
}

// MadByteTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type MadByteTransactorSession struct {
	Contract     *MadByteTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// MadByteRaw is an auto generated low-level Go binding around an Ethereum contract.
type MadByteRaw struct {
	Contract *MadByte // Generic contract binding to access the raw methods on
}

// MadByteCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type MadByteCallerRaw struct {
	Contract *MadByteCaller // Generic read-only contract binding to access the raw methods on
}

// MadByteTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type MadByteTransactorRaw struct {
	Contract *MadByteTransactor // Generic write-only contract binding to access the raw methods on
}

// NewMadByte creates a new instance of MadByte, bound to a specific deployed contract.
func NewMadByte(address common.Address, backend bind.ContractBackend) (*MadByte, error) {
	contract, err := bindMadByte(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &MadByte{MadByteCaller: MadByteCaller{contract: contract}, MadByteTransactor: MadByteTransactor{contract: contract}, MadByteFilterer: MadByteFilterer{contract: contract}}, nil
}

// NewMadByteCaller creates a new read-only instance of MadByte, bound to a specific deployed contract.
func NewMadByteCaller(address common.Address, caller bind.ContractCaller) (*MadByteCaller, error) {
	contract, err := bindMadByte(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &MadByteCaller{contract: contract}, nil
}

// NewMadByteTransactor creates a new write-only instance of MadByte, bound to a specific deployed contract.
func NewMadByteTransactor(address common.Address, transactor bind.ContractTransactor) (*MadByteTransactor, error) {
	contract, err := bindMadByte(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &MadByteTransactor{contract: contract}, nil
}

// NewMadByteFilterer creates a new log filterer instance of MadByte, bound to a specific deployed contract.
func NewMadByteFilterer(address common.Address, filterer bind.ContractFilterer) (*MadByteFilterer, error) {
	contract, err := bindMadByte(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &MadByteFilterer{contract: contract}, nil
}

// bindMadByte binds a generic wrapper to an already deployed contract.
func bindMadByte(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(MadByteABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_MadByte *MadByteRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _MadByte.Contract.MadByteCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_MadByte *MadByteRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MadByte.Contract.MadByteTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_MadByte *MadByteRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _MadByte.Contract.MadByteTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_MadByte *MadByteCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _MadByte.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_MadByte *MadByteTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MadByte.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_MadByte *MadByteTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _MadByte.Contract.contract.Transact(opts, method, params...)
}

// EthtoMB is a free data retrieval call binding the contract method 0x60f89f19.
//
// Solidity: function EthtoMB(uint256 poolBalance_, uint256 numEth_) pure returns(uint256)
func (_MadByte *MadByteCaller) EthtoMB(opts *bind.CallOpts, poolBalance_ *big.Int, numEth_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "EthtoMB", poolBalance_, numEth_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EthtoMB is a free data retrieval call binding the contract method 0x60f89f19.
//
// Solidity: function EthtoMB(uint256 poolBalance_, uint256 numEth_) pure returns(uint256)
func (_MadByte *MadByteSession) EthtoMB(poolBalance_ *big.Int, numEth_ *big.Int) (*big.Int, error) {
	return _MadByte.Contract.EthtoMB(&_MadByte.CallOpts, poolBalance_, numEth_)
}

// EthtoMB is a free data retrieval call binding the contract method 0x60f89f19.
//
// Solidity: function EthtoMB(uint256 poolBalance_, uint256 numEth_) pure returns(uint256)
func (_MadByte *MadByteCallerSession) EthtoMB(poolBalance_ *big.Int, numEth_ *big.Int) (*big.Int, error) {
	return _MadByte.Contract.EthtoMB(&_MadByte.CallOpts, poolBalance_, numEth_)
}

// MBtoEth is a free data retrieval call binding the contract method 0x9f8a3402.
//
// Solidity: function MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) pure returns(uint256 numEth)
func (_MadByte *MadByteCaller) MBtoEth(opts *bind.CallOpts, poolBalance_ *big.Int, totalSupply_ *big.Int, numMB_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "MBtoEth", poolBalance_, totalSupply_, numMB_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MBtoEth is a free data retrieval call binding the contract method 0x9f8a3402.
//
// Solidity: function MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) pure returns(uint256 numEth)
func (_MadByte *MadByteSession) MBtoEth(poolBalance_ *big.Int, totalSupply_ *big.Int, numMB_ *big.Int) (*big.Int, error) {
	return _MadByte.Contract.MBtoEth(&_MadByte.CallOpts, poolBalance_, totalSupply_, numMB_)
}

// MBtoEth is a free data retrieval call binding the contract method 0x9f8a3402.
//
// Solidity: function MBtoEth(uint256 poolBalance_, uint256 totalSupply_, uint256 numMB_) pure returns(uint256 numEth)
func (_MadByte *MadByteCallerSession) MBtoEth(poolBalance_ *big.Int, totalSupply_ *big.Int, numMB_ *big.Int) (*big.Int, error) {
	return _MadByte.Contract.MBtoEth(&_MadByte.CallOpts, poolBalance_, totalSupply_, numMB_)
}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_MadByte *MadByteCaller) Allowance(opts *bind.CallOpts, owner common.Address, spender common.Address) (*big.Int, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "allowance", owner, spender)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_MadByte *MadByteSession) Allowance(owner common.Address, spender common.Address) (*big.Int, error) {
	return _MadByte.Contract.Allowance(&_MadByte.CallOpts, owner, spender)
}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address owner, address spender) view returns(uint256)
func (_MadByte *MadByteCallerSession) Allowance(owner common.Address, spender common.Address) (*big.Int, error) {
	return _MadByte.Contract.Allowance(&_MadByte.CallOpts, owner, spender)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (_MadByte *MadByteCaller) BalanceOf(opts *bind.CallOpts, account common.Address) (*big.Int, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "balanceOf", account)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (_MadByte *MadByteSession) BalanceOf(account common.Address) (*big.Int, error) {
	return _MadByte.Contract.BalanceOf(&_MadByte.CallOpts, account)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (_MadByte *MadByteCallerSession) BalanceOf(account common.Address) (*big.Int, error) {
	return _MadByte.Contract.BalanceOf(&_MadByte.CallOpts, account)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_MadByte *MadByteCaller) Decimals(opts *bind.CallOpts) (uint8, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "decimals")

	if err != nil {
		return *new(uint8), err
	}

	out0 := *abi.ConvertType(out[0], new(uint8)).(*uint8)

	return out0, err

}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_MadByte *MadByteSession) Decimals() (uint8, error) {
	return _MadByte.Contract.Decimals(&_MadByte.CallOpts)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_MadByte *MadByteCallerSession) Decimals() (uint8, error) {
	return _MadByte.Contract.Decimals(&_MadByte.CallOpts)
}

// GetAdmin is a free data retrieval call binding the contract method 0x6e9960c3.
//
// Solidity: function getAdmin() view returns(address)
func (_MadByte *MadByteCaller) GetAdmin(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "getAdmin")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetAdmin is a free data retrieval call binding the contract method 0x6e9960c3.
//
// Solidity: function getAdmin() view returns(address)
func (_MadByte *MadByteSession) GetAdmin() (common.Address, error) {
	return _MadByte.Contract.GetAdmin(&_MadByte.CallOpts)
}

// GetAdmin is a free data retrieval call binding the contract method 0x6e9960c3.
//
// Solidity: function getAdmin() view returns(address)
func (_MadByte *MadByteCallerSession) GetAdmin() (common.Address, error) {
	return _MadByte.Contract.GetAdmin(&_MadByte.CallOpts)
}

// GetDeposit is a free data retrieval call binding the contract method 0x9f9fb968.
//
// Solidity: function getDeposit(uint256 depositID) view returns((uint8,address,uint256))
func (_MadByte *MadByteCaller) GetDeposit(opts *bind.CallOpts, depositID *big.Int) (MadByteDeposit, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "getDeposit", depositID)

	if err != nil {
		return *new(MadByteDeposit), err
	}

	out0 := *abi.ConvertType(out[0], new(MadByteDeposit)).(*MadByteDeposit)

	return out0, err

}

// GetDeposit is a free data retrieval call binding the contract method 0x9f9fb968.
//
// Solidity: function getDeposit(uint256 depositID) view returns((uint8,address,uint256))
func (_MadByte *MadByteSession) GetDeposit(depositID *big.Int) (MadByteDeposit, error) {
	return _MadByte.Contract.GetDeposit(&_MadByte.CallOpts, depositID)
}

// GetDeposit is a free data retrieval call binding the contract method 0x9f9fb968.
//
// Solidity: function getDeposit(uint256 depositID) view returns((uint8,address,uint256))
func (_MadByte *MadByteCallerSession) GetDeposit(depositID *big.Int) (MadByteDeposit, error) {
	return _MadByte.Contract.GetDeposit(&_MadByte.CallOpts, depositID)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_MadByte *MadByteCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_MadByte *MadByteSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _MadByte.Contract.GetMetamorphicContractAddress(&_MadByte.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_MadByte *MadByteCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _MadByte.Contract.GetMetamorphicContractAddress(&_MadByte.CallOpts, _salt, _factory)
}

// GetPoolBalance is a free data retrieval call binding the contract method 0xabd70aa2.
//
// Solidity: function getPoolBalance() view returns(uint256)
func (_MadByte *MadByteCaller) GetPoolBalance(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "getPoolBalance")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetPoolBalance is a free data retrieval call binding the contract method 0xabd70aa2.
//
// Solidity: function getPoolBalance() view returns(uint256)
func (_MadByte *MadByteSession) GetPoolBalance() (*big.Int, error) {
	return _MadByte.Contract.GetPoolBalance(&_MadByte.CallOpts)
}

// GetPoolBalance is a free data retrieval call binding the contract method 0xabd70aa2.
//
// Solidity: function getPoolBalance() view returns(uint256)
func (_MadByte *MadByteCallerSession) GetPoolBalance() (*big.Int, error) {
	return _MadByte.Contract.GetPoolBalance(&_MadByte.CallOpts)
}

// GetTotalMadBytesDeposited is a free data retrieval call binding the contract method 0x6957dc0e.
//
// Solidity: function getTotalMadBytesDeposited() view returns(uint256)
func (_MadByte *MadByteCaller) GetTotalMadBytesDeposited(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "getTotalMadBytesDeposited")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalMadBytesDeposited is a free data retrieval call binding the contract method 0x6957dc0e.
//
// Solidity: function getTotalMadBytesDeposited() view returns(uint256)
func (_MadByte *MadByteSession) GetTotalMadBytesDeposited() (*big.Int, error) {
	return _MadByte.Contract.GetTotalMadBytesDeposited(&_MadByte.CallOpts)
}

// GetTotalMadBytesDeposited is a free data retrieval call binding the contract method 0x6957dc0e.
//
// Solidity: function getTotalMadBytesDeposited() view returns(uint256)
func (_MadByte *MadByteCallerSession) GetTotalMadBytesDeposited() (*big.Int, error) {
	return _MadByte.Contract.GetTotalMadBytesDeposited(&_MadByte.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_MadByte *MadByteCaller) Name(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "name")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_MadByte *MadByteSession) Name() (string, error) {
	return _MadByte.Contract.Name(&_MadByte.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_MadByte *MadByteCallerSession) Name() (string, error) {
	return _MadByte.Contract.Name(&_MadByte.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_MadByte *MadByteCaller) Symbol(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "symbol")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_MadByte *MadByteSession) Symbol() (string, error) {
	return _MadByte.Contract.Symbol(&_MadByte.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_MadByte *MadByteCallerSession) Symbol() (string, error) {
	return _MadByte.Contract.Symbol(&_MadByte.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_MadByte *MadByteCaller) TotalSupply(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _MadByte.contract.Call(opts, &out, "totalSupply")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_MadByte *MadByteSession) TotalSupply() (*big.Int, error) {
	return _MadByte.Contract.TotalSupply(&_MadByte.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_MadByte *MadByteCallerSession) TotalSupply() (*big.Int, error) {
	return _MadByte.Contract.TotalSupply(&_MadByte.CallOpts)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_MadByte *MadByteTransactor) Approve(opts *bind.TransactOpts, spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "approve", spender, amount)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_MadByte *MadByteSession) Approve(spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Approve(&_MadByte.TransactOpts, spender, amount)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_MadByte *MadByteTransactorSession) Approve(spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Approve(&_MadByte.TransactOpts, spender, amount)
}

// Burn is a paid mutator transaction binding the contract method 0xb390c0ab.
//
// Solidity: function burn(uint256 amount_, uint256 minEth_) returns(uint256 numEth)
func (_MadByte *MadByteTransactor) Burn(opts *bind.TransactOpts, amount_ *big.Int, minEth_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "burn", amount_, minEth_)
}

// Burn is a paid mutator transaction binding the contract method 0xb390c0ab.
//
// Solidity: function burn(uint256 amount_, uint256 minEth_) returns(uint256 numEth)
func (_MadByte *MadByteSession) Burn(amount_ *big.Int, minEth_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Burn(&_MadByte.TransactOpts, amount_, minEth_)
}

// Burn is a paid mutator transaction binding the contract method 0xb390c0ab.
//
// Solidity: function burn(uint256 amount_, uint256 minEth_) returns(uint256 numEth)
func (_MadByte *MadByteTransactorSession) Burn(amount_ *big.Int, minEth_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Burn(&_MadByte.TransactOpts, amount_, minEth_)
}

// BurnTo is a paid mutator transaction binding the contract method 0x9b057203.
//
// Solidity: function burnTo(address to_, uint256 amount_, uint256 minEth_) returns(uint256 numEth)
func (_MadByte *MadByteTransactor) BurnTo(opts *bind.TransactOpts, to_ common.Address, amount_ *big.Int, minEth_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "burnTo", to_, amount_, minEth_)
}

// BurnTo is a paid mutator transaction binding the contract method 0x9b057203.
//
// Solidity: function burnTo(address to_, uint256 amount_, uint256 minEth_) returns(uint256 numEth)
func (_MadByte *MadByteSession) BurnTo(to_ common.Address, amount_ *big.Int, minEth_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.BurnTo(&_MadByte.TransactOpts, to_, amount_, minEth_)
}

// BurnTo is a paid mutator transaction binding the contract method 0x9b057203.
//
// Solidity: function burnTo(address to_, uint256 amount_, uint256 minEth_) returns(uint256 numEth)
func (_MadByte *MadByteTransactorSession) BurnTo(to_ common.Address, amount_ *big.Int, minEth_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.BurnTo(&_MadByte.TransactOpts, to_, amount_, minEth_)
}

// DecreaseAllowance is a paid mutator transaction binding the contract method 0xa457c2d7.
//
// Solidity: function decreaseAllowance(address spender, uint256 subtractedValue) returns(bool)
func (_MadByte *MadByteTransactor) DecreaseAllowance(opts *bind.TransactOpts, spender common.Address, subtractedValue *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "decreaseAllowance", spender, subtractedValue)
}

// DecreaseAllowance is a paid mutator transaction binding the contract method 0xa457c2d7.
//
// Solidity: function decreaseAllowance(address spender, uint256 subtractedValue) returns(bool)
func (_MadByte *MadByteSession) DecreaseAllowance(spender common.Address, subtractedValue *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.DecreaseAllowance(&_MadByte.TransactOpts, spender, subtractedValue)
}

// DecreaseAllowance is a paid mutator transaction binding the contract method 0xa457c2d7.
//
// Solidity: function decreaseAllowance(address spender, uint256 subtractedValue) returns(bool)
func (_MadByte *MadByteTransactorSession) DecreaseAllowance(spender common.Address, subtractedValue *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.DecreaseAllowance(&_MadByte.TransactOpts, spender, subtractedValue)
}

// Deposit is a paid mutator transaction binding the contract method 0x00838172.
//
// Solidity: function deposit(uint8 accountType_, address to_, uint256 amount_) returns(uint256)
func (_MadByte *MadByteTransactor) Deposit(opts *bind.TransactOpts, accountType_ uint8, to_ common.Address, amount_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "deposit", accountType_, to_, amount_)
}

// Deposit is a paid mutator transaction binding the contract method 0x00838172.
//
// Solidity: function deposit(uint8 accountType_, address to_, uint256 amount_) returns(uint256)
func (_MadByte *MadByteSession) Deposit(accountType_ uint8, to_ common.Address, amount_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Deposit(&_MadByte.TransactOpts, accountType_, to_, amount_)
}

// Deposit is a paid mutator transaction binding the contract method 0x00838172.
//
// Solidity: function deposit(uint8 accountType_, address to_, uint256 amount_) returns(uint256)
func (_MadByte *MadByteTransactorSession) Deposit(accountType_ uint8, to_ common.Address, amount_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Deposit(&_MadByte.TransactOpts, accountType_, to_, amount_)
}

// Distribute is a paid mutator transaction binding the contract method 0xe4fc6b6d.
//
// Solidity: function distribute() returns(uint256 minerAmount, uint256 stakingAmount, uint256 lpStakingAmount, uint256 foundationAmount)
func (_MadByte *MadByteTransactor) Distribute(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "distribute")
}

// Distribute is a paid mutator transaction binding the contract method 0xe4fc6b6d.
//
// Solidity: function distribute() returns(uint256 minerAmount, uint256 stakingAmount, uint256 lpStakingAmount, uint256 foundationAmount)
func (_MadByte *MadByteSession) Distribute() (*types.Transaction, error) {
	return _MadByte.Contract.Distribute(&_MadByte.TransactOpts)
}

// Distribute is a paid mutator transaction binding the contract method 0xe4fc6b6d.
//
// Solidity: function distribute() returns(uint256 minerAmount, uint256 stakingAmount, uint256 lpStakingAmount, uint256 foundationAmount)
func (_MadByte *MadByteTransactorSession) Distribute() (*types.Transaction, error) {
	return _MadByte.Contract.Distribute(&_MadByte.TransactOpts)
}

// IncreaseAllowance is a paid mutator transaction binding the contract method 0x39509351.
//
// Solidity: function increaseAllowance(address spender, uint256 addedValue) returns(bool)
func (_MadByte *MadByteTransactor) IncreaseAllowance(opts *bind.TransactOpts, spender common.Address, addedValue *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "increaseAllowance", spender, addedValue)
}

// IncreaseAllowance is a paid mutator transaction binding the contract method 0x39509351.
//
// Solidity: function increaseAllowance(address spender, uint256 addedValue) returns(bool)
func (_MadByte *MadByteSession) IncreaseAllowance(spender common.Address, addedValue *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.IncreaseAllowance(&_MadByte.TransactOpts, spender, addedValue)
}

// IncreaseAllowance is a paid mutator transaction binding the contract method 0x39509351.
//
// Solidity: function increaseAllowance(address spender, uint256 addedValue) returns(bool)
func (_MadByte *MadByteTransactorSession) IncreaseAllowance(spender common.Address, addedValue *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.IncreaseAllowance(&_MadByte.TransactOpts, spender, addedValue)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_MadByte *MadByteTransactor) Initialize(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "initialize")
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_MadByte *MadByteSession) Initialize() (*types.Transaction, error) {
	return _MadByte.Contract.Initialize(&_MadByte.TransactOpts)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_MadByte *MadByteTransactorSession) Initialize() (*types.Transaction, error) {
	return _MadByte.Contract.Initialize(&_MadByte.TransactOpts)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 minMB_) payable returns(uint256 nuMB)
func (_MadByte *MadByteTransactor) Mint(opts *bind.TransactOpts, minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "mint", minMB_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 minMB_) payable returns(uint256 nuMB)
func (_MadByte *MadByteSession) Mint(minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Mint(&_MadByte.TransactOpts, minMB_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 minMB_) payable returns(uint256 nuMB)
func (_MadByte *MadByteTransactorSession) Mint(minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Mint(&_MadByte.TransactOpts, minMB_)
}

// MintDeposit is a paid mutator transaction binding the contract method 0x4f232628.
//
// Solidity: function mintDeposit(uint8 accountType_, address to_, uint256 minMB_) payable returns(uint256)
func (_MadByte *MadByteTransactor) MintDeposit(opts *bind.TransactOpts, accountType_ uint8, to_ common.Address, minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "mintDeposit", accountType_, to_, minMB_)
}

// MintDeposit is a paid mutator transaction binding the contract method 0x4f232628.
//
// Solidity: function mintDeposit(uint8 accountType_, address to_, uint256 minMB_) payable returns(uint256)
func (_MadByte *MadByteSession) MintDeposit(accountType_ uint8, to_ common.Address, minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.MintDeposit(&_MadByte.TransactOpts, accountType_, to_, minMB_)
}

// MintDeposit is a paid mutator transaction binding the contract method 0x4f232628.
//
// Solidity: function mintDeposit(uint8 accountType_, address to_, uint256 minMB_) payable returns(uint256)
func (_MadByte *MadByteTransactorSession) MintDeposit(accountType_ uint8, to_ common.Address, minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.MintDeposit(&_MadByte.TransactOpts, accountType_, to_, minMB_)
}

// MintTo is a paid mutator transaction binding the contract method 0x449a52f8.
//
// Solidity: function mintTo(address to_, uint256 minMB_) payable returns(uint256 nuMB)
func (_MadByte *MadByteTransactor) MintTo(opts *bind.TransactOpts, to_ common.Address, minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "mintTo", to_, minMB_)
}

// MintTo is a paid mutator transaction binding the contract method 0x449a52f8.
//
// Solidity: function mintTo(address to_, uint256 minMB_) payable returns(uint256 nuMB)
func (_MadByte *MadByteSession) MintTo(to_ common.Address, minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.MintTo(&_MadByte.TransactOpts, to_, minMB_)
}

// MintTo is a paid mutator transaction binding the contract method 0x449a52f8.
//
// Solidity: function mintTo(address to_, uint256 minMB_) payable returns(uint256 nuMB)
func (_MadByte *MadByteTransactorSession) MintTo(to_ common.Address, minMB_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.MintTo(&_MadByte.TransactOpts, to_, minMB_)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address admin_) returns()
func (_MadByte *MadByteTransactor) SetAdmin(opts *bind.TransactOpts, admin_ common.Address) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "setAdmin", admin_)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address admin_) returns()
func (_MadByte *MadByteSession) SetAdmin(admin_ common.Address) (*types.Transaction, error) {
	return _MadByte.Contract.SetAdmin(&_MadByte.TransactOpts, admin_)
}

// SetAdmin is a paid mutator transaction binding the contract method 0x704b6c02.
//
// Solidity: function setAdmin(address admin_) returns()
func (_MadByte *MadByteTransactorSession) SetAdmin(admin_ common.Address) (*types.Transaction, error) {
	return _MadByte.Contract.SetAdmin(&_MadByte.TransactOpts, admin_)
}

// SetSplits is a paid mutator transaction binding the contract method 0x767bc1bf.
//
// Solidity: function setSplits(uint256 minerStakingSplit_, uint256 madStakingSplit_, uint256 lpStakingSplit_, uint256 protocolFee_) returns()
func (_MadByte *MadByteTransactor) SetSplits(opts *bind.TransactOpts, minerStakingSplit_ *big.Int, madStakingSplit_ *big.Int, lpStakingSplit_ *big.Int, protocolFee_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "setSplits", minerStakingSplit_, madStakingSplit_, lpStakingSplit_, protocolFee_)
}

// SetSplits is a paid mutator transaction binding the contract method 0x767bc1bf.
//
// Solidity: function setSplits(uint256 minerStakingSplit_, uint256 madStakingSplit_, uint256 lpStakingSplit_, uint256 protocolFee_) returns()
func (_MadByte *MadByteSession) SetSplits(minerStakingSplit_ *big.Int, madStakingSplit_ *big.Int, lpStakingSplit_ *big.Int, protocolFee_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.SetSplits(&_MadByte.TransactOpts, minerStakingSplit_, madStakingSplit_, lpStakingSplit_, protocolFee_)
}

// SetSplits is a paid mutator transaction binding the contract method 0x767bc1bf.
//
// Solidity: function setSplits(uint256 minerStakingSplit_, uint256 madStakingSplit_, uint256 lpStakingSplit_, uint256 protocolFee_) returns()
func (_MadByte *MadByteTransactorSession) SetSplits(minerStakingSplit_ *big.Int, madStakingSplit_ *big.Int, lpStakingSplit_ *big.Int, protocolFee_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.SetSplits(&_MadByte.TransactOpts, minerStakingSplit_, madStakingSplit_, lpStakingSplit_, protocolFee_)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_MadByte *MadByteTransactor) Transfer(opts *bind.TransactOpts, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "transfer", to, amount)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_MadByte *MadByteSession) Transfer(to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Transfer(&_MadByte.TransactOpts, to, amount)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_MadByte *MadByteTransactorSession) Transfer(to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.Transfer(&_MadByte.TransactOpts, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_MadByte *MadByteTransactor) TransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "transferFrom", from, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_MadByte *MadByteSession) TransferFrom(from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.TransferFrom(&_MadByte.TransactOpts, from, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_MadByte *MadByteTransactorSession) TransferFrom(from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.TransferFrom(&_MadByte.TransactOpts, from, to, amount)
}

// VirtualMintDeposit is a paid mutator transaction binding the contract method 0x92178278.
//
// Solidity: function virtualMintDeposit(uint8 accountType_, address to_, uint256 amount_) returns(uint256)
func (_MadByte *MadByteTransactor) VirtualMintDeposit(opts *bind.TransactOpts, accountType_ uint8, to_ common.Address, amount_ *big.Int) (*types.Transaction, error) {
	return _MadByte.contract.Transact(opts, "virtualMintDeposit", accountType_, to_, amount_)
}

// VirtualMintDeposit is a paid mutator transaction binding the contract method 0x92178278.
//
// Solidity: function virtualMintDeposit(uint8 accountType_, address to_, uint256 amount_) returns(uint256)
func (_MadByte *MadByteSession) VirtualMintDeposit(accountType_ uint8, to_ common.Address, amount_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.VirtualMintDeposit(&_MadByte.TransactOpts, accountType_, to_, amount_)
}

// VirtualMintDeposit is a paid mutator transaction binding the contract method 0x92178278.
//
// Solidity: function virtualMintDeposit(uint8 accountType_, address to_, uint256 amount_) returns(uint256)
func (_MadByte *MadByteTransactorSession) VirtualMintDeposit(accountType_ uint8, to_ common.Address, amount_ *big.Int) (*types.Transaction, error) {
	return _MadByte.Contract.VirtualMintDeposit(&_MadByte.TransactOpts, accountType_, to_, amount_)
}

// MadByteApprovalIterator is returned from FilterApproval and is used to iterate over the raw logs and unpacked data for Approval events raised by the MadByte contract.
type MadByteApprovalIterator struct {
	Event *MadByteApproval // Event containing the contract specifics and raw log

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
func (it *MadByteApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadByteApproval)
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
		it.Event = new(MadByteApproval)
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
func (it *MadByteApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadByteApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadByteApproval represents a Approval event raised by the MadByte contract.
type MadByteApproval struct {
	Owner   common.Address
	Spender common.Address
	Value   *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterApproval is a free log retrieval operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_MadByte *MadByteFilterer) FilterApproval(opts *bind.FilterOpts, owner []common.Address, spender []common.Address) (*MadByteApprovalIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _MadByte.contract.FilterLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return &MadByteApprovalIterator{contract: _MadByte.contract, event: "Approval", logs: logs, sub: sub}, nil
}

// WatchApproval is a free log subscription operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_MadByte *MadByteFilterer) WatchApproval(opts *bind.WatchOpts, sink chan<- *MadByteApproval, owner []common.Address, spender []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _MadByte.contract.WatchLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadByteApproval)
				if err := _MadByte.contract.UnpackLog(event, "Approval", log); err != nil {
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

// ParseApproval is a log parse operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 value)
func (_MadByte *MadByteFilterer) ParseApproval(log types.Log) (*MadByteApproval, error) {
	event := new(MadByteApproval)
	if err := _MadByte.contract.UnpackLog(event, "Approval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MadByteDepositReceivedIterator is returned from FilterDepositReceived and is used to iterate over the raw logs and unpacked data for DepositReceived events raised by the MadByte contract.
type MadByteDepositReceivedIterator struct {
	Event *MadByteDepositReceived // Event containing the contract specifics and raw log

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
func (it *MadByteDepositReceivedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadByteDepositReceived)
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
		it.Event = new(MadByteDepositReceived)
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
func (it *MadByteDepositReceivedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadByteDepositReceivedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadByteDepositReceived represents a DepositReceived event raised by the MadByte contract.
type MadByteDepositReceived struct {
	DepositID   *big.Int
	AccountType uint8
	Depositor   common.Address
	Amount      *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterDepositReceived is a free log retrieval operation binding the contract event 0x9d291e7244fa9bf5a85ec47d5a52012ccc92231b41c94308155ad2702eef9d4d.
//
// Solidity: event DepositReceived(uint256 indexed depositID, uint8 indexed accountType, address indexed depositor, uint256 amount)
func (_MadByte *MadByteFilterer) FilterDepositReceived(opts *bind.FilterOpts, depositID []*big.Int, accountType []uint8, depositor []common.Address) (*MadByteDepositReceivedIterator, error) {

	var depositIDRule []interface{}
	for _, depositIDItem := range depositID {
		depositIDRule = append(depositIDRule, depositIDItem)
	}
	var accountTypeRule []interface{}
	for _, accountTypeItem := range accountType {
		accountTypeRule = append(accountTypeRule, accountTypeItem)
	}
	var depositorRule []interface{}
	for _, depositorItem := range depositor {
		depositorRule = append(depositorRule, depositorItem)
	}

	logs, sub, err := _MadByte.contract.FilterLogs(opts, "DepositReceived", depositIDRule, accountTypeRule, depositorRule)
	if err != nil {
		return nil, err
	}
	return &MadByteDepositReceivedIterator{contract: _MadByte.contract, event: "DepositReceived", logs: logs, sub: sub}, nil
}

// WatchDepositReceived is a free log subscription operation binding the contract event 0x9d291e7244fa9bf5a85ec47d5a52012ccc92231b41c94308155ad2702eef9d4d.
//
// Solidity: event DepositReceived(uint256 indexed depositID, uint8 indexed accountType, address indexed depositor, uint256 amount)
func (_MadByte *MadByteFilterer) WatchDepositReceived(opts *bind.WatchOpts, sink chan<- *MadByteDepositReceived, depositID []*big.Int, accountType []uint8, depositor []common.Address) (event.Subscription, error) {

	var depositIDRule []interface{}
	for _, depositIDItem := range depositID {
		depositIDRule = append(depositIDRule, depositIDItem)
	}
	var accountTypeRule []interface{}
	for _, accountTypeItem := range accountType {
		accountTypeRule = append(accountTypeRule, accountTypeItem)
	}
	var depositorRule []interface{}
	for _, depositorItem := range depositor {
		depositorRule = append(depositorRule, depositorItem)
	}

	logs, sub, err := _MadByte.contract.WatchLogs(opts, "DepositReceived", depositIDRule, accountTypeRule, depositorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadByteDepositReceived)
				if err := _MadByte.contract.UnpackLog(event, "DepositReceived", log); err != nil {
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

// ParseDepositReceived is a log parse operation binding the contract event 0x9d291e7244fa9bf5a85ec47d5a52012ccc92231b41c94308155ad2702eef9d4d.
//
// Solidity: event DepositReceived(uint256 indexed depositID, uint8 indexed accountType, address indexed depositor, uint256 amount)
func (_MadByte *MadByteFilterer) ParseDepositReceived(log types.Log) (*MadByteDepositReceived, error) {
	event := new(MadByteDepositReceived)
	if err := _MadByte.contract.UnpackLog(event, "DepositReceived", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// MadByteTransferIterator is returned from FilterTransfer and is used to iterate over the raw logs and unpacked data for Transfer events raised by the MadByte contract.
type MadByteTransferIterator struct {
	Event *MadByteTransfer // Event containing the contract specifics and raw log

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
func (it *MadByteTransferIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(MadByteTransfer)
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
		it.Event = new(MadByteTransfer)
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
func (it *MadByteTransferIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *MadByteTransferIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// MadByteTransfer represents a Transfer event raised by the MadByte contract.
type MadByteTransfer struct {
	From  common.Address
	To    common.Address
	Value *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterTransfer is a free log retrieval operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_MadByte *MadByteFilterer) FilterTransfer(opts *bind.FilterOpts, from []common.Address, to []common.Address) (*MadByteTransferIterator, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _MadByte.contract.FilterLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return &MadByteTransferIterator{contract: _MadByte.contract, event: "Transfer", logs: logs, sub: sub}, nil
}

// WatchTransfer is a free log subscription operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_MadByte *MadByteFilterer) WatchTransfer(opts *bind.WatchOpts, sink chan<- *MadByteTransfer, from []common.Address, to []common.Address) (event.Subscription, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _MadByte.contract.WatchLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(MadByteTransfer)
				if err := _MadByte.contract.UnpackLog(event, "Transfer", log); err != nil {
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

// ParseTransfer is a log parse operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 value)
func (_MadByte *MadByteFilterer) ParseTransfer(log types.Log) (*MadByteTransfer, error) {
	event := new(MadByteTransfer)
	if err := _MadByte.contract.UnpackLog(event, "Transfer", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
