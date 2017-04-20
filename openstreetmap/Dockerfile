# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/openstreetmap.git /code/pelias/openstreetmap

# change working dir
WORKDIR /code/pelias/openstreetmap

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# copy pelias config
ADD 'pelias.json' '/code/pelias.json'
