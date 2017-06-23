# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y bzip2 && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/whosonfirst.git /code/pelias/whosonfirst

# change working dir
WORKDIR /code/pelias/whosonfirst

# install npm dependencies
RUN npm install

# update dbclient 'elasticsearch' dependency to support es@5
# @todo: fix and remove this
WORKDIR /code/pelias/whosonfirst/node_modules/pelias-dbclient
RUN npm install elasticsearch@latest
WORKDIR /code/pelias/whosonfirst

# run tests
RUN npm test
