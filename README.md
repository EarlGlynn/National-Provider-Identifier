National Provider Identifier (NPI) Downloadable File
====================================================

File:  Dec. 10, 2014

See GitHub [repository web page](http://earlglynn.github.io/National-Provider-Identifier/) for general information about files with healthcare provider information.

That web page allows downloading the files created with the R scripts described below.


Scripts
-------

**1. File Download**

* Script:  **0-CMS-National-Provider-Identifier-Download.R**
* Output:  Directory:  DATA/yyyy-mm-dd
* Files:  NPPES_Data_Dissemination.zip, **npidata_20050523-yyyymmdd.csv**

**2. Recoding**

The original raw data is quite bloated with millions of empty fields represented by a pair of quotation marks ("").  To get rid of nearly 3 billion unnecessary quotes, the file will be re-written using tab delimiters instead of commas, but only after a small number of existing tab characters are removed.  For details, see file **1-Recoding-notes.docx**.

* Script:  **1-Recode.bash run in Linux virtual machine**
* Input:  npidata_20050523-yyyymmdd.csv
* Output:  **npidata_20050523-yyyymmdd-notabs.csv**

**3. Reduce File Size**

Remove almost 3 billion quotation marks and change the field separator from comma to tab.

* Script:  **2-CMS-National-Provider-Identifier-Rewrite.R**
* Input:  npidata_20050523-yyyymmdd-notabs.csv
* Outputs:  **npidata_20050523-yyyymmdd-notabs.txt**, npidata-taxonomy-license.txt, npidata-other-identifier.txt, **MASTER-NPPES-info.txt**

**4. Eliminate Repeating Groups**

The original raw file is not [tidy](http://vita.had.co.nz/papers/tidy-data.pdf) since two sets of different repeating groups are present.  Let's change each repeating group into a separate table with a variable number of records instead of always allocating space for a fixed number of repeating groups.

* Script:  **3-CMS-NPI-split.R**
* Inputs:  npidata-taxonomy-license.txt, npidata-other-identifier.txt
* Outputs:  **MASTER-taxonomy-license.txt**, **MASTER-other-identifier.txt**

**5. Extract Missouri Provider Addresses**

The national data is nice for research purposes, but for now the focus is only on the Missouri providers.  Let's create mailing and provider business addresses to be used in geocoding.

* Script:  **4-Missouri-Connections.R**
* Inputs:  MASTER-NPPES-info.txt
* Outputs:  NPI-Missouri-Connections-All.txt, NPI-Missouri-Practices.txt, NPI-Missouri-Practices-Mailing-Addresses.txt, **NPI-Missouri-Practices-Practice-Addresses.txt**

