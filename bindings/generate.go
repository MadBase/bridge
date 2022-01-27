package bindings

//go:generate ifacemaker -f bridge.go -s AccusationCaller -o iface_accusation_caller.go -p bindings -i IAccusationCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s AccusationTransactor -o iface_accusation_transactor.go -p bindings -i IAccusationTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s AccusationFilterer -o iface_accusation_filterer.go -p bindings -i IAccusationFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IAccusation interface {
	IAccusationCaller
	IAccusationTransactor
	IAccusationFilterer
}

//go:generate ifacemaker -f bridge.go -s CryptoCaller -o iface_crypto_caller.go -p bindings -i ICryptoCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s CryptoTransactor -o iface_crypto_transactor.go -p bindings -i ICryptoTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s CryptoFilterer -o iface_crypto_filterer.go -p bindings -i ICryptoFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type ICrypto interface {
	ICryptoCaller
	ICryptoTransactor
	ICryptoFilterer
}

//go:generate ifacemaker -f bridge.go -s DepositCaller -o iface_deposit_caller.go -p bindings -i IDepositCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s DepositTransactor -o iface_deposit_transactor.go -p bindings -i IDepositTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s DepositFilterer -o iface_deposit_filterer.go -p bindings -i IDepositFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IDeposit interface {
	IDepositCaller
	IDepositTransactor
	IDepositFilterer
}

//go:generate ifacemaker -f bridge.go -s ETHDKGCaller -o iface_ethdkg_caller.go -p bindings -i IEthDkgCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s ETHDKGTransactor -o iface_ethdkg_transactor.go -p bindings -i IEthDkgTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s ETHDKGFilterer -o iface_ethdkg_filterer.go -p bindings -i IEthDkgFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IEthDkg interface {
	IEthDkgCaller
	IEthDkgTransactor
	IEthDkgFilterer
}

//go:generate ifacemaker -f bridge.go -s GovernorCaller -o iface_governor_caller.go -p bindings -i IGovernorCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s GovernorTransactor -o iface_governor_transactor.go -p bindings -i IGovernorTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s GovernorFilterer -o iface_governor_filterer.go -p bindings -i IGovernorFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IGovernor interface {
	IGovernorCaller
	IGovernorTransactor
	IGovernorFilterer
}

//go:generate ifacemaker -f bridge.go -s ParticipantsCaller -o iface_participants_caller.go -p bindings -i IParticipantsCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s ParticipantsTransactor -o iface_participants_transactor.go -p bindings -i IParticipantsTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s ParticipantsFilterer -o iface_participants_filterer.go -p bindings -i IParticipantsFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IParticipants interface {
	IParticipantsCaller
	IParticipantsTransactor
	IParticipantsFilterer
}

//go:generate ifacemaker -f bridge.go -s RegistryCaller -o iface_registry_caller.go -p bindings -i IRegistryCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s RegistryTransactor -o iface_registry_transactor.go -p bindings -i IRegistryTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s RegistryFilterer -o iface_registry_filterer.go -p bindings -i IRegistryFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IRegistry interface {
	IRegistryCaller
	IRegistryTransactor
	IRegistryFilterer
}

//go:generate ifacemaker -f bridge.go -s SnapshotsCaller -o iface_snapshot_caller.go -p bindings -i ISnapshotsCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s SnapshotsTransactor -o iface_snapshot_transactor.go -p bindings -i ISnapshotsTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s SnapshotsFilterer -o iface_snapshot_filterer.go -p bindings -i ISnapshotsFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type ISnapshots interface {
	ISnapshotsCaller
	ISnapshotsTransactor
	ISnapshotsFilterer
}

//go:generate ifacemaker -f bridge.go -s StakingCaller -o iface_staking_caller.go -p bindings -i IStakingCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s StakingTransactor -o iface_staking_transactor.go -p bindings -i IStakingTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s StakingFilterer -o iface_staking_filterer.go -p bindings -i IStakingFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IStaking interface {
	IStakingCaller
	IStakingTransactor
	IStakingFilterer
}

//go:generate ifacemaker -f bridge.go -s TokenCaller -o iface_token_caller.go -p bindings -i ITokenCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s TokenTransactor -o iface_token_transactor.go -p bindings -i ITokenTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s TokenFilterer -o iface_token_filterer.go -p bindings -i ITokenFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IToken interface {
	ITokenCaller
	ITokenTransactor
	ITokenFilterer
}

//go:generate ifacemaker -f bridge.go -s ValidatorsCaller -o iface_validators_caller.go -p bindings -i IValidatorsCaller -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s ValidatorsTransactor -o iface_validators_transactor.go -p bindings -i IValidatorsTransactor -c "Generated by ifacemaker. DO NOT EDIT."
//go:generate ifacemaker -f bridge.go -s ValidatorsFilterer -o iface_validators_filterer.go -p bindings -i IValidatorsFilterer -c "Generated by ifacemaker. DO NOT EDIT."
type IValidators interface {
	IValidatorsCaller
	IValidatorsTransactor
	IValidatorsFilterer
}
