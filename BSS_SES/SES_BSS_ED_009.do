clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_009.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	03/12/2019
**	Date Modified: 	03/12/2019
**  Algorithm Task: Structural Equation Model


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


/*
Analysis Notes

Create measurment component using the broad SES categories of interest

Link these components with a covariance path 

Run SEM model using Jackknife standard errors

predict scores for all variables in the model

Sum scores into one variable

Map scores into ArcGIS

*Paper computation of SES index using Census data 

///////
Ethnicity
Non-black population (Total Population)

Age
Median Age; young age dependancy; old age dependancy (Total Population)

Household Size
Mean household size; ****house hold size >=6 persons (Total Population)

Housing Tenure
House tenure: Owner; House tenure: renting (Government and Private) (Total Population)

Single Mother (Total Population)

Education
Education less than secondary; Teritary Education (Total Population / Male or Female breakdown?)

Income (Yearly Pay)
Median Income (Total / Male or Female); Low income; High income

Work Activity
Unemployment (Student****, Retired***, looking for work, home duties*****, incapaciated****)  [Total population  /  Male or Female?]

Women with liveborn children
Liveborn children >5

Crime
Crime Victim

Occupation
Management; Professional; Technical; Non-technical Occupation (Male / Female)

Marital Status****
Single (Never married & seperated), Married

Household structure
Number of rooms; number of bedrooms; number of bathrooms, toilet

Vehicle Ownership 
No Vehicle; Vehicle

Household Amentities
Stove, Refridgerator, Microwave, Computer, Radio, Television, Washing Machine

/////////////

*/


*SEM MODEL

sem (age -> t_age_median, ) (age -> per_young_age_depend, ) ///
	(age -> per_old_age_depend, ) (income -> per_high_income, ) ///
	(income -> per_t_income_0_49, ) (house_amenities -> per_amentities_stove, ) ///
	(house_amenities -> per_amentities_fridge, ) (house_amenities -> per_amentities_microwave, ) ///
	(house_amenities -> per_amentities_wash, ) (house_amenities -> per_amentities_tv, ) ///
	(house_amenities -> per_amentities_radio, ) (house_amenities -> per_amentities_computer, ) ///
	(education -> per_education_less_secondary, ) (education -> per_t_education_tertiary, ), ///
	covstruct(_lexogenous, diagonal) vce(jackknife) latent(age income house_amenities education ) ///
	cov( age*house_amenities income*age house_amenities*income house_amenities*education education*age) ///
	nocapslatent

	
	
	
*-------------------------------------------------------------------------------	
*						LARGE VARIABLE SEM MODELS	
*-------------------------------------------------------------------------------

*Large Variable Model  (FUll MODEL)

sem		(race -> per_f_non_black, ) (race -> per_m_non_black, ) ///
		(age -> f_age_median, ) (age -> m_age_median, ) (age -> per_f_young_age_depend, ) (age -> per_m_young_age_depend, ) (age -> per_f_old_age_depend, ) (age -> per_m_old_age_depend, ) ///
		(education -> per_f_education_less_secondary, ) (education -> per_m_education_less_secondary, ) (education -> per_f_education_tertiary, ) (education -> per_m_education_tertiary, ) ///
		(income -> per_f_income_0_49, ) (income -> per_m_income_0_49, ) (income -> per_f_high_income, ) (income -> per_m_high_income, ) (income -> f_income_median, ) (income -> m_income_median , ) ///
		(unemployment -> per_f_unemployment, ) (unemployment -> per_m_unemployment, ) ///
		(crime -> per_crime_victim, ) ///
		(crowding -> per_live_5_more, ) ///
		(occupation -> per_f_manage_occupation, ) (occupation -> per_m_manage_occupation, ) (occupation -> per_f_prof_occupation, ) (occupation -> per_m_prof_occupation, ) (occupation -> per_f_prof_techoccupation, ) (occupation -> per_m_prof_techoccupation, ) (occupation -> per_f_prof_n_techoccupation, ) (occupation -> per_m_prof_n_techoccupation, ) ///
		(vehicle -> per_vehicle_presence, ) (vehicle -> per_vehicles_0, ) ///
		(house_amentities -> per_amentities_stove, ) (house_amentities -> per_amentities_fridge, ) (house_amentities -> per_amentities_microwave, ) (house_amentities -> per_amentities_tv, ) (house_amentities -> per_amentities_radio, ) (house_amentities -> per_amentities_wash, ) (house_amentities -> per_amentities_computer, ) ///
		(house_tenure -> per_renting, ) (house_tenure -> per_htenure_owned, ) ///
		(house_size -> hsize_mean, ) ///
		(single_parent -> per_smother_total, ) ///
		(house_structure -> per_rooms_less_3, ) (house_structure -> per_bedrooms_less_2, ) (house_structure -> per_bathroom_0, ) (house_structure -> per_toilet_presence, ) (house_structure -> per_electricity, ) ///
		covstruct(_lexogenous, diagonal) vce(jackknife) ///
		latent (race age education income unemployment crime crowding occupation vehicle house_amentities house_tenure house_size single_parent house_structure) ///
		cov( education*age income*age occupation*income unemployment*income income*house_amentities) ///
		nocapslatent

predict ses_com_l_full*, scores

*Create summed ses index scores
egen ses_score_l_full = rowtotal(ses_com_l_full*)

*Ranking ses scores
egen rank_ses_score_l_full = rank(ses_score_l_full)
label var rank_ses_score_l_full "Ranking of SES Score using SEM Full VSM model"	
	
*-------------------------------------------------------------------------------
								  
*Large Variable Model from LASSO Regression (CV model)
	
