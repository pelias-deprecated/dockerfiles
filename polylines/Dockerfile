# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/polylines.git /code/pelias/polylines

# change working dir
WORKDIR /code/pelias/polylines

# install npm dependencies
RUN npm install

# update dbclient 'elasticsearch' dependency to support es@5
# @todo: fix and remove this
WORKDIR /code/pelias/polylines/node_modules/pelias-dbclient
RUN npm install elasticsearch@latest
WORKDIR /code/pelias/polylines

# run tests
RUN npm test
