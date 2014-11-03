# National Plan and Provider Enumeration System (NPPES) Downloadable File
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html

# Download National Provider Identifier (NPI) Downloadable File.
# http://nppes.viva-it.com/NPI_Files.html

# UMKC Center for Health Insights
# Earl F Glynn, 2014-10-20.

##############################################################################
### Setup

#setwd("C:/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")  ##### Modify as appropriate
setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")                  ##### Modify as appropriate

sink("0-CMS-National-Provider-Identifier-Download.txt", split=TRUE)
print(Sys.time())

library(downloader)  # platform neutral download function
library(tools)       # md5sum

DATA.DIR <- "DATA/2014-10-15"                                                                            ##### Modify as appropriate
if (! file.exists(DATA.DIR) )
{
  dir.create(DATA.DIR)
}

##############################################################################
### Download

download.url <- "http://nppes.viva-it.com/NPPES_Data_Dissemination_October_2014.zip"                     ###### Modify as appropriate
zip.filename <- paste0(DATA.DIR, "/NPPES_Data_Dissemination.zip")
download(download.url, zip.filename, mode = "wb")
print( md5sum(zip.filename) )
files <- unzip(zip.filename, exdir=DATA.DIR)
print(Sys.time())

options(width=150)
print( file.info(files) )

##############################################################################
### Preliminary stats.
### Need about 24 GB memory to read the raw data file.

# For now, treat all fields as character data.
firstlook <- read.csv(files[1], colClasses="character")
print(object.size(firstlook))
str(firstlook)

# Verify NPI might be record key.
length(unique(firstlook$NPI))

options(width=100)
for (i in 1:ncol(firstlook))
{
  cat("\n*************************************************\n")
  cat(i, names(firstlook)[i], "\n")
  counts <- table(firstlook[,i])
  cat(length(counts), "values\n")
  if (length(counts) > 100)
  {
    cat("Top 100 by frequency ...\n")
    counts <- sort(counts, decreasing=TRUE)[1:100]
  }
  print(counts)
  flush.console()
}

print(Sys.time())
sink()

