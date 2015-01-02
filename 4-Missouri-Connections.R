# Find Missouri connections in National Provider Identifier data.

# UMKC Center for Health Insights
# Earl F Glynn
# 2014-12-30

setwd("C:/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")  #####
#setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")

filename <- paste0("4-Missouri-Connections-",
                   format(Sys.time(), "%Y-%m-%d"), ".txt")
sink(filename, split=TRUE)
time.1 <- Sys.time()
time.1

# Missouri ZIP2 range:  63 to 65
# http://en.wikipedia.org/wiki/ZIP_code

# 63001 (Allenton) to 65899 (Springfield)

DATA.DIR <- "DATA/2014-12-10/"

###############################################################################
### info table

info <- read.delim(paste0(DATA.DIR, "MASTER-NPPES-info.txt"), as.is=TRUE)

names(info)[c(1,24,25,32,33)]
#[1] "NPI"
#[2] "Provider.Business.Mailing.Address.State.Name"
#[3] "Provider.Business.Mailing.Address.Postal.Code"
#[4] "Provider.Business.Practice.Location.Address.State.Name"
#[5] "Provider.Business.Practice.Location.Address.Postal.Code"

### SELECT1 = Provider.Business.Mailing.Address.State.Name is "MISSOURI" or "MO"
#table(info$Provider.Business.Mailing.Address.State.Name)
# MISSOURI 6, MO 77493
SELECT1 <- info$Provider.Business.Mailing.Address.State.Name %in% c("MISSOURI", "MO")
sum(SELECT1)
#[1] 77499

### SELECT2 = Provider.Business.Practice.Location.Address.State.Name is "MISSOURI" or "MO"
#table(info$Provider.Business.Practice.Location.Address.State.Name)
# MISSOURI 2, MO 78693
SELECT2 <- info$Provider.Business.Practice.Location.Address.State.Name %in% c("MISSOURI", "MO")
sum(SELECT2)
#[1] 78695

#table(nchar(info$Provider.Business.Mailing.Address.Postal.Code))

### SELECT3 = Provider.Business.Mailing.Address.Postal.Code is 5- or 9-digts and ZIP2 is "63", "64", "65"
# If 5- or 9-digit ZIP, with 2-digit zip 63 to 65 ...
SELECT3 <- (nchar(info$Provider.Business.Mailing.Address.Postal.Code) %in% c(5,9)) &
          (substr(info$Provider.Business.Mailing.Address.Postal.Code,1,2) %in% c("63", "64", "65"))
sum(SELECT3)
#[1] 77533

### SELECT4 = Provider.Business.Practice.Location.Address.Postal.Code is 5- or 9-digts and ZIP2 is "63", "64", "65"
SELECT4 <- (nchar(info$Provider.Business.Practice.Location.Address.Postal.Code) %in% c(5,9)) &
          (substr(info$Provider.Business.Practice.Location.Address.Postal.Code,1,2) %in% c("63", "64", "65"))
sum(SELECT4)
#[1] 78742

###############################################################################
### other table

other <- read.delim(paste0(DATA.DIR, "MASTER-other-identifier.txt"), as.is=TRUE)
#table(other$Other.Provider.Identifier.State)
# MO 71487

### SELECT5 = one or more of 50 fields have Other.Provider.Identifier.State of "MO"
SELECT.other <- (other$Other.Provider.Identifier.State == "MO")
sum(SELECT.other)
# [1] 71487

SELECT5.NPI <- other$NPI[SELECT.other]
length(SELECT5.NPI)

SELECT5.NPI <- unique(SELECT5.NPI)
length(SELECT5.NPI)
# [1] 32086

# info basis
SELECT5 <- (info$NPI %in% SELECT5.NPI)
sum(SELECT5)
#[1] 32086

stopifnot(nrow(info) == length(SELECT5))

###############################################################################
### license table

license <- read.delim(paste0(DATA.DIR, "MASTER-taxonomy-license.txt"), as.is=TRUE)
#table(license$Provider.License.Number.State.Code)
# MO 79851

### SELECT6 = one or more of 15 fields have Other.Provider.Identifier.State of "MO"
SELECT.license <- (license$Provider.License.Number.State.Code == "MO")
sum(SELECT.license)
#[1] 79851

SELECT6.NPI <- license$NPI[SELECT.license]
length(SELECT6.NPI)

SELECT6.NPI <- unique(SELECT6.NPI)
length(SELECT6.NPI)
#[1] 72922

# info basis
SELECT6 <- (info$NPI %in% SELECT6.NPI)
sum(SELECT6)
# [1] 72922

stopifnot(nrow(info) == length(SELECT6))

###############################################################################
### Missouri selection summary

sum(SELECT1 & SELECT2 & SELECT3 & SELECT4 & SELECT5 & SELECT6)
#[1] 22067

sum(SELECT1 | SELECT2 | SELECT3 | SELECT4 | SELECT5 | SELECT6)
#[1] 93074

# Unique combinations
info$combo <- paste0(" ", # avoid Excel problem
                     ifelse(SELECT1, "X","-"),
                     ifelse(SELECT2, "X","-"),
                     ifelse(SELECT3, "X","-"),
                     ifelse(SELECT4, "X","-"),
                     ifelse(SELECT5, "X","-"),
                     ifelse(SELECT6, "X","-"))

print(table(info$combo))
sum(table(info$combo)[-1])
# [1] 93074

MO.Connections <- info[info$combo != " ------",]

write.table(MO.Connections, paste0(DATA.DIR, "NPI-Missouri-Connections-All.txt"),
            quote=FALSE, sep="\t", row.names=FALSE)

###############################################################################
### Practices in Missouri

MO.Practices <- info[SELECT2 | SELECT4, ]
nrow(MO.Practices)
#[1] 78777

# For geocoding, leave out Provider.Second.Line.Business.Mailing.Address,
# which is often a suite
MO.Practices$Mailing.Location <- paste(
  MO.Practices$Provider.First.Line.Business.Mailing.Address,
  MO.Practices$Provider.Business.Mailing.Address.City.Name,
  MO.Practices$Provider.Business.Mailing.Address.State.Name,
  MO.Practices$Provider.Business.Mailing.Address.Postal.Code,
  sep="|")

# For geocoding, leave out Provider.Second.Line.Business.Practice.Location.Address,
# which is often a suite
MO.Practices$Practice.Location <- paste(
  MO.Practices$Provider.First.Line.Business.Practice.Location.Address,
  MO.Practices$Provider.Business.Practice.Location.Address.City.Name,
  MO.Practices$Provider.Business.Practice.Location.Address.State.Name,
  MO.Practices$Provider.Business.Practice.Location.Address.Postal.Code,
  sep="|")

Mailing.Location <- unique(sort(MO.Practices$Mailing.Location))
length(Mailing.Location)

Practice.Location <- unique(sort(MO.Practices$Practice.Location))
length(Practice.Location)

length(intersect(Practice.Location, Mailing.Location))
length(union(Practice.Location, Mailing.Location))


###############################################################################
### Write Missouri Practices file, Unique address lists for geocoding

write.table(MO.Practices, paste0(DATA.DIR, "NPI-Missouri-Practices.txt"),
            quote=FALSE, sep="\t", row.names=FALSE)

writeLines(Mailing.Location, paste0(DATA.DIR, "NPI-Missouri-Practices-Mailing-Addresses.txt"))
writeLines(Practice.Location, paste0(DATA.DIR, "NPI-Missouri-Practices-Practice-Addresses.txt"))

time.2 <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.2, time.1,  units="secs"))), " secs\n")

sink()
