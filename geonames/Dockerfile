# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/geonames.git /code/pelias/geonames

# change working dir
WORKDIR /code/pelias/geonames

# install npm dependencies
RUN npm install

# update metadata
RUN npm run download_metadata

# update dbclient 'elasticsearch' dependency to support es@5
# @todo: fix and remove this
WORKDIR /code/pelias/geonames/node_modules/pelias-dbclient
RUN npm install elasticsearch@latest
WORKDIR /code/pelias/geonames

# run tests
RUN npm test
