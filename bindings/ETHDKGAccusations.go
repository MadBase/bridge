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

// ETHDKGAccusationsMetaData contains all meta data concerning the ETHDKGAccusations contract.
var ETHDKGAccusationsMetaData = &bind.MetaData{
	ABI: "[{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"publicKey\",\"type\":\"uint256[2]\"}],\"name\":\"AddressRegistered\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"GPKJSubmissionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"KeyShareSubmissionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1\",\"type\":\"uint256[2]\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1CorrectnessProof\",\"type\":\"uint256[2]\"},{\"indexed\":false,\"internalType\":\"uint256[4]\",\"name\":\"keyShareG2\",\"type\":\"uint256[4]\"}],\"name\":\"KeyShareSubmitted\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[4]\",\"name\":\"mpk\",\"type\":\"uint256[4]\"}],\"name\":\"MPKSet\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"RegistrationComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"startBlock\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"numberValidators\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"phaseLength\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"confirmationLength\",\"type\":\"uint256\"}],\"name\":\"RegistrationOpened\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"ShareDistributionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[]\",\"name\":\"encryptedShares\",\"type\":\"uint256[]\"},{\"indexed\":false,\"internalType\":\"uint256[2][]\",\"name\":\"commitments\",\"type\":\"uint256[2][]\"}],\"name\":\"SharesDistributed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"epoch\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share0\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share1\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share2\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share3\",\"type\":\"uint256\"}],\"name\":\"ValidatorMemberAdded\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"validatorCount\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"epoch\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"ethHeight\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"madHeight\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey0\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey1\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey2\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey3\",\"type\":\"uint256\"}],\"name\":\"ValidatorSetCompleted\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantDidNotDistributeShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantDidNotSubmitGPKJ\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantDidNotSubmitKeyShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"dishonestAddress\",\"type\":\"address\"},{\"internalType\":\"uint256[]\",\"name\":\"encryptedShares\",\"type\":\"uint256[]\"},{\"internalType\":\"uint256[2][]\",\"name\":\"commitments\",\"type\":\"uint256[2][]\"},{\"internalType\":\"uint256[2]\",\"name\":\"sharedKey\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[2]\",\"name\":\"sharedKeyCorrectnessProof\",\"type\":\"uint256[2]\"}],\"name\":\"accuseParticipantDistributedBadShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantNotRegistered\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"validators\",\"type\":\"address[]\"},{\"internalType\":\"bytes32[]\",\"name\":\"encryptedSharesHash\",\"type\":\"bytes32[]\"},{\"internalType\":\"uint256[2][][]\",\"name\":\"commitments\",\"type\":\"uint256[2][][]\"},{\"internalType\":\"address\",\"name\":\"dishonestAddress\",\"type\":\"address\"}],\"name\":\"accuseParticipantSubmittedBadGPKJ\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]",
}

// ETHDKGAccusationsABI is the input ABI used to generate the binding from.
// Deprecated: Use ETHDKGAccusationsMetaData.ABI instead.
var ETHDKGAccusationsABI = ETHDKGAccusationsMetaData.ABI

// ETHDKGAccusations is an auto generated Go binding around an Ethereum contract.
type ETHDKGAccusations struct {
	ETHDKGAccusationsCaller     // Read-only binding to the contract
	ETHDKGAccusationsTransactor // Write-only binding to the contract
	ETHDKGAccusationsFilterer   // Log filterer for contract events
}

// ETHDKGAccusationsCaller is an auto generated read-only Go binding around an Ethereum contract.
type ETHDKGAccusationsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ETHDKGAccusationsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ETHDKGAccusationsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ETHDKGAccusationsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ETHDKGAccusationsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ETHDKGAccusationsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ETHDKGAccusationsSession struct {
	Contract     *ETHDKGAccusations // Generic contract binding to set the session for
	CallOpts     bind.CallOpts      // Call options to use throughout this session
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// ETHDKGAccusationsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ETHDKGAccusationsCallerSession struct {
	Contract *ETHDKGAccusationsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts            // Call options to use throughout this session
}

// ETHDKGAccusationsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ETHDKGAccusationsTransactorSession struct {
	Contract     *ETHDKGAccusationsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts            // Transaction auth options to use throughout this session
}

// ETHDKGAccusationsRaw is an auto generated low-level Go binding around an Ethereum contract.
type ETHDKGAccusationsRaw struct {
	Contract *ETHDKGAccusations // Generic contract binding to access the raw methods on
}

// ETHDKGAccusationsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ETHDKGAccusationsCallerRaw struct {
	Contract *ETHDKGAccusationsCaller // Generic read-only contract binding to access the raw methods on
}

// ETHDKGAccusationsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ETHDKGAccusationsTransactorRaw struct {
	Contract *ETHDKGAccusationsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewETHDKGAccusations creates a new instance of ETHDKGAccusations, bound to a specific deployed contract.
