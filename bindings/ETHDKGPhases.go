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

// ETHDKGPhasesMetaData contains all meta data concerning the ETHDKGPhases contract.
var ETHDKGPhasesMetaData = &bind.MetaData{
	ABI: "[{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"publicKey\",\"type\":\"uint256[2]\"}],\"name\":\"AddressRegistered\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"GPKJSubmissionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"KeyShareSubmissionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1\",\"type\":\"uint256[2]\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1CorrectnessProof\",\"type\":\"uint256[2]\"},{\"indexed\":false,\"internalType\":\"uint256[4]\",\"name\":\"keyShareG2\",\"type\":\"uint256[4]\"}],\"name\":\"KeyShareSubmitted\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[4]\",\"name\":\"mpk\",\"type\":\"uint256[4]\"}],\"name\":\"MPKSet\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"RegistrationComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"startBlock\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"numberValidators\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"phaseLength\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"confirmationLength\",\"type\":\"uint256\"}],\"name\":\"RegistrationOpened\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"ShareDistributionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[]\",\"name\":\"encryptedShares\",\"type\":\"uint256[]\"},{\"indexed\":false,\"internalType\":\"uint256[2][]\",\"name\":\"commitments\",\"type\":\"uint256[2][]\"}],\"name\":\"SharesDistributed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"epoch\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share0\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share1\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share2\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share3\",\"type\":\"uint256\"}],\"name\":\"ValidatorMemberAdded\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"validatorCount\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"epoch\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"ethHeight\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"madHeight\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey0\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey1\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey2\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey3\",\"type\":\"uint256\"}],\"name\":\"ValidatorSetCompleted\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"complete\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[]\",\"name\":\"encryptedShares\",\"type\":\"uint256[]\"},{\"internalType\":\"uint256[2][]\",\"name\":\"commitments\",\"type\":\"uint256[2][]\"}],\"name\":\"distributeShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_salt\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"_factory\",\"type\":\"address\"}],\"name\":\"getMetamorphicContractAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"pure\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getMyAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[2]\",\"name\":\"publicKey\",\"type\":\"uint256[2]\"}],\"name\":\"register\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[4]\",\"name\":\"gpkj\",\"type\":\"uint256[4]\"}],\"name\":\"submitGPKJ\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1CorrectnessProof\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[4]\",\"name\":\"keyShareG2\",\"type\":\"uint256[4]\"}],\"name\":\"submitKeyShare\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[4]\",\"name\":\"masterPublicKey_\",\"type\":\"uint256[4]\"}],\"name\":\"submitMasterPublicKey\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// ETHDKGPhasesABI is the input ABI used to generate the binding from.
// Deprecated: Use ETHDKGPhasesMetaData.ABI instead.
var ETHDKGPhasesABI = ETHDKGPhasesMetaData.ABI

// ETHDKGPhases is an auto generated Go binding around an Ethereum contract.
type ETHDKGPhases struct {
	ETHDKGPhasesCaller     // Read-only binding to the contract
	ETHDKGPhasesTransactor // Write-only binding to the contract
	ETHDKGPhasesFilterer   // Log filterer for contract events
}

// ETHDKGPhasesCaller is an auto generated read-only Go binding around an Ethereum contract.
type ETHDKGPhasesCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ETHDKGPhasesTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ETHDKGPhasesTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ETHDKGPhasesFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ETHDKGPhasesFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ETHDKGPhasesSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ETHDKGPhasesSession struct {
	Contract     *ETHDKGPhases     // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ETHDKGPhasesCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ETHDKGPhasesCallerSession struct {
	Contract *ETHDKGPhasesCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts       // Call options to use throughout this session
}

// ETHDKGPhasesTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ETHDKGPhasesTransactorSession struct {
	Contract     *ETHDKGPhasesTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts       // Transaction auth options to use throughout this session
}

// ETHDKGPhasesRaw is an auto generated low-level Go binding around an Ethereum contract.
type ETHDKGPhasesRaw struct {
	Contract *ETHDKGPhases // Generic contract binding to access the raw methods on
}

// ETHDKGPhasesCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ETHDKGPhasesCallerRaw struct {
	Contract *ETHDKGPhasesCaller // Generic read-only contract binding to access the raw methods on
}

// ETHDKGPhasesTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ETHDKGPhasesTransactorRaw struct {
	Contract *ETHDKGPhasesTransactor // Generic write-only contract binding to access the raw methods on
}

