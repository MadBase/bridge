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

// ValidatorData is an auto generated low-level Go binding around an user-defined struct.
type ValidatorData struct {
	Address common.Address
	TokenID *big.Int
}

// IValidatorPoolMetaData contains all meta data concerning the IValidatorPool contract.
var IValidatorPoolMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[],\"name\":\"claimExitingNFTPosition\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"collectProfits\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"payoutEth\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"payoutToken\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"completeETHDKG\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getDisputerReward\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"validator\",\"type\":\"address\"}],\"name\":\"getLocation\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"validators_\",\"type\":\"address[]\"}],\"name\":\"getLocations\",\"outputs\":[{\"internalType\":\"string[]\",\"name\":\"\",\"type\":\"string[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getMaxNumValidators\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getStakeAmount\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"}],\"name\":\"getValidator\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"}],\"name\":\"getValidatorData\",\"outputs\":[{\"components\":[{\"internalType\":\"address\",\"name\":\"_address\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_tokenID\",\"type\":\"uint256\"}],\"internalType\":\"structValidatorData\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getValidatorsAddresses\",\"outputs\":[{\"internalType\":\"address[]\",\"name\":\"\",\"type\":\"address[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getValidatorsCount\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"initializeETHDKG\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"participant\",\"type\":\"address\"}],\"name\":\"isAccusable\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"isConsensusRunning\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"participant\",\"type\":\"address\"}],\"name\":\"isInExitingQueue\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"isMaintenanceScheduled\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"participant\",\"type\":\"address\"}],\"name\":\"isValidator\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"dishonestValidator_\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"disputer_\",\"type\":\"address\"}],\"name\":\"majorSlash\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"dishonestValidator_\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"disputer_\",\"type\":\"address\"}],\"name\":\"minorSlash\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"pauseConsensus\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"madnetHeight\",\"type\":\"uint256\"}],\"name\":\"pauseConsensusOnArbitraryHeight\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"validators\",\"type\":\"address[]\"},{\"internalType\":\"uint256[]\",\"name\":\"stakerTokenIDs\",\"type\":\"uint256[]\"}],\"name\":\"registerValidators\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"scheduleMaintenance\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"disputerReward_\",\"type\":\"uint256\"}],\"name\":\"setDisputerReward\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"ip\",\"type\":\"string\"}],\"name\":\"setLocation\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"maxNumValidators_\",\"type\":\"uint256\"}],\"name\":\"setMaxNumValidators\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"stakeAmount_\",\"type\":\"uint256\"}],\"name\":\"setStakeAmount\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account_\",\"type\":\"address\"}],\"name\":\"tryGetTokenID\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"unregisterAllValidators\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"validators\",\"type\":\"address[]\"}],\"name\":\"unregisterValidators\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
}

// IValidatorPoolABI is the input ABI used to generate the binding from.
// Deprecated: Use IValidatorPoolMetaData.ABI instead.
var IValidatorPoolABI = IValidatorPoolMetaData.ABI

// IValidatorPool is an auto generated Go binding around an Ethereum contract.
type IValidatorPool struct {
	IValidatorPoolCaller     // Read-only binding to the contract
	IValidatorPoolTransactor // Write-only binding to the contract
	IValidatorPoolFilterer   // Log filterer for contract events
}

// IValidatorPoolCaller is an auto generated read-only Go binding around an Ethereum contract.
type IValidatorPoolCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IValidatorPoolTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IValidatorPoolTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IValidatorPoolFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IValidatorPoolFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IValidatorPoolSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IValidatorPoolSession struct {
	Contract     *IValidatorPool   // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IValidatorPoolCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IValidatorPoolCallerSession struct {
	Contract *IValidatorPoolCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts         // Call options to use throughout this session
}

// IValidatorPoolTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IValidatorPoolTransactorSession struct {
	Contract     *IValidatorPoolTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts         // Transaction auth options to use throughout this session
}

// IValidatorPoolRaw is an auto generated low-level Go binding around an Ethereum contract.
type IValidatorPoolRaw struct {
	Contract *IValidatorPool // Generic contract binding to access the raw methods on
}

// IValidatorPoolCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IValidatorPoolCallerRaw struct {
	Contract *IValidatorPoolCaller // Generic read-only contract binding to access the raw methods on
}

// IValidatorPoolTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IValidatorPoolTransactorRaw struct {
	Contract *IValidatorPoolTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIValidatorPool creates a new instance of IValidatorPool, bound to a specific deployed contract.
