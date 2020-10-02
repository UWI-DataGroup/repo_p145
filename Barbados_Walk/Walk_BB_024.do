
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_024.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	25/09/2020
**	Date Modified: 	01/10/2020
**  Algorithm Task: Road and Footpath Walkability Computation


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
log using "`logpath'/version01/3-output/Walkability/walk_BB_024.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------


*Merged Footpath (Unsurfaced & Surfaced Footpaths)
import excel "`datapath'/version01/2-working/Walkability/Barbados/Footpath_street_connectivity.xlsx", sheet("Footpath_street_connectivity") firstrow clear
keep ENUM_NO1 Intersection_Density
rename ENUM_NO1 ED
rename Intersection_Density Foot_Int_Density 
label var Foot_Int_Density "Footpath Intersection Density"
zscore Foot_Int_Density
gen foot_connect = 2 * z_Foot_Int_Density
save "`datapath'/version01/2-working/Walkability/Barbados/Footpath_street_connectivity.dta", replace

*Merged Road and Footpath (Unsurfaced & Surfaced Footpaths)
import excel "`datapath'/version01/2-working/Walkability/Barbados/Road_Footpath_Street_Connectivity.xlsx", sheet("Road_Footpath_Street_Connectivi") firstrow clear
keep ENUM_NO1 Intersection_Density
rename ENUM_NO1 ED
rename Intersection_Density Road_Foot_I_Density 
label var Road_Foot_I_Density  "Road and Footpath Intersection Density"
zscore Road_Foot_I_Density 
gen road_foot_connect = 2 * z_Road_Foot_I_Density
save "`datapath'/version01/2-working/Walkability/Barbados/Road_Footpath_Street_Connectivity", replace

*Merge data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/Footpath_street_connectivity.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Walk_factor.dta", nogenerate

*Create new walkability indices
egen walkability_footpath = rowtotal(z_LUM z_Residential foot_connect)
label var walkability_footpath "Walkability Index (Footpaths)
egen walkability_road_foot = rowtotal(z_LUM z_Residential road_foot_connect)
label var walkability_road_foot "Walkability Index (Rooad & Footpaths)"

*Compare walkability measures
tabstat walkability walkability_footpath walkability_road_foot, stat(mean sd median iqr min max) col(stat) long
graph hbox walkability walkability_footpath walkability_road_foot, nooutside

*Save dataset to encrypted location
save "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.dta", replace

keep ED walkability walkability_footpath walkability_road_foot

*Export data to encrypted location for GIS Mapping
export delimited using "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.csv", replace

sort ED
*Ranking of walkability indices 			
egen rank_walkability = rank(-walkability)
label var rank_walkability "Ranking of Walkability Index (Road)"

egen rank_walkability_footpath = rank(-walkability_footpath)
label var rank_walkability_footpath "Ranking of Walkability Index (Footpath)"

egen rank_walkability_road_foot = rank(-walkability_road_foot)
label var rank_walkability_road_foot "Ranking of Walkability Index (Road & Footpath)"



