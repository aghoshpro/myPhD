# Function to install package R 
# install.packages("package Name")
# install.packages("tictoc")
library(tictoc)

packages <- c("sp",
              "raster",
              "rasterVis",
              "rgdal",
              "gdalUtils",
              "mapproj",
              "maptools",
              "scales",
              "classInt",
              "Cairo",
              "xlsx",
              "ncdf4",
              "gplots",
              "ggplot2",
              "filestrings",
              "gtools",
              "devtools",
              "dlpyr",
              "plot3D",
              "data.table",
              "readr",
              "colorspace",
              "colorRamps",
              "RColorBrewer",
              "wesanderson",
              "virdis",
              "dichromat")

tic("basic")
#install.packages(packages)

toc(log = TRUE)
log.txt <- tic.log(format = TRUE)

# list all packages where an update is available
old.packages()

# update all available packages
# update.packages()

# update, without prompts for permission/clarification
# update.packages(ask = FALSE)

# update only a specific package use install.packages()
# install.packages("plotly")