# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/schema.git /code/pelias/schema
WORKDIR /code/pelias/schema
RUN git checkout 'es5-compat'

# change working dir
WORKDIR /code/pelias/schema

# install npm dependencies
RUN npm install

# run tests
RUN npm test
