# base image
FROM pelias/baseimage

# grab all of the valhalla software from ppa
RUN apt-get update && apt-get install -y golang-go && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/polylines.git /code/pelias/polylines

# change working dir
WORKDIR /code/pelias/polylines

# configure go environment
ENV GOPATH $HOME/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# get go dependencies
RUN go get github.com/missinglink/pbf

# consume the build variables
ARG REVISION=production

# switch to desired revision
RUN git checkout $REVISION

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# add convenience script - used to extract the first available pbf file to 0sv
ADD docker_extract.sh /code/pelias/polylines/docker_extract.sh
