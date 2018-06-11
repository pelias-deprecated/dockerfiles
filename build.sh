#!/bin/bash

# deprecation notice
2>&1 echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
2>&1 echo 'This repository has been deprecated in favour of https://github.com/pelias/docker';
2>&1 echo;
2>&1 echo 'We strongly recommended you to migrate any code referencing this repository';
2>&1 echo 'to use https://github.com/pelias/docker as soon as possible.'
2>&1 echo;
2>&1 echo 'You can find more information about why we deprecated this code along with a migration guide in the wiki:';
2>&1 echo 'https://github.com/pelias/dockerfiles/wiki/Deprecation-Notice';
2>&1 echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';

# bring containers down
# note: the -v flag deletes ALL persistent data volumes
docker-compose down || true;

# pull images from docker hub. Building them manually is not suggested in normal cases
docker-compose pull;

time sh ./prep_data.sh;

time sh ./run_services.sh;
