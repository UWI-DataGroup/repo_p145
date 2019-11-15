clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_001.do
**  Project:      	Macroscale Walkability- PhD
**  Analyst:		Kern Rocke
**	Date Created:	17/10/2019
**	Date Modified: 	05/11/2019
**  Algorithm Task: Data Preparation and Cleaning of BSS SES data by EDs 2010


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

*Setting working directory
** Dataset to encrypted location
/*
WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*/
*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

/*
Note

SES data provided by BSS include the following

1) 	Ethnicity
2) 	Age
3) 	Household size
4) 	House Tenure
5) 	Single Mothers
6) 	Relationship to head of household
7) 	Education
8) 	Yearly pay
9) 	Main activity
10)	Work activity
11)	Liveborn children
12)	Crime
13)	Occupation

*/

*Load in excel data (Ethnicity Origin)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Ethnic Origin") allstring clear

//////	Ethnicity Origin	//////////

*Male Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Male" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B m_race_total
rename C m_race_black
rename D m_race_white
rename E m_race_oriental
rename F m_race_east_indian
rename G m_race_middle_eastern
rename H m_race_mixed
rename I m_race_other
rename J m_race_not_stated

label var ED "Enumeration District Number"
label var m_race_total "Male Ethnicity Total"
label var m_race_black "Male Black"
label var m_race_white "Male White"
label var m_race_oriental "Male Oriental"
label var m_race_east_indian "Male East Indian"
label var m_race_middle_eastern "Male Middle Eastern"
label var m_race_mixed "Male Mixed"
label var m_race_other "Male Ethnicity Other"
label var m_race_not_stated "Male Ethnicity not stated"

save "`datapath'/version01/1-input/BSS_SES/male_race_SES", replace

restore

********************************************************************************

*Female Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Female" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B f_race_total
rename C f_race_black
rename D f_race_white
rename E f_race_oriental
rename F f_race_east_indian
rename G f_race_middle_eastern
rename H f_race_mixed
rename I f_race_other
rename J f_race_not_stated

label var ED "Enumeration District Number"
label var f_race_total "Female Ethnicity Total"
label var f_race_black "Female Black"
label var f_race_white "Female White"
label var f_race_oriental "Female Oriental"
label var f_race_east_indian "Female East Indian"
label var f_race_middle_eastern "Female Middle Eastern"
label var f_race_mixed "Female Mixed"
label var f_race_other "Female Ethnicity Other"
label var f_race_not_stated "Female Ethnicity not stated"

save "`datapath'/version01/1-input/BSS_SES/female_race_SES", replace

restore
********************************************************************************

*Total Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Total" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B t_race_total
rename C t_race_black
rename D t_race_white
rename E t_race_oriental
rename F t_race_east_indian
rename G t_race_middle_eastern
rename H t_race_mixed
rename I t_race_other
rename J t_race_not_stated

label var ED "Enumeration District Number"
label var t_race_total "Total Ethnicity Total"
label var t_race_black "Total Black"
label var t_race_white "Total White"
label var t_race_oriental "Total Oriental"
label var t_race_east_indian "Total East Indian"
label var t_race_middle_eastern "Total Middle Eastern"
label var t_race_mixed "Total Mixed"
label var t_race_other "Total Ethnicity Other"
label var t_race_not_stated "Total Ethnicity not stated"

save "`datapath'/version01/1-input/BSS_SES/total_race_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Age)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Age") allstring clear

/////	Age	//////

*Male
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Male" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B m_age_total
rename C m_age_median
rename D m_age_0_9
rename E m_age_10_19
rename F m_age_20_29
rename G m_age_30_39
rename H m_age_40_49
rename I m_age_50_59
rename J m_age_60_69
rename K m_age_70_79
rename L m_age_80_89
rename M m_age_90_99
rename N m_age_100_over

label var ED "Enumeration District Number"
label var m_age_total "Male age Total"
label var m_age_median "Male Median age"
label var m_age_0_9 "Male 0-9 years"
label var m_age_10_19 "Male 10-19 years"
label var m_age_20_29 "Male 20-29 years"
label var m_age_30_39 "Male 30-39 years"
label var m_age_40_49 "Male 40-49 years"
label var m_age_50_59 "Male 50-59 years"
label var m_age_60_69 "Male 60-69 years"
label var m_age_70_79 "Male 70-79 years"
label var m_age_80_89 "Male 80-89 years"
label var m_age_90_99 "Male 90-99 years"
label var m_age_100_over "Male 100 years and over"

save "`datapath'/version01/1-input/BSS_SES/male_age_SES", replace

restore
********************************************************************************

*Female
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Female" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B f_age_total
rename C f_age_median
rename D f_age_0_9
rename E f_age_10_19
rename F f_age_20_29
rename G f_age_30_39
rename H f_age_40_49
rename I f_age_50_59
rename J f_age_60_69
rename K f_age_70_79
rename L f_age_80_89
rename M f_age_90_99
rename N f_age_100_over

label var ED "Enumeration District Number"
label var f_age_total "Female age Total"
label var f_age_median "Female Median age"
label var f_age_0_9 "Female 0-9 years"
label var f_age_10_19 "Female 10-19 years"
label var f_age_20_29 "Female 20-29 years"
label var f_age_30_39 "Female 30-39 years"
label var f_age_40_49 "Female 40-49 years"
label var f_age_50_59 "Female 50-59 years"
label var f_age_60_69 "Female 60-69 years"
label var f_age_70_79 "Female 70-79 years"
label var f_age_80_89 "Female 80-89 years"
label var f_age_90_99 "Female 90-99 years"
label var f_age_100_over "Female 100 years and over"

save "`datapath'/version01/1-input/BSS_SES/female_age_SES", replace

restore
********************************************************************************

*Total
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Total" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B t_age_total
rename C t_age_median
rename D t_age_0_9
rename E t_age_10_19
rename F t_age_20_29
rename G t_age_30_39
rename H t_age_40_49
rename I t_age_50_59
rename J t_age_60_69
rename K t_age_70_79
rename L t_age_80_89
rename M t_age_90_99
rename N t_age_100_over

