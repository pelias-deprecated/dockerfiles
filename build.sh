#!/bin/bash
[ -z "$DATA_DIR" ] && echo "env var DATA_DIR not set" && exit 1;

# bring containers down
# note: the -v flag deletes ALL persistent data volumes
docker-compose down || true;

# rebuild the images
docker-compose build;

time sh ./prep_data.sh;

time sh ./run_services.sh;
