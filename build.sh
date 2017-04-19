#!/bin/bash

# bring containers down
# note: the -v flag deletes persistent data volumes
docker-compose down -v || true;

# rebuild the images
docker-compose build;

# start the containers
# note: the -d flag will background the logs
docker-compose up -d;

# wait for elasticsearch to start up
echo 'waiting for elasticsearch service to come up...';
until $(curl --output /dev/null --silent --head --fail http://localhost:9200); do
  printf '.'
  sleep 2
done

# put pelias config / mappings to cluster
docker-compose run --rm schema node scripts/create_index.js;
