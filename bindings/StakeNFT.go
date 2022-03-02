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

// StakeNFTMetaData contains all meta data concerning the StakeNFT contract.
var StakeNFTMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"approved\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"bool\",\"name\":\"approved\",\"type\":\"bool\"}],\"name\":\"ApprovalForAll\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"burn\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payoutEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"payoutMadToken\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"burnTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payoutEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"payoutMadToken\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"circuitBreakerState\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectEthTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectTokenTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"magic_\",\"type\":\"uint8\"}],\"name\":\"depositEth\",\"outputs\":[],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"magic_\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"depositToken\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"estimateEthCollection\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"estimateExcessEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"estimateExcessToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"estimateTokenCollection\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getAccumulatorScaleFactor\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"getApproved\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getEthAccumulator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"accumulator\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"slush\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"getPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"freeAfter\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"withdrawFreeAfter\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"accumulatorEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"accumulatorToken\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTokenAccumulator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"accumulator\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"slush\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalReserveEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalReserveMadToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalShares\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"initialize\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"}],\"name\":\"isApprovedForAll\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockOwnPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"caller_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockWithdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"mintTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"ownerOf\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"safeTransferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"},{\"internalType\":\"bytes\",\"name\":\"_data\",\"type\":\"bytes\"}],\"name\":\"safeTransferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"},{\"internalType\":\"bool\",\"name\":\"approved\",\"type\":\"bool\"}],\"name\":\"setApprovalForAll\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"}],\"name\":\"skimExcessEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"}],\"name\":\"skimExcessToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes4\",\"name\":\"interfaceId\",\"type\":\"bytes4\"}],\"name\":\"supportsInterface\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"tokenURI\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"tripCB\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// StakeNFTABI is the input ABI used to generate the binding from.
// Deprecated: Use StakeNFTMetaData.ABI instead.
var StakeNFTABI = StakeNFTMetaData.ABI

// StakeNFT is an auto generated Go binding around an Ethereum contract.
type StakeNFT struct {
	StakeNFTCaller     // Read-only binding to the contract
	StakeNFTTransactor // Write-only binding to the contract
	StakeNFTFilterer   // Log filterer for contract events
}

// StakeNFTCaller is an auto generated read-only Go binding around an Ethereum contract.
type StakeNFTCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// StakeNFTTransactor is an auto generated write-only Go binding around an Ethereum contract.
type StakeNFTTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// StakeNFTFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type StakeNFTFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// StakeNFTSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type StakeNFTSession struct {
	Contract     *StakeNFT         // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// StakeNFTCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type StakeNFTCallerSession struct {
	Contract *StakeNFTCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts   // Call options to use throughout this session
}

// StakeNFTTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type StakeNFTTransactorSession struct {
	Contract     *StakeNFTTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// StakeNFTRaw is an auto generated low-level Go binding around an Ethereum contract.
type StakeNFTRaw struct {
	Contract *StakeNFT // Generic contract binding to access the raw methods on
}

// StakeNFTCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type StakeNFTCallerRaw struct {
	Contract *StakeNFTCaller // Generic read-only contract binding to access the raw methods on
}

// StakeNFTTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type StakeNFTTransactorRaw struct {
	Contract *StakeNFTTransactor // Generic write-only contract binding to access the raw methods on
}

