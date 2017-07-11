# base image
FROM pelias/baseimage

VOLUME "/data"

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y bzip2 && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/whosonfirst.git /code/pelias/whosonfirst

# change working dir
WORKDIR /code/pelias/whosonfirst

RUN git checkout filtered-download

# install npm dependencies
RUN npm install

# run tests
RUN npm test