func NewETHDKGAccusations(address common.Address, backend bind.ContractBackend) (*ETHDKGAccusations, error) {
	contract, err := bindETHDKGAccusations(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusations{ETHDKGAccusationsCaller: ETHDKGAccusationsCaller{contract: contract}, ETHDKGAccusationsTransactor: ETHDKGAccusationsTransactor{contract: contract}, ETHDKGAccusationsFilterer: ETHDKGAccusationsFilterer{contract: contract}}, nil
}

// NewETHDKGAccusationsCaller creates a new read-only instance of ETHDKGAccusations, bound to a specific deployed contract.
func NewETHDKGAccusationsCaller(address common.Address, caller bind.ContractCaller) (*ETHDKGAccusationsCaller, error) {
	contract, err := bindETHDKGAccusations(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsCaller{contract: contract}, nil
}

// NewETHDKGAccusationsTransactor creates a new write-only instance of ETHDKGAccusations, bound to a specific deployed contract.
func NewETHDKGAccusationsTransactor(address common.Address, transactor bind.ContractTransactor) (*ETHDKGAccusationsTransactor, error) {
	contract, err := bindETHDKGAccusations(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsTransactor{contract: contract}, nil
}

// NewETHDKGAccusationsFilterer creates a new log filterer instance of ETHDKGAccusations, bound to a specific deployed contract.
func NewETHDKGAccusationsFilterer(address common.Address, filterer bind.ContractFilterer) (*ETHDKGAccusationsFilterer, error) {
	contract, err := bindETHDKGAccusations(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsFilterer{contract: contract}, nil
}

// bindETHDKGAccusations binds a generic wrapper to an already deployed contract.
func bindETHDKGAccusations(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ETHDKGAccusationsABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ETHDKGAccusations *ETHDKGAccusationsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ETHDKGAccusations.Contract.ETHDKGAccusationsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ETHDKGAccusations *ETHDKGAccusationsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.ETHDKGAccusationsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ETHDKGAccusations *ETHDKGAccusationsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.ETHDKGAccusationsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ETHDKGAccusations *ETHDKGAccusationsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ETHDKGAccusations.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ETHDKGAccusations *ETHDKGAccusationsCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ETHDKGAccusations.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ETHDKGAccusations *ETHDKGAccusationsSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ETHDKGAccusations.Contract.GetMetamorphicContractAddress(&_ETHDKGAccusations.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ETHDKGAccusations *ETHDKGAccusationsCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ETHDKGAccusations.Contract.GetMetamorphicContractAddress(&_ETHDKGAccusations.CallOpts, _salt, _factory)
}

// AccuseParticipantDidNotDistributeShares is a paid mutator transaction binding the contract method 0xdae681bc.
//
// Solidity: function accuseParticipantDidNotDistributeShares(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactor) AccuseParticipantDidNotDistributeShares(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.contract.Transact(opts, "accuseParticipantDidNotDistributeShares", dishonestAddresses)
}

// AccuseParticipantDidNotDistributeShares is a paid mutator transaction binding the contract method 0xdae681bc.
//
// Solidity: function accuseParticipantDidNotDistributeShares(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsSession) AccuseParticipantDidNotDistributeShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDidNotDistributeShares(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotDistributeShares is a paid mutator transaction binding the contract method 0xdae681bc.
//
// Solidity: function accuseParticipantDidNotDistributeShares(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorSession) AccuseParticipantDidNotDistributeShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDidNotDistributeShares(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitGPKJ is a paid mutator transaction binding the contract method 0x7df24ee9.
//
// Solidity: function accuseParticipantDidNotSubmitGPKJ(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactor) AccuseParticipantDidNotSubmitGPKJ(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.contract.Transact(opts, "accuseParticipantDidNotSubmitGPKJ", dishonestAddresses)
}

// AccuseParticipantDidNotSubmitGPKJ is a paid mutator transaction binding the contract method 0x7df24ee9.
//
// Solidity: function accuseParticipantDidNotSubmitGPKJ(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsSession) AccuseParticipantDidNotSubmitGPKJ(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDidNotSubmitGPKJ(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitGPKJ is a paid mutator transaction binding the contract method 0x7df24ee9.
//
// Solidity: function accuseParticipantDidNotSubmitGPKJ(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorSession) AccuseParticipantDidNotSubmitGPKJ(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDidNotSubmitGPKJ(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitKeyShares is a paid mutator transaction binding the contract method 0x043a6f12.
//
// Solidity: function accuseParticipantDidNotSubmitKeyShares(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactor) AccuseParticipantDidNotSubmitKeyShares(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.contract.Transact(opts, "accuseParticipantDidNotSubmitKeyShares", dishonestAddresses)
}

// AccuseParticipantDidNotSubmitKeyShares is a paid mutator transaction binding the contract method 0x043a6f12.
//
// Solidity: function accuseParticipantDidNotSubmitKeyShares(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsSession) AccuseParticipantDidNotSubmitKeyShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDidNotSubmitKeyShares(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitKeyShares is a paid mutator transaction binding the contract method 0x043a6f12.
//
// Solidity: function accuseParticipantDidNotSubmitKeyShares(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorSession) AccuseParticipantDidNotSubmitKeyShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDidNotSubmitKeyShares(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDistributedBadShares is a paid mutator transaction binding the contract method 0xedbe7bf7.
//
// Solidity: function accuseParticipantDistributedBadShares(address dishonestAddress, uint256[] encryptedShares, uint256[2][] commitments, uint256[2] sharedKey, uint256[2] sharedKeyCorrectnessProof) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactor) AccuseParticipantDistributedBadShares(opts *bind.TransactOpts, dishonestAddress common.Address, encryptedShares []*big.Int, commitments [][2]*big.Int, sharedKey [2]*big.Int, sharedKeyCorrectnessProof [2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGAccusations.contract.Transact(opts, "accuseParticipantDistributedBadShares", dishonestAddress, encryptedShares, commitments, sharedKey, sharedKeyCorrectnessProof)
}

// AccuseParticipantDistributedBadShares is a paid mutator transaction binding the contract method 0xedbe7bf7.
//
// Solidity: function accuseParticipantDistributedBadShares(address dishonestAddress, uint256[] encryptedShares, uint256[2][] commitments, uint256[2] sharedKey, uint256[2] sharedKeyCorrectnessProof) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsSession) AccuseParticipantDistributedBadShares(dishonestAddress common.Address, encryptedShares []*big.Int, commitments [][2]*big.Int, sharedKey [2]*big.Int, sharedKeyCorrectnessProof [2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDistributedBadShares(&_ETHDKGAccusations.TransactOpts, dishonestAddress, encryptedShares, commitments, sharedKey, sharedKeyCorrectnessProof)
}

