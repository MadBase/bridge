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

// ValidatorNFTMetaData contains all meta data concerning the ValidatorNFT contract.
var ValidatorNFTMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"approved\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"bool\",\"name\":\"approved\",\"type\":\"bool\"}],\"name\":\"ApprovalForAll\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"burn\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payoutEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"payoutMadToken\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"burnTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payoutEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"payoutMadToken\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"circuitBreakerState\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectEthTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"collectTokenTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"magic_\",\"type\":\"uint8\"}],\"name\":\"depositEth\",\"outputs\":[],\"stateMutability\":\"payable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint8\",\"name\":\"magic_\",\"type\":\"uint8\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"depositToken\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"estimateEthCollection\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"estimateExcessEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"estimateExcessToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"estimateTokenCollection\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payout\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getAccumulatorScaleFactor\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"getApproved\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getEthAccumulator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"accumulator\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"slush\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"}],\"name\":\"getPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"freeAfter\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"withdrawFreeAfter\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"accumulatorEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"accumulatorToken\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTokenAccumulator\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"accumulator\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"slush\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalReserveEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalReserveMadToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getTotalShares\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"initialize\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"}],\"name\":\"isApprovedForAll\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockOwnPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"caller_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"lockWithdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount_\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"lockDuration_\",\"type\":\"uint256\"}],\"name\":\"mintTo\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenID\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"ownerOf\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"safeTransferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"},{\"internalType\":\"bytes\",\"name\":\"_data\",\"type\":\"bytes\"}],\"name\":\"safeTransferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"operator\",\"type\":\"address\"},{\"internalType\":\"bool\",\"name\":\"approved\",\"type\":\"bool\"}],\"name\":\"setApprovalForAll\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"}],\"name\":\"skimExcessEth\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to_\",\"type\":\"address\"}],\"name\":\"skimExcessToken\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"excess\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes4\",\"name\":\"interfaceId\",\"type\":\"bytes4\"}],\"name\":\"supportsInterface\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"tokenURI\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"tripCB\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// ValidatorNFTABI is the input ABI used to generate the binding from.
// Deprecated: Use ValidatorNFTMetaData.ABI instead.
var ValidatorNFTABI = ValidatorNFTMetaData.ABI

// ValidatorNFT is an auto generated Go binding around an Ethereum contract.
type ValidatorNFT struct {
	ValidatorNFTCaller     // Read-only binding to the contract
	ValidatorNFTTransactor // Write-only binding to the contract
	ValidatorNFTFilterer   // Log filterer for contract events
}

// ValidatorNFTCaller is an auto generated read-only Go binding around an Ethereum contract.
type ValidatorNFTCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ValidatorNFTTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ValidatorNFTTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ValidatorNFTFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ValidatorNFTFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ValidatorNFTSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ValidatorNFTSession struct {
	Contract     *ValidatorNFT     // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ValidatorNFTCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ValidatorNFTCallerSession struct {
	Contract *ValidatorNFTCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts       // Call options to use throughout this session
}

// ValidatorNFTTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ValidatorNFTTransactorSession struct {
	Contract     *ValidatorNFTTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts       // Transaction auth options to use throughout this session
}

// ValidatorNFTRaw is an auto generated low-level Go binding around an Ethereum contract.
type ValidatorNFTRaw struct {
	Contract *ValidatorNFT // Generic contract binding to access the raw methods on
}

// ValidatorNFTCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ValidatorNFTCallerRaw struct {
	Contract *ValidatorNFTCaller // Generic read-only contract binding to access the raw methods on
}

// ValidatorNFTTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ValidatorNFTTransactorRaw struct {
	Contract *ValidatorNFTTransactor // Generic write-only contract binding to access the raw methods on
}

