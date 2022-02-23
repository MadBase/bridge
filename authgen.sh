#!/bin/sh
set -e
OUTFILE=./src/utils/immutableAuth.sol
python3 pygen.py > $OUTFILE