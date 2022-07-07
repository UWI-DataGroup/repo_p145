

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_007.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	20/01/2021
**	Date Modified: 	24/05/2022
**  Algorithm Task: Creating Equiplot for Directional Relationships


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
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

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
encode Estimatetype, gen(type)
drop if type == 1 | type == 6
replace Author = "Christiansen 2016" if Author == "christiansen 2016"
sort Author
encode BEMeasure, gen(built)
encode PhysicalActivityType, gen(activity)
encode Estimatetype, gen(estimate_type)
rename estimate or
rename lowerlimit Lower
rename upperlimit Upper

drop if or <0

gen ipen = .
replace ipen = 1 if Author == "Sallis 2016"
replace ipen = 1 if Author == "Cerin 2017"
replace ipen = 1 if Author == "Cerin 2018"
replace ipen = 1 if Author == "Christiansen 2016"
replace ipen = 1 if Author == "Schipperijn 2017"
replace ipen = 0 if ipen == .

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
replace experience = "Experience" if BEMeasure == "flat surface (experience)"
replace experience = "Experience" if BEMeasure == "Pedestrian facilities"
replace experience = "Experience" if BEMeasure == "Pedestrian facilities (experience)"
replace experience = "Experience" if BEMeasure == "pedestrian infrastructure"

*Traffic Safety
gen traffic = ""
replace traffic = "Traffic Safety" if BEMeasure == "Transit Station"
replace traffic = "Traffic Safety" if BEMeasure == "Public transport density"
replace traffic = "Traffic Safety" if BEMeasure == "Public Transportation"
replace traffic = "Traffic Safety" if BEMeasure == "Sidewalks"
replace traffic = "Traffic Safety" if BEMeasure == "walking paths"
replace traffic = "Traffic Safety" if BEMeasure == "Bus Stop"
replace traffic = "Traffic Safety" if BEMeasure == "Bus stops"
replace traffic = "Traffic Safety" if BEMeasure == "Distance to bicycle path"
replace traffic = "Traffic Safety" if BEMeasure == "Presence of bike path"
replace traffic = "Traffic Safety" if BEMeasure == "Distance to transit"
replace traffic = "Traffic Safety" if BEMeasure == "Bike paths"
replace traffic = "Traffic Safety" if BEMeasure == "Bike lanes"
replace traffic = "Traffic Safety" if BEMeasure == "Speed reducers"
replace traffic = "Traffic Safety" if BEMeasure == "School signage"
replace traffic = "Traffic Safety" if BEMeasure == "Traffic signs"
replace traffic = "Traffic Safety" if BEMeasure == "Route signage"



*Greenspace
gen greenspace = ""
replace greenspace = "Greenspace" if BEMeasure == "Presence of parks and squares"
replace greenspace = "Greenspace" if BEMeasure == "Presence of parks, spaces and facilities for physical activity"
replace greenspace = "Greenspace" if BEMeasure == "Parks"
replace greenspace = "Greenspace" if BEMeasure == "Presence of trees and gardens"
replace greenspace = "Greenspace" if BEMeasure == "High park density"
replace greenspace = "Greenspace" if BEMeasure == "Park access"
replace greenspace = "Greenspace" if BEMeasure == "Distance to parks and squares"
replace greenspace = "Greenspace" if BEMeasure == "Distance to park"

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
replace community = "Community" if BEMeasure == "Public space access"
replace community = "Community" if BEMeasure == "Distance to parks and squares"
replace community = "Community" if BEMeasure == "Park access"
replace community = "Community" if BEMeasure == "Distance to park"

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
replace land_use = "Land Use" if BEMeasure == "Distance to center"
replace land_use = "Land Use" if BEMeasure == "land use mix"
replace land_use = "Land Use" if BEMeasure == "Sports and leisure centers"
replace land_use = "Land Use" if BEMeasure == "Distance to school"
replace land_use = "Land Use" if BEMeasure == "Distance to utiliarian destinations"
replace land_use = "Land Use" if BEMeasure == "Distance to recreational facilities"
replace land_use = "Land Use" if BEMeasure == "Distance to nearest transit station"

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
replace connectivity = "Connectivity" if BEMeasure == "Block density"
replace connectivity = "Connectivity" if BEMeasure == "Connectivity between streets"
replace connectivity = "Connectivity" if BEMeasure == "Average size of blocks"
replace connectivity = "Connectivity" if BEMeasure == "Average block length"
replace connectivity = "Connectivity" if BEMeasure == "Block area"
replace connectivity = "Connectivity" if BEMeasure == "Bike path length"
replace connectivity = "Connectivity" if BEMeasure == "Length of footpath"


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

