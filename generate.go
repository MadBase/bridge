package bridge

//go:generate mkdir -p bindings
//go:generate abigen --abi bindings-artifacts/ETHDKG.json --pkg bindings --type ETHDKG --out bindings/ETHDKG.go
//go:generate abigen --abi bindings-artifacts/IETHDKG.json --pkg bindings --type IETHDKG --out bindings/IETHDKG.go
//go:generate abigen --abi bindings-artifacts/IETHDKGEvents.json --pkg bindings --type IETHDKGEvents --out bindings/IETHDKGEvents.go
//go:generate abigen --abi bindings-artifacts/ISnapshots.json --pkg bindings --type ISnapshots --out bindings/ISnapshots.go
//go:generate abigen --abi bindings-artifacts/IValidatorPool.json --pkg bindings --type IValidatorPool --out bindings/IValidatorPool.go
//go:generate abigen --abi bindings-artifacts/ImmutableETHDKG.json --pkg bindings --type ImmutableETHDKG --out bindings/ImmutableETHDKG.go
//go:generate abigen --abi bindings-artifacts/ImmutableMadByte.json --pkg bindings --type ImmutableMadByte --out bindings/ImmutableMadByte.go
//go:generate abigen --abi bindings-artifacts/ImmutableMadToken.json --pkg bindings --type ImmutableMadToken --out bindings/ImmutableMadToken.go
//go:generate abigen --abi bindings-artifacts/ImmutableSnapshots.json --pkg bindings --type ImmutableSnapshots --out bindings/ImmutableSnapshots.go
//go:generate abigen --abi bindings-artifacts/ImmutableStakeNFT.json --pkg bindings --type ImmutableStakeNFT --out bindings/ImmutableStakeNFT.go
//go:generate abigen --abi bindings-artifacts/ImmutableStakeNFTLP.json --pkg bindings --type ImmutableStakeNFTLP --out bindings/ImmutableStakeNFTLP.go
//go:generate abigen --abi bindings-artifacts/ImmutableValidatorNFT.json --pkg bindings --type ImmutableValidatorNFT --out bindings/ImmutableValidatorNFT.go
//go:generate abigen --abi bindings-artifacts/ImmutableValidatorPool.json --pkg bindings --type ImmutableValidatorPool --out bindings/ImmutableValidatorPool.go
//go:generate abigen --abi bindings-artifacts/MadByte.json --pkg bindings --type MadByte --out bindings/MadByte.go
//go:generate abigen --abi bindings-artifacts/MadToken.json --pkg bindings --type MadToken --out bindings/MadToken.go
//go:generate abigen --abi bindings-artifacts/MadnetFactory.json --pkg bindings --type MadnetFactory --out bindings/MadnetFactory.go
//go:generate abigen --abi bindings-artifacts/Snapshots.json --pkg bindings --type Snapshots --out bindings/Snapshots.go
//go:generate abigen --abi bindings-artifacts/StakeNFT.json --pkg bindings --type StakeNFT --out bindings/StakeNFT.go
//go:generate abigen --abi bindings-artifacts/StakeNFTLP.json --pkg bindings --type StakeNFTLP --out bindings/StakeNFTLP.go
//go:generate abigen --abi bindings-artifacts/ValidatorNFT.json --pkg bindings --type ValidatorNFT --out bindings/ValidatorNFT.go
//go:generate abigen --abi bindings-artifacts/ValidatorPool.json --pkg bindings --type ValidatorPool --out bindings/ValidatorPool.go
