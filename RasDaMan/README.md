# RasDaMan

## Datasets
1. [Air Temperature](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html)

## Google Group
1. [Rasdaman Google Help Group](https://groups.google.com/g/rasdaman-users/c/6RfopKXiapM/m/vyF5hrcCAgAJ)

## Tutorials
1. [WCSTImport Guide](http://rasdaman.org/wiki/WCSTImportGuide)
2. [General Recipe for WCSTImport](http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe)


## Installation
[Source](https://doc.rasdaman.org/stable/02_inst-guide.html)
### 1. Open terminal in Ubuntu 20.04 LTS 

 ```wget -O - https://download.rasdaman.org/packages/rasdaman.gpg | sudo apt-key add - ```

```echo "deb [arch=amd64] https://download.rasdaman.org/packages/deb focal stable" | sudo tee /etc/apt/sources.list.d/rasdaman.list ```

```sudo apt-get update ```

```sudo apt-get install rasdaman ```

```source /etc/profile.d/rasdaman.sh ```

```rasql -q 'select c from RAS_COLLECTIONNAMES as c' --out string```

```echo "deb [arch=amd64] https://download.rasdaman.org/packages/deb focal stable" | sudo tee /etc/apt/sources.list.d/rasdaman.list```

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

### 3. check [OGC Web Coverage Service Endpoint](http://localhost:8080/rasdaman/ows)

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

### 6. Worked
#### **DATA**: [/Datasets/udel.airt.precip/v401/air.mon.mean.v401.nc](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html) 
#### **Temporal Resolution** Monthly values for 1901/01 - 2014/12 (V4.01)
#### **Spatial Coverage** 0.5 degree latitude x 0.5 degree longitude global grid (720x360).

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

#### **Output Screenshot**
![Screenshot from 2022-11-22 13-49-12](https://user-images.githubusercontent.com/71174892/203321589-6abc0681-6488-4e83-a42c-96dd689cba33.png)