// NewValidatorNFT creates a new instance of ValidatorNFT, bound to a specific deployed contract.
func NewValidatorNFT(address common.Address, backend bind.ContractBackend) (*ValidatorNFT, error) {
	contract, err := bindValidatorNFT(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ValidatorNFT{ValidatorNFTCaller: ValidatorNFTCaller{contract: contract}, ValidatorNFTTransactor: ValidatorNFTTransactor{contract: contract}, ValidatorNFTFilterer: ValidatorNFTFilterer{contract: contract}}, nil
}

// NewValidatorNFTCaller creates a new read-only instance of ValidatorNFT, bound to a specific deployed contract.
func NewValidatorNFTCaller(address common.Address, caller bind.ContractCaller) (*ValidatorNFTCaller, error) {
	contract, err := bindValidatorNFT(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ValidatorNFTCaller{contract: contract}, nil
}

// NewValidatorNFTTransactor creates a new write-only instance of ValidatorNFT, bound to a specific deployed contract.
func NewValidatorNFTTransactor(address common.Address, transactor bind.ContractTransactor) (*ValidatorNFTTransactor, error) {
	contract, err := bindValidatorNFT(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ValidatorNFTTransactor{contract: contract}, nil
}

// NewValidatorNFTFilterer creates a new log filterer instance of ValidatorNFT, bound to a specific deployed contract.
func NewValidatorNFTFilterer(address common.Address, filterer bind.ContractFilterer) (*ValidatorNFTFilterer, error) {
	contract, err := bindValidatorNFT(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ValidatorNFTFilterer{contract: contract}, nil
}

// bindValidatorNFT binds a generic wrapper to an already deployed contract.
func bindValidatorNFT(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ValidatorNFTABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ValidatorNFT *ValidatorNFTRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ValidatorNFT.Contract.ValidatorNFTCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ValidatorNFT *ValidatorNFTRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.ValidatorNFTTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ValidatorNFT *ValidatorNFTRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.ValidatorNFTTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ValidatorNFT *ValidatorNFTCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ValidatorNFT.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ValidatorNFT *ValidatorNFTTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ValidatorNFT *ValidatorNFTTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.contract.Transact(opts, method, params...)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCaller) BalanceOf(opts *bind.CallOpts, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "balanceOf", owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) BalanceOf(owner common.Address) (*big.Int, error) {
	return _ValidatorNFT.Contract.BalanceOf(&_ValidatorNFT.CallOpts, owner)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address owner) view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCallerSession) BalanceOf(owner common.Address) (*big.Int, error) {
	return _ValidatorNFT.Contract.BalanceOf(&_ValidatorNFT.CallOpts, owner)
}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_ValidatorNFT *ValidatorNFTCaller) CircuitBreakerState(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "circuitBreakerState")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_ValidatorNFT *ValidatorNFTSession) CircuitBreakerState() (bool, error) {
	return _ValidatorNFT.Contract.CircuitBreakerState(&_ValidatorNFT.CallOpts)
}

// CircuitBreakerState is a free data retrieval call binding the contract method 0x89465c62.
//
// Solidity: function circuitBreakerState() view returns(bool)
func (_ValidatorNFT *ValidatorNFTCallerSession) CircuitBreakerState() (bool, error) {
	return _ValidatorNFT.Contract.CircuitBreakerState(&_ValidatorNFT.CallOpts)
}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTCaller) EstimateEthCollection(opts *bind.CallOpts, tokenID_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "estimateEthCollection", tokenID_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTSession) EstimateEthCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateEthCollection(&_ValidatorNFT.CallOpts, tokenID_)
}

// EstimateEthCollection is a free data retrieval call binding the contract method 0x20ea0d48.
//
// Solidity: function estimateEthCollection(uint256 tokenID_) view returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTCallerSession) EstimateEthCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateEthCollection(&_ValidatorNFT.CallOpts, tokenID_)
}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTCaller) EstimateExcessEth(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "estimateExcessEth")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTSession) EstimateExcessEth() (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateExcessEth(&_ValidatorNFT.CallOpts)
}

// EstimateExcessEth is a free data retrieval call binding the contract method 0x905953ed.
//
// Solidity: function estimateExcessEth() view returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTCallerSession) EstimateExcessEth() (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateExcessEth(&_ValidatorNFT.CallOpts)
}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTCaller) EstimateExcessToken(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "estimateExcessToken")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTSession) EstimateExcessToken() (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateExcessToken(&_ValidatorNFT.CallOpts)
}

// EstimateExcessToken is a free data retrieval call binding the contract method 0x3eed3eff.
//
// Solidity: function estimateExcessToken() view returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTCallerSession) EstimateExcessToken() (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateExcessToken(&_ValidatorNFT.CallOpts)
}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTCaller) EstimateTokenCollection(opts *bind.CallOpts, tokenID_ *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "estimateTokenCollection", tokenID_)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTSession) EstimateTokenCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateTokenCollection(&_ValidatorNFT.CallOpts, tokenID_)
}

// EstimateTokenCollection is a free data retrieval call binding the contract method 0x93c5748d.
//
// Solidity: function estimateTokenCollection(uint256 tokenID_) view returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTCallerSession) EstimateTokenCollection(tokenID_ *big.Int) (*big.Int, error) {
	return _ValidatorNFT.Contract.EstimateTokenCollection(&_ValidatorNFT.CallOpts, tokenID_)
}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_ValidatorNFT *ValidatorNFTCaller) GetAccumulatorScaleFactor(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getAccumulatorScaleFactor")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) GetAccumulatorScaleFactor() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetAccumulatorScaleFactor(&_ValidatorNFT.CallOpts)
}