label var ED "Enumeration District Number"
label var t_age_total "Total age Total"
label var t_age_median "Total Median age"
label var t_age_0_9 "Total 0-9 years"
label var t_age_10_19 "Total 10-19 years"
label var t_age_20_29 "Total 20-29 years"
label var t_age_30_39 "Total 30-39 years"
label var t_age_40_49 "Total 40-49 years"
label var t_age_50_59 "Total 50-59 years"
label var t_age_60_69 "Total 60-69 years"
label var t_age_70_79 "Total 70-79 years"
label var t_age_80_89 "Total 80-89 years"
label var t_age_90_99 "Total 90-99 years"
label var t_age_100_over "Total 100 years and over"

save "`datapath'/version01/1-input/BSS_SES/total_age_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Household Size)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Household Size") allstring clear

/////	Household Size	//////

preserve

*Data cleaning tasks
drop in 1/4
destring, replace

*Renaming and labelling variabels
rename A ED
rename B hsize_total
rename C hsize_mean
rename D hsize_1Person
rename E hsize_2Person
rename F hsize_3Person
rename G hsize_4Person
rename H hsize_5Person
rename I hsize_6Person
rename J hsize_7Person
rename K hsize_8Person
rename L hsize_9Person
rename M hsize_10Person
rename N hsize_11Person
rename O hsize_12Person
rename P hsize_13Person

label var ED "Enumeration District Number"
label var hsize_total "Household size Total"
label var hsize_mean "Household size Mean"
label var hsize_1Person "Household size 1 person"
label var hsize_2Person "Household size 2 persons"
label var hsize_3Person "Household size 3 persons"
label var hsize_4Person "Household size 4 persons"
label var hsize_5Person "Household size 5 persons"
label var hsize_6Person "Household size 6 persons"
label var hsize_7Person "Household size 7 persons"
label var hsize_8Person "Household size 8 persons"
label var hsize_9Person "Household size 9 persons"
label var hsize_10Person "Household size 10 persons"
label var hsize_11Person "Household size 11 persons"
label var hsize_12Person "Household size 12 persons"
label var hsize_13Person "Household size 13 persons or more"

save "`datapath'/version01/1-input/BSS_SES/household_size_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (House Tenure)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("House Tenure") allstring clear

/////	House Tenure	//////

preserve

*Data cleaning tasks
drop in 1/4
destring, replace

*Renaming and labelling variabels
rename A ED
rename B htenure_total
rename C htenure_owned
rename D htenure_private_rent
rename E htenure_gov_rent
rename F htenure_rent_free
rename G htenure_other
rename H htenure_no_state

label var ED "Enumeration District Number"
label var htenure_total "House Tenure Total"
label var htenure_owned "House Tenure Owned"
label var htenure_private_rent "House Tenure Private Rented or Leased"
label var htenure_gov_rent "House Tenure Government Rented or Leased"
label var htenure_rent_free "House Tenure Rent Free"
label var htenure_other "House Tenure Other"
label var htenure_no_state "House Tenure Not Stated"


save "`datapath'/version01/1-input/BSS_SES/house_tenure_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Single Mothers)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Single Mothers") allstring clear

/////	Single Mother households and total live births	//////

preserve

*Data cleaning tasks
drop in 1/4
destring, replace

*Renaming and labelling variabels
rename A ED
rename B smother_total
rename C smother_0
rename D smother_1
rename E smother_2
rename F smother_3
rename G smother_4
rename H smother_5
rename I smother_6
rename J smother_7
rename K smother_8
rename L smother_9
rename M smother_10
rename N smother_not_state

label var ED "Enumeration District Number"
label var smother_total "House Tenure Total"
label var smother_0 "0 liveborn"
label var smother_1 "1 liveborn"
label var smother_2 "2 liveborn"
label var smother_3 "3 liveborn"
label var smother_4 "4 liveborn"
label var smother_5 "5 liveborn"
label var smother_6 "6 liveborn"
label var smother_7 "7 liveborn"
label var smother_8 "8 liveborn"
label var smother_9 "9 liveborn"
label var smother_10 "10+ liveborn"
label var smother_not_state "liveborn- Not Stated"

save "`datapath'/version01/1-input/BSS_SES/single_mother_liveborn_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Households and Relationship to Head of household)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Relationship to head") allstring clear

/////	Households and Relationship to Head of household	//////

preserve

*Data cleaning tasks
drop in 1/4
destring, replace

*Renaming and labelling variabels
rename A ED
rename B rth_total
rename C rth_head
rename D rth_spouse
rename E rth_child_head
rename F rth_child_inlaw
rename G rth_grandchild
rename H rth_parent
rename I rth_other_relative
rename J rth_vistor
rename K rth_non_relative
rename L rth_not_stated


label var ED "Enumeration District Number"
label var rth_total "RTH Total"
label var rth_head "Head"
label var rth_spouse "Spouse/Partner"
label var rth_child_head "Child of Head/Spouse"
label var rth_child_inlaw "Son/Daughter in law"
label var rth_grandchild "Grandchild"
label var rth_parent "Parent/Parent in law"
label var rth_other_relative "Other Relative"
label var rth_vistor "Visitor"
label var rth_non_relative "Other non-relative"
label var rth_not_stated "Relationship to head- Not stated"

save "`datapath'/version01/1-input/BSS_SES/relationship_to_head_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Education)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Education") allstring clear

//////	Education	//////////

*Male Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Male" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B m_education_total
rename C m_education_preprimary
rename D m_education_primary
rename E m_education_composite
rename F m_education_secondary
rename G m_education_post_secondary
rename H m_education_tertiary
rename I m_education_other
rename J m_education_none
rename K m_education_not_stated

label var ED "Enumeration District Number"
label var m_education_total "Male Education Total"
label var m_education_preprimary "Male Preprimary"
label var m_education_primary "Male Primary"
label var m_education_composite "Male Senior/Composite"
label var m_education_secondary "Male Secondary"
label var m_education_post_secondary "Male Post Secondary"
label var m_education_tertiary "Male Tertiary"
label var m_education_other "Male Education- Other"
label var m_education_none "Male Education None"
label var m_education_not_stated "Male Education not stated"

save "`datapath'/version01/1-input/BSS_SES/male_education_SES", replace

restore

********************************************************************************

