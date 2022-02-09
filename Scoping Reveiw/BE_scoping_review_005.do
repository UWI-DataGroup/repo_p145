
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_005.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	20/01/2021
**	Date Modified: 	09/02/2022
**  Algorithm Task: Creating Funnel and Forest Plots


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

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Scoping Review/SR_PA_005.log",  replace


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

/*
Important to note this analysis is not for the purposes of a meta-analysis of the 
scoping review. 

This analysis seeks to examine the overall association between physical activity and 
built environment attributes. 

Activity outcomes which will be examoined will be:
	1) Active Transport
	2) Leisure-time Physical Activity
	3) Moderate to Vigorous Physical Activity
	
Estimates being used in this analysis are from adjusted multivariable regression models

Initially we will start off with studies reporting odds ratios, then move onto studies 
reporting continous estimates.

*/


*Load in data from encrypted location
*import excel "/Users/kernrocke/Downloads/Scoping_Review_Association.xlsx", sheet("Sheet6") firstrow clear

import excel "`datapath'/version01/1-input/Scoping Review/Relationships_Scoping_Review.xlsx", sheet("Sheet1") firstrow clear

/*
*Install user-driven commands for forest and funnel plots
ssc install admetan, replace
ssc install metan, replace
ssc install metafunnel, replace
ssc install metabias, replace
*/

*Minor Cleaning
replace Author = "Christiansen 2016" if Author == "christiansen 2016"
sort Author
encode BEMeasure, gen(built)
encode PhysicalActivityType, gen(activity)
encode Estimatetype, gen(estimate_type)
rename estimate or
rename lowerlimit Lower
rename upperlimit Upper

gen BE = .
tostring BE, replace

replace BE = "Route Characteristics" if BEMeasure == "Bike path density"
replace BE = "Transit" if BEMeasure == "Bus Stop"
replace BE = "Transit" if BEMeasure == "Bus stops"
replace BE = "Land Use" if BEMeasure == "Density of private places for PA"
replace BE = "Food Environment" if BEMeasure == "Food stores"
replace BE = "Land Use" if BEMeasure == "Gym facilities"
replace BE = "Land Use" if BEMeasure == "High Land use mix"
replace BE = "Population Density" if BEMeasure == "High Population Density"
replace BE = "Route Characteristics" if BEMeasure == "High Slope"
replace BE = "Street Connectivity" if BEMeasure == "High Street Connectivity"
replace BE = "Walkability Measure" if BEMeasure == "High Walkability Index"
replace BE = "Land Use" if BEMeasure == "High land use mix"
replace BE = "Open Greenspace" if BEMeasure == "High park density"
replace BE = "Population Density" if BEMeasure == "High population density"
replace BE = "Residential Density" if BEMeasure == "High residential area proportion"
replace BE = "Route Characteristics" if BEMeasure == "High slope"
replace BE = "Route Characteristics" if BEMeasure == "High street density"
replace BE = "Street Connectivity" if BEMeasure == "Intersection density"
replace BE = "Land Use" if BEMeasure == "Land use mix"
replace BE = "Land Use" if BEMeasure == "Land Use mix"
replace BE = "Proximity to Destinations" if BEMeasure == "Near gym "
replace BE = "Proximity to Destinations" if BEMeasure == "Near leisure and sport center"
replace BE = "Proximity to Destinations" if BEMeasure == "Near to outdoor gym equipment"
replace BE = "Proximity to Destinations" if BEMeasure == "Near to waterfront"
replace BE = "Open Greenspace" if BEMeasure == "Number of public spaces"
replace BE = "Open Greenspace" if BEMeasure == "Parks"
replace BE = "Population Density" if BEMeasure == "Population density" 
replace BE = "Route Characteristics" if BEMeasure == "Presence of bike path"
replace BE = "Open Greenspace" if BEMeasure == "Presence of parks and squares"
replace BE = "Open Greenspace" if BEMeasure == "Presence of parks, spaces and facilities for physical activity"
replace BE = "Land Use" if BEMeasure == "Presence of public gyms"
replace BE = "Open Greenspace" if BEMeasure == "Presence of trees and gardens"
replace BE = "Proximity to Destinations" if BEMeasure == "Proximity to gym"
replace BE = "Proximity to Destinations" if BEMeasure == "Proximity to seafront"
replace BE = "Proximity to Destinations" if BEMeasure == "Proximity to squares"
replace BE = "Transit" if BEMeasure == "Public Transportation"
replace BE = "Open Greenspace" if BEMeasure == "Public space"
replace BE = "Open Greenspace" if BEMeasure == "Public space (High activity)"
replace BE = "Open Greenspace" if BEMeasure == "Public space (low activity)"
replace BE = "Transit" if BEMeasure == "Public transport density"
replace BE = "Land Use" if BEMeasure == "Recreational facilities"
replace BE = "Residential Density" if BEMeasure == "Residential density"
replace BE = "Retail Floor" if BEMeasure == "Retail Floor"
replace BE = "Route Characteristics" if BEMeasure == "Sidewalks"
replace BE = "Route Characteristics" if BEMeasure == "Sidewalks/Trees for shading"
replace BE = "Street Connectivity" if BEMeasure == "Street connectivity"
replace BE = "Route Characteristics" if BEMeasure == "Street density"
replace BE = "Route Characteristics" if BEMeasure == "Street lighting"
replace BE = "Food Environment" if BEMeasure == "Supermarkets"
replace BE = "Transit" if BEMeasure == "Transit Station"
replace BE = "Walkability Measure" if BEMeasure == "Walkability Index"
replace BE = "Walkability Measure" if BEMeasure == "Walkscore"
replace BE = "Route Characteristics" if BEMeasure == "walking paths"

