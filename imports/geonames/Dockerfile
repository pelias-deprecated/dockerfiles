# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/geonames.git /code/pelias/geonames

# change working dir
WORKDIR /code/pelias/geonames

# consume the build variables
ARG REVISION=production

# switch to desired revision
RUN git checkout $REVISION

# install npm dependencies
RUN npm install

# update metadata
RUN npm run download_metadata

# run tests
RUN npm test
