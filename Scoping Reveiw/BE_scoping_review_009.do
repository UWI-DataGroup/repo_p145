

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_009.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	01/07/2022
**	Date Modified: 	01/07/2022
**  Algorithm Task: Creating Evidence Gap Matrix


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
*log using "`logpath'/version01/3-output/Scoping Review/SR_PA_005.log",  replace


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
*drop if type == 1 | type == 6
replace Author = "Christiansen 2016" if Author == "christiansen 2016"
sort Author
encode BEMeasure, gen(built)
encode PhysicalActivityType, gen(activity)
encode Estimatetype, gen(estimate_type)
rename estimate or
rename lowerlimit Lower
rename upperlimit Upper

*drop if or <0

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


*Creating Evidence Gap Map Matrix
*Counting the number of relationships and collapsing by activity and BE domain
gen count = 1
collapse (sum) count, by(walkhealth activity)
*Create coded PA variable. 
gen PA = .
replace PA = 1 if activity == 1 | activity ==2
replace PA = 2 if activity == 3 
replace PA = 3 if activity == 4 | activity ==5
label var PA "Physical Activity"
label define PA 1"Active Transport" 2"Leisure-time PA" 3"MVPA"
label value PA PA
*Convert string to coded categories
encode walkhealth, gen(walk_health)
*Recode to include parking for mapping purposes
recode walk_health (3=4) (4=5) (5=6) (6=7) (7=8) (8=9)

*Including domains with zero relationships
fillin walk_health PA
set obs 33
replace PA = 1 in 31
replace PA = 2 in 32
replace PA = 3 in 33
replace count = 0 if count == .
replace walk_health = 3 if walk_health==.

*Minot adjustment for mapping purposes
replace PA = 1.2 if PA==1
replace PA = 1 if PA ==1.2
replace PA = 2.85 if PA>2


#delimit;
	graph twoway
			(scatter walk_health PA if count==0, mfc("215 48 39") mlc(gs0) msize(7))
			(scatter walk_health PA if count>0 & count<=3, mfc("252 141 89") mlc(gs0) msize(7))
			(scatter walk_health PA if count>=4 & count<=5, mfc("254 224 139") mlc(gs0) msize(7))
			(scatter walk_health PA if count>=6 & count<=8, mfc("217 239 139") mlc(gs0) msize(7))
			(scatter walk_health PA if count>=9 & count<=10, mfc("145 207 96") mlc(gs0) msize(7))
			(scatter walk_health PA if count>10 , mfc("26 152 80") mlc(gs0) msize(7))
				,		
			ylab(1"Surveillance" 2"Experience" 3"Parking" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density"
				 8"Connectivity" 9"Land Use" 0.751" " 9.5" "
			,
			angle(0) nogrid notick glc(gs16) labsize(3))
			yscale(reverse)
			xscale(fill)
			xscale(alt)
			xlab(1"Active" 1.2"            Transport" 2.05"Leisure-time PA" 2.85"MVPA" 3.2" ", labs(3) nogrid notick glc(gs16))
			xtitle("{bf:Physical Activity Outcome}", size(3) )

			yline(0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.73,  lcolor(gs8) )
			xline(1.6 2.45 3.28 ,  lcolor(gs8) )
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 
			
			legend(size(3) position(3) ring(10) bm(t=0 b=0 l=4 r=0) colf cols(1)
            region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0)) 
            order(1 2 3 4 5 6) 
            lab(1 "0") lab(2 "1-3") lab(3 "4-5")  lab(4 "6-8") lab(5 "9-10") lab(6 ">10") 
			title("{bf:Number of}" "{bf:Relationships}", color(black) size(small))
                )
				
			xsize(5)
					;
		#delimit cr
		
