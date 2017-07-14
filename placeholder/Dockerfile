# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# clone repo
RUN git clone https://github.com/pelias/placeholder.git /code/pelias/placeholder

# change working dir
WORKDIR /code/pelias/placeholder

# consume the build variables
ARG REVISION=production

# switch to desired revision
RUN git checkout $REVISION

ENV WOF_DIR '/data/whosonfirst/data'
ENV PLACEHOLDER_DATA '/data/placeholder'

# install npm dependencies
RUN npm install

RUN export extract_file=${PLACEHOLDER_DATA}/wof.extract

CMD [ "npm", "start" ]
