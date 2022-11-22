# RasDaMan

## Datasets
1. [Air Temperature](https://psl.noaa.gov/data/gridded/data.UDel_AirT_Precip.html)

## Google Group
1. [Rasdaman Google Help Group](https://groups.google.com/g/rasdaman-users/c/6RfopKXiapM/m/vyF5hrcCAgAJ)

## Tutorials
1. [WCSTImport Guide](http://rasdaman.org/wiki/WCSTImportGuide)
2. [General Recipe for WCSTImport](http://rasdaman.org/wiki/WCSTImportGuide/GeneralRecipe)


## Installetion
### 1. Open terminal in Ubuntu 20.04 LTS 

 ```wget -O - https://download.rasdaman.org/packages/rasdaman.gpg | sudo apt-key add - ```

```echo "deb [arch=amd64] https://download.rasdaman.org/packages/deb focal stable" | sudo tee /etc/apt/sources.list.d/rasdaman.list ```

```sudo apt-get update ```

```sudo apt-get install rasdaman ```

```source /etc/profile.d/rasdaman.sh ```

```rasql -q 'select c from RAS_COLLECTIONNAMES as c' --out string```

'''echo "deb [arch=amd64] https://download.rasdaman.org/packages/deb focal stable" | sudo tee /etc/apt/sources.list.d/rasdaman.list'''

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
### 5. STATUS
```
service rasdaman start
service rasdaman stop
service rasdaman status
```
