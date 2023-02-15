# RasDaMan [Raster Data Manager]

## Datasets
1. [Air Temperature](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html)

## Google Group
1. [Rasdaman Google Help Group](https://groups.google.com/g/rasdaman-users/c/6RfopKXiapM/m/vyF5hrcCAgAJ)
2. [My Discussions](https://groups.google.com/d/msgid/rasdaman-users/10907293-5c82-4e8e-b3b3-dedb0dcdd515n%40googlegroups.com?utm_medium=email&utm_source=footer)

## Tutorials
1. [WCSTImport Guide](http://rasdaman.org/wiki/WCSTImportGuide)
2. [General Recipe for WCSTImport (NetCDF, PNG)](http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe)
3. [NetCDF in RaSdAmAn](http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe#Netcdf)


## Installation [Guide](https://doc.rasdaman.org/stable/02_inst-guide.html)

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
1.  Coverage's CRS is: OGC/0/AnsiDate@OGC/0/Index1D@EPSG/0/4326 which can be broken to these grid orders respectively: "ansi (datetime)":0, "i(level)":1, "lat":2, "long":3 in case 4D data
2.  Calculate datetime values in netCDF file with the origin of Time CRS (http://www.opengis.net/def/crs/OGC/0/AnsiDate with origin: 1600-12-31T00:00:00Z)
3. for irregular axis (resolution is always 1).
## Worked
#### **DATA**: [/Datasets/udel.airt.precip/v401/air.mon.mean.v401.nc](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html) 
* **Temporal Resolution**: Monthly values for 1901/01 - 2014/12 (V4.01)
* **Spatial Coverage**: 0.5 degree latitude x 0.5 degree longitude | global grid (720x360) | 3D datacube (time x lat x long = 1380 x 720 x 360).

#### WCSTImport introduces two concepts:

* ```Recipe``` - A recipe is a class implementing the BaseRecipe that based on a set of parameters (ingredients) can import a set of files into WCS forming a well defined structure (image, regular timeseries, irregular timeseries etc). 4 types of recipe are as follows (General Recipe,Mosaic Map, Regular Timeseries, Irregular Timeseries)

* ```Ingredients``` - An ingredients file is a json file containing a set of parameters that define how the recipe should behave (e.g. the WCS endpoint, the CRS resolver etc are all ingredients)

**NOTE** Its only input is an "**ingredient**" file telling everything about the import process that the utility needs to know. (On a side note, such ingredients files constitute an excellent documentation.)

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


