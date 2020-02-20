
clear
capture log close
cls

**  DO-FILE META DATA INFORMATION
**  Program:		MAPS_analysis_006.do
**  Project:      	Streetscapres- PhD & Walkability
**	Sub-Project:	Pilot MAPS UNESCO Heritiage Site Barbados
**  Analyst:		Kern Rocke
**	Date Created:	30/07/2019
**	Date Modified: 	14/02/2020
**	Task:			Creating Analysis Similar to USVI Paper


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200


*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
cd "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
*cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145



/*	IMPORTANT: 
	The following STATA do file should be excuted prior the excuting this 
	do file
	1) MAPS_prep_001.do
	2) MAPS_prep_002.do
	3) MAPS_prep_003.do
*/


*Reading in dataset
use "`datapath'/version01/2-working/MAPS/MAPS_Recoding_Scoring", clear

* Keep MAPS route data
keep if redcap_repeat_instrument=="maps_route"


*All destinations (0, 1, >2); Beach with public access
egen destinations = rowtotal(LU6a - LU6z)
recode destinations (3/max=2)
label var destinations "All Destinations"
label define destinations 0"0" 1"1" 2">2"
label value destinations destinations

*All destinations
ci destinations , binomial
ci destinations if type==1, binomial
ci destinations if type==2, binomial 

*Beach with public access
ci LU6y , binomial
ci LU6y if type==1, binomial
ci LU6y if type==2, binomial














