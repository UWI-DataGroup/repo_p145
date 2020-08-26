
** HEADER -----------------------------------------------------

*Clear screen
cls

*DO FILE META DATA
    //  algorithm name          BE_scoping_review_002
    //  project:                PhD Streetscapes
	//	sub-project:			Built environment scoping review
    //  analysts:               Kern ROCKE
    //  date first created      25-AUG-2020
    // 	date last modified      25-AUG-2020
    //  algorithm task          Importing Full-text review results from RedCAP to STATA
    //  status                  Completed

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

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Scoping Review/SR_PA_002.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------


import delimited record_id redcap_data_access_group data_extractor author ///
				 publication_year manuscript_title journal status ///
				 exclusion_reason other_reason_exclusion ///
				 publication_informat_v_0 study_design___1 study_design___2 ///
				 study_design___3 study_design___4 study_design___5 ///
				 study_design___6 study_design___7 study_design___8 ///
				 study_design___9 study_design___10 study_design___11 ///
				 other_study_design study_setting___1 study_setting___2 ///
				 sids_setting___1 sids_setting___2 sids_setting___3 ///
				 la_setting___1 la_setting___2 la_setting___3 la_setting___4 ///
				 north_central_setting___1 north_central_setting___2 ///
				 north_central_setting___3 north_central_setting___4 ///
				 north_central_setting___5 north_central_setting___6 ///
				 north_central_setting___7 north_central_setting___8 ///
				 north_central_setting___9 north_central_setting___10 ///
				 south_america_setting___1 south_america_setting___2 ///
				 south_america_setting___3 south_america_setting___4 ///
				 south_america_setting___5 south_america_setting___6 ///
				 south_america_setting___7 south_america_setting___8 ///
				 south_america_setting___9 south_america_setting___10 ///
				 south_america_setting___11 south_america_setting___12 ///
				 south_america_setting___13 south_america_setting___14 ///
				 south_america_setting___15 caribbean_countries___1 ///
				 caribbean_countries___2 caribbean_countries___3 ///
				 caribbean_countries___4 caribbean_countries___5 ///
				 caribbean_countries___6 caribbean_countries___7 ///
				 caribbean_countries___8 caribbean_countries___9 ///
				 caribbean_countries___10 caribbean_countries___11 ///
				 caribbean_countries___12 caribbean_countries___13 ///
				 caribbean_countries___14 caribbean_countries___15 ///
				 caribbean_countries___16 caribbean_countries___17 ///
				 caribbean_countries___18 caribbean_countries___19 ///
				 caribbean_countries___20 caribbean_countries___21 ///
				 caribbean_countries___22 caribbean_countries___23 ///
				 caribbean_countries___24 caribbean_countries___25 ///
				 caribbean_countries___26 caribbean_countries___27 ///
				 caribbean_countries___28 caribbean_countries___29 ///
				 caribbean_countries___30 caribbean_countries___31 ///
				 pacific_countries___1 pacific_countries___2 ///
				 pacific_countries___3 pacific_countries___4 ///
				 pacific_countries___5 pacific_countries___6 ///
				 pacific_countries___7 pacific_countries___8 ///
				 pacific_countries___9 pacific_countries___10 ///
				 pacific_countries___11 pacific_countries___12 ///
				 pacific_countries___13 pacific_countries___14 ///
				 pacific_countries___15 pacific_countries___16 ///
				 pacific_countries___17 pacific_countries___18 ///
				 pacific_countries___19 pacific_countries___20 ///
				 pacific_countries___21 aims_countries___1 ///
				 aims_countries___2 aims_countries___3 aims_countries___4 ///
				 aims_countries___5 aims_countries___6 aims_countries___7 ///
				 aims_countries___8 aims_countries___9 aims_countries___10 ///
				 aims_countries___11 non_sid_country non_sids_countries_list ///
				 project_name study_aim study_period population_type gender ///
				 sample_size age_range ses_setting___1 ses_setting___2 ///
				 ses_setting___3 ses_setting___4 be_gis___1 be_gis___2 ///
				 be_gis___3 be_gis___4 main_findings be_attributes___1 ///
				 be_attributes___2 be_attributes___3 be_attributes___4 ///
				 be_attributes___5 be_attributes___6 be_attributes___7 ///
				 be_attributes___8 be_attributes___9 be_attributes___10 ///
				 be_attributes___11 be_attributes___12 be_attributes___13 ///
				 other_be_attributes surveillance_be experience_be ///
				 parking_example_parking_lo traffic_safety community_nd ///
				 greenspace_nd density_nd connectivity_nd lands_nd ///
				 neigh_self_selection self_selection_attribute___1 ///
				 self_selection_attribute___2 self_selection_attribute___3 ///
				 self_selection_attribute___4 self_selection_attribute___5 ///
				 self_selection_attribute___6 self_selection_attribute___7 ///
				 pa_measure_type activity_type___1 activity_type___2 ///
				 activity_type___3 activity_type___4 activity_type___5 ///
				 activity_type___6 activity_type___7 other_activity_type ///
				 connectivity___1 connectivity___2 connectivity___3 ///
				 connectivity___4 convenience___1 convenience___2 ///
				 convenience___3 convenience___4 comfort___1 comfort___2 ///
				 comfort___3 comfort___4 comfort___5 comfort___6 comfort___7 ///
				 comfort___8 comfort___9 comfort___10 conviviality___1 ///
				 conviviality___2 conviviality___3 conviviality___4 ///
				 conviviality___5 conviviality___6 conviviality___7 ///
				 conviviality___8 conspicuousness___1 conspicuousness___2 ///
				 conspicuousness___3 conspicuousness___4 coexistence___1 ///
				 coexistence___2 coexistence___3 commitment___1 ///
				 commitment___2 commitment___3 commitment___4 outcome_name ///
				 outcome_definition unit_measurre secondary_outcome ///
				 secondary_definnition confounders conclude ///
				 extraction_informati_v_1 ///
				 using "`datapath'/version01/1-input/Scoping Review/BuiltEnvironmentAndP_DATA_NOHDRS_2020-08-25_0024.csv", varnames(nonames)

