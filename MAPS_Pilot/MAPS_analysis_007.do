
clear
capture log close
cls

**  DO-FILE META DATA INFORMATION
**  Program:		MAPS_analysis_007.do
**  Project:      	Streetscapres- PhD & Walkability
**	Sub-Project:	Pilot MAPS UNESCO Heritiage Site Barbados
**  Analyst:		Kern Rocke
**	Date Created:	20/06/2020
**	Date Modified: 	20/06/2020
**  Algorithm Task: Creating table similar to USVI paper


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*cd "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
*local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145


/*	IMPORTANT: 

	The following STATA do files should be excuted prior the excuting this 
	do files

	1) MAPS_prep_001.do
	2) MAPS_prep_002.do
	
	NOTE: This do file uses the putexcel command for ease of creation of table 1

*/



*Load dataset from encrypted location
use "`datapath'/version01/2-working/MAPS/MAPS_Recoding_Scoring", clear

*----------------------------BEGIN----------------------------------------------

/// Creating exccel file to store Prevalence Estimates_USVI results
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx"


*Time taken to conduct audit
mean time_diff, cformat(%tcHH:MM)

* Selecting maps route section for analysis
keep if instrument_type==1

//Route Descriptives

*Recoding mixed to commercial
*Frequency and percentage of type of routes audited
recode type (3=2)
tab type


*Types of residential uses
tab1 LU3a - LU3d


////////////////////////////////////////////////////////////////////////////////

***LAND USE

*Prevalence Estimates_USVI for number of destinations by type

egen destinations = rowtotal(LU6a - LU6z)
recode destinations (2/max=2)
tab destinations, gen(dest)

*Recode Beach access
recode LU6y (1/max=1)
tab LU6y, gen(beach)


*Destination

** des1 = 1 Destinations
** des2 = >2 Destinations
** LU6y = Beach access

*-------------------------------------------------------------------------------
*Overall
ci dest1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel B7=("Overall")
putexcel A8=("Destinations")
putexcel A9=("0-2")
putexcel B8=("Prevalence")
putexcel C8=("Lower Bound CI")
putexcel D8=("Upper Bound CI")
putexcel B9=(r(mean)) C9=(r(lb)) D9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify


*Residential
ci dest1 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F7=("Residential")
putexcel F8=("Prevalence")
putexcel G8=("Lower Bound CI")
putexcel H8=("Upper Bound CI")
putexcel F9=(r(mean)) G9=(r(lb)) H9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci dest1 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J7=("Commerical")
putexcel J8=("Prevalence")
putexcel K8=("Lower Bound CI")
putexcel L8=("Upper Bound CI")
putexcel J9=(r(mean)) K9=(r(lb)) L9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
putexcel M8=("p-value")
proportion dest1, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M9=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*-------------------------------------------------------------------------------
*Overall
ci dest2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A10=("3-4")
putexcel B10=(r(mean)) C10=(r(lb)) D10=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci dest2 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F10=(r(mean)) G10=(r(lb)) H10=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci dest2 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J10=(r(mean)) K10=(r(lb)) L10=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion dest2, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M10=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*-------------------------------------------------------------------------------
*Overall - Beach access
ci beach2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A11=("Beach Access")
putexcel B11=(r(mean)) C11=(r(lb)) D11=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci beach2 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F11=(r(mean)) G11=(r(lb)) H11=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci beach2 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J11=(r(mean)) K11=(r(lb)) L11=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion beach2, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M11=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

*STREETSCAPE


*Presence of at least 1 bus stop
preserve
tab SS1a
recode SS1a (1/max=1)

*SS1a = Numbero of transit bus stops

*Overall
ci SS1a , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A40=("Streetscape")
putexcel A41=("Presence of at least 1 bus stop")
putexcel B41=(r(mean)) C41=(r(lb)) D41=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci SS1a if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F41=(r(mean)) G41=(r(lb)) H41=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci SS1a if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J41=(r(mean)) K41=(r(lb)) L41=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion SS1a, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M41=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

restore
////////////////////////////////////////////////////////////////////////////////


*Traffic Calming - at least 1 traffic calming feature

preserve
recode SS4a (1/max=1)
tab SS4a, gen(SS4a)

*SS4a1 = No traffic calming feature
*SS4a2 = Presence of at least 1 traffic calming feature

*Overall
ci SS4a2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A45=("Presence of traffic calming feature")
putexcel B45=(r(mean)) C45=(r(lb)) D45=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci SS4a2 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F45=(r(mean)) G45=(r(lb)) H45=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci SS4a2 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J45=(r(mean)) K45=(r(lb)) L45=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion SS4a2, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M45=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

