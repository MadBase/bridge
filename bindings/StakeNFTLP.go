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

// StakeNFTLPMetaData contains all meta data concerning the StakeNFTLP contract.
var StakeNFTLPMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"approved\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"bool\",\"name\":\"approved\",\"type\":\"bool\"}],\"name\":\"ApprovalForAll\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"burn\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payoutEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"payoutMadToken\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"burnTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payoutEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"payoutMadToken\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"circuitBreakerState\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectEthTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectTokenTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"magic_\",\"type\":\"uint8\"}],\"name\":\"depositEth\",\"outputs\":[],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"magic_\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"depositToken\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"estimateEthCollection\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"estimateExcessEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"estimateExcessToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"estimateTokenCollection\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getAccumulatorScaleFactor\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"getApproved\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getEthAccumulator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"accumulator\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"slush\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"getPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"freeAfter\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"withdrawFreeAfter\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"accumulatorEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"accumulatorToken\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTokenAccumulator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"accumulator\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"slush\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalReserveEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalReserveMadToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalShares\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"initialize\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"}],\"name\":\"isApprovedForAll\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockOwnPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"caller_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockWithdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"mintTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"ownerOf\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"safeTransferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"},{\"internalType\":\"bytes\",\"name\":\"_data\",\"type\":\"bytes\"}],\"name\":\"safeTransferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"},{\"internalType\":\"bool\",\"name\":\"approved\",\"type\":\"bool\"}],\"name\":\"setApprovalForAll\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"}],\"name\":\"skimExcessEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"}],\"name\":\"skimExcessToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes4\",\"name\":\"interfaceId\",\"type\":\"bytes4\"}],\"name\":\"supportsInterface\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"tokenURI\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"tripCB\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// StakeNFTLPABI is the input ABI used to generate the binding from.
// Deprecated: Use StakeNFTLPMetaData.ABI instead.
var StakeNFTLPABI = StakeNFTLPMetaData.ABI

// StakeNFTLP is an auto generated Go binding around an Ethereum contract.
type StakeNFTLP struct {
	StakeNFTLPCaller     // Read-only binding to the contract
	StakeNFTLPTransactor // Write-only binding to the contract
	StakeNFTLPFilterer   // Log filterer for contract events
}

// StakeNFTLPCaller is an auto generated read-only Go binding around an Ethereum contract.
type StakeNFTLPCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// StakeNFTLPTransactor is an auto generated write-only Go binding around an Ethereum contract.
type StakeNFTLPTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// StakeNFTLPFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type StakeNFTLPFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// StakeNFTLPSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type StakeNFTLPSession struct {
	Contract     *StakeNFTLP       // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// StakeNFTLPCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type StakeNFTLPCallerSession struct {
	Contract *StakeNFTLPCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts     // Call options to use throughout this session
}

// StakeNFTLPTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type StakeNFTLPTransactorSession struct {
	Contract     *StakeNFTLPTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts     // Transaction auth options to use throughout this session
}

// StakeNFTLPRaw is an auto generated low-level Go binding around an Ethereum contract.
type StakeNFTLPRaw struct {
	Contract *StakeNFTLP // Generic contract binding to access the raw methods on
}

// StakeNFTLPCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type StakeNFTLPCallerRaw struct {
	Contract *StakeNFTLPCaller // Generic read-only contract binding to access the raw methods on
}

// StakeNFTLPTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type StakeNFTLPTransactorRaw struct {
	Contract *StakeNFTLPTransactor // Generic write-only contract binding to access the raw methods on
}