// NewETHDKGPhases creates a new instance of ETHDKGPhases, bound to a specific deployed contract.
func NewETHDKGPhases(address common.Address, backend bind.ContractBackend) (*ETHDKGPhases, error) {
	contract, err := bindETHDKGPhases(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhases{ETHDKGPhasesCaller: ETHDKGPhasesCaller{contract: contract}, ETHDKGPhasesTransactor: ETHDKGPhasesTransactor{contract: contract}, ETHDKGPhasesFilterer: ETHDKGPhasesFilterer{contract: contract}}, nil
}

// NewETHDKGPhasesCaller creates a new read-only instance of ETHDKGPhases, bound to a specific deployed contract.
func NewETHDKGPhasesCaller(address common.Address, caller bind.ContractCaller) (*ETHDKGPhasesCaller, error) {
	contract, err := bindETHDKGPhases(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesCaller{contract: contract}, nil
}

// NewETHDKGPhasesTransactor creates a new write-only instance of ETHDKGPhases, bound to a specific deployed contract.
func NewETHDKGPhasesTransactor(address common.Address, transactor bind.ContractTransactor) (*ETHDKGPhasesTransactor, error) {
	contract, err := bindETHDKGPhases(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesTransactor{contract: contract}, nil
}

// NewETHDKGPhasesFilterer creates a new log filterer instance of ETHDKGPhases, bound to a specific deployed contract.
func NewETHDKGPhasesFilterer(address common.Address, filterer bind.ContractFilterer) (*ETHDKGPhasesFilterer, error) {
	contract, err := bindETHDKGPhases(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesFilterer{contract: contract}, nil
}

// bindETHDKGPhases binds a generic wrapper to an already deployed contract.
func bindETHDKGPhases(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ETHDKGPhasesABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ETHDKGPhases *ETHDKGPhasesRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ETHDKGPhases.Contract.ETHDKGPhasesCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ETHDKGPhases *ETHDKGPhasesRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.ETHDKGPhasesTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ETHDKGPhases *ETHDKGPhasesRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.ETHDKGPhasesTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ETHDKGPhases *ETHDKGPhasesCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _ETHDKGPhases.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ETHDKGPhases *ETHDKGPhasesTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ETHDKGPhases *ETHDKGPhasesTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.contract.Transact(opts, method, params...)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ETHDKGPhases *ETHDKGPhasesCaller) GetMetamorphicContractAddress(opts *bind.CallOpts, _salt [32]byte, _factory common.Address) (common.Address, error) {
	var out []interface{}
	err := _ETHDKGPhases.contract.Call(opts, &out, "getMetamorphicContractAddress", _salt, _factory)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ETHDKGPhases *ETHDKGPhasesSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ETHDKGPhases.Contract.GetMetamorphicContractAddress(&_ETHDKGPhases.CallOpts, _salt, _factory)
}

// GetMetamorphicContractAddress is a free data retrieval call binding the contract method 0x8653a465.
//
// Solidity: function getMetamorphicContractAddress(bytes32 _salt, address _factory) pure returns(address)
func (_ETHDKGPhases *ETHDKGPhasesCallerSession) GetMetamorphicContractAddress(_salt [32]byte, _factory common.Address) (common.Address, error) {
	return _ETHDKGPhases.Contract.GetMetamorphicContractAddress(&_ETHDKGPhases.CallOpts, _salt, _factory)
}

// GetMyAddress is a free data retrieval call binding the contract method 0x9a166299.
//
// Solidity: function getMyAddress() view returns(address)
func (_ETHDKGPhases *ETHDKGPhasesCaller) GetMyAddress(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _ETHDKGPhases.contract.Call(opts, &out, "getMyAddress")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetMyAddress is a free data retrieval call binding the contract method 0x9a166299.
//
// Solidity: function getMyAddress() view returns(address)
func (_ETHDKGPhases *ETHDKGPhasesSession) GetMyAddress() (common.Address, error) {
	return _ETHDKGPhases.Contract.GetMyAddress(&_ETHDKGPhases.CallOpts)
}

// GetMyAddress is a free data retrieval call binding the contract method 0x9a166299.
//
// Solidity: function getMyAddress() view returns(address)
func (_ETHDKGPhases *ETHDKGPhasesCallerSession) GetMyAddress() (common.Address, error) {
	return _ETHDKGPhases.Contract.GetMyAddress(&_ETHDKGPhases.CallOpts)
}

// Complete is a paid mutator transaction binding the contract method 0x522e1177.
//
// Solidity: function complete() returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactor) Complete(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ETHDKGPhases.contract.Transact(opts, "complete")
}

// Complete is a paid mutator transaction binding the contract method 0x522e1177.
//
// Solidity: function complete() returns()
func (_ETHDKGPhases *ETHDKGPhasesSession) Complete() (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.Complete(&_ETHDKGPhases.TransactOpts)
}

// Complete is a paid mutator transaction binding the contract method 0x522e1177.
//
// Solidity: function complete() returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactorSession) Complete() (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.Complete(&_ETHDKGPhases.TransactOpts)
}

// DistributeShares is a paid mutator transaction binding the contract method 0x80b97e01.
//
// Solidity: function distributeShares(uint256[] encryptedShares, uint256[2][] commitments) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactor) DistributeShares(opts *bind.TransactOpts, encryptedShares []*big.Int, commitments [][2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.contract.Transact(opts, "distributeShares", encryptedShares, commitments)
}

// DistributeShares is a paid mutator transaction binding the contract method 0x80b97e01.
//
// Solidity: function distributeShares(uint256[] encryptedShares, uint256[2][] commitments) returns()
func (_ETHDKGPhases *ETHDKGPhasesSession) DistributeShares(encryptedShares []*big.Int, commitments [][2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.DistributeShares(&_ETHDKGPhases.TransactOpts, encryptedShares, commitments)
}

// DistributeShares is a paid mutator transaction binding the contract method 0x80b97e01.
//
// Solidity: function distributeShares(uint256[] encryptedShares, uint256[2][] commitments) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactorSession) DistributeShares(encryptedShares []*big.Int, commitments [][2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.DistributeShares(&_ETHDKGPhases.TransactOpts, encryptedShares, commitments)
}

// Register is a paid mutator transaction binding the contract method 0x3442af5c.
//
// Solidity: function register(uint256[2] publicKey) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactor) Register(opts *bind.TransactOpts, publicKey [2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.contract.Transact(opts, "register", publicKey)
}

// Register is a paid mutator transaction binding the contract method 0x3442af5c.
//
// Solidity: function register(uint256[2] publicKey) returns()
func (_ETHDKGPhases *ETHDKGPhasesSession) Register(publicKey [2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.Register(&_ETHDKGPhases.TransactOpts, publicKey)
}

// Register is a paid mutator transaction binding the contract method 0x3442af5c.
//
// Solidity: function register(uint256[2] publicKey) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactorSession) Register(publicKey [2]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.Register(&_ETHDKGPhases.TransactOpts, publicKey)
}

// SubmitGPKJ is a paid mutator transaction binding the contract method 0x101f49c1.
//
// Solidity: function submitGPKJ(uint256[4] gpkj) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactor) SubmitGPKJ(opts *bind.TransactOpts, gpkj [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.contract.Transact(opts, "submitGPKJ", gpkj)
}

