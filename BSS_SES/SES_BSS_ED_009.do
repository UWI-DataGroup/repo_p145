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
	
predict ses_com*, scores

*Create summed ses index scores
egen ses_score = rowtotal(ses_com*)

*Summary Statistics of ses index score by parish
tabstat ses_score, by(parish) stat(mean) col(stat)


*-------------------------END---------------------------------------------------