// GetAccumulatorScaleFactor is a free data retrieval call binding the contract method 0x99785132.
//
// Solidity: function getAccumulatorScaleFactor() pure returns(uint256)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetAccumulatorScaleFactor() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetAccumulatorScaleFactor(&_ValidatorNFT.CallOpts)
}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_ValidatorNFT *ValidatorNFTCaller) GetApproved(opts *bind.CallOpts, tokenId *big.Int) (common.Address, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getApproved", tokenId)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_ValidatorNFT *ValidatorNFTSession) GetApproved(tokenId *big.Int) (common.Address, error) {
	return _ValidatorNFT.Contract.GetApproved(&_ValidatorNFT.CallOpts, tokenId)
}

// GetApproved is a free data retrieval call binding the contract method 0x081812fc.
//
// Solidity: function getApproved(uint256 tokenId) view returns(address)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetApproved(tokenId *big.Int) (common.Address, error) {
	return _ValidatorNFT.Contract.GetApproved(&_ValidatorNFT.CallOpts, tokenId)
}

// GetEthAccumulator is a free data retrieval call binding the contract method 0x548652d2.
//
// Solidity: function getEthAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_ValidatorNFT *ValidatorNFTCaller) GetEthAccumulator(opts *bind.CallOpts) (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getEthAccumulator")

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
func (_ValidatorNFT *ValidatorNFTSession) GetEthAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _ValidatorNFT.Contract.GetEthAccumulator(&_ValidatorNFT.CallOpts)
}

// GetEthAccumulator is a free data retrieval call binding the contract method 0x548652d2.
//
// Solidity: function getEthAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetEthAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _ValidatorNFT.Contract.GetEthAccumulator(&_ValidatorNFT.CallOpts)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ValidatorNFT *ValidatorNFTCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ValidatorNFT *ValidatorNFTSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ValidatorNFT.Contract.GetMetamorphicContractAddress(&_ValidatorNFT.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ValidatorNFT.Contract.GetMetamorphicContractAddress(&_ValidatorNFT.CallOpts, _salt, _factory)
}

// GetPosition is a free data retrieval call binding the contract method 0xeb02c301.
//
// Solidity: function getPosition(uint256 tokenID_) view returns(uint256 shares, uint256 freeAfter, uint256 withdrawFreeAfter, uint256 accumulatorEth, uint256 accumulatorToken)
func (_ValidatorNFT *ValidatorNFTCaller) GetPosition(opts *bind.CallOpts, tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getPosition", tokenID_)

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
func (_ValidatorNFT *ValidatorNFTSession) GetPosition(tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	return _ValidatorNFT.Contract.GetPosition(&_ValidatorNFT.CallOpts, tokenID_)
}

// GetPosition is a free data retrieval call binding the contract method 0xeb02c301.
//
// Solidity: function getPosition(uint256 tokenID_) view returns(uint256 shares, uint256 freeAfter, uint256 withdrawFreeAfter, uint256 accumulatorEth, uint256 accumulatorToken)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetPosition(tokenID_ *big.Int) (struct {
	Shares            *big.Int
	FreeAfter         *big.Int
	WithdrawFreeAfter *big.Int
	AccumulatorEth    *big.Int
	AccumulatorToken  *big.Int
}, error) {
	return _ValidatorNFT.Contract.GetPosition(&_ValidatorNFT.CallOpts, tokenID_)
}

// GetTokenAccumulator is a free data retrieval call binding the contract method 0xc47c6e14.
//
// Solidity: function getTokenAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_ValidatorNFT *ValidatorNFTCaller) GetTokenAccumulator(opts *bind.CallOpts) (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getTokenAccumulator")

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
func (_ValidatorNFT *ValidatorNFTSession) GetTokenAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _ValidatorNFT.Contract.GetTokenAccumulator(&_ValidatorNFT.CallOpts)
}

// GetTokenAccumulator is a free data retrieval call binding the contract method 0xc47c6e14.
//
// Solidity: function getTokenAccumulator() view returns(uint256 accumulator, uint256 slush)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetTokenAccumulator() (struct {
	Accumulator *big.Int
	Slush       *big.Int
}, error) {
	return _ValidatorNFT.Contract.GetTokenAccumulator(&_ValidatorNFT.CallOpts)
}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCaller) GetTotalReserveEth(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getTotalReserveEth")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) GetTotalReserveEth() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetTotalReserveEth(&_ValidatorNFT.CallOpts)
}

// GetTotalReserveEth is a free data retrieval call binding the contract method 0x19b8be2f.
//
// Solidity: function getTotalReserveEth() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetTotalReserveEth() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetTotalReserveEth(&_ValidatorNFT.CallOpts)
}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCaller) GetTotalReserveMadToken(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getTotalReserveMadToken")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) GetTotalReserveMadToken() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetTotalReserveMadToken(&_ValidatorNFT.CallOpts)
}

