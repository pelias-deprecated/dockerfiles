# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/placeholder.git /code/pelias/placeholder

# change working dir
WORKDIR /code/pelias/placeholder

# configure directories
RUN mkdir -p '/data/placeholder'
RUN mkdir -p './data'

ENV WOF_DIR '/data/whosonfirst/data/'

# install npm dependencies
RUN npm install

CMD [ "/bin/bash", "-c", "bash cmd/wof_extract.sh > data/wof.extract; npm run build; mkdir -p /data/placeholder;  mv data/* /data/placeholder/;" ]