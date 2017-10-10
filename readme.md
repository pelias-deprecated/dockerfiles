
Dockerfiles for [Pelias](https://github.com/pelias/pelias) services

## Step-by-step Guide

Check out a [self-contained workshop](how_to_guide.pdf) that explains all the moving parts that make up the Pelias geocoding engine
and then shows you how to setup a geocoder for a single city or county right on your own machine.

- [Growing Pelias in Containers](how_to_guide.pdf)

### Prerequisites
1. Docker version `1.10.1` or later.

1. A directory for storing downloaded datasets. Set `DATA_DIR` to the folder's path in `.env` file.

1. **OSX Only**
    1. In Docker > Preferences > Advanced, set the CPU to `4` and memory to `12 GB`. This ensures that Docker has enough memory to run the imports and API.

#### Create a Directory for Your Data

Each of the containers will be able to access this directory internally as `/data`, source data downloaded by the containers will be stored here.

> note: the data can be fairly large, make sure you have at minimum ~15GB free space available on this volume

```bash
mkdir -p /tmp/data
```

If you wish to change the location of your data directory you can simply change the `DATA_DIR` environment variable.

Each importer and service has a range of different options, detailed installation and configuration instructions can be found here: https://github.com/pelias/pelias/blob/master/INSTALL.md
For an up-to-date references of supported options you can also view the README files contained in each repository on Github.

## Getting Up and Running

First you'll need to create (or edit) the provided `pelias.json` file at the root of the repository.
This is where you will specify all the details of your desired Pelias instance, such as area of coverage and data sources.
You can reference the individual data sections below for more details on configuration.

Once that's ready, the following command will build all the images and containers required:

> NOTE: this command can take several hours depending on your network, hardware, and the size of the region of coverage selected in pelias.json.

```bash
./build.sh
```

once the process is complete you can list the running services:

```bash
$ docker-compose ps
        Name                   Command           State                 Ports               
------------------------------------------------------------------------------------------
pelias_api             npm start                 Up       0.0.0.0:4000->4000/tcp           
pelias_baseimage       /bin/bash                 Exit 0                                    
pelias_elasticsearch   /bin/bash bin/es-docker   Up       0.0.0.0:9200->9200/tcp, 9300/tcp
pelias_geonames        /bin/bash                 Exit 0
pelias_interpolation   npm start                 Up       0.0.0.0:4300->4300/tcp
pelias_openaddresses   /bin/bash                 Exit 0                                    
pelias_openstreetmap   /bin/bash                 Exit 0
pelias_pip             npm start                 Up       0.0.0.0:4200->4200/tcp
pelias_placeholder     npm start                 Up       0.0.0.0:4100->4100/tcp           
pelias_polylines       /bin/bash                 Exit 0                                    
pelias_schema          /bin/bash                 Exit 0                                    
pelias_whosonfirst     /bin/bash                 Exit 0
```

## Checking that Services are Running
All the services should be up and running after the build script completes. The ports on which the services run should match
the configuration in `docker-compose.yml`. You can confirm this worked correctly by visiting each one at the corresponding URLs.

### API
http://localhost:4000/v1/search?text=portland
http://localhost:4000/v1/search?text=1901 Main St
http://localhost:4000/v1/reverse?point.lon=-122.650095&point.lat=45.533467

### Placeholder
http://localhost:4100/demo/#eng

### PIP (point in polygon)
http://localhost:4200/-122.650095/45.533467

### Interpolation
http://localhost:4300/demo/#13/45.5465/-122.6351


## Data Download and Import

There is a script that is actually used in the `build.sh` script but can also be executed independently to update the data
and rebuild the ES index and other databases.

*Note: if you are going to run it independently, it's important to make sure the docker containers have already been built.
This script will also shut down any running services to avoid conflicts during imports.*

It is ***VERY VERY*** strongly recommended that you use the `pelias.json` config file to limit the data downloads to a region
no larger than a region (state in US). There is too much data in larger regions for a single machine to handle. Also keep in mind
that the amount of time a download and import will take is directly correlated with the size of the area of coverage.

For TIGER data, use `imports.interpolation.download.tiger[]` (see [interpolation repo doc](https://github.com/pelias/interpolation#running-a-build-in-the-docker-container))

```bash
mdkir -p /tmp/data
export DATA_DIR=/tmp/data
sh ./prep_data.sh
```

### Individual Data Sources

#### Who's on First

*note: this guide only covers importing the admin areas (like cities, countries etc.)*

##### configuration
For WOF data, use `imports.whosonfirst.importPlace` (see [whosonfirst repo doc](https://github.com/pelias/whosonfirst#configuration))

```javascript
"imports": {
  "whosonfirst": {
    "datapath": "/data/whosonfirst",
    "importVenues": false,
    "importPostalcodes": true,
    "importPlace": "101715829",
    "api_key": "your-mapzen-api-key"
  }
}
```

##### download

```bash
docker-compose run --rm whosonfirst npm run download
```

##### import

```bash
docker-compose run --rm whosonfirst bash -c 'npm start'
```

#### OpenAddresses

##### configuration
For OA data, use `imports.openaddresses.files` (see [openaddresses repo doc](https://github.com/pelias/openaddresses#configuration))

```javascript
"imports": {
  "openaddresses": {
    "datapath": "/data/openaddresses",
    "files": [ "us/or/portland_metro.csv" ]
  }
}
```

##### download
```bash
docker-compose run --rm openaddresses npm run download
```

##### import
```bash
docker-compose run --rm openaddresses npm start
```

#### OpenStreetMap

Any `osm.pbf` file will work. A good source is [Metro Extracts](https://mapzen.com/data/metro-extracts/), which has
major cities and custom areas. Download and place the file in the data directory above.

##### configuration
Once you find a URL from which you can consistently download the data, specify it in the configuration file and
the download script will pull it down for you.

For OSM data, use `imports.openstreetmap.download[]` (see [openstreetmap repo doc](https://github.com/pelias/openstreetmap#configuration))

```javascript
"imports": {
  "openstreetmap": {
    "download": [
      {
        "sourceURL": "https://s3.amazonaws.com/metro-extracts.mapzen.com/portland_oregon.osm.pbf"
      }
    ],
    ...
  }
}
```

###### download

Using the download script in the container:

```bash
docker-compose run --rm openstreetmap npm run download
```

Or, download the data by other means such as `wget` (example for Singapore):

```bash
wget -qO- https://s3.amazonaws.com/metro-extracts.mapzen.com/singapore.osm.pbf > /tmp/data/openstreetmap/extract.osm.pbf
```

##### import

```bash
docker-compose run --rm openstreetmap npm start
```

#### Geonames

##### configuration

You can restrict the downloader to a single country by adding a `countryCode` property in your `pelias.json`:

```javascript
"imports": {
  "geonames": {
    ...
    "countryCode": "SG"
  }
}
```

##### download

```bash
docker-compose run --rm geonames npm run download
```

#### import

```bash
docker-compose run --rm geonames npm start
```

## Polylines

##### configuration

```javascript
"imports": {
  "polyline": {
    "datapath": "/data/polylines",
    "files": ["pbf_extract.polyline"]
  }
}
```

##### download
The extract of the polylines is done using the OSM pbf file so that must be downloaded first. See OpenStreetMap section for details on that.
Once the pbf extract is in place, run the following command.

```bash
docker-compose run --rm polylines sh ./docker_extract.sh
```

##### import

```bash
docker-compose run --rm polylines npm run start
```

## Setting Up Elasticsearch

This will take place as part of the build script, but in the case you'd like to manually manipulate the schema,
the following command will install the pelias schema in elasticsearch:

```bash
docker-compose run --rm schema bash -c 'node scripts/create_index.js'
```

You can confirm this worked correctly by visiting http://localhost:9200/pelias/_mapping


## Shutting Down and Restarting
To stop all the containers, `docker-compose down`.

Restart all the containers with `docker-compose up` or `sh ./run_services.sh`.

## Saving docker images as tar files

Docker images can be saved for offline use with the following command:

```bash
docker images --filter 'reference=pelias/*:latest' --format '{{.Repository}}' | parallel --no-notice docker save -o '{/.}.tar' {}
```
