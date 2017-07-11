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

# clone repo
RUN git clone https://github.com/pelias/api.git /code/pelias/api

# change working dir
WORKDIR /code/pelias/api

# npm apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y python && rm -rf /var/lib/apt/lists/*

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# start service
CMD [ "npm", "start" ]
