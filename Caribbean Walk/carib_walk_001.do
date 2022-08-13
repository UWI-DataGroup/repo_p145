

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Carib_Walk_001.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/06/2022
**	Date Modified: 	14/06/2022
**  Algorithm Task: Estimating Walk Score within 250m x 250m grid of Caribbean countries


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150
 
set seed 1234
scalar t1 = c(current_time)

*Setting working directory

*-------------------------------------------------------------------------------
*WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

/*
NOTE:

This algorithm creates google plus codes for each centroid of a 250m x 250m grid
for countries in the Caribbean region

These codes are need for integration into Walk Score platform for generating the
Walk Score estimate

Centroids are created from admin0 or admin1 shapefiles obtained from humanitarian
data exchange. Layer grid is then created over the country extent and cliped using
the intersection tool based on the country's geographical dimensions. The centroid
of each grid is developed and geographicl geometry attributes are added to each
point. All spatial analysis was done using QGIS. 

CARIBBEAN COUNTRIES

Antigua Barbuda 
Aruba 
Bahamas 
Barbados 
Belize 
Bonaire 
BVI 
Cayman 
Cuba 
Curacao 
Dominica 
Dominican Republic 
French Martinque 
Grenada 
Guyana 
Haiti 
Jamaica 
Montserrat 
Puerto Rico 
Saba 
Saint Barthelemy 
Saint Kitts Nevis 
Saint Lucia 
Saint Vincent 
Sint Eustatius 
Sint Martin 
Suriname 
Trinidad_Tobago 
Turks Caicos 
USVI

*/


foreach x in Antigua_Barbuda Aruba Bahamas Barbados Bonaire BVI Cayman Cuba Curacao Dominica Dominican_Republic French_Martinique Grenada Guyana Haiti Jamaica Montserrat Puerto_Rico Saba Saint_Barthelemy Saint_Kitts_Nevis Saint_Lucia Saint_Vincent Sint_Eustatius Sint_Martin Suriname Trinidad_Tobago Turks_Caicos USVI{
	
*Set working directory for shapefile export
cd "`datapath'/version01/1-input/GIS Data/Country Buildings/`x'/Centroid"

*Convert shapefile to be loaded in STATA
spshape2dta "`datapath'/version01/1-input/GIS Data/Country Buildings/`x'/Centroid/`x'_centroid.shp", replace 

use "`datapath'/version01/1-input/GIS Data/Country Buildings/`x'/Centroid/`x'_centroid.dta", clear


*Creating pluscode

rename xcoord longitude
rename ycoord latitude

local lat latitude
local long longitude

gen part1 = "https://plus.codes/api?address="
gen part2 = ","
gen part3 = "&email=YOUR_EMAIL_HERE"

egen address = concat(part1 latitude part2 longitude part3)
local address address

drop part*

*Create google pluscode webaddress
gen code =  fileread(address)

split code, limit(5)
rename code5 pluscode
label var pluscode "Google Plus code"
replace pluscode = subinstr(pluscode, ",", "",.) 
replace pluscode = subinstr(pluscode, `"""', "",.) 
drop code*

*Walkscore acquistion
gen part1 = "https://www.walkscore.com/score/"
egen walkscore_address = concat(part1 pluscode)
drop part*

gen walkscore_result = fileread(walkscore_address)

*Remove unneccessary string prior to walk score estimate
gen last = substr(walkscore_result, strpos(walkscore_result, "This location has a Walk Score of") + 33, .)

*Split remaining string into seperate variables to obtain walk score into one variable
*split last, limit(5) 


*Rename variable
*rename last1 walkscore
*label var walkscore "Walkscore"

*Remove unneccessary variables
*drop last*

*Create country variables
gen country = "`x'"
label var country "Country"

keep _ID longitude latitude walkscore_address walkscore_result last

*Save file 
save "`datapath'/version01/2-working/Walkability/WalkScore/Walkscore_`x'", replace

	
}
*-------------------------------------------------------------------------------
*Merge in country data into one dataset
use "`datapath'/version01/2-working/Walkability/WalkScore/Walkscore_Anguilla", clear

foreach x in Antigua_Barbuda Aruba Bahamas Barbados Bonaire BVI Cayman Cuba Curacao Dominica Dominican_Republic French_Martinique Grenada Guyana Haiti Jamaica Montserrat Puerto_Rico Saba Saint_Barthelemy Saint_Kitts_Nevis Saint_Lucia Saint_Vincent Sint_Eustatius Sint_Martin Suriname Trinidad_Tobago Turks_Caicos USVI{
	
append using "`datapath'/version01/2-working/Walkability/WalkScore/Walkscore_`x'"	
}

*Save file 
save "`datapath'/version01/2-working/Walkability/WalkScore/Walkscore_all_countries", replace
*-------------------------------------------------------------------------------

scalar t2 = c(current_time)
display ((clock(t2, "hms") - clock(t1, "hms")) / 1000)/60 " minutes"


/*
Fixing errors - Run after the model runs
*replace walkscore_result = fileread(walkscore_address) if walkscore_result == "fileread() error 679"

*Remove unneccessary string prior to walk score estimate
gen last = substr(walkscore_result, strpos(walkscore_result, "This location has a Walk Score of") + 33, .)

*Split remaining string into seperate variables to obtain walk score into one variable
split last, limit(5) 

*Remove non-numeric text
gen byte notnumeric = regexm(last1, "^[-+]?[0-9]*\.?[0-9]+$")==0
drop if notnumeric == 1

destring last1, replace

*Rename variable
drop walkscore
rename last1 walkscore
label var walkscore "Walkscore"

*Remove unneccessary variables
drop last*

sum walkscore


split walkscore_result, gen(pos1) parse("a Walk Score of ")