*Female Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Female" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B f_education_total
rename C f_education_preprimary
rename D f_education_primary
rename E f_education_composite
rename F f_education_secondary
rename G f_education_post_secondary
rename H f_education_tertiary
rename I f_education_other
rename J f_education_none
rename K f_education_not_stated

label var ED "Enumeration District Number"
label var f_education_total "Female Education Total"
label var f_education_preprimary "Female Preprimary"
label var f_education_primary "Female Primary"
label var f_education_composite "Female Senior/Composite"
label var f_education_secondary "Female Secondary"
label var f_education_post_secondary "Female Post Secondary"
label var f_education_tertiary "Female Tertiary"
label var f_education_other "Female Education- Other"
label var f_education_none "Female Education None"
label var f_education_not_stated "Female Education not stated"

save "`datapath'/version01/1-input/BSS_SES/female_education_SES", replace

restore
********************************************************************************

*Total Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Total" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B t_education_total
rename C t_education_preprimary
rename D t_education_primary
rename E t_education_composite
rename F t_education_secondary
rename G t_education_post_secondary
rename H t_education_tertiary
rename I t_education_other
rename J t_education_none
rename K t_education_not_stated

label var ED "Enumeration District Number"
label var t_education_total "Total Education Total"
label var t_education_preprimary "Total Preprimary"
label var t_education_primary "Total Primary"
label var t_education_composite "Total Senior/Composite"
label var t_education_secondary "Total Secondary"
label var t_education_post_secondary "Total Post Secondary"
label var t_education_tertiary "Total Tertiary"
label var t_education_other "Total Education- Other"
label var t_education_none "Total Education None"
label var t_education_not_stated "Total Education not stated"

save "`datapath'/version01/1-input/BSS_SES/total_education_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Yearly Pay)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Yearly Pay") allstring clear

//////	Yearly Pay	//////////

*Male Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Male" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B m_income_total
rename C m_income_median
rename D m_income_0_49
rename E m_income_50_99
rename F m_income_100_149
rename G m_income_150_199
rename H m_income_200_over
rename I m_income_other
rename J m_income_not_stated

label var ED "Enumeration District Number"
label var m_income_total "Male Income Total"
label var m_income_median "Male Median Income"
label var m_income_0_49 "Male $0 - 49999"
label var m_income_50_99 "Male $50000 - 99999"
label var m_income_100_149 "Male $100000 - 149999"
label var m_income_150_199 "Male $150000 - 199999"
label var m_income_200_over "Male $200000 and over"
label var m_income_other "Male Income other"
label var m_income_not_stated "Male Income not stated"

save "`datapath'/version01/1-input/BSS_SES/male_income_SES", replace

restore

********************************************************************************

*Female Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Female" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B f_income_total
rename C f_income_median
rename D f_income_0_49
rename E f_income_50_99
rename F f_income_100_149
rename G f_income_150_199
rename H f_income_200_over
rename I f_income_other
rename J f_income_not_stated

label var ED "Enumeration District Number"
label var f_income_total "Female Income Total"
label var f_income_median "Female Median Income"
label var f_income_0_49 "Female $0 - 49999"
label var f_income_50_99 "Female $50000 - 99999"
label var f_income_100_149 "Female $100000 - 149999"
label var f_income_150_199 "Female $150000 - 199999"
label var f_income_200_over "Female $200000 and over"
label var f_income_other "Female Income other"
label var f_income_not_stated "Female Income not stated"

save "`datapath'/version01/1-input/BSS_SES/female_income_SES", replace

restore

********************************************************************************

*Total Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Total" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B t_income_total
rename C t_income_median
rename D t_income_0_49
rename E t_income_50_99
rename F t_income_100_149
rename G t_income_150_199
rename H t_income_200_over
rename I t_income_other
rename J t_income_not_stated


label var ED "Enumeration District Number"
label var t_income_total "Total Income Total"
label var t_income_median "Total Median Income"
label var t_income_0_49 "Total $0 - 49999"
label var t_income_50_99 "Total $50000 - 99999"
label var t_income_100_149 "Total $100000 - 149999"
label var t_income_150_199 "Total $150000 - 199999"
label var t_income_200_over "Total $200000 and over"
label var t_income_other "Total Income other"
label var t_income_not_stated "Total Income not stated"

save "`datapath'/version01/1-input/BSS_SES/total_income_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Main Activity)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Main Activity") allstring clear

//////	Main Activity	//////////

*Male Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Male" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B m_mactivity_total
rename C m_mactivity_worked
rename D m_mactivity_j_notworking
rename E m_mactivity_look_work
rename F m_mactivity_home
rename G m_mactivity_student
rename H m_mactivity_retired
rename I m_mactivity_incapacitated
rename J m_mactivity_other
rename K m_mactivity_not_stated

label var ED "Enumeration District Number"
label var m_mactivity_total "Male Main Activity Total"
label var m_mactivity_worked "Male Main Activity Worked"
label var m_mactivity_j_notworking "Male Main Activity With Job Not Working"
label var m_mactivity_look_work "Male Main Activity Looked for Work"
label var m_mactivity_home "Male Main Activity Home Duties"
label var m_mactivity_student "Male Main Activity Student"
label var m_mactivity_retired "Male Main Activity Retired"
label var m_mactivity_incapacitated "Male Main Activity Incapacitated"
label var m_mactivity_other "Male Main Activity Other"
label var m_mactivity_not_stated "Male Main Activity Not Stated"

save "`datapath'/version01/1-input/BSS_SES/male_mactivity_SES", replace

restore

********************************************************************************

*Female Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Female" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B f_mactivity_total
rename C f_mactivity_worked
rename D f_mactivity_j_notworking
rename E f_mactivity_look_work
rename F f_mactivity_home
rename G f_mactivity_student
rename H f_mactivity_retired
rename I f_mactivity_incapacitated
rename J f_mactivity_other
rename K f_mactivity_not_stated

label var ED "Enumeration District Number"
label var f_mactivity_total "Female Main Activity Total"
label var f_mactivity_worked "Female Main Activity Worked"
label var f_mactivity_j_notworking "Female Main Activity With Job Not Working"
label var f_mactivity_look_work "Female Main Activity Looked for Work"
label var f_mactivity_home "Female Main Activity Home Duties"
label var f_mactivity_student "Female Main Activity Student"
label var f_mactivity_retired "Female Main Activity Retired"
label var f_mactivity_incapacitated "Female Main Activity Incapacitated"
label var f_mactivity_other "Female Main Activity Other"
label var f_mactivity_not_stated "Female Main Activity Not Stated"

