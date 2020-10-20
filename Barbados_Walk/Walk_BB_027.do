
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_027.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	19/10/2020
**	Date Modified: 	19/10/2020
**  Algorithm Task: Creating Walkability and SES Categories for Mapping


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
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Walkability/walk_BB_027.log",  replace

*-------------------------------------------------------------------------------

*Load data into encrypted location
use "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.dta", clear

*Merge SES data from encrypted location
merge m:1 ED using "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_medium.dta", force

zscore _eigen_var 
rename z__eigen_var  z_SES
rename _eigen_var SES
gen crime_new = (crime_victim/total_pop) *100

keep ED parish SES walkability_road_foot

xtile walk = walkability_road_foot, nq(10)
xtile SES_10 = SES, nq(10)

gen walk_SES = .
replace walk_SES = 1 if walk <=4 & SES_10<=4 // Low walkability & Low SES
replace walk_SES = 2 if walk <=4 & SES_10>=7 // Low walkability & High SES
replace walk_SES = 3 if walk >=7 & SES_10<=4 // High walkability & Low SES
replace walk_SES = 4 if walk >=7 & SES_10>=7 // High walkability & High SES

label var walk_SES "Walkability & SES"
label define walk_SES 1"Low walkability and Low SES" ///
					  2"Low walkability and High SES" ///
					  3"High walkability and Low SES" ///
					  4"High walkability and High SES"
label value walk_SES walk_SES


*Export data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/2-working/Walkability/Barbados/Walkability_SES.csv", replace

*------------------------END----------------------------------------------------


*Close log file
log close




