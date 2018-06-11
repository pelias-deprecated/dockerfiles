
# Portland Metro Area

This project is configured to download/prepare/build a complete Pelias installation for Portland, Oregon.

It is intended as an example for other projects, feel free to copy->paste these files to a new project directory to kick-start your own project.

# Prerequisites

You will need to have `docker` and `docker-compose` installed before continuing.

If you are running OSX, you should also install `brew install coreutils`.

The scripts will download several GB of geographic data, so ensure you have enough free disk space.

# Installing the Pelias Command

If you haven't done so already, you will need to ensure the `pelias` command is available on your path.

You can find the `pelias` file in the root of the https://github.com/pelias/dockerfiles repository.

Advanced users may have a preferance how this is done on their system, but a basic example would be to do something like:

```bash
git clone https://github.com/pelias/dockerfiles.git ~
ln -s ~/dockerfiles/pelias /usr/local/bin/pelias
```

once the command is correctly installed you should be able to run the following command to confim the pelias command is available on your path:

```bash
which pelias
```

# Configure Environment

The `pelias` command looks for an `.env` file in your current working directory, this file contains information specific to your local environment.

Ensure that your current working directory contains the files: `.env`, `docker-compose.yml` and `pelias.json` before continuing.

The only variable you will need to change in `.env` is: `DATA_DIR=/example/path`.

This path reflects the directory Pelias will use to store downloaded data and use to build it's other microservices.

Create a new directory which you will use for this project, for example:

```bash
mkdir /tmp/pelias
```

Then use your text editor to modify the `.env` file to reflect your new path, it should look like this:

```bash
COMPOSE_PROJECT_NAME=dockerfiles
COMPOSE_FILE=docker-compose.yml
DATA_DIR=/tmp/pelias
```

# Usage

You can now execute the `pelias` command directly to view a list of available actions:

```bash
pelias
```

# Run a Build

To run a complete build, execute the following commands:

```bash
pelias compose pull
pelias elastic start
pelias elastic wait
pelias elastic create
pelias download all
pelias prepare all
pelias import all
pelias compose up
```

# View Status of Running Containers

Once the build is complete, you can view the current status and port mappings of the Pelias docker containers:

```bash
pelias compose ps
```

You can also inspect the container logs for errors:

```bash
pelias compose logs
```

# Make an Example Query

You can now make queries against your new Pelias build:

http://localhost:4000/v1/search?text=pdx