func NewIValidatorPool(address common.Address, backend bind.ContractBackend) (*IValidatorPool, error) {
	contract, err := bindIValidatorPool(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IValidatorPool{IValidatorPoolCaller: IValidatorPoolCaller{contract: contract}, IValidatorPoolTransactor: IValidatorPoolTransactor{contract: contract}, IValidatorPoolFilterer: IValidatorPoolFilterer{contract: contract}}, nil
}

// NewIValidatorPoolCaller creates a new read-only instance of IValidatorPool, bound to a specific deployed contract.
func NewIValidatorPoolCaller(address common.Address, caller bind.ContractCaller) (*IValidatorPoolCaller, error) {
	contract, err := bindIValidatorPool(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolCaller{contract: contract}, nil
}

// NewIValidatorPoolTransactor creates a new write-only instance of IValidatorPool, bound to a specific deployed contract.
func NewIValidatorPoolTransactor(address common.Address, transactor bind.ContractTransactor) (*IValidatorPoolTransactor, error) {
	contract, err := bindIValidatorPool(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolTransactor{contract: contract}, nil
}

// NewIValidatorPoolFilterer creates a new log filterer instance of IValidatorPool, bound to a specific deployed contract.
func NewIValidatorPoolFilterer(address common.Address, filterer bind.ContractFilterer) (*IValidatorPoolFilterer, error) {
	contract, err := bindIValidatorPool(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolFilterer{contract: contract}, nil
}

// bindIValidatorPool binds a generic wrapper to an already deployed contract.
func bindIValidatorPool(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(IValidatorPoolABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IValidatorPool *IValidatorPoolRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IValidatorPool.Contract.IValidatorPoolCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IValidatorPool *IValidatorPoolRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.Contract.IValidatorPoolTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IValidatorPool *IValidatorPoolRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IValidatorPool.Contract.IValidatorPoolTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IValidatorPool *IValidatorPoolCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IValidatorPool.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IValidatorPool *IValidatorPoolTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IValidatorPool *IValidatorPoolTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IValidatorPool.Contract.contract.Transact(opts, method, params...)
}

// GetDisputerReward is a free data retrieval call binding the contract method 0x9ccdf830.
//
// Solidity: function getDisputerReward() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCaller) GetDisputerReward(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getDisputerReward")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetDisputerReward is a free data retrieval call binding the contract method 0x9ccdf830.
//
// Solidity: function getDisputerReward() view returns(uint256)
func (_IValidatorPool *IValidatorPoolSession) GetDisputerReward() (*big.Int, error) {
	return _IValidatorPool.Contract.GetDisputerReward(&_IValidatorPool.CallOpts)
}

// GetDisputerReward is a free data retrieval call binding the contract method 0x9ccdf830.
//
// Solidity: function getDisputerReward() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCallerSession) GetDisputerReward() (*big.Int, error) {
	return _IValidatorPool.Contract.GetDisputerReward(&_IValidatorPool.CallOpts)
}

// GetLocation is a free data retrieval call binding the contract method 0xd9e0dc59.
//
// Solidity: function getLocation(address validator) view returns(string)
func (_IValidatorPool *IValidatorPoolCaller) GetLocation(opts *bind.CallOpts, validator common.Address) (string, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getLocation", validator)

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// GetLocation is a free data retrieval call binding the contract method 0xd9e0dc59.
//
// Solidity: function getLocation(address validator) view returns(string)
func (_IValidatorPool *IValidatorPoolSession) GetLocation(validator common.Address) (string, error) {
	return _IValidatorPool.Contract.GetLocation(&_IValidatorPool.CallOpts, validator)
}

// GetLocation is a free data retrieval call binding the contract method 0xd9e0dc59.
//
// Solidity: function getLocation(address validator) view returns(string)
func (_IValidatorPool *IValidatorPoolCallerSession) GetLocation(validator common.Address) (string, error) {
	return _IValidatorPool.Contract.GetLocation(&_IValidatorPool.CallOpts, validator)
}

// GetLocations is a free data retrieval call binding the contract method 0x76207f9c.
//
// Solidity: function getLocations(address[] validators_) view returns(string[])
func (_IValidatorPool *IValidatorPoolCaller) GetLocations(opts *bind.CallOpts, validators_ []common.Address) ([]string, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getLocations", validators_)

	if err != nil {
		return *new([]string), err
	}

	out0 := *abi.ConvertType(out[0], new([]string)).(*[]string)

	return out0, err

}

// GetLocations is a free data retrieval call binding the contract method 0x76207f9c.
//
// Solidity: function getLocations(address[] validators_) view returns(string[])
func (_IValidatorPool *IValidatorPoolSession) GetLocations(validators_ []common.Address) ([]string, error) {
	return _IValidatorPool.Contract.GetLocations(&_IValidatorPool.CallOpts, validators_)
}

// GetLocations is a free data retrieval call binding the contract method 0x76207f9c.
//
// Solidity: function getLocations(address[] validators_) view returns(string[])
func (_IValidatorPool *IValidatorPoolCallerSession) GetLocations(validators_ []common.Address) ([]string, error) {
	return _IValidatorPool.Contract.GetLocations(&_IValidatorPool.CallOpts, validators_)
}

// GetMaxNumValidators is a free data retrieval call binding the contract method 0xd2992f54.
//
// Solidity: function getMaxNumValidators() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCaller) GetMaxNumValidators(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getMaxNumValidators")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetMaxNumValidators is a free data retrieval call binding the contract method 0xd2992f54.
//
// Solidity: function getMaxNumValidators() view returns(uint256)
func (_IValidatorPool *IValidatorPoolSession) GetMaxNumValidators() (*big.Int, error) {
	return _IValidatorPool.Contract.GetMaxNumValidators(&_IValidatorPool.CallOpts)
}

// GetMaxNumValidators is a free data retrieval call binding the contract method 0xd2992f54.
//
// Solidity: function getMaxNumValidators() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCallerSession) GetMaxNumValidators() (*big.Int, error) {
	return _IValidatorPool.Contract.GetMaxNumValidators(&_IValidatorPool.CallOpts)
}

// GetStakeAmount is a free data retrieval call binding the contract method 0x722580b6.
//
// Solidity: function getStakeAmount() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCaller) GetStakeAmount(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getStakeAmount")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetStakeAmount is a free data retrieval call binding the contract method 0x722580b6.
//
// Solidity: function getStakeAmount() view returns(uint256)
func (_IValidatorPool *IValidatorPoolSession) GetStakeAmount() (*big.Int, error) {
	return _IValidatorPool.Contract.GetStakeAmount(&_IValidatorPool.CallOpts)
}

// GetStakeAmount is a free data retrieval call binding the contract method 0x722580b6.
//
// Solidity: function getStakeAmount() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCallerSession) GetStakeAmount() (*big.Int, error) {
	return _IValidatorPool.Contract.GetStakeAmount(&_IValidatorPool.CallOpts)
}

// GetValidator is a free data retrieval call binding the contract method 0xb5d89627.
//
// Solidity: function getValidator(uint256 index) view returns(address)
func (_IValidatorPool *IValidatorPoolCaller) GetValidator(opts *bind.CallOpts, index *big.Int) (common.Address, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getValidator", index)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetValidator is a free data retrieval call binding the contract method 0xb5d89627.
//
// Solidity: function getValidator(uint256 index) view returns(address)
func (_IValidatorPool *IValidatorPoolSession) GetValidator(index *big.Int) (common.Address, error) {
	return _IValidatorPool.Contract.GetValidator(&_IValidatorPool.CallOpts, index)
}

// GetValidator is a free data retrieval call binding the contract method 0xb5d89627.
//
// Solidity: function getValidator(uint256 index) view returns(address)
func (_IValidatorPool *IValidatorPoolCallerSession) GetValidator(index *big.Int) (common.Address, error) {
	return _IValidatorPool.Contract.GetValidator(&_IValidatorPool.CallOpts, index)
}

// GetValidatorData is a free data retrieval call binding the contract method 0xc0951451.
//
// Solidity: function getValidatorData(uint256 index) view returns((address,uint256))
func (_IValidatorPool *IValidatorPoolCaller) GetValidatorData(opts *bind.CallOpts, index *big.Int) (ValidatorData, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getValidatorData", index)

	if err != nil {
		return *new(ValidatorData), err
	}

	out0 := *abi.ConvertType(out[0], new(ValidatorData)).(*ValidatorData)

	return out0, err

}

// GetValidatorData is a free data retrieval call binding the contract method 0xc0951451.
//
// Solidity: function getValidatorData(uint256 index) view returns((address,uint256))
func (_IValidatorPool *IValidatorPoolSession) GetValidatorData(index *big.Int) (ValidatorData, error) {
	return _IValidatorPool.Contract.GetValidatorData(&_IValidatorPool.CallOpts, index)
}

// GetValidatorData is a free data retrieval call binding the contract method 0xc0951451.
//
// Solidity: function getValidatorData(uint256 index) view returns((address,uint256))
func (_IValidatorPool *IValidatorPoolCallerSession) GetValidatorData(index *big.Int) (ValidatorData, error) {
	return _IValidatorPool.Contract.GetValidatorData(&_IValidatorPool.CallOpts, index)
}

// GetValidatorsAddresses is a free data retrieval call binding the contract method 0x9c7d8961.
//
// Solidity: function getValidatorsAddresses() view returns(address[])
func (_IValidatorPool *IValidatorPoolCaller) GetValidatorsAddresses(opts *bind.CallOpts) ([]common.Address, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getValidatorsAddresses")

	if err != nil {
		return *new([]common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new([]common.Address)).(*[]common.Address)

	return out0, err

}

// GetValidatorsAddresses is a free data retrieval call binding the contract method 0x9c7d8961.
//
// Solidity: function getValidatorsAddresses() view returns(address[])
func (_IValidatorPool *IValidatorPoolSession) GetValidatorsAddresses() ([]common.Address, error) {
	return _IValidatorPool.Contract.GetValidatorsAddresses(&_IValidatorPool.CallOpts)
}

// GetValidatorsAddresses is a free data retrieval call binding the contract method 0x9c7d8961.
//
// Solidity: function getValidatorsAddresses() view returns(address[])
func (_IValidatorPool *IValidatorPoolCallerSession) GetValidatorsAddresses() ([]common.Address, error) {
	return _IValidatorPool.Contract.GetValidatorsAddresses(&_IValidatorPool.CallOpts)
}

// GetValidatorsCount is a free data retrieval call binding the contract method 0x27498240.
//
// Solidity: function getValidatorsCount() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCaller) GetValidatorsCount(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "getValidatorsCount")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// GetValidatorsCount is a free data retrieval call binding the contract method 0x27498240.
//
// Solidity: function getValidatorsCount() view returns(uint256)
func (_IValidatorPool *IValidatorPoolSession) GetValidatorsCount() (*big.Int, error) {
	return _IValidatorPool.Contract.GetValidatorsCount(&_IValidatorPool.CallOpts)
}

// GetValidatorsCount is a free data retrieval call binding the contract method 0x27498240.
//
// Solidity: function getValidatorsCount() view returns(uint256)
func (_IValidatorPool *IValidatorPoolCallerSession) GetValidatorsCount() (*big.Int, error) {
	return _IValidatorPool.Contract.GetValidatorsCount(&_IValidatorPool.CallOpts)
}

// IsAccusable is a free data retrieval call binding the contract method 0x20c2856d.
//
// Solidity: function isAccusable(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolCaller) IsAccusable(opts *bind.CallOpts, participant common.Address) (bool, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "isAccusable", participant)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsAccusable is a free data retrieval call binding the contract method 0x20c2856d.
//
// Solidity: function isAccusable(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolSession) IsAccusable(participant common.Address) (bool, error) {
	return _IValidatorPool.Contract.IsAccusable(&_IValidatorPool.CallOpts, participant)
}

// IsAccusable is a free data retrieval call binding the contract method 0x20c2856d.
//
// Solidity: function isAccusable(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolCallerSession) IsAccusable(participant common.Address) (bool, error) {
	return _IValidatorPool.Contract.IsAccusable(&_IValidatorPool.CallOpts, participant)
}

// IsConsensusRunning is a free data retrieval call binding the contract method 0xc8d1a5e4.
//
// Solidity: function isConsensusRunning() view returns(bool)
func (_IValidatorPool *IValidatorPoolCaller) IsConsensusRunning(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "isConsensusRunning")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsConsensusRunning is a free data retrieval call binding the contract method 0xc8d1a5e4.
//
// Solidity: function isConsensusRunning() view returns(bool)
func (_IValidatorPool *IValidatorPoolSession) IsConsensusRunning() (bool, error) {
	return _IValidatorPool.Contract.IsConsensusRunning(&_IValidatorPool.CallOpts)
}

// IsConsensusRunning is a free data retrieval call binding the contract method 0xc8d1a5e4.
//
// Solidity: function isConsensusRunning() view returns(bool)
func (_IValidatorPool *IValidatorPoolCallerSession) IsConsensusRunning() (bool, error) {
	return _IValidatorPool.Contract.IsConsensusRunning(&_IValidatorPool.CallOpts)
}

// IsInExitingQueue is a free data retrieval call binding the contract method 0xe4ad75f1.
//
// Solidity: function isInExitingQueue(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolCaller) IsInExitingQueue(opts *bind.CallOpts, participant common.Address) (bool, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "isInExitingQueue", participant)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsInExitingQueue is a free data retrieval call binding the contract method 0xe4ad75f1.
//
// Solidity: function isInExitingQueue(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolSession) IsInExitingQueue(participant common.Address) (bool, error) {
	return _IValidatorPool.Contract.IsInExitingQueue(&_IValidatorPool.CallOpts, participant)
}

// IsInExitingQueue is a free data retrieval call binding the contract method 0xe4ad75f1.
//
// Solidity: function isInExitingQueue(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolCallerSession) IsInExitingQueue(participant common.Address) (bool, error) {
	return _IValidatorPool.Contract.IsInExitingQueue(&_IValidatorPool.CallOpts, participant)
}

// IsMaintenanceScheduled is a free data retrieval call binding the contract method 0x1885570f.
//
// Solidity: function isMaintenanceScheduled() view returns(bool)
func (_IValidatorPool *IValidatorPoolCaller) IsMaintenanceScheduled(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "isMaintenanceScheduled")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsMaintenanceScheduled is a free data retrieval call binding the contract method 0x1885570f.
//
// Solidity: function isMaintenanceScheduled() view returns(bool)
func (_IValidatorPool *IValidatorPoolSession) IsMaintenanceScheduled() (bool, error) {
	return _IValidatorPool.Contract.IsMaintenanceScheduled(&_IValidatorPool.CallOpts)
}

// IsMaintenanceScheduled is a free data retrieval call binding the contract method 0x1885570f.
//
// Solidity: function isMaintenanceScheduled() view returns(bool)
func (_IValidatorPool *IValidatorPoolCallerSession) IsMaintenanceScheduled() (bool, error) {
	return _IValidatorPool.Contract.IsMaintenanceScheduled(&_IValidatorPool.CallOpts)
}

// IsValidator is a free data retrieval call binding the contract method 0xfacd743b.
//
// Solidity: function isValidator(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolCaller) IsValidator(opts *bind.CallOpts, participant common.Address) (bool, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "isValidator", participant)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsValidator is a free data retrieval call binding the contract method 0xfacd743b.
//
// Solidity: function isValidator(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolSession) IsValidator(participant common.Address) (bool, error) {
	return _IValidatorPool.Contract.IsValidator(&_IValidatorPool.CallOpts, participant)
}

