clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_026.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	01/10/2020
**	Date Modified: 	05/11/2020
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

*WINDOWS OS Alternative
*local datapath "X:/The UWI - Cave Hill Campus//DataGroup - repo_data/data_p145

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS Alternative
*local logpath "X:/The UWI - Cave Hill Campus//DataGroup - repo_data/data_p145

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

*WINDOWS OS Alternative
*local outputpath "X:/The UWI - Cave Hill Campus//DataGroup - repo_data/data_p145

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Walkability/walk_BB_026.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

/*
Using the framework/logic model of Zungia-Terran 2017 this walkability index will 
include the following constructs

1) Street Connectivity - Road and footpath Intersection density Bus stop density
2) Land Use - Land Use mix estimated using entropy index
3) Density - Residential (household/dwelling) density; Population density
4) Surveillance - Lighting Pole density
5) Greenspace - Park density; Open green space density; slope
6) Traffic Safety - Pedestrian crossing density; Roundabout density
7) Community - Sporting Facility density; Playground density
8) Parking - Parking density
9) Experience - Slope


Note: Attributes for Parking and Experience constructs were not measured at the 
macroscale level.

*/

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

*-------------------------------------------------------------------------------

*Import Traffic Calming Features data (Roundabout and Pedestrian Crossing) by ED from encrypted location
import excel "`datapath'/version01/1-input/Walkability/Traffic Calming ED.xlsx", sheet("Traffic Calming ED") firstrow clear

*Minor data cleaning
rename ENUM_NO1 ED
rename Join_Count Cross_round
label var Cross_round "Number of Pedestrian Crossing and Roundabouts by ED"
keep ED Cross_round
*Save dataset
save "`datapath'/version01/2-working/Walkability/Traffic_Calming_Barbados.dta" , replace

*-------------------------------------------------------------------------------

*Import light pole density by ED data from encrypted location
import delimited "`datapath'/version01/1-input/Walkability/Light Pole Density.csv", clear

*Minor data cleaning
rename enum_no1 ED
rename numpoints light_poles
label var light_poles "Number of light poles"
keep ED light_poles

*Save light poles dataset
save "`datapath'/version01/2-working/Walkability/Light_poles_Barbados.dta", replace

*Merge data from encrypted location
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Destination_Density.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Slope_Barbados.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Traffic_Calming_Barbados.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/parking.dta", nogenerate

*Create light pole density by ED
gen light_density = light_poles/Area
label var light_density "Light Pole Density"

*Create traffic calming features density by ED
gen traffic_calm = Cross_round/Area
label var traffic_calm "Traffic Calming Features Density"

gen parking_density = parking/Area
label var parking_density "Parking Density"

*-------------------------------------------------------------------------------

*Principle Component Analysis Model for new walkability index
pca Sport_Density Playground_Density Greenspace_Density Road_Foot_I_Density ///
	LUM Residential pop_density light_density slope traffic_calm ///
	parking_density, components(3)
	
screeplot, yline(1)
estat kmo
rotate, varimax components(3) blank(0.3)
predict com1 com2 com3
egen factor = rowtotal(com1 com2 com3)

*Create z scores for light pole density, slope and traffic calming
zscore light_density
zscore slope
zscore traffic_calm
zscore parking_density

pca z_Road_Foot_I_Density z_Sport_Density z_Playground_Density ///
	z_Greenspace_Density z_LUM z_Residential z_Bus_Stop_Density ///
	z_pop_density z_light_density z_slope z_traffic_calm ///
	z_parking_density, components(3)
	
rotate, varimax components(3) blank(0.3)
predict z1 z2 z3
egen z_factor1 = rowtotal(z1 z2 z3)
zscore factor
zscore walkability_road_foot 

graph hbox z_factor z_factor1 z_walkability_road_foot z_walkscore z_moveability z_walk_10 z_walk_factor
graph hbox z_factor z_walkability_road_foot z_walkscore z_moveability z_walk_10 z_walk_factor, nooutsides

keep ED factor traffic_calm Area

*Save dataset
save "`datapath'/version01/2-working/Walkability/PCA_Data_Walk_Barbados.dta", replace

*Export data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/2-working/Walkability/Barbados/PCA_Walkability.csv", replace

*------------------------END----------------------------------------------------

*Close log file
log close 