restore
////////////////////////////////////////////////////////////////////////////////

*Presence of 1 bus stop feature at bus stop


preserve

egen bus_feature = rowtotal(SS2_1b SS2_1c)
recode bus_feature (1/max=1)
tab bus_feature

*Overall
ci bus_feature , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A48=("Presence of 1 bus stop feature")
putexcel B48=(r(mean)) C48=(r(lb)) D48=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci bus_feature if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F48=(r(mean)) G48=(r(lb)) H48=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci bus_feature if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J48=(r(mean)) K48=(r(lb)) L48=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion bus_feature, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M48=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

restore
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

*AESETHICS

*Presence of Hardscape Features

*Overall
ci A1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A51=("Aesethics")
putexcel A52=("Presence of Hardscape Features")
putexcel B52=(r(mean)) C52=(r(lb)) D52=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci A1 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F52=(r(mean)) G52=(r(lb)) H52=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci A1 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J52=(r(mean)) K52=(r(lb)) L52=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion A1, over(type)
test [Yes] :Residential = [Yes] :Commercial
putexcel M52=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

////////////////////////////////////////////////////////////////////////////////

*Presence of Softscape Features

*Overall
ci A2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A53=("Presence of Softscape Features")
putexcel B53=(r(mean)) C53=(r(lb)) D53=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci A2 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F53=(r(mean)) G53=(r(lb)) H53=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci A2 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J53=(r(mean)) K53=(r(lb)) L53=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion A2, over(type)
test [Yes] :Residential = [Yes] :Commercial
putexcel M53=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

////////////////////////////////////////////////////////////////////////////////

*Building Maintaince (50-99%)

preserve 
recode A4 (1=0) (2=1)

*Overall
ci A4 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A55=("Maintaince (50-99%)")
putexcel A56=("Building Maintaince")
putexcel B56=(r(mean)) C56=(r(lb)) D56=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci A4 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F56=(r(mean)) G56=(r(lb)) H56=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci A4 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J56=(r(mean)) K56=(r(lb)) L56=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion A4, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M56=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

restore

////////////////////////////////////////////////////////////////////////////////

*Outdoor Maintaince (50-99%)

preserve
recode A5 (1=0) (2=1)

*Overall
ci A5 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A57=("Outdoor Maintaince")
putexcel B57=(r(mean)) C57=(r(lb)) D57=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci A5 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F57=(r(mean)) G57=(r(lb)) H57=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci A5 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J57=(r(mean)) K57=(r(lb)) L57=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion A5, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M57=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

restore

////////////////////////////////////////////////////////////////////////////////

*Presence of Graffti

tab A6a, gen(graffti)

*Overall
ci graffti1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A58=("No Presence of Graffti")
putexcel B58=(r(mean)) C58=(r(lb)) D58=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci graffti1 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F58=(r(mean)) G58=(r(lb)) H58=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci graffti1 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J58=(r(mean)) K58=(r(lb)) L58=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion graffti1, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M58=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify



////////////////////////////////////////////////////////////////////////////////

tab SS5, gen(light_)

*light_1 - None
*light_2 - Some
*light_3 - Ample

*No lighting

*Overall
ci light_1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A60=("Lighting")
putexcel A61=("None")
putexcel B61=(r(mean)) C61=(r(lb)) D61=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci light_1 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F61=(r(mean)) G61=(r(lb)) H61=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci light_1 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J61=(r(mean)) K61=(r(lb)) L61=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion light_1, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M61=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*-------------------------------------------------------------------------------
*Some lighting

*Overall
ci light_2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A62=("Some")
putexcel B62=(r(mean)) C62=(r(lb)) D62=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci light_2 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F62=(r(mean)) G62=(r(lb)) H62=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci light_2 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J62=(r(mean)) K62=(r(lb)) L62=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion light_2, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M62=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*-------------------------------------------------------------------------------
*Ample lighting

*Overall
ci light_3 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel A63=("Ample")
putexcel B63=(r(mean)) C63=(r(lb)) D63=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Residential
ci light_3 if type==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel F63=(r(mean)) G63=(r(lb)) H63=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Commerical
ci light_3 if type==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify
putexcel J63=(r(mean)) K63=(r(lb)) L63=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

*Wald test for differences in proportions between residential and commercial
proportion light_3, over(type)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M63=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Route") modify

////////////////////////////////////////////////////////////////////////////////

*Load dataset from encrypted location
use "`datapath'/version01/2-working/MAPS/MAPS_Recoding_Scoring", clear

*-------------------------------BEGIN-------------------------------------------
*Keeping all street segment data
keep if instrument_type==2