// SubmitGPKJ is a paid mutator transaction binding the contract method 0x101f49c1.
//
// Solidity: function submitGPKJ(uint256[4] gpkj) returns()
func (_ETHDKGPhases *ETHDKGPhasesSession) SubmitGPKJ(gpkj [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.SubmitGPKJ(&_ETHDKGPhases.TransactOpts, gpkj)
}

// SubmitGPKJ is a paid mutator transaction binding the contract method 0x101f49c1.
//
// Solidity: function submitGPKJ(uint256[4] gpkj) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactorSession) SubmitGPKJ(gpkj [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.SubmitGPKJ(&_ETHDKGPhases.TransactOpts, gpkj)
}

// SubmitKeyShare is a paid mutator transaction binding the contract method 0x62a6523e.
//
// Solidity: function submitKeyShare(uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactor) SubmitKeyShare(opts *bind.TransactOpts, keyShareG1 [2]*big.Int, keyShareG1CorrectnessProof [2]*big.Int, keyShareG2 [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.contract.Transact(opts, "submitKeyShare", keyShareG1, keyShareG1CorrectnessProof, keyShareG2)
}

// SubmitKeyShare is a paid mutator transaction binding the contract method 0x62a6523e.
//
// Solidity: function submitKeyShare(uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2) returns()
func (_ETHDKGPhases *ETHDKGPhasesSession) SubmitKeyShare(keyShareG1 [2]*big.Int, keyShareG1CorrectnessProof [2]*big.Int, keyShareG2 [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.SubmitKeyShare(&_ETHDKGPhases.TransactOpts, keyShareG1, keyShareG1CorrectnessProof, keyShareG2)
}

// SubmitKeyShare is a paid mutator transaction binding the contract method 0x62a6523e.
//
// Solidity: function submitKeyShare(uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactorSession) SubmitKeyShare(keyShareG1 [2]*big.Int, keyShareG1CorrectnessProof [2]*big.Int, keyShareG2 [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.SubmitKeyShare(&_ETHDKGPhases.TransactOpts, keyShareG1, keyShareG1CorrectnessProof, keyShareG2)
}