// GetTotalReserveMadToken is a free data retrieval call binding the contract method 0x9aeac659.
//
// Solidity: function getTotalReserveMadToken() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetTotalReserveMadToken() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetTotalReserveMadToken(&_ValidatorNFT.CallOpts)
}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCaller) GetTotalShares(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "getTotalShares")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) GetTotalShares() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetTotalShares(&_ValidatorNFT.CallOpts)
}

// GetTotalShares is a free data retrieval call binding the contract method 0xd5002f2e.
//
// Solidity: function getTotalShares() view returns(uint256)
func (_ValidatorNFT *ValidatorNFTCallerSession) GetTotalShares() (*big.Int, error) {
	return _ValidatorNFT.Contract.GetTotalShares(&_ValidatorNFT.CallOpts)
}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_ValidatorNFT *ValidatorNFTCaller) IsApprovedForAll(opts *bind.CallOpts, owner common.Address, operator common.Address) (bool, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "isApprovedForAll", owner, operator)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_ValidatorNFT *ValidatorNFTSession) IsApprovedForAll(owner common.Address, operator common.Address) (bool, error) {
	return _ValidatorNFT.Contract.IsApprovedForAll(&_ValidatorNFT.CallOpts, owner, operator)
}

// IsApprovedForAll is a free data retrieval call binding the contract method 0xe985e9c5.
//
// Solidity: function isApprovedForAll(address owner, address operator) view returns(bool)
func (_ValidatorNFT *ValidatorNFTCallerSession) IsApprovedForAll(owner common.Address, operator common.Address) (bool, error) {
	return _ValidatorNFT.Contract.IsApprovedForAll(&_ValidatorNFT.CallOpts, owner, operator)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_ValidatorNFT *ValidatorNFTCaller) Name(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "name")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_ValidatorNFT *ValidatorNFTSession) Name() (string, error) {
	return _ValidatorNFT.Contract.Name(&_ValidatorNFT.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_ValidatorNFT *ValidatorNFTCallerSession) Name() (string, error) {
	return _ValidatorNFT.Contract.Name(&_ValidatorNFT.CallOpts)
}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_ValidatorNFT *ValidatorNFTCaller) OwnerOf(opts *bind.CallOpts, tokenId *big.Int) (common.Address, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "ownerOf", tokenId)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_ValidatorNFT *ValidatorNFTSession) OwnerOf(tokenId *big.Int) (common.Address, error) {
	return _ValidatorNFT.Contract.OwnerOf(&_ValidatorNFT.CallOpts, tokenId)
}

// OwnerOf is a free data retrieval call binding the contract method 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address)
func (_ValidatorNFT *ValidatorNFTCallerSession) OwnerOf(tokenId *big.Int) (common.Address, error) {
	return _ValidatorNFT.Contract.OwnerOf(&_ValidatorNFT.CallOpts, tokenId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_ValidatorNFT *ValidatorNFTCaller) SupportsInterface(opts *bind.CallOpts, interfaceId [4]byte) (bool, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "supportsInterface", interfaceId)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_ValidatorNFT *ValidatorNFTSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _ValidatorNFT.Contract.SupportsInterface(&_ValidatorNFT.CallOpts, interfaceId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_ValidatorNFT *ValidatorNFTCallerSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _ValidatorNFT.Contract.SupportsInterface(&_ValidatorNFT.CallOpts, interfaceId)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_ValidatorNFT *ValidatorNFTCaller) Symbol(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "symbol")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_ValidatorNFT *ValidatorNFTSession) Symbol() (string, error) {
	return _ValidatorNFT.Contract.Symbol(&_ValidatorNFT.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_ValidatorNFT *ValidatorNFTCallerSession) Symbol() (string, error) {
	return _ValidatorNFT.Contract.Symbol(&_ValidatorNFT.CallOpts)
}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_ValidatorNFT *ValidatorNFTCaller) TokenURI(opts *bind.CallOpts, tokenId *big.Int) (string, error) {
	var out []interface{}
	err := _ValidatorNFT.contract.Call(opts, &out, "tokenURI", tokenId)

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_ValidatorNFT *ValidatorNFTSession) TokenURI(tokenId *big.Int) (string, error) {
	return _ValidatorNFT.Contract.TokenURI(&_ValidatorNFT.CallOpts, tokenId)
}