*Recoding mixed to commercial
recode type_segment (3=2)

tab type_segment

////////////////////////////////////////////////////////////////////////////////
*SIDEWALK




tab S1_1, gen(S1_1a)

*Prevalence Estimates_USVI for no sidewalk
ci S1_1a1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel B6=("Overall")
putexcel A8=("No sidewalk")
putexcel B7=("Prevalence")
putexcel C7=("Lower Bound CI")
putexcel D7=("Upper Bound CI")
putexcel B8=(r(mean)) C8=(r(lb)) D8=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci S1_1a1 if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F6=("Residential")
putexcel F7=("Prevalence")
putexcel G7=("Lower Bound CI")
putexcel H7=("Upper Bound CI")
putexcel F8=(r(mean)) G8=(r(lb)) H8=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci S1_1a1 if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J6=("Commerical")
putexcel J7=("Prevalence")
putexcel K7=("Lower Bound CI")
putexcel L7=("Upper Bound CI")
putexcel J8=(r(mean)) K8=(r(lb)) L8=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
putexcel M7=("p-value")
proportion S1_1a1, over(type_segment)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M8=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------

*Prevalence Estimates_USVI for sidewalk present
ci S1_1a2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A9=("Sidewalk Present")
putexcel B9=(r(mean)) C9=(r(lb)) D9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci S1_1a2 if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F9=(r(mean)) G9=(r(lb)) H9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci S1_1a2 if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J9=(r(mean)) K9=(r(lb)) L9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion S1_1a2, over(type_segment)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M9=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------
 *Prevalence sidewalk continunity
ci S1_4b , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A16=("Sidewalk Continuinity")
putexcel A17=("Sidewalk continuous")
putexcel B17=(r(mean)) C17=(r(lb)) D17=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci S1_4b if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F17=(r(mean)) G17=(r(lb)) H17=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci S1_4b if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J17=(r(mean)) K17=(r(lb)) L17=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion S1_4b, over(type_segment)
test [Checked] :Residential = [Checked] :Commercial
putexcel M17=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
*-------------------------------------------------------------------------------
*Sidewalk discontinuous
egen sidewalk_dis = rowtotal(S1_4c S1_4d)
recode sidewalk_dis (1/max=1)

ci sidewalk_dis , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A18=("Sidewalk discontinuous")
putexcel B18=(r(mean)) C18=(r(lb)) D18=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci sidewalk_dis if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F18=(r(mean)) G18=(r(lb)) H18=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci sidewalk_dis if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J18=(r(mean)) K18=(r(lb)) L18=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion S1_4c, over(type_segment)
test [Checked] :Residential = [Checked] :Commercial
putexcel M18=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------
*WIDTH OF SIDEWALK

tab S1_2, gen(S1_2a)

*Prevalence Estimates_USVI for <3 feet 
ci S1_2a2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A11=("Sidewalk width")
putexcel A12=("< 3 ft")
putexcel B12=(r(mean)) C12=(r(lb)) D12=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci S1_2a2 if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F12=(r(mean)) G12=(r(lb)) H12=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci S1_2a2 if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J12=(r(mean)) K12=(r(lb)) L12=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion S1_2a2, over(type_segment)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M12=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------
*Prevalence Estimates_USVI for 3-5 feet 
ci S1_2a3 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A13=("3-5 ft")
putexcel B13=(r(mean)) C13=(r(lb)) D13=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci S1_2a3 if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F13=(r(mean)) G13=(r(lb)) H13=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci S1_2a3 if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J13=(r(mean)) K13=(r(lb)) L13=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion S1_2a3, over(type_segment)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M13=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------

*Prevalence Estimates_USVI for >5 feet 
ci S1_2a4 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A14=(">5 ft")
putexcel B14=(r(mean)) C14=(r(lb)) D14=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci S1_2a4 if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F14=(r(mean)) G14=(r(lb)) H14=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci S1_2a4 if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J14=(r(mean)) K14=(r(lb)) L14=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion S1_2a4, over(type_segment)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M14=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------

*Prevalence buffer
ci S1_3a , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A19=("Buffer Present")
putexcel B19=(r(mean)) C19=(r(lb)) D19=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci S1_3a if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F19=(r(mean)) G19=(r(lb)) H19=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci S1_3a if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J19=(r(mean)) K19=(r(lb)) L19=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion S1_3a, over(type_segment)
test [Yes] :Residential = [Yes] :Commercial
putexcel M19=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------
*No Major Tripping hazards

gen no_major_trip = .
replace no_major_trip = 0 if S1_5b >=2
replace no_major_trip = 1 if S1_5b <2