tab BE

*Creating variables for forest plots
gen lnor = .
gen lnlci = .
gen lnuci = .
replace lnor = ln(or) if estimate_type != 1 & estimate_type != 6
replace lnlci = ln(Lower) if estimate_type != 1 & estimate_type != 6
replace lnuci = ln(Upper) if estimate_type != 1 & estimate_type != 6
gen or_se = .
replace or_se = (lnuci - lnlci) / (2*invnormal(0.975)) if estimate_type != 1 & estimate_type != 6


*Surveillance
gen surveillance = ""
replace surveillance = "Surveillance" if BEMeasure == "Street lighting"

*Experience
gen experience = ""
replace experience = "Experience" if BEMeasure == "High slope"
replace experience = "Experience" if BEMeasure == "High Slope"
replace experience = "Experience" if BEMeasure == "Sidewalks/Trees for shading"

*Traffic Safety
gen traffic = ""
replace traffic = "Traffic Safety" if BEMeasure == "Transit Station"
replace traffic = "Traffic Safety" if BEMeasure == "Public transport density"
replace traffic = "Traffic Safety" if BEMeasure == "Public Transportation"
replace traffic = "Traffic Safety" if BEMeasure == "Sidewalks"
replace traffic = "Traffic Safety" if BEMeasure == "walking paths"
replace traffic = "Traffic Safety" if BEMeasure == "Bus Stop"
replace traffic = "Traffic Safety" if BEMeasure == "Bus stops"

*Greenspace
gen greenspace = ""
replace greenspace = "Greenspace" if BEMeasure == "Presence of parks and squares"
replace greenspace = "Greenspace" if BEMeasure == "Presence of parks, spaces and facilities for physical activity"
replace greenspace = "Greenspace" if BEMeasure == "Parks"
replace greenspace = "Greenspace" if BEMeasure == "Presence of trees and gardens"
replace greenspace = "Greenspace" if BEMeasure == "High park density"

