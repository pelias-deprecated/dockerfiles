#!/bin/bash
set -euo pipefail

# ensure data subdirectory exists
mkdir -p /data/polylines/;

# extract the first pbf file found in the osm directory
ls -1 /data/openstreetmap/*.osm.pbf | head -n1 | xargs pbf streets > /data/polylines/extract.0sv;

# debugging info
echo 'wrote polylines extract';
ls -lah /data/polylines/extract.0sv;
