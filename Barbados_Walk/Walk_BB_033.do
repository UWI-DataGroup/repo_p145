clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_033.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	09/03/2021
**	Date Modified: 	09/03/2021
**  Algorithm Task: Analysis of IPEN Walkability paper


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
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p120"
local hotnpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p124"
local dopath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The UWI - Cave Hill Campus/Github Repositories"
*Save dataset
use "`datapath'/version01/2-working/Walkability/walkability_SES.dta", clear

drop if ED==.

*Convert median income to USD from US
gen t_income_median_us = t_income_median/2

*High income population
gen high = (t_high_income/total_pop)*100
label var high "High Income Population"

*Create Z-scores
zscore Residential 
zscore Road_Foot_I_Density 
zscore LUM 
zscore walkability

*General Descriptives
tabstat t_income_median_us Residential z_Residential Road_Foot_I_Density ///
		z_Road_Foot_I_Density LUM z_LUM walkability z_walkability, ///
		by(parish) stat(mean) format(%9.2f)
		
*Create deciles for walkability and income
xtile walk10 = walkability, nq(10)
xtile income10 = t_income_median_us, nq(10)

*Create Low/High walkability and income categories (Low=1-4; High=7-10)
gen walk_cat = .
replace walk_cat = 0 if walk10 <=4 & walkability!=. // Low Walkability
replace walk_cat = 1 if walk10 >=7 & walkability!=. // High Walkability 
label var walk_cat "Walkability Categories"
label define walk_cat 0"Low Walkability" 1"High Walkability"
label value walk_cat walk_cat

gen income_cat = .
replace income_cat = 0 if income10 <=4 & income10!=. // Low Income
replace income_cat = 1 if income10 >=7 & income10!=. // High Income
label var income_cat "Income Categories"
label define income_cat 0"Low Income" 1"High Income"
label value income_cat income_cat

tab parish walk_cat, row chi2 nofreq
tab parish income_cat, row chi2 nofreq

*Examine differenes in sociodemographics and Low/High Walkability neighbourhoods
mean pop_density t_age_median per_t_young_age_depend per_t_old_age_depend ///
		t_income_median_us per_t_income_0_49 high educ crime_pop ///
		per_t_non_black per_t_unemployment per_vehicle_presence, over(walk_cat) cformat(%9.1f)