// NewStakeNFTLP creates a new instance of StakeNFTLP, bound to a specific deployed contract.
func NewStakeNFTLP(address common.Address, backend bind.ContractBackend) (*StakeNFTLP, error) {
	contract, err := bindStakeNFTLP(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &StakeNFTLP{StakeNFTLPCaller: StakeNFTLPCaller{contract: contract}, StakeNFTLPTransactor: StakeNFTLPTransactor{contract: contract}, StakeNFTLPFilterer: StakeNFTLPFilterer{contract: contract}}, nil
}

// NewStakeNFTLPCaller creates a new read-only instance of StakeNFTLP, bound to a specific deployed contract.
func NewStakeNFTLPCaller(address common.Address, caller bind.ContractCaller) (*StakeNFTLPCaller, error) {
	contract, err := bindStakeNFTLP(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &StakeNFTLPCaller{contract: contract}, nil
}

// NewStakeNFTLPTransactor creates a new write-only instance of StakeNFTLP, bound to a specific deployed contract.
func NewStakeNFTLPTransactor(address common.Address, transactor bind.ContractTransactor) (*StakeNFTLPTransactor, error) {
	contract, err := bindStakeNFTLP(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &StakeNFTLPTransactor{contract: contract}, nil
}

// NewStakeNFTLPFilterer creates a new log filterer instance of StakeNFTLP, bound to a specific deployed contract.
func NewStakeNFTLPFilterer(address common.Address, filterer bind.ContractFilterer) (*StakeNFTLPFilterer, error) {
	contract, err := bindStakeNFTLP(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &StakeNFTLPFilterer{contract: contract}, nil
}

// bindStakeNFTLP binds a generic wrapper to an already deployed contract.
func bindStakeNFTLP(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(StakeNFTLPABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_StakeNFTLP *StakeNFTLPRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _StakeNFTLP.Contract.StakeNFTLPCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_StakeNFTLP *StakeNFTLPRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.StakeNFTLPTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_StakeNFTLP *StakeNFTLPRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.StakeNFTLPTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_StakeNFTLP *StakeNFTLPCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _StakeNFTLP.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_StakeNFTLP *StakeNFTLPTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_StakeNFTLP *StakeNFTLPTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.contract.Transact(opts, method, params...)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCaller) BalanceOf(opts *bind.CallOpts, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "balanceOf", owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) BalanceOf(owner common.Address) (*big.Int, error) {
	return _StakeNFTLP.Contract.BalanceOf(&_StakeNFTLP.CallOpts, owner)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCallerSession) BalanceOf(owner common.Address) (*big.Int, error) {
	return _StakeNFTLP.Contract.BalanceOf(&_StakeNFTLP.CallOpts, owner)
}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_StakeNFTLP *StakeNFTLPCaller) CircuitBreakerState(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "circuitBreakerState")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_StakeNFTLP *StakeNFTLPSession) CircuitBreakerState() (bool, error) {
	return _StakeNFTLP.Contract.CircuitBreakerState(&_StakeNFTLP.CallOpts)
}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_StakeNFTLP *StakeNFTLPCallerSession) CircuitBreakerState() (bool, error) {
	return _StakeNFTLP.Contract.CircuitBreakerState(&_StakeNFTLP.CallOpts)
}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPCaller) EstimateEthCollection(opts *bind.CallOpts, tokenID_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "estimateEthCollection", tokenID_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPSession) EstimateEthCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateEthCollection(&_StakeNFTLP.CallOpts, tokenID_)
}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPCallerSession) EstimateEthCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateEthCollection(&_StakeNFTLP.CallOpts, tokenID_)
}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPCaller) EstimateExcessEth(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "estimateExcessEth")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPSession) EstimateExcessEth() (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateExcessEth(&_StakeNFTLP.CallOpts)
}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPCallerSession) EstimateExcessEth() (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateExcessEth(&_StakeNFTLP.CallOpts)
}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPCaller) EstimateExcessToken(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "estimateExcessToken")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPSession) EstimateExcessToken() (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateExcessToken(&_StakeNFTLP.CallOpts)
}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPCallerSession) EstimateExcessToken() (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateExcessToken(&_StakeNFTLP.CallOpts)
}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPCaller) EstimateTokenCollection(opts *bind.CallOpts, tokenID_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "estimateTokenCollection", tokenID_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPSession) EstimateTokenCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateTokenCollection(&_StakeNFTLP.CallOpts, tokenID_)
}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPCallerSession) EstimateTokenCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _StakeNFTLP.Contract.EstimateTokenCollection(&_StakeNFTLP.CallOpts, tokenID_)
}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_StakeNFTLP *StakeNFTLPCaller) GetAccumulatorScaleFactor(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getAccumulatorScaleFactor")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) GetAccumulatorScaleFactor() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetAccumulatorScaleFactor(&_StakeNFTLP.CallOpts)
}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetAccumulatorScaleFactor() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetAccumulatorScaleFactor(&_StakeNFTLP.CallOpts)
}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_StakeNFTLP *StakeNFTLPCaller) GetApproved(opts *bind.CallOpts, tokenId *big.Int) (common.Address, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getApproved", tokenId)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_StakeNFTLP *StakeNFTLPSession) GetApproved(tokenId *big.Int) (common.Address, error) {
	return _StakeNFTLP.Contract.GetApproved(&_StakeNFTLP.CallOpts, tokenId)
}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetApproved(tokenId *big.Int) (common.Address, error) {
	return _StakeNFTLP.Contract.GetApproved(&_StakeNFTLP.CallOpts, tokenId)
}