// IsValidator is a free data retrieval call binding the contract method 0xfacd743b.
//
// Solidity: function isValidator(address participant) view returns(bool)
func (_IValidatorPool *IValidatorPoolCallerSession) IsValidator(participant common.Address) (bool, error) {
	return _IValidatorPool.Contract.IsValidator(&_IValidatorPool.CallOpts, participant)
}

// TryGetTokenID is a free data retrieval call binding the contract method 0xee9e49bd.
//
// Solidity: function tryGetTokenID(address account_) view returns(bool, address, uint256)
func (_IValidatorPool *IValidatorPoolCaller) TryGetTokenID(opts *bind.CallOpts, account_ common.Address) (bool, common.Address, *big.Int, error) {
	var out []interface{}
	err := _IValidatorPool.contract.Call(opts, &out, "tryGetTokenID", account_)

	if err != nil {
		return *new(bool), *new(common.Address), *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	out1 := *abi.ConvertType(out[1], new(common.Address)).(*common.Address)
	out2 := *abi.ConvertType(out[2], new(*big.Int)).(**big.Int)

	return out0, out1, out2, err

}

// TryGetTokenID is a free data retrieval call binding the contract method 0xee9e49bd.
//
// Solidity: function tryGetTokenID(address account_) view returns(bool, address, uint256)
func (_IValidatorPool *IValidatorPoolSession) TryGetTokenID(account_ common.Address) (bool, common.Address, *big.Int, error) {
	return _IValidatorPool.Contract.TryGetTokenID(&_IValidatorPool.CallOpts, account_)
}

// TryGetTokenID is a free data retrieval call binding the contract method 0xee9e49bd.
//
// Solidity: function tryGetTokenID(address account_) view returns(bool, address, uint256)
func (_IValidatorPool *IValidatorPoolCallerSession) TryGetTokenID(account_ common.Address) (bool, common.Address, *big.Int, error) {
	return _IValidatorPool.Contract.TryGetTokenID(&_IValidatorPool.CallOpts, account_)
}

// ClaimExitingNFTPosition is a paid mutator transaction binding the contract method 0x769cc695.
//
// Solidity: function claimExitingNFTPosition() returns(uint256)
func (_IValidatorPool *IValidatorPoolTransactor) ClaimExitingNFTPosition(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "claimExitingNFTPosition")
}

