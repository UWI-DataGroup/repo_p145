clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BB_Walk_023.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Barbados Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	23/09/2020
**	Date Modified: 	06/11/2020
**  Algorithm Task: Walkscore Computation by Building footprint Level


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150


*Set working directories

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS - Ian & Christina (Data Group)
*local dopath "X:/OneDrive - The University of the West Indies/Github Repositories/repo_p145"

*WINDOWS OS - Kern & Stephanie
*local dopath "X:/OneDrive - The UWI - Cave Hill Campus/Github Repositories/repo_p145"


*MAC OS - Kern
local dopath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The University of the West Indies/Github Repositories/repo_p145"

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Set Overall data size to number of building footprints (130248)
set obs 1

*Create inital variable for walkscore java script output
do "`dopath'/Barbados_Walk/Walk_BB_023_1"

*Remove unneccessary string prior to walk score estimate
gen last = substr(s, strpos(s, "This location has a Walk Score of") + 33, .)

*Split remaining string into seperate variables to obtain walk score into one variable
split last

*Create identifier
egen id = seq()

*Remove unncessary variables not needed for analysis
keep id last1

*Destring walk score estimate. 
destring last1, replace

*Rename variable
rename last1 walkscore

*Change order
order id walkscore

*Rename id variable
rename id OBJECTID

*label variable
label var walkscore "Walkscore"

save "`datapath'/version01/2-working/Walkability/Barbados/Barbados_building_walkscore", replace