// NewStakeNFT creates a new instance of StakeNFT, bound to a specific deployed contract.
func NewStakeNFT(address common.Address, backend bind.ContractBackend) (*StakeNFT, error) {
	contract, err := bindStakeNFT(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &StakeNFT{StakeNFTCaller: StakeNFTCaller{contract: contract}, StakeNFTTransactor: StakeNFTTransactor{contract: contract}, StakeNFTFilterer: StakeNFTFilterer{contract: contract}}, nil
}

// NewStakeNFTCaller creates a new read-only instance of StakeNFT, bound to a specific deployed contract.
func NewStakeNFTCaller(address common.Address, caller bind.ContractCaller) (*StakeNFTCaller, error) {
	contract, err := bindStakeNFT(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &StakeNFTCaller{contract: contract}, nil
}

// NewStakeNFTTransactor creates a new write-only instance of StakeNFT, bound to a specific deployed contract.
func NewStakeNFTTransactor(address common.Address, transactor bind.ContractTransactor) (*StakeNFTTransactor, error) {
	contract, err := bindStakeNFT(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &StakeNFTTransactor{contract: contract}, nil
}

// NewStakeNFTFilterer creates a new log filterer instance of StakeNFT, bound to a specific deployed contract.
func NewStakeNFTFilterer(address common.Address, filterer bind.ContractFilterer) (*StakeNFTFilterer, error) {
	contract, err := bindStakeNFT(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &StakeNFTFilterer{contract: contract}, nil
}

// bindStakeNFT binds a generic wrapper to an already deployed contract.
func bindStakeNFT(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(StakeNFTABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_StakeNFT *StakeNFTRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _StakeNFT.Contract.StakeNFTCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_StakeNFT *StakeNFTRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFT.Contract.StakeNFTTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_StakeNFT *StakeNFTRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _StakeNFT.Contract.StakeNFTTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_StakeNFT *StakeNFTCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _StakeNFT.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_StakeNFT *StakeNFTTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFT.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_StakeNFT *StakeNFTTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _StakeNFT.Contract.contract.Transact(opts, method, params...)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_StakeNFT *StakeNFTCaller) BalanceOf(opts *bind.CallOpts, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "balanceOf", owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_StakeNFT *StakeNFTSession) BalanceOf(owner common.Address) (*big.Int, error) {
	return _StakeNFT.Contract.BalanceOf(&_StakeNFT.CallOpts, owner)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_StakeNFT *StakeNFTCallerSession) BalanceOf(owner common.Address) (*big.Int, error) {
	return _StakeNFT.Contract.BalanceOf(&_StakeNFT.CallOpts, owner)
}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_StakeNFT *StakeNFTCaller) CircuitBreakerState(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "circuitBreakerState")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_StakeNFT *StakeNFTSession) CircuitBreakerState() (bool, error) {
	return _StakeNFT.Contract.CircuitBreakerState(&_StakeNFT.CallOpts)
}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_StakeNFT *StakeNFTCallerSession) CircuitBreakerState() (bool, error) {
	return _StakeNFT.Contract.CircuitBreakerState(&_StakeNFT.CallOpts)
}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFT *StakeNFTCaller) EstimateEthCollection(opts *bind.CallOpts, tokenID_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "estimateEthCollection", tokenID_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFT *StakeNFTSession) EstimateEthCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFT.Contract.EstimateEthCollection(&_StakeNFT.CallOpts, tokenID_)
}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFT *StakeNFTCallerSession) EstimateEthCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFT.Contract.EstimateEthCollection(&_StakeNFT.CallOpts, tokenID_)
}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_StakeNFT *StakeNFTCaller) EstimateExcessEth(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "estimateExcessEth")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_StakeNFT *StakeNFTSession) EstimateExcessEth() (*big.Int, error) {
	return _StakeNFT.Contract.EstimateExcessEth(&_StakeNFT.CallOpts)
}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_StakeNFT *StakeNFTCallerSession) EstimateExcessEth() (*big.Int, error) {
	return _StakeNFT.Contract.EstimateExcessEth(&_StakeNFT.CallOpts)
}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_StakeNFT *StakeNFTCaller) EstimateExcessToken(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "estimateExcessToken")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_StakeNFT *StakeNFTSession) EstimateExcessToken() (*big.Int, error) {
	return _StakeNFT.Contract.EstimateExcessToken(&_StakeNFT.CallOpts)
}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_StakeNFT *StakeNFTCallerSession) EstimateExcessToken() (*big.Int, error) {
	return _StakeNFT.Contract.EstimateExcessToken(&_StakeNFT.CallOpts)
}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFT *StakeNFTCaller) EstimateTokenCollection(opts *bind.CallOpts, tokenID_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "estimateTokenCollection", tokenID_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFT *StakeNFTSession) EstimateTokenCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFT.Contract.EstimateTokenCollection(&_StakeNFT.CallOpts, tokenID_)
}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFT *StakeNFTCallerSession) EstimateTokenCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFT.Contract.EstimateTokenCollection(&_StakeNFT.CallOpts, tokenID_)
}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_StakeNFT *StakeNFTCaller) GetAccumulatorScaleFactor(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getAccumulatorScaleFactor")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_StakeNFT *StakeNFTSession) GetAccumulatorScaleFactor() (*big.Int, error) {
	return _StakeNFT.Contract.GetAccumulatorScaleFactor(&_StakeNFT.CallOpts)
}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_StakeNFT *StakeNFTCallerSession) GetAccumulatorScaleFactor() (*big.Int, error) {
	return _StakeNFT.Contract.GetAccumulatorScaleFactor(&_StakeNFT.CallOpts)
}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_StakeNFT *StakeNFTCaller) GetApproved(opts *bind.CallOpts, tokenId *big.Int) (common.Address, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getApproved", tokenId)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_StakeNFT *StakeNFTSession) GetApproved(tokenId *big.Int) (common.Address, error) {
	return _StakeNFT.Contract.GetApproved(&_StakeNFT.CallOpts, tokenId)
}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_StakeNFT *StakeNFTCallerSession) GetApproved(tokenId *big.Int) (common.Address, error) {
	return _StakeNFT.Contract.GetApproved(&_StakeNFT.CallOpts, tokenId)
}