foreach x in pop_density t_age_median per_t_young_age_depend per_t_old_age_depend ///
		t_income_median_us per_t_income_0_49 per_t_high_income educ crime_pop ///
		per_t_non_black per_t_unemployment per_vehicle_presence{
			
			ranksum `x', by(walk_cat)
		}
rename educ educ_census
rename SES SES_census
		
*Save dataset
save "`datapath'/version01/2-working/Walkability/walkability_paper_001.dta", replace
*-------------------------------------------------------------------------------

*Link HoTN and ECHORN with neighbourhood walkability
use "`hotnpath'/version01/Hotnanalysis/hotn_v4.1/hotn_v41RPAQ.dta", clear

rename ed ED
merge m:1 ED using "`datapath'/version01/2-working/Walkability/walkability_paper_001.dta"

gen bmi = weight / ((height/100)^2)

gen car = .
replace car = 0 if transport1 == 4
replace car = 1 if transport1 == 1
replace car = 1 if transport1 == 2
replace car = 0 if transport1 == 3

gen educ_new = .
replace educ_new = 1 if educ == 1 | educ == 2 | educ == 3
replace educ_new = 2 if educ == 4 | educ == 5 | educ == 7
replace educ_new = 3 if educ == 6 | educ == 8 | educ == 9



foreach x in CYCLEadj WALKadj LEIStime{
	replace `x' = `x'*60
}

egen walk = rowtotal(WALKadj ewalk_mins pwalk_mins)
replace walk = . if WALKadj == . & ewalk_mins == . & pwalk_mins == .

egen walk_transport = rowtotal(CYCLEadj WALKadj)
replace walk_transport = . if WALKadj == . & CYCLEadj

gen zero_commute =.
replace zero_commute = 0 if walk_transport == 0
replace zero_commute = 1 if walk_transport >0 & walk_transport !=.

gen zero_leisure =.
replace zero_leisure = 0 if LEIStime == 0
replace zero_leisure = 1 if LEIStime >0 & LEIStime !=.

gen zero_mvpa =.
replace zero_mvpa = 0 if mvpa_mins == 0
replace zero_mvpa = 1 if mvpa_mins >0 & mvpa_mins !=.

gen zero_walk =.
replace zero_walk = 0 if walk == 0
replace zero_walk = 1 if walk >0 & walk !=.

gen missing = . 
replace missing = 1 if  walk_transport !=. | walk !=. | mvpa_mins !=. | LEIStime !=.
replace missing = 0 if walk_transport ==. & walk ==. & mvpa_mins ==. & LEIStime ==.

tab missing
save "`datapath'/version01/2-working/Walkability/walkability_paper_001_hotn.dta", replace

cls
*Linear Model
regress walk walkability, cformat(%9.2f)
estimates store model_1

*Multi-Level Linear Model
mixed walk walkability || ED:, nolog cformat(%9.2f) 
estimates store model_2

*Tobit Model
tobit walk walkability, ll(0) nolog cformat(%9.2f)
estimates store model_3

*Multi-Level Tobit Model
metobit walk walkability || ED:, ll(0) nolog cformat(%9.2f)
estimates store model_4

*Poisson Model
poisson walk walkability, irr nolog cformat(%9.2f)
estimates store model_5

*Multi-level Possion Model
*mepoisson walk walkability || ED:, irr nolog cformat(%9.2f)
*estat ic

*Censored Poisson Model
cpoisson walk walkability, irr ll(0) nolog cformat(%9.2f)
estimates store model_7

*Negative Binomial Model
nbreg walk walkability, dispersion(mean) irr nolog cformat(%9.2f)
estimates store model_8

*Multi-Level Negative Binomial Model
menbreg walk walkability || ED:, irr nolog cformat(%9.2f)
estimates store model_9

*Zero Inflated Poisson Model
zip walk walkability, inflate(walkability) nolog irr cformat(%9.2f)
estimates store model_10

*Zero Inflated Negative Binomial Model
zinb walk walkability, inflate(walkability) nolog irr cformat(%9.2f)
estimates store model_11

*Hurdle Model
churdle linear walk walkability, select(walkability) ll(0) cformat(%9.2f)
estimates store model_12


estimates stats model_1 model_2 model_3 model_4 model_5 model_7 model_8 ///
				model_9 model_10 model_11 model_12


/*
Note the following model names

Model 1 =  Linear Regression
Model 2 =  Multi-Level Linear Regression
Model 3 =  Tobit Regression 
Model 4 =  Multi-Level Tobit Regression
Model 5 =  Poisson Regression
Model 6 =  Multi-Level Poisson Regression
Model 7 =  Censored Poisson Regression
Model 8 =  Negative Binomial Regression
Model 9 =  Multi-Level Negative Binomial Regression
Model 10 = Zero-Inflated Poisson Regression
Model 11 = Zero-Inflated Negative Binomial Regression
Model 12 = Hurdle Regression

*/




/*
*Outcomes: Active Commuting, Leisure-time Activity, Moderate to Vigorous Activity

cls
foreach x in walkability walk_cat Residential Road_Foot_I_Density LUM {
	zinb COMMUTEtime `x' sex age bmi ib3.educ_new car ///
			[pweight = wps_b2010], inflate(zero_commute) vce(cluster ED) ///
			irr zip nolog
			
}


cls
foreach x in walkability walk_cat Residential Road_Foot_I_Density LUM {
	zinb LEIStime `x' sex age bmi ib3.educ_new car ///
			[pweight = wps_b2010], inflate(zero_leisure) vce(cluster ED) ///
			irr zip nolog
			
}

cls
foreach x in walkability walk_cat Residential Road_Foot_I_Density LUM {
	zinb mvpa_mins `x' sex age bmi ib3.educ_new car ///
			[pweight = wps_b2010], inflate(zero_mvpa) vce(cluster ED) ///
			irr zip nolog
			
}
