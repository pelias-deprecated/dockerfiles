#!/bin/bash

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

# create the index in elasticsearch before importing data
docker-compose run --rm schema npm run create_index;

# download all the data to be used by imports
docker-compose run --rm whosonfirst_data npm run download &
docker-compose run --rm openaddresses_data npm run download &
docker-compose run --rm openstreetmap_data npm run download &

wait;

# polylines data prep requires openstreetmap data, so wait until that's done to start this
# but then wait to run the polylines importer process until this is finished
docker-compose run --rm polylines_data;


docker-compose run --rm whosonfirst_data npm start &
docker-compose run --rm openaddresses_data npm start &
docker-compose run --rm openstreetmap_data npm start &
docker-compose run --rm polylines_data npm start &
docker-compose run --rm placeholder_data &

wait;
