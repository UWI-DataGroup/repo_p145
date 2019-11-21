clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_002

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_003.do
**  Project:      	Macroscale Walkability- PhD
**  Analyst:		Kern Rocke
**	Date Created:	24/10/2019
**	Date Modified: 	21/11/2019
**  Algorithm Task: Creating SES variables for PCA analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 80

*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*/
*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

/*
This algorithm will attempt to utilize all possible combinations of SES variables derived from the SES Census 2010 data.

Possible SES variables needed for the computation of the SES index

Unemployed
<Seondary education
Management occupations (Male/Female)
<$49999 Yearly income (Male/Female)
Female headed households 
Non blacks

*/



*Load in dataset
use "`datapath'/version01/2-working/BSS_SES/BSS_SES_001", clear

*********************************************************************
*Convert Ethnicity variables to percentages

foreach x in black white oriental east_indian middle_eastern ///
            mixed other total {
gen per_m_race_`x' = (m_race_`x' / total_pop)*100
gen per_f_race_`x' = (f_race_`x' / total_pop)*100
gen per_t_race_`x' = (t_race_`x' / total_pop)*100

label var per_m_race_`x' "Male Percentage Race `x'"
label var per_f_race_`x' "Female Percentage Race `x'"
label var per_t_race_`x' "Total Percentage Race `x'"
            }

*********************************************************************
*Convert Age variables to percentages

foreach x in 0_9 10_19 20_29 30_39 40_49 50_59 60_69 70_79 80_89 ///
             90_99 100_over total  {
gen per_m_age_`x' = (m_age_`x' / total_pop)*100
gen per_f_age_`x' = (f_age_`x' / total_pop)*100
gen per_t_age_`x' = (t_age_`x' / total_pop)*100

label var per_m_age_`x' "Percentage Male Percentage Age `x'"
label var per_f_age_`x' "Percentage Female Percentage Age `x'"
label var per_t_age_`x' "Percentage Total Percentage Age `x'"
             }

*********************************************************************
*Convert Household Size variables to percentages

foreach x in 1Person 2Person 3Person 4Person 5Person 6Person ///
             7Person  8Person 9Person 10Person 11Person 12Person ///
             13Person total  {

gen per_hsize_`x' = (hsize_`x' / total_pop)*100

label var per_hsize_`x' "Percentage Household Size `x's"
             }
             
*********************************************************************
*Convert House Tenure variables to percentages

foreach x in owned private_rent gov_rent rent_free other total  {

gen per_htenure_`x' = (htenure_`x' / total_pop)*100

label var per_htenure_`x' "Percentage House Tenure `x'"
            }
                        
*********************************************************************
/*  Converting Single Mother Househilds and total live births variables 
    to percentages  */

foreach x in 0 1 2 3 4 5 6 7 8 9 10 total  {

gen per_smother_`x' = (smother_`x' / total_pop)*100

label var per_smother_`x' "Percentage Single Mother `x' liveborn"
            }
                                    
*********************************************************************
/*  Converting Househilds and Relationship to Head of household variables
    to percentages */

foreach x in head spouse child_head child_inlaw grandchild parent ///
            other_relative vistor non_relative total  {

gen per_rth_`x' = (rth_`x' / total_pop)*100

label var per_rth_`x' "Percentage RTH `x'"
            }
                                     
*********************************************************************
*Convert Education variables to percentages

foreach x in preprimary primary composite secondary post_secondary ///
            tertiary other none total  {
gen per_m_education_`x' = (m_education_`x' / total_pop)*100
gen per_f_education_`x' = (f_education_`x' / total_pop)*100
gen per_t_education_`x' = (t_education_`x' / total_pop)*100

label var per_m_education_`x' "Male Percentage Education `x'"
label var per_f_education_`x' "Female Percentage Education `x'"
label var per_t_education_`x' "Total Percentage Education `x'"
            }
                                                 
*********************************************************************
*Convert Yearly Pay (Income) variables to percentages

foreach x in 0_49 50_99 100_149 150_199 200_over total  {

gen per_m_income_`x' = (m_income_`x' / total_pop)*100
gen per_f_income_`x' = (f_income_`x' / total_pop)*100
gen per_t_income_`x' = (t_income_`x' / total_pop)*100

label var per_m_income_`x' "Male Percentage Income $`x' ($xxx,000)"
label var per_f_income_`x' "Female Percentage Income $`x' ($xxx,000)"
label var per_t_income_`x' "Total Percentage Income $`x' ($xxx,000)"
            }
                                                 
