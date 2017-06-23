# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/openaddresses.git /code/pelias/openaddresses

# change working dir
WORKDIR /code/pelias/openaddresses

# install npm dependencies
RUN npm install

# update dbclient 'elasticsearch' dependency to support es@5
# @todo: fix and remove this
WORKDIR /code/pelias/openaddresses/node_modules/pelias-dbclient
RUN npm install elasticsearch@latest
WORKDIR /code/pelias/openaddresses

# run tests
RUN npm test