replace Author = "Hino 2013 (Population Density)" if activity == 1 & BEMeasure=="High Population Density" & Author == "Hino 2013" 

replace Author = "Hino 2013 (Residential Density)" if activity == 1 & BEMeasure=="High residential area proportion" & Author == "Hino 2013" 

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

replace Author = "Hino 2019 (Outcome- Walking >10 min/week; Buffer: 500m; Public Spaces)" in 137
replace Author = "Hino 2019 (Outcome- Walking >10 min/week; Buffer: 1000m; Public Spaces)" in 138
replace Author = "Hino 2019 (Outcome- Walking >150 min/week; Buffer: 1000m; Public Spaces)" in 139
replace Author = "Hino 2019 (Outcome- Walking >150 min/week; Buffer: 500m; Public Spaces)" in 140

replace Author = "Gomez 2010b" if Author == "Gomez 2010"

replace Author = "Gomez 2010a (Outcome- Walking >150 min/week; BE- Slope)" if BEMeasure == "High slope" & Author == "Gomez 2010a" & or == 0.8

replace Author = "Gomez 2010a (Outcome- Walking >60 min/week; BE- Slope)" if BEMeasure == "High slope" & Author == "Gomez 2010a" & or == 0.61


replace Author = "Gomez 2010a (Outcome- Walking >150 min/week; BE- Transit Stops)" if BEMeasure == "Transit Station" & Author == "Gomez 2010a" & or == 0.78

replace Author = "Gomez 2010a (Outcome- Walking >60 min/week; BE- Transit Stops)" if BEMeasure == "Transit Station" & Author == "Gomez 2010a" & or == 0.75

replace Author = "Gomez 2010a (Outcome- Walking >150 min/week; BE- Parks)" if BEMeasure == "High park density" & Author == "Gomez 2010a" & or == 0.95

replace Author = "Gomez 2010a (Outcome- Walking >60 min/week; BE- Parks)" if BEMeasure == "High park density" & Author == "Gomez 2010a" & or == 1.06

replace Author = "Gomez 2010a (Outcome- Walking >150 min/week; BE- Connectivity)" if BEMeasure == "High Street Connectivity" & Author == "Gomez 2010a" & or == 0.90

replace Author = "Gomez 2010a (Outcome- Walking >60 min/week; BE- Connectivity)" if BEMeasure == "High Street Connectivity" & Author == "Gomez 2010a" & or == 0.64


replace Author = "Borchardt 2019 (Transit Stops)" if Author == "Borchardt 2019" & or == 1.02

replace Author = "Borchardt 2019 (Sidewalks)" if Author == "Borchardt 2019" & or == 0.94
replace Author = "Borchardt 2019 (Sidewalks)" if Author == "Borchardt 2019" & or == 1.03

replace Author = "Borchardt 2019 (Public gym)" if Author == "Borchardt 2019" & or == 0.99 & activity==4
replace Author = "Borchardt 2019 (Proximity to seafront)" if Author == "Borchardt 2019" & or == 1.16 & activity==4

replace Author = "Borchardt 2019 (Public gyms)" if Author == "Borchardt 2019" & or == 0.95
replace Author = "Borchardt 2019 (Proximity to seafront)" if Author == "Borchardt 2019" & or == 1.41

replace Author = "Da Silva 2017 (Walking paths/trails)" if Author == "Da Silva 2017" & activity == 3 & or == 1.00

replace Author = "Da Silva 2017 (Sidewalks)" if Author == "Da Silva 2017" & activity == 3 & or == 1.01

replace Author = "Andrade 2019 (Presence of trees and gardens)" if BEMeasure == "Presence of trees and gardens" & Author == "Andrade 2019"

replace Author = "Andrade 2019 (Parks)" if BEMeasure == "Presence of parks, spaces and facilities for physical activity" & Author == "Andrade 2019"


