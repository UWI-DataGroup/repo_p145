clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_030.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/11/2020
**	Date Modified: 	05/01/2020
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
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**ECHORN data path

*WINDOWS OS
*local echornpath "X:/The University of the West Indies/DataGroup - repo_data/data_p120"

*WINDOWS OS (Alternative)
*local echornpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p120"

*MAC OS
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p120"

*-------------------------------------------------------------------------------

*Open log file to store results
*log using "`logpath'/version01/3-output/Walkability/walk_BB_030.log",  replace

*-------------------------------------------------------------------------------

*Merge in walkability and SES measures for Barbados
import delimited "`datapath'/version01/2-working/Walkability/Barbados/walk_measure.csv", clear

rename ed ED

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

gen ERS = ((t_income_200_over+t_income_150_199) - t_income_0_49)/ total_income

*gen ICE = ((t_income_200_over+t_income_150_199+ t_income_100_149+ t_income_50_99) - t_income_0_49)/ total_income
label var ERS "Economic Residential Segregation"

gen ERS_cat = .
replace ERS_cat = 1 if ERS<=-0.8
replace ERS_cat = 2 if ERS>-0.8 & ERS<=-0.6
replace ERS_cat = 3 if ERS>-0.6 & ERS<=-0.4
replace ERS_cat = 4 if ERS>-0.4 & ERS<=-0.2
replace ERS_cat = 5 if ERS>-0.2 & ERS<=-0.0
replace ERS_cat = 6 if ERS>0.0 
tab ERS_cat 

*Addition of Index of Economic Dissimilarity (IED)
gen income_high = (t_income_150_199 + t_income_200_over)
tabstat income_high, by(parish) stat(sum)

/*
      parish |       sum
-------------+----------
Christ Churc |       171
  St. Andrew |         5
  St. George |        93
   St. James |       182
    St. John |        11
  St. Joseph |        11
    St. Lucy |         9
 St. Michael |       159
   St. Peter |        27
  St. Philip |        88
  St. Thomas |        67
-------------+----------
       Total |       823
------------------------

	
*/

*encode parish, gen(parish_cat)
gen parish_cat = parish

gen high_income_parish = .
replace high_income_parish = (income_high/171) if parish_cat == 1 // Christ Church
replace high_income_parish = (income_high/5) if parish_cat == 2 // St. Andrew
replace high_income_parish = (income_high/93) if parish_cat == 3 // St. George
replace high_income_parish = (income_high/182) if parish_cat == 4 // St. James
replace high_income_parish = (income_high/11) if parish_cat == 5 // St. John
replace high_income_parish = (income_high/11) if parish_cat == 6 // St. Joseph
replace high_income_parish = (income_high/9) if parish_cat == 7 // St. Lucy
replace high_income_parish = (income_high/159) if parish_cat == 8 // St. Michael
replace high_income_parish = (income_high/27) if parish_cat == 9 // St. Peter
replace high_income_parish = (income_high/88) if parish_cat == 10 // St. Philip
replace high_income_parish = (income_high/67) if parish_cat == 11 // St. Thomas


gen income_low = t_income_0_49
tabstat income_low, by(parish) stat(sum)

/*
      parish |       sum
-------------+----------
Christ Churc |     13050
  St. Andrew |      1336
  St. George |      6328
   St. James |      5727
    St. John |      2428
  St. Joseph |      1786
    St. Lucy |      2735
 St. Michael |     20127
   St. Peter |      3511
  St. Philip |      6741
  St. Thomas |      3975
-------------+----------
       Total |     67744
------------------------
*/

gen low_income_parish = .
replace low_income_parish = (income_low/13050) if parish_cat == 1 // Christ Church
replace low_income_parish = (income_low/1336) if parish_cat == 2 // St. Andrew
replace low_income_parish = (income_low/6328) if parish_cat == 3 // St. George
replace low_income_parish = (income_low/5727) if parish_cat == 4 // St. James
replace low_income_parish = (income_low/2428) if parish_cat == 5 // St. John
replace low_income_parish = (income_low/1786) if parish_cat == 6 // St. Joseph
replace low_income_parish = (income_low/2735) if parish_cat == 7 // St. Lucy
replace low_income_parish = (income_low/20127) if parish_cat == 8 // St. Michael
replace low_income_parish = (income_low/3511) if parish_cat == 9 // St. Peter
replace low_income_parish = (income_low/6741) if parish_cat == 10 // St. Philip
replace low_income_parish = (income_low/3975) if parish_cat == 11 // St. Thomas


gen IED = (0.5*(abs(high_income_parish - low_income_parish)))*100
label var IED "Index of Economic Dissimilarity"

*Create SES deciles
xtile SES_10 = SES , nq(10)
label var SES_10 "SES Index in Deciles"

*Regression Models for Active transport and walkability measures										
foreach x in walkability walkscore  moveability walk_10 factor{

mixed `x' SES || parish:, vce(robust)
mixed `x' SES ERS || parish:, vce(robust)
mixed `x' SES IED || parish:, vce(robust)
mixed `x' SES IED ERS t_age_median per_vehicles_0 crime_density || parish:, vce(robust)

}
cls

gen educ = ((t_education_secondary + t_education_post_secondary + t_education_tertiary)/total_pop) *100

label var educ "Percentage total population with secondary or more education"

foreach x in walkability walkscore  moveability walk_10 factor {
	foreach y in SES ERS i.ERS_cat IED{

regress `x' `y'  educ t_age_median per_t_unemployment crime_density, vce(robust)

	}
}


*Regression results plots
preserve
label var SES "SES"
label var ERS "ERS"
label var IED "IED"

regress walkability SES  educ t_age_median per_t_unemployment crime_density ib8.parish, vce(robust)
estimates store regress
mixed walkability SES  educ t_age_median per_t_unemployment crime_density|| parish:, vce(robust)
estimates store mixed
regress walkability SES , vce(robust)
estimates store unadjust_regress
mixed walkability SES || parish:, vce(robust)
estimates store unadjust_mixed

coefplot unadjust_regress regress unadjust_mixed mixed, keep (SES) name(SES) xline(0) legend(off)

drop _est_unadjust_regress _est_regress _est_unadjust_mixed _est_mixed
regress walkability ERS  educ t_age_median per_t_unemployment crime_density ib8.parish, vce(robust)
estimates store regress
mixed walkability ERS  educ t_age_median per_t_unemployment crime_density|| parish:, vce(robust)
estimates store mixed
regress walkability ERS , vce(robust)
estimates store unadjust_regress
mixed walkability ERS || parish:, vce(robust)
estimates store unadjust_mixed

coefplot unadjust_regress regress unadjust_mixed mixed, keep (ERS) name(ERS) xline(0) legend(off)

drop _est_unadjust_regress _est_regress _est_unadjust_mixed _est_mixed
regress walkability IED  educ t_age_median per_t_unemployment crime_density ib8.parish, vce(robust)
estimates store regress
mixed walkability IED  educ t_age_median per_t_unemployment crime_density|| parish:, vce(robust)
estimates store mixed
regress walkability IED , vce(robust)
estimates store unadjust_regress
mixed walkability IED || parish:, vce(robust)
estimates store unadjust_mixed

coefplot unadjust_regress regress unadjust_mixed mixed, keep (IED) name(IED) xline(0) legend(off)

graph combine SES ERS IED, name(combine) col(3)
restore
