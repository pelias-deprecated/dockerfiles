#!/bin/bash
# bring containers down
# note: the -v flag deletes ALL persistent data volumes
docker-compose down || true;

# pull images from docker hub. Building them manually is not suggested in normal cases
docker-compose pull;

time sh ./prep_data.sh;

time sh ./run_services.sh;
