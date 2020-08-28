clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Gren_Walk_004.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Grenada Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	27/08/2020
**	Date Modified: 	27/08/2020
**  Algorithm Task: IPEN and Stockton Walkability Index Computation


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
log using "`logpath'/version01/3-output/Walkability/walk_BB_020.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Import Residential and Population Density data from encrypted location
import excel "`datapath'/version01/1-input/GIS Data/Grenada_Walkability/ED_Res_Pop.xls", sheet("ED_Res_Pop") firstrow clear

*Rename ED variable
rename New_ED_ID ED

*Sort by ED
sort ED

*Save dataset
save "`datapath'/version01/2-working/Walkability/Grenada/Res_Pop_Gren.dta", replace

*-------------------------------------------------------------------------------

*Import Residential and Population Density data from encrypted location
import excel "`datapath'/version01/1-input/GIS Data/Grenada_Walkability/Intersection Density.xls", sheet("Intersection Density") firstrow clear

*Rename ED variable
rename New_ED_ID ED

*Sort by ED
sort ED

*Save dataset
save "`datapath'/version01/2-working/Walkability/Grenada/Intersection_Gren.dta", replace

*-------------------------------------------------------------------------------

*Load in Residential Density dataset
use "`datapath'/version01/2-working/Walkability/Grenada/Res_Pop_Gren.dta", clear

*Merge Intersection Density data
merge ED using "`datapath'/version01/2-working/Walkability/Grenada/Intersection_Gren.dta"

*Remove merge variable
drop _merge

*Sort by ED
sort ED

*-------------------------------------------------------------------------------

*Load in Land Use dataset
merge ED using "`datapath'/version01/2-working/Walkability/Grenada/Land_Use_Mix_Gren.dta"

*Keep built environment attributes
keep ED Perish Pop_Density Res_Density Intersection_Density ENT

*-------------------------------------------------------------------------------

*IPEN Walkability Index (Frank 2010)

*Create z-scores for built environment measures
zscore Res_Density
zscore Intersection_Density
zscore ENT

*Calculate IPEN Walkability Index (WI)
gen street_connect = 2*z_Intersection_Density
label var street_connect "Street connectivity"

egen WI = rowtotal(street_connect z_Res_Density z_ENT)
label var WI "IPEN Walkability Index"

*-------------------------------------------------------------------------------

*Stockton Walkability 

*Create deciles for built environment attributes
xtile res10 = Res_Density, nq(10)
xtile int10 = Intersection_Density, nq(10)
xtile land10 = ENT, nq(10)

egen W10 = rowtotal(res10 int10 land10)
label var W10 "Stockton Walkability"

*Export Excel data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/1-input/GIS Data/Grenada_Walkability/ED_Walkability.csv", replace

*-------------------------------------------------------------------------------
*Walkability by Parish

preserve
*Create parish variable
gen parish = .
replace parish = 1 if Perish == "Carrriacou"
replace parish = 2 if Perish == "Petite Martinique"
replace parish = 3 if Perish == "St. Andrew"
replace parish = 4 if Perish == "St. David's"
replace parish = 5 if Perish == "St. George"
replace parish = 5 if Perish == "Town of St. George"
replace parish = 6 if Perish == "St. John"
replace parish = 7 if Perish == "St. Mark"
replace parish = 8 if Perish == "St. Patrick"

label var parish "Parish"
label define parish 1"Carriacou" 2"Petite Martinique" 3"St Andrew" ///
					4"St David" 5"St George" 6"St John" 7"St Mark" ///
					8"St Patrick"
label value parish parish

collapse (mean) Pop_Density Res_Density Intersection_Density ENT WI W10, by(parish ED)

*Export Excel data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/1-input/GIS Data/Grenada_Walkability/Parish_Walkability.csv", replace

restore
*-------------------------------------------------------------------------------
