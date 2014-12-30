# National Plan and Provider Enumeration System (NPPES) Downloadable File
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/
# NationalProvIdentStand/DataDissemination.html

# Script 2-CMS-National-Provider-Identifier-Rewrite.R split the original file
# into three separate tab-separated-values (.txt) files without the bloat of
# all the empty "" fields in the original file.  Memory requirements to read
# these three files are much lower than the huge original file.

# But, two of the three files contain repeating groups that need to be
# restructured to create normalized database tables.

# UMKC Center for Health Insights
# Earl F Glynn, 2014-12-29.

##############################################################################
### Setup

setwd("C:/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")  ##### 1 / 4
#setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")

filename <- paste0("3-CMS-NPI-split-", format(Sys.time(), "%Y-%m-%d"), ".txt")

sink(filename, split=TRUE)

time.begin <- Sys.time()

##############################################################################
### Taxonomy-License
### Healthcare.Provider.Taxonomy (15 sets of 5 variables)  [key + 75]

time.1 <- Sys.time()
time.1

hpt <- read.delim("DATA/2014-12-10/npidata-taxonomy-license.txt", as.is=TRUE)    #####
dim(hpt)
object.size(hpt)

extract.hpt.set <- function(index)
{
  cat("Extract hpt set", index, "of 15\n")
  flush.console()
  extract <- hpt[,c(1, (4*index-2):(4*index+1), (index+1+60))]
  extract$index <- index
  extract <- extract[,c(1,7,2:6)]
  # verify index in variables is correct
  stopifnot( unlist(lapply(strsplit(names(extract)[-1:-2],"_"), "[", 2)) == index)
  names(extract) <-  c("NPI", "index",
                       "Healthcare.Provider.Taxonomy.Code",
                       "Provider.License.Number",
                       "Provider.License.Number.State.Code",
                       "Healthcare.Provider.Primary.Taxonomy.Switch",
                       "Healthcare.Provider.Taxonomy.Group")
  # get rid of blank entries but keep if any of the five fields are non-blank
  blank.test <- apply(extract[,-1:-2], 1, paste, collapse="|")
  SELECT <- blank.test != "||||"
  extract <- extract[SELECT,]
  extract
}

# This is not particularly efficient, but only needs to be done once.
new.hpt <- extract.hpt.set(1)
for (i in 2:15)
{
  print(nrow(new.hpt))
  flush.console()
  new.hpt <- rbind(new.hpt, extract.hpt.set(i))
}
print(nrow(new.hpt))

table(new.hpt$index)

write.table(new.hpt, "DATA/2014-12-10/MASTER-taxonomy-license.txt",         #####
            quote=FALSE, sep="\t", row.names=FALSE)

time.2 <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.2, time.1,  units="secs"))), " secs\n")

rm(hpt, new.hpt)

##############################################################################
### Other Identifier
### Other.Provider.Identifier (50 sets of 4 variables)  [key + 200]

time.1 <- Sys.time()
time.1

# opi object will not fit into memory on a 16 GB PC, so let's read file 50 times
# to get each set of four -- slow, but this only needs to be done once.
# opi <- read.delim("DATA/2014-12-10/npidata-other-identifier.txt", as.is=TRUE)      #####
#dim(opi)
#object.size(opi)

N <- 50

extract.opi.set <- function(index)
{
  cat("Read opi set", index, "of", N, "\n")
  cat(format(Sys.time(), "%H:%M:%S"), "\n")
  flush.console()
  columnClasses <- rep("NULL", 201)
  columnClasses[1] <- "character"
  columnClasses[(4*index-2):(4*index+1)] <- "character"
  extract <- read.delim("DATA/2014-12-10/npidata-other-identifier.txt", as.is=TRUE,
                        colClasses=columnClasses)
  extract$index <- index
  extract <- extract[,c(1,6,2:5)]
  # verify index in variables is correct
  stopifnot( unlist(lapply(strsplit(names(extract)[-1:-2],"_"), "[", 2)) == index)
  names(extract) <-  c("NPI", "index",
                       "Other.Provider.Identifier",
                       "Other.Provider.Identifier.Type.Code",
                       "Other.Provider.Identifier.State",
                       "Other.Provider.Identifier.Issuer")
  # get rid of blank entries but keep if any of the four fields are non-blank
  blank.test <- apply(extract[,-1:-2], 1, paste, collapse="|")
  SELECT <- blank.test != "|||"
  extract <- extract[SELECT,]
  extract
}

# This is not particularly efficient, but only needs to be done once.
new.opi <- extract.opi.set(1)
for (i in 2:N)
{
  print(nrow(new.opi))
  flush.console()
  new.opi <- rbind(new.opi, extract.opi.set(i))
}
print(nrow(new.opi))

table(new.opi$index)

write.table(new.opi, "DATA/2014-12-10/MASTER-other-identifier.txt",
            quote=FALSE, sep="\t", row.names=FALSE)

time.2 <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.2, time.1,  units="secs"))), " secs\n")

##############################################################################

time.end <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.end, time.begin,  units="secs"))), " secs\n")
sink()