// ClaimExitingNFTPosition is a paid mutator transaction binding the contract method 0x769cc695.
//
// Solidity: function claimExitingNFTPosition() returns(uint256)
func (_IValidatorPool *IValidatorPoolSession) ClaimExitingNFTPosition() (*types.Transaction, error) {
	return _IValidatorPool.Contract.ClaimExitingNFTPosition(&_IValidatorPool.TransactOpts)
}

// ClaimExitingNFTPosition is a paid mutator transaction binding the contract method 0x769cc695.
//
// Solidity: function claimExitingNFTPosition() returns(uint256)
func (_IValidatorPool *IValidatorPoolTransactorSession) ClaimExitingNFTPosition() (*types.Transaction, error) {
	return _IValidatorPool.Contract.ClaimExitingNFTPosition(&_IValidatorPool.TransactOpts)
}

// CollectProfits is a paid mutator transaction binding the contract method 0xc958e0d6.
//
// Solidity: function collectProfits() returns(uint256 payoutEth, uint256 payoutToken)
func (_IValidatorPool *IValidatorPoolTransactor) CollectProfits(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "collectProfits")
}

// CollectProfits is a paid mutator transaction binding the contract method 0xc958e0d6.
//
// Solidity: function collectProfits() returns(uint256 payoutEth, uint256 payoutToken)
func (_IValidatorPool *IValidatorPoolSession) CollectProfits() (*types.Transaction, error) {
	return _IValidatorPool.Contract.CollectProfits(&_IValidatorPool.TransactOpts)
}

