# base image
FROM pelias/libpostal_baseimage

# clone repo
RUN git clone https://github.com/pelias/api.git /code/pelias/api

# change working dir
WORKDIR /code/pelias/api

# consume the build variables
ARG REVISION=production

# switch to desired revision
RUN git checkout $REVISION

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# start service
CMD [ "npm", "start" ]