save "`datapath'/version01/1-input/BSS_SES/female_mactivity_SES", replace

restore

********************************************************************************

*Total Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Total" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B t_mactivity_total
rename C t_mactivity_worked
rename D t_mactivity_j_notworking
rename E t_mactivity_look_work
rename F t_mactivity_home
rename G t_mactivity_student
rename H t_mactivity_retired
rename I t_mactivity_incapacitated
rename J t_mactivity_other
rename K t_mactivity_not_stated

label var ED "Enumeration District Number"
label var t_mactivity_total "Total Main Activity Total"
label var t_mactivity_worked "Total Main Activity Worked"
label var t_mactivity_j_notworking "Total Main Activity With Job Not Working"
label var t_mactivity_look_work "Total Main Activity Looked for Work"
label var t_mactivity_home "Total Main Activity Home Duties"
label var t_mactivity_student "Total Main Activity Student"
label var t_mactivity_retired "Total Main Activity Retired"
label var t_mactivity_incapacitated "Total Main Activity Incapacitated"
label var t_mactivity_other "Total Main Activity Other"
label var t_mactivity_not_stated "Total Main Activity Not Stated"

save "`datapath'/version01/1-input/BSS_SES/total_mactivity_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Work Activity)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Work Activity") allstring clear

//////	Work Activity	//////////

*Male Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Male" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B m_wactivity_total
rename C m_wactivity_government
rename D m_wactivity_private_enter
rename E m_wactivity_private_house
rename F m_wactivity_other
rename G m_wactivity_unpaid_work
rename H m_wactivity_paid_help
rename I m_wactivity_unpaid_help
rename J m_wactivity_no_work
rename K m_wactivity_other_2
rename L m_wactivity_not_stated

label var ED "Enumeration District Number"
label var m_wactivity_total "Male Work Activity Total"
label var m_wactivity_government "Male Government Work Activity"
label var m_wactivity_private_enter "Male Private Enterprise Work Activity"
label var m_wactivity_private_house "Male Private household Work Activity"
label var m_wactivity_other "Male Other Work Activity"
label var m_wactivity_unpaid_work "Male Unpaid Worker Work Activity"
label var m_wactivity_paid_help "Male Paid Help Work Activity"
label var m_wactivity_unpaid_help "Male Unpaid Help Work Activity"
label var m_wactivity_no_work "Male Did not Work Work Activity"
label var m_wactivity_other_2 "Male Other 2 Work Activity"
label var m_wactivity_not_stated "Male Not stated Work Activity"

save "`datapath'/version01/1-input/BSS_SES/male_wactivity_SES", replace

restore

********************************************************************************

*Female Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Female" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B f_wactivity_total
rename C f_wactivity_government
rename D f_wactivity_private_enter
rename E f_wactivity_private_house
rename F f_wactivity_other
rename G f_wactivity_unpaid_work
rename H f_wactivity_paid_help
rename I f_wactivity_unpaid_help
rename J f_wactivity_no_work
rename K f_wactivity_other_2
rename L f_wactivity_not_stated

label var ED "Enumeration District Number"
label var f_wactivity_total "Female Work Activity Total"
label var f_wactivity_government "Female Government Work Activity"
label var f_wactivity_private_enter "Female Private Enterprise Work Activity"
label var f_wactivity_private_house "Female Private household Work Activity"
label var f_wactivity_other "Female Other Work Activity"
label var f_wactivity_unpaid_work "Female Unpaid Worker Work Activity"
label var f_wactivity_paid_help "Female Paid Help Work Activity"
label var f_wactivity_unpaid_help "Female Unpaid Help Work Activity"
label var f_wactivity_no_work "Female Did not Work Work Activity"
label var f_wactivity_other_2 "Female Other 2 Work Activity"
label var f_wactivity_not_stated "Female Not stated Work Activity"

save "`datapath'/version01/1-input/BSS_SES/female_wactivity_SES", replace

restore

********************************************************************************

*Total Data
preserve

*Data cleaning tasks
drop in 1/11
keep if A=="Total" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B t_wactivity_total
rename C t_wactivity_government
rename D t_wactivity_private_enter
rename E t_wactivity_private_house
rename F t_wactivity_other
rename G t_wactivity_unpaid_work
rename H t_wactivity_paid_help
rename I t_wactivity_unpaid_help
rename J t_wactivity_no_work
rename K t_wactivity_other_2
rename L t_wactivity_not_stated

label var ED "Enumeration District Number"
label var t_wactivity_total "Total Work Activity Total"
label var t_wactivity_government "Total Government Work Activity"
label var t_wactivity_private_enter "Total Private Enterprise Work Activity"
label var t_wactivity_private_house "Total Private household Work Activity"
label var t_wactivity_other "Total Other Work Activity"
label var t_wactivity_unpaid_work "Total Unpaid Worker Work Activity"
label var t_wactivity_paid_help "Total Paid Help Work Activity"
label var t_wactivity_unpaid_help "Total Unpaid Help Work Activity"
label var t_wactivity_no_work "Total Did not Work Work Activity"
label var t_wactivity_other_2 "Total Other 2 Work Activity"
label var t_wactivity_not_stated "Total Not stated Work Activity"

save "`datapath'/version01/1-input/BSS_SES/total_wactivity_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Liveborn children)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Liveborn children") allstring clear

/////	Women 15-64 years and Total Liveborn Children	//////

preserve

*Data cleaning tasks
drop in 1/4
destring, replace

*Renaming and labelling variabels
rename A ED
rename B live_total
rename C live_0
rename D live_1
rename E live_2
rename F live_3
rename G live_4
rename H live_5
rename I live_6
rename J live_7
rename K live_8
rename L live_9
rename M live_10
rename N live_not_stated

label var ED "Enumeration District Number"
label var live_total "Liveborn Children Total"
label var live_0 "0 Liveborn Children"
label var live_1 "1 Liveborn Children"
label var live_2 "2 Liveborn Children"
label var live_3 "3 Liveborn Children"
label var live_4 "4 Liveborn Children"
label var live_5 "5 Liveborn Children"
label var live_6 "6 Liveborn Children"
label var live_7 "7 Liveborn Children"
label var live_8 "8 Liveborn Children"
label var live_9 "9 Liveborn Children"
label var live_10 "10 Liveborn Children"
label var live_not_stated "Liveborn Children Not"


