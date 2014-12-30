# National Plan and Provider Enumeration System (NPPES) Downloadable File
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html

# See script 1-Recode.bash.

# With this change, a tab-delimited file can be written to remove all
# the double quotes to make a much smaller file to work with.

# UMKC Center for Health Insights
# Earl F Glynn, 2014-12-01.

##############################################################################
### Setup

setwd("C:/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")  ##### 1 / 4
#setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")

filename <- paste0("2-CMS-National-Provider-Identifier-Rewrite-",
                   format(Sys.time(), "%Y-%m-%d"), ".txt")

sink(filename, split=TRUE)
time.1 <- Sys.time()
time.1

##############################################################################
### Verify all lines can be parsed into same number of tokens.

field.counts <- count.fields("DATA/2014-12-10/npidata_20050523-20141207-notabs.csv",          ##### 2 / 4
                             quote='"', sep=",", comment.char="")
length(field.counts)
# [1] 4456578
count.table <- table(field.counts)
sum(count.table)
#[1] 4456578
count.table
#field.counts
#   329
#4456578

rm(field.counts)

##############################################################################
### Read modified file (.csv)

d <- read.csv("DATA/2014-12-10/npidata_20050523-20141207-notabs.csv",                         ##### 3 / 4
              colClasses="character")
dim(d)
#[1] 4456577     329

object.size(d)
#13285778472 bytes

##############################################################################
### Write tab-separated version of file (.txt)
write.table(d, "DATA/2014-12-10/npidata_20050523-20141207-notabs.txt",                        ##### 4 / 4
            quote=FALSE, sep="\t", row.names=FALSE)

time.2 <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.2, time.1,  units="secs"))), " secs\n")

##############################################################################
### Verify all NPIs are unique and NPI can be a database table key
nrow(d)
#[1] 4456577

length(unique(d$NPI))
#[1] 4456577

##############################################################################
### Break into three subsets:  1 (key) + 75 + 200 + 53 = 329

##############################################################################
### Healthcare.Provider.Taxonomy          (15 sets of 4 variables)
### Healthcare.Provider.Taxonomy.Group  + (15 sets of 1 variable)   [key + 75]

SELECT <- c(1, 48:107, 315:329)
length(SELECT)
names(d)[SELECT]
write.table(d[,SELECT], "DATA/2014-12-10/npidata-taxonomy-license.txt",
            quote=FALSE, sep="\t", row.names=FALSE)

##############################################################################
### Other.Provider.Identifier (50 sets of 4 variables)  [key + 200]

SELECT <- c(1, 108:307)
length(SELECT)
names(d)[SELECT]
write.table(d[,SELECT], "DATA/2014-12-10/npidata-other-identifier.txt",
            quote=FALSE, sep="\t", row.names=FALSE)

##############################################################################
### Base info [key + 53]

SELECT <- c(1:47, 308:314)
length(SELECT)
names(d)[SELECT]
write.table(d[,SELECT], "DATA/2014-12-10/MASTER-NPPES-info.txt",
            quote=FALSE, sep="\t", row.names=FALSE)

time.3 <- Sys.time()
cat(sprintf(" %.1f", as.numeric(difftime(time.3, time.2,  units="secs"))), " secs\n")
sink()

