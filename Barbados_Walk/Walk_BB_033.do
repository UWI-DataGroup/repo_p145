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

*Create SES tertiles
xtile SES_cat= SES_census, nq(3)

*Create Walkability tertiles
xtile walk_cat3 = walkability, nq(3)
xtile walk_cat4 = walkability, nq(4)
		
*Save dataset
save "`datapath'/version01/2-working/Walkability/walkability_paper_001.dta", replace
*-------------------------------------------------------------------------------

*Link HoTN and ECHORN with neighbourhood walkability
use "`hotnpath'/version01/Hotnanalysis/hotn_v4.1/hotn_v41RPAQBOUTS_adjV2.dta", clear

rename ed ED
merge m:1 ED using "`datapath'/version01/2-working/Walkability/walkability_paper_001.dta"

gen bmi = weight / ((height/100)^2)

gen car = .
replace car = 0 if transport1 == 4
replace car = 1 if transport1 == 1
replace car = 1 if transport1 == 2
replace car = 0 if transport1 == 3

gen car_new = .
replace car_new = 1 if transport ==1
replace car_new = 0 if transport !=1

gen over = .
replace over = 0 if bmi<24.99
replace over = 1 if bmi>=25 & bmi!=.

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
replace walk_transport = . if WALKadj == . & CYCLEadj == .

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
cls
/*
Based on unadjusted models the following regression types will be used
	1) Tobit Regression	
	2) Multi-Level Tobit Regression
	3) Negative Binomial Regression
	4) Multi-Level Negative Binomial Regression
	5) Zero-Inflated Negative Binomial Regression
	6) Hurdle Regression
				
*/


*All models will be adjusted for sex and age therefore these will be included in the final model.
*Note: Stepwise method is not available for all regression types thus stepwise will not be used.

********************************************************************************

*Tobit Regression

*Unadjusted
tobit walk walkability, ll(0) nolog cformat(%9.2f)
estimates store tobit_0

* Sex and age adjusted - Model 1
tobit walk walkability sex agey, ll(0) nolog cformat(%9.2f)
estimates store tobit_1

* Model 1 & education
tobit walk walkability sex agey i.educ_new, ll(0) nolog cformat(%9.2f)
estimates store tobit_educ

* Model 1 & bmi
tobit walk walkability sex agey bmi, ll(0) nolog cformat(%9.2f)
estimates store tobit_bmi

* Model 1 & overweight/obese
tobit walk walkability sex agey over, ll(0) nolog cformat(%9.2f)
estimates store tobit_over

* Model 1 & vehicle ownership
tobit walk walkability sex agey car, ll(0) nolog cformat(%9.2f)
estimates store tobit_car

* Model 1 & smoking
tobit walk walkability sex agey ib2.smoke, ll(0) nolog cformat(%9.2f)
estimates store tobit_smoke

* Model 1 & neighbourhood ses
tobit walk walkability sex agey SES_census, ll(0) nolog cformat(%9.2f)
estimates store tobit_ses


estimates stats tobit_0 tobit_1 tobit_educ tobit_bmi tobit_over tobit_car ///
				tobit_smoke tobit_ses, n(740)

/*
-----------------------------------------------------------------------------
       Model |          N   ll(null)  ll(model)      df        AIC        BIC
-------------+---------------------------------------------------------------
     tobit_0 |        740  -3383.438   -3381.23       3    6768.46    6782.28
     tobit_1 |        740  -3383.438  -3360.254       5   6730.508   6753.542
  tobit_educ |        740  -3383.438  -3355.693       7   6725.386   6757.632
   tobit_bmi |        740   -3241.31   -3217.12       6   6446.239   6473.879
  tobit_over |        740   -3241.31  -3217.155       6    6446.31    6473.95
   tobit_car |        740  -2068.462  -2059.417       6   4130.834   4158.474
 tobit_smoke |        740  -3383.438  -3359.808       6   6731.616   6759.255
   tobit_ses |        740  -3383.438  -3360.206       6   6732.412   6760.052
-----------------------------------------------------------------------------

Based on model fit estimatess the following variabels should be retained for the final model
		sex, age, vehicle ownership, bmi and education

*/

