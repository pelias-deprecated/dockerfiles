# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
# RUN apt-get update && apt-get install -y bzip2 && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/document-service.git /code/pelias/document-service

# change working dir
WORKDIR /code/pelias/document-service

# consume the build variables
ARG REVISION=production

# switch to desired revision
RUN git checkout $REVISION

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# start the document-service using the directory the data was downloaded to
CMD ["npm", "start", "--", "/data/whosonfirst"]
