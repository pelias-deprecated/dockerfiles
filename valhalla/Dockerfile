# base image
FROM pelias/baseimage

# grab all of the valhalla software from ppa
RUN apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository -y ppa:kevinkreiser/prime-server && \
    add-apt-repository -y ppa:valhalla-routing/valhalla && \
    apt-get update && \
    apt-get install -y valhalla-bin && \
    rm -rf /var/lib/apt/lists/*;

# change working dir
WORKDIR /code/pelias/valhalla

# generate config
RUN valhalla_build_config \
  --mjolnir-tile-dir "/data/valhalla" \
  --mjolnir-tile-extract "/data/valhalla.tar" \
  --mjolnir-timezone "/data/valhalla/timezones.sqlite" \
  --mjolnir-admin "/data/valhalla/admins.sqlite" > valhalla.json

# run server
# CMD [ "valhalla_route_service", "valhalla.json", "1" ]
