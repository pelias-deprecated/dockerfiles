#!/bin/bash
set -e
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for f in ${BASEDIR}/lib/* ${BASEDIR}/cmd/*; do source $f; done

# start elasticsearch if it's not already running
if test $(elastic_status) -ne 200; then
  elastic_start
  elastic_wait
fi

# start all services
compose_up
