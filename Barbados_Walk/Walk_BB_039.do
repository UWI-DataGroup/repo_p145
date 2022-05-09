

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_039.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/05/2022
**	Date Modified: 	06/05/2022
**  Algorithm Task: Linking walkability measures with Barbados Living Conditions Survey


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150
 
set seed 1234


*Setting working directory

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"
local brbpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p158"
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p120"
local hotnpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p124"
local dopath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The UWI - Cave Hill Campus/Github Repositories"



*Load in ED level greenness data (import from csv)
import delimited "/Users/kernrocke/Downloads/ED_fix_BB/ED_BB_ndvi.csv"

*Minor cleaning
rename _mean ndvi
label var ndvi "Normalized Difference Vegetative Index"

rename enum_no1 ED
label var ED "Enumeration Districts"

drop parishnam1 objectid id3

*Save NDVI data
save "`datapath'/version01/2-working/Walkability/ndvi_BB.dta", replace

*-------------------------------------------------------------------------------

*Load in Neighbourhood Environment data
use "`datapath'/version01/2-working/Walkability/walkability_paper_001.dta", replace
keep ED Road_Foot_I_Density LUM Residential walkability  walkscore walkability_factor Area parish total_pop SES_census crime_density BD_ht ERS ERS_cat IED educ_census pop_density ln_pop_density building_density crime_pop t_income_median_us walkability_new walkability_new_10

*Merge in Additionl neighbourhood environment chanracteristics
merge m:m ED using "`datapath'/version01/2-working/Walkability/neighbourhood_charc_add.dta", nogenerate
merge m:m ED using "`datapath'/version01/2-working/Walkability/ndvi_BB.dta", nogenerate

*Save neighbourhood environment data
save "`datapath'/version01/2-working/Walkability/neighbourhood_environment.dta", replace

*-------------------------------------------------------------------------------

** ********************************************************
** Load in Barbados Living Conditions Survey data 
**
** The following datasets exist:
** Database file RT001 – Household-level information 
** Database file RT002 – Individuals (Present household members)
** ********************************************************

*Load in Household-level information
use "`brbpath'/version01/1-input/SLC-BRB-2016/Data/RT001_Public.dta", clear
*Merge in Individual level data
merge 1:m hhid using "`brbpath'/version01/1-input/SLC-BRB-2016/Data/RT002_Public.dta", nogenerate

*Rename variable to identify EDs
rename psu ED

*Merge in Neighbourhood environment data
merge m:m ED using "`datapath'/version01/2-working/Walkability/neighbourhood_environment.dta", nogenerate



***Now looking at reclassifications of categorical variables

table q1_06 //Given 4379 are black.will classify black or other

gen q1_06b = 0
replace q1_06b = 1 if q1_06 == 1
replace q1_06b = . if q1_06 == .

label variable q1_06b "Ethnicity"
label define ethnicity_b 1 "Black" 0 "Other"
label values q1_06b ethnicity_b


table q1_07  // Divided into Anglican-1, Pentecostal-2, Other-3, None-4

gen q1_07b = .
replace q1_07b = 1 if q1_07 == 1
replace q1_07b = 2 if q1_07 == 9
replace q1_07b = 3 if q1_07 == 2 | q1_07 == 3 | q1_07 == 4 | q1_07 == 5 | q1_07 == 11
replace q1_07b = 3 if q1_07 == 6 | q1_07 == 7 | q1_07 == 8 | q1_07 == 10 | q1_07 == 12
replace q1_07b = 4 if q1_07 == 13

label variable q1_07b "Religion"
label define religion_b 1 "Anglican" 2 "Pentecostal" 3 "Other" 4 "None"
label values q1_07b religion_b


table q1_08  // Never married- 1; married and common-law-2; Other single - 3

gen q1_08b = .
replace q1_08b = 1 if q1_08 == 1
replace q1_08b = 2 if q1_08 == 2
replace q1_08b = 2 if q1_08 == 3
replace q1_08b = 3 if q1_08 == 4
replace q1_08b = 3 if q1_08 == 5
replace q1_08b = 3 if q1_08 == 6

label variable q1_08b "marital_status"
label define marital_status_b 1 "Never married" 2 "Married/Common-law" 3 "Widowed/Divorced"
label values q1_08b marital_status_b

gen q1_08c =.   //Revised marital status Single = 1; married= 2; 

replace q1_08c = 1 if q1_08b == 1
replace q1_08c = 2 if q1_08b == 2
replace q1_08c = 1 if q1_08b == 3

label variable q1_08c "marital_status_c"
label define marital_status_c 1 "Single" 2 "Married"
label values q1_08c marital_status_c


gen q3_22b = .
replace q3_22b = 1 if q3_22 == 1
replace q3_22b = 1 if q3_22 == 2
replace q3_22b = 1 if q3_22 == 3
replace q3_22b = 2 if q3_22 == 4
replace q3_22b = 2 if q3_22 == 5
replace q3_22b = 3 if q3_22 == 6 