*********************************************************************
*Convert Main Activity variables to percentages

foreach x in worked j_notworking look_work home student retired  ///
            incapacitated other total  {

gen per_m_mactivity_`x' = (m_mactivity_`x' / total_pop)*100
gen per_f_mactivity_`x' = (f_mactivity_`x' / total_pop)*100
gen per_t_mactivity_`x' = (t_mactivity_`x' / total_pop)*100

label var per_m_mactivity_`x' "Male Percentage Main Activity `x'"
label var per_f_mactivity_`x' "Female Percentage Main Activity `x'"
label var per_t_mactivity_`x' "Total Percentage Main Activity `x'"
            }
                                                 
*********************************************************************
*Convert Work Activity variables to percentages

foreach x in government private_enter private_house other   ///
            unpaid_work paid_help unpaid_help no_work other_2 ///
             total  {
                
gen per_m_wactivity_`x' = (m_wactivity_`x' / total_pop)*100
gen per_f_wactivity_`x' = (f_wactivity_`x' / total_pop)*100
gen per_t_wactivity_`x' = (t_wactivity_`x' / total_pop)*100

label var per_m_wactivity_`x' "Male Percentage Work Activity `x'"
label var per_f_wactivity_`x' "Female Percentage Work Activity `x'"
label var per_t_wactivity_`x' "Total Percentage Work Activity `x'"
            }
                                                 
*********************************************************************
/*  Converting Women 15-64 years and Total Liveborn children variables 
    to percentages  */

foreach x in 0 1 2 3 4 5 6 7 8 9 10 total  {

gen per_live_`x' = (live_`x' / total_pop)*100

label var per_live_`x' "Percentage Women 15-64 `x' liveborn children"
            }
                                    
*********************************************************************
/*  Crime variables to percentages  */

foreach x in victim murder kidnapping shooting rape other ///
            robbery wound larceny {

gen per_crime_`x' = (crime_`x' / total_pop)*100

label var per_crime_`x' "Percentage `x' Crime"
            }
                                    
*********************************************************************
*Convert Occupation variables to percentages

foreach x in a_forces exec admin_mange prod_mange hosp_mange   ///
            sci_prof health_prof teach_prof busi_prof info_prof ///
            legal_prof sci_a_prof health_a_prof busi_a_prof ///
            legal_a_prof info_tech gen_clerk cust_clerk num_clerk ///
            other_clerk per_work sale_work care_work prot_work ///
            mar_agri mar_fores s_farm build_work metal_work ///
            handicraft elec_work food_process plant_assemble ///
            drive_oper clean agri_labour mining_labour food_prep ///
            street_ser refuse_work total  {
                
gen per_m_occupation_`x' = (m_occupation_`x' / total_pop)*100
gen per_f_occupation_`x' = (f_occupation_`x' / total_pop)*100
gen per_t_occupation_`x' = (t_occupation_`x' / total_pop)*100

label var per_m_occupation_`x' "Male Percentage `x' Occupation"
label var per_f_occupation_`x' "Female Percentage `x' Occupation"
label var per_t_occupation_`x' "Total Percentage `x' Occupation"
             } 
                                                 
*********************************************************************
*Convert Martial Status variables to percentages

foreach x in married separated divorced widowed n_married {

gen per_marital_`x' = (marital_`x' / total_pop)*100
label var per_marital_`x' "Percentage Marital `x'"
}

*********************************************************************
*Convert Religion variables to percentages

foreach x in adventist anglican bahal baptist bretheren church_lord ///
			hindu jewish jevovah_wit methodist moravian mormon muslim ///
			pentecostal rasta catholic salvation other_chris none no{

gen per_religion_`x' = (religion_`x' / total_pop)*100
label var per_religion_`x' "Percentage Religion `x'"
}
                                                 
*********************************************************************
*Convert Number of rooms variables to percentages

foreach x in 1 2 3 4 5 6 7 8 9_more {

gen per_rooms_`x' = (rooms_`x' / total_pop)*100
label var per_rooms_`x' "Percentage Number of Rooms `x'"
}
                                                 
*********************************************************************
*Convert Number of bedrooms variables to percentages

foreach x in 0 1 2 3 4 5_more {

gen per_bedrooms_`x' = (bedrooms_`x' / total_pop)*100
label var per_bedrooms_`x' "Percentage Number of Bedrooms `x'"
}
                                                 
*********************************************************************
*Convert Number of bathrooms variables to percentages