save "`datapath'/version01/1-input/BSS_SES/liveborn_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Crime)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Crime") allstring clear

/////	Crime	//////

preserve

*Data cleaning tasks
drop in 1/4
destring, replace

*Renaming and labelling variabels
rename A ED
rename B crime_victim
rename C crime_victim_not_stated
rename D crime_murder
rename E crime_kidnapping
rename F crime_shooting
rename G crime_rape
rename H crime_other
rename I crime_robbery
rename J crime_wound
rename K crime_larceny
rename L crime_not_stated

label var ED "Enumeration District Number"
label var crime_victim "Crime victim"
label var crime_victim_not_stated "Crime victim Not Stated"
label var crime_murder "Murder Crime"
label var crime_kidnapping "Kidnapping Crime"
label var crime_shooting "Shooting Crime"
label var crime_rape "Rape/Abuse Crime"
label var crime_other "Other Crime"
label var crime_robbery "Robbery Crime"
label var crime_wound "Wound Crime"
label var crime_larceny "Larceny Crime"
label var crime_not_stated "Crime Not Stated"

save "`datapath'/version01/1-input/BSS_SES/crime_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (Occupation)
import excel "`datapath'/version01/1-input/BSS_SES/SES_Barbados_Statistical_Service_Census_2010.xlsx", sheet("Occupation") allstring clear

//////	Occupation	//////////

*Male Data
preserve

*Data cleaning tasks
drop AR 
drop in 1/9
keep if A=="Male" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B m_occupation_total
rename C m_occupation_a_forces
rename D m_occupation_exec
rename E m_occupation_admin_mange
rename F m_occupation_prod_mange
rename G m_occupation_hosp_mange
rename H m_occupation_sci_prof
rename I m_occupation_health_prof
rename J m_occupation_teach_prof
rename K m_occupation_busi_prof
rename L m_occupation_info_prof
rename M m_occupation_legal_prof
rename N m_occupation_sci_a_prof
rename O m_occupation_health_a_prof
rename P m_occupation_busi_a_prof
rename Q m_occupation_legal_a_prof
rename R m_occupation_info_tech
rename S m_occupation_gen_clerk
rename T m_occupation_cust_clerk
rename U m_occupation_num_clerk
rename V m_occupation_other_clerk
rename W m_occupation_per_work
rename X m_occupation_sale_work
rename Y m_occupation_care_work
rename Z m_occupation_prot_work
rename AA m_occupation_mar_agri
rename AB m_occupation_mar_fores
rename AC m_occupation_s_farm
rename AD m_occupation_build_work
rename AE m_occupation_metal_work
rename AF m_occupation_handicraft
rename AG m_occupation_elec_work
rename AH m_occupation_food_process
rename AI m_occupation_plant_assemble
rename AJ m_occupation_drive_oper
rename AK m_occupation_clean
rename AL m_occupation_agri_labour
rename AM m_occupation_mining_labour
rename AN m_occupation_food_prep
rename AO m_occupation_street_ser
rename AP m_occupation_refuse_work
rename AQ m_occupation_not_stated

label var ED "Enumeration District Number"
label var m_occupation_total "Male Occupation Total"
label var m_occupation_a_forces "Male Armed Forces Occupation"
label var m_occupation_exec "Male Chief executives, senior officials and legislators Occupation"
label var m_occupation_admin_mange "Male Administrative and Commerical Managers Occupation"
label var m_occupation_prod_mange "Male Production and Specialised Services Managers Occupation"
label var m_occupation_hosp_mange "Male Hospitality Retail and Other Services Managers Occupation"
label var m_occupation_sci_prof "Male Science and Engineering Professionals Occupation"
label var m_occupation_health_prof "Male Health Professionals Occupation"
label var m_occupation_teach_prof "Male Teaching Professionals Occupation"
label var m_occupation_busi_prof "Male Business and Administration Professionals Occupation"
label var m_occupation_info_prof "Male Information and Communications Technology Professionals Occupation"
label var m_occupation_legal_prof "Male Legal, Social and Cultural Professionals Occupation"
label var m_occupation_sci_a_prof "Male Science and Engineering Associate Professionals Occupation"
label var m_occupation_health_a_prof "Male Health Associate Professionals Occupation"
label var m_occupation_busi_a_prof "Male Business and Administration Associate Professionals Occupation"
label var m_occupation_legal_a_prof "Male Legal, Social, Cultural and Related Associate Professionals Occupation"
label var m_occupation_info_tech "Male Information and Communications Technicians Occupation"
label var m_occupation_gen_clerk "Male General and Keyboard Clerks Occupation"
label var m_occupation_cust_clerk "Male Customer Services Clerks Occupation"
label var m_occupation_num_clerk "Male Numerical and Material Recording Clerks Occupation"
label var m_occupation_other_clerk "Male Other Clerical Support Workers Occupation"
label var m_occupation_per_work "Male Personal Service Workers Occupation"
label var m_occupation_sale_work "Male Sales Workers Occupation"
label var m_occupation_care_work "Male Personal Care Workers Occupation"
label var m_occupation_prot_work "Male Protective Services Workers Occupation"
label var m_occupation_mar_agri "Male Market-oriented Skilled Agricultural Workers Occupation"
label var m_occupation_mar_fores "Male Market-oriented Skilled Forestry, Fishery and Hunting Workers Occupation"
label var m_occupation_s_farm "Male Subsistence Farmers, Fishers, Hunters and Gatherers Occupation"
label var m_occupation_build_work "Male Building and related trades Workers Excluding electricians Occupation"
label var m_occupation_metal_work "Male Metal Machinery and Related Trades Workers Occupation"
label var m_occupation_handicraft "Male Handicraft and Printing Workers Occupation"
label var m_occupation_elec_work "Male Electrical and Electronic Trades Workers Occupation"
label var m_occupation_food_process "Male Food Processing, Wood Working, Garment and Other Craft and Related Trades Workers Occupation"
label var m_occupation_plant_assemble "Male Stationary Plant and Machine Operators and Assemblers Occupation"
label var m_occupation_drive_oper "Male Drivers and Mobile Plant Operators Occupation"
label var m_occupation_clean "Male Cleaners and Helpers Occupation"
label var m_occupation_agri_labour "Male Agricultural Forestry and Fishery Labourers Occupation"
label var m_occupation_mining_labour "Male Labourers in Mining Construction Manufacturing and Transport Occupation"
label var m_occupation_food_prep "Male Food Preparation Assistants"
label var m_occupation_street_ser "Male Street and Related Sales and Service Workers Occupation"
label var m_occupation_refuse_work "Male Refuse Workers and other Elementary Workers Occupation"
label var m_occupation_not_stated "Male Occupation Not Stated"

