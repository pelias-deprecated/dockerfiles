#!/bin/bash
set -e;

ELASTIC_HOST='localhost:9200'

function elastic_schema_drop(){ docker-compose run -T --rm schema node scripts/drop_index "$@" || true; }
function elastic_schema_create(){ docker-compose run -T --rm schema npm run create_index; }
function elastic_start(){ docker-compose up -d elasticsearch; }
function elastic_stop(){ docker-compose kill elasticsearch; }

register 'elasticsearch' 'drop' 'delete elasticsearch index & all data' elastic_schema_drop
register 'elasticsearch' 'create' 'create elasticsearch index with pelias mapping' elastic_schema_create
register 'elasticsearch' 'start' 'start elasticsearch server' elastic_start
register 'elasticsearch' 'stop' 'stop elasticsearch server' elastic_stop

# to use this function:
# if test $(elastic_status) -ne 200; then
function elastic_status(){ curl --output /dev/null --silent --write-out "%{http_code}" "http://${ELASTIC_HOST}" || true; }

register 'elasticsearch' 'status' 'HTTP status code of the elasticsearch service' elastic_status

function elastic_wait(){
  echo 'waiting for elasticsearch service to come up';
  until test $(elastic_status) -eq 200; do
    printf '.'
    sleep 2
  done
  echo
}

register 'elasticsearch' 'wait' 'wait for elasticsearch to start up' elastic_wait
