# RasDaMan

## Datasets
1. [Air Temperature](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html)

## Google Group
1. [Rasdaman Google Help Group](https://groups.google.com/g/rasdaman-users/c/6RfopKXiapM/m/vyF5hrcCAgAJ)
2. [My Discussions](https://groups.google.com/d/msgid/rasdaman-users/10907293-5c82-4e8e-b3b3-dedb0dcdd515n%40googlegroups.com?utm_medium=email&utm_source=footer)

## Tutorials
1. [WCSTImport Guide](http://rasdaman.org/wiki/WCSTImportGuide)
2. [General Recipe for WCSTImport (NetCDF, PNG)](http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe)


## Installation
[Source](https://doc.rasdaman.org/stable/02_inst-guide.html)
### 1. Open terminal in Ubuntu 20.04 LTS 

 ```wget -O - https://download.rasdaman.org/packages/rasdaman.gpg | sudo apt-key add - ```

```echo "deb [arch=amd64] https://download.rasdaman.org/packages/deb focal stable" | sudo tee /etc/apt/sources.list.d/rasdaman.list ```

```sudo apt-get update ```

```sudo apt-get install rasdaman ```

```source /etc/profile.d/rasdaman.sh ```

### 2. Check if rasql is intalled and set in path or not 
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

### 6.Pre-requisite install [for first time users]

1. Check python version (must be 3.8 or later)

2. nstall netcdf4 package
``` sudo pip3 install netCDF4```
### 6. Tips
1.  Coverage's CRS is: OGC/0/AnsiDate@OGC/0/Index1D@EPSG/0/4326 which can be broken to these grid orders respectively: "ansi (datetime)":0, "i(level)":1, "lat":2, "long":3 in case 4D data
2.  Calculate datetime values in netCDF file with the origin of Time CRS (http://www.opengis.net/def/crs/OGC/0/AnsiDate with origin: 1600-12-31T00:00:00Z)
3. for irregular axis (resolution is always 1).
## Worked
#### **DATA**: [/Datasets/udel.airt.precip/v401/air.mon.mean.v401.nc](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html) 
#### **Temporal Resolution**: Monthly values for 1901/01 - 2014/12 (V4.01)
#### **Spatial Coverage**: 0.5 degree latitude x 0.5 degree longitude | global grid (720x360) | 3D datacube (time x lat x long = 1380 x 720 x 360).

#### **Recipe.json**
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

### 7. Queries
[Query Language Guide](https://doc.rasdaman.org/stable/04_ql-guide.html#query-language-guide)

