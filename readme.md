
dockerfiles for pelias services

### prerequisites

```
docker: min version xxx
docker-compose: min version xxx
```

## getting up and running

the following command will build all the images and containers required:

> note: this command can take 15-20 minutes depending on your network and hardware.

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
pelias_openaddresses   /bin/bash                 Exit 0                                    
pelias_openstreetmap   /bin/bash                 Exit 0                                    
pelias_placeholder     npm start                 Up       0.0.0.0:4100->4100/tcp           
pelias_polylines       /bin/bash                 Exit 0                                    
pelias_schema          /bin/bash                 Exit 0                                    
pelias_whosonfirst     /bin/bash                 Exit 0
```

#### create a directory for your data

each of the containers will be able to access this directory internally as `/data`, source data downloaded by the containers will be stored here.

> note: the data can be fairly large, make sure you have at minimum ~15GB free space available on this volume

```bash
mkdir -p /tmp/data
```

if you wish to change the location of your data directory you can replace all instances of the path in your `docker-compose.yml`.

each importer and service has a range of different options, detailed installation and configuration instructions can be found here: https://github.com/pelias/pelias/blob/master/INSTALL.md

for an up-to-date references of supported options you can also view the README files contained in each repository on Github.

#### setting up elasticsearch

the following command will install the pelias schema in elasticsearch:

```bash
docker-compose run --rm schema bash -c 'node scripts/create_index.js'
```

you can confirm this worked correctly by visiting http://localhost:9200/pelias/_mapping

#### checking the api service is running

the api service should already be running on port 4000.

you can confirm this worked correctly by visiting http://localhost:4000/v1/search?text=example

## importing whosonfirst

> note: this guide only covers importing the admin areas (like cities, countries etc.)

#### downloading the data

ensure the data directory exists:

```bash
mkdir -p /tmp/data/whosonfirst
```

download the data:

```bash
docker-compose run --rm whosonfirst bash -c 'node download_data.js'
```

#### importing the data

import whosonfirst data:

```bash
docker-compose run --rm whosonfirst bash -c 'npm start'
```

## importing openstreetmap

#### downloading the data

ensure the data directory exists:

```bash
mkdir -p /tmp/data/openstreetmap
```

download the data:

```bash
wget -qO- https://s3.amazonaws.com/metro-extracts.mapzen.com/singapore.osm.pbf > /tmp/data/openstreetmap/extract.osm.pbf
```

#### importing the data

import openstreetmap data:

```bash
docker-compose run --rm openstreetmap bash -c 'npm start'
```

## importing geonames

#### customizing your configuration

you can restrict the downloader to a single country by adding a `countryCode` property in your `pelias.json`:

```javascript
"imports": {
  "geonames": {
    ...
    "countryCode": "SG"
  }
}
```

#### downloading the data

ensure the data directory exists:

```bash
mkdir -p /tmp/data/geonames
```

download the data:

```bash
docker-compose run --rm geonames bash -c 'npm run download'
```

#### importing the data

import geonames data:

```bash
docker-compose run --rm geonames bash -c 'npm start'
```