// AccuseParticipantDistributedBadShares is a paid mutator transaction binding the contract method 0xedbe7bf7.
//
// Solidity: function accuseParticipantDistributedBadShares(address dishonestAddress, uint256[] encryptedShares, uint256[2][] commitments, uint256[2] sharedKey, uint256[2] sharedKeyCorrectnessProof) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorSession) AccuseParticipantDistributedBadShares(dishonestAddress common.Address, encryptedShares []*big.Int, commitments [][2]*big.Int, sharedKey [2]*big.Int, sharedKeyCorrectnessProof [2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantDistributedBadShares(&_ETHDKGAccusations.TransactOpts, dishonestAddress, encryptedShares, commitments, sharedKey, sharedKeyCorrectnessProof)
}

// AccuseParticipantNotRegistered is a paid mutator transaction binding the contract method 0xf72c45b6.
//
// Solidity: function accuseParticipantNotRegistered(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactor) AccuseParticipantNotRegistered(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.contract.Transact(opts, "accuseParticipantNotRegistered", dishonestAddresses)
}

// AccuseParticipantNotRegistered is a paid mutator transaction binding the contract method 0xf72c45b6.
//
// Solidity: function accuseParticipantNotRegistered(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsSession) AccuseParticipantNotRegistered(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantNotRegistered(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantNotRegistered is a paid mutator transaction binding the contract method 0xf72c45b6.
//
// Solidity: function accuseParticipantNotRegistered(address[] dishonestAddresses) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorSession) AccuseParticipantNotRegistered(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantNotRegistered(&_ETHDKGAccusations.TransactOpts, dishonestAddresses)
}

// AccuseParticipantSubmittedBadGPKJ is a paid mutator transaction binding the contract method 0x80001264.
//
// Solidity: function accuseParticipantSubmittedBadGPKJ(address[] validators, bytes32[] encryptedSharesHash, uint256[2][][] commitments, address dishonestAddress) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactor) AccuseParticipantSubmittedBadGPKJ(opts *bind.TransactOpts, validators []common.Address, encryptedSharesHash [][32]byte, commitments [][][2]*big.Int, dishonestAddress common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.contract.Transact(opts, "accuseParticipantSubmittedBadGPKJ", validators, encryptedSharesHash, commitments, dishonestAddress)
}

// AccuseParticipantSubmittedBadGPKJ is a paid mutator transaction binding the contract method 0x80001264.
//
// Solidity: function accuseParticipantSubmittedBadGPKJ(address[] validators, bytes32[] encryptedSharesHash, uint256[2][][] commitments, address dishonestAddress) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsSession) AccuseParticipantSubmittedBadGPKJ(validators []common.Address, encryptedSharesHash [][32]byte, commitments [][][2]*big.Int, dishonestAddress common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantSubmittedBadGPKJ(&_ETHDKGAccusations.TransactOpts, validators, encryptedSharesHash, commitments, dishonestAddress)
}

// AccuseParticipantSubmittedBadGPKJ is a paid mutator transaction binding the contract method 0x80001264.
//
// Solidity: function accuseParticipantSubmittedBadGPKJ(address[] validators, bytes32[] encryptedSharesHash, uint256[2][][] commitments, address dishonestAddress) returns()
func (_ETHDKGAccusations *ETHDKGAccusationsTransactorSession) AccuseParticipantSubmittedBadGPKJ(validators []common.Address, encryptedSharesHash [][32]byte, commitments [][][2]*big.Int, dishonestAddress common.Address) (*types.Transaction, error) {
	return _ETHDKGAccusations.Contract.AccuseParticipantSubmittedBadGPKJ(&_ETHDKGAccusations.TransactOpts, validators, encryptedSharesHash, commitments, dishonestAddress)
}

