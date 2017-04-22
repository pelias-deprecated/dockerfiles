#!/bin/bash
export DATA_DIR='/media/black/data'

function trimWofById() {
  sudo chown -R "$USER:$USER" "$DATA_DIR"
  find "$DATA_DIR/whosonfirst/data" -type f -name '*.geojson' -print0 | xargs --null grep -Z -L "$1" | xargs --null rm
  find "$DATA_DIR/whosonfirst/meta" -type f -name '*.csv' | xargs sed -i "/\($1\|cessation\)/!d"
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
         "$DATA_DIR/openstreetmap";

# run build scripts
. build.sh;

# create index
docker-compose run --rm schema bash -c 'node scripts/create_index.js'

# import whosonfirst
# trimWofById '85633111'; # delete wof records not referring to germany
docker-compose run --rm whosonfirst bash -c 'npm start'

# import polylines
# downloadPolylines 'http://missinglink.files.s3.amazonaws.com/berlin.gz';
docker-compose run --rm polylines bash -c 'npm start'

# import openstreetmap
# downloadPBFExtract 'https://s3.amazonaws.com/metro-extracts.mapzen.com/berlin_germany.osm.pbf';
docker-compose run --rm openstreetmap bash -c '\
  sed -i "/addr/d" config/features.js; \
  sed -i "/addressExtractor/d" stream/importPipeline.js; \
  npm start'

# import geonames
# docker-compose run --rm geonames bash -c 'npm start'
