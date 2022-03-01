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

// IETHDKGEventsMetaData contains all meta data concerning the IETHDKGEvents contract.
var IETHDKGEventsMetaData = &bind.MetaData{
	ABI: "[{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"publicKey\",\"type\":\"uint256[2]\"}],\"name\":\"AddressRegistered\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"GPKJSubmissionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"KeyShareSubmissionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1\",\"type\":\"uint256[2]\"},{\"indexed\":false,\"internalType\":\"uint256[2]\",\"name\":\"keyShareG1CorrectnessProof\",\"type\":\"uint256[2]\"},{\"indexed\":false,\"internalType\":\"uint256[4]\",\"name\":\"keyShareG2\",\"type\":\"uint256[4]\"}],\"name\":\"KeyShareSubmitted\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[4]\",\"name\":\"mpk\",\"type\":\"uint256[4]\"}],\"name\":\"MPKSet\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"RegistrationComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"startBlock\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"numberValidators\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"phaseLength\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"confirmationLength\",\"type\":\"uint256\"}],\"name\":\"RegistrationOpened\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"ShareDistributionComplete\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256[]\",\"name\":\"encryptedShares\",\"type\":\"uint256[]\"},{\"indexed\":false,\"internalType\":\"uint256[2][]\",\"name\":\"commitments\",\"type\":\"uint256[2][]\"}],\"name\":\"SharesDistributed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"epoch\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share0\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share1\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share2\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"share3\",\"type\":\"uint256\"}],\"name\":\"ValidatorMemberAdded\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"validatorCount\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"epoch\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"ethHeight\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"madHeight\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey0\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey1\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey2\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"groupKey3\",\"type\":\"uint256\"}],\"name\":\"ValidatorSetCompleted\",\"type\":\"event\"}]",
}

// IETHDKGEventsABI is the input ABI used to generate the binding from.
// Deprecated: Use IETHDKGEventsMetaData.ABI instead.
var IETHDKGEventsABI = IETHDKGEventsMetaData.ABI

// IETHDKGEvents is an auto generated Go binding around an Ethereum contract.
type IETHDKGEvents struct {
	IETHDKGEventsCaller     // Read-only binding to the contract
	IETHDKGEventsTransactor // Write-only binding to the contract
	IETHDKGEventsFilterer   // Log filterer for contract events
}

// IETHDKGEventsCaller is an auto generated read-only Go binding around an Ethereum contract.
type IETHDKGEventsCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IETHDKGEventsTransactor is an auto generated write-only Go binding around an Ethereum contract.
type IETHDKGEventsTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IETHDKGEventsFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type IETHDKGEventsFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// IETHDKGEventsSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type IETHDKGEventsSession struct {
	Contract     *IETHDKGEvents    // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// IETHDKGEventsCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type IETHDKGEventsCallerSession struct {
	Contract *IETHDKGEventsCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts        // Call options to use throughout this session
}

// IETHDKGEventsTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type IETHDKGEventsTransactorSession struct {
	Contract     *IETHDKGEventsTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts        // Transaction auth options to use throughout this session
}

// IETHDKGEventsRaw is an auto generated low-level Go binding around an Ethereum contract.
type IETHDKGEventsRaw struct {
	Contract *IETHDKGEvents // Generic contract binding to access the raw methods on
}

// IETHDKGEventsCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type IETHDKGEventsCallerRaw struct {
	Contract *IETHDKGEventsCaller // Generic read-only contract binding to access the raw methods on
}

// IETHDKGEventsTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type IETHDKGEventsTransactorRaw struct {
	Contract *IETHDKGEventsTransactor // Generic write-only contract binding to access the raw methods on
}