cls
*Multi-Level Tobit Regression

*Unadjusted
metobit walk walkability || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_0

* Sex and age adjusted - Model 1
metobit walk walkability sex agey || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_1

* Model 1 & education
metobit walk walkability sex agey i.educ_new || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_educ

* Model 1 & bmi
metobit walk walkability sex agey bmi || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_bmi

* Model 1 & overweight/obese
metobit walk walkability sex agey over || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_over

* Model 1 & vehicle ownership
metobit walk walkability sex agey car || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_car

* Model 1 & smoking
metobit walk walkability sex agey ib2.smoke || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_smoke

* Model 1 & neighbourhood ses
metobit walk walkability sex agey SES_census || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_ses

* Model 1 & work type
metobit walk walkability sex agey i.wtype || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_wtype

* Model 1 & total cholesterol
metobit walk walkability sex agey tchol || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_tchol


estimates stats metobit_0 metobit_1 metobit_educ metobit_bmi metobit_over metobit_car ///
				metobit_smoke metobit_ses metobit_wtype metobit_tchol, n(740)

/*
-----------------------------------------------------------------------------
       Model |          N   ll(null)  ll(model)      df        AIC        BIC
-------------+---------------------------------------------------------------
   metobit_0 |        740          .  -3341.158       4   6690.317   6708.744
   metobit_1 |        740          .  -3319.904       6   6651.808   6679.447
metobit_educ |        740          .  -3315.177       8   6646.355   6683.208
 metobit_bmi |        740          .  -3176.644       7   6367.289   6399.535
metobit_over |        740          .  -3176.659       7   6367.318   6399.564
 metobit_car |        740          .  -2025.951       7   4065.901   4098.148
metobit_sm~e |        740          .  -3319.546       7   6653.093   6685.339
 metobit_ses |        740          .  -3319.903       7   6653.805   6686.052
metobit_wt~e |        740          .  -2031.731       9   4081.461   4122.921
metobit_tc~l |        740          .  -3004.904       7   6023.809   6056.056
-----------------------------------------------------------------------------


Based on model fit estimatess the following variabels should be retained for the final model
		sex, age, vehicle ownership, bmi and education
		

*/
cls
*Negative Binomial Regression

*Unadjusted
nbreg walk walkability , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_0

* Sex and age adjusted - Model 1
nbreg walk walkability sex agey , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_1

* Model 1 & education
nbreg walk walkability sex agey i.educ_new , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_educ

* Model 1 & bmi
nbreg walk walkability sex agey bmi , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_bmi

* Model 1 & overweight/obese
nbreg walk walkability sex agey over , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_over

* Model 1 & vehicle ownership
nbreg walk walkability sex agey car , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_car

* Model 1 & smoking
nbreg walk walkability sex agey ib2.smoke , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_smoke

* Model 1 & neighbourhood ses
nbreg walk walkability sex agey SES_census , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_ses

* Model 1 & work type
nbreg walk walkability sex agey i.wtype , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_wtype

* Model 1 & total cholesterol
nbreg walk walkability sex agey tchol , dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_tchol

estimates stats nbreg_0 nbreg_1 nbreg_educ nbreg_bmi nbreg_over nbreg_car ///
				nbreg_smoke nbreg_ses nbreg_wtype nbreg_tchol, n(740)

