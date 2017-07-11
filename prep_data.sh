#!/bin/bash

# bring containers down
# note: the -v flag deletes ALL persistent data volumes
docker-compose down || true;

docker-compose up -d elasticsearch;

# wait for elasticsearch to start up
echo 'waiting for elasticsearch service to come up';
until $(curl --output /dev/null --silent --head --fail http://localhost:9200); do
  printf '.'
  sleep 2
done

docker-compose run --rm schema npm run create_index;

#docker-compose run --rm whosonfirst_data npm run download;
#docker-compose run --rm openaddresses_data npm run download;
docker-compose run --rm openstreetmap_data npm run download;

wait;

#docker-compose run --rm whosonfirst npm start &
#docker-compose run --rm openaddresses npm start &
docker-compose run --rm openstreetmap npm start &

# docker-compose up geonames &
# docker-compose up polylines &
# docker-compose up interpolation_import &

wait;