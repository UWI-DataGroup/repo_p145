clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_022.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	17/08/2020
**	Date Modified: 	17/08/2020
**  Algorithm Task: Creating new walkability index based on new intersections data (footpaths)


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150



*Set working directories

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS - Ian & Christina (Data Group)
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS - Kern & Stephanie
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"


*MAC OS - Kern
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------


*Load in Footpath Intersection data 

*Unsurfaced Footpaths
import excel "`datapath'/version01/1-input/Walkability/Intersections (Footpaths)/Unsurfaced footpaths Intersections.xlsx", sheet("Unsurfaced footpaths Intersecti") firstrow clear

keep ENUM_NO1 Intersection_Density_Unsurfaced_
rename Intersection_Density_Unsurfaced_ unsurfaced_footpaths
rename ENUM_NO1 ED

save "`datapath'/version01/2-working/Walkability/Barbados/unsurfaced_footpaths.dta", replace

*-------------------------------------------------------------------------------

*Surfaced Footpaths
import excel "`datapath'/version01/1-input/Walkability/Intersections (Footpaths)/Surfaced footpaths Intersections.xlsx", sheet("Surfaced footpaths Intersection") firstrow clear

keep ENUM_NO1 Intersection_Density_Surfaced_Fo
rename Intersection_Density_Surfaced_Fo surfaced_footpaths
rename ENUM_NO1 ED

save "`datapath'/version01/2-working/Walkability/Barbados/surfaced_footpaths.dta", replace

*-------------------------------------------------------------------------------

*Merged Footpaths
import excel "`datapath'/version01/1-input/Walkability/Intersections (Footpaths)/Merged footpaths Intersections.xlsx", sheet("Merged footpaths Intersections") firstrow clear

keep ENUM_NO1 Intersection_Density_Merged_Foot
rename Intersection_Density_Merged_Foot merged_footpaths
rename ENUM_NO1 ED

save "`datapath'/version01/2-working/Walkability/Barbados/merged_footpaths.dta", replace

*-------------------------------------------------------------------------------

*Merged Footpaths and Roads
import excel "`datapath'/version01/1-input/Walkability/Intersections (Footpaths)/Merged footpaths and roads Intersections.xlsx", sheet("Merged footpaths and roads Inte") firstrow clear

keep ENUM_NO1 Intersection_Density_Merged_Foot
rename Intersection_Density_Merged_Foot merged_road_footpaths
rename ENUM_NO1 ED

save "`datapath'/version01/2-working/Walkability/Barbados/merged_road_footpaths.dta", replace

*-------------------------------------------------------------------------------

clear

*Merge intersection data together

use "`datapath'/version01/2-working/Walkability/Barbados/unsurfaced_footpaths.dta", clear

merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/surfaced_footpaths.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/merged_footpaths.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/merged_road_footpaths.dta", nogenerate

*-------------------------------------------------------------------------------

*Merge Walkability Dataset

merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Walk_factor.dta", nogenerate

*-------------------------------------------------------------------------------

*Create z-scores for new street connectivity dataset

zscore unsurfaced_footpaths
zscore surfaced_footpaths
zscore merged_footpaths
zscore merged_road_footpaths


gen connect_unsurfaced_footpaths = 2 * z_unsurfaced_footpaths
gen connect_surfaced_footpaths = 2 * z_surfaced_footpaths
gen connect_merged_footpaths = 2 * z_merged_footpaths
gen connect_merged_road_footpaths = 2 * z_merged_road_footpaths


*Compute new walkability index
egen walk_unsurfaced = rowtotal(connect_unsurfaced_footpaths z_Res z_LUM)
egen walk_surfaced = rowtotal(connect_surfaced_footpaths z_Res z_LUM)
egen walk_merged_foot = rowtotal(connect_merged_footpaths z_Res z_LUM)
egen walk_merged_foot_road = rowtotal(connect_merged_road_footpaths z_Res z_LUM)

keep ED walkability walk_unsurfaced walk_surfaced walk_merged_foot walk_merged_foot_road

*Export Excel data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/2-working/Walkability/Barbados/Walk_index_foot.csv", replace


*Save dataset
save "`datapath'/version01/2-working/Walkability/Barbados/Walk_index_foot.dta", replace

*---------------------------------END-------------------------------------------