// ETHDKGAccusationsAddressRegisteredIterator is returned from FilterAddressRegistered and is used to iterate over the raw logs and unpacked data for AddressRegistered events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsAddressRegisteredIterator struct {
	Event *ETHDKGAccusationsAddressRegistered // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsAddressRegisteredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsAddressRegistered)
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
		it.Event = new(ETHDKGAccusationsAddressRegistered)
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
func (it *ETHDKGAccusationsAddressRegisteredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsAddressRegisteredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsAddressRegistered represents a AddressRegistered event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsAddressRegistered struct {
	Account   common.Address
	Index     *big.Int
	Nonce     *big.Int
	PublicKey [2]*big.Int
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterAddressRegistered is a free log retrieval operation binding the contract event 0x7f1304057ec61140fbf2f5f236790f34fcafe123d3eb0d298d92317c97da500d.
//
// Solidity: event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterAddressRegistered(opts *bind.FilterOpts) (*ETHDKGAccusationsAddressRegisteredIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "AddressRegistered")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsAddressRegisteredIterator{contract: _ETHDKGAccusations.contract, event: "AddressRegistered", logs: logs, sub: sub}, nil
}

// WatchAddressRegistered is a free log subscription operation binding the contract event 0x7f1304057ec61140fbf2f5f236790f34fcafe123d3eb0d298d92317c97da500d.
//
// Solidity: event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchAddressRegistered(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsAddressRegistered) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "AddressRegistered")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsAddressRegistered)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "AddressRegistered", log); err != nil {
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

// ParseAddressRegistered is a log parse operation binding the contract event 0x7f1304057ec61140fbf2f5f236790f34fcafe123d3eb0d298d92317c97da500d.
//
// Solidity: event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseAddressRegistered(log types.Log) (*ETHDKGAccusationsAddressRegistered, error) {
	event := new(ETHDKGAccusationsAddressRegistered)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "AddressRegistered", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsGPKJSubmissionCompleteIterator is returned from FilterGPKJSubmissionComplete and is used to iterate over the raw logs and unpacked data for GPKJSubmissionComplete events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsGPKJSubmissionCompleteIterator struct {
	Event *ETHDKGAccusationsGPKJSubmissionComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsGPKJSubmissionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsGPKJSubmissionComplete)
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
		it.Event = new(ETHDKGAccusationsGPKJSubmissionComplete)
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
func (it *ETHDKGAccusationsGPKJSubmissionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsGPKJSubmissionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsGPKJSubmissionComplete represents a GPKJSubmissionComplete event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsGPKJSubmissionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterGPKJSubmissionComplete is a free log retrieval operation binding the contract event 0x87bfe600b78cad9f7cf68c99eb582c1748f636b3269842b37d5873b0e069f628.
//
// Solidity: event GPKJSubmissionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterGPKJSubmissionComplete(opts *bind.FilterOpts) (*ETHDKGAccusationsGPKJSubmissionCompleteIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "GPKJSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsGPKJSubmissionCompleteIterator{contract: _ETHDKGAccusations.contract, event: "GPKJSubmissionComplete", logs: logs, sub: sub}, nil
}

// WatchGPKJSubmissionComplete is a free log subscription operation binding the contract event 0x87bfe600b78cad9f7cf68c99eb582c1748f636b3269842b37d5873b0e069f628.
//
// Solidity: event GPKJSubmissionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchGPKJSubmissionComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsGPKJSubmissionComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "GPKJSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsGPKJSubmissionComplete)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "GPKJSubmissionComplete", log); err != nil {
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

// ParseGPKJSubmissionComplete is a log parse operation binding the contract event 0x87bfe600b78cad9f7cf68c99eb582c1748f636b3269842b37d5873b0e069f628.
//
// Solidity: event GPKJSubmissionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseGPKJSubmissionComplete(log types.Log) (*ETHDKGAccusationsGPKJSubmissionComplete, error) {
	event := new(ETHDKGAccusationsGPKJSubmissionComplete)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "GPKJSubmissionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsKeyShareSubmissionCompleteIterator is returned from FilterKeyShareSubmissionComplete and is used to iterate over the raw logs and unpacked data for KeyShareSubmissionComplete events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsKeyShareSubmissionCompleteIterator struct {
	Event *ETHDKGAccusationsKeyShareSubmissionComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsKeyShareSubmissionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsKeyShareSubmissionComplete)
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
		it.Event = new(ETHDKGAccusationsKeyShareSubmissionComplete)
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
func (it *ETHDKGAccusationsKeyShareSubmissionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsKeyShareSubmissionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsKeyShareSubmissionComplete represents a KeyShareSubmissionComplete event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsKeyShareSubmissionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterKeyShareSubmissionComplete is a free log retrieval operation binding the contract event 0x522cec98f6caa194456c44afa9e8cef9ac63eecb0be60e20d180ce19cfb0ef59.
//
// Solidity: event KeyShareSubmissionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterKeyShareSubmissionComplete(opts *bind.FilterOpts) (*ETHDKGAccusationsKeyShareSubmissionCompleteIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "KeyShareSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsKeyShareSubmissionCompleteIterator{contract: _ETHDKGAccusations.contract, event: "KeyShareSubmissionComplete", logs: logs, sub: sub}, nil
}

