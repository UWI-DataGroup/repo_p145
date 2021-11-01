
clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_037.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	22/10/2021
**	Date Modified: 	23/10/2021
**  Algorithm Task: Missing Data Analysis & Multiple Imputation


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*MAC OS 
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"

*Install user written commnad
ssc install how_many_imputations, replace

*Open combined dataset
use "`datapath'/version01/2-working/Walkability/walkability_paper_001_combine.dta", replace

*Missing data on CVD Risk Score
gen cvd_miss = . 
replace cvd_miss = 0 if ascvd10 !=.
replace cvd_miss = 1 if ascvd10 == .
label var cvd_miss "Mising CVD Risk scores"
label define miss 0"Non-missing" 1"Missing"
label value cvd_miss miss

tab cvd_miss

*Create variable for missing walking data
gen walk_miss = .
replace walk_miss = 0 if walk != .
replace walk_miss = 1 if walk == .
label var walk_miss "Walking Missing"
label value walk_miss miss

tab walk_miss
*Note: Results of the analysis showed that approximately 30% is missing data on walking

ranksum ascvd10, by(walk_miss)
ranksum age, by(walk_miss)

ttest ascvd10, by(walk_miss) unequal
ttest age, by(walk_miss) unequal
ttest smoke, by(walk_miss) unequal
ttest car, by(walk_miss) unequal
ttest SES_census, by(walk_miss) unequal


*Create missing indicator for variables to be imputed
gen miss_impute = missing(bmi, walk, education_1, car, smoke)
tab miss_impute if cvd_miss!=.

ranksum ascvd10, by(miss_impute)
ranksum age, by(miss_impute)


*-------------------------------------------------------------------------------
*							DATASET with IMPUTATION							

*Distribution of missing data for key variables
misstable summarize walk bmi age sex_1 education_1 car smoke if ascvd10!=.
					
*Prepare dataset for imputation
mi set flong

*Set complex survey dataset for imputation
mi svyset ED [pweight= UScb2021], strata(region) vce(linearized) singleunit(certainty)


*Register dataset for imputation
 mi register imputed  walk bmi age sex_1 education_1 car smoke
					  
*Setting seed for reproducability of results
 set seed 1234 

*Imputation using complex chained equations
 mi impute  chained (regress) bmi  ///
					(regress) walk (logit) car ///
					(logit) smoke (ologit) education_1 ///
					= ascvd10 walkability age sex_1 SES_census if ascvd10!=., ///
					add(30) augment ///
					rseed(1234)	
					
mi estimate: regress ascvd10 walkability walk i.sex_1 age i.education_1 bmi car SES_census if age>=40 & age<80, cformat(%9.2f)		
			
mi estimate: svy linearized : regress ascvd10 walkability walk i.sex_1 age i.education_1 bmi car SES_census, cformat(%9.2f)	

mi estimate: svy linearized : regress ascvd10 walkability walk i.sex_1 age i.education_1 bmi car SES_census	if age>=40, cformat(%9.2f)	
how_many_imputations

 mi impute  chained (regress) bmi  ///
					(regress) walk (logit) car ///
					(logit) smoke (ologit) education_1 ///
					= ascvd10 walkability age sex_1 SES_census if ascvd10!=., ///
					add(`r(add_M)') augment ///
					rseed(1234)	

mi estimate: svy linearized : regress ascvd10 walkability walk i.sex_1 age i.education_1 bmi car SES_census	if age>=40 & age<80, cformat(%9.2f)	
mean ascvd10 walk
mi estimate: svy linearized: mean ascvd10 walk

*-------------------------------------------------------------------------------


*add(`r(add_M)')