save "`datapath'/version01/1-input/BSS_SES/male_occupation_SES", replace

restore

********************************************************************************

*Female Data
preserve

*Data cleaning tasks
drop AR 
drop in 1/9
keep if A=="Female" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B f_occupation_total
rename C f_occupation_a_forces
rename D f_occupation_exec
rename E f_occupation_admin_mange
rename F f_occupation_prod_mange
rename G f_occupation_hosp_mange
rename H f_occupation_sci_prof
rename I f_occupation_health_prof
rename J f_occupation_teach_prof
rename K f_occupation_busi_prof
rename L f_occupation_info_prof
rename M f_occupation_legal_prof
rename N f_occupation_sci_a_prof
rename O f_occupation_health_a_prof
rename P f_occupation_busi_a_prof
rename Q f_occupation_legal_a_prof
rename R f_occupation_info_tech
rename S f_occupation_gen_clerk
rename T f_occupation_cust_clerk
rename U f_occupation_num_clerk
rename V f_occupation_other_clerk
rename W f_occupation_per_work
rename X f_occupation_sale_work
rename Y f_occupation_care_work
rename Z f_occupation_prot_work
rename AA f_occupation_mar_agri
rename AB f_occupation_mar_fores
rename AC f_occupation_s_farm
rename AD f_occupation_build_work
rename AE f_occupation_metal_work
rename AF f_occupation_handicraft
rename AG f_occupation_elec_work
rename AH f_occupation_food_process
rename AI f_occupation_plant_assemble
rename AJ f_occupation_drive_oper
rename AK f_occupation_clean
rename AL f_occupation_agri_labour
rename AM f_occupation_mining_labour
rename AN f_occupation_food_prep
rename AO f_occupation_street_ser
rename AP f_occupation_refuse_work
rename AQ f_occupation_not_stated

label var ED "Enumeration District Number"
label var f_occupation_total "Female Occupation Total"
label var f_occupation_a_forces "Female Armed Forces Occupation"
label var f_occupation_exec "Female Chief executives, senior officials and legislators Occupation"
label var f_occupation_admin_mange "Female Administrative and Commerical Managers Occupation"
label var f_occupation_prod_mange "Female Production and Specialised Services Managers Occupation"
label var f_occupation_hosp_mange "Female Hospitality Retail and Other Services Managers Occupation"
label var f_occupation_sci_prof "Female Science and Engineering Professionals Occupation"
label var f_occupation_health_prof "Female Health Professionals Occupation"
label var f_occupation_teach_prof "Female Teaching Professionals Occupation"
label var f_occupation_busi_prof "Female Business and Administration Professionals Occupation"
label var f_occupation_info_prof "Female Information and Communications Technology Professionals Occupation"
label var f_occupation_legal_prof "Female Legal, Social and Cultural Professionals Occupation"
label var f_occupation_sci_a_prof "Female Science and Engineering Associate Professionals Occupation"
label var f_occupation_health_a_prof "Female Health Associate Professionals Occupation"
label var f_occupation_busi_a_prof "Female Business and Administration Associate Professionals Occupation"
label var f_occupation_legal_a_prof "Female Legal, Social, Cultural and Related Associate Professionals Occupation"
label var f_occupation_info_tech "Female Information and Communications Technicians Occupation"
label var f_occupation_gen_clerk "Female General and Keyboard Clerks Occupation"
label var f_occupation_cust_clerk "Female Customer Services Clerks Occupation"
label var f_occupation_num_clerk "Female Numerical and Material Recording Clerks Occupation"
label var f_occupation_other_clerk "Female Other Clerical Support Workers Occupation"
label var f_occupation_per_work "Female Personal Service Workers Occupation"
label var f_occupation_sale_work "Female Sales Workers Occupation"
label var f_occupation_care_work "Female Personal Care Workers Occupation"
label var f_occupation_prot_work "Female Protective Services Workers Occupation"
label var f_occupation_mar_agri "Female Market-oriented Skilled Agricultural Workers Occupation"
label var f_occupation_mar_fores "Female Market-oriented Skilled Forestry, Fishery and Hunting Workers Occupation"
label var f_occupation_s_farm "Female Subsistence Farmers, Fishers, Hunters and Gatherers Occupation"
label var f_occupation_build_work "Female Building and related trades Workers Excluding electricians Occupation"
label var f_occupation_metal_work "Female Metal Machinery and Related Trades Workers Occupation"
label var f_occupation_handicraft "Female Handicraft and Printing Workers Occupation"
label var f_occupation_elec_work "Female Electrical and Electronic Trades Workers Occupation"
label var f_occupation_food_process "Female Food Processing, Wood Working, Garment and Other Craft and Related Trades Workers Occupation"
label var f_occupation_plant_assemble "Female Stationary Plant and Machine Operators and Assemblers Occupation"
label var f_occupation_drive_oper "Female Drivers and Mobile Plant Operators Occupation"
label var f_occupation_clean "Female Cleaners and Helpers Occupation"
label var f_occupation_agri_labour "Female Agricultural Forestry and Fishery Labourers Occupation"
label var f_occupation_mining_labour "Female Labourers in Mining Construction Manufacturing and Transport Occupation"
label var f_occupation_food_prep "Female Food Preparation Assistants"
label var f_occupation_street_ser "Female Street and Related Sales and Service Workers Occupation"
label var f_occupation_refuse_work "Female Refuse Workers and other Elementary Workers Occupation"
label var f_occupation_not_stated "Female Occupation Not Stated"

