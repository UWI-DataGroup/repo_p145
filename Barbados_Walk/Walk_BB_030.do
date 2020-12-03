clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_030.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/11/2020
**	Date Modified: 	03/12/2020
**  Algorithm Task: Walkability and SES Analysis (Area-levl Analysis)


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

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS OS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS OS
local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*MAC OS
*local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**ECHORN data path

*WINDOWS OS
local echornpath "X:/The University of the West Indies/DataGroup - repo_data/data_p120"

*WINDOWS OS (Alternative)
*local echornpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p120"

*MAC OS
*local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p120"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Walkability/walk_BB_030.log",  replace

*-------------------------------------------------------------------------------

*Merge in walkability and SES measures for Barbados
use "`datapath'/version01/2-working/Walkability/Barbados/walk_measure.dta", clear
merge m:1 ED using "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_medium.dta", nogenerate

*Minor data cleaning
rename _eigen_var SES

cls

/*
Age Dependency - t_age_depend
High Income - per_t_high_income
Median Income - t_income_median
No Vehicle - per_vehicles_0
Population Density - pop_density
Crime - crime_density


*/

gen crime_density = crime_victim/area

*Addition of ICE variable (Economic Residential Segregation)
egen total_income = rowtotal(t_income_0_49 t_income_50_99 t_income_100_149 t_income_150_199 t_income_200_over)

gen ICE = ((t_income_200_over+t_income_150_199) - t_income_0_49)/ total_income

*gen ICE = ((t_income_200_over+t_income_150_199+ t_income_100_149+ t_income_50_99) - t_income_0_49)/ total_income
label var ICE "Index of Concentration of the Extremes"

gen ERS_cat = .
replace ERS_cat = 1 if ICE<=-0.8
replace ERS_cat = 2 if ICE>-0.8 & ICE<=-0.6
replace ERS_cat = 3 if ICE>-0.6 & ICE<=-0.4
replace ERS_cat = 4 if ICE>-0.4 & ICE<=-0.2
replace ERS_cat = 5 if ICE>-0.2 & ICE<=-0.0
replace ERS_cat = 6 if ICE>0.0 
tab ERS_cat 

*Create SES deciles
xtile SES_10 = SES , nq(10)
label var SES_10 "SES Index in Deciles"

*Regression Models for Active transport and walkability measures										
foreach x in walkability walkscore  moveability walk_10 factor{

mixed `x' SES || parish:, vce(robust)
mixed `x' SES ICE || parish:, vce(robust)
mixed `x' SES ICE t_age_depend per_t_high_income per_t_income_0_49 per_vehicles_0 || parish:, vce(robust)

}
