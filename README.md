# myPhD

[<img src="./research.png">](https://www.wsnmagazine.com/secrets-for-research-excellence/)

# Environment

### Installing Java SE Platform (JDK 23)

- Download jdk installer from Oracle [website](https://www.oracle.com/in/java/technologies/downloads/) and install default
- Go to the folder `C:\Program Files\Java\jdk-23\bin` and copy the path
- Open **Environmental Variables** and go to the **Path** in the **System Variables**
- Paste the `C:\Program Files\Java\jdk-23\bin` in the Path
- Then create a new system variable called `JAVA_HOME` with the value `C:\Program Files\Java\jdk-23`

- Open `cmd` pr `powershell` and run

  - `java -version`

    ```shell
    java version "23.0.1" 2024-10-15
    Java(TM) SE Runtime Environment (build 23.0.1+11-39)
    Java HotSpot(TM) 64-Bit Server VM (build 23.0.1+11-39, mixed mode, sharing)
    ```

# Relational Data

## Vector Data

Relational data with additional column representing geometric features of real world feature.

1. https://www.statsilk.com/maps/download-free-shapefile-maps
2. https://gadm.org/data.html
3. https://www.naturalearthdata.com/downloads/
4. https://hub.arcgis.com/datasets/esri::world-cities/about
5. https://arthworks.stanford.edu/
6. https://www.geonames.org/
7. https://www.efrainmaps.es/english-version/free-downloads/world/
8. https://download.geofabrik.de/

### Grammar of shapefiles

1. https://www.e-education.psu.edu/natureofgeoinfo/c4_p5.html
2. https://www.loc.gov/preservation/digital/formats/fdd/fdd000280.shtml

## CityGML

- [CityGML](https://www.cityjson.org/) can be represented in [CityJSON](https://www.cityjson.org/)

- CityJSON File [Viewer](https://ninja.cityjson.org/)

### Downloading CityGML data from [OpenDATA](https://geodaten.bayern.de/opengeodata/OpenDataDetail.html?pn=lod2) using `GitBash`

- Open **GitBash** inside the folder and execute the following shell script `get-munich-citygml.sh` using `$ sh get-munich-citygml.sh`

  ```sh
  #!/bin/bash

  for LONG in `seq 674 2 680`
  do
      for LAT in `seq 5332 2 5342`
      do
          wget "https://download1.bayernwolke.de/a/lod2/citygml/${LONG}_${LAT}.gml"
      done
  done
  ```

  - Edit the Range of `LONG` and `LAT` to download more gml files

### Converting CityGML to CityJSON

- CityJSON format is much smaller than CityGML for representing city data.

- Follow the instructions at this [page](https://www.cityjson.org/tutorials/conversion/#conversion-citygml---cityjson)

### Merging CityJSON files using _CityJSON/io ([cjio](https://github.com/cityjson/cjio?tab=readme-ov-file)_)

- Convert each `.gml` file to `.city.json` file
- Go to this [page](https://cjio.readthedocs.io/en/latest/includeme.html)
- Open cmd and run the following to download `cjio`

  - $` pip install cjio`

  - ```sh
    Defaulting to user installation because normal site-packages is not writeable
    Collecting cjio
      Downloading cjio-0.9.0-py2.py3-none-any.whl.metadata (11 kB)
    Requirement already satisfied: numpy in c:\users\arkag\appdata\roaming\python\python310\site-packages (from cjio) (1.23.4)
    Requirement already satisfied: Click>=8.1.0 in c:\users\arkag\appdata\roaming\python\python310\site-packages (from cjio) (8.1.7)
    Requirement already satisfied: colorama in c:\users\arkag\appdata\roaming\python\python310\site-packages (from Click>=8.1.0->cjio) (0.4.6)
    Downloading cjio-0.9.0-py2.py3-none-any.whl (49 kB)
    Installing collected packages: cjio
    Successfully installed cjio-0.9.0
    ```

  - `cjio --help`

  - Usage examples:

    ```sh
          cjio myfile.city.json info
          cjio myfile.city.json subset --id house12 save out.city.json
          cjio myfile.city.json crs_assign 7145 textures_remove export --format obj output.obj
          cat mystream.city.jsonl | cjio stdin info
    ```

  - Run the following script to join let's say 4 CityJSON files

    ```sh
    $ cjio 676_5336.json merge 680_5334.json merge 688_5334.json merge 688_5336.json save out.city.json
    ```

# Raster Data
