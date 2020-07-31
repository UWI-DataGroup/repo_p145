
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_0012.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	30/07/2020
**	Date Modified: 	30/07/2020
**  Algorithm Task: Creating Walkability and SES categories


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

** Do file path

*Windows OS
*local dopath "X:/OneDrive - The University of the West Indies/Github Repositories/repo_p145"

*MAC OS
local dopath "/Users/kernrocke/OneDrive - The University of the West Indies/Github Repositories/repo_p145"

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

*Run walkability index calculation do file
do "`dopath'/Barbados_Walk/Walk_BB_008.do"

*Combine SES and walkability datasets
merge 1:1 ED using "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_medium.dta"

*Minor cleaning
rename _eigen_var SES
rename walkabilty walkability

*Create categories using deciles for walkability and SES
xtile walk_nq = walkability, nq(10)
xtile SES_nq = SES, nq(10)

*Create Walkability Categories
gen walk_cat = . 
replace walk_cat = 1 if walk_nq <=4 // Low walkability
replace walk_cat = 2 if walk_nq == 5 | walk_nq == 6 // Moderate Walkability
replace walk_cat = 3 if walk_nq >=7 // High Walkability

*Create SES Categories
gen SES_cat = . 
replace SES_cat = 1 if SES_nq <=4 	// Low SES
replace SES_cat = 2 if SES_nq == 5 | SES_nq == 6	// Medium SES
replace SES_cat = 3 if SES_nq >=7	// High SES

*Combine Walkability and SES Categories for mapping
gen walk_SES = .
replace walk_SES = 1 if walk_cat == 2 & SES_cat == 2 // Moderate Walkability and SES
replace walk_SES = 2 if walk_cat == 1 & SES_cat == 1 // Low walkability & Low SES
replace walk_SES = 3 if walk_cat == 1 & SES_cat == 3 // Low walkability & High SES
replace walk_SES = 4 if walk_cat == 3 & SES_cat == 1 // High walkability & Low SES
replace walk_SES = 5 if walk_cat == 3 & SES_cat == 3 // High walkability & High SES

*House-keeping for combined walkability and SES
label var walk_SES "Walability and SES"
label define walk_SES 1"Moderate Walkability and SES" 2"Low walkability & low SES" ///
				  3"Low walkability & high SES" 4"High Walkability & Low SES" ///
				  5"High walkability & High SES", modify
label value walk_SES walk_SES

*Tabulation of walkabilty and SES categories
tab walk_SES


*Close log file
log close

*Export Excel data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/1-input/Walkability/Walk_SES.csv", replace
