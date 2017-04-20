# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/openaddresses.git /code/pelias/openaddresses

# change working dir
WORKDIR /code/pelias/openaddresses

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# copy pelias config
ADD 'pelias.json' '/code/pelias.json'