// TokenURI is a free data retrieval call binding the contract method 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string)
func (_ValidatorNFT *ValidatorNFTCallerSession) TokenURI(tokenId *big.Int) (string, error) {
	return _ValidatorNFT.Contract.TokenURI(&_ValidatorNFT.CallOpts, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTTransactor) Approve(opts *bind.TransactOpts, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "approve", to, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTSession) Approve(to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Approve(&_ValidatorNFT.TransactOpts, to, tokenId)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) Approve(to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Approve(&_ValidatorNFT.TransactOpts, to, tokenId)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_ValidatorNFT *ValidatorNFTTransactor) Burn(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "burn", tokenID_)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_ValidatorNFT *ValidatorNFTSession) Burn(tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Burn(&_ValidatorNFT.TransactOpts, tokenID_)
}

// Burn is a paid mutator transaction binding the contract method 0x42966c68.
//
// Solidity: function burn(uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_ValidatorNFT *ValidatorNFTTransactorSession) Burn(tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Burn(&_ValidatorNFT.TransactOpts, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_ValidatorNFT *ValidatorNFTTransactor) BurnTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "burnTo", to_, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_ValidatorNFT *ValidatorNFTSession) BurnTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.BurnTo(&_ValidatorNFT.TransactOpts, to_, tokenID_)
}

// BurnTo is a paid mutator transaction binding the contract method 0xea785a5e.
//
// Solidity: function burnTo(address to_, uint256 tokenID_) returns(uint256 payoutEth, uint256 payoutMadToken)
func (_ValidatorNFT *ValidatorNFTTransactorSession) BurnTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.BurnTo(&_ValidatorNFT.TransactOpts, to_, tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactor) CollectEth(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "collectEth", tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTSession) CollectEth(tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectEth(&_ValidatorNFT.TransactOpts, tokenID_)
}

// CollectEth is a paid mutator transaction binding the contract method 0x2a0d8bd1.
//
// Solidity: function collectEth(uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactorSession) CollectEth(tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectEth(&_ValidatorNFT.TransactOpts, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactor) CollectEthTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "collectEthTo", to_, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTSession) CollectEthTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectEthTo(&_ValidatorNFT.TransactOpts, to_, tokenID_)
}

// CollectEthTo is a paid mutator transaction binding the contract method 0xbe444379.
//
// Solidity: function collectEthTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactorSession) CollectEthTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectEthTo(&_ValidatorNFT.TransactOpts, to_, tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactor) CollectToken(opts *bind.TransactOpts, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "collectToken", tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTSession) CollectToken(tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectToken(&_ValidatorNFT.TransactOpts, tokenID_)
}

// CollectToken is a paid mutator transaction binding the contract method 0xe35c3e28.
//
// Solidity: function collectToken(uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactorSession) CollectToken(tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectToken(&_ValidatorNFT.TransactOpts, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactor) CollectTokenTo(opts *bind.TransactOpts, to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "collectTokenTo", to_, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTSession) CollectTokenTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectTokenTo(&_ValidatorNFT.TransactOpts, to_, tokenID_)
}

// CollectTokenTo is a paid mutator transaction binding the contract method 0x8853b950.
//
// Solidity: function collectTokenTo(address to_, uint256 tokenID_) returns(uint256 payout)
func (_ValidatorNFT *ValidatorNFTTransactorSession) CollectTokenTo(to_ common.Address, tokenID_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.CollectTokenTo(&_ValidatorNFT.TransactOpts, to_, tokenID_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_ValidatorNFT *ValidatorNFTTransactor) DepositEth(opts *bind.TransactOpts, magic_ uint8) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "depositEth", magic_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_ValidatorNFT *ValidatorNFTSession) DepositEth(magic_ uint8) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.DepositEth(&_ValidatorNFT.TransactOpts, magic_)
}

// DepositEth is a paid mutator transaction binding the contract method 0x99a89ecc.
//
// Solidity: function depositEth(uint8 magic_) payable returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) DepositEth(magic_ uint8) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.DepositEth(&_ValidatorNFT.TransactOpts, magic_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_ValidatorNFT *ValidatorNFTTransactor) DepositToken(opts *bind.TransactOpts, magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "depositToken", magic_, amount_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_ValidatorNFT *ValidatorNFTSession) DepositToken(magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.DepositToken(&_ValidatorNFT.TransactOpts, magic_, amount_)
}

// DepositToken is a paid mutator transaction binding the contract method 0x8191f5e5.
//
// Solidity: function depositToken(uint8 magic_, uint256 amount_) returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) DepositToken(magic_ uint8, amount_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.DepositToken(&_ValidatorNFT.TransactOpts, magic_, amount_)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_ValidatorNFT *ValidatorNFTTransactor) Initialize(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "initialize")
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_ValidatorNFT *ValidatorNFTSession) Initialize() (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Initialize(&_ValidatorNFT.TransactOpts)
}