label data "BuiltEnvironmentAndP_DATA_NOHDRS_2020-08-25_0024.csv"


label define data_extractor_ 1 "KR" 2 "CH" 
label define status_ 1 "Include" 2 "Exclude" 
label define exclusion_reason_ 1 "Ineligible year" 2 "Ineligible country (Not SIDS/Latin America)" 3 "Ineligible language" 4 "Inaccessible record OR full-text does not exist" 5 "Ineligible study design" 6 "Other" 
label define publication_informat_v_0_ 0 "Incomplete" 1 "Unverified" 2 "Complete" 
label define study_design___1_ 0 "Unchecked" 1 "Checked" 
label define study_design___2_ 0 "Unchecked" 1 "Checked" 
label define study_design___3_ 0 "Unchecked" 1 "Checked" 
label define study_design___4_ 0 "Unchecked" 1 "Checked" 
label define study_design___5_ 0 "Unchecked" 1 "Checked" 
label define study_design___6_ 0 "Unchecked" 1 "Checked" 
label define study_design___7_ 0 "Unchecked" 1 "Checked" 
label define study_design___8_ 0 "Unchecked" 1 "Checked" 
label define study_design___9_ 0 "Unchecked" 1 "Checked" 
label define study_design___10_ 0 "Unchecked" 1 "Checked" 
label define study_design___11_ 0 "Unchecked" 1 "Checked" 
label define study_setting___1_ 0 "Unchecked" 1 "Checked" 
label define study_setting___2_ 0 "Unchecked" 1 "Checked" 
label define sids_setting___1_ 0 "Unchecked" 1 "Checked" 
label define sids_setting___2_ 0 "Unchecked" 1 "Checked" 
label define sids_setting___3_ 0 "Unchecked" 1 "Checked" 
label define la_setting___1_ 0 "Unchecked" 1 "Checked" 
label define la_setting___2_ 0 "Unchecked" 1 "Checked" 
label define la_setting___3_ 0 "Unchecked" 1 "Checked" 
label define la_setting___4_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___1_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___2_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___3_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___4_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___5_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___6_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___7_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___8_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___9_ 0 "Unchecked" 1 "Checked" 
label define north_central_setting___10_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___1_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___2_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___3_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___4_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___5_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___6_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___7_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___8_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___9_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___10_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___11_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___12_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___13_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___14_ 0 "Unchecked" 1 "Checked" 
label define south_america_setting___15_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___1_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___2_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___3_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___4_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___5_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___6_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___7_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___8_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___9_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___10_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___11_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___12_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___13_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___14_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___15_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___16_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___17_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___18_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___19_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___20_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___21_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___22_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___23_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___24_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___25_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___26_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___27_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___28_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___29_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___30_ 0 "Unchecked" 1 "Checked" 
label define caribbean_countries___31_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___1_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___2_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___3_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___4_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___5_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___6_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___7_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___8_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___9_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___10_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___11_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___12_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___13_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___14_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___15_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___16_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___17_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___18_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___19_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___20_ 0 "Unchecked" 1 "Checked" 
label define pacific_countries___21_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___1_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___2_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___3_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___4_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___5_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___6_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___7_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___8_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___9_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___10_ 0 "Unchecked" 1 "Checked" 
label define aims_countries___11_ 0 "Unchecked" 1 "Checked" 
label define non_sid_country_ 1 "Yes" 0 "No" 
label define population_type_ 1 "Adult" 2 "Children/Adolescents" 3 "Adult and Children/Adolescents" 4 "None Stated" 
label define gender_ 1 "Male" 2 "Female" 3 "Both (Male/Female)" 4 "Non-stated" 
label define ses_setting___1_ 0 "Unchecked" 1 "Checked" 
label define ses_setting___2_ 0 "Unchecked" 1 "Checked" 
label define ses_setting___3_ 0 "Unchecked" 1 "Checked" 
label define ses_setting___4_ 0 "Unchecked" 1 "Checked" 
label define be_gis___1_ 0 "Unchecked" 1 "Checked" 
label define be_gis___2_ 0 "Unchecked" 1 "Checked" 
label define be_gis___3_ 0 "Unchecked" 1 "Checked" 
label define be_gis___4_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___1_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___2_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___3_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___4_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___5_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___6_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___7_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___8_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___9_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___10_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___11_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___12_ 0 "Unchecked" 1 "Checked" 
label define be_attributes___13_ 0 "Unchecked" 1 "Checked" 
label define neigh_self_selection_ 1 "Yes" 0 "No" 
label define self_selection_attribute___1_ 0 "Unchecked" 1 "Checked" 
label define self_selection_attribute___2_ 0 "Unchecked" 1 "Checked" 
label define self_selection_attribute___3_ 0 "Unchecked" 1 "Checked" 
label define self_selection_attribute___4_ 0 "Unchecked" 1 "Checked" 
label define self_selection_attribute___5_ 0 "Unchecked" 1 "Checked" 
label define self_selection_attribute___6_ 0 "Unchecked" 1 "Checked" 
label define self_selection_attribute___7_ 0 "Unchecked" 1 "Checked" 
label define pa_measure_type_ 1 "Objective" 2 "Self-Reported" 3 "Both (Objective & Self-Reported)" 
label define activity_type___1_ 0 "Unchecked" 1 "Checked" 
label define activity_type___2_ 0 "Unchecked" 1 "Checked" 
label define activity_type___3_ 0 "Unchecked" 1 "Checked" 
label define activity_type___4_ 0 "Unchecked" 1 "Checked" 
label define activity_type___5_ 0 "Unchecked" 1 "Checked" 
label define activity_type___6_ 0 "Unchecked" 1 "Checked" 
label define activity_type___7_ 0 "Unchecked" 1 "Checked" 
label define connectivity___1_ 0 "Unchecked" 1 "Checked" 
label define connectivity___2_ 0 "Unchecked" 1 "Checked" 
label define connectivity___3_ 0 "Unchecked" 1 "Checked" 
label define connectivity___4_ 0 "Unchecked" 1 "Checked" 
label define convenience___1_ 0 "Unchecked" 1 "Checked" 
label define convenience___2_ 0 "Unchecked" 1 "Checked" 
label define convenience___3_ 0 "Unchecked" 1 "Checked" 
label define convenience___4_ 0 "Unchecked" 1 "Checked" 
label define comfort___1_ 0 "Unchecked" 1 "Checked" 
label define comfort___2_ 0 "Unchecked" 1 "Checked" 
label define comfort___3_ 0 "Unchecked" 1 "Checked" 
label define comfort___4_ 0 "Unchecked" 1 "Checked" 
label define comfort___5_ 0 "Unchecked" 1 "Checked" 
label define comfort___6_ 0 "Unchecked" 1 "Checked" 
label define comfort___7_ 0 "Unchecked" 1 "Checked" 
label define comfort___8_ 0 "Unchecked" 1 "Checked" 
label define comfort___9_ 0 "Unchecked" 1 "Checked" 
label define comfort___10_ 0 "Unchecked" 1 "Checked" 
label define conviviality___1_ 0 "Unchecked" 1 "Checked" 
label define conviviality___2_ 0 "Unchecked" 1 "Checked" 
label define conviviality___3_ 0 "Unchecked" 1 "Checked" 
label define conviviality___4_ 0 "Unchecked" 1 "Checked" 
label define conviviality___5_ 0 "Unchecked" 1 "Checked" 
label define conviviality___6_ 0 "Unchecked" 1 "Checked" 
label define conviviality___7_ 0 "Unchecked" 1 "Checked" 
label define conviviality___8_ 0 "Unchecked" 1 "Checked" 
label define conspicuousness___1_ 0 "Unchecked" 1 "Checked" 
label define conspicuousness___2_ 0 "Unchecked" 1 "Checked" 
label define conspicuousness___3_ 0 "Unchecked" 1 "Checked" 
label define conspicuousness___4_ 0 "Unchecked" 1 "Checked" 
label define coexistence___1_ 0 "Unchecked" 1 "Checked" 
label define coexistence___2_ 0 "Unchecked" 1 "Checked" 
label define coexistence___3_ 0 "Unchecked" 1 "Checked" 
label define commitment___1_ 0 "Unchecked" 1 "Checked" 
label define commitment___2_ 0 "Unchecked" 1 "Checked" 
label define commitment___3_ 0 "Unchecked" 1 "Checked" 
label define commitment___4_ 0 "Unchecked" 1 "Checked" 
label define extraction_informati_v_1_ 0 "Incomplete" 1 "Unverified" 2 "Complete" 
label values data_extractor data_extractor_
label values status status_
label values exclusion_reason exclusion_reason_
label values publication_informat_v_0 publication_informat_v_0_
label values study_design___1 study_design___1_
label values study_design___2 study_design___2_
label values study_design___3 study_design___3_
label values study_design___4 study_design___4_
label values study_design___5 study_design___5_
label values study_design___6 study_design___6_
label values study_design___7 study_design___7_
label values study_design___8 study_design___8_
label values study_design___9 study_design___9_
label values study_design___10 study_design___10_
label values study_design___11 study_design___11_
label values study_setting___1 study_setting___1_
label values study_setting___2 study_setting___2_
label values sids_setting___1 sids_setting___1_
label values sids_setting___2 sids_setting___2_
label values sids_setting___3 sids_setting___3_
label values la_setting___1 la_setting___1_
label values la_setting___2 la_setting___2_
label values la_setting___3 la_setting___3_
label values la_setting___4 la_setting___4_
label values north_central_setting___1 north_central_setting___1_
label values north_central_setting___2 north_central_setting___2_
label values north_central_setting___3 north_central_setting___3_
label values north_central_setting___4 north_central_setting___4_
label values north_central_setting___5 north_central_setting___5_
label values north_central_setting___6 north_central_setting___6_
label values north_central_setting___7 north_central_setting___7_
label values north_central_setting___8 north_central_setting___8_
label values north_central_setting___9 north_central_setting___9_
label values north_central_setting___10 north_central_setting___10_
label values south_america_setting___1 south_america_setting___1_
label values south_america_setting___2 south_america_setting___2_
label values south_america_setting___3 south_america_setting___3_
label values south_america_setting___4 south_america_setting___4_
label values south_america_setting___5 south_america_setting___5_
label values south_america_setting___6 south_america_setting___6_
label values south_america_setting___7 south_america_setting___7_
label values south_america_setting___8 south_america_setting___8_
label values south_america_setting___9 south_america_setting___9_
label values south_america_setting___10 south_america_setting___10_
label values south_america_setting___11 south_america_setting___11_
label values south_america_setting___12 south_america_setting___12_
label values south_america_setting___13 south_america_setting___13_
label values south_america_setting___14 south_america_setting___14_
label values south_america_setting___15 south_america_setting___15_
label values caribbean_countries___1 caribbean_countries___1_
label values caribbean_countries___2 caribbean_countries___2_
label values caribbean_countries___3 caribbean_countries___3_
label values caribbean_countries___4 caribbean_countries___4_
label values caribbean_countries___5 caribbean_countries___5_
label values caribbean_countries___6 caribbean_countries___6_
label values caribbean_countries___7 caribbean_countries___7_
label values caribbean_countries___8 caribbean_countries___8_
label values caribbean_countries___9 caribbean_countries___9_
label values caribbean_countries___10 caribbean_countries___10_
label values caribbean_countries___11 caribbean_countries___11_
label values caribbean_countries___12 caribbean_countries___12_
label values caribbean_countries___13 caribbean_countries___13_
label values caribbean_countries___14 caribbean_countries___14_
label values caribbean_countries___15 caribbean_countries___15_
label values caribbean_countries___16 caribbean_countries___16_
label values caribbean_countries___17 caribbean_countries___17_
label values caribbean_countries___18 caribbean_countries___18_
label values caribbean_countries___19 caribbean_countries___19_
label values caribbean_countries___20 caribbean_countries___20_
label values caribbean_countries___21 caribbean_countries___21_
label values caribbean_countries___22 caribbean_countries___22_
label values caribbean_countries___23 caribbean_countries___23_
label values caribbean_countries___24 caribbean_countries___24_
label values caribbean_countries___25 caribbean_countries___25_
label values caribbean_countries___26 caribbean_countries___26_
label values caribbean_countries___27 caribbean_countries___27_
label values caribbean_countries___28 caribbean_countries___28_
label values caribbean_countries___29 caribbean_countries___29_
label values caribbean_countries___30 caribbean_countries___30_
label values caribbean_countries___31 caribbean_countries___31_
label values pacific_countries___1 pacific_countries___1_
label values pacific_countries___2 pacific_countries___2_
label values pacific_countries___3 pacific_countries___3_
label values pacific_countries___4 pacific_countries___4_
label values pacific_countries___5 pacific_countries___5_
label values pacific_countries___6 pacific_countries___6_
label values pacific_countries___7 pacific_countries___7_
label values pacific_countries___8 pacific_countries___8_
label values pacific_countries___9 pacific_countries___9_
label values pacific_countries___10 pacific_countries___10_
label values pacific_countries___11 pacific_countries___11_
label values pacific_countries___12 pacific_countries___12_
label values pacific_countries___13 pacific_countries___13_
label values pacific_countries___14 pacific_countries___14_
label values pacific_countries___15 pacific_countries___15_
label values pacific_countries___16 pacific_countries___16_
label values pacific_countries___17 pacific_countries___17_
label values pacific_countries___18 pacific_countries___18_
label values pacific_countries___19 pacific_countries___19_
label values pacific_countries___20 pacific_countries___20_
label values pacific_countries___21 pacific_countries___21_
label values aims_countries___1 aims_countries___1_
label values aims_countries___2 aims_countries___2_
label values aims_countries___3 aims_countries___3_
label values aims_countries___4 aims_countries___4_
label values aims_countries___5 aims_countries___5_
label values aims_countries___6 aims_countries___6_
label values aims_countries___7 aims_countries___7_
label values aims_countries___8 aims_countries___8_
label values aims_countries___9 aims_countries___9_
label values aims_countries___10 aims_countries___10_
label values aims_countries___11 aims_countries___11_
label values non_sid_country non_sid_country_
label values population_type population_type_
label values gender gender_
label values ses_setting___1 ses_setting___1_
label values ses_setting___2 ses_setting___2_
label values ses_setting___3 ses_setting___3_
label values ses_setting___4 ses_setting___4_
label values be_gis___1 be_gis___1_
label values be_gis___2 be_gis___2_
label values be_gis___3 be_gis___3_
label values be_gis___4 be_gis___4_
label values be_attributes___1 be_attributes___1_
label values be_attributes___2 be_attributes___2_
label values be_attributes___3 be_attributes___3_
label values be_attributes___4 be_attributes___4_
label values be_attributes___5 be_attributes___5_
label values be_attributes___6 be_attributes___6_
label values be_attributes___7 be_attributes___7_
label values be_attributes___8 be_attributes___8_
label values be_attributes___9 be_attributes___9_
label values be_attributes___10 be_attributes___10_
label values be_attributes___11 be_attributes___11_
label values be_attributes___12 be_attributes___12_
label values be_attributes___13 be_attributes___13_
label values neigh_self_selection neigh_self_selection_
label values self_selection_attribute___1 self_selection_attribute___1_
label values self_selection_attribute___2 self_selection_attribute___2_
label values self_selection_attribute___3 self_selection_attribute___3_
label values self_selection_attribute___4 self_selection_attribute___4_
label values self_selection_attribute___5 self_selection_attribute___5_
label values self_selection_attribute___6 self_selection_attribute___6_
label values self_selection_attribute___7 self_selection_attribute___7_
label values pa_measure_type pa_measure_type_
label values activity_type___1 activity_type___1_
label values activity_type___2 activity_type___2_
label values activity_type___3 activity_type___3_
label values activity_type___4 activity_type___4_
label values activity_type___5 activity_type___5_
label values activity_type___6 activity_type___6_
label values activity_type___7 activity_type___7_
label values connectivity___1 connectivity___1_
label values connectivity___2 connectivity___2_
label values connectivity___3 connectivity___3_
label values connectivity___4 connectivity___4_
label values convenience___1 convenience___1_
label values convenience___2 convenience___2_
label values convenience___3 convenience___3_
label values convenience___4 convenience___4_
label values comfort___1 comfort___1_
label values comfort___2 comfort___2_
label values comfort___3 comfort___3_
label values comfort___4 comfort___4_
label values comfort___5 comfort___5_
label values comfort___6 comfort___6_
label values comfort___7 comfort___7_
label values comfort___8 comfort___8_
label values comfort___9 comfort___9_
label values comfort___10 comfort___10_
label values conviviality___1 conviviality___1_
label values conviviality___2 conviviality___2_
label values conviviality___3 conviviality___3_
label values conviviality___4 conviviality___4_
label values conviviality___5 conviviality___5_
label values conviviality___6 conviviality___6_
label values conviviality___7 conviviality___7_
label values conviviality___8 conviviality___8_
label values conspicuousness___1 conspicuousness___1_
label values conspicuousness___2 conspicuousness___2_
label values conspicuousness___3 conspicuousness___3_
label values conspicuousness___4 conspicuousness___4_
label values coexistence___1 coexistence___1_
label values coexistence___2 coexistence___2_
label values coexistence___3 coexistence___3_
label values commitment___1 commitment___1_
label values commitment___2 commitment___2_
label values commitment___3 commitment___3_
label values commitment___4 commitment___4_
label values extraction_informati_v_1 extraction_informati_v_1_