// WatchKeyShareSubmissionComplete is a free log subscription operation binding the contract event 0x522cec98f6caa194456c44afa9e8cef9ac63eecb0be60e20d180ce19cfb0ef59.
//
// Solidity: event KeyShareSubmissionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchKeyShareSubmissionComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsKeyShareSubmissionComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "KeyShareSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsKeyShareSubmissionComplete)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "KeyShareSubmissionComplete", log); err != nil {
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

// ParseKeyShareSubmissionComplete is a log parse operation binding the contract event 0x522cec98f6caa194456c44afa9e8cef9ac63eecb0be60e20d180ce19cfb0ef59.
//
// Solidity: event KeyShareSubmissionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseKeyShareSubmissionComplete(log types.Log) (*ETHDKGAccusationsKeyShareSubmissionComplete, error) {
	event := new(ETHDKGAccusationsKeyShareSubmissionComplete)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "KeyShareSubmissionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsKeyShareSubmittedIterator is returned from FilterKeyShareSubmitted and is used to iterate over the raw logs and unpacked data for KeyShareSubmitted events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsKeyShareSubmittedIterator struct {
	Event *ETHDKGAccusationsKeyShareSubmitted // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsKeyShareSubmittedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsKeyShareSubmitted)
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
		it.Event = new(ETHDKGAccusationsKeyShareSubmitted)
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
func (it *ETHDKGAccusationsKeyShareSubmittedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsKeyShareSubmittedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsKeyShareSubmitted represents a KeyShareSubmitted event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsKeyShareSubmitted struct {
	Account                    common.Address
	Index                      *big.Int
	Nonce                      *big.Int
	KeyShareG1                 [2]*big.Int
	KeyShareG1CorrectnessProof [2]*big.Int
	KeyShareG2                 [4]*big.Int
	Raw                        types.Log // Blockchain specific contextual infos
}

// FilterKeyShareSubmitted is a free log retrieval operation binding the contract event 0x6162e2d11398e4063e4c8565dafc4fb6755bbead93747ea836a5ef73a594aaf7.
//
// Solidity: event KeyShareSubmitted(address account, uint256 index, uint256 nonce, uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterKeyShareSubmitted(opts *bind.FilterOpts) (*ETHDKGAccusationsKeyShareSubmittedIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "KeyShareSubmitted")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsKeyShareSubmittedIterator{contract: _ETHDKGAccusations.contract, event: "KeyShareSubmitted", logs: logs, sub: sub}, nil
}

// WatchKeyShareSubmitted is a free log subscription operation binding the contract event 0x6162e2d11398e4063e4c8565dafc4fb6755bbead93747ea836a5ef73a594aaf7.
//
// Solidity: event KeyShareSubmitted(address account, uint256 index, uint256 nonce, uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchKeyShareSubmitted(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsKeyShareSubmitted) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "KeyShareSubmitted")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsKeyShareSubmitted)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "KeyShareSubmitted", log); err != nil {
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

