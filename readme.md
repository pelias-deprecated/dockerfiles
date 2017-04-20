
dockerfiles for pelias services

detailed installation instructions can be found here: https://github.com/pelias/pelias/blob/master/INSTALL.md

### prerequisites

```
docker: min version xxx
docker-compose: min version xxx
```

### getting up and running

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

### setting up elasticsearch

the following command will install the pelias schema in elasticsearch:

```bash
docker-compose run --rm schema bash -c 'node scripts/create_index.js'
```

you can confirm this worked correctly by visiting http://localhost:9200/pelias/_mapping

### checking the api service is running

the api service should already be running on port 4000.

you can confirm this worked correctly by visiting http://localhost:4000/v1/search?text=example

### importing geonames

#### configuring your geonames import

each directory in this repository contains a `pelias.json` file which can be used to configure & customize your build.

for example, to import Singapore with `adminLookup` disabled you could edit the `imports` section to look like:

```javascript
"imports": {
  "adminLookup": {
    "enabled": false
  },
  "geonames": {
    "datapath": "./data",
    "countryCode": "SG"
  }
}
```

#### running the import

the following command will download & import geonames data:

```bash
docker-compose run geonames bash -c 'npm run download && npm start'
```
