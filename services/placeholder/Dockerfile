# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/placeholder.git /code/pelias/placeholder

# change working dir
WORKDIR /code/pelias/placeholder

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
