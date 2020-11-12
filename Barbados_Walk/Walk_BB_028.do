clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_028.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	25/09/2020
**	Date Modified: 	01/10/2020
**  Algorithm Task: Create different walkability measures using road and footpath data


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
log using "`logpath'/version01/3-output/Walkability/walk_BB_028.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Load in walkability index with road and footpath intersections
use "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.dta"

*Minor cleaning
keep ED Road_Foot_I_Density LUM Residential walkscore Destination_Density Bus_Stop_Density pop_density walkability_road_foot Destination_Density urbanization Area

*Create z-scores
zscore Road_Foot_I_Density LUM Residential Destination_Density urbanization Bus_Stop_Density pop_density
rename z_Road_Foot_I_Density z_Intersection

*Create connectivity variable
egen connectivity = rowtotal(z_Intersection z_Bus_Stop_Density)
replace connectivity = 1/2*(connectivity)
label var connectivity "Street Connectivity"

*Create Moveability Index
egen moveability = rowtotal(connectivity urbanization Destination_Density)
replace moveability = 1/3*(moveability)
label var moveability "Moveability Index"

*Create decile categories
xtile Res_10 = Residential, nq(10)
xtile LUM_10 = LUM, nq(10)
xtile Int_10 = Road_Foot_I_Density , nq(10)

*Walkability using deciles
egen walk_10 = rowtotal(Res_10 LUM_10 Int_10)



*Merge data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/PCA_Data_Walk_Barbados.dta", nogenerate

*Data Cleaning
rename walkability_road_foot walkability
keep ED walkability walkscore moveability walk_10 factor

label var ED "Enumeration Districts"
label var walk_10 "Walkability Index based on deciles"
label var factor "Data-driven Walkability"

*Create new z-scores for walkability indices
zscore walkscore walkability moveability walk_10 factor


*Examine differences between measures
graph hbox z_walkability z_walkscore z_moveability z_walk_10 z_factor, nooutsides


#delimit;
graph hbox z_walkability z_walkscore z_moveability z_walk_10 z_factor, 

		legend(order(1 "IPEN Walkability" 2 "Walk Score" 
						3 "Moveability" 4 "Walkability in deciles" 
						5 "Data-driven Walkability")) 
		nooutsides 
		title("Comparison of Walkability Measures", color(black) size(large)) 
		note("") 
		ytitle("Z-score")
		ylab(, nogrid)
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))

    ;
#delimit cr