*Community 
gen community = ""
replace community = "Community" if BEMeasure == "Public space (low activity)"
replace community = "Community" if BEMeasure == "Public space"
replace community = "Community" if BEMeasure == "Public space (High activity)"
replace community = "Community" if BEMeasure == "Presence of parks and squares"
replace community = "Community" if BEMeasure == "Number of public spaces"
replace community = "Community" if BEMeasure == "Presence of parks and squares"
replace community = "Community" if BEMeasure == "Presence of parks, spaces and facilities for physical activity"
replace community = "Community" if BEMeasure == "Proximity to squares"

*Land Use
gen land_use = ""
replace land_use = "Land Use" if BEMeasure == "Supermarkets"
replace land_use = "Land Use" if BEMeasure == "Recreational facilities"
replace land_use = "Land Use" if BEMeasure == "Presence of public gyms"
replace land_use = "Land Use" if BEMeasure == "Land use mix"
replace land_use = "Land Use" if BEMeasure == "Land Use mix"
replace land_use = "Land Use" if BEMeasure == "Gym facilities"
replace land_use = "Land Use" if BEMeasure == "High Land use mix"
replace land_use = "Land Use" if BEMeasure == "Density of private places for PA"
replace land_use = "Land Use" if BEMeasure == "Food stores"
replace land_use = "Land Use" if BEMeasure == "High land use mix"
replace land_use = "Land Use" if BEMeasure == "Walkscore"
replace land_use = "Land Use" if BEMeasure == "Near gym "
replace land_use = "Land Use" if BEMeasure == "Near leisure and sport center"
replace land_use = "Land Use" if BEMeasure == "Proximity to gym"
replace land_use = "Land Use" if BEMeasure == "Proximity to seafront"
replace land_use = "Land Use" if BEMeasure == "Near to outdoor gym equipment"
replace land_use = "Land Use" if BEMeasure == "Near to waterfront"
replace land_use = "Land Use" if BEMeasure == "Retail Floor"
replace land_use = "Land Use" if BEMeasure == "Walkability Index"

*Density
gen density = ""
replace density = "Density" if BEMeasure == "Residential density"
replace density = "Density" if BEMeasure == "High population density"
replace density = "Density" if BEMeasure == "High residential area proportion"
replace density = "Density" if BEMeasure == "High Population Density"
replace density = "Density" if BEMeasure == "Population density" 
replace density = "Density" if BEMeasure == "Walkability Index"

*Connectivity
gen connectivity = ""
replace connectivity = "Connectivity" if BEMeasure == "Bike path density"
replace connectivity = "Connectivity" if BEMeasure == "High Street Connectivity"
replace connectivity = "Connectivity" if BEMeasure == "High Walkability Index"
replace connectivity = "Connectivity" if BEMeasure == "High street density"
replace connectivity = "Connectivity" if BEMeasure == "Intersection density"
replace connectivity = "Connectivity" if BEMeasure == "Presence of bike path"
replace connectivity = "Connectivity" if BEMeasure == "Street connectivity"
replace connectivity = "Connectivity" if BEMeasure == "Street density"
replace connectivity = "Connectivity" if BEMeasure == "Walkability Index"

*Creating and Bolding Walkability for Health Dimensions String
gen walkhealth = ""
replace walkhealth = "{bf:1.Surveillance}" if surveillance == "Surveillance"
replace walkhealth = "{bf:2.Experience}" if experience == "Experience"
replace walkhealth = "{bf:3.Traffic Safety}" if traffic == "Traffic Safety"
replace walkhealth = "{bf:4.Community}" if community == "Community"
replace walkhealth = "{bf:5.Greenspace}" if greenspace == "Greenspace"
replace walkhealth = "{bf:6.Density}" if density == "Density"
replace walkhealth = "{bf:7.Connectivity}" if connectivity == "Connectivity"
replace walkhealth = "{bf:8.Land Use}" if land_use == "Land Use"

tab walkhealth

