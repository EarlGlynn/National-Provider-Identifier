# Google Geocoding of National Provider Identifiers
# http://code.google.com/apis/maps/documentation/geocoding/index.html
#
# Input file:   FILEPREFIX-in.txt
# Output file:  FILEPREFIX-out-TIMESUFFIX.txt
# Note:  Use "out" file as next "in" file after daily quota exhausted.
# Be sure to fix status column replacing OVER_QUERY_LIMIT.

# Earl F Glynn
# UMKC Center for Health Insights
# 2015-01-06

################################################################################
### Setup

library(stringr)  #  str_trim

baseDir <- "C:/2015/R/Geocoding-National-Providers/"  ##### CHANGE BY PROJECT #####
#FILEPREFIX <- "Sample"                               ##### CHANGE BY PROJECT #####
FILEPREFIX <- "NPI-Missouri-Practices-Practice-Addresses"

TIMESUFFIX <- format(Sys.time(), "%Y-%m-%d-%H%M")

setwd(baseDir)

filenameSink <- paste0("Sink-", FILEPREFIX, "-", TIMESUFFIX, ".txt")
sink(filenameSink, split=TRUE)

source("Google-Geocode-JSON.R")   # get.geocode function

################################################################################
### Read input file.  Cleanup if necessary.

filenameInput <- paste0(FILEPREFIX, "-in.txt")        ##### CHANGE BY PROJECT #####
d <- read.delim(filenameInput, as.is=TRUE)

### Cleanup only really necessary in the first round
d$Street <- str_trim(gsub("#", " ", d$Street))

# Add columns when status column not present
if (length(d$status) == 0)
{
  d$status <- ""
  d$geostreet <- ""
  d$geocity <- ""
  d$geostate <- ""
  d$geozip5 <- ""
  d$geozip4 <- ""
  d$county <- ""
  d$lat <- ""
  d$lng <- ""
  d$location.type <- ""
  d$types <- ""
  d$result.count <- ""
  d$establishment <- ""
  d$formatted.address <- ""
}

################################################################################
### Batch loop.  Only 2500 free geocodes per day from Google.

i <- 1
geocoding <- TRUE
continue <- TRUE
while (geocoding)
{
  # Only process rows from file if status field is empty.
  if ( (is.na(d$status[i])) || (nchar(d$status[i]) == 0) )
  {
    street <- d$Street[i]  # use for debugging when needed
    city   <- d$City[i]
    state  <- d$State[i]
    zip    <- d$ZIP[i]
    x <- get.geocode(i, street, city, state, zip)

    d$status[i]    <- x$status[1]

    d$geostreet[i] <- x$geostreet[1]
    d$geocity[i]   <- x$geocity[1]
    d$geostate[i]  <- x$geostate[1]
    d$geozip5[i]   <- x$geozip5[1]
    d$geozip4[i]   <- x$geozip4[1]

    d$county[i]            <- x$county[1]
    d$lat[i]               <- x$lat[1]
    d$lng[i]               <- x$lng[1]
    d$location.type[i]     <- x$location.type[1]

    d$types[i]             <- x$types[1]

    d$result.count[i]      <- x$result.count[1]
    d$establishment[i]     <- x$establishment[1]
    d$formatted.address[i] <- x$formatted.address[1]


    # stop when over daily quota
    continue <- (x$status[1] != "OVER_QUERY_LIMIT")

    cat(i,  x$status[1], street, city, state, zip, "\n")
    flush.console()

    Sys.sleep(0.5)  # Be kind to Google's server
  }
  i <- i + 1
  geocoding <- (i <= nrow(d)) && continue
}

filenameOutput <- paste0(FILEPREFIX, "-out-", TIMESUFFIX, ".txt")
write.table(d, file=filenameOutput, sep="\t", row.names=FALSE)

sink()
