
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_001.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	26/07/2020
**	Date Modified: 	27/07/2020
**  Algorithm Task: Creationn of Walkability Indices


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
log using "`logpath'/version01/3-output/Walkability/walk_BB_001.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Import Data Table from encrypted location
import excel "`datapath'/version01/1-input/Walkability/ED_landuse_Data.xlsx", sheet("ED_landuse_TableToExcel_1") firstrow clear

*Install user command
ssc install unique, replace

*List number of land uses within each ED
unique LANDUSE, by(ENUM_NO1) gen(number_landuse)
drop number_landuse

*Sort dataset by ED and Land use type
sort  ENUM_NO1 LANDUSE

*-------------------------------------------------------------------------------

*Data Cleaning of Land use to match IPEN Land use categories

drop if LANDUSE == "VACANT"
drop if LANDUSE == "TRANSPORTATION"
drop if LANDUSE == "RESOURCE EXTRACTION"
drop if LANDUSE == "NATURAL FEATURES"
drop if LANDUSE == "MARINA & JETTIES"
drop if LANDUSE == "LIGHT INDUSTRY"
drop if LANDUSE == "LAND FILL"
drop if LANDUSE == "HEAVY INDUSTRY"
drop if LANDUSE == "AGRICULTURE"

gen land_use = .
replace land_use = 1 if LANDUSE == "RESIDENTIAL-HIGH DEN" // Residential
replace land_use = 1 if LANDUSE == "RESIDENTIAL-LOW DENS" // Residential
replace land_use = 2 if LANDUSE == "COMMERCIAL" // Commercial
replace land_use = 2 if LANDUSE == "MAJOR RETAIL" // Commercial
replace land_use = 3 if LANDUSE == "PRIVATE GOLF COURSE" // Entertainment
replace land_use = 3 if LANDUSE == "TOURISM" // Entertainment
replace land_use = 3 if LANDUSE == "BEACH" // Entertainment
replace land_use = 4 if LANDUSE == "OFFICE" // Office
replace land_use = 5 if LANDUSE == "PUBLIC INSTITUTION" // Instutional

label var land_use "IPEN Land Use Categories"
label define land_use 1"Residential" ///
					  2"Commercial" ///
					  3"Entertainment" ///
					  4"Office" ///
					  5"Institutional"				 
label value land_use land_use					  

*-------------------------------------------------------------------------------

*Create variable for number of land uses within each ED
by ENUM_NO1 LANDUSE, sort: gen nvals = _n == 1
by ENUM_NO1: replace nvals = sum(nvals)
by ENUM_NO1: replace nvals = nvals[_N]

drop Proportion

/*
drop if LANDUSE == "VACANT"
drop if LANDUSE == "RESOURCE EXTRACTION"
drop if LANDUSE == "NATURAL FEATURES"
drop if LANDUSE == "MARINA & JETTIES"
drop if LANDUSE == "LANDFILL"
drop if LANDUSE == "HEAVY INDUSTRY"
drop if LANDUSE == "AGRICULTURE"
*/

*Create new proporiton variable
gen Proportion = Area_land / Area_1


gen p = Proportion
by ENUM_NO1: replace p = sum(p)
by ENUM_NO1: replace p = p[_N]

gen percentage = Proportion / p

gen t_old = (Proportion * ln(Proportion) )/ ln(nvals)
gen t = (percentage * ln(percentage) )/ ln(nvals)

collapse (sum) t t_old, by(ENUM_NO1)
replace t = -1*t
replace t_old = -1*t_old
sort ENUM_NO1

browse ENUM_NO1 t t_old 

*Close log file
log close
