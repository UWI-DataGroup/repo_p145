clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_TT_003.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Trinidad Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	22/08/2020
**	Date Modified: 	22/08/2020
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

*Import data from encrypted location
import excel "`datapath'/version01/1-input/Walkability/Trinidad/TDAD_ED_TableToExcel.xlsx", sheet("TDAD_ED_TableToExcel") firstrow clear

*Merge preparation
rename OBJECTID ED_NUM

*Merge Land Use Data
merge 1:1 ED_NUM using "`datapath'/version01/2-working/Walkability/Trinidad/Land_Use_Mix_TT.dta"

*Minor merge cleaning
drop if ED_NUM == .
replace ENT = 0 if ENT == .
sum ENT Intersection_density Dwelling_Density

*Recalculate intersection and dwelling density
drop Intersection_density
gen Intersection_density = Join_Count_1/Area_km
label var Intersection_density "Intersection Density"

drop Dwelling_Density
gen Dwelling_Density = NO_DWELL/Area_km
label var Dwelling_Density "Dwelling Density"

*-------------------------------------------------------------------------------
*IPEN Walkability Index (Frank 2010)

*Create z-scores for built environment measures
zscore Dwelling_Density
zscore Intersection_density
zscore ENT

*Calculate IPEN Walkability Index (WI)
gen street_connect = 2*z_Intersection_density
label var street_connect "Street connectivity"

egen WI = rowtotal(street_connect z_Dwelling_Density z_ENT)
label var WI "IPEN Walkability Index"
*-------------------------------------------------------------------------------
*Stockton Walkability 

*Create deciles for built environment attributes
xtile res10 = Dwelling_Density, nq(10)
xtile int10 = Intersection_density, nq(10)
xtile land10 = ENT, nq(10)

egen W10 = rowtotal(res10 int10 land10)
label var W10 "Stockton Walkability"

*Keep only EDs and Entropy Index
keep ED_NUM Dwelling_Density Intersection_density ENT WI W10

*Export Excel data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/1-input/Walkability/Trinidad/ED_Walkability.csv", replace
