# Contributor: Daniel Scheerooren
# Created on: 23-11-2015
# Contact: daniel.scheerooren@wur.nl
# Objective: To visualize additional datasets in Google Earth. 
# Subset of: main_ESDA.R

# Set directory 
mainDir <- "M:/GeoDataMscThesis/"
subDir <- "TestScript"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

list.files()

library(RCurl)
library(memisc)

## CSV-files
## - Charge stations
## - Air quality improvement locations
## - Air quality measurement stations
## - Payed parking zones
## - Existing solar panels
## - Building energy labels
## - Municipal election results 2014
## - City district borders

setwd("M:/GeoDataMscThesis/Data/CSV")

downloadData <- function(weblink){
  
}

#Download Charge point dataset
download.file("https://api.essent.nl/generic/downloadChargingStations?latitude_low=52.30567123031878&longtitude_low=4.756801078125022&latitude_high=52.43772606594848&longtitude_high=5.086390921875022&format=CSV",destfile="ChargeStations.csv",method="libcurl")
ChargeStations <- read.csv("ChargeStations.csv", header = T, sep=";")
View(ChargeStations)

#Download Improvement locations air quality
download.file("https://kaart.amsterdam.nl/datasets/datasets-item/t/verbeterlocaties-luchtkwaliteit-1/export/csv",destfile="ImprovementZonesAirQuality.csv",method="libcurl")
AirImprovementZones <- read.csv("ImprovementZonesAirQuality.csv", header = T, sep = ",")

#Download Air quality measurement stations
download.file("https://kaart.amsterdam.nl/datasets/datasets-item/t/lucht-meetstations-1/export/csv",destfile="AirQualityStations.csv",method="libcurl")
AirQualityStations <- read.csv("AirQualityStations.csv", header = T, sep = ",")

#Download Payed Parking Zones
download.file("https://kaart.amsterdam.nl/datasets/datasets-item/t/parkeertariefgebieden-2015/export/csv",destfile="PayedParkingZones.csv",method="libcurl")
PayedParkingZones <- read.csv("PayedParkingZones.csv", header = T, sep = ",")

#Download Existing Solar Panels
download.file("http://maps.amsterdam.nl/open_geodata/excel.php?KAARTLAAG=ENERGIE_ZONNEPANELEN",destfile="SolarPanels.csv",method="libcurl")
SolarPanels <- read.csv("SolarPanels.csv", header = T, sep = ",")

#Download Building Energy Labels
download.file("http://maps.amsterdam.nl/open_geodata/excel.php?KAARTLAAG=ENERGIE_LABELS",destfile="EnergyLabels.csv",method="libcurl")
EnergyLabels <- read.csv("EnergyLabels.csv", header = T, sep = ",")

#Download Municipal Election Results 2014
download.file("http://maps.amsterdam.nl/open_geodata/excel.php?KAARTLAAG=STEMBUS2014_GR",destfile="ElectionResults2014.csv",method="libcurl")
Election2014 <- read.csv("ElectionResults2014.csv", header = T, sep = ",")

#Download City District Borders
download.file("https://kaart.amsterdam.nl/datasets/datasets-item/t/stadsdeelgrenzen-1/export/csv",destfile="CityDistricts.csv",method="libcurl")
CityDistricts <- read.csv("CityDistricts.csv", header = T, sep = ",")

## ESRI .SHP-files (UNZIP FIRST!!)
## - Solar energy potential map
## - Neighborhood borders (Neighborhoods, Neighborhood combinations)
## - Noise nuisance
## - Building function map

#Download Solar Potential Map
download.file("http://maps.amsterdam.nl/energie_zonwind/ENERGIE_ZONPOTENTIE.ZIP", destfile = "SolarPotential.zip", method = "libcurl")
SolarPotential <- unzip("SolarPotential.zip", overwrite = TRUE, junkpaths = TRUE, exdir = tmpd)

url <- "http://maps.amsterdam.nl/energie_zonwind/ENERGIE_ZONPOTENTIE.ZIP"
tmpd <- tempdir() # tmpd <- "M:/GeoDataMscThesis/" --> Error: 'exdir' does not exist
tmpz <- file.path(tmpd, basename(url))
download.file(url, tmpz, mode = "wb")
unzip(tmpz, overwrite = TRUE, junkpaths = TRUE, exdir = tmpd)

list.files(tmpd)

# basename(url)
# tmpz <- file.path("Data/Shapefiles", basename(url))
# download.file(url, file.path("Data/Shapefiles", basename(url)))
# unzip(tmpz, overwrite = TRUE, junkpaths = TRUE, exdir = )

#destfile="Data/Shapefiles/ENERGIE_ZONPOTENTIE.zip", method="libcurl")

#Download Neighborhood borders (Neighborhoods, Neighborhood combinations)
download.file("http://maps.amsterdam.nl/gebiedsindeling/GEBIEDSINDELINGEN.ZIP",destfile="Data/Shapefiles/NeighborhoodBorders.zip",method="libcurl")
#Download Noise nuisance map
download.file("http://maps.amsterdam.nl/geluid/GELUID.ZIP", destfile = "Data/Shapefiles/NoiseNuisance.zip",method="libcurl")
#Download Amsterdam's building function map
download.file("http://maps.amsterdam.nl/functiekaart/FUNCTIEKAART.ZIP", destfile = "Data/Shapefiles/FunctionMap.zip", method = "libcurl")
