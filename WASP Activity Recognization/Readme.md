
# WASP-Activity-Rercognization-Umea
 
**WASP_AS_M1_Umeå1**: Arka Ghosh,  Divya Baura,  Joannes Vermant, Julian Alfredo Mendez and Sabine Houy
 
## Activity Recognization 
Download the (free) application Sensor Fusion from Google Play. It has been developed at LiU. More information is available here: http://sensorfusion.se/sfapp/

## Requirements:

The algorithm should be able to discriminate between, standing still, walking and running in a single data file (ie first collect than run, does not need to run on the phone) where the state changes. 

1. Input a sensor log file (e.g. sensorLog_20221028T145848.txt)

2. run the code 'activityDetectionUmu.m'

3. it will detect the activity 
4. **Expected problem:** Sometimes the 'sensordata.jar' that was given does not work. In this case the following section of code will not work

```
dataFilename = FileSensorDataReader('sensorLog_20221028T145848.txt');
dataFilename.start();

```


restart the MATLAB and run again