label variable record_id "Record ID"
label variable redcap_data_access_group "Data Access Group"
label variable data_extractor "Data extractor"
label variable author "First author (last name)"
label variable publication_year "Year of publication"
label variable manuscript_title "Manuscript Title"
label variable journal "Publication journal"
label variable status "Eligibility status"
label variable exclusion_reason "Reason for exclusion  Note: Based on if study does not meet the criteria listed"
label variable other_reason_exclusion "Please state (other):"
label variable publication_informat_v_0 "Complete?"
label variable study_design___1 "Study design (choice=Ecological)"
label variable study_design___2 "Study design (choice=Cross-Sectional)"
label variable study_design___3 "Study design (choice=Case-Control)"
label variable study_design___4 "Study design (choice=Cohort (Prospective/Retrospective))"
label variable study_design___5 "Study design (choice=Non-randomized trial)"
label variable study_design___6 "Study design (choice=Randomized trial)"
label variable study_design___7 "Study design (choice=Quasi-experiment/ ranndomized controlled trial)"
label variable study_design___8 "Study design (choice=Review)"
label variable study_design___9 "Study design (choice=Interrupted Time Series)"
label variable study_design___10 "Study design (choice=Other)"
label variable study_design___11 "Study design (choice=None or not appropriate)"
label variable other_study_design "Please state (Other):"
label variable study_setting___1 "Study setting (choice=SIDS)"
label variable study_setting___2 "Study setting (choice=Latin America)"
label variable sids_setting___1 "SIDS Setting (choice=Caribbean)"
label variable sids_setting___2 "SIDS Setting (choice=Pacific)"
label variable sids_setting___3 "SIDS Setting (choice=AIMS)"
label variable la_setting___1 "Latin American Setting (choice=North and Central America)"
label variable la_setting___2 "Latin American Setting (choice=South America)"
label variable la_setting___3 "Latin American Setting (choice=Entire region)"
label variable la_setting___4 "Latin American Setting (choice=Not stated)"
label variable north_central_setting___1 "North and Central America Setting (choice=Belize)"
label variable north_central_setting___2 "North and Central America Setting (choice=Costa Rica)"
label variable north_central_setting___3 "North and Central America Setting (choice=El Salvador)"
label variable north_central_setting___4 "North and Central America Setting (choice=Guatemala)"
label variable north_central_setting___5 "North and Central America Setting (choice=Honduras)"
label variable north_central_setting___6 "North and Central America Setting (choice=Mexico)"
label variable north_central_setting___7 "North and Central America Setting (choice=Nicaragua)"
label variable north_central_setting___8 "North and Central America Setting (choice=Panama)"
label variable north_central_setting___9 "North and Central America Setting (choice=Entire region)"
label variable north_central_setting___10 "North and Central America Setting (choice=Not stated)"
label variable south_america_setting___1 "South America Setting (choice=Argentina)"
label variable south_america_setting___2 "South America Setting (choice=Bolivia)"
label variable south_america_setting___3 "South America Setting (choice=Brazil)"
label variable south_america_setting___4 "South America Setting (choice=Chile)"
label variable south_america_setting___5 "South America Setting (choice=Colombia)"
label variable south_america_setting___6 "South America Setting (choice=Ecuador)"
label variable south_america_setting___7 "South America Setting (choice=French Guiana)"
label variable south_america_setting___8 "South America Setting (choice=Guyana)"
label variable south_america_setting___9 "South America Setting (choice=Paraguay)"
label variable south_america_setting___10 "South America Setting (choice=Peru)"
label variable south_america_setting___11 "South America Setting (choice=Suriname)"
label variable south_america_setting___12 "South America Setting (choice=Uruguay)"
label variable south_america_setting___13 "South America Setting (choice=Venezuela)"
label variable south_america_setting___14 "South America Setting (choice=Entire region)"
label variable south_america_setting___15 "South America Setting (choice=Not stated)"
label variable caribbean_countries___1 "Caribbean Countries (choice=Anguilla)"
label variable caribbean_countries___2 "Caribbean Countries (choice=Antigua and Barbuda)"
label variable caribbean_countries___3 "Caribbean Countries (choice=Aruba)"
label variable caribbean_countries___4 "Caribbean Countries (choice=Bahamas)"
label variable caribbean_countries___5 "Caribbean Countries (choice=Barbados)"
label variable caribbean_countries___6 "Caribbean Countries (choice=Belize)"
label variable caribbean_countries___7 "Caribbean Countries (choice=Bermuda)"
label variable caribbean_countries___8 "Caribbean Countries (choice=British Virgin Islands)"
label variable caribbean_countries___9 "Caribbean Countries (choice=Cayman Islands)"
label variable caribbean_countries___10 "Caribbean Countries (choice=Cuba)"
label variable caribbean_countries___11 "Caribbean Countries (choice=Curacao)"
label variable caribbean_countries___12 "Caribbean Countries (choice=Dominica)"
label variable caribbean_countries___13 "Caribbean Countries (choice=Dominican Republic)"
label variable caribbean_countries___14 "Caribbean Countries (choice=Grenada)"
label variable caribbean_countries___15 "Caribbean Countries (choice=Guadeloupe)"
label variable caribbean_countries___16 "Caribbean Countries (choice=Guyana)"
label variable caribbean_countries___17 "Caribbean Countries (choice=Haiti)"
label variable caribbean_countries___18 "Caribbean Countries (choice=Jamaica)"
label variable caribbean_countries___19 "Caribbean Countries (choice=Martinique)"
label variable caribbean_countries___20 "Caribbean Countries (choice=Montserrat)"
label variable caribbean_countries___21 "Caribbean Countries (choice=Puerto Rico)"
label variable caribbean_countries___22 "Caribbean Countries (choice=Sint Maarten)"
label variable caribbean_countries___23 "Caribbean Countries (choice=St. Kitts and Nevis)"
label variable caribbean_countries___24 "Caribbean Countries (choice=St. Lucia)"
label variable caribbean_countries___25 "Caribbean Countries (choice=St. Vincent and the Grenadines)"
label variable caribbean_countries___26 "Caribbean Countries (choice=Suriname)"
label variable caribbean_countries___27 "Caribbean Countries (choice=Trinidad and Tobago)"
label variable caribbean_countries___28 "Caribbean Countries (choice=Turks and Caicos Islands)"
label variable caribbean_countries___29 "Caribbean Countries (choice=US Virgin Islands)"
label variable caribbean_countries___30 "Caribbean Countries (choice=Entire region)"
label variable caribbean_countries___31 "Caribbean Countries (choice=Not stated)"
label variable pacific_countries___1 "Pacific Countries (choice=American Samoa)"
label variable pacific_countries___2 "Pacific Countries (choice=Cook Islands)"
label variable pacific_countries___3 "Pacific Countries (choice=Fiji)"
label variable pacific_countries___4 "Pacific Countries (choice=French Polynesia)"
label variable pacific_countries___5 "Pacific Countries (choice=Guam)"
label variable pacific_countries___6 "Pacific Countries (choice=Kiribati)"
label variable pacific_countries___7 "Pacific Countries (choice=Marshall Islands)"
label variable pacific_countries___8 "Pacific Countries (choice=Federated States of Micronesia)"
label variable pacific_countries___9 "Pacific Countries (choice=Nauru)"
label variable pacific_countries___10 "Pacific Countries (choice=New Caledonia)"
label variable pacific_countries___11 "Pacific Countries (choice=Niue)"
label variable pacific_countries___12 "Pacific Countries (choice=Northern Mariana Islands)"
label variable pacific_countries___13 "Pacific Countries (choice=Palau)"
label variable pacific_countries___14 "Pacific Countries (choice=Papa New Guinea)"
label variable pacific_countries___15 "Pacific Countries (choice=Samoa)"
label variable pacific_countries___16 "Pacific Countries (choice=Solomon Islands)"
label variable pacific_countries___17 "Pacific Countries (choice=Timor-Leste)"
label variable pacific_countries___18 "Pacific Countries (choice=Tonga)"
label variable pacific_countries___19 "Pacific Countries (choice=Tuvalu)"
label variable pacific_countries___20 "Pacific Countries (choice=Entire region)"
label variable pacific_countries___21 "Pacific Countries (choice=Not stated)"
label variable aims_countries___1 "AIMS Countries (choice=Bahrain)"
label variable aims_countries___2 "AIMS Countries (choice=Cape Verde)"
label variable aims_countries___3 "AIMS Countries (choice=Comoros)"
label variable aims_countries___4 "AIMS Countries (choice=Guinea-Bissau)"
label variable aims_countries___5 "AIMS Countries (choice=Maldives)"
label variable aims_countries___6 "AIMS Countries (choice=Mauritius)"
label variable aims_countries___7 "AIMS Countries (choice=Sao Tome and Principe)"
label variable aims_countries___8 "AIMS Countries (choice=Seychelles)"
label variable aims_countries___9 "AIMS Countries (choice=Singapore)"
label variable aims_countries___10 "AIMS Countries (choice=Entire region)"
label variable aims_countries___11 "AIMS Countries (choice=Not stated)"
label variable non_sid_country "Was the study carried out with the addition of a non-SIDS/Latin American country?"
label variable non_sids_countries_list "Please state the country(s) involved"
label variable project_name "Project Name (If applicable)"
label variable study_aim "Aim of the study? "
label variable study_period "Study period"
label variable population_type "Population Type"
label variable gender "Gender"
label variable sample_size "Sample size"
label variable age_range "Sample age range"
label variable ses_setting___1 "Socioeconomic Setting (choice=Urban)"
label variable ses_setting___2 "Socioeconomic Setting (choice=Suburban)"
label variable ses_setting___3 "Socioeconomic Setting (choice=Rural)"
label variable ses_setting___4 "Socioeconomic Setting (choice=Not stated)"
label variable be_gis___1 "Method in which Built Environment is measured (choice=Remote Sensing)"
label variable be_gis___2 "Method in which Built Environment is measured (choice=GPS)"
label variable be_gis___3 "Method in which Built Environment is measured (choice=Desktop Mapping)"
label variable be_gis___4 "Method in which Built Environment is measured (choice=Audit)"
label variable main_findings "Main Study finndings"
label variable be_attributes___1 "Built Environment Attributes (choice=Residential/Population Density)"
label variable be_attributes___2 "Built Environment Attributes (choice=Street Connectivity/Street Intersections)"
label variable be_attributes___3 "Built Environment Attributes (choice=Mixed Land-Use)"
label variable be_attributes___4 "Built Environment Attributes (choice=Retail Floor)"
label variable be_attributes___5 "Built Environment Attributes (choice=Public Space/Parks/Open Space)"
label variable be_attributes___6 "Built Environment Attributes (choice=Recreation land use proximity)"
label variable be_attributes___7 "Built Environment Attributes (choice=Non-recreational land use proximity)"
label variable be_attributes___8 "Built Environment Attributes (choice=Transit proximity/access)"
label variable be_attributes___9 "Built Environment Attributes (choice=Trails/sidewalk/pathways/cycle ways)"
label variable be_attributes___10 "Built Environment Attributes (choice=Pedestrian amenities (street lighting/shade/furniture))"
label variable be_attributes___11 "Built Environment Attributes (choice=Walkability/pedestrian index)"
label variable be_attributes___12 "Built Environment Attributes (choice=Sprawl/Urbal sprawl/Urban form)"
label variable be_attributes___13 "Built Environment Attributes (choice=Other)"
label variable other_be_attributes "Please state (Other):"
label variable surveillance_be "Surveillance  Examples 	Provide lighting on streets 	Buildings located near streets 	Building entrance orientation towards street 	Building includes balconies and porches overlooking the street 	Windows located towards the street at pedestrian level with a clear view "
label variable experience_be "Experience  Examples 	Maintenance and cleaning programs in place for trash, graffiti and evenness of sidewalks 	Inclusion of trees and vegetation along streets, water bodies, landmarks, high fences and signage 	Garbage containers located away from sidewalks  "
label variable parking_example_parking_lo "Parking  Example 	Parking location behind buildings or in basements with entries towards secondary streets 	Ability to use of alternative modes of transportation "
label variable traffic_safety "Traffic Safety  Example 	Providing ample sidewalks and bike lanes 	Provide frequent and reliable bus service that connects to the rest of the city 	Bus stops have accompanied with it a safe and covered sitting area 	Sidewalks and bike lanes buffer (stripe of vegetation) present and on street parking 	Implementation of traffic calming treatments (speed limit signage, speed bumps, pedestrian only streets) "
label variable community_nd "Community  Example  	Inclusion of civic space, community centre, shared facilities and spaces for community gathering 	Encouragement of neighbourhood participation in organizations  "
label variable greenspace_nd "Greenspace  Example 	Homes having a view of nature 	Inclusion of greenspace 1/5/10 minute(s) walking distance from home "
label variable density_nd "Density  Example 	Inclusion of different types of housing options"
label variable connectivity_nd "Connectivity  Example 	Inclusion of grid street network 	Inclusion of multiple 4-way intersections 	Exclusion of dead end streets 	Exclusion of busy intersections"
label variable lands_nd "Land-use  Example 	Location of services within ½ or 1 mile from homes 	Areas with food stores, schools, recreational facilities"
label variable neigh_self_selection "Neighbourhood Self-Selection Considered"
label variable self_selection_attribute___1 "Neighbourhood Self-Selection Attribute (choice=Neighbourhood preference measured)"
label variable self_selection_attribute___2 "Neighbourhood Self-Selection Attribute (choice=Reason for neighbourhood migration)"
label variable self_selection_attribute___3 "Neighbourhood Self-Selection Attribute (choice=Instrumental variable analysis)"
label variable self_selection_attribute___4 "Neighbourhood Self-Selection Attribute (choice=Selection Model)"
label variable self_selection_attribute___5 "Neighbourhood Self-Selection Attribute (choice=Structural Equation models)"
label variable self_selection_attribute___6 "Neighbourhood Self-Selection Attribute (choice=Joint Probability models)"
label variable self_selection_attribute___7 "Neighbourhood Self-Selection Attribute (choice=Propensity Score Analysis)"
label variable pa_measure_type "Physical Activity Measure Type"
label variable activity_type___1 "Activity type (choice=Recreational walking)"
label variable activity_type___2 "Activity type (choice=Transportation walking)"
label variable activity_type___3 "Activity type (choice=General walking)"
label variable activity_type___4 "Activity type (choice=General cycling/biking)"
label variable activity_type___5 "Activity type (choice=Combined walk/cycle)"
label variable activity_type___6 "Activity type (choice=Moderate to vigorous physical activity (MVPA/METS))"
label variable activity_type___7 "Activity type (choice=Other)"
label variable other_activity_type "Please state (Other):"
label variable connectivity___1 "Connectivity (choice=Presence of Barriers)"
label variable connectivity___2 "Connectivity (choice=Intersection Density)"
label variable connectivity___3 "Connectivity (choice=Proximity to transport nodes (e.g. bus stops))"
label variable connectivity___4 "Connectivity (choice=Path Directness (Shortest Path))"
label variable convenience___1 "Convenience (choice=Pedestrian route Effective Width)"
label variable convenience___2 "Convenience (choice=Walkscore index (Land use diversity))"
label variable convenience___3 "Convenience (choice=Density of retail activities and services (Available destinations))"
label variable convenience___4 "Convenience (choice=Number of distinct commerce and services used on a daily basis)"
label variable comfort___1 "Comfort (choice=Vigilance (Building first floor windows))"
label variable comfort___2 "Comfort (choice=Illumination (Degree of illumination of pedestrian facilities along streets))"
label variable comfort___3 "Comfort (choice=Pavement quality (Conditions of pedestrian pavements))"
label variable comfort___4 "Comfort (choice=Slope (Longitudinal slope))"
label variable comfort___5 "Comfort (choice=Available lavatories)"
label variable comfort___6 "Comfort (choice=Available fountains)"
label variable comfort___7 "Comfort (choice=Vegetation (Tree coverage))"
label variable comfort___8 "Comfort (choice=Urban water features (available water bodies in public space design))"
label variable comfort___9 "Comfort (choice=Quality of acoustic environment)"
label variable comfort___10 "Comfort (choice=Variety of micro-climatic conditions)"
label variable conviviality___1 "Conviviality (choice=Presence of meeting places)"
label variable conviviality___2 "Conviviality (choice=Visibility of anchors places (shopping malls, public facilities))"
label variable conviviality___3 "Conviviality (choice=Presence of activities with extended service hours (restaurants, bars, cinemas))"
label variable conviviality___4 "Conviviality (choice=Integration of buildings and open space)"
label variable conviviality___5 "Conviviality (choice=Areas with space identified for play)"
label variable conviviality___6 "Conviviality (choice=Availability of infrastructure for play (furniture, equipment etc.))"
label variable conviviality___7 "Conviviality (choice=Presence of informal seats)"
label variable conviviality___8 "Conviviality (choice=Presence of resting/sitting features)"
label variable conspicuousness___1 "Conspicuousness (choice=Mention of some feature of enclosure)"
label variable conspicuousness___2 "Conspicuousness (choice=Complexity of urban design)"
label variable conspicuousness___3 "Conspicuousness (choice=Mention of human scale)"
label variable conspicuousness___4 "Conspicuousness (choice=Mention of imaginability of built design)"
label variable coexistence___1 "Coexistence (choice=Traffic safety features present (pedestrian crossing, signage etc))"
label variable coexistence___2 "Coexistence (choice=Traffic speed limits and numbers of lanes)"
label variable coexistence___3 "Coexistence (choice=Design prioritising pedestrians)"
label variable commitment___1 "Commitment (choice=Availability of garbage containers)"
label variable commitment___2 "Commitment (choice=Maintenance of pedestrian surfaces/facilities)"
label variable commitment___3 "Commitment (choice=Management of vegetation (trees))"
label variable commitment___4 "Commitment (choice=Planned public space design intervention (implementing design standards))"
label variable outcome_name "Primary Outcome name"
label variable outcome_definition "Primary Outcome definition"
label variable unit_measurre "Unit of measurement"
label variable secondary_outcome "Secondary outcome"
label variable secondary_definnition "Secondary outcome definition"
label variable confounders "Confounders mentioned in study"
label variable conclude "Key conclusions"
label variable extraction_informati_v_1 "Complete?"

