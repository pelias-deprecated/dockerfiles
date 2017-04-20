#!/bin/bash

# run build scripts
. build.sh;

# create index
docker-compose run --rm schema bash -c 'node scripts/create_index.js'

# import whosonfirst
# docker-compose run --rm whosonfirst bash -c 'npm start'

# import openstreetmap
docker-compose run --rm openstreetmap bash -c 'npm start'

# import geonames
# docker-compose run --rm geonames bash -c 'npm start'