replace Author = "Schipperijn 2017 (parks within 500m buffer)" if Author == "Schipperijn 2017" & or == 1.04

replace Author = "Schipperijn 2017 (parks within 1 km buffer)" if Author == "Schipperijn 2017" & or == 1.027

replace Author = "Hino 2011 (Land Use Mix)" if Author == "Hino 2011" & or == 1.89

replace Author = "Lee 2016 (Land use)" if Author == "Lee 2016" & or == 0.89
replace Author = "Lee 2016 (Recreational facilities)" if Author == "Lee 2016" & or == 1.04


replace Author = "Cerin 2017 (500m buffer; BE- Transit Stop)" if Author == "Cerin 2017" & or == 1.063
replace Author = "Cerin 2017 (1 km buffer; BE- Transit Stop)" if Author == "Cerin 2017" & or == 1.105

replace Author = "Cerin 2017 (500m buffer; BE- Residential Density)" if Author == "Cerin 2017" & or == 1.005
replace Author = "Cerin 2017 (1 km buffer; BE- Residential Density)" if Author == "Cerin 2017" & or == 1.006

replace Author = "Cerin 2017 (500m buffer; BE- Intersection Density)" if Author == "Cerin 2017" & or == 1.055
replace Author = "Cerin 2017 (1 km buffer; BE- Intersection Density)" if Author == "Cerin 2017" & or == 1.314

replace Author = "Cerin 2017 (500m buffer; BE- Parks)" if Author == "Cerin 2017" & or == 1.057
replace Author = "Cerin 2017 (1 km buffer; BE- Parks)" if Author == "Cerin 2017" & or == 1.03

replace Author = "Cerin 2017 (500m buffer; BE- Land Use Mix)" if Author == "Cerin 2017" & or == 1.971
replace Author = "Cerin 2017 (1 km buffer; BE- Land Use Mix)" if Author == "Cerin 2017" & or == 2.06

replace Author = "Cerin 2017 (500m buffer; BE- Retail Floor)" if Author == "Cerin 2017" & or == 2.235
replace Author = "Cerin 2017 (1 km buffer; BE- Retail Floor)" if Author == "Cerin 2017" & or == 1.713

replace Author = "Cerin 2018 (Land Use Mix)" if Author == "Cerin 2018" & or == 0.999
replace Author = "Cerin 2018 (Retail Floor)" if Author == "Cerin 2018" & or == 1.008

replace Author = "Schipperijn 2017 (parks within 500m buffer)" if Author == "Schipperijn 2017" & or == 1.007
replace Author = "Schipperijn 2017 (parks within 1 km buffer)" if Author == "Schipperijn 2017" & or == 1.016

replace Author = "Da Silva 2017 (Middle SES: Street lighting)" if Author == "Da Silva 2017" & or == 1.22
replace Author = "Da Silva 2017 (Middle SES: Population Density)" if Author == "Da Silva 2017" & or == 1.13
replace Author = "Da Silva 2017 (Middle SES: Sidewalks)" if Author == "Da Silva 2017" & or == 1.01
replace Author = "Da Silva 2017 (Middle SES: Presence of Trees)" if Author == "Da Silva 2017" & or == 1.19
replace Author = "Da Silva 2017 (Middle SES: Street Connectivity)" if Author == "Da Silva 2017" & or == 1.14
replace Author = "Da Silva 2017 (Middle SES: Public Space)" if Author == "Da Silva 2017" & or == 0.98
replace Author = "Da Silva 2017 (Middle SES: Walking paths)" if Author == "Da Silva 2017" & or == 1.07
replace Author = "Da Silva 2017 (Middle SES: Proximity to seafront)" if Author == "Da Silva 2017" & or == 0.46


