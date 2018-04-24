#!/bin/bash
set -e
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for f in ${BASEDIR}/lib/* ${BASEDIR}/cmd/*; do source $f; done

# cli runner
cli "$@"
