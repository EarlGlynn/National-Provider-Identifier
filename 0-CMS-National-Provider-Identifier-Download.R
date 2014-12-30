# National Plan and Provider Enumeration System (NPPES) Downloadable File
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html

# Download National Provider Identifier (NPI) Downloadable File.
# (Full replacement monthly NPI file)
# http://nppes.viva-it.com/NPI_Files.html                                                          ##### Review labels

# UMKC Center for Health Insights
# Earl F Glynn, 2014-12-01.

##############################################################################
### Setup

setwd("C:/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")  ##### Modify as appropriate
#setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")                ##### Modify as appropriate

filename <- paste0("0-CMS-National-Provider-Identifier-Download-",
                   format(Sys.time(), "%Y-%m-%d"), ".txt")
sink(filename, split=TRUE)
time.1 <- Sys.time()
time.1

library(downloader)  # platform neutral download function
library(tools)       # md5sum

DATA.DIR <- "DATA/2014-12-10"                                                                      ##### 1 of 2
if (! file.exists(DATA.DIR) )
{
  dir.create(DATA.DIR)
}

##############################################################################
### Download

download.url <- "http://nppes.viva-it.com/NPPES_Data_Dissemination_December_2014.zip"              ##### 2 of 2
zip.filename <- paste0(DATA.DIR, "/NPPES_Data_Dissemination.zip")
download(download.url, zip.filename, mode = "wb")
print( md5sum(zip.filename) )
files <- unzip(zip.filename, exdir=DATA.DIR)
print(Sys.time())

options(width=150)
print( file.info(files) )

cat("Data file:\n")
files[1]

time.2 <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.2, time.1,  units="secs"))), " secs\n")

# Run script 1-Recode.bash in Linux virtual machine

sink()

