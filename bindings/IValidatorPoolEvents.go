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

// IValidatorPoolEventsMetaData contains all meta data concerning the IValidatorPoolEvents contract.
var IValidatorPoolEventsMetaData = &bind.MetaData{
	ABI: "[{\"anonymous\":false,\"inputs\":[],\"name\":\"MaintenanceScheduled\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"validatorNFT\",\"type\":\"uint256\"}],\"name\":\"ValidatorJoined\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"stakeNFT\",\"type\":\"uint256\"}],\"name\":\"ValidatorLeft\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"ValidatorMajorSlashed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"stakeNFT\",\"type\":\"uint256\"}],\"name\":\"ValidatorMinorSlashed\",\"type\":\"event\"}]",
}

// IValidatorPoolEventsABI is the input ABI used to generate the binding from.
// Deprecated: Use IValidatorPoolEventsMetaData.ABI instead.
var IValidatorPoolEventsABI = IValidatorPoolEventsMetaData.ABI

// IValidatorPoolEvents is an auto generated Go binding around an Ethereum contract.
type IValidatorPoolEvents struct {
	IValidatorPoolEventsCaller     // Read-only binding to the contract
	IValidatorPoolEventsTransactor // Write-only binding to the contract
	IValidatorPoolEventsFilterer   // Log filterer for contract events
}

// IValidatorPoolEventsCaller is an auto generated read-only Go binding around an Ethereum contract.
type IValidatorPoolEventsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IValidatorPoolEventsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IValidatorPoolEventsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IValidatorPoolEventsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IValidatorPoolEventsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IValidatorPoolEventsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IValidatorPoolEventsSession struct {
	Contract     *IValidatorPoolEvents // Generic contract binding to set the session for
	CallOpts     bind.CallOpts         // Call options to use throughout this session
	TransactOpts bind.TransactOpts     // Transaction auth options to use throughout this session
}

// IValidatorPoolEventsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IValidatorPoolEventsCallerSession struct {
	Contract *IValidatorPoolEventsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts               // Call options to use throughout this session
}

// IValidatorPoolEventsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IValidatorPoolEventsTransactorSession struct {
	Contract     *IValidatorPoolEventsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts               // Transaction auth options to use throughout this session
}

// IValidatorPoolEventsRaw is an auto generated low-level Go binding around an Ethereum contract.
type IValidatorPoolEventsRaw struct {
	Contract *IValidatorPoolEvents // Generic contract binding to access the raw methods on
}

// IValidatorPoolEventsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IValidatorPoolEventsCallerRaw struct {
	Contract *IValidatorPoolEventsCaller // Generic read-only contract binding to access the raw methods on
}

// IValidatorPoolEventsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IValidatorPoolEventsTransactorRaw struct {
	Contract *IValidatorPoolEventsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIValidatorPoolEvents creates a new instance of IValidatorPoolEvents, bound to a specific deployed contract.
