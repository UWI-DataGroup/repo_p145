
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_008.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	29/07/2020
**	Date Modified: 	29/07/2020
**  Algorithm Task: Walkability Index Calculation


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
import excel "`datapath'/version01/1-input/Walkability/Walkability.xls", sheet("Walkability") firstrow clear


*Data Cleaning
keep ED_Boundary_2010_SpatialJoinENU Walkability_EDPARISHNAM1 ED_Boundary_2010_SpatialJoinInt ED_Entropy_IndexcsvENT Residential_DensityResidential_
rename ED_Boundary_2010_SpatialJoinENU ED
rename Walkability_EDPARISHNAM1 Parish_name
rename ED_Boundary_2010_SpatialJoinInt Intersection
rename ED_Entropy_IndexcsvENT LUM
rename Residential_DensityResidential_ Residential

*Create Parish variable
encode Parish_name, gen(Parish)
label var Parish "Parish"
drop Parish_name

*Create Intersection Density z-score
sum Intersection
return list
gen z_InD = 2*((Intersection-r(mean))/r(sd))
label var z_InD "Intersection Density z-score"
replace Intersection = 0 if Intersection == .

*Create Land Use mix z-score
sum LUM
return list
gen z_LUM = (LUM-r(mean))/r(sd)
label var z_LUM "Land Use mix z-score"

*Create Residential Density z-score
sum Residential
return list
gen z_Res = (Residential-r(mean))/r(sd)
label var z_Res "Res Density z-score"

*Descriptives for z scores
sum z_InD z_LUM z_Res

*Create walkability index using Frank (2010) formulae
egen walkability = rowtotal(z_InD z_Res z_LUM)
label var walkability "Walkability Index"

*Descriptives for Walkability Index by ED
tabstat walkability , by(Parish) stat(mean)


*Close log file
log close

*Export Excel data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/1-input/Walkability/Walk_index.csv", replace

*Save dataset
save "`datapath'/version01/2-working/Walkability/Walk_index.dta", replace