// CollectProfits is a paid mutator transaction binding the contract method 0xc958e0d6.
//
// Solidity: function collectProfits() returns(uint256 payoutEth, uint256 payoutToken)
func (_IValidatorPool *IValidatorPoolTransactorSession) CollectProfits() (*types.Transaction, error) {
	return _IValidatorPool.Contract.CollectProfits(&_IValidatorPool.TransactOpts)
}

// CompleteETHDKG is a paid mutator transaction binding the contract method 0x8f579924.
//
// Solidity: function completeETHDKG() returns()
func (_IValidatorPool *IValidatorPoolTransactor) CompleteETHDKG(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "completeETHDKG")
}

// CompleteETHDKG is a paid mutator transaction binding the contract method 0x8f579924.
//
// Solidity: function completeETHDKG() returns()
func (_IValidatorPool *IValidatorPoolSession) CompleteETHDKG() (*types.Transaction, error) {
	return _IValidatorPool.Contract.CompleteETHDKG(&_IValidatorPool.TransactOpts)
}

// CompleteETHDKG is a paid mutator transaction binding the contract method 0x8f579924.
//
// Solidity: function completeETHDKG() returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) CompleteETHDKG() (*types.Transaction, error) {
	return _IValidatorPool.Contract.CompleteETHDKG(&_IValidatorPool.TransactOpts)
}

