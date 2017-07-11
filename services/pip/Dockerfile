# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y bzip2 && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/pip-service.git /code/pelias/pip-service

# change working dir
WORKDIR /code/pelias/pip-service

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# start the pip service using the directory the data was downloaded to
CMD ["npm", "start", "--", "/data/whosonfirst"]
