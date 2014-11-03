# National Plan and Provider Enumeration System (NPPES) Downloadable File
# http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html
# "Full Replacement Monthly NPI File" downloaded from here:  http://nppes.viva-it.com/NPI_Files.html

# Can R's fast data.table be used to read this huge file?

# UMKC Center for Health Insights
# Earl F Glynn, 2014-11-02.

##############################################################################
### Setup

setwd("E:/FOIA/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/")       ##### Modify as appropriate

sink("0-CMS-NPI-data-table.txt", split=TRUE)
print(Sys.time())

##############################################################################
### Read data table

library(data.table)
dt <- fread("DATA/2014-10-15/npidata_20050523-20141012.csv")
dim(dt)
print(Sys.time())

object.size(d)

sink()

