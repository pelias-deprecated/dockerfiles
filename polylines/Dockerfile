# base image
FROM pelias/baseimage

# grab all of the valhalla software from ppa
RUN apt-get update && apt-get install -y golang-go && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/polylines.git /code/pelias/polylines

# change working dir
WORKDIR /code/pelias/polylines

ENV GOPATH $HOME/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN go get github.com/missinglink/pbf

# consume the build variables
ARG REVISION=production

# switch to desired revision
RUN git checkout $REVISION

# install npm dependencies
RUN npm install

# run tests
RUN npm test

# generate extract command
CMD [ "/bin/bash", "-c", "mkdir -p /data/polylines/ && ls /data/openstreetmap/*.osm.pbf | xargs pbf streets > /data/polylines/pbf_extract.polyline" ]