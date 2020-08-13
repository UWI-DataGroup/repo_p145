
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_015.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	08/08/2020
**	Date Modified: 	08/08/2020
**  Algorithm Task: Analysis of Walkscore by ED


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Setting working directory

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Walkability/walk_BB_007.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Import Data Table from encrypted location

import delimited "`datapath'/version01/1-input/Walkability//ED_Walkscore.csv", clear

*Cleaning data
rename v4 longitude
rename lat latitude
rename parishnam1 parish
rename enum_no1 ED

label var latitude "Latitude"
label var longitude "Longitude"
label var parish "Parish"

*Create categories for walkscore

gen walk_cat = .
replace walk_cat = 1 if walkscore<=24
replace walk_cat = 2 if walkscore>=25 & walkscore<=49
replace walk_cat = 3 if walkscore>=50 & walkscore<=69
replace walk_cat = 4 if walkscore>=70 & walkscore<=89
replace walk_cat = 5 if walkscore>=90

label var walk_cat "Walkscore Categories"
label define walk_cat 1"Car Dependent (Almost all erands require a car)" ///
					  2"Car Dependent (Most errands require a car)" ///
					  3"Somewhat Walkable" ///
					  4"Very Walkable" ///
					  5"Walker's Paradise"
label value walk_cat walk_cat

tab walk_cat
tab parish walk_cat, row

*Save dataset
save "`datapath'/version01/2-working/Walkability/Walk_score.dta", replace