gen PA = ""
replace PA = "1.Leisure-time PA" if PhysicalActivityType == "Leisure-time Physical Activity"
replace PA = "2.MVPA" if PhysicalActivityType == "Moderate to Vigorous Physical Activity"
replace PA = "2.MVPA" if PhysicalActivityType == "Total physical activity "
replace PA = "3.Active Transport" if PhysicalActivityType == "Active Transport (cycling)"
replace PA = "3.Active Transport" if PhysicalActivityType == "Active Transport (walking)"
tab PA

*Bolding of variable labels
label var BEMeasure `"`"{bf:Built Envrionment}"' `"{bf:Attributes}"'"'
label var walkhealth `"`"{bf:Walkability for}"' `"{bf:Health Framework}"'"'
label var Author `"`"{bf:Studies}"'"'
label var BE `"`"{bf:Built Envrionment}"' `"{bf:Attributes}"'"'



*Bolding Built Environment Attributes String
replace BE = "{bf:Walkability Index}" if BE == "Walkability Measure"
replace BE = "{bf:Retail Floor}" if BE == "Retail Floor"
replace BE = "{bf:Transit}" if BE == "Transit"
replace BE = "{bf:Route Characteristics}" if BE == "Route Characteristics"
replace BE = "{bf:Food Environment}" if BE == "Food Environment"	
replace BE = "{bf:Population Density}" if BE == "Population Density"
replace BE = "{bf:Residential Density}" if BE == "Residential Density"
replace BE = "{bf:Land Use}" if BE == "Land Use"
replace BE = "{bf:Open Greenspace}" if BE == "Open Greenspace"
replace BE = "{bf:Street Connectivity}" if BE == "Street Connectivity"
replace BE = "{bf:Proximity to Destinations}" if BE == "Proximity to Destinations"

*Prepartory Cleaning for Forest Plots
replace Author = "Florindo 2019 (Supermarkets)" if BEMeasure == "Supermarkets" & Author == "Florindo 2019"
replace Author = "Florindo 2019 (Food Stores)" if BEMeasure == "Food stores" & Author == "Florindo 2019"
replace Author = "Florindo 2019 (Parks)" if BEMeasure == "Parks" & Author == "Florindo 2019"
replace Author = "Florindo 2019 (Public Open Space)" if BEMeasure == "Public space" & Author == "Florindo 2019"

replace Author = "Hino 2013 (Bike Path Density)" if BEMeasure == "Bike path density" & Author == "Hino 2013"
replace Author = "Hino 2013 (Street Density)" if BEMeasure == "High street density" & Author == "Hino 2013"
replace Author = "Hino 2013 (Population Density)" if BEMeasure == "High population density" | BEMeasure == "High Population Density" | BEMeasure == "Population density" & Author == "Hino 2013"
replace Author = "Hino 2013 (Residential Density)" if BEMeasure == "Residential density" | BEMeasure == "High residential area proportion" & Author == "Hino 2013"


replace Author = "Da Silva 2017 (Low SES: Presence of Trees)" if BEMeasure == "Presence of trees and gardens" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Presence of Trees)" if BEMeasure == "Presence of trees and gardens" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Low SES: Public Space)" if BEMeasure == "Public space" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Public Space)" if BEMeasure == "Public space" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Low SES: Proximity to seafront)" if BEMeasure == "Proximity to seafront" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Proximity to seafront)" if BEMeasure == "Proximity to seafront" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Low SES: Population Density)" if BEMeasure == "Population density" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Population Density)" if BEMeasure == "Population density" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Low SES: Street Connectivity)" if BEMeasure == "Street connectivity" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Street Connectivity)" if BEMeasure == "Street connectivity" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Low SES: Sidewalks)" if BEMeasure == "Sidewalks" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Sidewalks)" if BEMeasure == "Sidewalks" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Low SES: Street Lighting)" if BEMeasure == "Street lighting" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Street Lighting)" if BEMeasure == "Street lighting" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Low SES: Walking Paths)" if BEMeasure == "walking paths" & Author == "Da Silva 2017" & Subcat == "Low SES"
replace Author = "Da Silva 2017 (High SES: Walking Paths)" if BEMeasure == "walking paths" & Author == "Da Silva 2017" & Subcat == "High SES"