// GetEthAccumulator is a free data retrieval call binding the contract method 0x548652d2.
//
// Solidity: function getEthAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFTLP *StakeNFTLPCaller) GetEthAccumulator(opts *bind.CallOpts) (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getEthAccumulator")

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
func (_StakeNFTLP *StakeNFTLPSession) GetEthAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFTLP.Contract.GetEthAccumulator(&_StakeNFTLP.CallOpts)
}

// GetEthAccumulator is a free data retrieval call binding the contract method 0x548652d2.
//
// Solidity: function getEthAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetEthAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFTLP.Contract.GetEthAccumulator(&_StakeNFTLP.CallOpts)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_StakeNFTLP *StakeNFTLPCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_StakeNFTLP *StakeNFTLPSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _StakeNFTLP.Contract.GetMetamorphicContractAddress(&_StakeNFTLP.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _StakeNFTLP.Contract.GetMetamorphicContractAddress(&_StakeNFTLP.CallOpts, _salt, _factory)
}

// GetPosition is a free data retrieval call binding the contract method 0xeb02c301.
//
// Solidity: function getPosition(uint256 tokenID_) view returns(uint256 shares, uint256 freeAfter, uint256 withdrawFreeAfter, uint256 accumulatorEth, uint256 accumulatorToken)
func (_StakeNFTLP *StakeNFTLPCaller) GetPosition(opts *bind.CallOpts, tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getPosition", tokenID_)

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
func (_StakeNFTLP *StakeNFTLPSession) GetPosition(tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	return _StakeNFTLP.Contract.GetPosition(&_StakeNFTLP.CallOpts, tokenID_)
}

// GetPosition is a free data retrieval call binding the contract method 0xeb02c301.
//
// Solidity: function getPosition(uint256 tokenID_) view returns(uint256 shares, uint256 freeAfter, uint256 withdrawFreeAfter, uint256 accumulatorEth, uint256 accumulatorToken)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetPosition(tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	return _StakeNFTLP.Contract.GetPosition(&_StakeNFTLP.CallOpts, tokenID_)
}

// GetTokenAccumulator is a free data retrieval call binding the contract method 0xc47c6e14.
//
// Solidity: function getTokenAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFTLP *StakeNFTLPCaller) GetTokenAccumulator(opts *bind.CallOpts) (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getTokenAccumulator")

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
func (_StakeNFTLP *StakeNFTLPSession) GetTokenAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFTLP.Contract.GetTokenAccumulator(&_StakeNFTLP.CallOpts)
}

