# Contributor: Daniel Scheerooren
# Created on: 23-11-2015
# Contact: daniel.scheerooren@wur.nl
# Objective: To visualize (plot) the spatio-temporal data of EV charge points in Google Earth. 
# Subset of: main_ESDA.R

#Create subdirectory
mainDir <- "M:/GeoDataMscThesis/"
subDir <- "TestScript"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

list.files()
#Load library
library(plotKML)
library(sp)
library(rgdal)

### Read CSV files
CP_TestTimeSlider2_copy <- read.csv("M:/GeoDataMscThesis/....csv")

# #Read KML files
# newmap<-readOGR("M:/GeoDataMscThesis/MscGeoKML/ChargeStationsAmsterdam.kml", layer="ChargeStationsAmsterdam")
# plot(newmap)
# 
# #Write KML file
# oldmap <- writeOGR(objectname, dsn = "name.kml", layer = "name", driver = "KML")

#Set projection system
proj4string(CP_TestTimeSlider2_copy) <- CRS("+init=epsg:4326")

#Make date variable understandable for R
CP_TestTimeSlider2_copy$Date <- as.Date(CP_TestTimeSlider2_copy$Date, "%d-%m-%y")

#plot KML
plotKML(Geo)


OBJECTtoKML <- function(filename){
  
}