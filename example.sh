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

export DATA_DIR='/media/black/data'

function trimWofById() {
  sudo chown -R "$USER:$USER" "$DATA_DIR"
  find "$DATA_DIR/whosonfirst/data" -type f -name '*.geojson' -print0 | xargs --null grep -Z -L "$1" | xargs --null rm
  find "$DATA_DIR/whosonfirst/meta" -type f -name '*.csv' | xargs sed -i "/\($1\|cessation\)/!d"
}

function valhallaBuildTiles() {
  docker-compose run --rm valhalla bash -c \
    'valhalla_build_tiles -c valhalla.json /data/openstreetmap/extract.osm.pbf'
}

function valhallaExportEdges() {
  docker-compose run --rm valhalla bash -c \
    'valhalla_export_edges --config valhalla.json > /data/polyline/extract.0sv'
}

function downloadPolylines() {
  wget -O- "$1" | gunzip > "$DATA_DIR/polyline/extract.0sv"
}

function downloadPBFExtract() {
  wget -O- "$1" > "$DATA_DIR/openstreetmap/extract.osm.pbf"
}

# ensure data dirs exists
mkdir -p "$DATA_DIR/elasticsearch" \
         "$DATA_DIR/whosonfirst" \
         "$DATA_DIR/polyline" \
         "$DATA_DIR/openstreetmap" \
         "$DATA_DIR/valhalla";

# run build scripts
. build.sh;

# create index
docker-compose run --rm schema bash -c 'node scripts/create_index.js'

# import whosonfirst
# trimWofById '85633111'; # delete wof records not referring to germany
docker-compose run --rm whosonfirst bash -c 'npm start'

# import polylines
# downloadPolylines 'http://missinglink.files.s3.amazonaws.com/berlin.gz';
# valhallaBuildTiles;
# valhallaExportEdges;
docker-compose run --rm polylines bash -c 'npm start'

# import openstreetmap
# downloadPBFExtract 'https://s3.amazonaws.com/metro-extracts.mapzen.com/berlin_germany.osm.pbf';
docker-compose run --rm openstreetmap bash -c '\
  sed -i "/addr/d" config/features.js; \
  sed -i "/addressExtractor/d" stream/importPipeline.js; \
  npm start'

# import geonames
# docker-compose run --rm geonames bash -c 'npm start'
