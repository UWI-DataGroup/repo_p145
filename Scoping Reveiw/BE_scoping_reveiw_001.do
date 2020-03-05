** HEADER -----------------------------------------------------

*Clear screen
cls

*DO FILE META DATA
    //  algorithm name          BE_scoping_review_001
    //  project:                PhD Streetscapes
    //  analysts:               JKern ROCKE
    //  date first created      04-MAR-2020
    // 	date last modified      04-MAR-2020
    //  algorithm task          Determination of total title/abstract screen by on time period
    //  status                  Completed
    //  objective               To determine the number of articles to screen based on time period
    //  methods                 Create descriptive tables and graphs to be used for PhD manuscript

** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
	
	
/*
NOTE: Articles retreived from the following databases based on the time period of 2000-2019
1) PubMed(Medline), 
2) Web of Science, 
3) LILACS, 
4) EBSCO Host, 
5) IBECS, 
6) TRID (Transport Research Information Database), 
7) ITRD (International Transport Research Documentation Database) 
8) RIP (Research in Progress database)
	
*/
	
*Open article dataset 
import excel "`datapath'/version01/1-input/Scoping Review/scoping_review.xlsx", sheet("scoping_review") firstrow clear

*--------------------------------BEGIN------------------------------------------

*-------------------------------------------------------------------------------

*2000-2019
preserve
drop if year==2020
duplicates report title
duplicates drop title, force
count
tab year
restore

*-------------------------------------------------------------------------------

*2005-2019
preserve
keep if year>=2005
drop if year==2020
duplicates report title
duplicates drop title, force
count
tab year
restore

*-------------------------------------------------------------------------------

*2010-2019
preserve
keep if year>=2010
drop if year==2020
duplicates report title
duplicates drop title, force
count
tab year
restore


*-------------------------------------------------------------------------------

*2015-2019
preserve
keep if year>=2015
drop if year==2020
duplicates report title
duplicates drop title, force
count
tab year
restore


*-------------------------------------------------------------------------------


*-----------------------------------END-----------------------------------------
