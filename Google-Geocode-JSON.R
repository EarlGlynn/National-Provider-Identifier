# Google Geocoding:  JSON get.geocode function
# Earl F Glynn, UMKC Center for Health Insights, 2015-01-12.

################################################################################

library(stringr)   # str_trim
library(RJSONIO)   # fromJSON

# Based on Missouri observations
knownAddressTypes <- c(
  "administrative_area_level_1|political",
  "administrative_area_level_2|political",
  "administrative_area_level_3|political",
  "country|political",
  "establishment",
  "locality|political",
  "neighborhood|political",
  "point_of_interest|establishment",
  "postal_code",
  "postal_code_suffix",
  "premise",
  "route",
  "street_number",
  "sublocality_level_1|sublocality|political",
  "subpremise"
  )

################################################################################

# Function to call Google's Geocoding API for given street, city and state.
# "id" could be used to add a "key" to the data record being processed.
get.geocode <- function (id, street, city, state, zip)
{
  address <- paste(street, city, state, zip, sep=", ")
  URL <- paste("http://maps.googleapis.com/maps/api/geocode/json?address=",
               gsub(" ", "+", address), sep="")

  JSON <- fromJSON(URL)
  status <- JSON$status

  # if more than one, pick only the first in JSON$results[[1]]
  if (status == "OK")
  {
    # Initial breakup up JSON object
    address_components <- JSON$results[[1]]$address_components
    formatted.address  <- JSON$results[[1]]$formatted_address
    geometry           <- JSON$results[[1]]$geometry
    types              <- JSON$results[[1]]$types

    result.count <- length(JSON$results)    # study why this is ever > 1

    # address_components
    address_long_name <- unlist(lapply(address_components, "[", 1))
    stopifnot(names(address_long_name) == "long_name")
    address_short_name <- unlist(lapply(address_components, "[", 2))
    stopifnot(names(address_short_name) == "short_name")

    address_types <- unlist(lapply(address_components, function(x){paste(x$types,collapse="|")}))

    if (! all(address_types %in% knownAddressTypes) )
    {
      cat("Unexpected address type(s) for", id, ":\n")
      cat(address_types[which(!address_types %in% knownAddressTypes)], "\n")
    }

    components <- data.frame(types=address_types,
                             short=address_short_name,
                             long=address_long_name,
                             stringsAsFactors=FALSE, row.names=1)

    # Add prefix "geo" to fields that were inputs.  This allows later comparison of
    # inputs and outputs if ever necessary.

    street_number <- components["street_number", "short"]
    if (is.na(street_number)) street_number <- ""
    route         <- components["route", "short"]
    if (is.na(route)) route <- ""
    geostreet     <- str_trim(paste(street_number, route))

    geocity       <- components["locality|political", "long"]
    geostate      <- components["administrative_area_level_1|political", "short"]
    geozip5       <- components["postal_code", "short"]
    geozip4       <- components["postal_code_suffix", "short"]

    county        <- components["administrative_area_level_2|political", "short"]
    establishment <- components["establishment", "long"]

    if (is.na(geocity))  geocity   <- ""
    if (is.na(geostate)) geostate  <- ""
    if (is.na(geozip5))  geozip5   <- ""
    if (is.na(geozip4))  geozip4   <- ""
    if (is.na(county))   county    <- ""
    if (is.na(establishment)) establishment <- ""

    # geometry
    lat <- geometry$location["lat"]
    lng <- geometry$location["lng"]
    location.type <- geometry$location_type
  } else {
    types <- ""
    formatted.address <- ""
    geostreet <- ""
    geocity <- ""
    geostate <- ""
    geozip5 <- ""
    geozip4 <- ""
    county <- ""
    establishment <- ""
    lat <- ""
    lng <- ""
    location.type <- ""
    result.count <- 0
  }

  data.frame(id, status,
             street=street, city=city, state=state, zip=zip,
             geostreet, geocity, geostate, geozip5, geozip4, county,
             lat, lng, location.type,
             formatted.address, establishment,
             types=paste(types, collapse="|"),
             result.count, row.names=1,
             stringsAsFactors=FALSE)
}
