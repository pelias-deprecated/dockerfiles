#!/bin/bash
set -e
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for f in ${BASEDIR}/lib/* ${BASEDIR}/cmd/*; do source $f; done

# ensure all docker images are up-to-date
compose_pull

# start elasticsearch if it's not already running
if test $(elastic_status) -ne 200; then
  elastic_start
  elastic_wait
fi

# drop and recreate index
elastic_schema_drop '-f'
elastic_schema_create

# download all the data to be used by imports
download_all

# prepare all systems with a build step
prepare_all

# import all datasets
import_all
