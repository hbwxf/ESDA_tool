# Contributor: Daniel Scheerooren
# Created on: 23-11-2015
# Contact: daniel.scheerooren@wur.nl
# Objective: To visualize (plot) the spatio-temporal data of EV charge points in Google Maps. 
# Subset of: main_ESDA.R

#Create subdirectory
mainDir <- "M:/GeoDataMscThesis/"
subDir <- "TestScript"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

list.files()
install.packages("plotGoogleMaps")
library(spacetime)
library(plotGoogleMaps)