replace Author = "Da Silva 2017 (Proximity to seafront)" if BEMeasure == "Proximity to seafront" & Author == "Da Silva 2017"
replace Author = "Da Silva 2017 (Proximity to gym)" if BEMeasure == "Proximity to gym" & Author == "Da Silva 2017"

replace Author = "Lopes 2018 (Outcome: Walking 150 min/week)" if Outcome == "walk 150 min/week" & Author == "Lopes 2018"
replace Author = "Lopes 2018 (Outcome: Walking 10 min/week)" if Outcome == "walk 10 min/week" & Author == "Lopes 2018"

replace Author = "Hino 2011 (Proximity to gym)" if BEMeasure == "Near gym " & Author == "Hino 2011"
replace Author = "Hino 2011 (Proximity to leisure and sport centre)" if BEMeasure == "Near leisure and sport center" & Author == "Hino 2011"

replace Author = "Faerstein 2018 (Proximity to seafront)" if BEMeasure == "Near to waterfront" & Author == "Faerstein 2018" 
replace Author = "Faerstein 2018  (Proximity to public squares)" if BEMeasure == "Proximity to squares" & Author == "Faerstein 2018"
replace Author = "Faerstein 2018  (Proximity to outdoor gym)" if BEMeasure == "Near to outdoor gym equipment" & Author == "Faerstein 2018"

replace Author = "Hino 2019 (Buffer: 500m; Parks)" if Subcat == "500m" & Author == "Hino 2019"  & BEMeasure == "Parks"
replace Author = "Hino 2019 (Buffer: 1000m; Parks)" if Subcat == "1000m" & Author == "Hino 2019" & BEMeasure == "Parks"

replace Author = "Hino 2019 (Buffer: 500m; Public Spaces)" if Subcat == "500m" & Author == "Hino 2019" & BEMeasure == "Number of public spaces"
replace Author = "Hino 2019 (Buffer: 1000m; Public Spaces)" if Subcat == "1000m" & Author == "Hino 2019" & BEMeasure == "Number of public spaces"

gsort -lnor 

*-------------------------------------------------------------------------------		

*Forest Plot
**Active Transport

*Active Transport Cycling
admetan lnor lnlci lnuci if activity==1 , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures", ///
		color(black) size(large)) caption("Outcome: cycling for transport (10/150 min per week)", span size(medium)) ///
		dp(2) name(forest_AT_cycling, replace) xlabel(0.50(1)4 0.30 1 4, labsize(medium))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins cycling commute/week # >10 mins cycling comute/week) ysize(1) xsize(4)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_cycle.png", as(png) replace
		
*Active Transport Walking (No Buffer)
admetan lnor lnlci lnuci if activity==2 & Subcat == "" | Subcat == "High SES" | Subcat == "Low SES" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking, replace) xlabel(0.50(1)4 0.30 1 6.5,labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk.png", as(png) replace
		
*Active Transport Walking (500m Buffer)		
admetan lnor lnlci lnuci if activity==2 & Subcat == "500m" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures" "500m Buffer", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(medium)) ///
		dp(2) name(forest_AT_walking_500, replace) xlabel(0.50(1)2.0 1 2.0, labsize(medsmall))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) ysize(1.5) xsize(4)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 

*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk_500.png", as(png) replace

*Active Transport Walking (1000m Buffer)
admetan lnor lnlci lnuci if activity==2 & Subcat == "1000m" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures" "1000m Buffer", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(medium)) ///
		dp(2) name(forest_AT_walking_1000, replace) xlabel(0.50(1)2 0.5 1 2.0, labsize(medsmall))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) ysize(1.5) xsize(4)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk_1000.png", as(png) replace		
