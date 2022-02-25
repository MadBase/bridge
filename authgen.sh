#!/bin/sh
set -e
OUTFILE=./src/utils/ImmutableAuth.sol
python3 pygen.py > $OUTFILE