/*
-----------------------------------------------------------------------------
       Model |          N   ll(null)  ll(model)      df        AIC        BIC
-------------+---------------------------------------------------------------
     nbreg_0 |        740  -3541.164  -3539.975       3    7085.95    7099.77
     nbreg_1 |        740  -3541.164  -3535.753       5   7081.506   7104.539
  nbreg_educ |        740  -3541.164  -3534.839       7   7083.678   7115.924
   nbreg_bmi |        740  -3385.024  -3378.918       6   6769.836   6797.476
  nbreg_over |        740  -3385.024  -3378.867       6   6769.733   6797.373
   nbreg_car |        740  -2173.898  -2171.514       6   4355.029   4382.669
 nbreg_smoke |        740  -3541.164  -3535.687       6   7083.373   7111.013
   nbreg_ses |        740  -3541.164   -3535.64       6   7083.281   7110.921
 nbreg_wtype |        740  -2173.898   -2172.86       8   4361.719   4398.572
 nbreg_tchol |        740   -3203.91  -3198.257       6   6408.514   6436.154
-----------------------------------------------------------------------------


Based on model fit estimatess the following variabels should be retained for the final model
		sex, age, vehicle ownership, overweight/obese

*/
cls

*Multi-Level Negative Binomial Regression

*Unadjusted
menbreg walk walkability || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_0

* Sex and age adjusted - Model 1
menbreg walk walkability sex agey || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_1

* Model 1 & education
menbreg walk walkability sex agey i.educ_new || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_educ

* Model 1 & bmi
menbreg walk walkability sex agey bmi || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_bmi

* Model 1 & overweight/obese
menbreg walk walkability sex agey over || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_over

* Model 1 & vehicle ownership
menbreg walk walkability sex agey car || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_car

* Model 1 & smoking
menbreg walk walkability sex agey ib2.smoke || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_smoke

* Model 1 & neighbourhood ses
menbreg walk walkability sex agey SES_census || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_ses

* Model 1 & work type
menbreg walk walkability sex agey i.wtype || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_wtype

* Model 1 & total cholesterol
menbreg walk walkability sex agey tchol || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_tchol


estimates stats menbreg_0 menbreg_1 menbreg_educ menbreg_bmi menbreg_over menbreg_car ///
				menbreg_smoke menbreg_ses menbreg_wtype menbreg_tchol, n(740)
				
/*				
-----------------------------------------------------------------------------
       Model |          N   ll(null)  ll(model)      df        AIC        BIC
-------------+---------------------------------------------------------------
   menbreg_0 |        740          .  -3539.975       3    7085.95    7099.77
   menbreg_1 |        740          .  -3535.753       5   7081.506   7104.539
menbreg_educ |        740          .  -3534.839       7   7083.678   7115.924
 menbreg_bmi |        740          .  -3378.918       6   6769.836   6797.476
menbreg_over |        740          .  -3378.867       6   6769.733   6797.373
 menbreg_car |        740          .  -2171.514       6   4355.029   4382.669
menbreg_sm~e |        740          .  -3535.687       6   7083.373   7111.013
 menbreg_ses |        740          .   -3535.64       6   7083.281   7110.921
menbreg_wt~e |        740          .   -2172.86       8   4361.719   4398.572
menbreg_tc~l |        740          .  -3198.257       6   6408.514   6436.154
-----------------------------------------------------------------------------

Based on model fit estimatess the following variabels should be retained for the final model
	sex, age, vehicle ownership, bmi and education
*/

cls
*Zero-Inflated Negative Binomial Regression

*Unadjusted
zinb walk walkability , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_0

* Sex and age adjusted - Model 1
zinb walk walkability sex agey , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_1

* Model 1 & education
zinb walk walkability sex agey i.educ_new , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_educ

* Model 1 & bmi
zinb walk walkability sex agey bmi , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_bmi

* Model 1 & overweight/obese
zinb walk walkability sex agey over , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_over

* Model 1 & vehicle ownership
zinb walk walkability sex agey car , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_car

* Model 1 & smoking
zinb walk walkability sex agey ib2.smoke , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_smoke

* Model 1 & neighbourhood ses
zinb walk walkability sex agey SES_census , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_ses

* Model 1 & work type
zinb walk walkability sex agey i.wtype , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_wtype

