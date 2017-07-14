# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/schema.git /code/pelias/schema

# change working dir
WORKDIR /code/pelias/schema

# consume the build variables
ARG REVISION=production

# switch to desired revision
RUN git checkout $REVISION

# install npm dependencies
RUN npm install

# run tests
RUN npm test
