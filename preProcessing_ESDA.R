# Contributor: Daniel Scheerooren
# Created on: 23-11-2015
# Contact: daniel.scheerooren@wur.nl
# Objective: To pre-process raw electrical vehicle charge point datasets (Amsterdam area) for use in the ESDA tool. 
# Subset of main_ESDA.R

#Set directory
mainDir <- "M:/GeoDataMscThesis/"
subDir <- "Datasets"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

# Download Charge point dataset
download.file("https://api.essent.nl/generic/downloadChargingStations?latitude_low=52.30567123031878&longtitude_low=4.756801078125022&latitude_high=52.43772606594848&longtitude_high=5.086390921875022&format=CSV",destfile="ChargeStations.csv",method="libcurl")
ChargeStations <- read.csv("ChargeStations.csv", header = T, sep=";")

# Mannualy put charge data into Datasets directory and save as CSV-file.
list.files()

#Download required packages
library(plyr)

# Read csv files and create R-objects
NuonRaw <- read.csv("rapportage_verbruiksdata 201301 + 201306.csv",  header = T, sep=",")
EssentRaw01 <- read.csv("exp_201301-62014.csv",  header = T, sep=",")
EssentRaw06 <- read.csv("exp_201306-62014.csv",  header = T, sep=",")

# Split Nuon dataset into Januari and June (Error)
NuonRaw$Date2 <- as.POSIXct(paste(NuonRaw$Date2), tz = "GMT")
NuonRaw01 <- subset(NuonRaw, Date2 <= as.POSIXct("2013-01-01 00:00"))
NuonRaw06 <- subset(NuonRaw, Date2 > as.POSIXct("2013-01-01 00:00"))

#-------------------------------------------------------------------------------------------  
# Make Nuon/Essent data equal (date/time/PostalCode/kWH) 
#-------------------------------------------------------------------------------------------
# Rename column by name: (for merge purposes)
names(NuonRaw01)[names(NuonRaw01)=="Straat"] <- "Street"
names(NuonRaw01)[names(NuonRaw01)=="Huisnummer"] <- "HouseNumber"
names(NuonRaw01)[names(NuonRaw01)=="Postcode"] <- "PostalCode"
names(NuonRaw01)[names(NuonRaw01)=="Laadtijd"] <- "CONNECT_TIME"
names(NuonRaw01)[names(NuonRaw01)=="Start"] <- "BEGIN_CS"
names(NuonRaw01)[names(NuonRaw01)=="Eind"] <- "END_CS"
names(EssentRaw01)[names(EssentRaw01)=="STREET"] <- "Street"
names(EssentRaw01)[names(EssentRaw01)=="HOUSE_NUM1"] <- "HouseNumber"
names(EssentRaw01)[names(EssentRaw01)=="POST_CODE1"] <- "PostalCode"
names(EssentRaw01)[names(EssentRaw01)=="CHARGE_DURATION"] <- "CONNECT_TIME"
names(EssentRaw01)[names(EssentRaw01)=="ENERGIE"] <- "kWh"

# Merge date and time (Essent)
as.POSIXct(EssentRaw01$BEGIN_LOAD_DATE, format = "%d.%m.%Y")
as.POSIXct(EssentRaw01$BEGIN_LOAD_TIME, format = "%H:%M:%S", tz = "GMT")
as.POSIXct(EssentRaw01$END_LOAD_DATE, format = "%d.%m.%Y")
as.POSIXct(EssentRaw01$END_LOAD_TIME, format = "%H:%M:%S", tz = "GMT")
EssentRaw01$BEGIN_CS <- as.POSIXct(paste(EssentRaw01$BEGIN_LOAD_DATE, EssentRaw01$BEGIN_LOAD_TIME), format = "%Y-%m-%d %H:%M:%S")
EssentRaw01$END_CS <- as.POSIXct(paste(EssentRaw01$END_LOAD_DATE, EssentRaw01$END_LOAD_TIME), format = "%Y-%m-%d %H:%M:%S")

EssentRaw01$BEGIN_CS <- cbind(EssentRaw01$BEGIN_LOAD_DATE, EssentRaw01$BEGIN_LOAD_TIME) # Gives weird numbers

View(EssentRaw01) # No error, but NA values

# Set date and time (Nuon)
NuonRaw$BEGIN_CS <- as.POSIXct(paste(NuonRaw$Start), format="%d-%m-%Y %H:%M", tz = "GMT")
NuonRaw$END_CS <- as.POSIXct(paste(NuonRaw$Eind), format="%d-%m-%Y %H:%M",  tz = "GMT")

View(NuonRaw) # No error, but NA values

#-------------------------------------------------------------------------------------------  
# Merge charge data with xy coordinates
#-------------------------------------------------------------------------------------------  
mergeXY <- function (df, xy){
  df$ID <- paste(df$Street, df$HouseNumber, df$PostalCode, sep="_")
  xy <- ChargeStations
  xy$ID <- paste(xy$Street, xy$HouseNumber, xy$PostalCode, sep="_")
  df.xy <- join(df, xy, by="ID")
  return (df.xy)
}

# Remove na values
dat.xy <- dat.xy[!is.na(dat.xy$Latitude),]

# Remove unnecessary columns
keep <- c("Street", "HouseNumber", "PostalCode", "BEGIN_CS", "END_CS", "CONNECT_TIME", "kWh", "Latitude", "Longitude", "Provider")
EssentClean01 <- EssentRaw01[keep]
NuonClean01 <- NuonClean01[keep]

#Write object to csv file for viewing outside R environment
write.csv(EssentClean01, file = "EssentClean01.csv")
write.csv(NuonClean01, file= "NuonClean01.csv")