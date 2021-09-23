#!/bin/sh
solc --bin --optimize-runs 2000 --allow-paths .,ds-token --overwrite ds-token/=lib/ds-token/src/ ds-stop/=lib/ds-stop/src/ ds-auth/=lib/ds-auth/src/ ds-note/=lib/ds-stop/lib/ds-note/src/ ds-math/=lib/ds-math/src/ erc20/=lib/ds-token/lib/erc20/src/ openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/ $*
