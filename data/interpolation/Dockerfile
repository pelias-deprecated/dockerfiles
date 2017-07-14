# base image
FROM pelias/baseimage

# dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && \
    apt-get install -y autoconf automake libtool pkg-config python sqlite3 gdal-bin&& \
    rm -rf /var/lib/apt/lists/*

# install libpostal
RUN git clone https://github.com/openvenues/libpostal /code/libpostal
WORKDIR /code/libpostal
RUN ./bootstrap.sh && \
    ./configure --datadir=/usr/share/libpostal && \
    make && make check && make install && \
    ldconfig

# clone app
RUN git clone https://github.com/pelias/interpolation.git /code/pelias/interpolation

# change working dir
WORKDIR /code/pelias/interpolation

# Install app dependencies
RUN npm install

# run tests
RUN npm test

# set entry point
ENTRYPOINT [ "./interpolate" ]

CMD [ "server", "/data/address.db", "/data/street.db" ]