#! /bin/bash
set -x

# UMKC Center for Health Insights
# Earl F Glynn, 2014-12-01.      

cd /mnt/hgfs/Data/US-Government/Centers-for-Medicare-and-Medicaid-Services/National-Provider-Identifier/DATA/2014-12-10

# Show lines with tabs
grep -n  $'\x09' npidata_20050523-20141207.csv > tab-lines.txt

# Changes tabs to spaces
tr $'\x09' ' ' <  npidata_20050523-20141207.csv > npidata_20050523-20141207-notabs.csv

# Now run 2-CMS-National-Provider-Identifier-Rewrite.R