func NewIValidatorPoolEvents(address common.Address, backend bind.ContractBackend) (*IValidatorPoolEvents, error) {
	contract, err := bindIValidatorPoolEvents(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEvents{IValidatorPoolEventsCaller: IValidatorPoolEventsCaller{contract: contract}, IValidatorPoolEventsTransactor: IValidatorPoolEventsTransactor{contract: contract}, IValidatorPoolEventsFilterer: IValidatorPoolEventsFilterer{contract: contract}}, nil
}

// NewIValidatorPoolEventsCaller creates a new read-only instance of IValidatorPoolEvents, bound to a specific deployed contract.
func NewIValidatorPoolEventsCaller(address common.Address, caller bind.ContractCaller) (*IValidatorPoolEventsCaller, error) {
	contract, err := bindIValidatorPoolEvents(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsCaller{contract: contract}, nil
}

// NewIValidatorPoolEventsTransactor creates a new write-only instance of IValidatorPoolEvents, bound to a specific deployed contract.
func NewIValidatorPoolEventsTransactor(address common.Address, transactor bind.ContractTransactor) (*IValidatorPoolEventsTransactor, error) {
	contract, err := bindIValidatorPoolEvents(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsTransactor{contract: contract}, nil
}

// NewIValidatorPoolEventsFilterer creates a new log filterer instance of IValidatorPoolEvents, bound to a specific deployed contract.
func NewIValidatorPoolEventsFilterer(address common.Address, filterer bind.ContractFilterer) (*IValidatorPoolEventsFilterer, error) {
	contract, err := bindIValidatorPoolEvents(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsFilterer{contract: contract}, nil
}

// bindIValidatorPoolEvents binds a generic wrapper to an already deployed contract.
func bindIValidatorPoolEvents(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(IValidatorPoolEventsABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IValidatorPoolEvents *IValidatorPoolEventsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IValidatorPoolEvents.Contract.IValidatorPoolEventsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IValidatorPoolEvents *IValidatorPoolEventsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPoolEvents.Contract.IValidatorPoolEventsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IValidatorPoolEvents *IValidatorPoolEventsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IValidatorPoolEvents.Contract.IValidatorPoolEventsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IValidatorPoolEvents *IValidatorPoolEventsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IValidatorPoolEvents.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IValidatorPoolEvents *IValidatorPoolEventsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IValidatorPoolEvents.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IValidatorPoolEvents *IValidatorPoolEventsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IValidatorPoolEvents.Contract.contract.Transact(opts, method, params...)
}

// IValidatorPoolEventsMaintenanceScheduledIterator is returned from FilterMaintenanceScheduled and is used to iterate over the raw logs and unpacked data for MaintenanceScheduled events raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsMaintenanceScheduledIterator struct {
	Event *IValidatorPoolEventsMaintenanceScheduled // Event containing the contract specifics and raw log

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
func (it *IValidatorPoolEventsMaintenanceScheduledIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IValidatorPoolEventsMaintenanceScheduled)
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
		it.Event = new(IValidatorPoolEventsMaintenanceScheduled)
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
func (it *IValidatorPoolEventsMaintenanceScheduledIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IValidatorPoolEventsMaintenanceScheduledIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IValidatorPoolEventsMaintenanceScheduled represents a MaintenanceScheduled event raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsMaintenanceScheduled struct {
	Raw types.Log // Blockchain specific contextual infos
}

// FilterMaintenanceScheduled is a free log retrieval operation binding the contract event 0xc77f315ab4072b428052ff8f369916ce39f7fa7e925613f3e9b28fe383c565c8.
//
// Solidity: event MaintenanceScheduled()
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) FilterMaintenanceScheduled(opts *bind.FilterOpts) (*IValidatorPoolEventsMaintenanceScheduledIterator, error) {

	logs, sub, err := _IValidatorPoolEvents.contract.FilterLogs(opts, "MaintenanceScheduled")
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsMaintenanceScheduledIterator{contract: _IValidatorPoolEvents.contract, event: "MaintenanceScheduled", logs: logs, sub: sub}, nil
}

// WatchMaintenanceScheduled is a free log subscription operation binding the contract event 0xc77f315ab4072b428052ff8f369916ce39f7fa7e925613f3e9b28fe383c565c8.
//
// Solidity: event MaintenanceScheduled()
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) WatchMaintenanceScheduled(opts *bind.WatchOpts, sink chan<- *IValidatorPoolEventsMaintenanceScheduled) (event.Subscription, error) {

	logs, sub, err := _IValidatorPoolEvents.contract.WatchLogs(opts, "MaintenanceScheduled")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IValidatorPoolEventsMaintenanceScheduled)
				if err := _IValidatorPoolEvents.contract.UnpackLog(event, "MaintenanceScheduled", log); err != nil {
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

// ParseMaintenanceScheduled is a log parse operation binding the contract event 0xc77f315ab4072b428052ff8f369916ce39f7fa7e925613f3e9b28fe383c565c8.
//
// Solidity: event MaintenanceScheduled()
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) ParseMaintenanceScheduled(log types.Log) (*IValidatorPoolEventsMaintenanceScheduled, error) {
	event := new(IValidatorPoolEventsMaintenanceScheduled)
	if err := _IValidatorPoolEvents.contract.UnpackLog(event, "MaintenanceScheduled", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IValidatorPoolEventsValidatorJoinedIterator is returned from FilterValidatorJoined and is used to iterate over the raw logs and unpacked data for ValidatorJoined events raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorJoinedIterator struct {
	Event *IValidatorPoolEventsValidatorJoined // Event containing the contract specifics and raw log

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
func (it *IValidatorPoolEventsValidatorJoinedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IValidatorPoolEventsValidatorJoined)
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
		it.Event = new(IValidatorPoolEventsValidatorJoined)
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
func (it *IValidatorPoolEventsValidatorJoinedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IValidatorPoolEventsValidatorJoinedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IValidatorPoolEventsValidatorJoined represents a ValidatorJoined event raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorJoined struct {
	Account      common.Address
	ValidatorNFT *big.Int
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterValidatorJoined is a free log retrieval operation binding the contract event 0xe30848520248cd6b60cf19fe62a302a47e2d2c1c147deea1188e471751557a52.
//
// Solidity: event ValidatorJoined(address indexed account, uint256 validatorNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) FilterValidatorJoined(opts *bind.FilterOpts, account []common.Address) (*IValidatorPoolEventsValidatorJoinedIterator, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.FilterLogs(opts, "ValidatorJoined", accountRule)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsValidatorJoinedIterator{contract: _IValidatorPoolEvents.contract, event: "ValidatorJoined", logs: logs, sub: sub}, nil
}

// WatchValidatorJoined is a free log subscription operation binding the contract event 0xe30848520248cd6b60cf19fe62a302a47e2d2c1c147deea1188e471751557a52.
//
// Solidity: event ValidatorJoined(address indexed account, uint256 validatorNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) WatchValidatorJoined(opts *bind.WatchOpts, sink chan<- *IValidatorPoolEventsValidatorJoined, account []common.Address) (event.Subscription, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.WatchLogs(opts, "ValidatorJoined", accountRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IValidatorPoolEventsValidatorJoined)
				if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorJoined", log); err != nil {
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

// ParseValidatorJoined is a log parse operation binding the contract event 0xe30848520248cd6b60cf19fe62a302a47e2d2c1c147deea1188e471751557a52.
//
// Solidity: event ValidatorJoined(address indexed account, uint256 validatorNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) ParseValidatorJoined(log types.Log) (*IValidatorPoolEventsValidatorJoined, error) {
	event := new(IValidatorPoolEventsValidatorJoined)
	if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorJoined", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IValidatorPoolEventsValidatorLeftIterator is returned from FilterValidatorLeft and is used to iterate over the raw logs and unpacked data for ValidatorLeft events raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorLeftIterator struct {
	Event *IValidatorPoolEventsValidatorLeft // Event containing the contract specifics and raw log

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
func (it *IValidatorPoolEventsValidatorLeftIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IValidatorPoolEventsValidatorLeft)
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
		it.Event = new(IValidatorPoolEventsValidatorLeft)
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
func (it *IValidatorPoolEventsValidatorLeftIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IValidatorPoolEventsValidatorLeftIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IValidatorPoolEventsValidatorLeft represents a ValidatorLeft event raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorLeft struct {
	Account  common.Address
	StakeNFT *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterValidatorLeft is a free log retrieval operation binding the contract event 0x33ff7b2beda3cb99406d3401fd9e8d9001b93e74b845cf7346f6e7f70c703e73.
//
// Solidity: event ValidatorLeft(address indexed account, uint256 stakeNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) FilterValidatorLeft(opts *bind.FilterOpts, account []common.Address) (*IValidatorPoolEventsValidatorLeftIterator, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.FilterLogs(opts, "ValidatorLeft", accountRule)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsValidatorLeftIterator{contract: _IValidatorPoolEvents.contract, event: "ValidatorLeft", logs: logs, sub: sub}, nil
}

// WatchValidatorLeft is a free log subscription operation binding the contract event 0x33ff7b2beda3cb99406d3401fd9e8d9001b93e74b845cf7346f6e7f70c703e73.
//
// Solidity: event ValidatorLeft(address indexed account, uint256 stakeNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) WatchValidatorLeft(opts *bind.WatchOpts, sink chan<- *IValidatorPoolEventsValidatorLeft, account []common.Address) (event.Subscription, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.WatchLogs(opts, "ValidatorLeft", accountRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IValidatorPoolEventsValidatorLeft)
				if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorLeft", log); err != nil {
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

// ParseValidatorLeft is a log parse operation binding the contract event 0x33ff7b2beda3cb99406d3401fd9e8d9001b93e74b845cf7346f6e7f70c703e73.
//
// Solidity: event ValidatorLeft(address indexed account, uint256 stakeNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) ParseValidatorLeft(log types.Log) (*IValidatorPoolEventsValidatorLeft, error) {
	event := new(IValidatorPoolEventsValidatorLeft)
	if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorLeft", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IValidatorPoolEventsValidatorMajorSlashedIterator is returned from FilterValidatorMajorSlashed and is used to iterate over the raw logs and unpacked data for ValidatorMajorSlashed events raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorMajorSlashedIterator struct {
	Event *IValidatorPoolEventsValidatorMajorSlashed // Event containing the contract specifics and raw log

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
func (it *IValidatorPoolEventsValidatorMajorSlashedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IValidatorPoolEventsValidatorMajorSlashed)
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
		it.Event = new(IValidatorPoolEventsValidatorMajorSlashed)
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
func (it *IValidatorPoolEventsValidatorMajorSlashedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IValidatorPoolEventsValidatorMajorSlashedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IValidatorPoolEventsValidatorMajorSlashed represents a ValidatorMajorSlashed event raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorMajorSlashed struct {
	Account common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterValidatorMajorSlashed is a free log retrieval operation binding the contract event 0xee806478c61c75fc3ec50328b2af43290d1860ef40d5dfbba62ece0e1e3abe9e.
//
// Solidity: event ValidatorMajorSlashed(address indexed account)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) FilterValidatorMajorSlashed(opts *bind.FilterOpts, account []common.Address) (*IValidatorPoolEventsValidatorMajorSlashedIterator, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.FilterLogs(opts, "ValidatorMajorSlashed", accountRule)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsValidatorMajorSlashedIterator{contract: _IValidatorPoolEvents.contract, event: "ValidatorMajorSlashed", logs: logs, sub: sub}, nil
}

// WatchValidatorMajorSlashed is a free log subscription operation binding the contract event 0xee806478c61c75fc3ec50328b2af43290d1860ef40d5dfbba62ece0e1e3abe9e.
//
// Solidity: event ValidatorMajorSlashed(address indexed account)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) WatchValidatorMajorSlashed(opts *bind.WatchOpts, sink chan<- *IValidatorPoolEventsValidatorMajorSlashed, account []common.Address) (event.Subscription, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.WatchLogs(opts, "ValidatorMajorSlashed", accountRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IValidatorPoolEventsValidatorMajorSlashed)
				if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorMajorSlashed", log); err != nil {
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

// ParseValidatorMajorSlashed is a log parse operation binding the contract event 0xee806478c61c75fc3ec50328b2af43290d1860ef40d5dfbba62ece0e1e3abe9e.
//
// Solidity: event ValidatorMajorSlashed(address indexed account)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) ParseValidatorMajorSlashed(log types.Log) (*IValidatorPoolEventsValidatorMajorSlashed, error) {
	event := new(IValidatorPoolEventsValidatorMajorSlashed)
	if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorMajorSlashed", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IValidatorPoolEventsValidatorMinorSlashedIterator is returned from FilterValidatorMinorSlashed and is used to iterate over the raw logs and unpacked data for ValidatorMinorSlashed events raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorMinorSlashedIterator struct {
	Event *IValidatorPoolEventsValidatorMinorSlashed // Event containing the contract specifics and raw log

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
func (it *IValidatorPoolEventsValidatorMinorSlashedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IValidatorPoolEventsValidatorMinorSlashed)
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
		it.Event = new(IValidatorPoolEventsValidatorMinorSlashed)
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
func (it *IValidatorPoolEventsValidatorMinorSlashedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IValidatorPoolEventsValidatorMinorSlashedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IValidatorPoolEventsValidatorMinorSlashed represents a ValidatorMinorSlashed event raised by the IValidatorPoolEvents contract.
type IValidatorPoolEventsValidatorMinorSlashed struct {
	Account  common.Address
	StakeNFT *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterValidatorMinorSlashed is a free log retrieval operation binding the contract event 0x23f67a6ac6d764dca01e28630334f5b636e2b1928c0a5d5b5428da3f69167208.
//
// Solidity: event ValidatorMinorSlashed(address indexed account, uint256 stakeNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) FilterValidatorMinorSlashed(opts *bind.FilterOpts, account []common.Address) (*IValidatorPoolEventsValidatorMinorSlashedIterator, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.FilterLogs(opts, "ValidatorMinorSlashed", accountRule)
	if err != nil {
		return nil, err
	}
	return &IValidatorPoolEventsValidatorMinorSlashedIterator{contract: _IValidatorPoolEvents.contract, event: "ValidatorMinorSlashed", logs: logs, sub: sub}, nil
}

// WatchValidatorMinorSlashed is a free log subscription operation binding the contract event 0x23f67a6ac6d764dca01e28630334f5b636e2b1928c0a5d5b5428da3f69167208.
//
// Solidity: event ValidatorMinorSlashed(address indexed account, uint256 stakeNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) WatchValidatorMinorSlashed(opts *bind.WatchOpts, sink chan<- *IValidatorPoolEventsValidatorMinorSlashed, account []common.Address) (event.Subscription, error) {

	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}

	logs, sub, err := _IValidatorPoolEvents.contract.WatchLogs(opts, "ValidatorMinorSlashed", accountRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IValidatorPoolEventsValidatorMinorSlashed)
				if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorMinorSlashed", log); err != nil {
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

// ParseValidatorMinorSlashed is a log parse operation binding the contract event 0x23f67a6ac6d764dca01e28630334f5b636e2b1928c0a5d5b5428da3f69167208.
//
// Solidity: event ValidatorMinorSlashed(address indexed account, uint256 stakeNFT)
func (_IValidatorPoolEvents *IValidatorPoolEventsFilterer) ParseValidatorMinorSlashed(log types.Log) (*IValidatorPoolEventsValidatorMinorSlashed, error) {
	event := new(IValidatorPoolEventsValidatorMinorSlashed)
	if err := _IValidatorPoolEvents.contract.UnpackLog(event, "ValidatorMinorSlashed", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