// Initialize is a paid mutator transaction binding the contract method 0x8129fc1c.
//
// Solidity: function initialize() returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) Initialize() (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Initialize(&_ValidatorNFT.TransactOpts)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTTransactor) LockOwnPosition(opts *bind.TransactOpts, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "lockOwnPosition", tokenID_, lockDuration_)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) LockOwnPosition(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.LockOwnPosition(&_ValidatorNFT.TransactOpts, tokenID_, lockDuration_)
}

// LockOwnPosition is a paid mutator transaction binding the contract method 0xe42a673c.
//
// Solidity: function lockOwnPosition(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTTransactorSession) LockOwnPosition(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.LockOwnPosition(&_ValidatorNFT.TransactOpts, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTTransactor) LockPosition(opts *bind.TransactOpts, caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "lockPosition", caller_, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) LockPosition(caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.LockPosition(&_ValidatorNFT.TransactOpts, caller_, tokenID_, lockDuration_)
}

// LockPosition is a paid mutator transaction binding the contract method 0x0cc65dfb.
//
// Solidity: function lockPosition(address caller_, uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTTransactorSession) LockPosition(caller_ common.Address, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.LockPosition(&_ValidatorNFT.TransactOpts, caller_, tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTTransactor) LockWithdraw(opts *bind.TransactOpts, tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "lockWithdraw", tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTSession) LockWithdraw(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.LockWithdraw(&_ValidatorNFT.TransactOpts, tokenID_, lockDuration_)
}

// LockWithdraw is a paid mutator transaction binding the contract method 0x0e4eb15b.
//
// Solidity: function lockWithdraw(uint256 tokenID_, uint256 lockDuration_) returns(uint256)
func (_ValidatorNFT *ValidatorNFTTransactorSession) LockWithdraw(tokenID_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.LockWithdraw(&_ValidatorNFT.TransactOpts, tokenID_, lockDuration_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_ValidatorNFT *ValidatorNFTTransactor) Mint(opts *bind.TransactOpts, amount_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "mint", amount_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_ValidatorNFT *ValidatorNFTSession) Mint(amount_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Mint(&_ValidatorNFT.TransactOpts, amount_)
}

// Mint is a paid mutator transaction binding the contract method 0xa0712d68.
//
// Solidity: function mint(uint256 amount_) returns(uint256 tokenID)
func (_ValidatorNFT *ValidatorNFTTransactorSession) Mint(amount_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.Mint(&_ValidatorNFT.TransactOpts, amount_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_ValidatorNFT *ValidatorNFTTransactor) MintTo(opts *bind.TransactOpts, to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "mintTo", to_, amount_, lockDuration_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_ValidatorNFT *ValidatorNFTSession) MintTo(to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.MintTo(&_ValidatorNFT.TransactOpts, to_, amount_, lockDuration_)
}

// MintTo is a paid mutator transaction binding the contract method 0x2baf2acb.
//
// Solidity: function mintTo(address to_, uint256 amount_, uint256 lockDuration_) returns(uint256 tokenID)
func (_ValidatorNFT *ValidatorNFTTransactorSession) MintTo(to_ common.Address, amount_ *big.Int, lockDuration_ *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.MintTo(&_ValidatorNFT.TransactOpts, to_, amount_, lockDuration_)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTTransactor) SafeTransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "safeTransferFrom", from, to, tokenId)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTSession) SafeTransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SafeTransferFrom(&_ValidatorNFT.TransactOpts, from, to, tokenId)
}

// SafeTransferFrom is a paid mutator transaction binding the contract method 0x42842e0e.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) SafeTransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SafeTransferFrom(&_ValidatorNFT.TransactOpts, from, to, tokenId)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_ValidatorNFT *ValidatorNFTTransactor) SafeTransferFrom0(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "safeTransferFrom0", from, to, tokenId, _data)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_ValidatorNFT *ValidatorNFTSession) SafeTransferFrom0(from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SafeTransferFrom0(&_ValidatorNFT.TransactOpts, from, to, tokenId, _data)
}

// SafeTransferFrom0 is a paid mutator transaction binding the contract method 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) SafeTransferFrom0(from common.Address, to common.Address, tokenId *big.Int, _data []byte) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SafeTransferFrom0(&_ValidatorNFT.TransactOpts, from, to, tokenId, _data)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_ValidatorNFT *ValidatorNFTTransactor) SetApprovalForAll(opts *bind.TransactOpts, operator common.Address, approved bool) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "setApprovalForAll", operator, approved)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_ValidatorNFT *ValidatorNFTSession) SetApprovalForAll(operator common.Address, approved bool) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SetApprovalForAll(&_ValidatorNFT.TransactOpts, operator, approved)
}