// ParseKeyShareSubmitted is a log parse operation binding the contract event 0x6162e2d11398e4063e4c8565dafc4fb6755bbead93747ea836a5ef73a594aaf7.
//
// Solidity: event KeyShareSubmitted(address account, uint256 index, uint256 nonce, uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseKeyShareSubmitted(log types.Log) (*ETHDKGAccusationsKeyShareSubmitted, error) {
	event := new(ETHDKGAccusationsKeyShareSubmitted)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "KeyShareSubmitted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsMPKSetIterator is returned from FilterMPKSet and is used to iterate over the raw logs and unpacked data for MPKSet events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsMPKSetIterator struct {
	Event *ETHDKGAccusationsMPKSet // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsMPKSetIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsMPKSet)
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
		it.Event = new(ETHDKGAccusationsMPKSet)
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
func (it *ETHDKGAccusationsMPKSetIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsMPKSetIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsMPKSet represents a MPKSet event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsMPKSet struct {
	BlockNumber *big.Int
	Nonce       *big.Int
	Mpk         [4]*big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterMPKSet is a free log retrieval operation binding the contract event 0x71b1ebd27be320895a22125d6458e3363aefa6944a312ede4bf275867e6d5a71.
//
// Solidity: event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterMPKSet(opts *bind.FilterOpts) (*ETHDKGAccusationsMPKSetIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "MPKSet")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsMPKSetIterator{contract: _ETHDKGAccusations.contract, event: "MPKSet", logs: logs, sub: sub}, nil
}

// WatchMPKSet is a free log subscription operation binding the contract event 0x71b1ebd27be320895a22125d6458e3363aefa6944a312ede4bf275867e6d5a71.
//
// Solidity: event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchMPKSet(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsMPKSet) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "MPKSet")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsMPKSet)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "MPKSet", log); err != nil {
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

// ParseMPKSet is a log parse operation binding the contract event 0x71b1ebd27be320895a22125d6458e3363aefa6944a312ede4bf275867e6d5a71.
//
// Solidity: event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseMPKSet(log types.Log) (*ETHDKGAccusationsMPKSet, error) {
	event := new(ETHDKGAccusationsMPKSet)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "MPKSet", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsRegistrationCompleteIterator is returned from FilterRegistrationComplete and is used to iterate over the raw logs and unpacked data for RegistrationComplete events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsRegistrationCompleteIterator struct {
	Event *ETHDKGAccusationsRegistrationComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsRegistrationCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsRegistrationComplete)
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
		it.Event = new(ETHDKGAccusationsRegistrationComplete)
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
func (it *ETHDKGAccusationsRegistrationCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsRegistrationCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsRegistrationComplete represents a RegistrationComplete event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsRegistrationComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterRegistrationComplete is a free log retrieval operation binding the contract event 0x833013b96b786b4eca83baac286920e5e53956c21ff3894f1d9f02e97d6ed764.
//
// Solidity: event RegistrationComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterRegistrationComplete(opts *bind.FilterOpts) (*ETHDKGAccusationsRegistrationCompleteIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "RegistrationComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsRegistrationCompleteIterator{contract: _ETHDKGAccusations.contract, event: "RegistrationComplete", logs: logs, sub: sub}, nil
}

// WatchRegistrationComplete is a free log subscription operation binding the contract event 0x833013b96b786b4eca83baac286920e5e53956c21ff3894f1d9f02e97d6ed764.
//
// Solidity: event RegistrationComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchRegistrationComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsRegistrationComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "RegistrationComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsRegistrationComplete)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "RegistrationComplete", log); err != nil {
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

// ParseRegistrationComplete is a log parse operation binding the contract event 0x833013b96b786b4eca83baac286920e5e53956c21ff3894f1d9f02e97d6ed764.
//
// Solidity: event RegistrationComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseRegistrationComplete(log types.Log) (*ETHDKGAccusationsRegistrationComplete, error) {
	event := new(ETHDKGAccusationsRegistrationComplete)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "RegistrationComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsRegistrationOpenedIterator is returned from FilterRegistrationOpened and is used to iterate over the raw logs and unpacked data for RegistrationOpened events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsRegistrationOpenedIterator struct {
	Event *ETHDKGAccusationsRegistrationOpened // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsRegistrationOpenedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsRegistrationOpened)
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
		it.Event = new(ETHDKGAccusationsRegistrationOpened)
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
func (it *ETHDKGAccusationsRegistrationOpenedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsRegistrationOpenedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsRegistrationOpened represents a RegistrationOpened event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsRegistrationOpened struct {
	StartBlock         *big.Int
	NumberValidators   *big.Int
	Nonce              *big.Int
	PhaseLength        *big.Int
	ConfirmationLength *big.Int
	Raw                types.Log // Blockchain specific contextual infos
}

// FilterRegistrationOpened is a free log retrieval operation binding the contract event 0xbda431b9b63510f1398bf33d700e013315bcba905507078a1780f13ea5b354b9.
//
// Solidity: event RegistrationOpened(uint256 startBlock, uint256 numberValidators, uint256 nonce, uint256 phaseLength, uint256 confirmationLength)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterRegistrationOpened(opts *bind.FilterOpts) (*ETHDKGAccusationsRegistrationOpenedIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "RegistrationOpened")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsRegistrationOpenedIterator{contract: _ETHDKGAccusations.contract, event: "RegistrationOpened", logs: logs, sub: sub}, nil
}

// WatchRegistrationOpened is a free log subscription operation binding the contract event 0xbda431b9b63510f1398bf33d700e013315bcba905507078a1780f13ea5b354b9.
//
// Solidity: event RegistrationOpened(uint256 startBlock, uint256 numberValidators, uint256 nonce, uint256 phaseLength, uint256 confirmationLength)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchRegistrationOpened(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsRegistrationOpened) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "RegistrationOpened")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsRegistrationOpened)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "RegistrationOpened", log); err != nil {
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

// ParseRegistrationOpened is a log parse operation binding the contract event 0xbda431b9b63510f1398bf33d700e013315bcba905507078a1780f13ea5b354b9.
//
// Solidity: event RegistrationOpened(uint256 startBlock, uint256 numberValidators, uint256 nonce, uint256 phaseLength, uint256 confirmationLength)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseRegistrationOpened(log types.Log) (*ETHDKGAccusationsRegistrationOpened, error) {
	event := new(ETHDKGAccusationsRegistrationOpened)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "RegistrationOpened", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsShareDistributionCompleteIterator is returned from FilterShareDistributionComplete and is used to iterate over the raw logs and unpacked data for ShareDistributionComplete events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsShareDistributionCompleteIterator struct {
	Event *ETHDKGAccusationsShareDistributionComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsShareDistributionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsShareDistributionComplete)
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
		it.Event = new(ETHDKGAccusationsShareDistributionComplete)
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
func (it *ETHDKGAccusationsShareDistributionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsShareDistributionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsShareDistributionComplete represents a ShareDistributionComplete event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsShareDistributionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterShareDistributionComplete is a free log retrieval operation binding the contract event 0xbfe94ffef5ddde4d25ac7b652f3f67686ea63f9badbfe1f25451e26fc262d11c.
//
// Solidity: event ShareDistributionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterShareDistributionComplete(opts *bind.FilterOpts) (*ETHDKGAccusationsShareDistributionCompleteIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "ShareDistributionComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsShareDistributionCompleteIterator{contract: _ETHDKGAccusations.contract, event: "ShareDistributionComplete", logs: logs, sub: sub}, nil
}

// WatchShareDistributionComplete is a free log subscription operation binding the contract event 0xbfe94ffef5ddde4d25ac7b652f3f67686ea63f9badbfe1f25451e26fc262d11c.
//
// Solidity: event ShareDistributionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchShareDistributionComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsShareDistributionComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "ShareDistributionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsShareDistributionComplete)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "ShareDistributionComplete", log); err != nil {
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

// ParseShareDistributionComplete is a log parse operation binding the contract event 0xbfe94ffef5ddde4d25ac7b652f3f67686ea63f9badbfe1f25451e26fc262d11c.
//
// Solidity: event ShareDistributionComplete(uint256 blockNumber)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseShareDistributionComplete(log types.Log) (*ETHDKGAccusationsShareDistributionComplete, error) {
	event := new(ETHDKGAccusationsShareDistributionComplete)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "ShareDistributionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsSharesDistributedIterator is returned from FilterSharesDistributed and is used to iterate over the raw logs and unpacked data for SharesDistributed events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsSharesDistributedIterator struct {
	Event *ETHDKGAccusationsSharesDistributed // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsSharesDistributedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsSharesDistributed)
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
		it.Event = new(ETHDKGAccusationsSharesDistributed)
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
func (it *ETHDKGAccusationsSharesDistributedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsSharesDistributedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsSharesDistributed represents a SharesDistributed event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsSharesDistributed struct {
	Account         common.Address
	Index           *big.Int
	Nonce           *big.Int
	EncryptedShares []*big.Int
	Commitments     [][2]*big.Int
	Raw             types.Log // Blockchain specific contextual infos
}

// FilterSharesDistributed is a free log retrieval operation binding the contract event 0xf0c8b0ef2867c2b4639b404a0296b6bbf0bf97e20856af42144a5a6035c0d0d2.
//
// Solidity: event SharesDistributed(address account, uint256 index, uint256 nonce, uint256[] encryptedShares, uint256[2][] commitments)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterSharesDistributed(opts *bind.FilterOpts) (*ETHDKGAccusationsSharesDistributedIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "SharesDistributed")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsSharesDistributedIterator{contract: _ETHDKGAccusations.contract, event: "SharesDistributed", logs: logs, sub: sub}, nil
}

// WatchSharesDistributed is a free log subscription operation binding the contract event 0xf0c8b0ef2867c2b4639b404a0296b6bbf0bf97e20856af42144a5a6035c0d0d2.
//
// Solidity: event SharesDistributed(address account, uint256 index, uint256 nonce, uint256[] encryptedShares, uint256[2][] commitments)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchSharesDistributed(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsSharesDistributed) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "SharesDistributed")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsSharesDistributed)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "SharesDistributed", log); err != nil {
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

// ParseSharesDistributed is a log parse operation binding the contract event 0xf0c8b0ef2867c2b4639b404a0296b6bbf0bf97e20856af42144a5a6035c0d0d2.
//
// Solidity: event SharesDistributed(address account, uint256 index, uint256 nonce, uint256[] encryptedShares, uint256[2][] commitments)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseSharesDistributed(log types.Log) (*ETHDKGAccusationsSharesDistributed, error) {
	event := new(ETHDKGAccusationsSharesDistributed)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "SharesDistributed", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsValidatorMemberAddedIterator is returned from FilterValidatorMemberAdded and is used to iterate over the raw logs and unpacked data for ValidatorMemberAdded events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsValidatorMemberAddedIterator struct {
	Event *ETHDKGAccusationsValidatorMemberAdded // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsValidatorMemberAddedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsValidatorMemberAdded)
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
		it.Event = new(ETHDKGAccusationsValidatorMemberAdded)
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
func (it *ETHDKGAccusationsValidatorMemberAddedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsValidatorMemberAddedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsValidatorMemberAdded represents a ValidatorMemberAdded event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsValidatorMemberAdded struct {
	Account common.Address
	Index   *big.Int
	Nonce   *big.Int
	Epoch   *big.Int
	Share0  *big.Int
	Share1  *big.Int
	Share2  *big.Int
	Share3  *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterValidatorMemberAdded is a free log retrieval operation binding the contract event 0x09b90b08bbc3dbe22e9d2a0bc9c2c7614c7511cd0ad72177727a1e762115bf06.
//
// Solidity: event ValidatorMemberAdded(address account, uint256 index, uint256 nonce, uint256 epoch, uint256 share0, uint256 share1, uint256 share2, uint256 share3)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterValidatorMemberAdded(opts *bind.FilterOpts) (*ETHDKGAccusationsValidatorMemberAddedIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "ValidatorMemberAdded")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsValidatorMemberAddedIterator{contract: _ETHDKGAccusations.contract, event: "ValidatorMemberAdded", logs: logs, sub: sub}, nil
}

// WatchValidatorMemberAdded is a free log subscription operation binding the contract event 0x09b90b08bbc3dbe22e9d2a0bc9c2c7614c7511cd0ad72177727a1e762115bf06.
//
// Solidity: event ValidatorMemberAdded(address account, uint256 index, uint256 nonce, uint256 epoch, uint256 share0, uint256 share1, uint256 share2, uint256 share3)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchValidatorMemberAdded(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsValidatorMemberAdded) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "ValidatorMemberAdded")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsValidatorMemberAdded)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "ValidatorMemberAdded", log); err != nil {
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

// ParseValidatorMemberAdded is a log parse operation binding the contract event 0x09b90b08bbc3dbe22e9d2a0bc9c2c7614c7511cd0ad72177727a1e762115bf06.
//
// Solidity: event ValidatorMemberAdded(address account, uint256 index, uint256 nonce, uint256 epoch, uint256 share0, uint256 share1, uint256 share2, uint256 share3)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseValidatorMemberAdded(log types.Log) (*ETHDKGAccusationsValidatorMemberAdded, error) {
	event := new(ETHDKGAccusationsValidatorMemberAdded)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "ValidatorMemberAdded", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGAccusationsValidatorSetCompletedIterator is returned from FilterValidatorSetCompleted and is used to iterate over the raw logs and unpacked data for ValidatorSetCompleted events raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsValidatorSetCompletedIterator struct {
	Event *ETHDKGAccusationsValidatorSetCompleted // Event containing the contract specifics and raw log

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
func (it *ETHDKGAccusationsValidatorSetCompletedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGAccusationsValidatorSetCompleted)
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
		it.Event = new(ETHDKGAccusationsValidatorSetCompleted)
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
func (it *ETHDKGAccusationsValidatorSetCompletedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGAccusationsValidatorSetCompletedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGAccusationsValidatorSetCompleted represents a ValidatorSetCompleted event raised by the ETHDKGAccusations contract.
type ETHDKGAccusationsValidatorSetCompleted struct {
	ValidatorCount *big.Int
	Nonce          *big.Int
	Epoch          *big.Int
	EthHeight      *big.Int
	MadHeight      *big.Int
	GroupKey0      *big.Int
	GroupKey1      *big.Int
	GroupKey2      *big.Int
	GroupKey3      *big.Int
	Raw            types.Log // Blockchain specific contextual infos
}

// FilterValidatorSetCompleted is a free log retrieval operation binding the contract event 0xd7237b781669fa700ecf77be6cd8fa0f4b98b1a24ac584a9b6b44c509216718a.
//
// Solidity: event ValidatorSetCompleted(uint256 validatorCount, uint256 nonce, uint256 epoch, uint256 ethHeight, uint256 madHeight, uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) FilterValidatorSetCompleted(opts *bind.FilterOpts) (*ETHDKGAccusationsValidatorSetCompletedIterator, error) {

	logs, sub, err := _ETHDKGAccusations.contract.FilterLogs(opts, "ValidatorSetCompleted")
	if err != nil {
		return nil, err
	}
	return &ETHDKGAccusationsValidatorSetCompletedIterator{contract: _ETHDKGAccusations.contract, event: "ValidatorSetCompleted", logs: logs, sub: sub}, nil
}

// WatchValidatorSetCompleted is a free log subscription operation binding the contract event 0xd7237b781669fa700ecf77be6cd8fa0f4b98b1a24ac584a9b6b44c509216718a.
//
// Solidity: event ValidatorSetCompleted(uint256 validatorCount, uint256 nonce, uint256 epoch, uint256 ethHeight, uint256 madHeight, uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) WatchValidatorSetCompleted(opts *bind.WatchOpts, sink chan<- *ETHDKGAccusationsValidatorSetCompleted) (event.Subscription, error) {

	logs, sub, err := _ETHDKGAccusations.contract.WatchLogs(opts, "ValidatorSetCompleted")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGAccusationsValidatorSetCompleted)
				if err := _ETHDKGAccusations.contract.UnpackLog(event, "ValidatorSetCompleted", log); err != nil {
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

// ParseValidatorSetCompleted is a log parse operation binding the contract event 0xd7237b781669fa700ecf77be6cd8fa0f4b98b1a24ac584a9b6b44c509216718a.
//
// Solidity: event ValidatorSetCompleted(uint256 validatorCount, uint256 nonce, uint256 epoch, uint256 ethHeight, uint256 madHeight, uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3)
func (_ETHDKGAccusations *ETHDKGAccusationsFilterer) ParseValidatorSetCompleted(log types.Log) (*ETHDKGAccusationsValidatorSetCompleted, error) {
	event := new(ETHDKGAccusationsValidatorSetCompleted)
	if err := _ETHDKGAccusations.contract.UnpackLog(event, "ValidatorSetCompleted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