replace q3_22b = 1 if q3_22 == 7 & q3_27 == 1
replace q3_22b = 1 if q3_22 == 7 & q3_27 == 2
replace q3_22b = 1 if q3_22 == 7 & q3_27 == 3
replace q3_22b = 2 if q3_22 == 7 & q3_27 == 4
replace q3_22b = 2 if q3_22 == 7 & q3_27 == 5
replace q3_22b = 2 if q3_22 == 7 & q3_27 == 6
replace q3_22b = 3 if q3_22 == 7 & q3_27 == 8
replace q3_22b = 3 if q3_22 == 7 & q3_27 == 9
replace q3_22b = 3 if q3_22 == 7 & q3_27 == 10
replace q3_22b = 3 if q3_22 == 7 & q3_27 == 11
replace q3_22b = 3 if q3_22 == 7 & q3_27 == 12
replace q3_22b = 3 if q3_22 == 7 & q3_27 == 13

label variable q3_22b "Education"
label define education_b 1 "Primary/Elementary" 2 "Secondary" 3 "Tertiary"
label values q3_22b education_b

***Checking that the reclassification was done correctly

tab q3_22b q3_22

***Reclassification for hypertension and diabetes. 

gen q5_06ad = 0
replace q5_06ad = 1 if q5_06a == 1

label variable q5_06ad "Diabetes"
label define diabetes 1 "Yes" 0 "No"
label values q5_06ad diabetes

gen q5_06bh = 0 
replace q5_06bh = 1 if q5_06b == 1

label variable q5_06bh "Hypertension"
label define hypertension 1 "Yes" 0 "No"
label values q5_06bh hypertension

***Occupation. First, employment status
codebook q9_04

**Will recategorise into Employed, Retired, Unemployed/Other(students,kept house,incapacitated,)
gen q9_04b = .
replace q9_04b = 1 if q9_04 == 1
replace q9_04b = 2 if q9_04 == 2
replace q9_04b = 2 if q9_04 == 3
replace q9_04b = 2 if q9_04 == 4
replace q9_04b = 3 if q9_04 == 5
replace q9_04b = 3 if q9_04 == 6
replace q9_04b = 2 if q9_04 == 7

label variable q9_04b "Employment2"

label define employ2 1 "Employed" 2 "Unemployed/Other" 3 "Retired/Incapacitated"

label values q9_04b employ2


*Current education of participants
gen educ_new = .
replace educ_new = 1 if q3_03 == 1
replace educ_new = 1 if q3_03 == 2
replace educ_new = 2 if q3_03 == 3
replace educ_new = 2 if q3_03 == 4
replace educ_new = 3 if q3_03 == 5
replace educ_new = 4 if q3_03 == 6
replace educ_new = 3 if q3_03 == 7

label var educ_new "Level of education attending now"
label define educ_new 1"Primary/Elementary" 2"Secondary" 3"Technical" 4"Tertiary"
label value educ_new educ_new

*ssc install zscore06, replace

sum q1_04 if q1_04>=18  & q3_14!=.
sum q1_04 if q1_04<=18 
sum q1_04 if q3_14!=.

*keep if q1_04<=15

svyset ED, strata(stratum) weight(weight) vce(linearized) singleunit(missing) || hhid 

preserve
keep if q3_14!=.

*************************LINEAR REGRESSION MODEL**********************

svy linearized : regress q3_14 walkability_new_10 if q3_14!=., cformat(%9.2f)
svy linearized : regress q3_14 walkability_new_10 q1_04 i.q1_03 SES_census if q3_14!=., cformat(%9.2f)
svy linearized : regress q3_14 walkability_new_10 q1_04 i.q1_03 i.q1_06b i.q1_07b i.educ_new SES_census if q3_14!=., cformat(%9.2f)
svy linearized : regress q3_14 walkability_new_10 q1_04 i.q1_03 i.q1_06b i.q1_07b ib2.q3_03 SES_census if q3_14!=., cformat(%9.2f)

restore
*----------------------------------------------------

*************************LOGISTIC REGRESSION MODEL**********************

gen walk_cat = .
replace walk_cat = 1 if q5_03e == 1
replace walk_cat = 0 if q5_03e == .

svy linearized : logistic walk_cat walkability_new_10 , cformat(%9.2f)
svy linearized : logistic walk_cat walkability_new_10 q1_04 i.q1_03 SES_census, cformat(%9.2f)
svy linearized : logistic walk_cat walkability_new_10 q1_04 i.q1_03 i.q1_06b i.q1_07b i.educ_new SES_census, cformat(%9.2f)

*----------------------------------------------------
*Participants who actively commuted (walked or biked) to school
gen walk_school = .
replace walk_school = 1 if q3_15==1 | q3_15==2
replace walk_school = 0 if q3_15==3 | q3_15==4 | q3_15==5 | q3_15==6 | q3_15==7

svy linearized: logistic walk_school walkability_new_10 q1_04 i.q1_03 i.q1_06b i.q1_07b i.educ_new SES_census, cformat(%9.2f)
svy linearized: logistic walk_school i.walk_3 q1_04 i.q1_03 i.q1_06b i.q1_07b i.educ_new SES_census, cformat(%9.2f)

/*
svy linearized : tobit q3_14 walkability_new_10 if q1_04 <18 & q1_04>=5 & q1_04!=., ll(0) cformat(%9.2f)
svy linearized : tobit q3_14 walkability_new_10 q1_04 i.q1_03 SES_census if q1_04 <18 & q1_04>=5 & q1_04!=., ll(0) cformat(%9.2f)

svy linearized : tobit q3_14 walkability_new_10 q1_04 i.q1_03 SES_census, ll(0) cformat(%9.2f)
svy linearized : tobit q3_14 walkability_new_10 q1_04 i.q1_03 SES_census if q1_04>4 & q1_04!=., ll(0) cformat(%9.2f)
