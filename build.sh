#!/bin/bash
[ -z "$DATA_DIR" ] && echo "env var DATA_DIR not set" && exit 1;

# bring containers down
# note: the -v flag deletes ALL persistent data volumes
docker-compose down || true;

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
