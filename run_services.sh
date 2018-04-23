#!/bin/bash
set -e
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source <(cat ${BASEDIR}/lib/*)
source <(cat ${BASEDIR}/cmd/*)

# load DATA_DIR and other vars from docker-compose .env file
env_load_stream < "${BASEDIR}/.env"

# ensure the user env is correctly set up
env_check

# start elasticsearch if it's not already running
if test $(elastic_status) -ne 200; then
  elastic_start
  elastic_wait
fi

# start all services
docker-compose up -d
