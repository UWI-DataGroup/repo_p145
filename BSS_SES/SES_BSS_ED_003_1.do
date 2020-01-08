clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_003_1.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	28/10/2019
**	Date Modified: 	18/12/2019
**  Algorithm Task: Normality and Transformations


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
*WINDOWS
local logpath "X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145"
*MAC
*local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"


**Aggregated output path
*WINDOWS
local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"
*MAC
*local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*swilk
*per_m_young_age_depend   hsize_mean per_f_education_less_secondary per_t_education_less_secondary per_amentities_tv
*sktest
*per_amentities_tv per_amentities_microwave per_vehicles_0 per_m_prof_techoccupation per_t_education_less_secondary per_f_education_less_secondary per_m_young_age_depend

** ------------------------------------------
** FILE 1-PCA ANALYSIS
** ------------------------------------------

use "`datapath'/version01/2-working/BSS_SES/BSS_SES_002", clear

**Initalize macros
global xlist		per_f_non_black per_m_non_black	per_t_non_black			///
					f_age_median m_age_median t_age_median				///
					per_f_young_age_depend per_m_young_age_depend per_t_young_age_depend ///
					per_f_old_age_depend per_m_old_age_depend per_t_old_age_depend				///
					hsize_mean per_htenure_owned per_renting per_smother_total ///
					per_f_education_less_secondary per_m_education_less_secondary per_t_education_less_secondary  ///
					per_f_education_tertiary per_m_education_tertiary per_t_education_tertiary		///
					per_f_income_0_49 per_m_income_0_49	per_t_income_0_49					///
					per_f_high_income per_m_high_income	per_t_high_income					///
					f_income_median m_income_median t_income_median						///
					per_f_unemployment per_m_unemployment per_t_unemployment					///			
					per_live_5_more per_crime_victim ///
					per_f_manage_occupation per_m_manage_occupation	per_t_manage_occupation		///
					per_f_prof_occupation per_m_prof_occupation	per_t_prof_occupation			///
					per_f_prof_techoccupation per_m_prof_techoccupation per_t_prof_techoccupation ///			
					per_f_prof_n_techoccupation per_m_prof_n_techoccupation per_t_prof_n_techoccupation ///
					per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0		///
					per_toilet_presence										///
					per_vehicle_presence per_vehicles_0 per_amentities_stove	///
					per_amentities_fridge per_amentities_microwave 	///
					per_amentities_tv per_amentities_radio			///
					per_amentities_wash per_amentities_computer	///
					per_electricity			
global ED



*Skewness Tests
sktest $xlist




foreach x in 		per_f_non_black per_m_non_black	per_t_non_black			///
					f_age_median m_age_median t_age_median				///
					per_f_young_age_depend per_t_young_age_depend ///
					per_f_old_age_depend per_m_old_age_depend per_t_old_age_depend				///
					hsize_mean per_htenure_owned per_renting per_smother_total ///
					per_m_education_less_secondary   ///
					per_f_education_tertiary per_m_education_tertiary per_t_education_tertiary		///
					per_f_income_0_49 per_m_income_0_49	per_t_income_0_49					///
					per_f_high_income per_m_high_income	per_t_high_income					///
					f_income_median m_income_median t_income_median						///
					per_f_unemployment per_m_unemployment per_t_unemployment					///			
					per_live_5_more per_crime_victim ///
					per_f_manage_occupation per_m_manage_occupation	per_t_manage_occupation		///
					per_f_prof_occupation per_m_prof_occupation	per_t_prof_occupation			///
					per_f_prof_techoccupation per_t_prof_techoccupation ///			
					per_f_prof_n_techoccupation per_m_prof_n_techoccupation per_t_prof_n_techoccupation ///
					per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0		///
					per_toilet_presence										///
					per_vehicle_presence  per_amentities_stove	///
					per_amentities_fridge  	///
					per_amentities_radio			///
					per_amentities_wash per_amentities_computer	///
					per_electricity	{
					
					
gen ln`x' = ln(`x')

recode ln`x' (.=0)

sktest ln`x'

gladder ln`x', name(ln`x')
					}



					

					
					
					
					
					
					
					
					
gladder lnf_age_median



