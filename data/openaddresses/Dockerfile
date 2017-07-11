# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/openaddresses.git /code/pelias/openaddresses

# change working dir
WORKDIR /code/pelias/openaddresses

# TBD: remove this once it's published to npm
RUN git checkout filtered-download

# install npm dependencies
RUN npm install
