#!/bin/bash
set -e;

# per-source prepares
function prepare_polylines(){ docker-compose run -T --rm polylines bash ./docker_extract.sh; }
function prepare_interpolation(){ docker-compose run -T --rm interpolation bash ./docker_build.sh; }
function prepare_placeholder(){
  docker-compose run -T --rm placeholder npm run extract
  docker-compose run -T --rm placeholder npm run build
}

register 'prepare' 'polylines' 'export road network from openstreetmap into polylines format' prepare_polylines
register 'prepare' 'interpolation' 'build interpolation sqlite databases' prepare_interpolation
register 'prepare' 'placeholder' 'build placeholder sqlite databases' prepare_placeholder

# prepare all the data to be used by imports
function prepare_all(){
  prepare_polylines &
  prepare_placeholder &
  wait
}

register 'prepare' 'all' 'build all services which have a prepare step' prepare_all