order record_id redcap_data_access_group data_extractor author publication_year manuscript_title journal status exclusion_reason other_reason_exclusion publication_informat_v_0 study_design___1 study_design___2 study_design___3 study_design___4 study_design___5 study_design___6 study_design___7 study_design___8 study_design___9 study_design___10 study_design___11 other_study_design study_setting___1 study_setting___2 sids_setting___1 sids_setting___2 sids_setting___3 la_setting___1 la_setting___2 la_setting___3 la_setting___4 north_central_setting___1 north_central_setting___2 north_central_setting___3 north_central_setting___4 north_central_setting___5 north_central_setting___6 north_central_setting___7 north_central_setting___8 north_central_setting___9 north_central_setting___10 south_america_setting___1 south_america_setting___2 south_america_setting___3 south_america_setting___4 south_america_setting___5 south_america_setting___6 south_america_setting___7 south_america_setting___8 south_america_setting___9 south_america_setting___10 south_america_setting___11 south_america_setting___12 south_america_setting___13 south_america_setting___14 south_america_setting___15 caribbean_countries___1 caribbean_countries___2 caribbean_countries___3 caribbean_countries___4 caribbean_countries___5 caribbean_countries___6 caribbean_countries___7 caribbean_countries___8 caribbean_countries___9 caribbean_countries___10 caribbean_countries___11 caribbean_countries___12 caribbean_countries___13 caribbean_countries___14 caribbean_countries___15 caribbean_countries___16 caribbean_countries___17 caribbean_countries___18 caribbean_countries___19 caribbean_countries___20 caribbean_countries___21 caribbean_countries___22 caribbean_countries___23 caribbean_countries___24 caribbean_countries___25 caribbean_countries___26 caribbean_countries___27 caribbean_countries___28 caribbean_countries___29 caribbean_countries___30 caribbean_countries___31 pacific_countries___1 pacific_countries___2 pacific_countries___3 pacific_countries___4 pacific_countries___5 pacific_countries___6 pacific_countries___7 pacific_countries___8 pacific_countries___9 pacific_countries___10 pacific_countries___11 pacific_countries___12 pacific_countries___13 pacific_countries___14 pacific_countries___15 pacific_countries___16 pacific_countries___17 pacific_countries___18 pacific_countries___19 pacific_countries___20 pacific_countries___21 aims_countries___1 aims_countries___2 aims_countries___3 aims_countries___4 aims_countries___5 aims_countries___6 aims_countries___7 aims_countries___8 aims_countries___9 aims_countries___10 aims_countries___11 non_sid_country non_sids_countries_list project_name study_aim study_period population_type gender sample_size age_range ses_setting___1 ses_setting___2 ses_setting___3 ses_setting___4 be_gis___1 be_gis___2 be_gis___3 be_gis___4 main_findings be_attributes___1 be_attributes___2 be_attributes___3 be_attributes___4 be_attributes___5 be_attributes___6 be_attributes___7 be_attributes___8 be_attributes___9 be_attributes___10 be_attributes___11 be_attributes___12 be_attributes___13 other_be_attributes surveillance_be experience_be parking_example_parking_lo traffic_safety community_nd greenspace_nd density_nd connectivity_nd lands_nd neigh_self_selection self_selection_attribute___1 self_selection_attribute___2 self_selection_attribute___3 self_selection_attribute___4 self_selection_attribute___5 self_selection_attribute___6 self_selection_attribute___7 pa_measure_type activity_type___1 activity_type___2 activity_type___3 activity_type___4 activity_type___5 activity_type___6 activity_type___7 other_activity_type connectivity___1 connectivity___2 connectivity___3 connectivity___4 convenience___1 convenience___2 convenience___3 convenience___4 comfort___1 comfort___2 comfort___3 comfort___4 comfort___5 comfort___6 comfort___7 comfort___8 comfort___9 comfort___10 conviviality___1 conviviality___2 conviviality___3 conviviality___4 conviviality___5 conviviality___6 conviviality___7 conviviality___8 conspicuousness___1 conspicuousness___2 conspicuousness___3 conspicuousness___4 coexistence___1 coexistence___2 coexistence___3 commitment___1 commitment___2 commitment___3 commitment___4 outcome_name outcome_definition unit_measurre secondary_outcome secondary_definnition confounders conclude extraction_informati_v_1 
set more off
describe


*Save dataset
save "`datapath'/version01/2-working/Scoping Review/Full_text_BE_PA.dta", replace

*Close log file
log close	

