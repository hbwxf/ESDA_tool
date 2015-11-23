# Contributor: Daniel Scheerooren
# Created on: 23-11-2015
# Contact: daniel.scheerooren@wur.nl
# Objective: To test packages without altering the main script.
# Subset of: main_ESDA.R

#Create subdirectory
mainDir <- "M:/GeoDataMscThesis/"
subDir <- "TestScript"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

list.files()

# #Download Charge point dataset
# download.file("https://api.essent.nl/generic/downloadChargingStations?latitude_low=52.30567123031878&longtitude_low=4.756801078125022&latitude_high=52.43772606594848&longtitude_high=5.086390921875022&format=CSV",destfile="ChargeStations.csv",method="libcurl")
# ChargeStations <- read.csv("ChargeStations.csv", header = T, sep=";")
# View(ChargeStations)

#Load library
library(plotKML)
library(sp)
library(rgdal)

### Read CSV files
NuonTestPlot <- read.csv("M:/GeoDataMscThesis/HvA_Copy_RawData/NuonTESTkml.csv")
View(NuonTestPlot)

#Plot latitude vs.longitude 
plot(essentXYmerged$Latitude ~ essentXYmerged$Longitude, ylab="Latitude", xlab="Longitude", main="Charge Stations", col='red')

str(essentXYmerged)
#Make date variable understandable for R
essentXYmerged$BEGIN_LOAD_TIME <- as.Date(essentXYmerged$BEGIN_LOAD_TIME, "%H:%M:%S")
essentXYmerged$BEGIN_LOAD_DATE <- as.Date(essentXYmerged$BEGIN_LOAD_DATE, "%d.%m.%y")

#Plot kwH vs. Date
plot(NuonTestPlot$kWh~NuonTestPlot$Eind_text, type='p', col='red', ylab="kWh", xlab="Date", main="Charge sessions")

### Google VIS
install.packages("googleVis")
library(googleVis)
library(RJSONIO)

NuonRaw <- read.xlsx("M:/GeoDataMscThesis/HvA_RawData/2rapportage_verbruiksdata 201301 + 201306.xlsx", sheet = 1, colNames = TRUE)
View(NuonRaw)
NuonRaw$Start_text <- as.Date(NuonRaw$Start_text, "%d-%m-%y %H:%M")
NuonRaw$Laadtijd <- as.Date(NuonRaw$Laadtijd, "%M:%S")
#Create MotionChart (Including zoom function!)
Visualization1 <- gvisMotionChart(NuonRaw, idvar="kWh", timevar='Laadtijd', options=list(explorer="{actions: ['dragToZoom', 'rightClickToReset'], maxZoomIn:0.05}"))
plot(Visualization1)



# Add xy-coordinates of charge point dataset to charge datasets
nuonXYmerged <- merge(NuonRaw,ChargeStations,by=c("Street","HouseNumber"))
essentXYmerged <- merge(EssentRaw,ChargeStations, by=c("Street","HouseNumber"))
#Write object to csv file for viewing outside R environment
write.csv(nuonXYmerged, file = "M:/GeoDataMscThesis/HvA_Copy_RawData/NuonTESTkml.csv")
write.csv(essentXYmerged, file= "M:/GeoDataMscThesis/HvA_Copy_RawData/EssentTESTkml.csv")

#Create Map (Works --> re-scale/zoom to Amsterdam region doens't work yet)
#gvisIntensityMap, gvisGeoMap, gvisGeoChart, gvisAnnotatedTimeLine
Geo <- gvisGeoMap(CP_TestTimeSlider2_copy, locationvar="LatLong", numvar='kWh', options=list(dataMode = "markers", enableScrollWheel=TRUE, showTip=TRUE, mapType="hybrid", zoomLevel="19"))
plot(Geo)

#Create callender of kWh use (WORKS!)
Cal <- gvisCalendar(CP_TestTimeSlider2_copy, 
                    datevar="Date", 
                    numvar="kWh",
                    options=list(
                      title="Charged kWh in Amsterdam",
                      height=320,
                      calendar="{yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}}")
                    )
plot(Cal)

#Merging different charts! 
GeoCal <- gvisMerge(Geo, Cal, horizontal = TRUE)
plot(GeoCal)
  
#Read KML files
newmap<-readOGR("M:/GeoDataMscThesis/MscGeoKML/ChargeStationsAmsterdam.kml", layer="ChargeStationsAmsterdam")
plot(newmap)


                