replace Author = "Florindo 2019 (Transit stops within 1 km buffer)" if Author == "Florindo 2019" & or == 1.31
replace Author = "Florindo 2019 (Transit stops within 500m buffer)" if Author == "Florindo 2019" & or == 0.93
replace Author = "Florindo 2019 (Parks within 1 km buffer)" if Author == "Florindo 2019 (Parks)" & or == 0.74
replace Author = "Florindo 2019 (Parks within 500m buffer)" if Author == "Florindo 2019 (Parks)" & or == 0.82
replace Author = "Florindo 2019 (Food stores 1 km buffer)" if Author == "Florindo 2019 (Food Stores)" & or == 1.24
replace Author = "Florindo 2019 (Food stores within 500m buffer)" if Author == "Florindo 2019 (Food Stores)" & or == 0.95
replace Author = "Florindo 2019 (Supermarkets within 1 km buffer)" if Author == "Florindo 2019 (Supermarkets)" & or == 1.03
replace Author = "Florindo 2019 (Supermarkets within 500m buffer)" if Author == "Florindo 2019 (Supermarkets)" & or == 0.93
replace Author = "Florindo 2019 (Land use mix within 1 km buffer)" if Author == "Florindo 2019" & or == 0.90
replace Author = "Florindo 2019 (Land use mix within 500m buffer)" if Author == "Florindo 2019" & or == 1.21
replace Author = "Florindo 2019 (Public space within 1 km buffer)" if Author == "Florindo 2019 (Public Open Space)" & or == 0.95
replace Author = "Florindo 2019 (Public space within 500m buffer)" if Author == "Florindo 2019 (Public Open Space)" & or == 0.85


replace Author = "Christiansen 2016 (Residential Density within 1 km buffer)" if Author == "Christiansen 2016" & or == 1.03
replace Author = "Christiansen 2016 (Intersection Density within 1 km buffer)" if Author == "Christiansen 2016" & or == 1.35
replace Author = "Christiansen 2016 (Land Use Mix within 1 km buffer)" if Author == "Christiansen 2016" & or == 1.29
replace Author = "Christiansen 2016 (Parks within 1 km buffer)" if Author == "Christiansen 2016" & Lower == 0.98


replace Author = "Christiansen 2016 (Residential Density within 500m buffer)" if Author == "Christiansen 2016" & or == 1.01
replace Author = "Christiansen 2016 (Intersection Density within 500m buffer)" if Author == "Christiansen 2016" & or == 1.26
replace Author = "Christiansen 2016 (Land Use Mix within 500m buffer)" if Author == "Christiansen 2016" & or == 1.32
replace Author = "Christiansen 2016 (Parks within 500m buffer)" if Author == "Christiansen 2016" & Lower == 0.96
gsort -lnor 


*Encode Walkability Categories
encode walkhealth, gen(walkhealth_cat)

gen walkhealth_graph = .

replace walkhealth_graph =  12 if PA == "1.Leisure-time PA" & walkhealth_cat == 1
replace walkhealth_graph =  13 if PA == "1.Leisure-time PA" & walkhealth_cat == 2
replace walkhealth_graph =  14 if PA == "1.Leisure-time PA" & walkhealth_cat == 3
replace walkhealth_graph =  15 if PA == "1.Leisure-time PA" & walkhealth_cat == 4
replace walkhealth_graph =  16 if PA == "1.Leisure-time PA" & walkhealth_cat == 5
replace walkhealth_graph =  17 if PA == "1.Leisure-time PA" & walkhealth_cat == 6
replace walkhealth_graph =  18 if PA == "1.Leisure-time PA" & walkhealth_cat == 7
replace walkhealth_graph =  19 if PA == "1.Leisure-time PA" & walkhealth_cat == 8


replace walkhealth_graph =  22 if PA == "2.MVPA" & walkhealth_cat == 1
replace walkhealth_graph =  23 if PA == "2.MVPA" & walkhealth_cat == 2
replace walkhealth_graph =  24 if PA == "2.MVPA" & walkhealth_cat == 3
replace walkhealth_graph =  25 if PA == "2.MVPA" & walkhealth_cat == 4
replace walkhealth_graph =  26 if PA == "2.MVPA" & walkhealth_cat == 5
replace walkhealth_graph =  27 if PA == "2.MVPA" & walkhealth_cat == 6
replace walkhealth_graph =  28 if PA == "2.MVPA" & walkhealth_cat == 7
replace walkhealth_graph =  29 if PA == "2.MVPA" & walkhealth_cat == 8


