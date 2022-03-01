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

// Participant is an auto generated low-level Go binding around an user-defined struct.
type Participant struct {
	PublicKey                   [2]*big.Int
	Nonce                       uint64
	Index                       uint64
	Phase                       uint8
	DistributedSharesHash       [32]byte
	CommitmentsFirstCoefficient [2]*big.Int
	KeyShares                   [2]*big.Int
	Gpkj                        [4]*big.Int
}

// IETHDKGMetaData contains all meta data concerning the IETHDKG contract.
var IETHDKGMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantDidNotDistributeShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantDidNotSubmitGPKJ\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantDidNotSubmitKeyShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"dishonestAddress\",\"type\":\"address\"},{\"internalType\":\"uint256[]\",\"name\":\"encryptedShares\",\"type\":\"uint256[]\"},{\"internalType\":\"uint256[2][]\",\"name\":\"commitments\",\"type\":\"uint256[2][]\"},{\"internalType\":\"uint256[2]\",\"name\":\"sharedKey\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[2]\",\"name\":\"sharedKeyCorrectnessProof\",\"type\":\"uint256[2]\"}],\"name\":\"accuseParticipantDistributedBadShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"dishonestAddresses\",\"type\":\"address[]\"}],\"name\":\"accuseParticipantNotRegistered\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"validators\",\"type\":\"address[]\"},{\"internalType\":\"bytes32[]\",\"name\":\"encryptedSharesHash\",\"type\":\"bytes32[]\"},{\"internalType\":\"uint256[2][][]\",\"name\":\"commitments\",\"type\":\"uint256[2][][]\"},{\"internalType\":\"address\",\"name\":\"dishonestAddress\",\"type\":\"address\"}],\"name\":\"accuseParticipantSubmittedBadGPKJ\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"complete\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[]\",\"name\":\"encryptedShares\",\"type\":\"uint256[]\"},{\"internalType\":\"uint256[2][]\",\"name\":\"commitments\",\"type\":\"uint256[2][]\"}],\"name\":\"distributeShares\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getBadParticipants\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getConfirmationLength\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getETHDKGPhase\",\"outputs\":[{\"internalType\":\"enumPhase\",\"name\":\"\",\"type\":\"uint8\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getMasterPublicKey\",\"outputs\":[{\"internalType\":\"uint256[4]\",\"name\":\"\",\"type\":\"uint256[4]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getMinValidators\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getNonce\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getNumParticipants\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"participant\",\"type\":\"address\"}],\"name\":\"getParticipantInternalState\",\"outputs\":[{\"components\":[{\"internalType\":\"uint256[2]\",\"name\":\"publicKey\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint64\",\"name\":\"nonce\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"index\",\"type\":\"uint64\"},{\"internalType\":\"enumPhase\",\"name\":\"phase\",\"type\":\"uint8\"},{\"internalType\":\"bytes32\",\"name\":\"distributedSharesHash\",\"type\":\"bytes32\"},{\"internalType\":\"uint256[2]\",\"name\":\"commitmentsFirstCoefficient\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[2]\",\"name\":\"keyShares\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[4]\",\"name\":\"gpkj\",\"type\":\"uint256[4]\"}],\"internalType\":\"structParticipant\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getPhaseLength\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getPhaseStartBlock\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"initializeETHDKG\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"isETHDKGRunning\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"isMasterPublicKeySet\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[2]\",\"name\":\"publicKey\",\"type\":\"uint256[2]\"}],\"name\":\"register\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint16\",\"name\":\"confirmationLength_\",\"type\":\"uint16\"}],\"name\":\"setConfirmationLength\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"madnetHeight\",\"type\":\"uint256\"}],\"name\":\"setCustomMadnetHeight\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint16\",\"name\":\"phaseLength_\",\"type\":\"uint16\"}],\"name\":\"setPhaseLength\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[4]\",\"name\":\"gpkj\",\"type\":\"uint256[4]\"}],\"name\":\"submitGPKJ\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1CorrectnessProof\",\"type\":\"uint256[2]\"},{\"internalType\":\"uint256[4]\",\"name\":\"keyShareG2\",\"type\":\"uint256[4]\"}],\"name\":\"submitKeyShare\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256[4]\",\"name\":\"masterPublicKey_\",\"type\":\"uint256[4]\"}],\"name\":\"submitMasterPublicKey\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"participant\",\"type\":\"address\"}],\"name\":\"tryGetParticipantIndex\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]",
}

// IETHDKGABI is the input ABI used to generate the binding from.
// Deprecated: Use IETHDKGMetaData.ABI instead.
var IETHDKGABI = IETHDKGMetaData.ABI

// IETHDKG is an auto generated Go binding around an Ethereum contract.
type IETHDKG struct {
	IETHDKGCaller     // Read-only binding to the contract
	IETHDKGTransactor // Write-only binding to the contract
	IETHDKGFilterer   // Log filterer for contract events
}

// IETHDKGCaller is an auto generated read-only Go binding around an Ethereum contract.
type IETHDKGCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IETHDKGTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IETHDKGTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IETHDKGFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IETHDKGFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IETHDKGSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IETHDKGSession struct {
	Contract     *IETHDKG          // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IETHDKGCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IETHDKGCallerSession struct {
	Contract *IETHDKGCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts  // Call options to use throughout this session
}

// IETHDKGTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IETHDKGTransactorSession struct {
	Contract     *IETHDKGTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// IETHDKGRaw is an auto generated low-level Go binding around an Ethereum contract.
type IETHDKGRaw struct {
	Contract *IETHDKG // Generic contract binding to access the raw methods on
}

// IETHDKGCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IETHDKGCallerRaw struct {
	Contract *IETHDKGCaller // Generic read-only contract binding to access the raw methods on
}

// IETHDKGTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IETHDKGTransactorRaw struct {
	Contract *IETHDKGTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIETHDKG creates a new instance of IETHDKG, bound to a specific deployed contract.
func NewIETHDKG(address common.Address, backend bind.ContractBackend) (*IETHDKG, error) {
	contract, err := bindIETHDKG(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IETHDKG{IETHDKGCaller: IETHDKGCaller{contract: contract}, IETHDKGTransactor: IETHDKGTransactor{contract: contract}, IETHDKGFilterer: IETHDKGFilterer{contract: contract}}, nil
}

// NewIETHDKGCaller creates a new read-only instance of IETHDKG, bound to a specific deployed contract.
func NewIETHDKGCaller(address common.Address, caller bind.ContractCaller) (*IETHDKGCaller, error) {
	contract, err := bindIETHDKG(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IETHDKGCaller{contract: contract}, nil
}

// NewIETHDKGTransactor creates a new write-only instance of IETHDKG, bound to a specific deployed contract.
func NewIETHDKGTransactor(address common.Address, transactor bind.ContractTransactor) (*IETHDKGTransactor, error) {
	contract, err := bindIETHDKG(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IETHDKGTransactor{contract: contract}, nil
}

// NewIETHDKGFilterer creates a new log filterer instance of IETHDKG, bound to a specific deployed contract.
func NewIETHDKGFilterer(address common.Address, filterer bind.ContractFilterer) (*IETHDKGFilterer, error) {
	contract, err := bindIETHDKG(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IETHDKGFilterer{contract: contract}, nil
}

// bindIETHDKG binds a generic wrapper to an already deployed contract.
func bindIETHDKG(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(IETHDKGABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IETHDKG *IETHDKGRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IETHDKG.Contract.IETHDKGCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IETHDKG *IETHDKGRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IETHDKG.Contract.IETHDKGTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IETHDKG *IETHDKGRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IETHDKG.Contract.IETHDKGTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IETHDKG *IETHDKGCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IETHDKG.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IETHDKG *IETHDKGTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IETHDKG.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IETHDKG *IETHDKGTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IETHDKG.Contract.contract.Transact(opts, method, params...)
}

// GetBadParticipants is a free data retrieval call binding the contract method 0x32d4d570.
//
// Solidity: function getBadParticipants() view returns(uint256)
func (_IETHDKG *IETHDKGCaller) GetBadParticipants(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getBadParticipants")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetBadParticipants is a free data retrieval call binding the contract method 0x32d4d570.
//
// Solidity: function getBadParticipants() view returns(uint256)
func (_IETHDKG *IETHDKGSession) GetBadParticipants() (*big.Int, error) {
	return _IETHDKG.Contract.GetBadParticipants(&_IETHDKG.CallOpts)
}

// GetBadParticipants is a free data retrieval call binding the contract method 0x32d4d570.
//
// Solidity: function getBadParticipants() view returns(uint256)
func (_IETHDKG *IETHDKGCallerSession) GetBadParticipants() (*big.Int, error) {
	return _IETHDKG.Contract.GetBadParticipants(&_IETHDKG.CallOpts)
}

// GetConfirmationLength is a free data retrieval call binding the contract method 0x8c848d32.
//
// Solidity: function getConfirmationLength() view returns(uint256)
func (_IETHDKG *IETHDKGCaller) GetConfirmationLength(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getConfirmationLength")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetConfirmationLength is a free data retrieval call binding the contract method 0x8c848d32.
//
// Solidity: function getConfirmationLength() view returns(uint256)
func (_IETHDKG *IETHDKGSession) GetConfirmationLength() (*big.Int, error) {
	return _IETHDKG.Contract.GetConfirmationLength(&_IETHDKG.CallOpts)
}

// GetConfirmationLength is a free data retrieval call binding the contract method 0x8c848d32.
//
// Solidity: function getConfirmationLength() view returns(uint256)
func (_IETHDKG *IETHDKGCallerSession) GetConfirmationLength() (*big.Int, error) {
	return _IETHDKG.Contract.GetConfirmationLength(&_IETHDKG.CallOpts)
}

// GetETHDKGPhase is a free data retrieval call binding the contract method 0x2958e81c.
//
// Solidity: function getETHDKGPhase() view returns(uint8)
func (_IETHDKG *IETHDKGCaller) GetETHDKGPhase(opts *bind.CallOpts) (uint8, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getETHDKGPhase")

	if err != nil {
		return *new(uint8), err
	}

	out0 := *abi.ConvertType(out[0], new(uint8)).(*uint8)

	return out0, err

}

// GetETHDKGPhase is a free data retrieval call binding the contract method 0x2958e81c.
//
// Solidity: function getETHDKGPhase() view returns(uint8)
func (_IETHDKG *IETHDKGSession) GetETHDKGPhase() (uint8, error) {
	return _IETHDKG.Contract.GetETHDKGPhase(&_IETHDKG.CallOpts)
}

// GetETHDKGPhase is a free data retrieval call binding the contract method 0x2958e81c.
//
// Solidity: function getETHDKGPhase() view returns(uint8)
func (_IETHDKG *IETHDKGCallerSession) GetETHDKGPhase() (uint8, error) {
	return _IETHDKG.Contract.GetETHDKGPhase(&_IETHDKG.CallOpts)
}

// GetMasterPublicKey is a free data retrieval call binding the contract method 0xe146372a.
//
// Solidity: function getMasterPublicKey() view returns(uint256[4])
func (_IETHDKG *IETHDKGCaller) GetMasterPublicKey(opts *bind.CallOpts) ([4]*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getMasterPublicKey")

	if err != nil {
		return *new([4]*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new([4]*big.Int)).(*[4]*big.Int)

	return out0, err

}

// GetMasterPublicKey is a free data retrieval call binding the contract method 0xe146372a.
//
// Solidity: function getMasterPublicKey() view returns(uint256[4])
func (_IETHDKG *IETHDKGSession) GetMasterPublicKey() ([4]*big.Int, error) {
	return _IETHDKG.Contract.GetMasterPublicKey(&_IETHDKG.CallOpts)
}

// GetMasterPublicKey is a free data retrieval call binding the contract method 0xe146372a.
//
// Solidity: function getMasterPublicKey() view returns(uint256[4])
func (_IETHDKG *IETHDKGCallerSession) GetMasterPublicKey() ([4]*big.Int, error) {
	return _IETHDKG.Contract.GetMasterPublicKey(&_IETHDKG.CallOpts)
}

// GetMinValidators is a free data retrieval call binding the contract method 0xecbadb36.
//
// Solidity: function getMinValidators() view returns(uint256)
func (_IETHDKG *IETHDKGCaller) GetMinValidators(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getMinValidators")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetMinValidators is a free data retrieval call binding the contract method 0xecbadb36.
//
// Solidity: function getMinValidators() view returns(uint256)
func (_IETHDKG *IETHDKGSession) GetMinValidators() (*big.Int, error) {
	return _IETHDKG.Contract.GetMinValidators(&_IETHDKG.CallOpts)
}

// GetMinValidators is a free data retrieval call binding the contract method 0xecbadb36.
//
// Solidity: function getMinValidators() view returns(uint256)
func (_IETHDKG *IETHDKGCallerSession) GetMinValidators() (*big.Int, error) {
	return _IETHDKG.Contract.GetMinValidators(&_IETHDKG.CallOpts)
}

// GetNonce is a free data retrieval call binding the contract method 0xd087d288.
//
// Solidity: function getNonce() view returns(uint256)
func (_IETHDKG *IETHDKGCaller) GetNonce(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getNonce")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetNonce is a free data retrieval call binding the contract method 0xd087d288.
//
// Solidity: function getNonce() view returns(uint256)
func (_IETHDKG *IETHDKGSession) GetNonce() (*big.Int, error) {
	return _IETHDKG.Contract.GetNonce(&_IETHDKG.CallOpts)
}

// GetNonce is a free data retrieval call binding the contract method 0xd087d288.
//
// Solidity: function getNonce() view returns(uint256)
func (_IETHDKG *IETHDKGCallerSession) GetNonce() (*big.Int, error) {
	return _IETHDKG.Contract.GetNonce(&_IETHDKG.CallOpts)
}

// GetNumParticipants is a free data retrieval call binding the contract method 0xfd478ca9.
//
// Solidity: function getNumParticipants() view returns(uint256)
func (_IETHDKG *IETHDKGCaller) GetNumParticipants(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getNumParticipants")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetNumParticipants is a free data retrieval call binding the contract method 0xfd478ca9.
//
// Solidity: function getNumParticipants() view returns(uint256)
func (_IETHDKG *IETHDKGSession) GetNumParticipants() (*big.Int, error) {
	return _IETHDKG.Contract.GetNumParticipants(&_IETHDKG.CallOpts)
}

// GetNumParticipants is a free data retrieval call binding the contract method 0xfd478ca9.
//
// Solidity: function getNumParticipants() view returns(uint256)
func (_IETHDKG *IETHDKGCallerSession) GetNumParticipants() (*big.Int, error) {
	return _IETHDKG.Contract.GetNumParticipants(&_IETHDKG.CallOpts)
}

// GetParticipantInternalState is a free data retrieval call binding the contract method 0xbf7786b6.
//
// Solidity: function getParticipantInternalState(address participant) view returns((uint256[2],uint64,uint64,uint8,bytes32,uint256[2],uint256[2],uint256[4]))
func (_IETHDKG *IETHDKGCaller) GetParticipantInternalState(opts *bind.CallOpts, participant common.Address) (Participant, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getParticipantInternalState", participant)

	if err != nil {
		return *new(Participant), err
	}

	out0 := *abi.ConvertType(out[0], new(Participant)).(*Participant)

	return out0, err

}

// GetParticipantInternalState is a free data retrieval call binding the contract method 0xbf7786b6.
//
// Solidity: function getParticipantInternalState(address participant) view returns((uint256[2],uint64,uint64,uint8,bytes32,uint256[2],uint256[2],uint256[4]))
func (_IETHDKG *IETHDKGSession) GetParticipantInternalState(participant common.Address) (Participant, error) {
	return _IETHDKG.Contract.GetParticipantInternalState(&_IETHDKG.CallOpts, participant)
}

// GetParticipantInternalState is a free data retrieval call binding the contract method 0xbf7786b6.
//
// Solidity: function getParticipantInternalState(address participant) view returns((uint256[2],uint64,uint64,uint8,bytes32,uint256[2],uint256[2],uint256[4]))
func (_IETHDKG *IETHDKGCallerSession) GetParticipantInternalState(participant common.Address) (Participant, error) {
	return _IETHDKG.Contract.GetParticipantInternalState(&_IETHDKG.CallOpts, participant)
}

// GetPhaseLength is a free data retrieval call binding the contract method 0x106da57d.
//
// Solidity: function getPhaseLength() view returns(uint256)
func (_IETHDKG *IETHDKGCaller) GetPhaseLength(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getPhaseLength")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetPhaseLength is a free data retrieval call binding the contract method 0x106da57d.
//
// Solidity: function getPhaseLength() view returns(uint256)
func (_IETHDKG *IETHDKGSession) GetPhaseLength() (*big.Int, error) {
	return _IETHDKG.Contract.GetPhaseLength(&_IETHDKG.CallOpts)
}

// GetPhaseLength is a free data retrieval call binding the contract method 0x106da57d.
//
// Solidity: function getPhaseLength() view returns(uint256)
func (_IETHDKG *IETHDKGCallerSession) GetPhaseLength() (*big.Int, error) {
	return _IETHDKG.Contract.GetPhaseLength(&_IETHDKG.CallOpts)
}

// GetPhaseStartBlock is a free data retrieval call binding the contract method 0xa2bc9c78.
//
// Solidity: function getPhaseStartBlock() view returns(uint256)
func (_IETHDKG *IETHDKGCaller) GetPhaseStartBlock(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "getPhaseStartBlock")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetPhaseStartBlock is a free data retrieval call binding the contract method 0xa2bc9c78.
//
// Solidity: function getPhaseStartBlock() view returns(uint256)
func (_IETHDKG *IETHDKGSession) GetPhaseStartBlock() (*big.Int, error) {
	return _IETHDKG.Contract.GetPhaseStartBlock(&_IETHDKG.CallOpts)
}

// GetPhaseStartBlock is a free data retrieval call binding the contract method 0xa2bc9c78.
//
// Solidity: function getPhaseStartBlock() view returns(uint256)
func (_IETHDKG *IETHDKGCallerSession) GetPhaseStartBlock() (*big.Int, error) {
	return _IETHDKG.Contract.GetPhaseStartBlock(&_IETHDKG.CallOpts)
}

// IsETHDKGRunning is a free data retrieval call binding the contract method 0x747b217c.
//
// Solidity: function isETHDKGRunning() view returns(bool)
func (_IETHDKG *IETHDKGCaller) IsETHDKGRunning(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "isETHDKGRunning")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsETHDKGRunning is a free data retrieval call binding the contract method 0x747b217c.
//
// Solidity: function isETHDKGRunning() view returns(bool)
func (_IETHDKG *IETHDKGSession) IsETHDKGRunning() (bool, error) {
	return _IETHDKG.Contract.IsETHDKGRunning(&_IETHDKG.CallOpts)
}

// IsETHDKGRunning is a free data retrieval call binding the contract method 0x747b217c.
//
// Solidity: function isETHDKGRunning() view returns(bool)
func (_IETHDKG *IETHDKGCallerSession) IsETHDKGRunning() (bool, error) {
	return _IETHDKG.Contract.IsETHDKGRunning(&_IETHDKG.CallOpts)
}

// IsMasterPublicKeySet is a free data retrieval call binding the contract method 0x08efcf16.
//
// Solidity: function isMasterPublicKeySet() view returns(bool)
func (_IETHDKG *IETHDKGCaller) IsMasterPublicKeySet(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "isMasterPublicKeySet")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsMasterPublicKeySet is a free data retrieval call binding the contract method 0x08efcf16.
//
// Solidity: function isMasterPublicKeySet() view returns(bool)
func (_IETHDKG *IETHDKGSession) IsMasterPublicKeySet() (bool, error) {
	return _IETHDKG.Contract.IsMasterPublicKeySet(&_IETHDKG.CallOpts)
}

// IsMasterPublicKeySet is a free data retrieval call binding the contract method 0x08efcf16.
//
// Solidity: function isMasterPublicKeySet() view returns(bool)
func (_IETHDKG *IETHDKGCallerSession) IsMasterPublicKeySet() (bool, error) {
	return _IETHDKG.Contract.IsMasterPublicKeySet(&_IETHDKG.CallOpts)
}

// TryGetParticipantIndex is a free data retrieval call binding the contract method 0x65e62b9b.
//
// Solidity: function tryGetParticipantIndex(address participant) view returns(bool, uint256)
func (_IETHDKG *IETHDKGCaller) TryGetParticipantIndex(opts *bind.CallOpts, participant common.Address) (bool, *big.Int, error) {
	var out []interface{}
	err := _IETHDKG.contract.Call(opts, &out, "tryGetParticipantIndex", participant)

	if err != nil {
		return *new(bool), *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	out1 := *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)

	return out0, out1, err

}

// TryGetParticipantIndex is a free data retrieval call binding the contract method 0x65e62b9b.
//
// Solidity: function tryGetParticipantIndex(address participant) view returns(bool, uint256)
func (_IETHDKG *IETHDKGSession) TryGetParticipantIndex(participant common.Address) (bool, *big.Int, error) {
	return _IETHDKG.Contract.TryGetParticipantIndex(&_IETHDKG.CallOpts, participant)
}

// TryGetParticipantIndex is a free data retrieval call binding the contract method 0x65e62b9b.
//
// Solidity: function tryGetParticipantIndex(address participant) view returns(bool, uint256)
func (_IETHDKG *IETHDKGCallerSession) TryGetParticipantIndex(participant common.Address) (bool, *big.Int, error) {
	return _IETHDKG.Contract.TryGetParticipantIndex(&_IETHDKG.CallOpts, participant)
}

// AccuseParticipantDidNotDistributeShares is a paid mutator transaction binding the contract method 0xdae681bc.
//
// Solidity: function accuseParticipantDidNotDistributeShares(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactor) AccuseParticipantDidNotDistributeShares(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "accuseParticipantDidNotDistributeShares", dishonestAddresses)
}

// AccuseParticipantDidNotDistributeShares is a paid mutator transaction binding the contract method 0xdae681bc.
//
// Solidity: function accuseParticipantDidNotDistributeShares(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGSession) AccuseParticipantDidNotDistributeShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDidNotDistributeShares(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotDistributeShares is a paid mutator transaction binding the contract method 0xdae681bc.
//
// Solidity: function accuseParticipantDidNotDistributeShares(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactorSession) AccuseParticipantDidNotDistributeShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDidNotDistributeShares(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitGPKJ is a paid mutator transaction binding the contract method 0x7df24ee9.
//
// Solidity: function accuseParticipantDidNotSubmitGPKJ(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactor) AccuseParticipantDidNotSubmitGPKJ(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "accuseParticipantDidNotSubmitGPKJ", dishonestAddresses)
}

// AccuseParticipantDidNotSubmitGPKJ is a paid mutator transaction binding the contract method 0x7df24ee9.
//
// Solidity: function accuseParticipantDidNotSubmitGPKJ(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGSession) AccuseParticipantDidNotSubmitGPKJ(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDidNotSubmitGPKJ(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitGPKJ is a paid mutator transaction binding the contract method 0x7df24ee9.
//
// Solidity: function accuseParticipantDidNotSubmitGPKJ(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactorSession) AccuseParticipantDidNotSubmitGPKJ(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDidNotSubmitGPKJ(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitKeyShares is a paid mutator transaction binding the contract method 0x043a6f12.
//
// Solidity: function accuseParticipantDidNotSubmitKeyShares(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactor) AccuseParticipantDidNotSubmitKeyShares(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "accuseParticipantDidNotSubmitKeyShares", dishonestAddresses)
}

// AccuseParticipantDidNotSubmitKeyShares is a paid mutator transaction binding the contract method 0x043a6f12.
//
// Solidity: function accuseParticipantDidNotSubmitKeyShares(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGSession) AccuseParticipantDidNotSubmitKeyShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDidNotSubmitKeyShares(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDidNotSubmitKeyShares is a paid mutator transaction binding the contract method 0x043a6f12.
//
// Solidity: function accuseParticipantDidNotSubmitKeyShares(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactorSession) AccuseParticipantDidNotSubmitKeyShares(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDidNotSubmitKeyShares(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantDistributedBadShares is a paid mutator transaction binding the contract method 0xedbe7bf7.
//
// Solidity: function accuseParticipantDistributedBadShares(address dishonestAddress, uint256[] encryptedShares, uint256[2][] commitments, uint256[2] sharedKey, uint256[2] sharedKeyCorrectnessProof) returns()
func (_IETHDKG *IETHDKGTransactor) AccuseParticipantDistributedBadShares(opts *bind.TransactOpts, dishonestAddress common.Address, encryptedShares []*big.Int, commitments [][2]*big.Int, sharedKey [2]*big.Int, sharedKeyCorrectnessProof [2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "accuseParticipantDistributedBadShares", dishonestAddress, encryptedShares, commitments, sharedKey, sharedKeyCorrectnessProof)
}

// AccuseParticipantDistributedBadShares is a paid mutator transaction binding the contract method 0xedbe7bf7.
//
// Solidity: function accuseParticipantDistributedBadShares(address dishonestAddress, uint256[] encryptedShares, uint256[2][] commitments, uint256[2] sharedKey, uint256[2] sharedKeyCorrectnessProof) returns()
func (_IETHDKG *IETHDKGSession) AccuseParticipantDistributedBadShares(dishonestAddress common.Address, encryptedShares []*big.Int, commitments [][2]*big.Int, sharedKey [2]*big.Int, sharedKeyCorrectnessProof [2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDistributedBadShares(&_IETHDKG.TransactOpts, dishonestAddress, encryptedShares, commitments, sharedKey, sharedKeyCorrectnessProof)
}

// AccuseParticipantDistributedBadShares is a paid mutator transaction binding the contract method 0xedbe7bf7.
//
// Solidity: function accuseParticipantDistributedBadShares(address dishonestAddress, uint256[] encryptedShares, uint256[2][] commitments, uint256[2] sharedKey, uint256[2] sharedKeyCorrectnessProof) returns()
func (_IETHDKG *IETHDKGTransactorSession) AccuseParticipantDistributedBadShares(dishonestAddress common.Address, encryptedShares []*big.Int, commitments [][2]*big.Int, sharedKey [2]*big.Int, sharedKeyCorrectnessProof [2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantDistributedBadShares(&_IETHDKG.TransactOpts, dishonestAddress, encryptedShares, commitments, sharedKey, sharedKeyCorrectnessProof)
}

// AccuseParticipantNotRegistered is a paid mutator transaction binding the contract method 0xf72c45b6.
//
// Solidity: function accuseParticipantNotRegistered(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactor) AccuseParticipantNotRegistered(opts *bind.TransactOpts, dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "accuseParticipantNotRegistered", dishonestAddresses)
}

// AccuseParticipantNotRegistered is a paid mutator transaction binding the contract method 0xf72c45b6.
//
// Solidity: function accuseParticipantNotRegistered(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGSession) AccuseParticipantNotRegistered(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantNotRegistered(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantNotRegistered is a paid mutator transaction binding the contract method 0xf72c45b6.
//
// Solidity: function accuseParticipantNotRegistered(address[] dishonestAddresses) returns()
func (_IETHDKG *IETHDKGTransactorSession) AccuseParticipantNotRegistered(dishonestAddresses []common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantNotRegistered(&_IETHDKG.TransactOpts, dishonestAddresses)
}

// AccuseParticipantSubmittedBadGPKJ is a paid mutator transaction binding the contract method 0x80001264.
//
// Solidity: function accuseParticipantSubmittedBadGPKJ(address[] validators, bytes32[] encryptedSharesHash, uint256[2][][] commitments, address dishonestAddress) returns()
func (_IETHDKG *IETHDKGTransactor) AccuseParticipantSubmittedBadGPKJ(opts *bind.TransactOpts, validators []common.Address, encryptedSharesHash [][32]byte, commitments [][][2]*big.Int, dishonestAddress common.Address) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "accuseParticipantSubmittedBadGPKJ", validators, encryptedSharesHash, commitments, dishonestAddress)
}

// AccuseParticipantSubmittedBadGPKJ is a paid mutator transaction binding the contract method 0x80001264.
//
// Solidity: function accuseParticipantSubmittedBadGPKJ(address[] validators, bytes32[] encryptedSharesHash, uint256[2][][] commitments, address dishonestAddress) returns()
func (_IETHDKG *IETHDKGSession) AccuseParticipantSubmittedBadGPKJ(validators []common.Address, encryptedSharesHash [][32]byte, commitments [][][2]*big.Int, dishonestAddress common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantSubmittedBadGPKJ(&_IETHDKG.TransactOpts, validators, encryptedSharesHash, commitments, dishonestAddress)
}

// AccuseParticipantSubmittedBadGPKJ is a paid mutator transaction binding the contract method 0x80001264.
//
// Solidity: function accuseParticipantSubmittedBadGPKJ(address[] validators, bytes32[] encryptedSharesHash, uint256[2][][] commitments, address dishonestAddress) returns()
func (_IETHDKG *IETHDKGTransactorSession) AccuseParticipantSubmittedBadGPKJ(validators []common.Address, encryptedSharesHash [][32]byte, commitments [][][2]*big.Int, dishonestAddress common.Address) (*types.Transaction, error) {
	return _IETHDKG.Contract.AccuseParticipantSubmittedBadGPKJ(&_IETHDKG.TransactOpts, validators, encryptedSharesHash, commitments, dishonestAddress)
}

// Complete is a paid mutator transaction binding the contract method 0x522e1177.
//
// Solidity: function complete() returns()
func (_IETHDKG *IETHDKGTransactor) Complete(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "complete")
}

// Complete is a paid mutator transaction binding the contract method 0x522e1177.
//
// Solidity: function complete() returns()
func (_IETHDKG *IETHDKGSession) Complete() (*types.Transaction, error) {
	return _IETHDKG.Contract.Complete(&_IETHDKG.TransactOpts)
}

// Complete is a paid mutator transaction binding the contract method 0x522e1177.
//
// Solidity: function complete() returns()
func (_IETHDKG *IETHDKGTransactorSession) Complete() (*types.Transaction, error) {
	return _IETHDKG.Contract.Complete(&_IETHDKG.TransactOpts)
}

// DistributeShares is a paid mutator transaction binding the contract method 0x80b97e01.
//
// Solidity: function distributeShares(uint256[] encryptedShares, uint256[2][] commitments) returns()
func (_IETHDKG *IETHDKGTransactor) DistributeShares(opts *bind.TransactOpts, encryptedShares []*big.Int, commitments [][2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "distributeShares", encryptedShares, commitments)
}

// DistributeShares is a paid mutator transaction binding the contract method 0x80b97e01.
//
// Solidity: function distributeShares(uint256[] encryptedShares, uint256[2][] commitments) returns()
func (_IETHDKG *IETHDKGSession) DistributeShares(encryptedShares []*big.Int, commitments [][2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.DistributeShares(&_IETHDKG.TransactOpts, encryptedShares, commitments)
}

// DistributeShares is a paid mutator transaction binding the contract method 0x80b97e01.
//
// Solidity: function distributeShares(uint256[] encryptedShares, uint256[2][] commitments) returns()
func (_IETHDKG *IETHDKGTransactorSession) DistributeShares(encryptedShares []*big.Int, commitments [][2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.DistributeShares(&_IETHDKG.TransactOpts, encryptedShares, commitments)
}

// InitializeETHDKG is a paid mutator transaction binding the contract method 0x57b51c9c.
//
// Solidity: function initializeETHDKG() returns()
func (_IETHDKG *IETHDKGTransactor) InitializeETHDKG(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "initializeETHDKG")
}

// InitializeETHDKG is a paid mutator transaction binding the contract method 0x57b51c9c.
//
// Solidity: function initializeETHDKG() returns()
func (_IETHDKG *IETHDKGSession) InitializeETHDKG() (*types.Transaction, error) {
	return _IETHDKG.Contract.InitializeETHDKG(&_IETHDKG.TransactOpts)
}

// InitializeETHDKG is a paid mutator transaction binding the contract method 0x57b51c9c.
//
// Solidity: function initializeETHDKG() returns()
func (_IETHDKG *IETHDKGTransactorSession) InitializeETHDKG() (*types.Transaction, error) {
	return _IETHDKG.Contract.InitializeETHDKG(&_IETHDKG.TransactOpts)
}

// Register is a paid mutator transaction binding the contract method 0x3442af5c.
//
// Solidity: function register(uint256[2] publicKey) returns()
func (_IETHDKG *IETHDKGTransactor) Register(opts *bind.TransactOpts, publicKey [2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "register", publicKey)
}

// Register is a paid mutator transaction binding the contract method 0x3442af5c.
//
// Solidity: function register(uint256[2] publicKey) returns()
func (_IETHDKG *IETHDKGSession) Register(publicKey [2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.Register(&_IETHDKG.TransactOpts, publicKey)
}

// Register is a paid mutator transaction binding the contract method 0x3442af5c.
//
// Solidity: function register(uint256[2] publicKey) returns()
func (_IETHDKG *IETHDKGTransactorSession) Register(publicKey [2]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.Register(&_IETHDKG.TransactOpts, publicKey)
}

// SetConfirmationLength is a paid mutator transaction binding the contract method 0xff3e5e45.
//
// Solidity: function setConfirmationLength(uint16 confirmationLength_) returns()
func (_IETHDKG *IETHDKGTransactor) SetConfirmationLength(opts *bind.TransactOpts, confirmationLength_ uint16) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "setConfirmationLength", confirmationLength_)
}

// SetConfirmationLength is a paid mutator transaction binding the contract method 0xff3e5e45.
//
// Solidity: function setConfirmationLength(uint16 confirmationLength_) returns()
func (_IETHDKG *IETHDKGSession) SetConfirmationLength(confirmationLength_ uint16) (*types.Transaction, error) {
	return _IETHDKG.Contract.SetConfirmationLength(&_IETHDKG.TransactOpts, confirmationLength_)
}

// SetConfirmationLength is a paid mutator transaction binding the contract method 0xff3e5e45.
//
// Solidity: function setConfirmationLength(uint16 confirmationLength_) returns()
func (_IETHDKG *IETHDKGTransactorSession) SetConfirmationLength(confirmationLength_ uint16) (*types.Transaction, error) {
	return _IETHDKG.Contract.SetConfirmationLength(&_IETHDKG.TransactOpts, confirmationLength_)
}

// SetCustomMadnetHeight is a paid mutator transaction binding the contract method 0x8328cdf7.
//
// Solidity: function setCustomMadnetHeight(uint256 madnetHeight) returns()
func (_IETHDKG *IETHDKGTransactor) SetCustomMadnetHeight(opts *bind.TransactOpts, madnetHeight *big.Int) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "setCustomMadnetHeight", madnetHeight)
}

// SetCustomMadnetHeight is a paid mutator transaction binding the contract method 0x8328cdf7.
//
// Solidity: function setCustomMadnetHeight(uint256 madnetHeight) returns()
func (_IETHDKG *IETHDKGSession) SetCustomMadnetHeight(madnetHeight *big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SetCustomMadnetHeight(&_IETHDKG.TransactOpts, madnetHeight)
}

// SetCustomMadnetHeight is a paid mutator transaction binding the contract method 0x8328cdf7.
//
// Solidity: function setCustomMadnetHeight(uint256 madnetHeight) returns()
func (_IETHDKG *IETHDKGTransactorSession) SetCustomMadnetHeight(madnetHeight *big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SetCustomMadnetHeight(&_IETHDKG.TransactOpts, madnetHeight)
}

// SetPhaseLength is a paid mutator transaction binding the contract method 0x8a3c24cc.
//
// Solidity: function setPhaseLength(uint16 phaseLength_) returns()
func (_IETHDKG *IETHDKGTransactor) SetPhaseLength(opts *bind.TransactOpts, phaseLength_ uint16) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "setPhaseLength", phaseLength_)
}

// SetPhaseLength is a paid mutator transaction binding the contract method 0x8a3c24cc.
//
// Solidity: function setPhaseLength(uint16 phaseLength_) returns()
func (_IETHDKG *IETHDKGSession) SetPhaseLength(phaseLength_ uint16) (*types.Transaction, error) {
	return _IETHDKG.Contract.SetPhaseLength(&_IETHDKG.TransactOpts, phaseLength_)
}

// SetPhaseLength is a paid mutator transaction binding the contract method 0x8a3c24cc.
//
// Solidity: function setPhaseLength(uint16 phaseLength_) returns()
func (_IETHDKG *IETHDKGTransactorSession) SetPhaseLength(phaseLength_ uint16) (*types.Transaction, error) {
	return _IETHDKG.Contract.SetPhaseLength(&_IETHDKG.TransactOpts, phaseLength_)
}

// SubmitGPKJ is a paid mutator transaction binding the contract method 0x101f49c1.
//
// Solidity: function submitGPKJ(uint256[4] gpkj) returns()
func (_IETHDKG *IETHDKGTransactor) SubmitGPKJ(opts *bind.TransactOpts, gpkj [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "submitGPKJ", gpkj)
}

// SubmitGPKJ is a paid mutator transaction binding the contract method 0x101f49c1.
//
// Solidity: function submitGPKJ(uint256[4] gpkj) returns()
func (_IETHDKG *IETHDKGSession) SubmitGPKJ(gpkj [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SubmitGPKJ(&_IETHDKG.TransactOpts, gpkj)
}

// SubmitGPKJ is a paid mutator transaction binding the contract method 0x101f49c1.
//
// Solidity: function submitGPKJ(uint256[4] gpkj) returns()
func (_IETHDKG *IETHDKGTransactorSession) SubmitGPKJ(gpkj [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SubmitGPKJ(&_IETHDKG.TransactOpts, gpkj)
}

// SubmitKeyShare is a paid mutator transaction binding the contract method 0x62a6523e.
//
// Solidity: function submitKeyShare(uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2) returns()
func (_IETHDKG *IETHDKGTransactor) SubmitKeyShare(opts *bind.TransactOpts, keyShareG1 [2]*big.Int, keyShareG1CorrectnessProof [2]*big.Int, keyShareG2 [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "submitKeyShare", keyShareG1, keyShareG1CorrectnessProof, keyShareG2)
}

// SubmitKeyShare is a paid mutator transaction binding the contract method 0x62a6523e.
//
// Solidity: function submitKeyShare(uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2) returns()
func (_IETHDKG *IETHDKGSession) SubmitKeyShare(keyShareG1 [2]*big.Int, keyShareG1CorrectnessProof [2]*big.Int, keyShareG2 [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SubmitKeyShare(&_IETHDKG.TransactOpts, keyShareG1, keyShareG1CorrectnessProof, keyShareG2)
}

// SubmitKeyShare is a paid mutator transaction binding the contract method 0x62a6523e.
//
// Solidity: function submitKeyShare(uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2) returns()
func (_IETHDKG *IETHDKGTransactorSession) SubmitKeyShare(keyShareG1 [2]*big.Int, keyShareG1CorrectnessProof [2]*big.Int, keyShareG2 [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SubmitKeyShare(&_IETHDKG.TransactOpts, keyShareG1, keyShareG1CorrectnessProof, keyShareG2)
}

// SubmitMasterPublicKey is a paid mutator transaction binding the contract method 0xe8323224.
//
// Solidity: function submitMasterPublicKey(uint256[4] masterPublicKey_) returns()
func (_IETHDKG *IETHDKGTransactor) SubmitMasterPublicKey(opts *bind.TransactOpts, masterPublicKey_ [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.contract.Transact(opts, "submitMasterPublicKey", masterPublicKey_)
}

// SubmitMasterPublicKey is a paid mutator transaction binding the contract method 0xe8323224.
//
// Solidity: function submitMasterPublicKey(uint256[4] masterPublicKey_) returns()
func (_IETHDKG *IETHDKGSession) SubmitMasterPublicKey(masterPublicKey_ [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SubmitMasterPublicKey(&_IETHDKG.TransactOpts, masterPublicKey_)
}

// SubmitMasterPublicKey is a paid mutator transaction binding the contract method 0xe8323224.
//
// Solidity: function submitMasterPublicKey(uint256[4] masterPublicKey_) returns()
func (_IETHDKG *IETHDKGTransactorSession) SubmitMasterPublicKey(masterPublicKey_ [4]*big.Int) (*types.Transaction, error) {
	return _IETHDKG.Contract.SubmitMasterPublicKey(&_IETHDKG.TransactOpts, masterPublicKey_)
}