// NewIETHDKGEvents creates a new instance of IETHDKGEvents, bound to a specific deployed contract.
func NewIETHDKGEvents(address common.Address, backend bind.ContractBackend) (*IETHDKGEvents, error) {
	contract, err := bindIETHDKGEvents(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &IETHDKGEvents{IETHDKGEventsCaller: IETHDKGEventsCaller{contract: contract}, IETHDKGEventsTransactor: IETHDKGEventsTransactor{contract: contract}, IETHDKGEventsFilterer: IETHDKGEventsFilterer{contract: contract}}, nil
}

// NewIETHDKGEventsCaller creates a new read-only instance of IETHDKGEvents, bound to a specific deployed contract.
func NewIETHDKGEventsCaller(address common.Address, caller bind.ContractCaller) (*IETHDKGEventsCaller, error) {
	contract, err := bindIETHDKGEvents(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsCaller{contract: contract}, nil
}

// NewIETHDKGEventsTransactor creates a new write-only instance of IETHDKGEvents, bound to a specific deployed contract.
func NewIETHDKGEventsTransactor(address common.Address, transactor bind.ContractTransactor) (*IETHDKGEventsTransactor, error) {
	contract, err := bindIETHDKGEvents(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsTransactor{contract: contract}, nil
}

// NewIETHDKGEventsFilterer creates a new log filterer instance of IETHDKGEvents, bound to a specific deployed contract.
func NewIETHDKGEventsFilterer(address common.Address, filterer bind.ContractFilterer) (*IETHDKGEventsFilterer, error) {
	contract, err := bindIETHDKGEvents(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsFilterer{contract: contract}, nil
}

// bindIETHDKGEvents binds a generic wrapper to an already deployed contract.
func bindIETHDKGEvents(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(IETHDKGEventsABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IETHDKGEvents *IETHDKGEventsRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IETHDKGEvents.Contract.IETHDKGEventsCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IETHDKGEvents *IETHDKGEventsRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IETHDKGEvents.Contract.IETHDKGEventsTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IETHDKGEvents *IETHDKGEventsRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IETHDKGEvents.Contract.IETHDKGEventsTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_IETHDKGEvents *IETHDKGEventsCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _IETHDKGEvents.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_IETHDKGEvents *IETHDKGEventsTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _IETHDKGEvents.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_IETHDKGEvents *IETHDKGEventsTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _IETHDKGEvents.Contract.contract.Transact(opts, method, params...)
}

// IETHDKGEventsAddressRegisteredIterator is returned from FilterAddressRegistered and is used to iterate over the raw logs and unpacked data for AddressRegistered events raised by the IETHDKGEvents contract.
type IETHDKGEventsAddressRegisteredIterator struct {
	Event *IETHDKGEventsAddressRegistered // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsAddressRegisteredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsAddressRegistered)
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
		it.Event = new(IETHDKGEventsAddressRegistered)
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
func (it *IETHDKGEventsAddressRegisteredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsAddressRegisteredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsAddressRegistered represents a AddressRegistered event raised by the IETHDKGEvents contract.
type IETHDKGEventsAddressRegistered struct {
	Account   common.Address
	Index     *big.Int
	Nonce     *big.Int
	PublicKey [2]*big.Int
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterAddressRegistered is a free log retrieval operation binding the contract event 0x7f1304057ec61140fbf2f5f236790f34fcafe123d3eb0d298d92317c97da500d.
//
// Solidity: event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey)
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterAddressRegistered(opts *bind.FilterOpts) (*IETHDKGEventsAddressRegisteredIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "AddressRegistered")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsAddressRegisteredIterator{contract: _IETHDKGEvents.contract, event: "AddressRegistered", logs: logs, sub: sub}, nil
}

// WatchAddressRegistered is a free log subscription operation binding the contract event 0x7f1304057ec61140fbf2f5f236790f34fcafe123d3eb0d298d92317c97da500d.
//
// Solidity: event AddressRegistered(address account, uint256 index, uint256 nonce, uint256[2] publicKey)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchAddressRegistered(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsAddressRegistered) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "AddressRegistered")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsAddressRegistered)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "AddressRegistered", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseAddressRegistered(log types.Log) (*IETHDKGEventsAddressRegistered, error) {
	event := new(IETHDKGEventsAddressRegistered)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "AddressRegistered", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsGPKJSubmissionCompleteIterator is returned from FilterGPKJSubmissionComplete and is used to iterate over the raw logs and unpacked data for GPKJSubmissionComplete events raised by the IETHDKGEvents contract.
type IETHDKGEventsGPKJSubmissionCompleteIterator struct {
	Event *IETHDKGEventsGPKJSubmissionComplete // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsGPKJSubmissionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsGPKJSubmissionComplete)
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
		it.Event = new(IETHDKGEventsGPKJSubmissionComplete)
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
func (it *IETHDKGEventsGPKJSubmissionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsGPKJSubmissionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsGPKJSubmissionComplete represents a GPKJSubmissionComplete event raised by the IETHDKGEvents contract.
type IETHDKGEventsGPKJSubmissionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterGPKJSubmissionComplete is a free log retrieval operation binding the contract event 0x87bfe600b78cad9f7cf68c99eb582c1748f636b3269842b37d5873b0e069f628.
//
// Solidity: event GPKJSubmissionComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterGPKJSubmissionComplete(opts *bind.FilterOpts) (*IETHDKGEventsGPKJSubmissionCompleteIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "GPKJSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsGPKJSubmissionCompleteIterator{contract: _IETHDKGEvents.contract, event: "GPKJSubmissionComplete", logs: logs, sub: sub}, nil
}

// WatchGPKJSubmissionComplete is a free log subscription operation binding the contract event 0x87bfe600b78cad9f7cf68c99eb582c1748f636b3269842b37d5873b0e069f628.
//
// Solidity: event GPKJSubmissionComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchGPKJSubmissionComplete(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsGPKJSubmissionComplete) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "GPKJSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsGPKJSubmissionComplete)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "GPKJSubmissionComplete", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseGPKJSubmissionComplete(log types.Log) (*IETHDKGEventsGPKJSubmissionComplete, error) {
	event := new(IETHDKGEventsGPKJSubmissionComplete)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "GPKJSubmissionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsKeyShareSubmissionCompleteIterator is returned from FilterKeyShareSubmissionComplete and is used to iterate over the raw logs and unpacked data for KeyShareSubmissionComplete events raised by the IETHDKGEvents contract.
type IETHDKGEventsKeyShareSubmissionCompleteIterator struct {
	Event *IETHDKGEventsKeyShareSubmissionComplete // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsKeyShareSubmissionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsKeyShareSubmissionComplete)
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
		it.Event = new(IETHDKGEventsKeyShareSubmissionComplete)
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
func (it *IETHDKGEventsKeyShareSubmissionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsKeyShareSubmissionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsKeyShareSubmissionComplete represents a KeyShareSubmissionComplete event raised by the IETHDKGEvents contract.
type IETHDKGEventsKeyShareSubmissionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterKeyShareSubmissionComplete is a free log retrieval operation binding the contract event 0x522cec98f6caa194456c44afa9e8cef9ac63eecb0be60e20d180ce19cfb0ef59.
//
// Solidity: event KeyShareSubmissionComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterKeyShareSubmissionComplete(opts *bind.FilterOpts) (*IETHDKGEventsKeyShareSubmissionCompleteIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "KeyShareSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsKeyShareSubmissionCompleteIterator{contract: _IETHDKGEvents.contract, event: "KeyShareSubmissionComplete", logs: logs, sub: sub}, nil
}

// WatchKeyShareSubmissionComplete is a free log subscription operation binding the contract event 0x522cec98f6caa194456c44afa9e8cef9ac63eecb0be60e20d180ce19cfb0ef59.
//
// Solidity: event KeyShareSubmissionComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchKeyShareSubmissionComplete(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsKeyShareSubmissionComplete) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "KeyShareSubmissionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsKeyShareSubmissionComplete)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "KeyShareSubmissionComplete", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseKeyShareSubmissionComplete(log types.Log) (*IETHDKGEventsKeyShareSubmissionComplete, error) {
	event := new(IETHDKGEventsKeyShareSubmissionComplete)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "KeyShareSubmissionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsKeyShareSubmittedIterator is returned from FilterKeyShareSubmitted and is used to iterate over the raw logs and unpacked data for KeyShareSubmitted events raised by the IETHDKGEvents contract.
type IETHDKGEventsKeyShareSubmittedIterator struct {
	Event *IETHDKGEventsKeyShareSubmitted // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsKeyShareSubmittedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsKeyShareSubmitted)
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
		it.Event = new(IETHDKGEventsKeyShareSubmitted)
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
func (it *IETHDKGEventsKeyShareSubmittedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsKeyShareSubmittedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsKeyShareSubmitted represents a KeyShareSubmitted event raised by the IETHDKGEvents contract.
type IETHDKGEventsKeyShareSubmitted struct {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterKeyShareSubmitted(opts *bind.FilterOpts) (*IETHDKGEventsKeyShareSubmittedIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "KeyShareSubmitted")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsKeyShareSubmittedIterator{contract: _IETHDKGEvents.contract, event: "KeyShareSubmitted", logs: logs, sub: sub}, nil
}

// WatchKeyShareSubmitted is a free log subscription operation binding the contract event 0x6162e2d11398e4063e4c8565dafc4fb6755bbead93747ea836a5ef73a594aaf7.
//
// Solidity: event KeyShareSubmitted(address account, uint256 index, uint256 nonce, uint256[2] keyShareG1, uint256[2] keyShareG1CorrectnessProof, uint256[4] keyShareG2)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchKeyShareSubmitted(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsKeyShareSubmitted) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "KeyShareSubmitted")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsKeyShareSubmitted)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "KeyShareSubmitted", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseKeyShareSubmitted(log types.Log) (*IETHDKGEventsKeyShareSubmitted, error) {
	event := new(IETHDKGEventsKeyShareSubmitted)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "KeyShareSubmitted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsMPKSetIterator is returned from FilterMPKSet and is used to iterate over the raw logs and unpacked data for MPKSet events raised by the IETHDKGEvents contract.
type IETHDKGEventsMPKSetIterator struct {
	Event *IETHDKGEventsMPKSet // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsMPKSetIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsMPKSet)
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
		it.Event = new(IETHDKGEventsMPKSet)
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
func (it *IETHDKGEventsMPKSetIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsMPKSetIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsMPKSet represents a MPKSet event raised by the IETHDKGEvents contract.
type IETHDKGEventsMPKSet struct {
	BlockNumber *big.Int
	Nonce       *big.Int
	Mpk         [4]*big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterMPKSet is a free log retrieval operation binding the contract event 0x71b1ebd27be320895a22125d6458e3363aefa6944a312ede4bf275867e6d5a71.
//
// Solidity: event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterMPKSet(opts *bind.FilterOpts) (*IETHDKGEventsMPKSetIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "MPKSet")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsMPKSetIterator{contract: _IETHDKGEvents.contract, event: "MPKSet", logs: logs, sub: sub}, nil
}

// WatchMPKSet is a free log subscription operation binding the contract event 0x71b1ebd27be320895a22125d6458e3363aefa6944a312ede4bf275867e6d5a71.
//
// Solidity: event MPKSet(uint256 blockNumber, uint256 nonce, uint256[4] mpk)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchMPKSet(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsMPKSet) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "MPKSet")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsMPKSet)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "MPKSet", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseMPKSet(log types.Log) (*IETHDKGEventsMPKSet, error) {
	event := new(IETHDKGEventsMPKSet)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "MPKSet", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsRegistrationCompleteIterator is returned from FilterRegistrationComplete and is used to iterate over the raw logs and unpacked data for RegistrationComplete events raised by the IETHDKGEvents contract.
type IETHDKGEventsRegistrationCompleteIterator struct {
	Event *IETHDKGEventsRegistrationComplete // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsRegistrationCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsRegistrationComplete)
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
		it.Event = new(IETHDKGEventsRegistrationComplete)
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
func (it *IETHDKGEventsRegistrationCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsRegistrationCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsRegistrationComplete represents a RegistrationComplete event raised by the IETHDKGEvents contract.
type IETHDKGEventsRegistrationComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterRegistrationComplete is a free log retrieval operation binding the contract event 0x833013b96b786b4eca83baac286920e5e53956c21ff3894f1d9f02e97d6ed764.
//
// Solidity: event RegistrationComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterRegistrationComplete(opts *bind.FilterOpts) (*IETHDKGEventsRegistrationCompleteIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "RegistrationComplete")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsRegistrationCompleteIterator{contract: _IETHDKGEvents.contract, event: "RegistrationComplete", logs: logs, sub: sub}, nil
}

// WatchRegistrationComplete is a free log subscription operation binding the contract event 0x833013b96b786b4eca83baac286920e5e53956c21ff3894f1d9f02e97d6ed764.
//
// Solidity: event RegistrationComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchRegistrationComplete(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsRegistrationComplete) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "RegistrationComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsRegistrationComplete)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "RegistrationComplete", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseRegistrationComplete(log types.Log) (*IETHDKGEventsRegistrationComplete, error) {
	event := new(IETHDKGEventsRegistrationComplete)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "RegistrationComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsRegistrationOpenedIterator is returned from FilterRegistrationOpened and is used to iterate over the raw logs and unpacked data for RegistrationOpened events raised by the IETHDKGEvents contract.
type IETHDKGEventsRegistrationOpenedIterator struct {
	Event *IETHDKGEventsRegistrationOpened // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsRegistrationOpenedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsRegistrationOpened)
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
		it.Event = new(IETHDKGEventsRegistrationOpened)
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
func (it *IETHDKGEventsRegistrationOpenedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsRegistrationOpenedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsRegistrationOpened represents a RegistrationOpened event raised by the IETHDKGEvents contract.
type IETHDKGEventsRegistrationOpened struct {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterRegistrationOpened(opts *bind.FilterOpts) (*IETHDKGEventsRegistrationOpenedIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "RegistrationOpened")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsRegistrationOpenedIterator{contract: _IETHDKGEvents.contract, event: "RegistrationOpened", logs: logs, sub: sub}, nil
}

// WatchRegistrationOpened is a free log subscription operation binding the contract event 0xbda431b9b63510f1398bf33d700e013315bcba905507078a1780f13ea5b354b9.
//
// Solidity: event RegistrationOpened(uint256 startBlock, uint256 numberValidators, uint256 nonce, uint256 phaseLength, uint256 confirmationLength)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchRegistrationOpened(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsRegistrationOpened) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "RegistrationOpened")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsRegistrationOpened)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "RegistrationOpened", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseRegistrationOpened(log types.Log) (*IETHDKGEventsRegistrationOpened, error) {
	event := new(IETHDKGEventsRegistrationOpened)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "RegistrationOpened", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsShareDistributionCompleteIterator is returned from FilterShareDistributionComplete and is used to iterate over the raw logs and unpacked data for ShareDistributionComplete events raised by the IETHDKGEvents contract.
type IETHDKGEventsShareDistributionCompleteIterator struct {
	Event *IETHDKGEventsShareDistributionComplete // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsShareDistributionCompleteIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsShareDistributionComplete)
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
		it.Event = new(IETHDKGEventsShareDistributionComplete)
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
func (it *IETHDKGEventsShareDistributionCompleteIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsShareDistributionCompleteIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsShareDistributionComplete represents a ShareDistributionComplete event raised by the IETHDKGEvents contract.
type IETHDKGEventsShareDistributionComplete struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterShareDistributionComplete is a free log retrieval operation binding the contract event 0xbfe94ffef5ddde4d25ac7b652f3f67686ea63f9badbfe1f25451e26fc262d11c.
//
// Solidity: event ShareDistributionComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterShareDistributionComplete(opts *bind.FilterOpts) (*IETHDKGEventsShareDistributionCompleteIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "ShareDistributionComplete")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsShareDistributionCompleteIterator{contract: _IETHDKGEvents.contract, event: "ShareDistributionComplete", logs: logs, sub: sub}, nil
}

// WatchShareDistributionComplete is a free log subscription operation binding the contract event 0xbfe94ffef5ddde4d25ac7b652f3f67686ea63f9badbfe1f25451e26fc262d11c.
//
// Solidity: event ShareDistributionComplete(uint256 blockNumber)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchShareDistributionComplete(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsShareDistributionComplete) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "ShareDistributionComplete")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsShareDistributionComplete)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "ShareDistributionComplete", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseShareDistributionComplete(log types.Log) (*IETHDKGEventsShareDistributionComplete, error) {
	event := new(IETHDKGEventsShareDistributionComplete)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "ShareDistributionComplete", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsSharesDistributedIterator is returned from FilterSharesDistributed and is used to iterate over the raw logs and unpacked data for SharesDistributed events raised by the IETHDKGEvents contract.
type IETHDKGEventsSharesDistributedIterator struct {
	Event *IETHDKGEventsSharesDistributed // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsSharesDistributedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsSharesDistributed)
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
		it.Event = new(IETHDKGEventsSharesDistributed)
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
func (it *IETHDKGEventsSharesDistributedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsSharesDistributedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsSharesDistributed represents a SharesDistributed event raised by the IETHDKGEvents contract.
type IETHDKGEventsSharesDistributed struct {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterSharesDistributed(opts *bind.FilterOpts) (*IETHDKGEventsSharesDistributedIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "SharesDistributed")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsSharesDistributedIterator{contract: _IETHDKGEvents.contract, event: "SharesDistributed", logs: logs, sub: sub}, nil
}

// WatchSharesDistributed is a free log subscription operation binding the contract event 0xf0c8b0ef2867c2b4639b404a0296b6bbf0bf97e20856af42144a5a6035c0d0d2.
//
// Solidity: event SharesDistributed(address account, uint256 index, uint256 nonce, uint256[] encryptedShares, uint256[2][] commitments)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchSharesDistributed(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsSharesDistributed) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "SharesDistributed")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsSharesDistributed)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "SharesDistributed", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseSharesDistributed(log types.Log) (*IETHDKGEventsSharesDistributed, error) {
	event := new(IETHDKGEventsSharesDistributed)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "SharesDistributed", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsValidatorMemberAddedIterator is returned from FilterValidatorMemberAdded and is used to iterate over the raw logs and unpacked data for ValidatorMemberAdded events raised by the IETHDKGEvents contract.
type IETHDKGEventsValidatorMemberAddedIterator struct {
	Event *IETHDKGEventsValidatorMemberAdded // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsValidatorMemberAddedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsValidatorMemberAdded)
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
		it.Event = new(IETHDKGEventsValidatorMemberAdded)
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
func (it *IETHDKGEventsValidatorMemberAddedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsValidatorMemberAddedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsValidatorMemberAdded represents a ValidatorMemberAdded event raised by the IETHDKGEvents contract.
type IETHDKGEventsValidatorMemberAdded struct {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterValidatorMemberAdded(opts *bind.FilterOpts) (*IETHDKGEventsValidatorMemberAddedIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "ValidatorMemberAdded")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsValidatorMemberAddedIterator{contract: _IETHDKGEvents.contract, event: "ValidatorMemberAdded", logs: logs, sub: sub}, nil
}

// WatchValidatorMemberAdded is a free log subscription operation binding the contract event 0x09b90b08bbc3dbe22e9d2a0bc9c2c7614c7511cd0ad72177727a1e762115bf06.
//
// Solidity: event ValidatorMemberAdded(address account, uint256 index, uint256 nonce, uint256 epoch, uint256 share0, uint256 share1, uint256 share2, uint256 share3)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchValidatorMemberAdded(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsValidatorMemberAdded) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "ValidatorMemberAdded")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsValidatorMemberAdded)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "ValidatorMemberAdded", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseValidatorMemberAdded(log types.Log) (*IETHDKGEventsValidatorMemberAdded, error) {
	event := new(IETHDKGEventsValidatorMemberAdded)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "ValidatorMemberAdded", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// IETHDKGEventsValidatorSetCompletedIterator is returned from FilterValidatorSetCompleted and is used to iterate over the raw logs and unpacked data for ValidatorSetCompleted events raised by the IETHDKGEvents contract.
type IETHDKGEventsValidatorSetCompletedIterator struct {
	Event *IETHDKGEventsValidatorSetCompleted // Event containing the contract specifics and raw log

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
func (it *IETHDKGEventsValidatorSetCompletedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(IETHDKGEventsValidatorSetCompleted)
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
		it.Event = new(IETHDKGEventsValidatorSetCompleted)
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
func (it *IETHDKGEventsValidatorSetCompletedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *IETHDKGEventsValidatorSetCompletedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// IETHDKGEventsValidatorSetCompleted represents a ValidatorSetCompleted event raised by the IETHDKGEvents contract.
type IETHDKGEventsValidatorSetCompleted struct {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) FilterValidatorSetCompleted(opts *bind.FilterOpts) (*IETHDKGEventsValidatorSetCompletedIterator, error) {

	logs, sub, err := _IETHDKGEvents.contract.FilterLogs(opts, "ValidatorSetCompleted")
	if err != nil {
		return nil, err
	}
	return &IETHDKGEventsValidatorSetCompletedIterator{contract: _IETHDKGEvents.contract, event: "ValidatorSetCompleted", logs: logs, sub: sub}, nil
}

// WatchValidatorSetCompleted is a free log subscription operation binding the contract event 0xd7237b781669fa700ecf77be6cd8fa0f4b98b1a24ac584a9b6b44c509216718a.
//
// Solidity: event ValidatorSetCompleted(uint256 validatorCount, uint256 nonce, uint256 epoch, uint256 ethHeight, uint256 madHeight, uint256 groupKey0, uint256 groupKey1, uint256 groupKey2, uint256 groupKey3)
func (_IETHDKGEvents *IETHDKGEventsFilterer) WatchValidatorSetCompleted(opts *bind.WatchOpts, sink chan<- *IETHDKGEventsValidatorSetCompleted) (event.Subscription, error) {

	logs, sub, err := _IETHDKGEvents.contract.WatchLogs(opts, "ValidatorSetCompleted")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(IETHDKGEventsValidatorSetCompleted)
				if err := _IETHDKGEvents.contract.UnpackLog(event, "ValidatorSetCompleted", log); err != nil {
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
func (_IETHDKGEvents *IETHDKGEventsFilterer) ParseValidatorSetCompleted(log types.Log) (*IETHDKGEventsValidatorSetCompleted, error) {
	event := new(IETHDKGEventsValidatorSetCompleted)
	if err := _IETHDKGEvents.contract.UnpackLog(event, "ValidatorSetCompleted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