foreach x in 0 1 2 3 shared {

gen per_bathroom_`x' = (bathroom_`x' / total_pop)*100
label var per_bathroom_`x' "Percentage Number of Bathrooms `x'"
}

*********************************************************************
*Convert Sewage variables to percentages

foreach x in wc_sewer wc_no_sewer other_toilet pit no_toilet ///
			shared_toilet {

gen per_sewage_`x' = (sewage_`x' / total_pop)*100
label var per_sewage_`x' "Percentage Sewage `x'"
}

*********************************************************************
*Convert Number of vehicles variables to percentages

foreach x in 0 1 2 3 4_more {

gen per_vehicles_`x' = (vehicles_`x' / total_pop)*100
label var per_vehicles_`x' "Percentage Number of Vehicles `x'"
}
                                                 
*********************************************************************
*Convert Electricity and Emigrants variables to percentages

foreach x in electricity emigrants {

gen per_`x' = (`x' / total_pop)*100
label var per_`x' "Percentage Persons with `x'"
}
                                                 
*********************************************************************
*Convert Amentities variables to percentages

foreach x in stove fridge freezer water_tank microwave toaster wash ///
			dish_wash dryer fixed_line tv radio cabel_tv stero_system ///
			computer {

gen per_amentities_`x' = (amentities_`x' / total_pop)*100
label var per_amentities_`x' "Percentage Persons Amentities (`x')"
}
                                                 
*********************************************************************

/*Creating variable and percentages for residents with education less than 
secondary education
*/

egen education_less_secondary = rowtotal(t_education_preprimary ///
								t_education_primary t_education_composite)
label var education_less_secondary "Less than Secondary Education"

gen per_education_less_secondary = (education_less_secondary / total_pop) *100
label var per_education_less_secondary "Percentage Less than Secondary Education"

*********************************************************************

/*Creating variable and percentages for vehicle ownership
*/

egen vehicle_presence = rowtotal(vehicles_1 vehicles_2 vehicles_3 ///
						vehicles_4_more)
label var vehicle_presence "Vehicular Ownership"

gen per_vehicle_presence = (vehicle_presence/total_pop)*100
label var per_vehicle_presence "Percentage Vehiclular Ownership"

*********************************************************************

/*Creating variable and percentages for less than 3 rooms at home
*/

egen rooms_less_3 = rowtotal(rooms_1 rooms_2)
label var rooms_less_3 "Less than 3 rooms"

gen per_rooms_less_3 = (rooms_less_3/total_pop)*100
label var per_rooms_less_3 "Percentage Less than 3 rooms"

*********************************************************************

/*Creating variable and percentages for less than 3 rooms at home
*/

egen bedrooms_less_2 = rowtotal(bedrooms_0 bedrooms_1)
label var bedrooms_less_2 "Less than 2 berooms"

gen per_bedrooms_less_2 = (bedrooms_less_2/total_pop)*100
label var per_bedrooms_less_2 "Percentage Less than 2 bedrooms"

*********************************************************************

/*Creating variable and percentages for professional occupations
*/

egen prof_occupation = rowtotal(t_occupation_exec t_occupation_exec ///
						t_occupation_admin_mange t_occupation_prod_mange ///
						t_occupation_hosp_mange t_occupation_sci_prof ///
						t_occupation_health_prof t_occupation_teach_prof ///
						t_occupation_busi_prof t_occupation_info_prof ///
						t_occupation_legal_prof t_occupation_sci_a_prof ///
						t_occupation_health_a_prof t_occupation_busi_a_prof ///
						t_occupation_legal_a_prof)
label var prof_occupation "Professional Occupation"

gen per_prof_occupation = (prof_occupation/total_pop)*100
label var per_prof_occupation "Percentage Professional Occupation"

**********************************************************************
/*Creating variable and percentages for age dependancy (<20 years & >60 years)
*/

egen age_depend = rowtotal(t_age_0_9 t_age_10_19 t_age_60_69 t_age_70_79    ///
                            t_age_80_89 t_age_90_99 t_age_100_over)
label var age_depend "Age Dependancy (<20 years & >60 years)"

gen per_age_depend = (age_depend/total_pop)*100
label var per_age_depend "Percentage Age Dependancy (<20 years & >60 years)"

*********************************************************************
/*Creating variable and percentages for young age dependancy (<20 years)
*/

egen young_age_depend = rowtotal(t_age_0_9 t_age_10_19)
label var young_age_depend "Yonger Age Dependancy (<20 years)"

