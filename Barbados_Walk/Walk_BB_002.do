
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_002.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	26/07/2020
**	Date Modified: 	28/07/2020
**  Algorithm Task: Land use mix - Entropy Index Calculation


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
drop Proportion

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
drop if LANDUSE == "PUBLIC OPEN SPACE"

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
by ENUM_NO1 land_use, sort: gen nvals = _n == 1
by ENUM_NO1: replace nvals = sum(nvals)
by ENUM_NO1: replace nvals = nvals[_N]

*Create total area of all land use types variable
gen Area_land_total = Area_land
by ENUM_NO1: replace Area_land_total = sum(Area_land_total)
by ENUM_NO1: replace Area_land_total = Area_land_total[_N]

*-------------------------------------------------------------------------------
*Land area by land use type 

gen Area_res = .
replace Area_res = Area_land if land_use == 1 // residential

gen Area_com = .
replace Area_com = Area_land if land_use == 2 // Commercial

gen Area_enter = .
replace Area_enter = Area_land if land_use == 3 // Entertainment

gen Area_office = .
replace Area_office = Area_land if land_use == 4 // Office

gen Area_ins = .
replace Area_ins = Area_land if land_use == 5 // Institutional

*-------------------------------------------------------------------------------

*Summate area land types within each ED

collapse (sum) Area_res Area_com Area_enter Area_office Area_ins , ///
				by(land_use ENUM_NO1 nvals Area_land_total)

*Sort based on Enumeration District number				
sort ENUM_NO1

*Reshape data for land areas within each ED for ease of calculation
reshape wide Area_res Area_com Area_enter Area_office Area_ins, i(ENUM_NO1) j(land_use)

*Remove empty variables
drop Area_enter1 Area_office1 Area_ins1 Area_res2 Area_enter2 Area_office2 ///
	 Area_ins2 Area_res3 Area_com3 Area_office3 Area_ins3 Area_res4 Area_com4 ///
	 Area_enter4 Area_ins4 Area_res5 Area_com5 Area_enter5 Area_office5 ///
	 Area_com1

*Rename variables for ease of analysis for loop algorithm
rename Area_res1 Area_res
rename Area_com2 Area_com
rename Area_enter3 Area_enter
rename Area_office4 Area_office
rename Area_ins5 Area_ins

/*Create Proportion of land area for each land use - 
land area (specfic land use)/Total land area for all land use types

Note: Land use types: Residential, Commercial/Retail, Entertainment, Office and
	  Public Institutions
*/
gen res = Area_res/Area_land_total
gen com = Area_com/Area_land_total
gen enter = Area_enter/Area_land_total
gen office = Area_office/Area_land_total
gen ins = Area_ins/Area_land_total

*Loop for creating log proportion land use variables and Proportion land use x log propotion land use
foreach x in res com enter office ins {

	gen ln_`x' = ln(`x')
	
	gen pi_`x' = `x'* ln_`x'
	
	}

*Create variable summing all land use types estimated proportion land use
egen pi_pre = rowtotal(pi_res pi_com pi_enter pi_office pi_ins)

*Create inverse summation for final step
gen pi_final = -1*pi_pre

*Final caluclation of Entropy Index
gen ENT = pi_final/ (ln(nvals))
label var ENT "Entropy Land use mix Index"

*Important note: ENT should range between 0 and 1

*Replace empty values with 0
replace ENT = 0 if ENT == .

*Descriptives of ENT
tabstat ENT, stat(mean median min max)

tabstat ENT, by(ENUM_NO1) stat(mean)

*Close log file
log close