ci no_major_trip , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A20=("No Major Tripping Hazard")
putexcel B20=(r(mean)) C20=(r(lb)) D20=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci no_major_trip if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F20=(r(mean)) G20=(r(lb)) H20=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci no_major_trip if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J20=(r(mean)) K20=(r(lb)) L20=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion no_major_trip, over(type_segment)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M20=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*-------------------------------------------------------------------------------
*No Tempoary Obstructions

gen no_temp_obstruction = .
replace no_temp_obstruction = 1 if S1_5b <2 | S1_5c <2
replace no_temp_obstruction = 0 if S1_5b >=2 | S1_5c >=2

ci no_temp_obstruction , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel A22=("No Major Tripping Hazard")
putexcel B22=(r(mean)) C22=(r(lb)) D22=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Residential
ci no_temp_obstruction if type_segment==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel F22=(r(mean)) G22=(r(lb)) H22=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Commerical
ci no_temp_obstruction if type_segment==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify
putexcel J22=(r(mean)) K22=(r(lb)) L22=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify

*Wald test for differences in proportions between residential and commercial
proportion no_temp_obstruction, over(type_segment)
test [_prop_2] :Residential = [_prop_2] :Commercial
putexcel M22=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Segment") modify


////////////////////////////////////////////////////////////////////////////////
*Crossing

*Load dataset from encrypted location
use "`datapath'/version01/2-working/MAPS/MAPS_Recoding_Scoring", clear

*--------------------------------BEGIN------------------------------------------

*Keeping all street crossing data
keep if instrument_type==3

tab type_crossing

////////////////////////////////////////////////////////////////////////////////
*Intersection (At least 1 control)

egen intersection = rowtotal(C1_1d C1_5a C1_5b C1_7c)
recode intersection (1/max=1)

*Prevalence Estimates_USVI for No signals
ci intersection , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel B6=("Overall")
putexcel A8=("At least 1 control at Intersection")
putexcel B7=("Prevalence")
putexcel C7=("Lower Bound CI")
putexcel D7=("Upper Bound CI")
putexcel B8=(r(mean)) C8=(r(lb)) D8=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Residential
ci intersection if type_crossing==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel F6=("Residential")
putexcel F7=("Prevalence")
putexcel G7=("Lower Bound CI")
putexcel H7=("Upper Bound CI")
putexcel F8=(r(mean)) G8=(r(lb)) H8=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Commerical
ci intersection if type_crossing==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel J6=("Commerical")
putexcel J7=("Prevalence")
putexcel K7=("Lower Bound CI")
putexcel L7=("Upper Bound CI")
putexcel J8=(r(mean)) K8=(r(lb)) L8=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Wald test for differences in proportions between residential and commercial
putexcel M7=("p-value")
proportion intersection, over(type_crossing)
test [_prop_2] :Residenital = [_prop_2] :Commercial 
putexcel M8=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*-------------------------------------------------------------------------------
egen p_sign = rowtotal(C1_3b C1_3c C1_3d)
recode p_sign (1/max=1)

*Prevalence Estimates_USVI for Pedestrian walk signals
ci p_sign , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel A9=("Pedestrian walk signals")
putexcel B9=(r(mean)) C9=(r(lb)) D9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Residential
ci p_sign if type_crossing==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel F9=(r(mean)) G9=(r(lb)) H9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Commerical
ci p_sign if type_crossing==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel J9=(r(mean)) K9=(r(lb)) L9=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Wald test for differences in proportions between residential and commercial
proportion p_sign, over(type_crossing)
test [_prop_2] :Residenital = [_prop_2] :Commercial 
putexcel M9=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*-------------------------------------------------------------------------------

*CROSSWALK TREATMENT

egen cross_treat = rowtotal(C1_8a C1_8b)
recode cross_treat (1/max=1)

ci cross_treat , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel A17=("At least 1 crosswalk treatment")
putexcel B17=(r(mean)) C17=(r(lb)) D17=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Residential
ci cross_treat if type_crossing==1 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel F17=(r(mean)) G17=(r(lb)) H17=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Commerical
ci cross_treat if type_crossing==2 , binomial
putexcel set "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify
putexcel J17=(r(mean)) K17=(r(lb)) L17=(r(ub)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify

*Wald test for differences in proportions between residential and commercial
proportion cross_treat, over(type_crossing)
test [_prop_2] :Residenital = [_prop_2] :Commercial 
putexcel M17=(r(p)) using "`datapath'/version01/3-output/MAPS/Prevalence Estimates_USVI.xlsx", sheet("Crossing") modify


////////////////////////////////////////////////////////////////////////////////

*------------------------------END----------------------------------------------
