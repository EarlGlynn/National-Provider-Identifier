# National Plan and Provider Enumeration System (NPPES) Downloadable File
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html

# The National Provider Identifier (NPI) File is over 50% double quotes (")
# -- over two billion double quotes -- because of the huge number of
# empty quote-delimited fields ("").

# The file contains a few tab characters, but they can safely be replaced
# with spaces using Linux command:

# Inspect lines with tabs:
#   grep -n  $'\x09' npidata_20050523-20141012.csv > tab-lines.txt

# Change tabs to spaces:
#   tr $'\x09' ' ' < npidata_20050523-20141012.csv  \
#                  > npidata_20050523-20141012-notabs.csv

# With this change, a tab-delimited file can be written to remove all
# the double quotes to make a much smaller file to work with.

# UMKC Center for Health Insights
# Earl F Glynn, 2014-11-02.

##############################################################################
### Setup

#setwd("C:/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")  ##### Modify as appropriate
setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")                  ##### Modify as appropriate

sink("1-CMS-National-Provider-Identifier-Rewrite.txt", split=TRUE)
print(Sys.time())

##############################################################################
### Read modified file (.csv)

d <- read.csv("DATA/2014-10-15/npidata_20050523-20141012-notabs.csv", colClasses="character")
dim(d)

object.size(d)
#13167691232 bytes

##############################################################################
### Write tab-separated version of file (.tsv)
write.table(d, "DATA/2014-10-15/npidata_20050523-20141012-notabs.tsv", quote=FALSE, sep="\t", row.names=FALSE)

print(Sys.time())
sink()

##############################################################################
### Subsets
writeLines(names(d), "DATA/2014-10-15/field-names.txt")

# Write file for potential use with Access
# Leave out columns that are part of mostly-empty repeating groups
SELECT <- c(1:47, 308:314)
write.table(d[,SELECT], "DATA/2014-10-15/npidata_20050523-20141012-notabs-subset.txt", quote=FALSE, sep="\t", row.names=FALSE)

writeLines(names(d)[SELECT], "DATA/2014-10-15/field-names-subset.txt")
