clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_017.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	11/08/2020
**	Date Modified: 	11/08/2020
**  Algorithm Task: Creating Moveability Index


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
log using "`logpath'/version01/3-output/Walkability/walk_BB_017.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Import data from encrypted location
import excel "`datapath'/version01/1-input/Walkability/Destination Density.xls", sheet("Destination Density") firstrow

*Data Cleaning
keep PARISHNAM1 ENUM_NO1_1 Playground_Density Greenspace_Density Sport_Density Destination_Density
rename ENUM_NO1_1 ED
sort ED
rename PARISHNAM1 parish
collapse (mean) Sport_Density Playground_Density Greenspace_Density Destination_Density, by(ED parish)

label var ED "Enumeration District"
label var parish "Parish"
label var Sport_Density "Sport Facility Density"
label var Playground_Density "Playground Density"
label var Greenspace_Density "Green Space Density"
label var Destination_Density "Destination Density"


*Create z-score varibales
zscore Sport_Density
zscore Playground_Density
zscore Greenspace_Density

*Create new Destination Density variable
drop Destination_Density
egen Destination_Density = rowtotal(z_Sport_Density z_Playground_Density z_Greenspace_Density)
replace Destination_Density = 1/3*(Destination_Density)
label var Destination_Density "Destination Density"

sum Destination_Density, detail
tabstat Destination_Density, by(parish) stat(mean median)

*Save dataset in encrypted location
save "`datapath'/version01/2-working/Walkability/Destination_Density.dta", replace

*-------------------------------------------------------------------------------
*Import bus stop density
import excel "`datapath'/version01/1-input/Walkability/BusStop Density.xls", sheet("BusStop Density") firstrow clear

*Data Cleaning
rename Density Bus_Stop_Density
label var Bus_Stop_Density "Bus Stop Density"
rename ENUM_NO1 ED
label var ED "Enumeration Districts"
rename PARISHNAM1 parish 
label var parish "Parish"
keep ED parish Area Bus_Stop_Density

*Save Dataset in encrypted location
save "`datapath'/version01/2-working/Walkability/BusStop_Density.dta", replace

*-------------------------------------------------------------------------------
*Open Denstination Density dataset
use "`datapath'/version01/2-working/Walkability/Destination_Density.dta", clear

*Merge walkability index attributes for Land Use Mix, Street Connectivity and Residential Density
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Walk_index.dta", nogenerate

keep ED parish Destination_Density Intersection LUM Residential

label var Intersection "Intersection Density"
label var LUM "Land Use Mix - Entropy Index"
label var Residential "Residential Density"

*Create z-score variables
zscore Intersection
zscore LUM
zscore Residential

*Create Level of urbanization variable
egen urbanization = rowtotal(z_LUM z_Residential)
replace urbanization = 1/2*(urbanization)
label var urbanization "Level of urbanization"

*Merge Bus Stop Density
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/BusStop_Density.dta", nogenerate

*Create z-score for bus stop density
zscore Bus_Stop_Density

*Create Street Connectivity
egen connectivity = rowtotal(z_Intersection z_Bus_Stop_Density)
replace connectivity = 1/2*(connectivity)
label var connectivity "Street Connectivity"

*-------------------------------------------------------------------------------
*Creating moveability Index
egen moveability = rowtotal(connectivity urbanization Destination_Density)
replace moveability = 1/3*(moveability)
label var moveability "Moveability Index"

*Summary stats of moveability index
sum moveability, detail
tabstat moveability, by(parish) stat(mean median iqr min max)

*-------------------------------------------------------------------------------

*Save dataset
save "`datapath'/version01/2-working/Walkability/Moveability_index.dta", replace

*Export csv file for Mapping in ArcGIS Pro
export delimited ED moveability using "`datapath'/version01/3-output/Walkability/moveability_index.csv", replace

*Close log file
log close