sem 	(education -> per_m_education_less_secondary, ) (education -> per_m_education_tertiary, ) (education -> per_f_education_less_secondary, ) ///
		(age -> per_m_young_age_depend, ) (age -> per_f_old_age_depend, ) (age -> per_f_young_age_depend, ) ///
		(income -> per_m_income_0_49, ) (income -> m_income_median, ) (income -> f_income_median, ) (income -> per_f_high_income, ) ///
		(occupation -> per_f_prof_occupation, ) (occupation -> per_m_prof_n_techoccupation, ) (occupation -> per_f_prof_techoccupation, ) (occupation -> per_m_prof_occupation, ) ///
		(unemployment -> per_f_unemployment, ) (unemployment -> per_m_unemployment, ) ///
		(race -> per_f_non_black, ) ///
		(house_amentities -> per_amentities_wash, ) (house_amentities -> per_amentities_tv, ) (house_amentities -> per_amentities_computer, ) (house_amentities -> per_amentities_microwave, ) ///
		(rent -> per_renting, ) ///
		(vehicle -> per_vehicle_presence, ) ///
		(house_size -> hsize_mean, ) ///
		(crime -> per_crime_victim, ) ///
		(house_structure -> per_bedrooms_less_2, ) (house_structure -> per_bathroom_0, ) (house_structure -> per_rooms_less_3, ) ///
		(crowding -> per_live_5_more, ) ///
		(single_parent -> per_smother_total, ) ///
		covstruct(_lexogenous, diagonal) vce(jackknife) ///
		latent (education age income occupation unemployment race house_amentities rent vehicle house_size crime house_structure crowding single_parent) ///
		cov( education*age income*age occupation*income unemployment*income income*house_amentities) ///
		nocapslatent
			
predict ses_com_cv*, scores

*Create summed ses index scores
egen ses_score_cv = rowtotal(ses_com_cv*)

*Ranking ses scores
egen rank_ses_score_cv = rank(ses_score_cv)
label var rank_ses_score_cv "Ranking of SES Score using SEM and LASSO CV VSM model"

*-------------------------------------------------------------------------------

*Large Variable Model from LASSO Regression (minBIC model)

sem 	(education -> per_m_education_less_secondary, ) (education -> per_m_education_tertiary, )  ///
		(age -> per_m_young_age_depend, ) (age -> per_f_young_age_depend, ) (age -> m_age_median, ) ///
		(income -> per_m_high_income, ) ///
		(occupation -> per_f_prof_occupation, ) (occupation -> per_m_prof_n_techoccupation, ) (occupation -> per_f_prof_techoccupation, ) (occupation -> per_m_prof_occupation, ) ///
		(unemployment -> per_f_unemployment, )  ///
		(race -> per_f_non_black, ) ///
		(house_amentities -> per_amentities_microwave, ) ///
		(rent -> per_renting, ) ///
		(vehicle -> per_vehicle_presence, ) ///
		(house_structure -> per_bedrooms_less_2, ) (house_structure -> per_bathroom_0, ) ///
		(single_parent -> per_smother_total, )  ///
		(house_tenure -> per_htenure_owned, ) ///
		covstruct(_lexogenous, diagonal) vce(jackknife) ///
		latent (education age income occupation unemployment race house_amentities rent vehicle  house_structure single_parent house_tenure) ///
		cov( education*age income*age occupation*income unemployment*income income*house_amentities) ///
		nocapslatent

predict ses_com_minBIC*, scores

*Create summed ses index scores
egen ses_score_minBIC = rowtotal(ses_com_minBIC*)

*Ranking ses scores
egen rank_ses_score_minBIC = rank(ses_score_minBIC)
label var rank_ses_score_minBIC "Ranking of SES Score using SEM and LASSO minBIC VSM model"

*-------------------------------------------------------------------------------

*Large Variable Model from LASSO Regression (adaptive model)

sem 	(education -> per_m_education_less_secondary, ) (education -> per_m_education_tertiary, )  ///
		(age -> per_m_young_age_depend, ) (age -> per_f_old_age_depend, ) (age -> per_f_young_age_depend, ) ///
		(income -> per_m_income_0_49, ) (income -> m_income_median, ) ///
		(occupation -> per_f_prof_occupation, ) (occupation -> per_m_prof_n_techoccupation, ) (occupation -> per_f_prof_techoccupation, )  ///
		(unemployment -> per_f_unemployment, )  ///
		(race -> per_f_non_black, ) ///
		(house_amentities -> per_amentities_wash, ) (house_amentities -> per_amentities_tv, ) (house_amentities -> per_amentities_computer, ) (house_amentities -> per_amentities_microwave, ) ///
		(rent -> per_renting, ) ///
		(vehicle -> per_vehicle_presence, ) ///
		(house_size -> hsize_mean, ) ///
		(crime -> per_crime_victim, ) ///
		(house_structure -> per_bedrooms_less_2, ) (house_structure -> per_bathroom_0, )  ///
		(single_parent -> per_smother_total, ) ///
		covstruct(_lexogenous, diagonal) vce(jackknife) ///
		latent (education age income occupation unemployment race house_amentities rent vehicle house_size crime house_structure single_parent) ///
		cov( education*age income*age occupation*income unemployment*income income*house_amentities) ///
		nocapslatent

predict ses_com_adapt*, scores

*Create summed ses index scores
egen ses_score_adapt = rowtotal(ses_com_adapt*)

*Ranking ses scores
egen rank_ses_score_adapt = rank(ses_score_adapt)
label var rank_ses_score_adapt "Ranking of SES Score using SEM and LASSO Adaptive VSM model"


*-------------------------------------------------------------------------------


*Summary Statistics of ses index score by parish
tabstat ses_score_l_full ses_score_cv ses_score_minBIC ses_score_adapt, by(parish) stat(mean) col(stat)


*-------------------------END---------------------------------------------------
