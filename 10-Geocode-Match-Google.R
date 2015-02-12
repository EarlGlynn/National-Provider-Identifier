# Match Google Geocoded Addresses with Original Missouri Provider Records

# UMKC Center for Health Insights
# Earl F Glynn
# 2015-02-12

setwd("C:/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")  #####
#setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")

library(stringr)   # str_trim

filename <- paste0("10-Geocode-Match-Google-",
                   format(Sys.time(), "%Y-%m-%d"), ".txt")
sink(filename, split=TRUE)
time.1 <- Sys.time()
time.1

DATA.DIR <- "DATA/2014-12-10/"

# NPI-Missouri-Practices.txt has field Practice.Location.
MO.Practices <- read.delim(paste0(DATA.DIR, "NPI-Missouri-Practices.txt"), quote="", as.is=TRUE)
dim(MO.Practices)
# [1] 78777    57

# The first four fields of Practice.Location (Street, City, State, ZIP) can be used to create key
# for joining with MO.Practices data.
Practice.Location <- read.delim(paste0(DATA.DIR, "NPI-Missouri-Practices-Practice-Addresses-Geocoded-Google.txt"), as.is=TRUE)
dim(Practice.Location)
# [1] 28180    18

# Removed duplicates (caused by removal of # in orginal street data)
# This should not be needed in new runs in 2015.
Practice.Location <- unique(Practice.Location)
dim(Practice.Location)
# [1] 28174    18

# Cleanup to match geocoding pre-processing
Practice.Location$Practice.Location <- paste(Practice.Location$Street, Practice.Location$City,
                                             Practice.Location$State, Practice.Location$ZIP,
                                             sep="|")
Practice.Location <- Practice.Location[,-1:-4]

Geocoded.MO.Practices <- merge(MO.Practices, Practice.Location,
                               by="Practice.Location", all.x=TRUE)
dim(Geocoded.MO.Practices)

Missouri.Only <- Geocoded.MO.Practices[Geocoded.MO.Practices$geostate == "MO",]
dim(Missouri.Only)
write.table(Missouri.Only,
            paste0(DATA.DIR, "NPI-Missouri-Practices-Geocoded-Google.txt"),
            quote=FALSE, sep="\t", row.names=FALSE)

str(Missouri.Only)

table(Missouri.Only$combo)
table(Missouri.Only$status)
table(Missouri.Only$geostate)
table(Missouri.Only$county)
length(table(Missouri.Only$county))
table(Missouri.Only$types)
table(Missouri.Only$result.count)

Outside.Missouri <- Geocoded.MO.Practices[Geocoded.MO.Practices$geostate != "MO",]
dim(Outside.Missouri)
write.table(Outside.Missouri,
            paste0(DATA.DIR, "NPI-Missouri-Practices-Geocoded-Google-Outside-MO.txt"),
            quote=FALSE, sep="\t", row.names=FALSE)
table(Outside.Missouri$combo)
table(Outside.Missouri$status)
table(Outside.Missouri$geostate)
table(Outside.Missouri$types)
table(Outside.Missouri$result.count)

time.2 <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.2, time.1,  units="secs"))), " secs\n")
sink()