// SetApprovalForAll is a paid mutator transaction binding the contract method 0xa22cb465.
//
// Solidity: function setApprovalForAll(address operator, bool approved) returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) SetApprovalForAll(operator common.Address, approved bool) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SetApprovalForAll(&_ValidatorNFT.TransactOpts, operator, approved)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTTransactor) SkimExcessEth(opts *bind.TransactOpts, to_ common.Address) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "skimExcessEth", to_)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTSession) SkimExcessEth(to_ common.Address) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SkimExcessEth(&_ValidatorNFT.TransactOpts, to_)
}

// SkimExcessEth is a paid mutator transaction binding the contract method 0x971b505b.
//
// Solidity: function skimExcessEth(address to_) returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTTransactorSession) SkimExcessEth(to_ common.Address) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SkimExcessEth(&_ValidatorNFT.TransactOpts, to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTTransactor) SkimExcessToken(opts *bind.TransactOpts, to_ common.Address) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "skimExcessToken", to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTSession) SkimExcessToken(to_ common.Address) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SkimExcessToken(&_ValidatorNFT.TransactOpts, to_)
}

// SkimExcessToken is a paid mutator transaction binding the contract method 0x7aa507fb.
//
// Solidity: function skimExcessToken(address to_) returns(uint256 excess)
func (_ValidatorNFT *ValidatorNFTTransactorSession) SkimExcessToken(to_ common.Address) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.SkimExcessToken(&_ValidatorNFT.TransactOpts, to_)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTTransactor) TransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "transferFrom", from, to, tokenId)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTSession) TransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.TransferFrom(&_ValidatorNFT.TransactOpts, from, to, tokenId)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 tokenId) returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) TransferFrom(from common.Address, to common.Address, tokenId *big.Int) (*types.Transaction, error) {
	return _ValidatorNFT.Contract.TransferFrom(&_ValidatorNFT.TransactOpts, from, to, tokenId)
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_ValidatorNFT *ValidatorNFTTransactor) TripCB(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ValidatorNFT.contract.Transact(opts, "tripCB")
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_ValidatorNFT *ValidatorNFTSession) TripCB() (*types.Transaction, error) {
	return _ValidatorNFT.Contract.TripCB(&_ValidatorNFT.TransactOpts)
}

// TripCB is a paid mutator transaction binding the contract method 0xadfdc03f.
//
// Solidity: function tripCB() returns()
func (_ValidatorNFT *ValidatorNFTTransactorSession) TripCB() (*types.Transaction, error) {
	return _ValidatorNFT.Contract.TripCB(&_ValidatorNFT.TransactOpts)
}