replace walkhealth_graph =  2 if PA == "3.Active Transport" & walkhealth_cat == 1
replace walkhealth_graph =  3 if PA == "3.Active Transport" & walkhealth_cat == 2
replace walkhealth_graph =  4 if PA == "3.Active Transport" & walkhealth_cat == 3
replace walkhealth_graph =  5 if PA == "3.Active Transport" & walkhealth_cat == 4
replace walkhealth_graph =  6 if PA == "3.Active Transport" & walkhealth_cat == 5
replace walkhealth_graph =  7 if PA == "3.Active Transport" & walkhealth_cat == 6
replace walkhealth_graph =  8 if PA == "3.Active Transport" & walkhealth_cat == 7
replace walkhealth_graph =  9 if PA == "3.Active Transport" & walkhealth_cat == 8


label var walkhealth_graph "Walkability for Helath Domains"

label define walkhealth_graph 2"Surveillance" 3"Experience" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density" 8"Connectivity" 9"Land Use" 12"Surveillance" 13"Experience" 14"Traffic Safety" 15"Community" 16"Greenspace" 17"Density" 18"Connectivity" 19"Land Use" 22"Surveillance" 23"Experience" 24"Traffic Safety" 25"Community" 26"Greenspace" 27"Density" 28"Connectivity" 29"Land Use" 

label value walkhealth_graph walkhealth_graph

tab walkhealth_graph
tab walkhealth_graph, nolabel

unique walkhealth_graph

*Note: 10 18 missing

gen ln_or = ln(or)

gen zero = 0

by walkhealth_graph, sort : egen float min_or = min(ln_or)
by walkhealth_graph, sort : egen float max_or = max(ln_or)

	#delimit;
	graph twoway
		(rspike min_or max_or walkhealth_graph, hor lcolor(gs4) lwidth(0.01))
		(sc walkhealth_graph ln_or if or<=1, msize(2) msymbol(o) mlc(gs0) mfc("222 203 228 %10") mlw(0.1) ) 
		(sc walkhealth_graph ln_or if or>1 , msize(2) msymbol(o) mlc(gs0) mfc("222 203 228 %10") mlw(0.1) )	
		(sc walkhealth_graph min_or,  msize(2) msymbol(o) mlc(gs0) mfc("222 203 228") mlw(0.1) )
		(sc walkhealth_graph max_or,  msize(2) msymbol(o) mlc(gs0) mfc("222 203 228") mlw(0.1) )
				
		(line walkhealth_graph zero if PA=="3.Active Transport", lcolor(gs9))
		(line walkhealth_graph zero if PA=="2.MVPA", lcolor(gs9))
		(line walkhealth_graph zero if PA=="1.Leisure-time PA", lcolor(gs9))
		, 
		

			ytitle("{bf:Built Environment Domains (Increased presence and proximity)}", size(3) ) 
			yscale(reverse)
			
			ylab(2"Surveillance" 3"Experience" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density"
				 8"Connectivity" 9"Land Use" 10" " 11" " 12"Surveillance" 13"Experience" 14"Traffic Safety" 15"Community" 16"Greenspace" 17"Density"
				 18"Connectivity" 19"Land Use" 20" " 21" " 22"Surveillance" 23"Experience" 24"Traffic Safety" 25"Community" 26"Greenspace" 27"Density"
				 28"Connectivity" 29"Land Use" 
			,
			angle(0) nogrid notick glc(gs16) labsize(3))
			
			
			xscale(fill titlegap(5))

			xtitle("{bf:Physical Activity}", size(3) margin(2-pt)  )
			
			xlab(0"1" 2.2"{bf:More}"  -2"{bf:Less}" -1.2039728"0.3" -.51082562"0.6" .69314718"2.0" 1.3862944"4.0"
			,
			angle(0) nogrid glc(gs16) labsize(3) noticks )
			
				
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 

			ysize(10)
			
			legend(off)

             
			text(0.3 2.10 "Number of", size(small))
			text(0.8 2.00 "Relationships", size(small))
			text(12 2.35 "1|2", size(small))
			text(13 2.35 "2|3", size(small))
			text(14 2.35 "14|8", size(small))
			text(15 2.35 "4|3", size(small))
			text(16 2.35 "5|4", size(small))
			text(17 2.35 "2|11", size(small))
			text(18 2.35 "8|12", size(small))
			text(19 2.35 "13|14", size(small))
			
			text(2 2.35 "1|2", size(small))
			text(3 2.35 "4|3", size(small))
			text(4 2.35 "5|5", size(small))
			text(5 2.35 "2|8", size(small))
			text(6 2.35 "3|11", size(small))
			text(7 2.35 "3|3", size(small))
			text(8 2.35 "6|5", size(small))
			text(9 2.35 "4|10", size(small))
			
			text(22 2.35 "1|0", size(small))
			text(23 2.35 "0|2", size(small))
			text(24 2.35 "0|6", size(small))
			text(25 2.35 "2|2", size(small))
			text(26 2.35 "1|6", size(small))
			text(27 2.35 "1|3", size(small))
			text(28 2.35 "1|4", size(small))
			text(29 2.35 "2|8", size(small))
			
			text(1.27 0.43 "{bf:Active Transport}", size(small))
			text(11 0.40 "{bf:Leisure-time PA}", size(small))
			text(21 0.18 "{bf:MVPA}", size(small))
			
			name(new_graph_1, replace)
			text(1.3 2.35 "(-|+)", size(small))
			text(30.3 2.20 "{bf:Activity}", size(small))
			text(30.3 -2.0 "{bf:Activity}", size(small))
			
			
			title(" ")
		;
		#delimit cr

