#!/bin/bash

# bring containers down
# note: the -v flag deletes ALL persistent data volumes
# docker-compose down || true;

# start the containers
# note: the -d flag will background the logs
docker-compose up -d;
