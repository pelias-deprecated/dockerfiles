# base image
FROM pelias/baseimage

# clone repo
RUN git clone https://github.com/pelias/placeholder.git /code/pelias/placeholder

# change working dir
WORKDIR /code/pelias/placeholder

# install npm dependencies
RUN npm install

# update source data
# RUN mkdir data && curl -s http://missinglink.geo.s3.amazonaws.com/ph.wof.extract.gz | gunzip > data/wof.extract

# generate a new build
RUN npm run build

# run tests
RUN npm test

# start service
CMD [ "npm", "start" ]
