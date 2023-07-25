# RasDaMan [Raster Data Manager]
## Table of Contents
1. [Installation](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#installation-guide)
2. [Data Exploration](https://github.com/aghoshpro/myPhD/blob/main/RasDaMan/README.md#data-exploration)
3. [Google Group](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#google-group)
4. [Tutorial](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#tutorials)
5. [Working Examples](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#working-examples)
   * [NetCDF](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#netcdf-format)
   * [GeoTIFF](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#geotiff-format)
6. [RaSQL Quries](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#queries)
7. [RasdaPy](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#rasdapy3)
8. [WCPS Query](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#wcps-query)
9. [Usecase](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#usecase-sweden)
10. [Ontop Integration](https://github.com/aghoshpro/myPhD/tree/main/RasDaMan#ontop-integration)

## Installation  
* Source: https://doc.rasdaman.org/stable/02_inst-guide.html#installation-and-administration-guide

### 1. Open terminal in Ubuntu 22.04 LTS 

```
wget -O - https://download.rasdaman.org/packages/rasdaman.gpg | sudo apt-key add -
```

```
echo "deb [arch=amd64] https://download.rasdaman.org/packages/deb focal stable" | sudo tee /etc/apt/sources.list.d/rasdaman.list
```

```
sudo apt-get update
```

```
sudo apt-get install rasdaman
```

```
source /etc/profile.d/rasdaman.sh
```

### 2. Check if rasql is installed and set in path or not 
```
arkaghosh@lat7410g:~$ rasql -q 'select c from RAS_COLLECTIONNAMES as c' --out string
rasql: rasdaman query tool 10.0.5.
Opening database RASBASE at 127.0.0.1:7001... ok.
Executing retrieval query... ok.
Query result collection has 0 element(s):
rasql done
```

### 3. Check that petascope is initialized properly at [OGC Web Coverage Service Endpoint](http://localhost:8080/rasdaman/ows) 


### 4. Updating
```
sudo apt-get update
sudo service rasdaman stop
sudo apt-get install rasdaman
```
### 5. Status
```
service rasdaman start
service rasdaman stop
service rasdaman status
```
### 6. Pre-requisite install [for first time users]

1. Install Python 3.8 or more on Ubuntu 22.04
Install the required dependency for adding custom PPAs.

* ```sudo apt install software-properties-common -y```

Then proceed and add the deadsnakes PPA to the APT package manager sources list as below.

* ```sudo add-apt-repository ppa:deadsnakes/ppa```

Press Enter to continue. Now download Python 3.10 with the single command below.

* ```sudo apt install python3.10```

Verify the installation by checking the installed version.
* ```python3 --version```

2. install netcdf4 package
``` sudo pip3 install netCDF4```

### 7. Tips
1. **How to choose correct recipe**:  Time series recipes are generally used with 2D formats like geotiff.For netcdf we provide a general_coverage recipe.
2. Coverage's CRS is: OGC/0/AnsiDate@OGC/0/Index1D@EPSG/0/4326 which can be broken to these grid orders respectively: "ansi (datetime)":0, "i(level)":1, "lat":2, "long":3 in case 4D data
3. Calculate datetime values in netCDF file with the origin of Time CRS (http://www.opengis.net/def/crs/OGC/0/AnsiDate with origin: 1600-12-31T00:00:00Z)
4. for irregular axis (resolution is always 1).
5. rasql works on grid **index coordinates**, it doesn't know about **geo coordinates**. Ove has to use WCPS if one wants to address data with geo coordinates in user queries and get geo-referenced data out of rasdaman.[link](https://groups.google.com/g/rasdaman-users/c/_zM3ikFvOXw/m/Vga9hInhAwAJ)
6. **Polygon clipping ingestion recipe**: **rasdaman stores arrays, so the ingested area needs to be an array and not a polygon (polygons can be used to subset stored array data after).** If you have many such areas you could import them in separate coverages, as arrays having bbox = minimal bbox encompassing the polygon. Then you could update the areas inside the bbox, but outside of the polygon with some null value. [link](https://groups.google.com/g/rasdaman-users/c/0PuKivXMZxw/m/mrLQyMRIEgAJ)


## Data Exploration
### Datasets
1. [Air Temperature](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html)

### Check the metadata of data using [gdal](https://gdal.org/)
   * GeoTIFF
```
gdalinfo /home/arkaghosh/Downloads/RAS_DATA/MOD11A1.006_LST_Night_1km_doy2017001_aid0001.tif
```
   * netCDF
```
gdalinfo /home/arkaghosh/Downloads/RAS_DATA/air.mon.mean.v401.nc
```
## Google Group
1. [Rasdaman Google Help Group](https://groups.google.com/g/rasdaman-users/c/6RfopKXiapM/m/vyF5hrcCAgAJ)
2. [My Discussions](https://groups.google.com/d/msgid/rasdaman-users/10907293-5c82-4e8e-b3b3-dedb0dcdd515n%40googlegroups.com?utm_medium=email&utm_source=footer)

## Tutorials
1. [WCSTImport Guide](http://rasdaman.org/wiki/WCSTImportGuide)
2. [General Recipe for WCSTImport (NetCDF, PNG)](http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe)
3. [NetCDF in RaSdAmAn](http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe#Netcdf)

## Working Examples
### NetCDF Format
#### **DATA**: [/Datasets/udel.airt.precip/v401/air.mon.mean.v401.nc](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html) 
* **Temporal Resolution**: Monthly values for 1901/01 - 2014/12 (V4.01)
* **Spatial Coverage**: 0.5 degree latitude x 0.5 degree longitude | global grid (720x360) | 3D datacube (time x lat x long = 1380 x 720 x 360).

#### WCSTImport introduces two concepts:

* ```Recipe``` - A recipe is a class implementing the BaseRecipe that based on a set of parameters (ingredients) can import a set of files into WCS forming a well defined structure (image, regular timeseries, irregular timeseries etc). 4 types of recipe are as follows (General Recipe,Mosaic Map, Regular Timeseries, Irregular Timeseries)

* ```Ingredients``` - An ingredients file is a json file containing a set of parameters that define how the recipe should behave (e.g. the WCS endpoint, the CRS resolver etc are all ingredients). [List of ingredients](http://rasdaman.org/browser/applications/wcst_import/ingredients/possible_ingredients.json)

**NOTE** Its only input is an "**ingredient**" file telling everything about the import process that the utility needs to know. (On a side note, such ingredients files constitute an excellent [documentation](http://rasdaman.org/wiki/WCSTImportGuide).)

#### **Ingredient File (AIR_TEMP_RAS_X.json)**
```{
    "config": {
        "service_url": "http://localhost:8080/rasdaman/ows",
        "tmp_directory": "/tmp/",
        "mock": false,
        "automated": true,
        "track_files": false
    },
    "input": {
        "coverage_id":"AIR_TEMP_X",
        "paths": [
            "/home/arkaghosh/Downloads/RAS_DATA/air.mon.mean.v401.nc"
        ]
    },
    "recipe": {
        "name": "general_coverage",
        "options": {
            "coverage": {
                "crs": "OGC/0/AnsiDate@EPSG/0/4326",
                "metadata": {
                    "type": "xml",
                    "global": "auto"
                },
                "slicer": {
                    "type": "netcdf",
                    "pixelIsPoint": true,
                    "bands": [{
                        "name": "air",
                        "variable": "air",
                        "description": "Air Temperature",
                        "identifier": "air",
                        "nilvalue":"-9.96921e+36f"
                    }],
                    "axes": {
                        "ansi": {
                            "statements": "from datetime import datetime, timedelta",
                             "min": "(datetime(1900,1,1,0,0,0) + timedelta(hours=${netcdf:variable:time:min})).strftime(\"%Y-%m-%dT%H:%M\")",
                             "max": "(datetime(1900,1,1,0,0,0) + timedelta(hours=${netcdf:variable:time:max})).strftime(\"%Y-%m-%dT%H:%M\")",
                            "directPositions": "[(datetime(1900,1,1,0,0,0) + timedelta(hours=x)).strftime(\"%Y-%m-%dT%H:%M\") for x in ${netcdf:variable:time}]",
                            "gridOrder": 0,
                            "type": "ansidate",
                            "resolution": 1,
                            "irregular": true
                        },
                        "Long": {
                            "min": "${netcdf:variable:lon:min}",
                            "max": "${netcdf:variable:lon:max}",
                            "gridOrder": 2,
                            "resolution": "${netcdf:variable:lon:resolution}"
                        },
                        "Lat": {
                            "min": "${netcdf:variable:lat:min}",
                            "max": "${netcdf:variable:lat:max}",
                            "gridOrder": 1,
                            "resolution": "-${netcdf:variable:lat:resolution}"
                        }
                    }
                }
            },
            "tiling": "ALIGNED [0:0, 0:359, 0:719]" 
        }
    }
}
```
### Output [```241.82``` MB has expanded to ```1.43``` GB after successful ingestion in ```16.03``` seconds]
#### Output in terminal
```
arkaghosh@lat7410g:~$ wcst_import.sh /home/arkaghosh/Downloads/RASDAMAN_FINALE/AIR_TEMP_RAS_X.json
wcst_import.sh: rasdaman v10.0.5 build gf81f9b82
Collected first 1 files: ['/home/arkaghosh/Downloads/RAS_DATA/air.mon.mean.v401.nc']...
The recipe has been validated and is ready to run.
Recipe: general_coverage
Coverage: AIR_TEMP_X
WCS Service: http://localhost:8080/rasdaman/ows
Operation: INSERT
Subset Correction: False
Mocked: False
WMS Import: True
Import mode: Blocking
Analyzing file (1/1): /home/arkaghosh/Downloads/RAS_DATA/air.mon.mean.v401.nc ...
Elapsed time: 0.081 s.
All files have been analyzed. Please verify that the axis subsets of the first 1 files above are correct.
Slice 1: {Axis Subset: ansi("1900-01-01T00:00:00+00:00","2014-12-01T00:00:00+00:00") Lat(-90.00,90.00) Long(0.000,360.000) 
Data Provider: file:///home/arkaghosh/Downloads/RAS_DATA/air.mon.mean.v401.nc}

Progress: [------------------------------] 0/1 0.00% 
[2022-11-22 13:41:03] coverage 'AIR_TEMP_X' - 1/1 - file 'air.mon.mean.v401.nc' - grid domains [0:1379,0:359,0:719] of size 241.82 MB; Total time to ingest file 16.03 s @ 15.09 MB/s.
Progress: [##############################] 1/1 100.00% Done.

```
#### **Output Screenshot**
![Screenshot from 2022-11-22 13-49-12](https://user-images.githubusercontent.com/71174892/203321589-6abc0681-6488-4e83-a42c-96dd689cba33.png)

#### Output Endpoint

![image](https://user-images.githubusercontent.com/71174892/203323830-ead6e294-52f7-4cad-9c30-89a6ae24d023.png)

#### --------------------------- Database configuration ----------------------------

```
arkaghosh@lat7410g:~$ cd /opt/rasdaman/etc
arkaghosh@lat7410g:/opt/rasdaman/etc$ ls
log-client.conf  log-rasmgr.conf  log-server.conf  petascope.properties  rasmgr.conf  secore.properties
arkaghosh@lat7410g:/opt/rasdaman/etc$  nano petascope.properties 
```

#### Default configuration for all DBMS
```
spring.jpa.database=default
spring.jpa.hibernate.ddl-auto=none

spring.datasource.url=jdbc:postgresql://localhost:5432/petascopedb
spring.datasource.username=petauser
spring.datasource.password=7d6ccae381f94d5bab7bc4931ca0882d
spring.datasource.jdbc_jar_path=
```

### GeoTIFF Format
**Data**: [MOD11A1.006 Terra Land Surface Temperature and Emissivity Daily Global 1km](https://developers.google.com/earth-engine/datasets/catalog/MODIS_006_MOD11A1#bands)
Here I have ingested 3 MODIS Daily LST geotiff file each of size 334 MB. Each image has a spatial dimention of 43099 X 20757.

#### **Ingredient File (general_coverage_gdal_LST_Timeseries.json)**
```{
  "config": {
    "service_url": "http://localhost:8080/rasdaman/ows",
    "tmp_directory": "/tmp/",
    "crs_resolver": "http://localhost:8080/def/",
    "default_crs": "http://www.opengis.net/def/crs/EPSG/0/4326",
    "mock": false,
    "automated": true
  },
  "input": {
    "coverage_id": "LST_03_GeoTIFF",
    "paths": [
      "/home/arkaghosh/Downloads/RAS_DATA/MODIS/*.tif"
    ]
  },
  "recipe": {
    "name": "time_series_irregular",
    "options": {
      "time_parameter": {
        "filename": {
          "__comment__": "The regex has to contain groups of tokens, separated by parentheses. The group parameter specifies which regex group to use for retrieving the time value",
          "regex": "(.*)_(.*)_doy(.+?)_(.*)",
          "group": "3"
        },
        "datetime_format": "YYYYMMDD"
      },
      "time_crs": "http://localhost:8080/def/crs/OGC/0/AnsiDate",
      "tiling": "ALIGNED [0:*,0:43098, 0:20756]"
    }
  }
}

```
### Output [```1``` GB has expanded to ```10``` GB after successful ingestion in ```143.03``` seconds]
#### Output in terminal
```
arkaghosh@lat7410g:~$ wcst_import.sh /home/arkaghosh/Downloads/RASDAMAN_FINALE/general_coverage_gdal_LST_Timeseries.json
wcst_import.sh: rasdaman v10.1.3 build g47ad85de
Collected first 3 files: ['/home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170101_aid0001.tif', '/home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170115_aid0001.tif', '/home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170126_aid0001.tif']...
The recipe has been validated and is ready to run.
Recipe: time_series_irregular
Coverage: LST_03_GeoTIFF
WCS Service: http://localhost:8080/rasdaman/ows
Operation: INSERT
Subset Correction: False
Mocked: False
WMS Import: True
Import mode: Blocking
Track files: True
Analyzing file (1/3): /home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170101_aid0001.tif ...
Elapsed time: 0.001 s.
Analyzing file (2/3): /home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170115_aid0001.tif ...
Elapsed time: 0.001 s.
Analyzing file (3/3): /home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170126_aid0001.tif ...
Elapsed time: 0.001 s.
All files have been analyzed. Please verify that the axis subsets of the first 3 files above are correct.
Slice 1: {Axis Subset: ansi("2017-01-01T00:00:00+00:00") Lat(-84.658333325730799103,88.31666665873561) Lon(-179.15833331724446,179.999999983835549921) 
Data Provider: file:///home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170101_aid0001.tif}

Slice 2: {Axis Subset: ansi("2017-01-15T00:00:00+00:00") Lat(-84.658333325730799103,88.31666665873561) Lon(-179.15833331724446,179.999999983835549921) 
Data Provider: file:///home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170115_aid0001.tif}

Slice 3: {Axis Subset: ansi("2017-01-26T00:00:00+00:00") Lat(-84.658333325730799103,88.31666665873561) Lon(-179.15833331724446,179.999999983835549921) 
Data Provider: file:///home/arkaghosh/Downloads/RAS_DATA/MODIS/MOD11A1.006_LST_Night_1km_doy20170126_aid0001.tif}

Progress: [------------------------------] 0/1 0.00% 
[2023-02-17 21:24:43] coverage 'LST_03_GeoTIFF' - 1/3 - file 'MOD11A1.006_LST_Night_1km_doy20170101_aid0001.tif' - grid domains [0,0:20756,0:43098] of size 338.81 MB; Total time to ingest file 34.84 s @ 9.72 MB/s.
Progress: [------------------------------] 0/1 0.00% 
[2023-02-17 21:25:18] coverage 'LST_03_GeoTIFF' - 2/3 - file 'MOD11A1.006_LST_Night_1km_doy20170115_aid0001.tif' - grid domains [0,0:20756,0:43098] of size 361.2 MB; Total time to ingest file 35.31 s @ 10.23 MB/s.
Progress: [------------------------------] 0/1 0.00% 
[2023-02-17 21:25:53] coverage 'LST_03_GeoTIFF' - 3/3 - file 'MOD11A1.006_LST_Night_1km_doy20170126_aid0001.tif' - grid domains [0,0:20756,0:43098] of size 307.71 MB; Total time to ingest file 34.19 s @ 9.0 MB/s.
Progress: [##############################] 1/1 100.00% Done.
Recipe executed successfully
```
#### Output Screenshot
![image](https://user-images.githubusercontent.com/71174892/219706205-8a217e48-0afe-4cdc-aa3f-ca03e2d07bd4.png)

#### Output Endpoint
![image](https://user-images.githubusercontent.com/71174892/219706500-7e78936a-13b8-4085-b120-c1659db55962.png)

## Queries
[Query Language Guide](https://doc.rasdaman.org/stable/04_ql-guide.html#query-language-guide)

* **To check exiting db collection**
```
rasql -q 'select c from RAS_COLLECTIONNAMES as c' --out string
```
```
arkaghosh@lat7410g:~$ rasql -q 'select c from RAS_COLLECTIONNAMES as c' --out string
rasql: rasdaman query tool 10.0.5.
Opening database RASBASE at 127.0.0.1:7001... ok.
Executing retrieval query... ok.
Query result collection has 5 element(s):
  Result object 1: AIR_TEMP_02
  Result object 2: AIR_TEMP_01
  Result object 3: output1
  Result object 4: AIR_TEMP_03
  Result object 5: AIR_TEMP_X
rasql done.
```
* **To delete the collection**
```
rasql -q "drop collection test"       --user rasadmin --passwd rasadmin
```

* **Q1**
```
rasql -q "select sdom(c) from AIR_TEMP_X as c" --out string
```
```
rasql: rasdaman query tool 10.0.5.
Opening database RASBASE at 127.0.0.1:7001... ok.
Executing retrieval query... ok.
Query result collection has 1 element(s):
Result element 1: [0:1379,0:359,0:719]
rasql done
```
## **Rasdapy3**
* **Activate virtual environment**
```
arkaghosh@lat7410g:~$ cd Downloads/rasdapy3_dir
```
```
arkaghosh@lat7410g:~/Downloads/rasdapy3_dir$ ls
env_rasdaman  rasdapy.ipynb  Rasdapy-Query-Workflow.ipynb  rasdapy-tutorial.ipynb
```
```
arkaghosh@lat7410g:~/Downloads/rasdapy3_dir$ source env_rasdaman/bin/activate
```
```
(env_rasdaman) arkaghosh@lat7410g:~/Downloads/rasdapy3_dir$ jupyter notebook

```
* **Check all existing python versions** *
```
compgen -c python | sort -u | grep -v -- '-config$' | while read -r p; do
     printf "%-14s  " "$p"
     "$p" --version
done
```
```
python          Python 2.7.18
python2         Python 2.7.18
python2.7       Python 2.7.18
python3         Python 3.10.9
python3.10      Python 3.10.9
python3.11      Python 3.11.0
python3.8       Python 3.8.10
python3-futurize  0.18.2
python3-pasteurize  0.18.2
```

* **Changing pyhton3 version in Ubuntu**
```
arkag@arkag-VirtualBox:~$ sudo su
```
```
0. root@arkag-VirtualBox:/usr/bin# which python ==> /usr/bin/python

1. root@arkag-VirtualBox:~# cd /usr/bin/
2. root@arkag-VirtualBox:/usr/bin# ls -lrth python*
3. root@arkag-VirtualBox:/usr/bin# python --version ==> Python 2.7
4. root@arkag-VirtualBox:/usr/bin# unlink python
5. root@arkag-VirtualBox:/usr/bin# ln -s /usr/bin/python3.6 python
6. root@arkag-VirtualBox:/usr/bin# python --version ==> Python 3.8.
```
* **Output**

![Screenshot from 2022-12-13 16-50-27](https://user-images.githubusercontent.com/71174892/207380999-7d0d0de1-37aa-4bc0-9e3c-d873ce855221.png)

![Screenshot from 2023-01-12 22-51-16](https://user-images.githubusercontent.com/71174892/212136544-147f55c8-3c37-47cb-9c7b-7e25c9c4162b.png)


* **RQ1**
```
>>> sdom = query_executor.execute_read("select sdom(c) from AIR_TEMP_X as c")         
>>> print(sdom)
```
```
[0:1379,0:359,0:719]
```

* **RQ2**
```
select clip( c, polygon(( list of WKT points )) )
from coll as c
```

* **RQ3**
```
select clip( c, multipolygon((( list of WKT points )),(( list of WKT points ))...) )
from coll as c
```



## WCPS Query

* Source: https://mundi.rasdaman.com/demos/client_jupyter-notebook/index.html
* Important Links
* http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe

  i. http://rasdaman.org/search?q=WCPS+clip%28%29+polygon+coordinate&noquickjump=1&changeset=on&milestone=on&ticket=on&wiki=on
  ii. http://rasdaman.org/ticket/1692
  iii. http://rasdaman.org/ticket/1833
  iv. http://www.postgis.net/docs/ST_GeomFromText.html
1. WCPS Query 1
``` 
for c in (AIR_TEMP_X) return max(clip(c[ansi("2014-12-01T00:00:00.000Z")], MULTIPOLYGON(((-20.4270 131.6931, -28.4204 124.1895,-27.9944 139.4604, -26.3919 129.0015 )),(( -20.4270 131.6931, -19.9527 142.4268,-27.9944 139.4604, -21.8819 40.5151)) ) ))
```

2. WCPS clip() query POLYGON(long, lat) aacording to [CRS](https://www.w3.org/2015/spatial/wiki/Coordinate_Reference_Systems)
```
for c in (LST_03_GeoTIFF_FLIPPED) return encode(clip(c[ansi("2017-01-01T00:00:00.000Z")], POLYGON((35.960222969296694 66.62109374999999, 36.173356935221605 94.92187499999999, 5.003394345022173 94.30664062499999, 5.266007882805496 66.88476562499999,35.960222969296694 66.62109374999999)), "EPSG:4326"), "tiff")
```
[gis stock exchange](https://gis.stackexchange.com/questions/436101/polygon-coords-are-backwards)

3. WCPS Query MULTIPOLYGON(long, lat)
```
for c in (LST_03_GeoTIFF_FLIPPED) return encode(clip(c[ansi("2017-01-01T00:00:00.000Z")], MULTIPOLYGON(((-20.4270 131.6931, -28.4204 124.1895,-27.9944 139.4604, -26.3919 129.0015 )),((-20.4270 131.6931, -19.9527 142.4268,-27.9944 139.4604, -21.8819 40.5151))), "EPSG:4326"), "tiff")
```
# Usecase: Sweden 
## Integration of Vector Data (PostgreSQL) & Raster Data (RasDaMan)
### Vector Data
1. [GADM data (version 4.1)](https://gadm.org/download_country.html)
#### Ingestion into PostgreSQL
```
$ shp2pgsql -s 4326 /home/arkaghosh/Downloads/RASDAMAN_FINALE/Worked/Sweden/SWE_adm/SWE_adm2 municipalswe | psql -h localhost -p 5432 -U postgres -d Sweden 
```
### Raster Data
1. [Surface Temperature](http://dx.doi.org/10.5067/MODIS/MOD11A1.061)
2. [Snow Cover](http://dx.doi.org/10.5067/MODIS/MOD10A1.006)
3. [Elevation](https://land.copernicus.eu/imagery-in-situ/eu-dem/eu-dem-v1.1?tab=metadata)

One can use [Application for Extracting and Exploring Analysis Ready Samples (AρρEEARS)](https://appeears.earthdatacloud.nasa.gov/) to subset the temperature and snow data according to the boundaries of Sweden and fetch the raster data as netcdf or geotiff.

#### Metadata using ```gdalinfo```
```
gdalinfo /home/arkaghosh/Downloads/RASDAMAN_FINALE/Worked/Sweden/surface_temp.nc
```
#### Ingestion into Rasdaman 
* Ingredient File (AIR_TEMP_RAS_X.json
```
{
    "config": {
        "service_url": "http://localhost:8080/rasdaman/ows",
        "tmp_directory": "/tmp/",
        "mock": false,
        "automated": true,
        "track_files": false
    },
    "input": {
        "coverage_id":"Surface_Temperature_Sweden",
        "paths": [
            "/home/arkaghosh/Downloads/RASDAMAN_FINALE/Worked/Sweden/MOD11A1.061_1km_aid0001.nc"
        ]
    },
    "recipe": {
        "name": "general_coverage",
        "options": {
            "coverage": {
                "crs": "OGC/0/AnsiDate@EPSG/0/4326",
                "metadata": {
                    "type": "xml",
                    "global": "auto"
                },
                "slicer": {
                    "type": "netcdf",
                    "pixelIsPoint": true,
                    "bands": [{
                        "name": "LST_Night_1km",
                        "variable": "LST_Night_1km",
                        "description": "Daily Snow Cover over Sweden from April, 2022 to April, 2023",
                        "identifier": "LST_Night_1km",
                        "nilvalue":"0"
                    }],
                    "axes": {
                        "ansi": {
                            "statements": "from datetime import datetime, timedelta",
                            "min": "(datetime(2000,1,1,0,0,0) + timedelta(days=${netcdf:variable:time:min})).strftime(\"%Y-%m-%dT%H:%M\")",
                            "max": "(datetime(2000,1,1,0,0,0) + timedelta(days=${netcdf:variable:time:max})).strftime(\"%Y-%m-%dT%H:%M\")",
                            "directPositions": "[(datetime(2000,1,1,0,0,0) + timedelta(days=x)).strftime(\"%Y-%m-%dT%H:%M\") for x in ${netcdf:variable:time}]",
                            "gridOrder": 0,
                            "type": "ansidate",
                            "resolution": 1,
                            "irregular": true
                        },
                        "Long": {
                            "min": "${netcdf:variable:lon:min}",
                            "max": "${netcdf:variable:lon:max}",
                            "gridOrder": 2,
                            "resolution": "${netcdf:variable:lon:resolution}"
                        },
                        "Lat": {
                            "min": "${netcdf:variable:lat:min}",
                            "max": "${netcdf:variable:lat:max}",
                            "gridOrder": 1,
                            "resolution": "-${netcdf:variable:lat:resolution}"
                        }
                    }
                }
            },
            "tiling": "ALIGNED [0:0, 0:1585, 0:1647]" 
        }
    }
}
```
### PL/Python
These are stored procedures inside PostgreSQL that connects rasdaman, send rasql queries anf fetched the data arrays or single numeric valeus back to postgresql based on the quires.
1.  **geo_index2grid_index**
2.  **aggregated_result_numeric**

### Combined Quries [SQL + Python(RaSQL)]
* **Q1: What are the average, maximum and minimum temperature over 'Linköping' municipality of Sweden ?**
```
SELECT  m.name_2 AS municipalities,
        rasdaman.aggregated_result_numeric(CONCAT('select avg_cells(clip((c[20, 0:* , 0:*]*0.02) - 273.15,',rasdaman.geo_index2grid_index(ST_AsText((ST_Dump(m.geom)).geom)),')) from Surface_Temperature_Sweden AS c')) AS avg_temp_°C,
	rasdaman.aggregated_result_numeric(CONCAT('select max_cells(clip((c[20, 0:* , 0:*]*0.02) - 273.15,',rasdaman.geo_index2grid_index(ST_AsText((ST_Dump(m.geom)).geom)),')) from Surface_Temperature_Sweden AS c')) AS max_temp_°C,
	rasdaman.aggregated_result_numeric(CONCAT('select min_cells(clip((c[20, 0:* , 0:*]*0.02) - 273.15,',rasdaman.geo_index2grid_index(ST_AsText((ST_Dump(m.geom)).geom)),')) from Surface_Temperature_Sweden AS c')) AS min_temp_°C
FROM    municipalswe AS m
WHERE   m.name_2 = 'Linköping'
```
* **Q2: What are the average, maximum and minimum temperature the following municipalities of Sweden ?**
```
SELECT  m.name_2 AS municipalities,
        rasdaman.aggregated_result_numeric(CONCAT('select avg_cells(clip((c[20, 0:* , 0:*]*0.02) - 273.15,',rasdaman.geo_index2grid_index(ST_AsText((ST_Dump(m.geom)).geom)),')) from Surface_Temperature_Sweden AS c')) AS avg_temp_°C,
	rasdaman.aggregated_result_numeric(CONCAT('select max_cells(clip((c[20, 0:* , 0:*]*0.02) - 273.15,',rasdaman.geo_index2grid_index(ST_AsText((ST_Dump(m.geom)).geom)),')) from Surface_Temperature_Sweden AS c')) AS max_temp_°C,
	rasdaman.aggregated_result_numeric(CONCAT('select min_cells(clip((c[20, 0:* , 0:*]*0.02) - 273.15,',rasdaman.geo_index2grid_index(ST_AsText((ST_Dump(m.geom)).geom)),')) from Surface_Temperature_Sweden AS c')) AS min_temp_°C    
FROM    municipalswe AS m
WHERE   m.name_2 IN ('Åsele',
                     'Dorotea',
                     'Lycksele',
                     'Linköping',
                     'Malå',
                     'Sorsele')
```
# Ontop Integration
#### ```jdbc``` driver is needed to connect Ontop with Rasdaman but as per rasdaman comunity rasdaman doesn't have a jdbc driver and we also double checked it.

* **Solution**: [ASQLDB](https://blog.52north.org/2014/06/26/sensor-data-access-for-rasdaman-mid-term-blog-post/)

### ASQLDB ([source](https://github.com/misev/asqldb))

![asqldb](https://blog.52north.org/wp-content/uploads/sites/2/2014/06/AsqlJDBCRasadaman.png)

#### Java8 in Ubuntu ([link](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/How-do-I-install-Java-on-Ubuntu))
```
$ java --version

openjdk 11.0.18 2023-01-17
OpenJDK Runtime Environment (build 11.0.18+10-post-Ubuntu-0ubuntu120.04.1)
OpenJDK 64-Bit Server VM (build 11.0.18+10-post-Ubuntu-0ubuntu120.04.1, mixed mode)
```
```
$ sudo apt-get install openjdk-8-jdk
```
```
$ sudo nano /etc/environment
```
```
$ source /etc/environment
```
```
$ echo $JAVA_HOME

/lib/jvm/java-8-openjdk-amd6
```



