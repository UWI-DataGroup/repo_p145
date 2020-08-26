clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_TT_004.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Trinidad Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	23/08/2020
**	Date Modified: 	23/08/2020
**  Algorithm Task: IPEN Country & City comparisons 


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
log using "`logpath'/version01/3-output/Walkability/walk_TT_004.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------


*Load in data from encrypted location
import excel "`datapath'/version01/1-input/Walkability/IPEN_WI_countries.xlsx", sheet("WI_Index") clear

*Data cleaning 
rename A WI
label var WI "Walkability Index"
rename B location

*Create Location variable
gen Location = .
replace Location = 1 if location == "IPEN Pooled"
replace Location = 2 if location == "Adelaide, AUS"
replace Location = 3 if location == "Ghent, BEL"
replace Location = 4 if location == "Curitiba, BRA"
replace Location = 5 if location == "Bogota, COL"
replace Location = 6 if location == "Olomouc, CZE"
replace Location = 7 if location == "Aarhus, DNK"
replace Location = 8 if location == "Hong Kong, HKG"
replace Location = 9 if location == "Cuernavaca, MEX"
replace Location = 10 if location == "Christchurch, NZL"
replace Location = 11 if location == "North Shore, NZL"
replace Location = 12 if location == "Waitakere, NZL"
replace Location = 13 if location == "Wellington, NZL"
replace Location = 14 if location == "Stoke-on-Trent, GBR"
replace Location = 15 if location == "Baltimore, USA"
replace Location = 16 if location == "Seattle, USA"
replace Location = 17 if location == "Trinidad"
replace Location = 18 if location == "Barbados"

label var Location "Location"

label define Location ///
						1"IPEN Pooled" ///
						2"Adelaide, AUS" ///
						3"Ghent, BEL" ///
						4"Curitiba, BRA" ///
						5"Bogota, COL" ///
						6"Olomouc, CZE" ///
						7"Aarhus, DNK" ///
						8"Hong Kong, HKG" ///
						9"Cuernavaca, MEX" ///
						10"Christchurch, NZL" ///
						11"North Shore, NZL" ///
						12"Waitakere, NZL" ///
						13"Wellington, NZL" ///
						14"Stoke-on-Trent, GBR" ///
						15"Baltimore, USA" ///
						16"Seattle, USA" ///
						17"Trinidad" ///
						18"Barbados", modify

label value Location Location

tab Location
*-------------------------------------------------------------------------------
*Creating region variable
gen region = . 
replace region = 1 if Location == 2 | Location == 10 | Location == 11 | Location == 12 | Location == 13 // Oceania
replace region = 2 if Location == 3 | Location == 6 | Location == 7 | Location == 14 // Europe
replace region = 3 if Location == 9 | Location == 15 | Location == 16 // North & Central America
replace region = 4 if Location == 4 | Location == 5 // South America
replace region = 5 if Location == 17 | Location == 18 // Caribbean

label var region "Region"
label define region 1"Oceania" 2"Europe" 3"North & Central America" 4"South America" 5"Caribbean"
label value region region

tab region
*-------------------------------------------------------------------------------
*Examine differences between medians between Trinidad and Barbados WI
median WI if Location == 17 | Location == 18, by(Location) medianties(below)

*Differences in mean walkability index by region
oneway WI region, tab

*Examine differences between medians between regions WI
median WI, by(region) medianties(below)

*-------------------------------------------------------------------------------

*Create comparison box plots
#delimit ;

graph hbox WI, over(Location) nooutsides 
			   box(1, fcolor(green) lcolor(black)) 
			   ylabel(-5(1)12, nogrid)
			   yline(0, lpattern(dash) lcolor(black))  
			   plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			   graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
			   title("IPEN Walkability Index Country Comparisons", color(black)) 
			   note("")
   ;
#delimit cr

*Export boxplot to encrypted folder
graph export "`outputpath'/version01/3-output/Walkability/WI_country_comparison.png", replace as(png)	
*-------------------------------------------------------------------------------

#delimit ;

graph hbox WI, over(region) nooutsides 
			   box(1, fcolor(green) lcolor(black)) 
			   ylabel(-5(1)8, nogrid labsize(medium))
			   yline(0, lpattern(dash) lcolor(black))  
			   plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			   graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
			   title("IPEN Walkability Index Region Comparisons", color(black)) 
			   note("Note:"
					"Oceania= Australia, New Zealand; Europe= Belgium, Czech Republic, Denmark, Great Britian"
					"North and Central America= USA, Mexico; South America= Brazil, Colombia"
					"Caribbean= Barbados, Trinidad", span size(vsmall))
   ;
#delimit cr

*Export boxplot to encrypted folder
graph export "`outputpath'/version01/3-output/Walkability/WI_country_region.png", replace as(png)	

*-------------------------------------------------------------------------------
*Label dataset
label data "Walkability Index using Frank (2010) methodology for IPEN countries and additional Caribbean (Trnidad & Babrados) countries"

*Save dataset
save "`datapath'/version01/2-working/Walkability/IPEN_WI_countries.dta", replace

*Close log file
log close
