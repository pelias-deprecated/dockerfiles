#!/bin/bash
set -e
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source <(cat ${BASEDIR}/lib/* ${BASEDIR}/cmd/*)

# cli runner
cli "$@"