// GetEthAccumulator is a free data retrieval call binding the contract method 0x548652d2.
//
// Solidity: function getEthAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFT *StakeNFTCaller) GetEthAccumulator(opts *bind.CallOpts) (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getEthAccumulator")

	outstruct := new(struct {
		Accumulator *big.Int
		Slush       *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.Accumulator = *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)
	outstruct.Slush = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetEthAccumulator is a free data retrieval call binding the contract method 0x548652d2.
//
// Solidity: function getEthAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFT *StakeNFTSession) GetEthAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFT.Contract.GetEthAccumulator(&_StakeNFT.CallOpts)
}

// GetEthAccumulator is a free data retrieval call binding the contract method 0x548652d2.
//
// Solidity: function getEthAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFT *StakeNFTCallerSession) GetEthAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFT.Contract.GetEthAccumulator(&_StakeNFT.CallOpts)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_StakeNFT *StakeNFTCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_StakeNFT *StakeNFTSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _StakeNFT.Contract.GetMetamorphicContractAddress(&_StakeNFT.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_StakeNFT *StakeNFTCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _StakeNFT.Contract.GetMetamorphicContractAddress(&_StakeNFT.CallOpts, _salt, _factory)
}

// GetPosition is a free data retrieval call binding the contract method 0xeb02c301.
//
// Solidity: function getPosition(uint256 tokenID_) view returns(uint256 shares, uint256 freeAfter, uint256 withdrawFreeAfter, uint256 accumulatorEth, uint256 accumulatorToken)
func (_StakeNFT *StakeNFTCaller) GetPosition(opts *bind.CallOpts, tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getPosition", tokenID_)

	outstruct := new(struct {
		Shares            *big.Int
		FreeAfter         *big.Int
		WithdrawFreeAfter *big.Int
		AccumulatorEth    *big.Int
		AccumulatorToken  *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.Shares = *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)
	outstruct.FreeAfter = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)
	outstruct.WithdrawFreeAfter = *abi.ConvertType(out[2], new(*big.Int)).(**big.Int)
	outstruct.AccumulatorEth = *abi.ConvertType(out[3], new(*big.Int)).(**big.Int)
	outstruct.AccumulatorToken = *abi.ConvertType(out[4], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetPosition is a free data retrieval call binding the contract method 0xeb02c301.
//
// Solidity: function getPosition(uint256 tokenID_) view returns(uint256 shares, uint256 freeAfter, uint256 withdrawFreeAfter, uint256 accumulatorEth, uint256 accumulatorToken)
func (_StakeNFT *StakeNFTSession) GetPosition(tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	return _StakeNFT.Contract.GetPosition(&_StakeNFT.CallOpts, tokenID_)
}

// GetPosition is a free data retrieval call binding the contract method 0xeb02c301.
//
// Solidity: function getPosition(uint256 tokenID_) view returns(uint256 shares, uint256 freeAfter, uint256 withdrawFreeAfter, uint256 accumulatorEth, uint256 accumulatorToken)
func (_StakeNFT *StakeNFTCallerSession) GetPosition(tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	return _StakeNFT.Contract.GetPosition(&_StakeNFT.CallOpts, tokenID_)
}

// GetTokenAccumulator is a free data retrieval call binding the contract method 0xc47c6e14.
//
// Solidity: function getTokenAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFT *StakeNFTCaller) GetTokenAccumulator(opts *bind.CallOpts) (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getTokenAccumulator")

	outstruct := new(struct {
		Accumulator *big.Int
		Slush       *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.Accumulator = *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)
	outstruct.Slush = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// GetTokenAccumulator is a free data retrieval call binding the contract method 0xc47c6e14.
//
// Solidity: function getTokenAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFT *StakeNFTSession) GetTokenAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFT.Contract.GetTokenAccumulator(&_StakeNFT.CallOpts)
}

// GetTokenAccumulator is a free data retrieval call binding the contract method 0xc47c6e14.
//
// Solidity: function getTokenAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFT *StakeNFTCallerSession) GetTokenAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFT.Contract.GetTokenAccumulator(&_StakeNFT.CallOpts)
}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_StakeNFT *StakeNFTCaller) GetTotalReserveEth(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getTotalReserveEth")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_StakeNFT *StakeNFTSession) GetTotalReserveEth() (*big.Int, error) {
	return _StakeNFT.Contract.GetTotalReserveEth(&_StakeNFT.CallOpts)
}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_StakeNFT *StakeNFTCallerSession) GetTotalReserveEth() (*big.Int, error) {
	return _StakeNFT.Contract.GetTotalReserveEth(&_StakeNFT.CallOpts)
}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_StakeNFT *StakeNFTCaller) GetTotalReserveMadToken(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getTotalReserveMadToken")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_StakeNFT *StakeNFTSession) GetTotalReserveMadToken() (*big.Int, error) {
	return _StakeNFT.Contract.GetTotalReserveMadToken(&_StakeNFT.CallOpts)
}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_StakeNFT *StakeNFTCallerSession) GetTotalReserveMadToken() (*big.Int, error) {
	return _StakeNFT.Contract.GetTotalReserveMadToken(&_StakeNFT.CallOpts)
}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_StakeNFT *StakeNFTCaller) GetTotalShares(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "getTotalShares")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_StakeNFT *StakeNFTSession) GetTotalShares() (*big.Int, error) {
	return _StakeNFT.Contract.GetTotalShares(&_StakeNFT.CallOpts)
}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_StakeNFT *StakeNFTCallerSession) GetTotalShares() (*big.Int, error) {
	return _StakeNFT.Contract.GetTotalShares(&_StakeNFT.CallOpts)
}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_StakeNFT *StakeNFTCaller) IsApprovedForAll(opts *bind.CallOpts, owner common.Address, operator common.Address) (bool, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "isApprovedForAll", owner, operator)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_StakeNFT *StakeNFTSession) IsApprovedForAll(owner common.Address, operator common.Address) (bool, error) {
	return _StakeNFT.Contract.IsApprovedForAll(&_StakeNFT.CallOpts, owner, operator)
}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_StakeNFT *StakeNFTCallerSession) IsApprovedForAll(owner common.Address, operator common.Address) (bool, error) {
	return _StakeNFT.Contract.IsApprovedForAll(&_StakeNFT.CallOpts, owner, operator)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_StakeNFT *StakeNFTCaller) Name(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "name")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_StakeNFT *StakeNFTSession) Name() (string, error) {
	return _StakeNFT.Contract.Name(&_StakeNFT.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_StakeNFT *StakeNFTCallerSession) Name() (string, error) {
	return _StakeNFT.Contract.Name(&_StakeNFT.CallOpts)
}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_StakeNFT *StakeNFTCaller) OwnerOf(opts *bind.CallOpts, tokenId *big.Int) (common.Address, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "ownerOf", tokenId)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_StakeNFT *StakeNFTSession) OwnerOf(tokenId *big.Int) (common.Address, error) {
	return _StakeNFT.Contract.OwnerOf(&_StakeNFT.CallOpts, tokenId)
}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_StakeNFT *StakeNFTCallerSession) OwnerOf(tokenId *big.Int) (common.Address, error) {
	return _StakeNFT.Contract.OwnerOf(&_StakeNFT.CallOpts, tokenId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_StakeNFT *StakeNFTCaller) SupportsInterface(opts *bind.CallOpts, interfaceId [4]byte) (bool, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "supportsInterface", interfaceId)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_StakeNFT *StakeNFTSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _StakeNFT.Contract.SupportsInterface(&_StakeNFT.CallOpts, interfaceId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_StakeNFT *StakeNFTCallerSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _StakeNFT.Contract.SupportsInterface(&_StakeNFT.CallOpts, interfaceId)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_StakeNFT *StakeNFTCaller) Symbol(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "symbol")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_StakeNFT *StakeNFTSession) Symbol() (string, error) {
	return _StakeNFT.Contract.Symbol(&_StakeNFT.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_StakeNFT *StakeNFTCallerSession) Symbol() (string, error) {
	return _StakeNFT.Contract.Symbol(&_StakeNFT.CallOpts)
}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_StakeNFT *StakeNFTCaller) TokenURI(opts *bind.CallOpts, tokenId *big.Int) (string, error) {
	var out []interface{}
	err := _StakeNFT.contract.Call(opts, &out, "tokenURI", tokenId)

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_StakeNFT *StakeNFTSession) TokenURI(tokenId *big.Int) (string, error) {
	return _StakeNFT.Contract.TokenURI(&_StakeNFT.CallOpts, tokenId)
}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_StakeNFT *StakeNFTCallerSession) TokenURI(tokenId *big.Int) (string, error) {
	return _StakeNFT.Contract.TokenURI(&_StakeNFT.CallOpts, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTTransactor) Approve(opts *bind.TransactOpts, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "approve", to, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTSession) Approve(to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.Approve(&_StakeNFT.TransactOpts, to, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTTransactorSession) Approve(to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.Approve(&_StakeNFT.TransactOpts, to, tokenId)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFT *StakeNFTTransactor) Burn(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "burn", tokenID_)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFT *StakeNFTSession) Burn(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.Burn(&_StakeNFT.TransactOpts, tokenID_)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFT *StakeNFTTransactorSession) Burn(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.Burn(&_StakeNFT.TransactOpts, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFT *StakeNFTTransactor) BurnTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "burnTo", to_, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFT *StakeNFTSession) BurnTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.BurnTo(&_StakeNFT.TransactOpts, to_, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFT *StakeNFTTransactorSession) BurnTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.BurnTo(&_StakeNFT.TransactOpts, to_, tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactor) CollectEth(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "collectEth", tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTSession) CollectEth(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectEth(&_StakeNFT.TransactOpts, tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactorSession) CollectEth(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectEth(&_StakeNFT.TransactOpts, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactor) CollectEthTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "collectEthTo", to_, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTSession) CollectEthTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectEthTo(&_StakeNFT.TransactOpts, to_, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactorSession) CollectEthTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectEthTo(&_StakeNFT.TransactOpts, to_, tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactor) CollectToken(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "collectToken", tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTSession) CollectToken(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectToken(&_StakeNFT.TransactOpts, tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactorSession) CollectToken(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectToken(&_StakeNFT.TransactOpts, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactor) CollectTokenTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "collectTokenTo", to_, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTSession) CollectTokenTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectTokenTo(&_StakeNFT.TransactOpts, to_, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFT *StakeNFTTransactorSession) CollectTokenTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.CollectTokenTo(&_StakeNFT.TransactOpts, to_, tokenID_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_StakeNFT *StakeNFTTransactor) DepositEth(opts *bind.TransactOpts, magic_ uint8) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "depositEth", magic_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_StakeNFT *StakeNFTSession) DepositEth(magic_ uint8) (*types.Transaction, error) {
	return _StakeNFT.Contract.DepositEth(&_StakeNFT.TransactOpts, magic_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_StakeNFT *StakeNFTTransactorSession) DepositEth(magic_ uint8) (*types.Transaction, error) {
	return _StakeNFT.Contract.DepositEth(&_StakeNFT.TransactOpts, magic_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_StakeNFT *StakeNFTTransactor) DepositToken(opts *bind.TransactOpts, magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "depositToken", magic_, amount_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_StakeNFT *StakeNFTSession) DepositToken(magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.DepositToken(&_StakeNFT.TransactOpts, magic_, amount_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_StakeNFT *StakeNFTTransactorSession) DepositToken(magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.DepositToken(&_StakeNFT.TransactOpts, magic_, amount_)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_StakeNFT *StakeNFTTransactor) Initialize(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "initialize")
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_StakeNFT *StakeNFTSession) Initialize() (*types.Transaction, error) {
	return _StakeNFT.Contract.Initialize(&_StakeNFT.TransactOpts)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_StakeNFT *StakeNFTTransactorSession) Initialize() (*types.Transaction, error) {
	return _StakeNFT.Contract.Initialize(&_StakeNFT.TransactOpts)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTTransactor) LockOwnPosition(opts *bind.TransactOpts, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "lockOwnPosition", tokenID_, lockDuration_)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTSession) LockOwnPosition(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.LockOwnPosition(&_StakeNFT.TransactOpts, tokenID_, lockDuration_)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTTransactorSession) LockOwnPosition(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.LockOwnPosition(&_StakeNFT.TransactOpts, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTTransactor) LockPosition(opts *bind.TransactOpts, caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "lockPosition", caller_, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTSession) LockPosition(caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.LockPosition(&_StakeNFT.TransactOpts, caller_, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTTransactorSession) LockPosition(caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.LockPosition(&_StakeNFT.TransactOpts, caller_, tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTTransactor) LockWithdraw(opts *bind.TransactOpts, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "lockWithdraw", tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTSession) LockWithdraw(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.LockWithdraw(&_StakeNFT.TransactOpts, tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFT *StakeNFTTransactorSession) LockWithdraw(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.LockWithdraw(&_StakeNFT.TransactOpts, tokenID_, lockDuration_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_StakeNFT *StakeNFTTransactor) Mint(opts *bind.TransactOpts, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "mint", amount_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_StakeNFT *StakeNFTSession) Mint(amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.Mint(&_StakeNFT.TransactOpts, amount_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_StakeNFT *StakeNFTTransactorSession) Mint(amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.Mint(&_StakeNFT.TransactOpts, amount_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_StakeNFT *StakeNFTTransactor) MintTo(opts *bind.TransactOpts, to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "mintTo", to_, amount_, lockDuration_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_StakeNFT *StakeNFTSession) MintTo(to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.MintTo(&_StakeNFT.TransactOpts, to_, amount_, lockDuration_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_StakeNFT *StakeNFTTransactorSession) MintTo(to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.MintTo(&_StakeNFT.TransactOpts, to_, amount_, lockDuration_)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTTransactor) SafeTransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "safeTransferFrom", from, to, tokenId)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTSession) SafeTransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.SafeTransferFrom(&_StakeNFT.TransactOpts, from, to, tokenId)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTTransactorSession) SafeTransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.SafeTransferFrom(&_StakeNFT.TransactOpts, from, to, tokenId)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_StakeNFT *StakeNFTTransactor) SafeTransferFrom0(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "safeTransferFrom0", from, to, tokenId, _data)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_StakeNFT *StakeNFTSession) SafeTransferFrom0(from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _StakeNFT.Contract.SafeTransferFrom0(&_StakeNFT.TransactOpts, from, to, tokenId, _data)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_StakeNFT *StakeNFTTransactorSession) SafeTransferFrom0(from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _StakeNFT.Contract.SafeTransferFrom0(&_StakeNFT.TransactOpts, from, to, tokenId, _data)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_StakeNFT *StakeNFTTransactor) SetApprovalForAll(opts *bind.TransactOpts, operator common.Address, approved bool) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "setApprovalForAll", operator, approved)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_StakeNFT *StakeNFTSession) SetApprovalForAll(operator common.Address, approved bool) (*types.Transaction, error) {
	return _StakeNFT.Contract.SetApprovalForAll(&_StakeNFT.TransactOpts, operator, approved)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_StakeNFT *StakeNFTTransactorSession) SetApprovalForAll(operator common.Address, approved bool) (*types.Transaction, error) {
	return _StakeNFT.Contract.SetApprovalForAll(&_StakeNFT.TransactOpts, operator, approved)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_StakeNFT *StakeNFTTransactor) SkimExcessEth(opts *bind.TransactOpts, to_ common.Address) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "skimExcessEth", to_)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_StakeNFT *StakeNFTSession) SkimExcessEth(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFT.Contract.SkimExcessEth(&_StakeNFT.TransactOpts, to_)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_StakeNFT *StakeNFTTransactorSession) SkimExcessEth(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFT.Contract.SkimExcessEth(&_StakeNFT.TransactOpts, to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_StakeNFT *StakeNFTTransactor) SkimExcessToken(opts *bind.TransactOpts, to_ common.Address) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "skimExcessToken", to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_StakeNFT *StakeNFTSession) SkimExcessToken(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFT.Contract.SkimExcessToken(&_StakeNFT.TransactOpts, to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_StakeNFT *StakeNFTTransactorSession) SkimExcessToken(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFT.Contract.SkimExcessToken(&_StakeNFT.TransactOpts, to_)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTTransactor) TransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "transferFrom", from, to, tokenId)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTSession) TransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.TransferFrom(&_StakeNFT.TransactOpts, from, to, tokenId)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFT *StakeNFTTransactorSession) TransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFT.Contract.TransferFrom(&_StakeNFT.TransactOpts, from, to, tokenId)
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_StakeNFT *StakeNFTTransactor) TripCB(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFT.contract.Transact(opts, "tripCB")
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_StakeNFT *StakeNFTSession) TripCB() (*types.Transaction, error) {
	return _StakeNFT.Contract.TripCB(&_StakeNFT.TransactOpts)
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_StakeNFT *StakeNFTTransactorSession) TripCB() (*types.Transaction, error) {
	return _StakeNFT.Contract.TripCB(&_StakeNFT.TransactOpts)
}