* Model 1 & neighbourhood total cholesterol
zinb walk walkability sex agey tchol , inflate(walkability) irr nolog cformat(%9.2f)
estimates store zinb_tchol


estimates stats zinb_0 zinb_1 zinb_educ zinb_bmi zinb_over zinb_car ///
				zinb_smoke zinb_ses zinb_wtype zinb_tchol, n(740)

/*
-----------------------------------------------------------------------------
       Model |          N   ll(null)  ll(model)      df        AIC        BIC
-------------+---------------------------------------------------------------
      zinb_0 |        740  -3311.191  -3308.316       5   6626.632   6649.665
      zinb_1 |        740  -3311.191  -3308.172       7   6630.345   6662.591
   zinb_educ |        740  -3311.191  -3308.109       9   6634.219   6675.678
    zinb_bmi |        740  -3169.942   -3164.71       8    6345.42   6382.273
   zinb_over |        740  -3169.942  -3165.546       8   6347.092   6383.945
    zinb_car |        740  -2028.761  -2027.419       8   4070.838   4107.692
  zinb_smoke |        740  -3311.191  -3308.156       8   6632.311   6669.165
    zinb_ses |        740  -3311.191  -3305.807       8   6627.615   6664.468
  zinb_wtype |        740  -2028.761  -2026.702      10   4073.405   4119.471
  zinb_tchol |        740  -2998.189  -2994.515       8    6005.03   6041.884
-----------------------------------------------------------------------------


Based on model fit estimatess the following variabels should be retained for the final model
		sex, age, vehicle ownership, bmi, smoke, ses
*/

cls
*Hurdle Regression

*Unadjusted
churdle linear walk walkability , select(walkability) ll(0) cformat(%9.2f)
estimates store churdle_0

* Sex and age adjusted - Model 1
churdle linear walk walkability sex agey , select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_1

* Model 1 & education
churdle linear walk walkability sex agey i.educ_new , select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_educ

* Model 1 & bmi
churdle linear walk walkability sex agey bmi , select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_bmi

* Model 1 & overweight/obese
churdle linear walk walkability sex agey over , select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_over

* Model 1 & vehicle ownership
churdle linear walk walkability sex agey car , select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_car

* Model 1 & smoking
churdle linear walk walkability sex agey ib2.smoke , select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_smoke

* Model 1 & neighbourhood ses
churdle linear walk walkability sex agey SES_census , select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_ses

* Model 1 & neighbourhood work type
churdle linear walk walkability sex agey i.wtype, select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_wtype

* Model 1 & neighbourhood total cholesterol
churdle linear walk walkability sex agey tchol, select(walkability sex agey) ll(0) cformat(%9.2f)
estimates store churdle_tchol

estimates stats churdle_0 churdle_1 churdle_educ churdle_bmi churdle_over churdle_car ///
				churdle_smoke churdle_ses churdle_wtype churdle_tchol, n(740)

/*
-----------------------------------------------------------------------------
       Model |          N   ll(null)  ll(model)      df        AIC        BIC
-------------+---------------------------------------------------------------
   churdle_0 |        740  -3332.209  -3329.087       5   6668.174   6691.207
   churdle_1 |        740  -3332.209  -3294.917       9   6607.834   6649.294
churdle_educ |        740  -3332.209  -3294.825      11    6611.65   6662.323
 churdle_bmi |        740  -3188.978  -3150.327      10   6320.654    6366.72
churdle_over |        740  -3188.978  -3151.127      10   6322.255   6368.321
 churdle_car |        740  -2034.836  -2031.244      10   4082.488   4128.555
churdle_sm~e |        740  -3332.209  -3294.893      10   6609.787   6655.853
 churdle_ses |        740  -3332.209  -3293.083      10   6606.165   6652.232
churdle_wt~e |        740  -2034.836  -2030.348      12   4084.696   4139.976
churdle_tc~l |        740  -3016.725  -2982.023      10   5984.047   6030.113
-----------------------------------------------------------------------------



Based on model fit estimatess the following variabels should be retained for the final model
		sex, age, vehicle ownership, bmi, ses, work type, total cholesterol
*/

