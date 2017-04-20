
dockerfiles for pelias services

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

### customizing your configuration

the `pelias.json` file in this repo is mounted inside each container at runtime, you can make modifications to the configuration file locally without the need for a rebuild.

for example, to import Geonames for Singapore with `adminLookup` disabled you could edit the `imports` section to look like:

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

each importer and service has a range of different options, detailed installation and configuration instructions can be found here: https://github.com/pelias/pelias/blob/master/INSTALL.md

for an up-to-date references of supported options you can also view the README files contained in each repository on Github.

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

the following command will download & import geonames data:

```bash
docker-compose run geonames bash -c 'npm run download && npm start'
```
