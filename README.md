National Provider Identifier (NPI) Downloadable File
====================================================

File:  Dec. 10, 2014

The Centers for Medicare and Medicaid Services provide a huge file of healthcare providers called by either of these names:

* [National Plan and Provider Enumeration System (NPPES) Downloadable File](http://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/DataDissemination.html).

or

* [National Provider Identifier (NPI) Downloadable File](http://nppes.viva-it.com/NPI_Files.html).

The "Full Replacement Monthly NPI File" was a 484 MB ZIP that becomes a huge 5.03 GB file when decompressed.

The complete file had 4,456,577 observations of 329 variables.

The file is extremely bloated -- 2.9 billion of the 5.4 billion characters in the file are double quotes (") used to surround each field in the CSV file.  The file contains nearly 1.5 billion commas to separate the many empty fields. The two repeating groups of variables were made into separate database tables.


Scripts
-------

**0-CMS-National-Provider-Identifier-Download.R**:  Script to download the complete monthly file.

**1-Recode.bash**:  Bash script to remove the few tabs (x09 characters) from file, so file can be rewritten with tab-delimiters and no quote field delimiters.

**2-CMS-National-Provider-Identifier.Rewrite.R**:  After removing a few dozen tabs from the original file, the file is re-written with a tab separator and no quote delimiters to reduce the size to about 2.3 GB (instead of over 5 GB).  A separate **MASTER-NPPES-info.txt** file is created, which is intended to be a database table of 54 fields.

**3-CMS-NPI-split.R**:  The original file contains two sets of repeating groups. One can have up to 15 repeating groups, the other up to 50. To normalize the data and reduce the huge waste of space to store no data, this script creates two new files intended to be database tables:  **MASTER-taxonomy-license.txt** and **MASTER-other-identifier.txt**.

**4-Missouri-Connections.R**:  Find providers with Missouri connections.


The file **NPPES-NPI-Overview.docx** gives some additional details.