// GetTokenAccumulator is a free data retrieval call binding the contract method 0xc47c6e14.
//
// Solidity: function getTokenAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetTokenAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _StakeNFTLP.Contract.GetTokenAccumulator(&_StakeNFTLP.CallOpts)
}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCaller) GetTotalReserveEth(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getTotalReserveEth")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) GetTotalReserveEth() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetTotalReserveEth(&_StakeNFTLP.CallOpts)
}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetTotalReserveEth() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetTotalReserveEth(&_StakeNFTLP.CallOpts)
}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCaller) GetTotalReserveMadToken(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getTotalReserveMadToken")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) GetTotalReserveMadToken() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetTotalReserveMadToken(&_StakeNFTLP.CallOpts)
}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetTotalReserveMadToken() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetTotalReserveMadToken(&_StakeNFTLP.CallOpts)
}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCaller) GetTotalShares(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "getTotalShares")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) GetTotalShares() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetTotalShares(&_StakeNFTLP.CallOpts)
}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_StakeNFTLP *StakeNFTLPCallerSession) GetTotalShares() (*big.Int, error) {
	return _StakeNFTLP.Contract.GetTotalShares(&_StakeNFTLP.CallOpts)
}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_StakeNFTLP *StakeNFTLPCaller) IsApprovedForAll(opts *bind.CallOpts, owner common.Address, operator common.Address) (bool, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "isApprovedForAll", owner, operator)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_StakeNFTLP *StakeNFTLPSession) IsApprovedForAll(owner common.Address, operator common.Address) (bool, error) {
	return _StakeNFTLP.Contract.IsApprovedForAll(&_StakeNFTLP.CallOpts, owner, operator)
}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_StakeNFTLP *StakeNFTLPCallerSession) IsApprovedForAll(owner common.Address, operator common.Address) (bool, error) {
	return _StakeNFTLP.Contract.IsApprovedForAll(&_StakeNFTLP.CallOpts, owner, operator)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_StakeNFTLP *StakeNFTLPCaller) Name(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "name")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_StakeNFTLP *StakeNFTLPSession) Name() (string, error) {
	return _StakeNFTLP.Contract.Name(&_StakeNFTLP.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_StakeNFTLP *StakeNFTLPCallerSession) Name() (string, error) {
	return _StakeNFTLP.Contract.Name(&_StakeNFTLP.CallOpts)
}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_StakeNFTLP *StakeNFTLPCaller) OwnerOf(opts *bind.CallOpts, tokenId *big.Int) (common.Address, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "ownerOf", tokenId)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_StakeNFTLP *StakeNFTLPSession) OwnerOf(tokenId *big.Int) (common.Address, error) {
	return _StakeNFTLP.Contract.OwnerOf(&_StakeNFTLP.CallOpts, tokenId)
}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_StakeNFTLP *StakeNFTLPCallerSession) OwnerOf(tokenId *big.Int) (common.Address, error) {
	return _StakeNFTLP.Contract.OwnerOf(&_StakeNFTLP.CallOpts, tokenId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_StakeNFTLP *StakeNFTLPCaller) SupportsInterface(opts *bind.CallOpts, interfaceId [4]byte) (bool, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "supportsInterface", interfaceId)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_StakeNFTLP *StakeNFTLPSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _StakeNFTLP.Contract.SupportsInterface(&_StakeNFTLP.CallOpts, interfaceId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_StakeNFTLP *StakeNFTLPCallerSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _StakeNFTLP.Contract.SupportsInterface(&_StakeNFTLP.CallOpts, interfaceId)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_StakeNFTLP *StakeNFTLPCaller) Symbol(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "symbol")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_StakeNFTLP *StakeNFTLPSession) Symbol() (string, error) {
	return _StakeNFTLP.Contract.Symbol(&_StakeNFTLP.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_StakeNFTLP *StakeNFTLPCallerSession) Symbol() (string, error) {
	return _StakeNFTLP.Contract.Symbol(&_StakeNFTLP.CallOpts)
}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_StakeNFTLP *StakeNFTLPCaller) TokenURI(opts *bind.CallOpts, tokenId *big.Int) (string, error) {
	var out []interface{}
	err := _StakeNFTLP.contract.Call(opts, &out, "tokenURI", tokenId)

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_StakeNFTLP *StakeNFTLPSession) TokenURI(tokenId *big.Int) (string, error) {
	return _StakeNFTLP.Contract.TokenURI(&_StakeNFTLP.CallOpts, tokenId)
}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_StakeNFTLP *StakeNFTLPCallerSession) TokenURI(tokenId *big.Int) (string, error) {
	return _StakeNFTLP.Contract.TokenURI(&_StakeNFTLP.CallOpts, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPTransactor) Approve(opts *bind.TransactOpts, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "approve", to, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPSession) Approve(to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Approve(&_StakeNFTLP.TransactOpts, to, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) Approve(to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Approve(&_StakeNFTLP.TransactOpts, to, tokenId)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFTLP *StakeNFTLPTransactor) Burn(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "burn", tokenID_)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFTLP *StakeNFTLPSession) Burn(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Burn(&_StakeNFTLP.TransactOpts, tokenID_)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFTLP *StakeNFTLPTransactorSession) Burn(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Burn(&_StakeNFTLP.TransactOpts, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFTLP *StakeNFTLPTransactor) BurnTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "burnTo", to_, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFTLP *StakeNFTLPSession) BurnTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.BurnTo(&_StakeNFTLP.TransactOpts, to_, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_StakeNFTLP *StakeNFTLPTransactorSession) BurnTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.BurnTo(&_StakeNFTLP.TransactOpts, to_, tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactor) CollectEth(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "collectEth", tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPSession) CollectEth(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectEth(&_StakeNFTLP.TransactOpts, tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactorSession) CollectEth(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectEth(&_StakeNFTLP.TransactOpts, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactor) CollectEthTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "collectEthTo", to_, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPSession) CollectEthTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectEthTo(&_StakeNFTLP.TransactOpts, to_, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactorSession) CollectEthTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectEthTo(&_StakeNFTLP.TransactOpts, to_, tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactor) CollectToken(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "collectToken", tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPSession) CollectToken(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectToken(&_StakeNFTLP.TransactOpts, tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactorSession) CollectToken(tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectToken(&_StakeNFTLP.TransactOpts, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactor) CollectTokenTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "collectTokenTo", to_, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPSession) CollectTokenTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectTokenTo(&_StakeNFTLP.TransactOpts, to_, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_StakeNFTLP *StakeNFTLPTransactorSession) CollectTokenTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.CollectTokenTo(&_StakeNFTLP.TransactOpts, to_, tokenID_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_StakeNFTLP *StakeNFTLPTransactor) DepositEth(opts *bind.TransactOpts, magic_ uint8) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "depositEth", magic_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_StakeNFTLP *StakeNFTLPSession) DepositEth(magic_ uint8) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.DepositEth(&_StakeNFTLP.TransactOpts, magic_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) DepositEth(magic_ uint8) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.DepositEth(&_StakeNFTLP.TransactOpts, magic_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_StakeNFTLP *StakeNFTLPTransactor) DepositToken(opts *bind.TransactOpts, magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "depositToken", magic_, amount_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_StakeNFTLP *StakeNFTLPSession) DepositToken(magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.DepositToken(&_StakeNFTLP.TransactOpts, magic_, amount_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) DepositToken(magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.DepositToken(&_StakeNFTLP.TransactOpts, magic_, amount_)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_StakeNFTLP *StakeNFTLPTransactor) Initialize(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "initialize")
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_StakeNFTLP *StakeNFTLPSession) Initialize() (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Initialize(&_StakeNFTLP.TransactOpts)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) Initialize() (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Initialize(&_StakeNFTLP.TransactOpts)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPTransactor) LockOwnPosition(opts *bind.TransactOpts, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "lockOwnPosition", tokenID_, lockDuration_)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) LockOwnPosition(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.LockOwnPosition(&_StakeNFTLP.TransactOpts, tokenID_, lockDuration_)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPTransactorSession) LockOwnPosition(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.LockOwnPosition(&_StakeNFTLP.TransactOpts, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPTransactor) LockPosition(opts *bind.TransactOpts, caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "lockPosition", caller_, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) LockPosition(caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.LockPosition(&_StakeNFTLP.TransactOpts, caller_, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPTransactorSession) LockPosition(caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.LockPosition(&_StakeNFTLP.TransactOpts, caller_, tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPTransactor) LockWithdraw(opts *bind.TransactOpts, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "lockWithdraw", tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPSession) LockWithdraw(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.LockWithdraw(&_StakeNFTLP.TransactOpts, tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_StakeNFTLP *StakeNFTLPTransactorSession) LockWithdraw(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.LockWithdraw(&_StakeNFTLP.TransactOpts, tokenID_, lockDuration_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_StakeNFTLP *StakeNFTLPTransactor) Mint(opts *bind.TransactOpts, amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "mint", amount_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_StakeNFTLP *StakeNFTLPSession) Mint(amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Mint(&_StakeNFTLP.TransactOpts, amount_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_StakeNFTLP *StakeNFTLPTransactorSession) Mint(amount_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.Mint(&_StakeNFTLP.TransactOpts, amount_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_StakeNFTLP *StakeNFTLPTransactor) MintTo(opts *bind.TransactOpts, to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "mintTo", to_, amount_, lockDuration_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_StakeNFTLP *StakeNFTLPSession) MintTo(to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.MintTo(&_StakeNFTLP.TransactOpts, to_, amount_, lockDuration_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_StakeNFTLP *StakeNFTLPTransactorSession) MintTo(to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.MintTo(&_StakeNFTLP.TransactOpts, to_, amount_, lockDuration_)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPTransactor) SafeTransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "safeTransferFrom", from, to, tokenId)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPSession) SafeTransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SafeTransferFrom(&_StakeNFTLP.TransactOpts, from, to, tokenId)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) SafeTransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SafeTransferFrom(&_StakeNFTLP.TransactOpts, from, to, tokenId)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_StakeNFTLP *StakeNFTLPTransactor) SafeTransferFrom0(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "safeTransferFrom0", from, to, tokenId, _data)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_StakeNFTLP *StakeNFTLPSession) SafeTransferFrom0(from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SafeTransferFrom0(&_StakeNFTLP.TransactOpts, from, to, tokenId, _data)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) SafeTransferFrom0(from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SafeTransferFrom0(&_StakeNFTLP.TransactOpts, from, to, tokenId, _data)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_StakeNFTLP *StakeNFTLPTransactor) SetApprovalForAll(opts *bind.TransactOpts, operator common.Address, approved bool) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "setApprovalForAll", operator, approved)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_StakeNFTLP *StakeNFTLPSession) SetApprovalForAll(operator common.Address, approved bool) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SetApprovalForAll(&_StakeNFTLP.TransactOpts, operator, approved)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) SetApprovalForAll(operator common.Address, approved bool) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SetApprovalForAll(&_StakeNFTLP.TransactOpts, operator, approved)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPTransactor) SkimExcessEth(opts *bind.TransactOpts, to_ common.Address) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "skimExcessEth", to_)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPSession) SkimExcessEth(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SkimExcessEth(&_StakeNFTLP.TransactOpts, to_)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPTransactorSession) SkimExcessEth(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SkimExcessEth(&_StakeNFTLP.TransactOpts, to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPTransactor) SkimExcessToken(opts *bind.TransactOpts, to_ common.Address) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "skimExcessToken", to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPSession) SkimExcessToken(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SkimExcessToken(&_StakeNFTLP.TransactOpts, to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_StakeNFTLP *StakeNFTLPTransactorSession) SkimExcessToken(to_ common.Address) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.SkimExcessToken(&_StakeNFTLP.TransactOpts, to_)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPTransactor) TransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "transferFrom", from, to, tokenId)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPSession) TransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.TransferFrom(&_StakeNFTLP.TransactOpts, from, to, tokenId)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) TransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _StakeNFTLP.Contract.TransferFrom(&_StakeNFTLP.TransactOpts, from, to, tokenId)
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_StakeNFTLP *StakeNFTLPTransactor) TripCB(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _StakeNFTLP.contract.Transact(opts, "tripCB")
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_StakeNFTLP *StakeNFTLPSession) TripCB() (*types.Transaction, error) {
	return _StakeNFTLP.Contract.TripCB(&_StakeNFTLP.TransactOpts)
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_StakeNFTLP *StakeNFTLPTransactorSession) TripCB() (*types.Transaction, error) {
	return _StakeNFTLP.Contract.TripCB(&_StakeNFTLP.TransactOpts)
}