cls
*Final models

tobit walk walkability sex agey car bmi i.educ_new [pweight = wps_b2010], ll(0) nolog cformat(%9.2f) vce(cluster ED)
estimates store tobit_final

metobit walk walkability sex agey car bmi i.educ_new || ED: , ll(0) nolog cformat(%9.2f)
estimates store metobit_final

nbreg walk walkability sex agey car over [pweight = wps_b2010], dispersion(mean) irr nolog cformat(%9.2f) vce(cluster ED)
estimates store nbreg_final

menbreg walk walkability sex agey car bmi i.educ_new || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_final

zinb walk walkability sex agey car SES_census bmi ib2.smoke tchol i.wtype [pweight = wps_b2010], inflate(walkability) irr nolog cformat(%9.2f) vce(cluster ED)
estimates store zinb_final

churdle linear walk walkability sex agey car bmi SES_census tchol i.wtype [pweight = wps_b2010], select(walkability sex agey) ll(0) cformat(%9.2f) vce(cluster ED)
estimates store churdle_final

estimates stats tobit_final metobit_final nbreg_final menbreg_final zinb_final churdle_final, n(740)


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



*/


preserve

cls

*UNADJUSTED MODELS

*Tobit Model
tobit walk walkability, ll(0) nolog cformat(%9.2f)
estimates store tobit_0

*Multi-Level Tobit Model
metobit walk walkability || ED:, ll(0) nolog cformat(%9.2f)
estimates store metobit_0

*Negative Binomial Model
nbreg walk walkability, dispersion(mean) irr nolog cformat(%9.2f)
estimates store nbreg_0

*Multi-Level Negative Binomial Model
menbreg walk walkability || ED:, irr nolog cformat(%9.2f)
estimates store menbreg_0

*Zero Inflated Negative Binomial Model
zinb walk walkability, inflate(walkability) nolog irr cformat(%9.2f)
estimates store zinb_0

*Hurdle Model
churdle linear walk walkability, select(walkability) ll(0) cformat(%9.2f) nolog
estimates store churdle_0

estimates stats tobit_0 metobit_0 nbreg_0 menbreg_0 zinb_0 churdle_0

*FINIAL MODELS


*Final tobit model syntax
tobit walk z_walkability sex agey SES_census educ_new ethnic bmi car_new ib2.diab parish  [pweight = wps_b2010], ll(0) nolog cformat(%9.2f) vce(cluster ED)
estimates store tobit

*Final Multi-Level tobit model syntax
metobit walk z_walkability sex agey bmi educ_new ethnic parish car_new SES_census [pweight = wps_b2010] || ED:, ll(0) nolog cformat(%9.2f)
estimate store metobit

*Final Negative Binomial model syntax
nbreg walk z_walkability sex agey bmi educ_new ethnic SES_census car_new parish [pweight = wps_b2010], dispersion(mean) irr nolog cformat(%9.2f) vce(cluster ED)
estimates store nbreg

*Final Multi-Level Negative Binomial model syntax
menbreg walk z_walkability sex agey bmi educ_new ethnic SES_census parish car_new [pweight = wps_b2010] || ED:, irr nolog cformat(%9.2f)
estimates store menbreg

*Final Zero-Inflated Negative Binomial model syntax
zinb walk z_walkability sex agey bmi SES_census car_new hyper [pweight = wps_b2010], inflate(z_walkability sex agey bmi SES_census car_new hyper) nolog irr cformat(%9.2f) vce(cluster ED)
estimates store zinb

*Final Hurdle model syntax
churdle linear walk z_walkability sex agey bmi SES_census car_new hyper [pweight = wps_b2010], select(z_walkability sex agey bmi SES_census car_new hyper ) ll(0) cformat(%9.2f) vce(cluster ED)
estimates store churdle


estimates stats tobit metobit nbreg menbreg zinb churdle


restore
