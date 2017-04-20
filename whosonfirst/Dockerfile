# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/whosonfirst.git /code/pelias/whosonfirst

# change working dir
WORKDIR /code/pelias/whosonfirst

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# copy pelias config
ADD 'pelias.json' '/code/pelias.json'
