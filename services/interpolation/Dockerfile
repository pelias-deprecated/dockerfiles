# base image
FROM pelias/baseimage

# libpostal apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && \
    apt-get install -y autoconf automake libtool pkg-config && \
    rm -rf /var/lib/apt/lists/*

# install libpostal
RUN git clone https://github.com/openvenues/libpostal /code/libpostal
WORKDIR /code/libpostal
RUN ./bootstrap.sh && \
    ./configure --datadir=/usr/share/libpostal && \
    make && make check && make install && \
    ldconfig

# dependencies
RUN apt-get update && \
    apt-get install -y python sqlite3 gdal-bin lftp && \
    rm -rf /var/lib/apt/lists/*

# --- pbf2json ---

# clone
RUN git clone https://github.com/pelias/pbf2json.git /code/pbf2json

# install
RUN chmod +x /code/pbf2json/build/pbf2json.linux-x64

ENV PBF2JSON_BIN /code/pbf2json/build/pbf2json.linux-x64

# location of the openstreetmap data
ENV PBF2JSON_FILE '/data/openstreetmap/portland_oregon.osm.pbf'

# location where the db files will be created
ENV BUILDDIR '/data/interpolation'

# location of the polyline data
ENV POLYLINE_FILE '/data/polylines/pbf_extract.polyline'

# location of the openaddresses data
ENV OAPATH '/data/openaddresses'

# location of TIGER data
ENV TIGERPATH '/data/tiger/'


# clone app
RUN git clone https://github.com/pelias/interpolation.git /code/pelias/interpolation

# change working dir
WORKDIR /code/pelias/interpolation

# Install app dependencies
RUN npm install

# run tests
RUN npm test

# set entry point
#ENTRYPOINT [ "./interpolate" ]
# to build run

CMD [ "server", "/data/address.db", "/data/street.db" ]