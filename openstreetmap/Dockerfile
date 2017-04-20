# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/openstreetmap.git /code/pelias/openstreetmap

# change working dir
WORKDIR /code/pelias/openstreetmap

# install npm dependencies
RUN npm install

# update dbclient 'elasticsearch' dependency to support es@5
# @todo: fix and remove this
WORKDIR /code/pelias/openstreetmap/node_modules/pelias-dbclient
RUN npm install elasticsearch@latest
WORKDIR /code/pelias/openstreetmap

# run tests
RUN npm test
