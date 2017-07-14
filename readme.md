
Dockerfiles for [Pelias](https://github.com/pelias/pelias) services

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

The following command will build all the images and containers required:

> NOTE: this command can take several hours depending on your network, hardware, and the size of the region of coverage selected in pelais.cofnig.

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

## Setting Up Elasticsearch

the following command will install the pelias schema in elasticsearch:

```bash
docker-compose run --rm schema bash -c 'node scripts/create_index.js'
```

you can confirm this worked correctly by visiting http://localhost:9200/pelias/_mapping

#### Checking that API Service is Running

the api service should already be running on port 4000.

you can confirm this worked correctly by visiting http://localhost:4000/v1/search?text=example

## Importing Whosonfirst

> note: this guide only covers importing the admin areas (like cities, countries etc.)

#### Downloading the Data (easy way)

There is a script that is actually used in the build.sh script but can also be executed independently to update the data
and rebuild the ES index and other databases.

Note: if you are going to run it independently, it's important to make sure the docker containers have already been built.

It is VERY VERY strongly recommended that you use the `pelias.json` config file to limit the data downloads to a region 
no larger than a region (state in US). There is too much data in larger regions for a single machine to handle. Also keep in mind
that the amount of time a download and import will take is directly correlated with the size of the area of coverage.
 
For OSM data, use `imports.openstreetmap.download[]` (see [openstreetmap repo doc](https://github.com/pelias/openstreetmap#configuration))

For OA data, use `imports.openaddresses.files` (see [openaddresses repo doc](https://github.com/pelias/openaddresses#configuration))

For WOF data, use `imports.whosonfirst.importPlace` (see [whosonfirst repo doc](https://github.com/pelias/whosonfirst#configuration))

For TIGER data, use `imports.interpolation.download.tiger[]` (see [interpolation repo doc](https://github.com/pelias/interpolation#running-a-build-in-the-docker-container))

```bash
mdkir -p /tmp/data
sh ./prep_data.sh
```

#### Downloading the Data Manually

ensure the data directory exists:

```bash
mkdir -p /tmp/data/whosonfirst
```

download the data:

```bash
docker-compose run --rm whosonfirst bash -c 'node download_data.js'
```

#### Importing the Data

import whosonfirst data:

```bash
docker-compose run --rm whosonfirst bash -c 'npm start'
```

## Importing OpenStreetMap

#### Downloading the Data

ensure the data directory exists:

```bash
mkdir -p /tmp/data/openstreetmap
```

Any `osm.pbf` file will work. A good source is [Metro Extracts](https://mapzen.com/data/metro-extracts/), which has major cities and custom areas. Download and place the file in the data directory above.

Or, download the data (for Singapore):

```bash
wget -qO- https://s3.amazonaws.com/metro-extracts.mapzen.com/singapore.osm.pbf > /tmp/data/openstreetmap/extract.osm.pbf
```

#### Importing the Data

import openstreetmap data:

```bash
docker-compose run --rm openstreetmap bash -c 'npm start'
```

## Importing Geonames

#### Customizing Your Configuration

you can restrict the downloader to a single country by adding a `countryCode` property in your `pelias.json`:

```javascript
"imports": {
  "geonames": {
    ...
    "countryCode": "SG"
  }
}
```

#### Downloading the Data

ensure the data directory exists:

```bash
mkdir -p /tmp/data/geonames
```

download the data:

```bash
docker-compose run --rm geonames bash -c 'npm run download'
```

#### Importing the Data

import geonames data:

```bash
docker-compose run --rm geonames bash -c 'npm start'
```
## Importing Polylines

#### Downloading the Data

ensure the data directory exists:

```bash
mkdir -p /tmp/data/polyline
```
download the data:

The Pelias/Polylines repo has some [polylines extracts](https://github.com/pelias/polylines#download-data). Once you have unzipped the file, specify the name of the polylines data file in your `pelias.json`

```javascript
"imports" : {
  "polyline": {
    ...
    "files": ["san_francisco.polylines"]
  }

}
```
#### Importing the Data
import polylines data:
```bash
docker-compose run --rm polylines bash -c 'PELIAS_CONFIG=/code/pelias.json npm start'
```

#### Shutting Down and Restarting
To stop all the containers, `docker-compose down`. Restart all the containers with `docker-compose up`.