// StakeNFTLPApprovalIterator is returned from FilterApproval and is used to iterate over the raw logs and unpacked data for Approval events raised by the StakeNFTLP contract.
type StakeNFTLPApprovalIterator struct {
	Event *StakeNFTLPApproval // Event containing the contract specifics and raw log

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
func (it *StakeNFTLPApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(StakeNFTLPApproval)
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
		it.Event = new(StakeNFTLPApproval)
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
func (it *StakeNFTLPApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *StakeNFTLPApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// StakeNFTLPApproval represents a Approval event raised by the StakeNFTLP contract.
type StakeNFTLPApproval struct {
	Owner    common.Address
	Approved common.Address
	TokenId  *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterApproval is a free log retrieval operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
func (_StakeNFTLP *StakeNFTLPFilterer) FilterApproval(opts *bind.FilterOpts, owner []common.Address, approved []common.Address, tokenId []*big.Int) (*StakeNFTLPApprovalIterator, error) {

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

	logs, sub, err := _StakeNFTLP.contract.FilterLogs(opts, "Approval", ownerRule, approvedRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return &StakeNFTLPApprovalIterator{contract: _StakeNFTLP.contract, event: "Approval", logs: logs, sub: sub}, nil
}

// WatchApproval is a free log subscription operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
func (_StakeNFTLP *StakeNFTLPFilterer) WatchApproval(opts *bind.WatchOpts, sink chan<- *StakeNFTLPApproval, owner []common.Address, approved []common.Address, tokenId []*big.Int) (event.Subscription, error) {

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

	logs, sub, err := _StakeNFTLP.contract.WatchLogs(opts, "Approval", ownerRule, approvedRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(StakeNFTLPApproval)
				if err := _StakeNFTLP.contract.UnpackLog(event, "Approval", log); err != nil {
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
func (_StakeNFTLP *StakeNFTLPFilterer) ParseApproval(log types.Log) (*StakeNFTLPApproval, error) {
	event := new(StakeNFTLPApproval)
	if err := _StakeNFTLP.contract.UnpackLog(event, "Approval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// StakeNFTLPApprovalForAllIterator is returned from FilterApprovalForAll and is used to iterate over the raw logs and unpacked data for ApprovalForAll events raised by the StakeNFTLP contract.
type StakeNFTLPApprovalForAllIterator struct {
	Event *StakeNFTLPApprovalForAll // Event containing the contract specifics and raw log

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
func (it *StakeNFTLPApprovalForAllIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(StakeNFTLPApprovalForAll)
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
		it.Event = new(StakeNFTLPApprovalForAll)
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
func (it *StakeNFTLPApprovalForAllIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *StakeNFTLPApprovalForAllIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// StakeNFTLPApprovalForAll represents a ApprovalForAll event raised by the StakeNFTLP contract.
type StakeNFTLPApprovalForAll struct {
	Owner    common.Address
	Operator common.Address
	Approved bool
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterApprovalForAll is a free log retrieval operation binding the contract event 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31.
//
// Solidity: event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
func (_StakeNFTLP *StakeNFTLPFilterer) FilterApprovalForAll(opts *bind.FilterOpts, owner []common.Address, operator []common.Address) (*StakeNFTLPApprovalForAllIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}

	logs, sub, err := _StakeNFTLP.contract.FilterLogs(opts, "ApprovalForAll", ownerRule, operatorRule)
	if err != nil {
		return nil, err
	}
	return &StakeNFTLPApprovalForAllIterator{contract: _StakeNFTLP.contract, event: "ApprovalForAll", logs: logs, sub: sub}, nil
}

// WatchApprovalForAll is a free log subscription operation binding the contract event 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31.
//
// Solidity: event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
func (_StakeNFTLP *StakeNFTLPFilterer) WatchApprovalForAll(opts *bind.WatchOpts, sink chan<- *StakeNFTLPApprovalForAll, owner []common.Address, operator []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}

	logs, sub, err := _StakeNFTLP.contract.WatchLogs(opts, "ApprovalForAll", ownerRule, operatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(StakeNFTLPApprovalForAll)
				if err := _StakeNFTLP.contract.UnpackLog(event, "ApprovalForAll", log); err != nil {
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
func (_StakeNFTLP *StakeNFTLPFilterer) ParseApprovalForAll(log types.Log) (*StakeNFTLPApprovalForAll, error) {
	event := new(StakeNFTLPApprovalForAll)
	if err := _StakeNFTLP.contract.UnpackLog(event, "ApprovalForAll", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// StakeNFTLPTransferIterator is returned from FilterTransfer and is used to iterate over the raw logs and unpacked data for Transfer events raised by the StakeNFTLP contract.
type StakeNFTLPTransferIterator struct {
	Event *StakeNFTLPTransfer // Event containing the contract specifics and raw log

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
func (it *StakeNFTLPTransferIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(StakeNFTLPTransfer)
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
		it.Event = new(StakeNFTLPTransfer)
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
func (it *StakeNFTLPTransferIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *StakeNFTLPTransferIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// StakeNFTLPTransfer represents a Transfer event raised by the StakeNFTLP contract.
type StakeNFTLPTransfer struct {
	From    common.Address
	To      common.Address
	TokenId *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterTransfer is a free log retrieval operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (_StakeNFTLP *StakeNFTLPFilterer) FilterTransfer(opts *bind.FilterOpts, from []common.Address, to []common.Address, tokenId []*big.Int) (*StakeNFTLPTransferIterator, error) {

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

	logs, sub, err := _StakeNFTLP.contract.FilterLogs(opts, "Transfer", fromRule, toRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return &StakeNFTLPTransferIterator{contract: _StakeNFTLP.contract, event: "Transfer", logs: logs, sub: sub}, nil
}

// WatchTransfer is a free log subscription operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (_StakeNFTLP *StakeNFTLPFilterer) WatchTransfer(opts *bind.WatchOpts, sink chan<- *StakeNFTLPTransfer, from []common.Address, to []common.Address, tokenId []*big.Int) (event.Subscription, error) {

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

	logs, sub, err := _StakeNFTLP.contract.WatchLogs(opts, "Transfer", fromRule, toRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(StakeNFTLPTransfer)
				if err := _StakeNFTLP.contract.UnpackLog(event, "Transfer", log); err != nil {
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
func (_StakeNFTLP *StakeNFTLPFilterer) ParseTransfer(log types.Log) (*StakeNFTLPTransfer, error) {
	event := new(StakeNFTLPTransfer)
	if err := _StakeNFTLP.contract.UnpackLog(event, "Transfer", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