// ValidatorNFTApprovalIterator is returned from FilterApproval and is used to iterate over the raw logs and unpacked data for Approval events raised by the ValidatorNFT contract.
type ValidatorNFTApprovalIterator struct {
	Event *ValidatorNFTApproval // Event containing the contract specifics and raw log

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
func (it *ValidatorNFTApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ValidatorNFTApproval)
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
		it.Event = new(ValidatorNFTApproval)
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
func (it *ValidatorNFTApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ValidatorNFTApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ValidatorNFTApproval represents a Approval event raised by the ValidatorNFT contract.
type ValidatorNFTApproval struct {
	Owner    common.Address
	Approved common.Address
	TokenId  *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterApproval is a free log retrieval operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
func (_ValidatorNFT *ValidatorNFTFilterer) FilterApproval(opts *bind.FilterOpts, owner []common.Address, approved []common.Address, tokenId []*big.Int) (*ValidatorNFTApprovalIterator, error) {

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

	logs, sub, err := _ValidatorNFT.contract.FilterLogs(opts, "Approval", ownerRule, approvedRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return &ValidatorNFTApprovalIterator{contract: _ValidatorNFT.contract, event: "Approval", logs: logs, sub: sub}, nil
}

// WatchApproval is a free log subscription operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)
func (_ValidatorNFT *ValidatorNFTFilterer) WatchApproval(opts *bind.WatchOpts, sink chan<- *ValidatorNFTApproval, owner []common.Address, approved []common.Address, tokenId []*big.Int) (event.Subscription, error) {

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

	logs, sub, err := _ValidatorNFT.contract.WatchLogs(opts, "Approval", ownerRule, approvedRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ValidatorNFTApproval)
				if err := _ValidatorNFT.contract.UnpackLog(event, "Approval", log); err != nil {
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
func (_ValidatorNFT *ValidatorNFTFilterer) ParseApproval(log types.Log) (*ValidatorNFTApproval, error) {
	event := new(ValidatorNFTApproval)
	if err := _ValidatorNFT.contract.UnpackLog(event, "Approval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ValidatorNFTApprovalForAllIterator is returned from FilterApprovalForAll and is used to iterate over the raw logs and unpacked data for ApprovalForAll events raised by the ValidatorNFT contract.
type ValidatorNFTApprovalForAllIterator struct {
	Event *ValidatorNFTApprovalForAll // Event containing the contract specifics and raw log

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
func (it *ValidatorNFTApprovalForAllIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ValidatorNFTApprovalForAll)
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
		it.Event = new(ValidatorNFTApprovalForAll)
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
func (it *ValidatorNFTApprovalForAllIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ValidatorNFTApprovalForAllIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ValidatorNFTApprovalForAll represents a ApprovalForAll event raised by the ValidatorNFT contract.
type ValidatorNFTApprovalForAll struct {
	Owner    common.Address
	Operator common.Address
	Approved bool
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterApprovalForAll is a free log retrieval operation binding the contract event 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31.
//
// Solidity: event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
func (_ValidatorNFT *ValidatorNFTFilterer) FilterApprovalForAll(opts *bind.FilterOpts, owner []common.Address, operator []common.Address) (*ValidatorNFTApprovalForAllIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}

	logs, sub, err := _ValidatorNFT.contract.FilterLogs(opts, "ApprovalForAll", ownerRule, operatorRule)
	if err != nil {
		return nil, err
	}
	return &ValidatorNFTApprovalForAllIterator{contract: _ValidatorNFT.contract, event: "ApprovalForAll", logs: logs, sub: sub}, nil
}

// WatchApprovalForAll is a free log subscription operation binding the contract event 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31.
//
// Solidity: event ApprovalForAll(address indexed owner, address indexed operator, bool approved)
func (_ValidatorNFT *ValidatorNFTFilterer) WatchApprovalForAll(opts *bind.WatchOpts, sink chan<- *ValidatorNFTApprovalForAll, owner []common.Address, operator []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var operatorRule []interface{}
	for _, operatorItem := range operator {
		operatorRule = append(operatorRule, operatorItem)
	}

	logs, sub, err := _ValidatorNFT.contract.WatchLogs(opts, "ApprovalForAll", ownerRule, operatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ValidatorNFTApprovalForAll)
				if err := _ValidatorNFT.contract.UnpackLog(event, "ApprovalForAll", log); err != nil {
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
func (_ValidatorNFT *ValidatorNFTFilterer) ParseApprovalForAll(log types.Log) (*ValidatorNFTApprovalForAll, error) {
	event := new(ValidatorNFTApprovalForAll)
	if err := _ValidatorNFT.contract.UnpackLog(event, "ApprovalForAll", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ValidatorNFTTransferIterator is returned from FilterTransfer and is used to iterate over the raw logs and unpacked data for Transfer events raised by the ValidatorNFT contract.
type ValidatorNFTTransferIterator struct {
	Event *ValidatorNFTTransfer // Event containing the contract specifics and raw log

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
func (it *ValidatorNFTTransferIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ValidatorNFTTransfer)
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
		it.Event = new(ValidatorNFTTransfer)
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
func (it *ValidatorNFTTransferIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ValidatorNFTTransferIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ValidatorNFTTransfer represents a Transfer event raised by the ValidatorNFT contract.
type ValidatorNFTTransfer struct {
	From    common.Address
	To      common.Address
	TokenId *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterTransfer is a free log retrieval operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (_ValidatorNFT *ValidatorNFTFilterer) FilterTransfer(opts *bind.FilterOpts, from []common.Address, to []common.Address, tokenId []*big.Int) (*ValidatorNFTTransferIterator, error) {

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

	logs, sub, err := _ValidatorNFT.contract.FilterLogs(opts, "Transfer", fromRule, toRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return &ValidatorNFTTransferIterator{contract: _ValidatorNFT.contract, event: "Transfer", logs: logs, sub: sub}, nil
}

// WatchTransfer is a free log subscription operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (_ValidatorNFT *ValidatorNFTFilterer) WatchTransfer(opts *bind.WatchOpts, sink chan<- *ValidatorNFTTransfer, from []common.Address, to []common.Address, tokenId []*big.Int) (event.Subscription, error) {

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

	logs, sub, err := _ValidatorNFT.contract.WatchLogs(opts, "Transfer", fromRule, toRule, tokenIdRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ValidatorNFTTransfer)
				if err := _ValidatorNFT.contract.UnpackLog(event, "Transfer", log); err != nil {
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
func (_ValidatorNFT *ValidatorNFTFilterer) ParseTransfer(log types.Log) (*ValidatorNFTTransfer, error) {
	event := new(ValidatorNFTTransfer)
	if err := _ValidatorNFT.contract.UnpackLog(event, "Transfer", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
