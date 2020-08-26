clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_020.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	17/08/2020
**	Date Modified: 	17/08/2020
**  Algorithm Task: Area Level walkability and SES


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

** ECHORN Dataset to encrypted location

*WINDOWS OS
*local echornpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p120"

*MAC OS
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p120"

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
log using "`logpath'/version01/3-output/Walkability/walk_BB_020.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

/*
*Load in ECHORN ED individual level data
import excel "`datapath'/version01/1-input/Walkability/Barbados_ECHORN_ED.xlsx", sheet("Sheet1") firstrow clear
sort ED
destring ED, replace
drop if key == ""
save "`datapath'/version01/2-working/Walkability/walkability_ED.dta", replace

merge m:1 key using "`echornpath'/version03/02-working/survey_wave1_weighted.dta"
keep if siteid == 3
sort key
drop _merge
merge m:1 ED using "`datapath'/version01/2-working/Walkability/Walk_factor.dta"
drop if _merge == 2
drop _merge
*/

import excel "`datapath'/version01/1-input/Walkability/DMA_ED.xls", sheet("DMA_ED") firstrow
rename ENUM_NO1 ED
merge m:1 ED using "`datapath'/version01/2-working/Walkability/Walk_factor.dta"
drop _merge

*Load in walkabiltty data from encrypted location
*use "`datapath'/version01/2-working/Walkability/Walk_factor.dta

*Merge SES data from encrypted location
merge m:1 ED using "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_medium.dta", force

zscore _eigen_var 
rename z__eigen_var  z_SES
rename _eigen_var SES
gen crime_new = (crime_victim/total_pop) *100

*Bivariable regression of walkability and vehicle ownership
foreach x in walkability walkscore moveability walk_10 walk_factor {

*Linear Regression
regress `x' per_vehicle_presence
regress `x' SES 

*Multi-level mixed Effects Regression
mixed `x' SES || Parish: || DMA_Zone:, vce(robust)
mixed `x' per_vehicle_presence || Parish: || DMA_Zone:, vce(robust)

}