save "`datapath'/version01/1-input/BSS_SES/female_occupation_SES", replace

restore
********************************************************************************

*Total Data
preserve

*Data cleaning tasks
drop AR 
drop in 1/9
keep if A=="Total" 
destring, replace
egen ED = seq()
order ED
drop A

*Renaming and labelling variabels
rename B t_occupation_total
rename C t_occupation_a_forces
rename D t_occupation_exec
rename E t_occupation_admin_mange
rename F t_occupation_prod_mange
rename G t_occupation_hosp_mange
rename H t_occupation_sci_prof
rename I t_occupation_health_prof
rename J t_occupation_teach_prof
rename K t_occupation_busi_prof
rename L t_occupation_info_prof
rename M t_occupation_legal_prof
rename N t_occupation_sci_a_prof
rename O t_occupation_health_a_prof
rename P t_occupation_busi_a_prof
rename Q t_occupation_legal_a_prof
rename R t_occupation_info_tech
rename S t_occupation_gen_clerk
rename T t_occupation_cust_clerk
rename U t_occupation_num_clerk
rename V t_occupation_other_clerk
rename W t_occupation_per_work
rename X t_occupation_sale_work
rename Y t_occupation_care_work
rename Z t_occupation_prot_work
rename AA t_occupation_mar_agri
rename AB t_occupation_mar_fores
rename AC t_occupation_s_farm
rename AD t_occupation_build_work
rename AE t_occupation_metal_work
rename AF t_occupation_handicraft
rename AG t_occupation_elec_work
rename AH t_occupation_food_process
rename AI t_occupation_plant_assemble
rename AJ t_occupation_drive_oper
rename AK t_occupation_clean
rename AL t_occupation_agri_labour
rename AM t_occupation_mining_labour
rename AN t_occupation_food_prep
rename AO t_occupation_street_ser
rename AP t_occupation_refuse_work
rename AQ t_occupation_not_stated

label var ED "Enumeration District Number"
label var t_occupation_total "Total Occupation Total"
label var t_occupation_a_forces "Total Armed Forces Occupation"
label var t_occupation_exec "Total Chief executives, senior officials and legislators Occupation"
label var t_occupation_admin_mange "Total Administrative and Commerical Managers Occupation"
label var t_occupation_prod_mange "Total Production and Specialised Services Managers Occupation"
label var t_occupation_hosp_mange "Total Hospitality Retail and Other Services Managers Occupation"
label var t_occupation_sci_prof "Total Science and Engineering Professionals Occupation"
label var t_occupation_health_prof "Total Health Professionals Occupation"
label var t_occupation_teach_prof "Total Teaching Professionals Occupation"
label var t_occupation_busi_prof "Total Business and Administration Professionals Occupation"
label var t_occupation_info_prof "Total Information and Communications Technology Professionals Occupation"
label var t_occupation_legal_prof "Total Legal, Social and Cultural Professionals Occupation"
label var t_occupation_sci_a_prof "Total Science and Engineering Associate Professionals Occupation"
label var t_occupation_health_a_prof "Total Health Associate Professionals Occupation"
label var t_occupation_busi_a_prof "Total Business and Administration Associate Professionals Occupation"
label var t_occupation_legal_a_prof "Total Legal, Social, Cultural and Related Associate Professionals Occupation"
label var t_occupation_info_tech "Total Information and Communications Technicians Occupation"
label var t_occupation_gen_clerk "Total General and Keyboard Clerks Occupation"
label var t_occupation_cust_clerk "Total Customer Services Clerks Occupation"
label var t_occupation_num_clerk "Total Numerical and Material Recording Clerks Occupation"
label var t_occupation_other_clerk "Total Other Clerical Support Workers Occupation"
label var t_occupation_per_work "Total Personal Service Workers Occupation"
label var t_occupation_sale_work "Total Sales Workers Occupation"
label var t_occupation_care_work "Total Personal Care Workers Occupation"
label var t_occupation_prot_work "Total Protective Services Workers Occupation"
label var t_occupation_mar_agri "Total Market-oriented Skilled Agricultural Workers Occupation"
label var t_occupation_mar_fores "Total Market-oriented Skilled Forestry, Fishery and Hunting Workers Occupation"
label var t_occupation_s_farm "Total Subsistence Farmers, Fishers, Hunters and Gatherers Occupation"
label var t_occupation_build_work "Total Building and related trades Workers Excluding electricians Occupation"
label var t_occupation_metal_work "Total Metal Machinery and Related Trades Workers Occupation"
label var t_occupation_handicraft "Total Handicraft and Printing Workers Occupation"
label var t_occupation_elec_work "Total Electrical and Electronic Trades Workers Occupation"
label var t_occupation_food_process "Total Food Processing, Wood Working, Garment and Other Craft and Related Trades Workers Occupation"
label var t_occupation_plant_assemble "Total Stationary Plant and Machine Operators and Assemblers Occupation"
label var t_occupation_drive_oper "Total Drivers and Mobile Plant Operators Occupation"
label var t_occupation_clean "Total Cleaners and Helpers Occupation"
label var t_occupation_agri_labour "Total Agricultural Forestry and Fishery Labourers Occupation"
label var t_occupation_mining_labour "Total Labourers in Mining Construction Manufacturing and Transport Occupation"
label var t_occupation_food_prep "Total Food Preparation Assistants"
label var t_occupation_street_ser "Total Street and Related Sales and Service Workers Occupation"
label var t_occupation_refuse_work "Total Refuse Workers and other Elementary Workers Occupation"
label var t_occupation_not_stated "Total Occupation Not Stated"

save "`datapath'/version01/1-input/BSS_SES/total_occupation_SES", replace

restore
********************************************************************************
********************************************************************************

*Load in excel data (GIS Attributes)
import excel "`datapath'/version01/1-input/BSS_SES/SES_GIS_BSS_data.xlsx", allstring clear

/////	GIS data	//////

preserve

*Data cleaning tasks
drop in 1
drop D E K-Q AJ AM-GC GX-HM HU-IF IW IX IZ-JB JG-JQ
destring, replace

