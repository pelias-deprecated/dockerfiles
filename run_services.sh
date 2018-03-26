#!/bin/bash

# load DATA_DIR and other vars from docker-compose .env file
export $(cat .env | xargs)

# start elasticsearch if it's not already running
if ! [ $(curl --output /dev/null --silent --head --fail http://localhost:9200) ]; then
    docker-compose up -d elasticsearch;

    # wait for elasticsearch to start up
    echo 'waiting for elasticsearch service to come up';
    until $(curl --output /dev/null --silent --head --fail http://localhost:9200); do
      printf '.'
      sleep 2
    done
fi

# assuming elasticsearch is already running

# start the containers
# note: the -d flag will background the logs
docker-compose up -d interpolation;
docker-compose up -d placeholder;
docker-compose up -d pip-service;
docker-compose up -d libpostal;
docker-compose up -d api;