// SubmitMasterPublicKey is a paid mutator transaction binding the contract method 0xe8323224.
//
// Solidity: function submitMasterPublicKey(uint256[4] masterPublicKey_) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactor) SubmitMasterPublicKey(opts *bind.TransactOpts, masterPublicKey_ [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.contract.Transact(opts, "submitMasterPublicKey", masterPublicKey_)
}

// SubmitMasterPublicKey is a paid mutator transaction binding the contract method 0xe8323224.
//
// Solidity: function submitMasterPublicKey(uint256[4] masterPublicKey_) returns()
func (_ETHDKGPhases *ETHDKGPhasesSession) SubmitMasterPublicKey(masterPublicKey_ [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.SubmitMasterPublicKey(&_ETHDKGPhases.TransactOpts, masterPublicKey_)
}

// SubmitMasterPublicKey is a paid mutator transaction binding the contract method 0xe8323224.
//
// Solidity: function submitMasterPublicKey(uint256[4] masterPublicKey_) returns()
func (_ETHDKGPhases *ETHDKGPhasesTransactorSession) SubmitMasterPublicKey(masterPublicKey_ [4]*big.Int) (*types.Transaction, error) {
	return _ETHDKGPhases.Contract.SubmitMasterPublicKey(&_ETHDKGPhases.TransactOpts, masterPublicKey_)
}

// ETHDKGPhasesAddressRegisteredIterator is returned from FilterAddressRegistered and is used to iterate over the raw logs and unpacked data for AddressRegistered events raised by the ETHDKGPhases contract.
type ETHDKGPhasesAddressRegisteredIterator struct {
	Event *ETHDKGPhasesAddressRegistered // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesAddressRegisteredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesAddressRegistered)
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
		it.Event = new(ETHDKGPhasesAddressRegistered)
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
func (it *ETHDKGPhasesAddressRegisteredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesAddressRegisteredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesAddressRegistered represents a AddressRegistered event raised by the ETHDKGPhases contract.
type ETHDKGPhasesAddressRegistered struct {
	Account   common.Address
	Index     *big.Int
	Nonce     *big.Int
	PublicKey [2]*big.Int
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterAddressRegistered is a free log retrieval operation binding the contract event 0x7f1304057ec61140fbf2f5f236790f34fcafe123d3eb0d298d92317c97da500d.
//
// Solidity: event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterAddressRegistered(opts *bind.FilterOpts) (*ETHDKGPhasesAddressRegisteredIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "AddressRegistered")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesAddressRegisteredIterator{contract: _ETHDKGPhases.contract, event: "AddressRegistered", logs: logs, sub: sub}, nil
}

// WatchAddressRegistered is a free log subscription operation binding the contract event 0x7f1304057ec61140fbf2f5f236790f34fcafe123d3eb0d298d92317c97da500d.
//
// Solidity: event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchAddressRegistered(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesAddressRegistered) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "AddressRegistered")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesAddressRegistered)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "AddressRegistered", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseAddressRegistered(log types.Log) (*ETHDKGPhasesAddressRegistered, error) {
	event := new(ETHDKGPhasesAddressRegistered)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "AddressRegistered", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesGPKJSubmissionCompleteIterator is returned from FilterGPKJSubmissionComplete and is used to iterate over the raw logs and unpacked data for GPKJSubmissionComplete events raised by the ETHDKGPhases contract.
type ETHDKGPhasesGPKJSubmissionCompleteIterator struct {
	Event *ETHDKGPhasesGPKJSubmissionComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesGPKJSubmissionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesGPKJSubmissionComplete)
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
		it.Event = new(ETHDKGPhasesGPKJSubmissionComplete)
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
func (it *ETHDKGPhasesGPKJSubmissionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesGPKJSubmissionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesGPKJSubmissionComplete represents a GPKJSubmissionComplete event raised by the ETHDKGPhases contract.
type ETHDKGPhasesGPKJSubmissionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterGPKJSubmissionComplete is a free log retrieval operation binding the contract event 0x87bfe600b78cad9f7cf68c99eb582c1748f636b3269842b37d5873b0e069f628.
//
// Solidity: event GPKJSubmissionComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterGPKJSubmissionComplete(opts *bind.FilterOpts) (*ETHDKGPhasesGPKJSubmissionCompleteIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "GPKJSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesGPKJSubmissionCompleteIterator{contract: _ETHDKGPhases.contract, event: "GPKJSubmissionComplete", logs: logs, sub: sub}, nil
}

// WatchGPKJSubmissionComplete is a free log subscription operation binding the contract event 0x87bfe600b78cad9f7cf68c99eb582c1748f636b3269842b37d5873b0e069f628.
//
// Solidity: event GPKJSubmissionComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchGPKJSubmissionComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesGPKJSubmissionComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "GPKJSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesGPKJSubmissionComplete)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "GPKJSubmissionComplete", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseGPKJSubmissionComplete(log types.Log) (*ETHDKGPhasesGPKJSubmissionComplete, error) {
	event := new(ETHDKGPhasesGPKJSubmissionComplete)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "GPKJSubmissionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesKeyShareSubmissionCompleteIterator is returned from FilterKeyShareSubmissionComplete and is used to iterate over the raw logs and unpacked data for KeyShareSubmissionComplete events raised by the ETHDKGPhases contract.
type ETHDKGPhasesKeyShareSubmissionCompleteIterator struct {
	Event *ETHDKGPhasesKeyShareSubmissionComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesKeyShareSubmissionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesKeyShareSubmissionComplete)
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
		it.Event = new(ETHDKGPhasesKeyShareSubmissionComplete)
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
func (it *ETHDKGPhasesKeyShareSubmissionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesKeyShareSubmissionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesKeyShareSubmissionComplete represents a KeyShareSubmissionComplete event raised by the ETHDKGPhases contract.
type ETHDKGPhasesKeyShareSubmissionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterKeyShareSubmissionComplete is a free log retrieval operation binding the contract event 0x522cec98f6caa194456c44afa9e8cef9ac63eecb0be60e20d180ce19cfb0ef59.
//
// Solidity: event KeyShareSubmissionComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterKeyShareSubmissionComplete(opts *bind.FilterOpts) (*ETHDKGPhasesKeyShareSubmissionCompleteIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "KeyShareSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesKeyShareSubmissionCompleteIterator{contract: _ETHDKGPhases.contract, event: "KeyShareSubmissionComplete", logs: logs, sub: sub}, nil
}

// WatchKeyShareSubmissionComplete is a free log subscription operation binding the contract event 0x522cec98f6caa194456c44afa9e8cef9ac63eecb0be60e20d180ce19cfb0ef59.
//
// Solidity: event KeyShareSubmissionComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchKeyShareSubmissionComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesKeyShareSubmissionComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "KeyShareSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesKeyShareSubmissionComplete)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "KeyShareSubmissionComplete", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseKeyShareSubmissionComplete(log types.Log) (*ETHDKGPhasesKeyShareSubmissionComplete, error) {
	event := new(ETHDKGPhasesKeyShareSubmissionComplete)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "KeyShareSubmissionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesKeyShareSubmittedIterator is returned from FilterKeyShareSubmitted and is used to iterate over the raw logs and unpacked data for KeyShareSubmitted events raised by the ETHDKGPhases contract.
type ETHDKGPhasesKeyShareSubmittedIterator struct {
	Event *ETHDKGPhasesKeyShareSubmitted // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesKeyShareSubmittedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesKeyShareSubmitted)
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
		it.Event = new(ETHDKGPhasesKeyShareSubmitted)
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
func (it *ETHDKGPhasesKeyShareSubmittedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesKeyShareSubmittedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesKeyShareSubmitted represents a KeyShareSubmitted event raised by the ETHDKGPhases contract.
type ETHDKGPhasesKeyShareSubmitted struct {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterKeyShareSubmitted(opts *bind.FilterOpts) (*ETHDKGPhasesKeyShareSubmittedIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "KeyShareSubmitted")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesKeyShareSubmittedIterator{contract: _ETHDKGPhases.contract, event: "KeyShareSubmitted", logs: logs, sub: sub}, nil
}

// WatchKeyShareSubmitted is a free log subscription operation binding the contract event 0x6162e2d11398e4063e4c8565dafc4fb6755bbead93747ea836a5ef73a594aaf7.
//
// Solidity: event KeyShareSubmitted(address account, uint256 index, uint256 nonce, uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchKeyShareSubmitted(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesKeyShareSubmitted) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "KeyShareSubmitted")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesKeyShareSubmitted)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "KeyShareSubmitted", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseKeyShareSubmitted(log types.Log) (*ETHDKGPhasesKeyShareSubmitted, error) {
	event := new(ETHDKGPhasesKeyShareSubmitted)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "KeyShareSubmitted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesMPKSetIterator is returned from FilterMPKSet and is used to iterate over the raw logs and unpacked data for MPKSet events raised by the ETHDKGPhases contract.
type ETHDKGPhasesMPKSetIterator struct {
	Event *ETHDKGPhasesMPKSet // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesMPKSetIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesMPKSet)
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
		it.Event = new(ETHDKGPhasesMPKSet)
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
func (it *ETHDKGPhasesMPKSetIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesMPKSetIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesMPKSet represents a MPKSet event raised by the ETHDKGPhases contract.
type ETHDKGPhasesMPKSet struct {
	BlockNumber *big.Int
	Nonce       *big.Int
	Mpk         [4]*big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterMPKSet is a free log retrieval operation binding the contract event 0x71b1ebd27be320895a22125d6458e3363aefa6944a312ede4bf275867e6d5a71.
//
// Solidity: event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterMPKSet(opts *bind.FilterOpts) (*ETHDKGPhasesMPKSetIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "MPKSet")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesMPKSetIterator{contract: _ETHDKGPhases.contract, event: "MPKSet", logs: logs, sub: sub}, nil
}

// WatchMPKSet is a free log subscription operation binding the contract event 0x71b1ebd27be320895a22125d6458e3363aefa6944a312ede4bf275867e6d5a71.
//
// Solidity: event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchMPKSet(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesMPKSet) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "MPKSet")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesMPKSet)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "MPKSet", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseMPKSet(log types.Log) (*ETHDKGPhasesMPKSet, error) {
	event := new(ETHDKGPhasesMPKSet)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "MPKSet", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesRegistrationCompleteIterator is returned from FilterRegistrationComplete and is used to iterate over the raw logs and unpacked data for RegistrationComplete events raised by the ETHDKGPhases contract.
type ETHDKGPhasesRegistrationCompleteIterator struct {
	Event *ETHDKGPhasesRegistrationComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesRegistrationCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesRegistrationComplete)
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
		it.Event = new(ETHDKGPhasesRegistrationComplete)
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
func (it *ETHDKGPhasesRegistrationCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesRegistrationCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesRegistrationComplete represents a RegistrationComplete event raised by the ETHDKGPhases contract.
type ETHDKGPhasesRegistrationComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterRegistrationComplete is a free log retrieval operation binding the contract event 0x833013b96b786b4eca83baac286920e5e53956c21ff3894f1d9f02e97d6ed764.
//
// Solidity: event RegistrationComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterRegistrationComplete(opts *bind.FilterOpts) (*ETHDKGPhasesRegistrationCompleteIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "RegistrationComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesRegistrationCompleteIterator{contract: _ETHDKGPhases.contract, event: "RegistrationComplete", logs: logs, sub: sub}, nil
}

// WatchRegistrationComplete is a free log subscription operation binding the contract event 0x833013b96b786b4eca83baac286920e5e53956c21ff3894f1d9f02e97d6ed764.
//
// Solidity: event RegistrationComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchRegistrationComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesRegistrationComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "RegistrationComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesRegistrationComplete)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "RegistrationComplete", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseRegistrationComplete(log types.Log) (*ETHDKGPhasesRegistrationComplete, error) {
	event := new(ETHDKGPhasesRegistrationComplete)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "RegistrationComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesRegistrationOpenedIterator is returned from FilterRegistrationOpened and is used to iterate over the raw logs and unpacked data for RegistrationOpened events raised by the ETHDKGPhases contract.
type ETHDKGPhasesRegistrationOpenedIterator struct {
	Event *ETHDKGPhasesRegistrationOpened // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesRegistrationOpenedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesRegistrationOpened)
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
		it.Event = new(ETHDKGPhasesRegistrationOpened)
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
func (it *ETHDKGPhasesRegistrationOpenedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesRegistrationOpenedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesRegistrationOpened represents a RegistrationOpened event raised by the ETHDKGPhases contract.
type ETHDKGPhasesRegistrationOpened struct {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterRegistrationOpened(opts *bind.FilterOpts) (*ETHDKGPhasesRegistrationOpenedIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "RegistrationOpened")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesRegistrationOpenedIterator{contract: _ETHDKGPhases.contract, event: "RegistrationOpened", logs: logs, sub: sub}, nil
}

// WatchRegistrationOpened is a free log subscription operation binding the contract event 0xbda431b9b63510f1398bf33d700e013315bcba905507078a1780f13ea5b354b9.
//
// Solidity: event RegistrationOpened(uint256 startBlock, uint256 numberValidators, uint256 nonce, uint256 phaseLength, uint256 confirmationLength)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchRegistrationOpened(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesRegistrationOpened) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "RegistrationOpened")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesRegistrationOpened)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "RegistrationOpened", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseRegistrationOpened(log types.Log) (*ETHDKGPhasesRegistrationOpened, error) {
	event := new(ETHDKGPhasesRegistrationOpened)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "RegistrationOpened", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesShareDistributionCompleteIterator is returned from FilterShareDistributionComplete and is used to iterate over the raw logs and unpacked data for ShareDistributionComplete events raised by the ETHDKGPhases contract.
type ETHDKGPhasesShareDistributionCompleteIterator struct {
	Event *ETHDKGPhasesShareDistributionComplete // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesShareDistributionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesShareDistributionComplete)
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
		it.Event = new(ETHDKGPhasesShareDistributionComplete)
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
func (it *ETHDKGPhasesShareDistributionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesShareDistributionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesShareDistributionComplete represents a ShareDistributionComplete event raised by the ETHDKGPhases contract.
type ETHDKGPhasesShareDistributionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterShareDistributionComplete is a free log retrieval operation binding the contract event 0xbfe94ffef5ddde4d25ac7b652f3f67686ea63f9badbfe1f25451e26fc262d11c.
//
// Solidity: event ShareDistributionComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterShareDistributionComplete(opts *bind.FilterOpts) (*ETHDKGPhasesShareDistributionCompleteIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "ShareDistributionComplete")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesShareDistributionCompleteIterator{contract: _ETHDKGPhases.contract, event: "ShareDistributionComplete", logs: logs, sub: sub}, nil
}

// WatchShareDistributionComplete is a free log subscription operation binding the contract event 0xbfe94ffef5ddde4d25ac7b652f3f67686ea63f9badbfe1f25451e26fc262d11c.
//
// Solidity: event ShareDistributionComplete(uint256 blockNumber)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchShareDistributionComplete(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesShareDistributionComplete) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "ShareDistributionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesShareDistributionComplete)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "ShareDistributionComplete", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseShareDistributionComplete(log types.Log) (*ETHDKGPhasesShareDistributionComplete, error) {
	event := new(ETHDKGPhasesShareDistributionComplete)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "ShareDistributionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesSharesDistributedIterator is returned from FilterSharesDistributed and is used to iterate over the raw logs and unpacked data for SharesDistributed events raised by the ETHDKGPhases contract.
type ETHDKGPhasesSharesDistributedIterator struct {
	Event *ETHDKGPhasesSharesDistributed // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesSharesDistributedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesSharesDistributed)
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
		it.Event = new(ETHDKGPhasesSharesDistributed)
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
func (it *ETHDKGPhasesSharesDistributedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesSharesDistributedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesSharesDistributed represents a SharesDistributed event raised by the ETHDKGPhases contract.
type ETHDKGPhasesSharesDistributed struct {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterSharesDistributed(opts *bind.FilterOpts) (*ETHDKGPhasesSharesDistributedIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "SharesDistributed")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesSharesDistributedIterator{contract: _ETHDKGPhases.contract, event: "SharesDistributed", logs: logs, sub: sub}, nil
}

// WatchSharesDistributed is a free log subscription operation binding the contract event 0xf0c8b0ef2867c2b4639b404a0296b6bbf0bf97e20856af42144a5a6035c0d0d2.
//
// Solidity: event SharesDistributed(address account, uint256 index, uint256 nonce, uint256[] encryptedShares, uint256[2][] commitments)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchSharesDistributed(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesSharesDistributed) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "SharesDistributed")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesSharesDistributed)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "SharesDistributed", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseSharesDistributed(log types.Log) (*ETHDKGPhasesSharesDistributed, error) {
	event := new(ETHDKGPhasesSharesDistributed)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "SharesDistributed", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesValidatorMemberAddedIterator is returned from FilterValidatorMemberAdded and is used to iterate over the raw logs and unpacked data for ValidatorMemberAdded events raised by the ETHDKGPhases contract.
type ETHDKGPhasesValidatorMemberAddedIterator struct {
	Event *ETHDKGPhasesValidatorMemberAdded // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesValidatorMemberAddedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesValidatorMemberAdded)
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
		it.Event = new(ETHDKGPhasesValidatorMemberAdded)
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
func (it *ETHDKGPhasesValidatorMemberAddedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesValidatorMemberAddedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesValidatorMemberAdded represents a ValidatorMemberAdded event raised by the ETHDKGPhases contract.
type ETHDKGPhasesValidatorMemberAdded struct {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterValidatorMemberAdded(opts *bind.FilterOpts) (*ETHDKGPhasesValidatorMemberAddedIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "ValidatorMemberAdded")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesValidatorMemberAddedIterator{contract: _ETHDKGPhases.contract, event: "ValidatorMemberAdded", logs: logs, sub: sub}, nil
}

// WatchValidatorMemberAdded is a free log subscription operation binding the contract event 0x09b90b08bbc3dbe22e9d2a0bc9c2c7614c7511cd0ad72177727a1e762115bf06.
//
// Solidity: event ValidatorMemberAdded(address account, uint256 index, uint256 nonce, uint256 epoch, uint256 share0, uint256 share1, uint256 share2, uint256 share3)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchValidatorMemberAdded(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesValidatorMemberAdded) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "ValidatorMemberAdded")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesValidatorMemberAdded)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "ValidatorMemberAdded", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseValidatorMemberAdded(log types.Log) (*ETHDKGPhasesValidatorMemberAdded, error) {
	event := new(ETHDKGPhasesValidatorMemberAdded)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "ValidatorMemberAdded", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ETHDKGPhasesValidatorSetCompletedIterator is returned from FilterValidatorSetCompleted and is used to iterate over the raw logs and unpacked data for ValidatorSetCompleted events raised by the ETHDKGPhases contract.
type ETHDKGPhasesValidatorSetCompletedIterator struct {
	Event *ETHDKGPhasesValidatorSetCompleted // Event containing the contract specifics and raw log

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
func (it *ETHDKGPhasesValidatorSetCompletedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ETHDKGPhasesValidatorSetCompleted)
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
		it.Event = new(ETHDKGPhasesValidatorSetCompleted)
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
func (it *ETHDKGPhasesValidatorSetCompletedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ETHDKGPhasesValidatorSetCompletedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ETHDKGPhasesValidatorSetCompleted represents a ValidatorSetCompleted event raised by the ETHDKGPhases contract.
type ETHDKGPhasesValidatorSetCompleted struct {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) FilterValidatorSetCompleted(opts *bind.FilterOpts) (*ETHDKGPhasesValidatorSetCompletedIterator, error) {

	logs, sub, err := _ETHDKGPhases.contract.FilterLogs(opts, "ValidatorSetCompleted")
	if err != nil {
		return nil, err
	}
	return &ETHDKGPhasesValidatorSetCompletedIterator{contract: _ETHDKGPhases.contract, event: "ValidatorSetCompleted", logs: logs, sub: sub}, nil
}

// WatchValidatorSetCompleted is a free log subscription operation binding the contract event 0xd7237b781669fa700ecf77be6cd8fa0f4b98b1a24ac584a9b6b44c509216718a.
//
// Solidity: event ValidatorSetCompleted(uint256 validatorCount, uint256 nonce, uint256 epoch, uint256 ethHeight, uint256 madHeight, uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3)
func (_ETHDKGPhases *ETHDKGPhasesFilterer) WatchValidatorSetCompleted(opts *bind.WatchOpts, sink chan<- *ETHDKGPhasesValidatorSetCompleted) (event.Subscription, error) {

	logs, sub, err := _ETHDKGPhases.contract.WatchLogs(opts, "ValidatorSetCompleted")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ETHDKGPhasesValidatorSetCompleted)
				if err := _ETHDKGPhases.contract.UnpackLog(event, "ValidatorSetCompleted", log); err != nil {
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
func (_ETHDKGPhases *ETHDKGPhasesFilterer) ParseValidatorSetCompleted(log types.Log) (*ETHDKGPhasesValidatorSetCompleted, error) {
	event := new(ETHDKGPhasesValidatorSetCompleted)
	if err := _ETHDKGPhases.contract.UnpackLog(event, "ValidatorSetCompleted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