gen per_young_age_depend = (young_age_depend/total_pop)*100
label var per_young_age_depend "Percentage Younger Age Dependancy (<20 years & >60 years)"

*********************************************************************

/*Creating variable and percentages for older age dependancy (>60 years)
*/

egen old_age_depend = rowtotal(t_age_60_69 t_age_70_79    ///
                            t_age_80_89 t_age_90_99 t_age_100_over)
label var old_age_depend "Older Age Dependancy (>60 years)"

gen per_old_age_depend = (old_age_depend/total_pop)*100
label var per_old_age_depend "Percentage Older Age Dependancy (>60 years)"

*********************************************************************
/*Creating variable and percentages for high income (>$150000)
*/

egen high_income = rowtotal(t_income_150_199 t_income_200_over)
label var high_income "High income >$150000"

gen per_high_income = (high_income/total_pop)*100
label var per_high_income "Percentage High income >$150000"

*********************************************************************
*Calculate population density by ED

/*

Parish          =  Code =   Population Size

Christ Church   =   1   =   43127
St. Andrew      =   2   =   4631
St. George      =   3   =   18203
St. James       =   4   =   21258
St. John        =   5   =   8617
St. Joseph      =   6   =   5939
St. Lucy        =   7   =   8609
St. Michael     =   8   =   69604
St. Peter       =   9   =   10382
St. Phillip     =   10  =   23788
St. Thomas      =   11  =   12035
*/

gen pop_density = total_pop/area
label var pop_density "Population Density per square mile"

*********************************************************************
* Create variable for Renting (Government and Private Renting)

egen renting = rowtotal(htenure_private htenure_gov_rent)
label var renting "Renting (Governemnt and Private)"

gen per_renting = (renting/total_pop)*100
label var per_renting "Percentage Renting (Government and Private)"

*********************************************************************
* Create variable for Main Activity No Job (Unemployed)

egen unemployment = rowtotal(t_mactivity_retired t_mactivity_student ///
                    t_mactivity_home t_mactivity_look_work)
label var unemployment "Unemployment"

gen per_unemployment = (unemployment/total_pop)*100
label var per_unemployment "Percentage Unemployment"

*********************************************************************
*Create variable for Private Working Activity (Private Enterprise/ Household)

egen private_wactivity = rowtotal(t_wactivity_private_enter t_wactivity_private_house)
label var private_wactivity "Private Work Activity"

gen per_private_wactivity = (private_wactivity/total_pop)*100
label var per_private_wactivity "Percentage Private Work Activity"

*********************************************************************
*Create variable for women 15-64 years with >5 liveborn children

egen live_5_more = rowtotal(live_6 live_7 live_7 live_8 live_9 ///
                        live_10)
label var live_5_more "Women with >5 Liveborn children"

gen per_live_5_more = (live_5_more/total_pop)*100
label var per_live_5_more "Percentage Women with >5 Liveborn children"

*********************************************************************
/*Creating variable and percentages for Non-Technical/Professional occupations
*/

egen prof_n_techoccupation = rowtotal(t_occupation_gen_clerk t_occupation_cust_clerk ///
                                t_occupation_num_clerk t_occupation_other_clerk ///
                                t_occupation_per_work t_occupation_sale_work ///
                                t_occupation_care_work t_occupation_prot_work ///
                                t_occupation_clean t_occupation_food_prep ///
                                t_occupation_street_ser)
label var prof_n_techoccupation "Non Technical/Professional Occupation"

gen per_prof_n_techoccupation = (prof_n_techoccupation/total_pop)*100
label var per_prof_n_techoccupation "Percentage Non Technical/Professional Occupation"

**********************************************************************
/*Creating variable and percentages for Technical occupations
*/

egen prof_techoccupation = rowtotal(t_occupation_info_tech t_occupation_mar_agri ///
                            t_occupation_mar_fores t_occupation_s_farm ///
                            t_occupation_build_work t_occupation_metal_work ///
                            t_occupation_handicraft t_occupation_elec_work ///
                            t_occupation_food_process t_occupation_plant_assemble ///
                            t_occupation_drive_oper)
label var prof_techoccupation "Technical Occupation"

gen per_prof_techoccupation = (prof_techoccupation/total_pop)*100
label var per_prof_techoccupation "Percentage Technical Occupation"

**********************************************************************

label data "SES Indicators by Ennumeration Districts - Barbabdos Statistical Service (p2)"

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/BSS_SES_002", replace
