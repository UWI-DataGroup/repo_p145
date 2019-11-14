clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_004

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_005.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	14/11/2019
**	Date Modified: 	14/11/2019
**  Algorithm Task: Multiple Imputation and Lasso Prediction


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 80

*Setting working directory
** Dataset to encrypted location
/*
WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*/
*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
cd "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

*Load in dataset
use "`datapath'/version01/2-working/BSS_SES/BSS_SES_003", clear

*MULTIPLE IMPUTATION

/*
Note: Median income within some of the EDs are missing, therefore imputation 
will be used to replace these estimates. 

Values of 999999 were used to idenitfy as missing

Imputation method: Predictive mean matching or multivariate chained equations 
will be used.

*/

**Initalize macros
global xlist per_t_income_0_49 t_age_median per_education_less_secondary ///
				per_crime_victim hsize_mean per_htenure_owned ///
				pop_density per_renting per_high_income per_electricity ///
				per_vehicle_presence per_smother_total per_marital_n_married ///
				per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0 ///
				per_prof_occupation per_amentities_stove per_amentities_fridge ///
				per_amentities_microwave per_amentities_tv per_amentities_radio ///
				per_amentities_wash per_t_wactivity_no_work per_age_depend ///
				per_t_wactivity_government per_t_wactivity_private_enter ///
				per_private_wactivity per_live_5_more per_prof_n_techoccupation ///
				per_prof_techoccupation per_unemployment
global ED

*Descriptives of t_income_median
sum t_income_median
tabstat t_income_median, by(parish)
tabstat t_income_median, by(ED)

*Replace missing code 999999 with .
replace t_income_median = . if t_income_median>559999

*Imputation Model
preserve
mi set mlong
misstable sum t_income_median
mi register imputed t_income_median 
set seed 29390
*Predictive Mean Matching
mi impute pmm $xlist, add(20) knn(5)
				
restore


vl set, categorical(4) uncertain(0)
vl substitute ifactors = i.vlcategorical
display "$ifactors"
* split sample for lasso model
splitsample, gen(sample) nsplit(2) rseed(1234)
tab sample
* Group 1 - Training dataset; Group 2 - Testing dataset
lasso linear q104($idemographics) $ifactors $vlcontinous if sample ==1, rseed(1234)
cvplot
estimate store cv
lassoknots, display(nonzero osr2 bic)
*Select model with lowest BIC
lassoselect id = 9
cvplot
estimates store minBIC
lasso linear q104($idemographics) $ifactors $vlcontinous if sample ==1, selection(adaptive) rseed(1234)
*Selecting an adaptive model
estimates store adaptive
lassocoef cv minBIC adaptive, sort(coef, standardized) nofvlabel
lassogof cv minBIC adaptive, over(sample) postselection















