# Madnet/Bridge

This repository contains all solidity smart contracts used by the MadNet.

## Requirements

### Dapp tools

To build and deploy the contracts, we use a command line tool called **dapp
tools**. Check the [official dapptools
documentation](https://github.com/dapphub/dapptools#installation) for
instructions on how to install it.

Note: You will need to install Nix in order to install the **dapp tools**.

### Fetch all the required git submodules

Before, building, deploying or testing the smart-contracts, you will need to
fetch all the git submodules required by this project. In order to download all
the required submodules, run the following command on the terminal at the root
of this repository:

```bash
git submodule update --init --recursive
```

## Building, deploying and testing the smart contracts contracts

To build the contracts run:

```bash
make all
```

To deploy the smart contracts, run:

```bash
make deploy
```

To run all the tests:

```bash
make test
```

To clean the build artifacts, just run:

```bash
make clean
```

## Useful Resources

- [Diamonds Smart Contract Pattern](https://eips.ethereum.org/EIPS/eip-2535).
  The main architecture pattern used by the MadNet smart contracts.
- [Dapp
  documentation](https://github.com/dapphub/dapptools/tree/master/src/dapp).
  More information about the dapp commands and usage.