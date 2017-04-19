# base image
FROM ubuntu:latest

# build variables
ENV NODE_VERSION='4.4.7'

# configure env
ENV DEBIAN_FRONTEND 'noninteractive'

# update apt, install core apt dependencies and delete the apt-cache
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && \
    apt-get install -y locales iputils-ping curl wget git-core && \
    rm -rf /var/lib/apt/lists/*

# configure locale
RUN locale-gen 'en_US.UTF-8'
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'
ENV LC_ALL 'en_US.UTF-8'

# configure directories
RUN mkdir -p '/code/pelias'

# configure volumes
VOLUME "/data"

# configure git
RUN git config --global 'user.email' 'pelias@mapzen.com'
RUN git config --global 'user.name' 'Pelias Docker'

# install nodejs
RUN git clone 'https://github.com/isaacs/nave.git' /code/nave && /code/nave/nave.sh 'usemain' "${NODE_VERSION}" && rm -rf /code/nave

# add global install dir to $NODE_PATH
ENV NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

# copy pelias config
ADD 'pelias.json' '/code/pelias.json'
ENV PELIAS_CONFIG '/code/pelias.json'
