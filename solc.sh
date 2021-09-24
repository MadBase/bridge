#!/bin/sh
solc --bin --optimize-runs 2000 --allow-paths ., --overwrite ds-stop/=lib/ds-stop/src/ ds-auth/=lib/ds-auth/src/ ds-note/=lib/ds-stop/lib/ds-note/src/ ds-math/=lib/ds-math/src/ $*
