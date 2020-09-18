clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_TT_002.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Trinidad Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	22/08/2020
**	Date Modified: 	22/08/2020
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
log using "`logpath'/version01/3-output/Walkability/walk_TT_002.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Import data from encrypted location
import excel "`datapath'/version01/1-input/Walkability/Trinidad/Land_Use_ED.xls", sheet("Land_Use_ED") firstrow clear

*Install user command
ssc install unique, replace

*List number of land uses within each ED
unique POLICY, by(ED_NUM) gen(number_landuse)
drop number_landuse

*Sort dataset by ED and Land use type
sort  ED_NUM POLICY

*Remove none EDs
drop if ED_NUM == 0
*-------------------------------------------------------------------------------

*Data Cleaning of Land use to match IPEN Land use categories

drop if POLICY == "Agricultural 0.4ha" 
drop if POLICY == "Agricultural 2ha" 
drop if POLICY == "Agriculture" 
drop if POLICY == "Arena Forest Reserve" 
drop if POLICY == "Arima Forest Reserve" 
drop if POLICY == "Arima Reserve" 
drop if POLICY == "Blanchisseuse Reserve" 
drop if POLICY == "Brigand Hill Reserves" 
drop if POLICY == "Cap De Ville Reserve" 
drop if POLICY == "Caroni Arena Dam" 
drop if POLICY == "Cedros Reserve" 
drop if POLICY == "Erin Reserve"
drop if POLICY == "Forest Reserve" 
drop if POLICY == "Godineau Swamp" 
drop if POLICY == "Hollis Reservoir" 
drop if POLICY == "Homestead" 
drop if POLICY == "Las Cuevas Forest Reserve"
drop if POLICY == "Las Cuevas Reserve"
drop if POLICY == "Long Stretch Reserve"
drop if POLICY == "Los Blanquizales Lagoon"
drop if POLICY == "Manzanilla Reserve" 
drop if POLICY == "Marina/Berthing" 
drop if POLICY == "Matura Reserve" 
drop if POLICY == "Melajo Reserve" 
drop if POLICY == "Morne L'Enfer Reserve" 	
drop if POLICY == "Nariva Windbelt Reserve" 
drop if POLICY == "Nature Reserve" 
drop if POLICY == "Navet Dam" 
drop if POLICY == "Open Space" 
drop if POLICY == "Paria Forest Reserve" 
drop if POLICY == "Pasturage"        
drop if POLICY == "Quarrying" 
drop if POLICY == "Rousillac Swamp"
drop if POLICY == "San Pedro Reserves"
drop if POLICY == "Siparia Reserve"
drop if POLICY == "St. David Forest Reserve"
drop if POLICY == "Swamp"
drop if POLICY == "Tacarigua Reserve"
drop if POLICY == "Transportation"
drop if POLICY == "Tumpuna Forest Reserve"
drop if POLICY == "Turtle Nesting Area"        
drop if POLICY == "Valencia Reserve"
drop if POLICY == "Victoria/Mayaro Reserve"
drop if POLICY == "Volcanic Zone"
drop if POLICY == "Watershed Reserve"
drop if POLICY == "Windbelt Reserve"
drop if POLICY == "Yarra Reserve"
drop if POLICY == " " & Class_Name == "Forest Reserve"

gen land_use = .
replace land_use = 1 if POLICY == "Residential"  // Residential
replace land_use = 1 if POLICY == "Residential Resort" //Residential
replace land_use = 1 if POLICY == "Urban Development" // Residential	
replace land_use = 1 if POLICY == " " & Class_Name == "Urban Development" // Residential
replace land_use = 2 if POLICY == "Commerical" // Commercial		
replace land_use = 2 if POLICY == "Comerical/Industrial" // Commercial
replace land_use = 2 if POLICY == "Commercial/Residential" // Commercial
replace land_use = 2 if POLICY == "Commerical/Residential" // Commercial
replace land_use = 2 if POLICY == "Multiple Use" // Commercial
replace land_use = 2 if POLICY == "Hotel/Resort" // Commercial
replace land_use = 2 if POLICY == "Industrial" // Commercial
replace land_use = 3 if POLICY == "Recreational" // Entertainment
replace land_use = 3 if POLICY == "Public/Protective" // Entertainment
replace land_use = 4 if POLICY == "Public Utilities" // Office
replace land_use = 5 if POLICY == "Institutional" // Institutional
	
label var land_use "IPEN Land Use Categories"
label define land_use 1"Residential" ///
					  2"Commercial" ///
					  3"Entertainment" ///
					  4"Office" ///
					  5"Institutional"				 
label value land_use land_use						

*-------------------------------------------------------------------------------

*Create variable for number of land uses within each ED
by ED_NUM land_use, sort: gen nvals = _n == 1
by ED_NUM: replace nvals = sum(nvals)
by ED_NUM: replace nvals = nvals[_N]

*Create total area of all land use types variable
gen Area_land_total = Landuse_area
by ED_NUM: replace Area_land_total = sum(Area_land_total)
by ED_NUM: replace Area_land_total = Area_land_total[_N]

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
				by(land_use ED_NUM nvals Area_land_total)

*Sort based on Enumeration District number				
sort ED_NUM

*Replace empty land use EDs
replace land_use = 0 if land_use == .

*Reshape data for land areas within each ED for ease of calculation
reshape wide Area_res Area_com Area_enter Area_office Area_ins, i(ED_NUM) j(land_use)

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

tabstat ENT, by(ED_NUM) stat(mean)

*Close log file
log close

*Keep only EDs and Entropy Index
keep ED_NUM ENT

*Export Excel data to encrypted location for joining within GIS
export delimited using "`datapath'/version01/1-input/Walkability/Trinidad/ED_Entropy_Index.csv", replace


*Save dataset
save "`datapath'/version01/2-working/Walkability/Trinidad/Land_Use_Mix_TT.dta", replace
