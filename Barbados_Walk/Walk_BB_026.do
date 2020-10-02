clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_026.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	01/10/2020
**	Date Modified: 	02/10/2020
**  Algorithm Task: Creating new walkability index using Walkability Framework


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
log using "`logpath'/version01/3-output/Walkability/walk_BB_026.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Import Slope data by ED from encryped location
import excel "`datapath'/version01/1-input/Walkability/Barbados_Slope_ED_SJoin.xlsx", sheet("Barbados_Slope_ED_SJoin") firstrow clear

*Minor data cleaning
rename ENUM_NO1 ED
rename grid_code percent_rise
collapse (mean) percent_rise, by(ED)
rename percent_rise slope
label var slope "Slope Percentage Rise"
*Save dataset
save "`datapath'/version01/2-working/Walkability/Slope_Barbados.dta" , replace

*Import light pole density by ED data from encrypted location
import delimited "`datapath'/version01/1-input/Walkability/Light Pole Density.csv", clear

*Minor data cleaning
rename enum_no1 ED
rename numpoints light_poles
label var light_poles "Number of light poles"
keep ED light_poles

*Merge data from encrypted location
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Destination_Density.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Slope_Barbados.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.dta", nogenerate


*Create light pole density by ED
gen light_density = light_poles/Area
label var light_density "Light Pole Density"

pca Sport_Density Playground_Density Greenspace_Density Road_Foot_I_Density ///
	LUM Residential pop_density light_density slope, components(3)
	
screeplot, yline(1)
rotate, varimax components(3) blank(0.3)
predict com1 com2 com3
egen factor = rowtotal(com1 com2 com3)


pca z_Road_Foot_I_Density z_Sport_Density z_Playground_Density z_Greenspace_Density z_LUM z_Residential z_Bus_Stop_Density z_pop_density z_light_density z_slope, components(3)
rotate, varimax components(3) blank(0.3)
predict z1 z2 z3
egen z_factor1 = rowtotal(z1 z2 z3)
zscore factor
zscore walkability_road_foot 

graph hbox z_factor z_factor1 z_walkability_road_foot z_walkscore z_moveability z_walk_10 z_walk_factor
graph hbox z_factor z_walkability_road_foot z_walkscore z_moveability z_walk_10 z_walk_factor, nooutsides

keep ED factor

*Export data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/2-working/Walkability/Barbados/PCA_Walkability.csv", replace

*------------------------END----------------------------------------------------
