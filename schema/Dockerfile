# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/schema.git /code/pelias/schema

# change working dir
WORKDIR /code/pelias/schema

# switch to custom branch
# @todo: use master branch once merged
RUN git checkout 'es5-compat'

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# copy pelias config
ADD 'pelias.json' '/code/pelias.json'
