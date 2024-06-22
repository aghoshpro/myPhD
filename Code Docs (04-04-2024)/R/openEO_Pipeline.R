library(openeo)
library(tibble)

setwd("D:/workspace_R/OUTPUT_R")

user = "group7"
pwd = "test123"

# connect  to the back-end and login either via explicit call of login, or use your credentials in the connect function
gee = connect(host = "https://earthengine.openeo.org",user = user,password = pwd,login_type = "basic")

# get the process collection to use the predefined processes of the back-end
p = processes()

# get the collection list to get easier access to the collection ids, via auto completion
collections = list_collections()

# get the formats
formats = list_file_formats()

# load the initial data collection and limit the amount of data loaded
# note: for the collection id and later the format you can also use the its character value
data = p$load_collection(id = collections$`MODIS/006/MOD11A1`,
                         spatial_extent = list(west=-180, 
                                               south=-90,
                                               east=180,
                                               north=90),
                         temporal_extent = c("2017-01-01", "2017-01-31"),
                         bands = c("LST_Night_1km"))

# export shall be format PNG
# look at the format description
# formats$output$`GTIFF-THUMB`

# store the results using the format and set the create options
result = p$save_result(data = data,format = formats$output$`GTIFF-THUMB`)

# create a job
job = create_job(graph = result, title = "S1 Example R", description = "Getting Started example on openeo.org for R-client")

# then start the processing of the job and turn on logging (messages that are captured on the back-end during the process execution)
start_job(job = job, log = TRUE)