// InitializeETHDKG is a paid mutator transaction binding the contract method 0x57b51c9c.
//
// Solidity: function initializeETHDKG() returns()
func (_IValidatorPool *IValidatorPoolTransactor) InitializeETHDKG(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "initializeETHDKG")
}

// InitializeETHDKG is a paid mutator transaction binding the contract method 0x57b51c9c.
//
// Solidity: function initializeETHDKG() returns()
func (_IValidatorPool *IValidatorPoolSession) InitializeETHDKG() (*types.Transaction, error) {
	return _IValidatorPool.Contract.InitializeETHDKG(&_IValidatorPool.TransactOpts)
}

// InitializeETHDKG is a paid mutator transaction binding the contract method 0x57b51c9c.
//
// Solidity: function initializeETHDKG() returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) InitializeETHDKG() (*types.Transaction, error) {
	return _IValidatorPool.Contract.InitializeETHDKG(&_IValidatorPool.TransactOpts)
}

// MajorSlash is a paid mutator transaction binding the contract method 0x048d56c7.
//
// Solidity: function majorSlash(address dishonestValidator_, address disputer_) returns()
func (_IValidatorPool *IValidatorPoolTransactor) MajorSlash(opts *bind.TransactOpts, dishonestValidator_ common.Address, disputer_ common.Address) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "majorSlash", dishonestValidator_, disputer_)
}

// MajorSlash is a paid mutator transaction binding the contract method 0x048d56c7.
//
// Solidity: function majorSlash(address dishonestValidator_, address disputer_) returns()
func (_IValidatorPool *IValidatorPoolSession) MajorSlash(dishonestValidator_ common.Address, disputer_ common.Address) (*types.Transaction, error) {
	return _IValidatorPool.Contract.MajorSlash(&_IValidatorPool.TransactOpts, dishonestValidator_, disputer_)
}

// MajorSlash is a paid mutator transaction binding the contract method 0x048d56c7.
//
// Solidity: function majorSlash(address dishonestValidator_, address disputer_) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) MajorSlash(dishonestValidator_ common.Address, disputer_ common.Address) (*types.Transaction, error) {
	return _IValidatorPool.Contract.MajorSlash(&_IValidatorPool.TransactOpts, dishonestValidator_, disputer_)
}

// MinorSlash is a paid mutator transaction binding the contract method 0x64c0461c.
//
// Solidity: function minorSlash(address dishonestValidator_, address disputer_) returns()
func (_IValidatorPool *IValidatorPoolTransactor) MinorSlash(opts *bind.TransactOpts, dishonestValidator_ common.Address, disputer_ common.Address) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "minorSlash", dishonestValidator_, disputer_)
}

// MinorSlash is a paid mutator transaction binding the contract method 0x64c0461c.
//
// Solidity: function minorSlash(address dishonestValidator_, address disputer_) returns()
func (_IValidatorPool *IValidatorPoolSession) MinorSlash(dishonestValidator_ common.Address, disputer_ common.Address) (*types.Transaction, error) {
	return _IValidatorPool.Contract.MinorSlash(&_IValidatorPool.TransactOpts, dishonestValidator_, disputer_)
}

// MinorSlash is a paid mutator transaction binding the contract method 0x64c0461c.
//
// Solidity: function minorSlash(address dishonestValidator_, address disputer_) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) MinorSlash(dishonestValidator_ common.Address, disputer_ common.Address) (*types.Transaction, error) {
	return _IValidatorPool.Contract.MinorSlash(&_IValidatorPool.TransactOpts, dishonestValidator_, disputer_)
}

// PauseConsensus is a paid mutator transaction binding the contract method 0x1e5975f4.
//
// Solidity: function pauseConsensus() returns()
func (_IValidatorPool *IValidatorPoolTransactor) PauseConsensus(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "pauseConsensus")
}

// PauseConsensus is a paid mutator transaction binding the contract method 0x1e5975f4.
//
// Solidity: function pauseConsensus() returns()
func (_IValidatorPool *IValidatorPoolSession) PauseConsensus() (*types.Transaction, error) {
	return _IValidatorPool.Contract.PauseConsensus(&_IValidatorPool.TransactOpts)
}

