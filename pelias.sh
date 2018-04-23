#!/bin/bash
set -e
export LC_ALL=en_US.UTF-8
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# load functions
source <(cat ${BASEDIR}/lib/*)
source <(cat ${BASEDIR}/cmd/*)

# ensure the user env is correctly set up
env_check

# cli runner
cli "$@"
