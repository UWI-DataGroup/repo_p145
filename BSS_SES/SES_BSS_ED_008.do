clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_008.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	27/11/2019
**	Date Modified: 	29/11/2019
**  Algorithm Task: Variable Model Selection


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

*VARIABLE MODEL SELECTION

/*
Method: Each variable will be added individually for the PCA model
Different component retention methods will be utilized begining with eign values
>1 for inital component retention method
Scores from each model will be computed using either varimax or Direc oblique
Oblamin rotation.  
*/

keep if data == 0

local predictors $xlist
local X
foreach x of loc predictors {
    local X `X' `x'
    pca pop_density `X', mineigen(1)
	rotate, varimax blank (0.3)
	predict com*_vari_eigen1
}




