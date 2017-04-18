# base image
FROM pelias/baseimage

# clone repo
# RUN git clone https://github.com/pelias/schema.git /code/pelias/schema
RUN git clone https://github.com/cag/schema.git /code/pelias/schema

WORKDIR /code/pelias/schema
RUN git remote add upstream https://github.com/pelias/schema.git
RUN git pull upstream master

# change working dir
WORKDIR /code/pelias/schema

# install npm dependencies
RUN npm install

# run tests
# RUN npm test
