National Provider Identifier (NPI) Downloadable File
====================================================

File:  Oct. 15, 2014

The Centers for Medicare and Medicaid Services provide a huge file of providers called by either of these names:

* [National Plan and Provider Enumeration System (NPPES) Downloadable File](http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html).

or

* [National Provider Identifier (NPI) Downloadable File](http://nppes.viva-it.com/NPI_Files.html).

The "Full Replacement Monthly NPI File" was a 462 MB ZIP that becomes a huge 4.98 GB file when decompressed.

The complete file had 4,416,197 observations of 329 variables.

The file is extremely bloated -- 2.9 billion of the 5.3 billion characters in the file are double quotes (") used to surround each field in the CSV file.  The file contains 1.4 billion commas to separate the many empty fields. The several repeating groups of variables should be made into separate database tables.


R scripts
---------

**0-CMS-National-Provider-Identifier-Download.R**:  Script to download the complete monthly file and take a quick look at frequency counts of values by variable.

**0-CMS-NPI-data-table.R**:  R's new speedy data.table fails to load the file.

**1-CMS-National-Provider-Identifier.Rewrite.R**:  After removing a few dozen tabs (x09 characters) from the original file, the file is re-written with a tab separator and no quote delimiters to reduce the size to about 2.3 GB (instead of almost 5 GB).  A subset file is also created, which is small enough to be processed by Access.


Summary
-------

Using the subset, 42 of 329 fields were loaded into Access NPI table:  4,416,196 records

Summary of Access queries

**Organizations**

 * 1,035,094 all
 * 707,546 unique addresses (includes room, suite, box number, …)
 * 13,379 MO unique addresses

**People**

 * 3,310,313 all
 * 1,976,415 unique addresses (includes room, suite, box number, …)
 * 31,220 MO unique addresses