// PauseConsensus is a paid mutator transaction binding the contract method 0x1e5975f4.
//
// Solidity: function pauseConsensus() returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) PauseConsensus() (*types.Transaction, error) {
	return _IValidatorPool.Contract.PauseConsensus(&_IValidatorPool.TransactOpts)
}

// PauseConsensusOnArbitraryHeight is a paid mutator transaction binding the contract method 0xbc33bb01.
//
// Solidity: function pauseConsensusOnArbitraryHeight(uint256 madnetHeight) returns()
func (_IValidatorPool *IValidatorPoolTransactor) PauseConsensusOnArbitraryHeight(opts *bind.TransactOpts, madnetHeight *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "pauseConsensusOnArbitraryHeight", madnetHeight)
}

// PauseConsensusOnArbitraryHeight is a paid mutator transaction binding the contract method 0xbc33bb01.
//
// Solidity: function pauseConsensusOnArbitraryHeight(uint256 madnetHeight) returns()
func (_IValidatorPool *IValidatorPoolSession) PauseConsensusOnArbitraryHeight(madnetHeight *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.PauseConsensusOnArbitraryHeight(&_IValidatorPool.TransactOpts, madnetHeight)
}

// PauseConsensusOnArbitraryHeight is a paid mutator transaction binding the contract method 0xbc33bb01.
//
// Solidity: function pauseConsensusOnArbitraryHeight(uint256 madnetHeight) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) PauseConsensusOnArbitraryHeight(madnetHeight *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.PauseConsensusOnArbitraryHeight(&_IValidatorPool.TransactOpts, madnetHeight)
}

// RegisterValidators is a paid mutator transaction binding the contract method 0x65bd91af.
//
// Solidity: function registerValidators(address[] validators, uint256[] stakerTokenIDs) returns()
func (_IValidatorPool *IValidatorPoolTransactor) RegisterValidators(opts *bind.TransactOpts, validators []common.Address, stakerTokenIDs []*big.Int) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "registerValidators", validators, stakerTokenIDs)
}

// RegisterValidators is a paid mutator transaction binding the contract method 0x65bd91af.
//
// Solidity: function registerValidators(address[] validators, uint256[] stakerTokenIDs) returns()
func (_IValidatorPool *IValidatorPoolSession) RegisterValidators(validators []common.Address, stakerTokenIDs []*big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.RegisterValidators(&_IValidatorPool.TransactOpts, validators, stakerTokenIDs)
}

// RegisterValidators is a paid mutator transaction binding the contract method 0x65bd91af.
//
// Solidity: function registerValidators(address[] validators, uint256[] stakerTokenIDs) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) RegisterValidators(validators []common.Address, stakerTokenIDs []*big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.RegisterValidators(&_IValidatorPool.TransactOpts, validators, stakerTokenIDs)
}

// ScheduleMaintenance is a paid mutator transaction binding the contract method 0x2380db1a.
//
// Solidity: function scheduleMaintenance() returns()
func (_IValidatorPool *IValidatorPoolTransactor) ScheduleMaintenance(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "scheduleMaintenance")
}

// ScheduleMaintenance is a paid mutator transaction binding the contract method 0x2380db1a.
//
// Solidity: function scheduleMaintenance() returns()
func (_IValidatorPool *IValidatorPoolSession) ScheduleMaintenance() (*types.Transaction, error) {
	return _IValidatorPool.Contract.ScheduleMaintenance(&_IValidatorPool.TransactOpts)
}

// ScheduleMaintenance is a paid mutator transaction binding the contract method 0x2380db1a.
//
// Solidity: function scheduleMaintenance() returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) ScheduleMaintenance() (*types.Transaction, error) {
	return _IValidatorPool.Contract.ScheduleMaintenance(&_IValidatorPool.TransactOpts)
}

// SetDisputerReward is a paid mutator transaction binding the contract method 0x7d907284.
//
// Solidity: function setDisputerReward(uint256 disputerReward_) returns()
func (_IValidatorPool *IValidatorPoolTransactor) SetDisputerReward(opts *bind.TransactOpts, disputerReward_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "setDisputerReward", disputerReward_)
}

// SetDisputerReward is a paid mutator transaction binding the contract method 0x7d907284.
//
// Solidity: function setDisputerReward(uint256 disputerReward_) returns()
func (_IValidatorPool *IValidatorPoolSession) SetDisputerReward(disputerReward_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetDisputerReward(&_IValidatorPool.TransactOpts, disputerReward_)
}

// SetDisputerReward is a paid mutator transaction binding the contract method 0x7d907284.
//
// Solidity: function setDisputerReward(uint256 disputerReward_) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) SetDisputerReward(disputerReward_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetDisputerReward(&_IValidatorPool.TransactOpts, disputerReward_)
}

// SetLocation is a paid mutator transaction binding the contract method 0x827bfbdf.
//
// Solidity: function setLocation(string ip) returns()
func (_IValidatorPool *IValidatorPoolTransactor) SetLocation(opts *bind.TransactOpts, ip string) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "setLocation", ip)
}