*-------------------------------------------------------------------------------		
		
**Leisure-time Physical Activity

admetan lnor lnlci lnuci if activity==3 & (walkhealth == "{bf:1.Surveillance}" | walkhealth == "{bf:2.Experience}" | walkhealth == "{bf:3.Traffic Safety}") , eform(Studies) effect(OR) ///
		forestplot( title("Leisure Time Physical Activity and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Leisure-time Physical Activity (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_LtPA_1, replace) xlabel(0.50(1)4 0.4 1 5.0, labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins activity/week # >10 mins activity/week) ysize(2.5)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 
				
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_leisure_1.png", as(png) replace

admetan lnor lnlci lnuci if activity==3 & (walkhealth == "{bf:4.Community}" | walkhealth == "{bf:5.Greenspace}" | walkhealth == "{bf:6.Density}") , eform(Studies) effect(OR) ///
		forestplot( title("Leisure Time Physical Activity and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Leisure-time Physical Activity (10/150 min per week)", span size(small)) ///
		dp(2) name(forest_LtPA_2, replace) xlabel(0.50(1)4 0.10 1 5.0, labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins activity/week # >10 mins activity/week) ysize(2.5)) ///
		study(Author) by(walkhealth) nooverall nosubgroup
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_leisure_2.png", as(png) replace

admetan lnor lnlci lnuci if activity==3 & (walkhealth == "{bf:7.Connectivity}" | walkhealth == "{bf:8.Land Use}") , eform(Studies) effect(OR) ///
		forestplot( title("Leisure Time Physical Activity and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Leisure-time Physical Activity (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_LtPA_3, replace) xlabel(0.50(1)4 0.35 1, labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins activity/week # >10 mins activity/week) ysize(2.5)) ///
		study(Author) by(walkhealth) nooverall nosubgroup
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_leisure_3.png", as(png) replace
		
*-------------------------------------------------------------------------------	

** Moderate to Vigorous Physical Activity (MVPA)

admetan lnor lnlci lnuci if activity==4 & (Estimatetype == "Odds Ratio"  | Estimatetype == "Prevalence Ratio") ///
		& (walkhealth == "{bf:1.Surveillance}" | walkhealth == "{bf:2.Experience}" | walkhealth == "{bf:3.Traffic Safety}" | walkhealth == "{bf:4.Community}" | | walkhealth == "{bf:5.Greenspace}") , eform(Studies) effect(OR) ///
		forestplot( title("MVPA and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Moderate to Vigorous Physical Activity per week)", span size(small)) ///
		dp(2) name(forest_MVPA_1, replace) xlabel(0.50(1)3 0.6 1 3.0, labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins activity/week # >10 mins activity/week) ysize(2.5)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_mvpa_1.png", as(png) replace

admetan lnor lnlci lnuci if activity==4 & (Estimatetype == "Odds Ratio"  | Estimatetype == "Prevalence Ratio") ///
		& (walkhealth == "{bf:6.Density}" | walkhealth == "{bf:7.Connectivity}" | walkhealth == "{bf:8.Land Use}") , eform(Studies) effect(OR) ///
		forestplot( title("MVPA and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Moderate to Vigorous Physical Activity per week)", span size(small)) ///
		dp(2) name(forest_MVPA_2, replace) xlabel(0.70(1)3.0  1 3.5, labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins activity/week # >10 mins activity/week) ysize(2.5)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_mvpa_2.png", as(png) replace

*-------------------------------------------------------------------------------	

gen activity_new = .
replace activity_new = 1 if activity == 1 | activity == 2
replace activity_new = 2 if activity == 3
replace activity_new = 3 if activity == 4
label var activity_new "Physical Activity Outcomes"
label define activity_new 1"Active Transport" 2"Leisure-time Physical Activity" 3"MVPA"
label value activity_new activity_new

*Contour Funnel Plot
#delimit;
confunnel lnor or_se if activity_new!=., contours(0.1 1 5 10) name(funnel, replace) 
			xlab(-2.0 -1.2 0 1.2 2.0, labsize(small)) xtitle("Odds Ratio (log scale)") 
			ylab(.8(.1)0) ytitle("Standard Error") 
			
			twowayopts(plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            bgcolor(white) )
			by(activity_new, col(3))
			legendopts(row(2))	
			note(" ")

			;
#delimit cr
gr_edit .note.draw_view.setstyle, style(no)
// note edits

gr_edit .legend.plotregion1.label[1].text = {}
gr_edit .legend.plotregion1.label[1].text.Arrpush Relationships
// label[1] edits

gr_edit .legend.plotregion1.label[2].text = {}
gr_edit .legend.plotregion1.label[2].text.Arrpush p < 0.001
// label[2] edits

gr_edit .legend.plotregion1.label[3].text = {}
gr_edit .legend.plotregion1.label[3].text.Arrpush 0.001 < p < 0.01
// label[3] edits

gr_edit .legend.plotregion1.label[4].text = {}
gr_edit .legend.plotregion1.label[4].text.Arrpush 0.01 < p < 0.05
// label[4] edits

gr_edit .legend.plotregion1.label[5].text = {}
gr_edit .legend.plotregion1.label[5].text.Arrpush 0.05 < p < 0.10
// label[5] edits

gr_edit .legend.plotregion1.label[6].text = {}
gr_edit .legend.plotregion1.label[6].text.Arrpush p > 0.10
// label[6] edits

gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy

*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/Contour_Funnel.png", as(png) replace

*Testing for publication bias (Egger Test)
**Active Transport
metabias lnor or_se if activity_new == 1, egger 
**Leisure-time Physical Activity
metabias lnor or_se if activity_new == 2, egger 
**Moderate to Vigorous Physical Activity
metabias lnor or_se if activity_new == 3, egger 
*confunnel lnor or_se, contours(0.1 1 5 10)  twowayopts(legend (order(0 1 2 3 4 5 ) lab(1 "p<0.001") lab(2 "0.001<p<0.01") lab(3 "0.01<p<0.05") lab(4 "0.05<p<0.1") lab(5 "p>0.1")))



*-------------------------------------------------------------------------------


/*
*Connected
gen connected = ""
replace connected = "Connected" if BEMeasure == "Bike path density"
replace connected = "Connected" if BEMeasure == "High Street Connectivity"
replace connected = "Connected" if BEMeasure == "High Walkability Index"
replace connected = "Connected" if BEMeasure == "High street density"
replace connected = "Connected" if BEMeasure == "Intersection density"
replace connected = "Connected" if BEMeasure == "Street connectivity"
replace connected = "Connected" if BEMeasure == "Street density"
replace connected = "Connected" if BEMeasure == "Walkability Index"
replace connected = "Connected" if BEMeasure == "Bus Stop"
replace connected = "Connected" if BEMeasure == "Bus stops"
replace connected = "Connected" if BEMeasure == "Transit Station"
replace connected = "Connected" if BEMeasure == "Public transport density"
replace connected = "Connected" if BEMeasure == "Public Transportation"

*Convenient
gen convenient = ""
replace convenient = "Convenient" if BEMeasure == "Supermarkets"
replace convenient = "Convenient" if BEMeasure == "Recreational facilities"
replace convenient = "Convenient" if BEMeasure == "Presence of public gyms"
replace convenient = "Convenient" if BEMeasure == "Land use mix"
replace convenient = "Convenient" if BEMeasure == "Land Use mix"
replace convenient = "Convenient" if BEMeasure == "Gym facilities"
replace convenient = "Convenient" if BEMeasure == "High Land use mix"
replace convenient = "Convenient" if BEMeasure == "Density of private places for PA"
replace convenient = "Convenient" if BEMeasure == "Food stores"
replace convenient = "Convenient" if BEMeasure == "High land use mix"
replace convenient = "Convenient" if BEMeasure == "Walkscore"
replace convenient = "Convenient" if BEMeasure == "Near gym "
replace convenient = "Convenient" if BEMeasure == "Near leisure and sport center"
replace convenient = "Convenient" if BEMeasure == "Proximity to gym"
replace convenient = "Convenient" if BEMeasure == "Proximity to seafront"
replace convenient = "Convenient" if BEMeasure == "Near to outdoor gym equipment"
replace convenient = "Convenient" if BEMeasure == "Near to waterfront"
replace convenient = "Convenient" if BEMeasure == "Retail Floor"
replace convenient = "Convenient" if BEMeasure == "Walkability Index"

*Comfortable
gen comfortable = ""
replace comfortable = "Comfortable" if BEMeasure == "Bike path density"
replace comfortable = "Comfortable" if BEMeasure == "Presence of bike path"
replace comfortable = "Comfortable" if BEMeasure == "walking paths"
replace comfortable= "Comfortable" if BEMeasure == "Presence of trees and gardens"
replace comfortable = "Comfortable" if BEMeasure == "Sidewalks/Trees for shading"

*Convival
gen convival = ""
replace convival = "Convival" if BEMeasure == "Presence of parks and squares"
replace convival = "Convival" if BEMeasure == "Presence of parks, spaces and facilities for physical activity"
replace convival = "Convival" if BEMeasure == "Parks"
replace convival = "Convival" if BEMeasure == "High park density"
replace convival = "Convival" if BEMeasure == "Public space (low activity)"
replace convival = "Convival" if BEMeasure == "Public space"
replace convival = "Convival" if BEMeasure == "Public space (High activity)"
replace convival = "Convival" if BEMeasure == "Presence of parks and squares"
replace convival = "Convival" if BEMeasure == "Number of public spaces"
replace convival = "Convival" if BEMeasure == "Presence of parks and squares"
replace convival = "Convival" if BEMeasure == "Presence of parks, spaces and facilities for physical activity"
replace convival = "Convival" if BEMeasure == "Proximity to squares"

*Conspicuous
gen conspicuous = ""
replace conspicuous = "Conspicuous" if BEMeasure == "Street lighting"
replace conspicuous = "Conspicuous" if BEMeasure == "Walkability Index"
replace conspicuous = "Conspicuous" if BEMeasure == "High slope"
replace conspicuous = "Conspicuous" if BEMeasure == "High Slope"

*Coexistence
gen coexistence = ""
replace coexistence = "Coexistence" if BEMeasure == "Bus Stop"
replace coexistence = "Coexistence" if BEMeasure == "Bus stops"
replace coexistence = "Coexistence" if BEMeasure == "Transit Station"
replace coexistence = "Coexistence" if BEMeasure == "Public transport density"
replace coexistence = "Coexistence" if BEMeasure == "Public Transportation"
replace coexistence = "Coexistence" if BEMeasure == "Walkability Index"

*Commitment
gen commitment = ""
replace commitment = "Commitment" if BEMeasure == "Bike path density"
replace commitment = "Commitment" if BEMeasure == "Presence of bike path"
replace commitment= "Commitment" if BEMeasure == "walking paths"
replace commitment = "Commitment" if BEMeasure == "Presence of trees and gardens"
replace commitment = "Commitment" if BEMeasure == "Sidewalks/Trees for shading"

gen seven_c = ""
replace seven_c = "Connected" if connected == "Connected"
replace seven_c = "Convenient" if convenient == "Convenient"
replace seven_c = "Comfortable" if comfortable == "Comfortable"
replace seven_c = "Convival" if convival == "Convival"
replace seven_c = "Conspicuous" if conspicuous == "Conspicuous"
replace seven_c = "Coexistence" if coexistence == "Coexistence"
replace seven_c = "Commitment" if commitment == "Commitment"

tab seven_c PA
