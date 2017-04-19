#!/bin/bash

# bring containers down
# note: the -v flag deletes ALL persistent data volumes
docker-compose down || true;

# delete persistent volumes
docker volume rm 'dockerfiles_esdata';

# rebuild the images
docker-compose build;

# start the containers
# note: the -d flag will background the logs
docker-compose up -d;

# wait for elasticsearch to start up
echo 'waiting for elasticsearch service to come up';
until $(curl --output /dev/null --silent --head --fail http://localhost:9200); do
  printf '.'
  sleep 2
done

# put pelias config / mappings to cluster
docker-compose run --rm schema bash -c 'node scripts/create_index.js';

# import geonames
docker-compose run --rm geonames bash -c 'npm run download && npm start';