*Renaming and labelling variabels
rename A ED
rename B parish
rename C total_pop
*Marital Status
rename F marital_married
rename G marital_separated
rename H marital_divorced
rename I marital_widowed
rename J marital_n_married
*Religion
rename R religion_adventist
rename S religion_anglican
rename T religion_bahal 
rename U religion_baptist
rename V religion_bretheren
rename W religion_church_lord
rename X religion_hindu
rename Y religion_jewish
rename Z religion_jevovah_wit
rename AA religion_methodist
rename AB religion_moravian
rename AC religion_mormon
rename AD religion_muslim
rename AE religion_pentecostal
rename AF religion_rasta
rename AG religion_catholic
rename AH religion_salvation
rename AI religion_other_chris
rename AK religion_none
rename AL religion_no
*Number of rooms
rename GD rooms_1
rename GE rooms_2
rename GF rooms_3
rename GG rooms_4
rename GH rooms_5
rename GI rooms_6
rename GJ rooms_7
rename GK rooms_8
rename GL rooms_9_more
*Number of bedrooms
rename GM bedrooms_0
rename GN bedrooms_1
rename GO bedrooms_2
rename GP bedrooms_3
rename GQ bedrooms_4
rename GR bedrooms_5_more
*Number of bathrooms
rename GS bathroom_0
rename GT bathroom_1
rename GU bathroom_2
rename GV bathroom_3
rename GW bathroom_shared
*Sewage
rename HN sewage_wc_sewer
rename HO sewage_wc_no_sewer
rename HP sewage_other_toilet
rename HQ sewage_pit
rename HR sewage_no_toilet
rename HS sewage_shared_toilet
*Electrcity
rename HT electricity
*Number of vehciles 
rename IG vehicles_0
rename IH vehicles_1
rename II vehicles_2
rename IJ vehicles_3
rename IK vehicles_4_more
*Emigrants
rename IL emigrants
*Household ammentites
rename IM amentities_stove
rename IN amentities_fridge
rename IO amentities_freezer
rename IP amentities_water_tank
rename IQ amentities_microwave
rename IR amentities_toaster
rename IS amentities_wash
rename IT amentities_dish_wash
rename IU amentities_dryer
rename IV amentities_fixed_line
rename IY amentities_tv
rename JC amentities_radio
rename JD amentities_cabel_tv
rename JE amentities_stero_system
rename JF amentities_computer
 
*General variables (ED, parish, total population)
label var ED "Enumeration District Number"
label var parish "Parish"
label var total_pop "Total Population within ED"
*Marital Status
label var marital_married "Married population"
label var marital_separated "Separated population"
label var marital_divorced "Divorced population"
label var marital_widowed "Widowed population"
label var marital_n_married "Never Married population"
*Religion
label var religion_adventist "Adventist population"
label var religion_anglican "Anglican population"
label var religion_bahal "Bahal (religion) population"
label var religion_baptist "Baptist population"
label var religion_bretheren "Bretheren population"
label var religion_church_lord "Church of the lord (religion) population"
label var religion_hindu "Hindu population"
label var religion_jewish "Jewish population"
label var religion_jevovah_wit "Jevovah Witness population"
label var religion_methodist "Methodist population"
label var religion_moravian "Moravian population"
label var religion_mormon "Mormon population"
label var religion_muslim "Muslim population"
label var religion_pentecostal "Pentecostal population"
label var religion_rasta "Rastaferian population"
label var religion_catholic "Roman Catholic population"
label var religion_salvation "Salvation population"
label var religion_other_chris "Other Christians population"
label var religion_none "Religion none"
label var religion_no "No religion"
*Number of rooms
label var rooms_1 "Household 1 room"
label var rooms_2 "Household 2 rooms"
label var rooms_3 "Household 3 rooms"
label var rooms_4 "Household 4 rooms"
label var rooms_5 "Household 5 rooms"
label var rooms_6 "Household 6 rooms"
label var rooms_7 "Household 7 rooms"
label var rooms_8 "Household 8 rooms"
label var rooms_9_more "Household 9 rooms and more"
*Number of bedrooms
label var bedrooms_0 "Household 0 bedrooms"
label var bedrooms_1 "Household 1 bedroom"
label var bedrooms_2 "Household 2 bedrooms" 
label var bedrooms_3 "Household 3 bedrooms"
label var bedrooms_4 "Household 4 bedrooms"
label var bedrooms_5_more "Household 5 bedrooms and more"
*Number of bathrooms
label var bathroom_0 "Household 0 bathrooms"
label var bathroom_1 "Household 1 bathroom"
label var bathroom_2 "Household 2 bathrooms"
label var bathroom_3 "Household 3 bathrooms"
label var bathroom_shared "Household shared bathrooms"
*Sewage
label var sewage_wc_sewer "Sewage system available"
label var sewage_wc_no_sewer "No sewage system"
label var sewage_other_toilet "Other Toilet"
label var sewage_pit "Sewage Pit"
label var sewage_no_toilet "Sewage no toilet"
label var sewage_shared_toilet "Sewage share toilet"
*Electrcity
label var electricity "Electricity"
*Number of vehciles 
label var vehicles_0 "Number of vehicles 0"
label var vehicles_1 "Number of vehicles 1"
label var vehicles_2 "Number of vehicles 2"
label var vehicles_3 "Number of vehicles 3"
label var vehicles_4_more "Number of vehicles 4 and more"
*Emigrants
label var emigrants "Emigrant population"
*Household ammentites
label var amentities_stove "Amentities: Stove"
label var amentities_fridge "Amentities: Refridgerator"
label var amentities_freezer "Amentities: Frezer"
label var amentities_water_tank "Amentities: Water Tank"
label var amentities_microwave "Amentities: Microwave"
label var amentities_toaster "Amentities: Toaster"
label var amentities_wash "Amentities: Washing machine"
label var amentities_dish_wash "Amentities: Dish washer"
label var amentities_dryer "Amentities: Electric dryer"
label var amentities_fixed_line "Amentities: Fixed line dryer"
label var amentities_tv "Amentities: Television"
label var amentities_radio "Amentities: Radio"
label var amentities_cabel_tv "Amentities: Cabel TV"
label var amentities_stero_system "Amentities: Stero System"
label var amentities_computer "Amentities: Computer"


save "`datapath'/version01/1-input/BSS_SES/additional_SES", replace

restore
********************************************************************************
********************************************************************************