/*

	#delimit;
	graph twoway
		(sc walkhealth_graph ln_or if or<=1, msize(2) msymbol(o) mlc(gs0) mfc(gs15) mlw(0.1) ) 
		(sc walkhealth_graph ln_or if or>1 , msize(2) msymbol(o) mlc(gs0) mfc("222 203 228") mlw(0.1) )	
		

		
		(rspike min_or max_or walkhealth_graph if ipen!=1, hor lcolor(gs4) lwidth(0.01))
		, 
		
		xline(0, lcolor(black))
		
		
	
			ytitle("{bf:Walkability for Health Framework Domains}", size(3) ) 
			yscale(reverse)
			
			ylab(2"Surveillance" 3"Experience" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density"
				 8"Connectivity" 9"Land Use" 10" " 11" " 12"Surveillance" 13"Experience" 14"Traffic Safety" 15"Community" 16"Greenspace" 17"Density"
				 18"Connectivity" 19"Land Use" 20" " 21" " 22"Surveillance" 23"Experience" 24"Traffic Safety" 25"Community" 26"Greenspace" 27"Density"
				 28"Connectivity" 29"Land Use" 
			,
			angle(0) nogrid notick glc(gs16) labsize(3))
			
			
			xscale(fill)
			xlab("0", labs(2.5) nogrid glc(gs16))
			xtitle("{bf:Physical Activity}", size(3) margin(2-pt)  )
			
			xlab(1.2"Increase" 1.3" " -1"Decrease" 0"No change"
			,
			angle(0) nogrid glc(gs16) labsize(3))
			
				
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 
            ysize(12) xsize(28)
			
			
			legend(size(3) position(11) ring(10) bm(t=0 b=0 l=0 r=0) colf cols(2)
            region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0)) 
            order(1 2) 
            lab(1 "Negative/Null") lab(2 "Positive")  
			title("{bf:Relationships}", color(black) size(small))
                )
			
			text(0.4 1.23 "Ratio" "Negative/Postive", size(small))
			text(12 1.23 "1/2", size(small))
			text(13 1.23 "4/1", size(small))
			text(14 1.23 "5/4", size(small))
			text(15 1.23 "1/7", size(small))
			text(16 1.23 "2/9", size(small))
			text(17 1.23 "2/3", size(small))
			text(18 1.23 "5/2", size(small))
			text(19 1.23 "4/10", size(small))
			
			text(2 1.23 "1/2", size(small))
			text(3 1.23 "0/0", size(small))
			text(4 1.23 "6/5", size(small))
			text(5 1.23 "4/1", size(small))
			text(6 1.23 "4/4", size(small))
			text(7 1.23 "1/8", size(small))
			text(8 1.23 "3/7", size(small))
			text(9 1.23 "6/9", size(small))
			
			text(22 1.23 "1/0", size(small))
			text(23 1.23 "0/0", size(small))
			text(24 1.23 "0/6", size(small))
			text(25 1.23 "0/2", size(small))
			text(26 1.23 "1/6", size(small))
			text(27 1.23 "1/3", size(small))
			text(28 1.23 "1/4", size(small))
			text(29 1.23 "2/7", size(small))
			
			text(1 0.23 "{bf:Active Transport}", size(small))
			text(11 0.22 "{bf:Leisure-time PA}", size(small))
			text(21 0.1 "{bf:MVPA}", size(small))
			
			name(new_graph_1, replace)
			
		;
		#delimit cr
		
*-------------------------------------------------------------------------------
/*
gen count = 1
gen direction = .
replace direction = 1 if or<=1 // Negativ/Null
replace direction = 2 if or>1 // Positive
label var direction "Direction of Relationships"
label define direction 1"Negativ/Null" 2"Positive"
label value direction direction

collapse (sum) count, by(walkhealth_cat direction PA)
cls
*Negative
list walkhealth_cat count if direction ==1 & PA== "2.MVPA"
*Positive		
list walkhealth_cat count if direction ==2 & PA== "2.MVPA"	


		
		
			#delimit;
	graph twoway
		(rspike min_or max_or walkhealth_graph, hor lcolor(gs4) lwidth(0.01))
		(sc walkhealth_graph ln_or if or<=1, msize(2) msymbol(o) mlc(gs0) mfc(gs15) mlw(0.1) ) 
		(sc walkhealth_graph ln_or if or>1 , msize(2) msymbol(o) mlc(gs0) mfc(gs15) mlw(0.1) )	
		(sc walkhealth_graph min_or,  msize(2) msymbol(o) mlc(gs0) mfc("222 203 228") mlw(0.1) )
		(sc walkhealth_graph max_or,  msize(2) msymbol(o) mlc(gs0) mfc("222 203 228") mlw(0.1) )
		

		, 
		
		xline(0, lcolor(gs10))
		
		
	
			ytitle("{bf:Walkability for Health Framework Domains}", size(3) ) 
			yscale(reverse)
			
			ylab(2"Surveillance" 3"Experience" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density"
				 8"Connectivity" 9"Land Use" 10" " 11" " 12"Surveillance" 13"Experience" 14"Traffic Safety" 15"Community" 16"Greenspace" 17"Density"
				 18"Connectivity" 19"Land Use" 20" " 21" " 22"Surveillance" 23"Experience" 24"Traffic Safety" 25"Community" 26"Greenspace" 27"Density"
				 28"Connectivity" 29"Land Use" 
			,
			angle(0) nogrid notick glc(gs16) labsize(3))
			
			
			xscale(fill)
			xlab("0", labs(2.5) nogrid glc(gs16))
			xtitle("{bf:Physical Activity}", size(3) margin(2-pt)  )
			
			xlab(1.2"Increase" 1.3" " -1"Decrease" 0"No change"
			,
			angle(0) nogrid glc(gs16) labsize(3))
			
				
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 
            ysize(50) xsize(28)
			
			legend(off)

             
			
			text(0.4 1.23 "Ratio" "Negative/Postive", size(small))
			text(12 1.23 "1/2", size(small))
			text(13 1.23 "4/1", size(small))
			text(14 1.23 "5/4", size(small))
			text(15 1.23 "1/7", size(small))
			text(16 1.23 "2/9", size(small))
			text(17 1.23 "2/3", size(small))
			text(18 1.23 "5/2", size(small))
			text(19 1.23 "4/10", size(small))
			
			text(2 1.23 "1/2", size(small))
			text(3 1.23 "0/0", size(small))
			text(4 1.23 "6/5", size(small))
			text(5 1.23 "4/1", size(small))
			text(6 1.23 "4/4", size(small))
			text(7 1.23 "1/8", size(small))
			text(8 1.23 "3/7", size(small))
			text(9 1.23 "6/9", size(small))
			
			text(22 1.23 "1/0", size(small))
			text(23 1.23 "0/0", size(small))
			text(24 1.23 "0/6", size(small))
			text(25 1.23 "0/2", size(small))
			text(26 1.23 "1/6", size(small))
			text(27 1.23 "1/3", size(small))
			text(28 1.23 "1/4", size(small))
			text(29 1.23 "2/7", size(small))
			
			text(1.27 0.43 "{bf:Active Transport}", size(small))
			text(11 0.40 "{bf:Leisure-time PA}", size(small))
			text(21 0.18 "{bf:MVPA}", size(small))
			
			name(new_graph_1, replace)
			
		;
		#delimit cr
		
		
		

*NEW GRAPH

	
	#delimit;
	graph twoway
		(rspike min_or max_or walkhealth_graph, hor lcolor(gs4) lwidth(0.01))
		(sc walkhealth_graph ln_or if or<=1, msize(2) msymbol(o) mlc(gs0) mfc("222 203 228 %10") mlw(0.1) ) 
		(sc walkhealth_graph ln_or if or>1 , msize(2) msymbol(o) mlc(gs0) mfc("222 203 228 %10") mlw(0.1) )	
		(sc walkhealth_graph min_or,  msize(2) msymbol(o) mlc(gs0) mfc("222 203 228") mlw(0.1) )
		(sc walkhealth_graph max_or,  msize(2) msymbol(o) mlc(gs0) mfc("222 203 228") mlw(0.1) )
				
		(line walkhealth_graph zero if PA=="3.Active Transport", lcolor(gs9))
		(line walkhealth_graph zero if PA=="2.MVPA", lcolor(gs9))
		(line walkhealth_graph zero if PA=="1.Leisure-time PA", lcolor(gs9))
		, 
		

			ytitle("{bf:Built Environment Domains (Increased presence and proximity)}", size(3) ) 
			yscale(reverse)
			
			ylab(2"Surveillance" 3"Experience" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density"
				 8"Connectivity" 9"Land Use" 10" " 11" " 12"Surveillance" 13"Experience" 14"Traffic Safety" 15"Community" 16"Greenspace" 17"Density"
				 18"Connectivity" 19"Land Use" 20" " 21" " 22"Surveillance" 23"Experience" 24"Traffic Safety" 25"Community" 26"Greenspace" 27"Density"
				 28"Connectivity" 29"Land Use" 
			,
			angle(0) nogrid notick glc(gs16) labsize(3))
			
			
			xscale(fill titlegap(5))

			xtitle("{bf:Physical Activity}", size(3) margin(2-pt)  )
			
			xlab(0"1" 1.2"{bf:More}"  -1"{bf:Less}" -.69314718"0.5" -.22314355"0.8" .40546511"1.5" .69314718"2.0"
			,
			angle(0) nogrid glc(gs16) labsize(3) noticks )
			
				
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 
            ysize(60) xsize(38)
			
			legend(off)

             
			text(0 1.10 "Number of", size(small))
			text(0.5 1.10 "Relationships", size(small))
			text(12 1.23 "1|2", size(small))
			text(13 1.23 "4|1", size(small))
			text(14 1.23 "5|4", size(small))
			text(15 1.23 "1|7", size(small))
			text(16 1.23 "2|9", size(small))
			text(17 1.23 "2|3", size(small))
			text(18 1.23 "5|2", size(small))
			text(19 1.23 "4|10", size(small))
			
			text(2 1.23 "1|2", size(small))
			text(3 1.23 "0|0", size(small))
			text(4 1.23 "6|5", size(small))
			text(5 1.23 "4|1", size(small))
			text(6 1.23 "4|4", size(small))
			text(7 1.23 "1|8", size(small))
			text(8 1.23 "3|7", size(small))
			text(9 1.23 "6|9", size(small))
			
			text(22 1.23 "1|0", size(small))
			text(23 1.23 "0|0", size(small))
			text(24 1.23 "0|6", size(small))
			text(25 1.23 "0|2", size(small))
			text(26 1.23 "1|6", size(small))
			text(27 1.23 "1|3", size(small))
			text(28 1.23 "1|4", size(small))
			text(29 1.23 "2|7", size(small))
			
			text(1.27 0.43 "{bf:Active Transport}", size(small))
			text(11 0.40 "{bf:Leisure-time PA}", size(small))
			text(21 0.18 "{bf:MVPA}", size(small))
			
			name(new_graph_1, replace)
			text(1.2 1.23 "(-|+)", size(small))
			text(30.6 1.20 "{bf:Activity}", size(small))
			text(30.6 -1.0 "{bf:Activity}", size(small))
			
			
			title(" ")
		;
		#delimit cr
		
		
		
		/*
		