// SetLocation is a paid mutator transaction binding the contract method 0x827bfbdf.
//
// Solidity: function setLocation(string ip) returns()
func (_IValidatorPool *IValidatorPoolSession) SetLocation(ip string) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetLocation(&_IValidatorPool.TransactOpts, ip)
}

// SetLocation is a paid mutator transaction binding the contract method 0x827bfbdf.
//
// Solidity: function setLocation(string ip) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) SetLocation(ip string) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetLocation(&_IValidatorPool.TransactOpts, ip)
}

// SetMaxNumValidators is a paid mutator transaction binding the contract method 0x6c0da0b4.
//
// Solidity: function setMaxNumValidators(uint256 maxNumValidators_) returns()
func (_IValidatorPool *IValidatorPoolTransactor) SetMaxNumValidators(opts *bind.TransactOpts, maxNumValidators_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "setMaxNumValidators", maxNumValidators_)
}

// SetMaxNumValidators is a paid mutator transaction binding the contract method 0x6c0da0b4.
//
// Solidity: function setMaxNumValidators(uint256 maxNumValidators_) returns()
func (_IValidatorPool *IValidatorPoolSession) SetMaxNumValidators(maxNumValidators_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetMaxNumValidators(&_IValidatorPool.TransactOpts, maxNumValidators_)
}

// SetMaxNumValidators is a paid mutator transaction binding the contract method 0x6c0da0b4.
//
// Solidity: function setMaxNumValidators(uint256 maxNumValidators_) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) SetMaxNumValidators(maxNumValidators_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetMaxNumValidators(&_IValidatorPool.TransactOpts, maxNumValidators_)
}

// SetStakeAmount is a paid mutator transaction binding the contract method 0x43808c50.
//
// Solidity: function setStakeAmount(uint256 stakeAmount_) returns()
func (_IValidatorPool *IValidatorPoolTransactor) SetStakeAmount(opts *bind.TransactOpts, stakeAmount_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "setStakeAmount", stakeAmount_)
}

// SetStakeAmount is a paid mutator transaction binding the contract method 0x43808c50.
//
// Solidity: function setStakeAmount(uint256 stakeAmount_) returns()
func (_IValidatorPool *IValidatorPoolSession) SetStakeAmount(stakeAmount_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetStakeAmount(&_IValidatorPool.TransactOpts, stakeAmount_)
}

// SetStakeAmount is a paid mutator transaction binding the contract method 0x43808c50.
//
// Solidity: function setStakeAmount(uint256 stakeAmount_) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) SetStakeAmount(stakeAmount_ *big.Int) (*types.Transaction, error) {
	return _IValidatorPool.Contract.SetStakeAmount(&_IValidatorPool.TransactOpts, stakeAmount_)
}

// UnregisterAllValidators is a paid mutator transaction binding the contract method 0xf6442e24.
//
// Solidity: function unregisterAllValidators() returns()
func (_IValidatorPool *IValidatorPoolTransactor) UnregisterAllValidators(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "unregisterAllValidators")
}

// UnregisterAllValidators is a paid mutator transaction binding the contract method 0xf6442e24.
//
// Solidity: function unregisterAllValidators() returns()
func (_IValidatorPool *IValidatorPoolSession) UnregisterAllValidators() (*types.Transaction, error) {
	return _IValidatorPool.Contract.UnregisterAllValidators(&_IValidatorPool.TransactOpts)
}

// UnregisterAllValidators is a paid mutator transaction binding the contract method 0xf6442e24.
//
// Solidity: function unregisterAllValidators() returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) UnregisterAllValidators() (*types.Transaction, error) {
	return _IValidatorPool.Contract.UnregisterAllValidators(&_IValidatorPool.TransactOpts)
}

// UnregisterValidators is a paid mutator transaction binding the contract method 0xc6e86ad6.
//
// Solidity: function unregisterValidators(address[] validators) returns()
func (_IValidatorPool *IValidatorPoolTransactor) UnregisterValidators(opts *bind.TransactOpts, validators []common.Address) (*types.Transaction, error) {
	return _IValidatorPool.contract.Transact(opts, "unregisterValidators", validators)
}

// UnregisterValidators is a paid mutator transaction binding the contract method 0xc6e86ad6.
//
// Solidity: function unregisterValidators(address[] validators) returns()
func (_IValidatorPool *IValidatorPoolSession) UnregisterValidators(validators []common.Address) (*types.Transaction, error) {
	return _IValidatorPool.Contract.UnregisterValidators(&_IValidatorPool.TransactOpts, validators)
}

// UnregisterValidators is a paid mutator transaction binding the contract method 0xc6e86ad6.
//
// Solidity: function unregisterValidators(address[] validators) returns()
func (_IValidatorPool *IValidatorPoolTransactorSession) UnregisterValidators(validators []common.Address) (*types.Transaction, error) {
	return _IValidatorPool.Contract.UnregisterValidators(&_IValidatorPool.TransactOpts, validators)
}
