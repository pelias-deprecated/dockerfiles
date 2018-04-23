#!/bin/bash
set -e;

# per-source imports
function import_wof(){ docker-compose run -T --rm whosonfirst npm start; }
function import_oa(){ docker-compose run -T --rm openaddresses npm start; }
function import_osm(){ docker-compose run -T --rm openstreetmap npm start; }
function import_polylines(){ docker-compose run -T --rm polylines npm start; }
function import_transit(){ docker-compose run -T --rm transit npm start; }

register 'import' 'wof' '(re)import whosonfirst data' import_wof
register 'import' 'oa' '(re)import openaddresses data' import_oa
register 'import' 'osm' '(re)import openstreetmap data' import_osm
register 'import' 'polylines' '(re)import polylines data' import_polylines
register 'import' 'transit' '(re)import transit data' import_transit

# import all the data to be used by imports
# note: running these in parallel requires a large amount of RAM (so we dont)
function import_all(){
  import_wof
  import_oa
  import_osm
  import_polylines
  import_transit
}

register 'import' 'all' '(re)import all data' import_all