// StakeNFTApprovalIterator is returned from FilterApproval and is used to iterate over the raw logs and unpacked data for Approval events raised by the StakeNFT contract.
type StakeNFTApprovalIterator struct {
	Event *StakeNFTApproval // Event containing the contract specifics and raw log

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
func (it *StakeNFTApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(StakeNFTApproval)
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
		it.Event = new(StakeNFTApproval)
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
func (it *StakeNFTApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *StakeNFTApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// StakeNFTApproval represents a Approval event raised by the StakeNFT contract.
type StakeNFTApproval struct {
	Owner    common.Address
	Approved common.Address
	TokenId  *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterApproval is a free log retrieval operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
func (_StakeNFT *StakeNFTFilterer) FilterApproval(opts *bind.FilterOpts, owner []common.Address, approved []common.Address, tokenId []*big.Int) (*StakeNFTApprovalIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var approvedRule []interface{}
	for _, approvedItem := range approved {
		approvedRule = append(approvedRule, approvedItem)
	}
	var tokenIdRule []interface{}
	for _, tokenIdItem := range tokenId {
		tokenIdRule = append(tokenIdRule, tokenIdItem)
	}

	logs, sub, err := _StakeNFT.contract.FilterLogs(opts, "Approval", ownerRule, approvedRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return &StakeNFTApprovalIterator{contract: _StakeNFT.contract, event: "Approval", logs: logs, sub: sub}, nil
}

// WatchApproval is a free log subscription operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
func (_StakeNFT *StakeNFTFilterer) WatchApproval(opts *bind.WatchOpts, sink chan<- *StakeNFTApproval, owner []common.Address, approved []common.Address, tokenId []*big.Int) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var approvedRule []interface{}
	for _, approvedItem := range approved {
		approvedRule = append(approvedRule, approvedItem)
	}
	var tokenIdRule []interface{}
	for _, tokenIdItem := range tokenId {
		tokenIdRule = append(tokenIdRule, tokenIdItem)
	}

	logs, sub, err := _StakeNFT.contract.WatchLogs(opts, "Approval", ownerRule, approvedRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(StakeNFTApproval)
				if err := _StakeNFT.contract.UnpackLog(event, "Approval", log); err != nil {
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
// Solidity: event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
func (_StakeNFT *StakeNFTFilterer) ParseApproval(log types.Log) (*StakeNFTApproval, error) {
	event := new(StakeNFTApproval)
	if err := _StakeNFT.contract.UnpackLog(event, "Approval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// StakeNFTApprovalForAllIterator is returned from FilterApprovalForAll and is used to iterate over the raw logs and unpacked data for ApprovalForAll events raised by the StakeNFT contract.
type StakeNFTApprovalForAllIterator struct {
	Event *StakeNFTApprovalForAll // Event containing the contract specifics and raw log

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
func (it *StakeNFTApprovalForAllIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(StakeNFTApprovalForAll)
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
		it.Event = new(StakeNFTApprovalForAll)
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
func (it *StakeNFTApprovalForAllIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *StakeNFTApprovalForAllIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// StakeNFTApprovalForAll represents a ApprovalForAll event raised by the StakeNFT contract.
type StakeNFTApprovalForAll struct {
	Owner    common.Address
	Operator common.Address
	Approved bool
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterApprovalForAll is a free log retrieval operation binding the contract event 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31.
//
// Solidity: event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
func (_StakeNFT *StakeNFTFilterer) FilterApprovalForAll(opts *bind.FilterOpts, owner []common.Address, operator []common.Address) (*StakeNFTApprovalForAllIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}

	logs, sub, err := _StakeNFT.contract.FilterLogs(opts, "ApprovalForAll", ownerRule, operatorRule)
	if err != nil {
		return nil, err
	}
	return &StakeNFTApprovalForAllIterator{contract: _StakeNFT.contract, event: "ApprovalForAll", logs: logs, sub: sub}, nil
}

// WatchApprovalForAll is a free log subscription operation binding the contract event 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31.
//
// Solidity: event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
func (_StakeNFT *StakeNFTFilterer) WatchApprovalForAll(opts *bind.WatchOpts, sink chan<- *StakeNFTApprovalForAll, owner []common.Address, operator []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}

	logs, sub, err := _StakeNFT.contract.WatchLogs(opts, "ApprovalForAll", ownerRule, operatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(StakeNFTApprovalForAll)
				if err := _StakeNFT.contract.UnpackLog(event, "ApprovalForAll", log); err != nil {
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

// ParseApprovalForAll is a log parse operation binding the contract event 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31.
//
// Solidity: event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
func (_StakeNFT *StakeNFTFilterer) ParseApprovalForAll(log types.Log) (*StakeNFTApprovalForAll, error) {
	event := new(StakeNFTApprovalForAll)
	if err := _StakeNFT.contract.UnpackLog(event, "ApprovalForAll", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// StakeNFTTransferIterator is returned from FilterTransfer and is used to iterate over the raw logs and unpacked data for Transfer events raised by the StakeNFT contract.
type StakeNFTTransferIterator struct {
	Event *StakeNFTTransfer // Event containing the contract specifics and raw log

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
func (it *StakeNFTTransferIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(StakeNFTTransfer)
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
		it.Event = new(StakeNFTTransfer)
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
func (it *StakeNFTTransferIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *StakeNFTTransferIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// StakeNFTTransfer represents a Transfer event raised by the StakeNFT contract.
type StakeNFTTransfer struct {
	From    common.Address
	To      common.Address
	TokenId *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterTransfer is a free log retrieval operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (_StakeNFT *StakeNFTFilterer) FilterTransfer(opts *bind.FilterOpts, from []common.Address, to []common.Address, tokenId []*big.Int) (*StakeNFTTransferIterator, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}
	var tokenIdRule []interface{}
	for _, tokenIdItem := range tokenId {
		tokenIdRule = append(tokenIdRule, tokenIdItem)
	}

	logs, sub, err := _StakeNFT.contract.FilterLogs(opts, "Transfer", fromRule, toRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return &StakeNFTTransferIterator{contract: _StakeNFT.contract, event: "Transfer", logs: logs, sub: sub}, nil
}

// WatchTransfer is a free log subscription operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (_StakeNFT *StakeNFTFilterer) WatchTransfer(opts *bind.WatchOpts, sink chan<- *StakeNFTTransfer, from []common.Address, to []common.Address, tokenId []*big.Int) (event.Subscription, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}
	var tokenIdRule []interface{}
	for _, tokenIdItem := range tokenId {
		tokenIdRule = append(tokenIdRule, tokenIdItem)
	}

	logs, sub, err := _StakeNFT.contract.WatchLogs(opts, "Transfer", fromRule, toRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(StakeNFTTransfer)
				if err := _StakeNFT.contract.UnpackLog(event, "Transfer", log); err != nil {
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
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (_StakeNFT *StakeNFTFilterer) ParseTransfer(log types.Log) (*StakeNFTTransfer, error) {
	event := new(StakeNFTTransfer)
	if err := _StakeNFT.contract.UnpackLog(event, "Transfer", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
