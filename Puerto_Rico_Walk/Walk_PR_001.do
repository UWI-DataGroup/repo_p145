clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_PR_001.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Puerto Rico Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/09/2020
**	Date Modified: 	06/09/2020
**  Algorithm Task: Land Use Mix Computation


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
*log using "`logpath'/version01/3-output/Walkability/walk_PR_001.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Import data from encrypted location
import excel "C:\Users\kernr\OneDrive\Desktop\land_use san juan.xlsx", sheet("land_use san juan") firstrow clear
gen area_km_build = Area_m/1000000

*Install user command
ssc install unique, replace

*List number of land uses within each ED
unique building, by(TRACTCE10) gen(number_landuse)
drop number_landuse

*Sort dataset by ED and Land use type
sort TRACTCE10 building

*Remove none EDs
drop if TRACTCE10 == ""
*-------------------------------------------------------------------------------

*Data Cleaning of Land use to match IPEN Land use categories
drop if building == "bandshell"
drop if building == "construction"
drop if building == "garage"
drop if building == "garages"
drop if building == "gazebo"
drop if building == "greenhouse"
drop if building == "hanger"
drop if building == "hut"
drop if building == "industrial"
drop if building == "parking"
drop if building == "part"
drop if building == "roof"
drop if building == "ruins"
drop if building == "stable"
drop if building == "terrace"
drop if building == "transportation"
drop if building == "warehouse"

gen land_use = .
replace land_use = 1 if building == "apartments"
replace land_use = 5 if building == "cathedral"
replace land_use = 5 if building == "chapel"
replace land_use = 5 if building == "church"
replace land_use = 2 if building == "commercial"
replace land_use = 3 if building == "concert_hall"
replace land_use = 1 if building == "dormitory"
replace land_use = 5 if building == "hospital"
replace land_use = 2 if building == "hotel"
replace land_use = 1 if building == "house"
replace land_use = 4 if building == "office"
replace land_use = 5 if building == "public"
replace land_use = 1 if building == "residential"
replace land_use = 2 if building == "commercial"
replace land_use = 2 if building == "retail"
replace land_use = 5 if building == "school"
replace land_use = 1 if building == "semidetached_house"
replace land_use = 2 if building == "service"
replace land_use = 5 if building == "university"
replace land_use = 1 if building == "yes"
	
label var land_use "IPEN Land Use Categories"
label define land_use 1"Residential" ///
					  2"Commercial" ///
					  3"Entertainment" ///
					  4"Office" ///
					  5"Institutional"				 
label value land_use land_use						

*-------------------------------------------------------------------------------

*Create variable for number of land uses within each ED
by TRACTCE10 land_use, sort: gen nvals = _n == 1
by TRACTCE10: replace nvals = sum(nvals)
by TRACTCE10: replace nvals = nvals[_N]

*Create total area of all land use types variable
rename area_km_build Landuse_area
gen Area_land_total = Landuse_area
by TRACTCE10: replace Area_land_total = sum(Area_land_total)
by TRACTCE10: replace Area_land_total = Area_land_total[_N]

*-------------------------------------------------------------------------------
*Land area by land use type 

gen Area_res = .
replace Area_res = Landuse_area if land_use == 1 // residential

gen Area_com = .
replace Area_com = Landuse_area if land_use == 2 // Commercial

gen Area_enter = .
replace Area_enter = Landuse_area if land_use == 3 // Entertainment

gen Area_office = .
replace Area_office = Landuse_area if land_use == 4 // Office

gen Area_ins = .
replace Area_ins = Landuse_area if land_use == 5 // Institutional


*-------------------------------------------------------------------------------

*Summate area land types within each ED

collapse (sum) Area_res Area_com Area_enter Area_office Area_ins , ///
				by(land_use TRACTCE10 nvals Area_land_total)

*Sort based on Enumeration District number				
sort TRACTCE10

*Replace empty land use EDs
replace land_use = 0 if land_use == .

*Reshape data for land areas within each ED for ease of calculation
reshape wide Area_res Area_com Area_enter Area_office Area_ins, i(TRACTCE10) j(land_use)

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

tabstat ENT, by(TRACTCE10) stat(mean)

*Keep only EDs and Entropy Index
keep TRACTCE10 ENT

*Creating IDs for merge within GIS
egen id = seq()

export delimited using "C:\Users\kernr\OneDrive\Desktop\ENT_San_Juan_PR_census_tract_new.csv", replace
