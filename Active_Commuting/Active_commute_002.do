

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Active_Commute_002.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Barbados ECS Inidividual Walkability
**  Analyst:		Kern Rocke
**	Date Created:	09/12/2020
**	Date Modified: 	09/12/2020
**  Algorithm Task: Multi-Level Models with Walk Score estimates


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
local echornpath "X:/The University of the West Indies/DataGroup - repo_data/data_p120"

*WINDOWS OS (Alternative)
*local echornpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p120"

*MAC OS
*local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p120"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/WHO STEPS/Active_BB_002.log",  replace

*-------------------------------------------------------------------------------

*Load in ECS Barbados Wave 1 Participant Data
use "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity", clear

*Merge in ECS wave 1 address and ED level data
merge 1:1 key using "`datapath'/version01/2-working/Walkability/Barbados/walkability_ECHORN_participants.dta", nogenerate

*Minor dataset cleaning
keep if country==3 // ECS Barbados
destring ED, replace

*Create ID variable for merge of individual walk score estimates
egen OBJECTID = seq()

*Merge individual walk score data with ECS Barbados data
merge 1:1 OBJECTID using "`datapath'/version01/2-working/Walkability/Barbados/walkscore_ECHORN_participants.dta", nogenerate

rename OBJECTID id

*Summary statistics of walk score estimates
tabstat walkscore, stat(mean sd sem median iqr min max) col(stat) long

mean walkscore

*Create tertiles based on walkscore
xtile tertile = walkscore, nq(3)
label var tertile "Walk Score in Tertiles"
tab tertile

*Merge in Parish data
merge m:1 ED using "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145/version01/2-working/Walkability/Walk_index.dta", nogenerate

*Minor cleaning
drop if key == ""

*-------------------------------------------------------------------------------

*Vehicle ownership
gen vehicle = .
replace vehicle = 0 if D96 == 0
replace vehicle = 1 if D96>=1
label var vehicle "Vehicle Ownership"
label define vehicle 0"No vehicles" 1"One or more vehicles"
label value vehicle

*Education
gen educ = .
replace educ = 1 if D13 == 0 | D13 == 1
replace educ = 2 if D13 == 2 | D13 == 3
replace educ = 2 if D13 == 4
replace educ = 3 if D13 >= 5
replace educ = . if D13 == .
label var educ "Education"
label define educ 1"Primary" 2"Secondary" 3"Teritary"
label value educ educ

*-------------------------------------------------------------------------------

*BMI and BMI categories
gen bmi = weight/ ((height/100)^2)
label var bmi "Body Mass Index"
**Overweight
gen over = .
replace over = 0 if bmi<=24.99
replace over = 1 if bmi>=25.0
label var over "Overweight"
label define over 0"Non-Overweight" 1"Overweight"
label value over over
**Obesity
gen obese = .
replace obese = 0 if bmi<=29.99
replace obese = 1 if bmi>=30.0
label var obese "Obesity"
label define obese 0"Non-Obese" 1"Obese"
label value obese obese

*Summary estimates for Overweight and Obesity
proportion over obese 

*Hypertension
gen htn = .
replace htn = 1 if bp_systolic >= 140 & bp_diastolic >=90
replace htn = 0 if bp_systolic <140 | bp_diastolic <90
label var htn "Hypertension"
label define htn 0"No Hypertension" 1"Hypertension"
label value htn htn

*Summary estimates for Hypertension
proportion htn, over(sex)

*Diabetes
gen dia = .
replace dia = 0 if glucose <126 | HBA1C <6.5
replace dia = 1 if glucose >=126 | HBA1C >=6.5
label var dia "Diabetes"
label define dia 0"No diabetes" 1"Diabetic"
label value dia dia

*Summary estimates for Diabetes
proportion dia, over(sex)

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Multi-Level mixed effects linear regression model (Active commuting per day and walk score categories)
mixed mpdT i.tertile sex partage vehicle over dia htn i.educ || Parish: || ED:, vce(robust)

*Multi-Level mixed effects linear regression model (Active commuting per week and walk score categories)
mixed mpwT i.tertile sex partage vehicle over dia htn i.educ || Parish: || ED:, vce(robust)

*Multi-Level mixed effects linear regression model (Total Physical Activity per week and walk score categories)
mixed totMETmin i.tertile sex partage vehicle over dia htn i.educ || Parish: || ED:, vce(robust)

*Multi-Level mixed effects logistic regression model (Pysical inactivity and walk score categories)
melogit inactive i.tertile sex partage vehicle over dia htn i.educ || Parish: || ED:, vce(robust) or

*-------------------------------------------------------------------------------



