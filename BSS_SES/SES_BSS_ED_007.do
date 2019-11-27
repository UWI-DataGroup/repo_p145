
clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_007.do
**  Project:      	Macroscale Walkability- PhD
**  Analyst:		Kern Rocke
**	Date Created:	27/11/2019
**	Date Modified: 	27/11/2019
**  Algorithm Task: Final LASSO Regression Model and PCA Senstivity Analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

**Aggregated data path
local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

use "`datapath'/version01/2-working/BSS_SES/BSS_SES_002", clear

/////	 LASSO MODEL	/////

**Initalize macros
global xlist	per_t_income_0_49  per_high_income 	///
				t_age_median per_young_age_depend per_old_age_depend	///
				per_education_less_secondary per_t_education_tertiary	///
				per_htenure_owned per_renting	///
				per_amentities_stove per_amentities_fridge ///
				per_amentities_microwave per_amentities_tv ///
				per_amentities_radio per_amentities_wash  ///
				per_amentities_computer	///
				per_t_wactivity_government per_private_wactivity ///
				per_prof_occupation per_prof_techoccupation ///
				per_prof_n_techoccupation		///
				per_unemployment per_t_wactivity_no_work	///
				per_crime_victim per_smother_total per_marital_n_married	///
				per_vehicle_presence ///
				hsize_mean per_rooms_less_3 per_bedrooms_less_2 	///
				per_bathroom_0 per_live_5_more 	///
			
global ED

preserve
*Replace missing code 999999 with .
replace t_income_median = . if t_income_median>559999

gen t_cat = .
replace t_cat = 0 if t_income_median==.
recode t_cat (.=1)

tab t_cat

*Imputation Model
mi set mlong
misstable sum t_income_median
mi register imputed t_income_median 
set seed 29390

*Predictive Mean Matching
mi impute chained (regress) t_income_median = t_age_median hsize_mean , add(20)
	
*Listing mean total median income for missing median income EDs											
mi estimate: mean t_income_median if t_cat==0, over(ED)

gen data = _mi_m
recode data (2/max=1) 
tab data

*-------------------------------------------------------------------------------

*Lasso linear model
lasso linear pop_density $xlist if data==0, rseed(1234)
cvplot					// Cross-validation plot
estimates store cv 		// Storing estimates of linear model


*LASSO BIC model
lassoknots, display(nonzero osr2 bic)
lassoselect id = 39		// Selecting model 39- Model with the lowest BIC
cvplot					// Cross-validation plot with bic and linear model
estimates store minBIC	// Storing estimates minimum BIC model


*LASSO Adapative model
lasso linear pop_density $xlist if data==0, selection(adaptive) rseed(1234)
estimates store adaptive	// Storing estimates of adaptive model


* Table of standardized coeficients used for each model
lassocoef cv minBIC adaptive, sort(coef, standardized) nofvlabel


*Assess goodness of fit for each of the models used on training datasets
lassogof cv minBIC adaptive,  over(data) postselection

tabstat _est_cv _est_minBIC _est_adaptive, by(parish) stat(mean)

restore


*-------------------------------------------------------------------------------

*PCA ANALYSIS USING VARIABLE MODEL FROM LASSO CV MODEL

pca per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_wactivity_government per_amentities_tv  per_t_education_tertiary  ///
	per_private_wactivity t_age_median per_live_5_more per_rooms_less_3, ///
	mineigen(1)

*Screeplot	
screeplot, yline(1)

*Horn's Parallel Analysis
paran per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_wactivity_government per_amentities_tv  per_t_education_tertiary  ///
	per_private_wactivity t_age_median per_live_5_more per_rooms_less_3, ///
	graph color

*PCA using CV LASSO variables 
pca per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_wactivity_government per_amentities_tv  per_t_education_tertiary  ///
	per_private_wactivity t_age_median per_live_5_more per_rooms_less_3, ///
	mineigen(1)

*Varimax Rotation
rotate, varimax components(6) blank(.3)
*Predicting component scores
predict com*
*Generation of SES score 
egen ses_score_cv = rowtotal( com1 com2 com3 com4 com5 com6)
tabstat ses_score_cv, by(parish) stat(mean)

drop com*

*-------------------------------------------------------------------------------

*PCA ANALYSIS USING VARIABLE MODEL FROM LASSO minimum BIC MODEL

pca per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_education_tertiary, mineigen(1)

*Screeplot	
screeplot, yline(1)

*Horn's Parallel Analysis
paran per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_education_tertiary, graph color

*PCA using minBIC LASSO variables 
pca per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_education_tertiary, mineigen(1)

*Varimax Rotation
rotate, varimax components(4) blank(.3)
*Predicting component scores
predict com*
*Generation of SES score 
egen ses_score_bic = rowtotal( com1 com2 com3 com4)
tabstat ses_score_bic, by(parish) stat(mean)

drop com*

*-------------------------------------------------------------------------------

*PCA ANALYSIS USING VARIABLE MODEL FROM LASSO SELECTIVE ADAPTION MODEL

pca per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_wactivity_government per_amentities_tv per_private_wactivity, ///
	mineigen(1)

*Screeplot	
screeplot, yline(1)

*Horn's Parallel Analysis
paran per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
		per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
		per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
		per_t_wactivity_no_work per_high_income per_amentities_microwave ///
		per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
		per_t_wactivity_government per_amentities_tv per_private_wactivity, ///
		graph color

*PCA using adaptive LASSO variables 
pca per_renting per_vehicle_presence per_marital_n_married per_amentities_wash ///
	per_education_less_secondary per_bedrooms_less_2 per_young_age_depend ///
	per_old_age_depend hsize_mean per_prof_techoccupation per_smother_total ///
	per_t_wactivity_no_work per_high_income per_amentities_microwave ///
	per_crime_victim per_bathroom_0 per_prof_n_techoccupation ///
	per_t_wactivity_government per_amentities_tv per_private_wactivity, ///
	mineigen(1)

*Varimax Rotation
rotate, varimax components(6) blank(.3)
*Predicting component scores
predict com*
*Generation of SES score 
egen ses_score_adpat = rowtotal( com1 com2 com3 com4 com5 com6)
tabstat ses_score_adpat, by(parish) stat(mean)

*Exporting results to excel for GIS mapping 
export excel ses_score_cv ses_score_bic ses_score_adpat using "C:\Users\810000689\Desktop\ses_score.xlsx", ///
firstrow(variables) replace

*--------------------------------END--------------------------------------------
