package bridge

mkdir -p bindings
//go:generate abigen --abi artifacts/abigen/ETHDKG.json --pkg bindings --type ETHDKG --out bindings/ETHDKG.go
//go:generate abigen --abi artifacts/abigen/IETHDKG.json --pkg bindings --type IETHDKG --out bindings/IETHDKG.go
//go:generate abigen --abi artifacts/abigen/IETHDKGEvents.json --pkg bindings --type IETHDKGEvents --out bindings/IETHDKGEvents.go
//go:generate abigen --abi artifacts/abigen/ISnapshots.json --pkg bindings --type ISnapshots --out bindings/ISnapshots.go
//go:generate abigen --abi artifacts/abigen/IValidatorPool.json --pkg bindings --type IValidatorPool --out bindings/IValidatorPool.go
//go:generate abigen --abi artifacts/abigen/IValidatorPoolEvents.json --pkg bindings --type IValidatorPoolEvents --out bindings/IValidatorPoolEvents.go
//go:generate abigen --abi artifacts/abigen/ImmutableETHDKG.json --pkg bindings --type ImmutableETHDKG --out bindings/ImmutableETHDKG.go
//go:generate abigen --abi artifacts/abigen/ImmutableMadByte.json --pkg bindings --type ImmutableMadByte --out bindings/ImmutableMadByte.go
//go:generate abigen --abi artifacts/abigen/ImmutableMadToken.json --pkg bindings --type ImmutableMadToken --out bindings/ImmutableMadToken.go
//go:generate abigen --abi artifacts/abigen/ImmutableSnapshots.json --pkg bindings --type ImmutableSnapshots --out bindings/ImmutableSnapshots.go
//go:generate abigen --abi artifacts/abigen/ImmutableStakeNFT.json --pkg bindings --type ImmutableStakeNFT --out bindings/ImmutableStakeNFT.go
//go:generate abigen --abi artifacts/abigen/ImmutableStakeNFTLP.json --pkg bindings --type ImmutableStakeNFTLP --out bindings/ImmutableStakeNFTLP.go
//go:generate abigen --abi artifacts/abigen/ImmutableValidatorNFT.json --pkg bindings --type ImmutableValidatorNFT --out bindings/ImmutableValidatorNFT.go
//go:generate abigen --abi artifacts/abigen/ImmutableValidatorPool.json --pkg bindings --type ImmutableValidatorPool --out bindings/ImmutableValidatorPool.go
//go:generate abigen --abi artifacts/abigen/MadByte.json --pkg bindings --type MadByte --out bindings/MadByte.go
//go:generate abigen --abi artifacts/abigen/MadToken.json --pkg bindings --type MadToken --out bindings/MadToken.go
//go:generate abigen --abi artifacts/abigen/MadnetFactory.json --pkg bindings --type MadnetFactory --out bindings/MadnetFactory.go
//go:generate abigen --abi artifacts/abigen/Snapshots.json --pkg bindings --type Snapshots --out bindings/Snapshots.go
//go:generate abigen --abi artifacts/abigen/StakeNFT.json --pkg bindings --type StakeNFT --out bindings/StakeNFT.go
//go:generate abigen --abi artifacts/abigen/StakeNFTLP.json --pkg bindings --type StakeNFTLP --out bindings/StakeNFTLP.go
//go:generate abigen --abi artifacts/abigen/ValidatorNFT.json --pkg bindings --type ValidatorNFT --out bindings/ValidatorNFT.go
//go:generate abigen --abi artifacts/abigen/ValidatorPool.json --pkg bindings --type ValidatorPool --out bindings/ValidatorPool.go
