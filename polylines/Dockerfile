# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/polylines.git /code/pelias/polylines

# change working dir
WORKDIR /code/pelias/polylines

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# copy pelias config
ADD 'pelias.json' '/code/pelias.json'
