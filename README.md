National Provider Identifier (NPI) Downloadable File
====================================================

The Centers for Medicare and Medicaid Services provide a huge file of providers called by either of these names:

* [National Plan and Provider Enumeration System (NPPES) Downloadable File](http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html).

or

* [National Provider Identifier (NPI) Downloadable File](http://nppes.viva-it.com/NPI_Files.html).

The "Full Replacement Monthly NPI File" in Sept. 2014 was a 459 MB ZIP that becomes a huge 4.95 GB file when decompressed.

The complete file in Sept. 2014 had 4,384,814 observations of 329 variables.

The file is extremely bloated -- 2.8 billion of the 5.3 billion characters in the file are the double quotes (") used to surround each field in the CSV file.  The file contains 1.4 billion commas to separate the many empty fields. The several repeating groups of variables should be made into separate database tables.

R scripts
---------

**0-CMS-National-Provider-Identifier-Download.R**:  Script to download the complete monthly file and take a quick look at frequency counts of values by variable.
