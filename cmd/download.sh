#!/bin/bash
set -e;

# per-source downloads
function download_wof(){ docker-compose run -T --rm whosonfirst npm run download; }
function download_oa(){ docker-compose run -T --rm openaddresses npm run download; }
function download_osm(){ docker-compose run -T --rm openstreetmap npm run download; }
function download_tiger(){ docker-compose run -T --rm interpolation npm run download-tiger; }
function download_transit(){ docker-compose run -T --rm transit npm run download; }

register 'download' 'wof' '(re)download whosonfirst data' download_wof
register 'download' 'oa' '(re)download openaddresses data' download_oa
register 'download' 'osm' '(re)download openstreetmap data' download_osm
register 'download' 'tiger' '(re)download TIGER data' download_tiger
register 'download' 'transit' '(re)download transit data' download_transit

# download all the data to be used by imports
function download_all(){
  download_wof &
  download_oa &
  download_osm &
  download_tiger &
  download_transit &
  wait
}

register 'download' 'all' '(re)download all data' download_all
