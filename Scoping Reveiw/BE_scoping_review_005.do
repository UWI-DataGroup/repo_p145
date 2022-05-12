
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_005.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	20/01/2021
**	Date Modified: 	10/02/2022
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
*-------------------------------------------------------------------------------				
*Active Transport Walking (No Buffer)
admetan lnor lnlci lnuci if activity==2 & Subcat == "" | Subcat == "High SES" | Subcat == "Low SES" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking, replace) xlabel(0.50(1)4 0.30 1 6.5,labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) ysize(30) xsize(50)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk.png", as(png) replace

*-------------------------------------------------------------------------------
*Active Transport - Surveillance; Experience; Traffic Safety; Community
admetan lnor lnlci lnuci if activity==2 & (walkhealth == "{bf:1.Surveillance}" | walkhealth == "{bf:2.Experience}" | walkhealth == "{bf:3.Traffic Safety}" | walkhealth == "{bf:4.Community}"), eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking_1, replace) xlabel(0.50(1)2 0.50 1 2.0,labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) xsize(11)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 

*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk_v1.png", as(png) replace		
*-------------------------------------------------------------------------------		
*Active Transport - Greenspace; Density; Connectivity
admetan lnor lnlci lnuci if activity==2 & (walkhealth == "{bf:5.Greenspace}" | walkhealth == "{bf:6.Density}" | walkhealth == "{bf:7.Connectivity}"), eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking_2, replace) xlabel(0.5(1)4  0.12 1 6.5,labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) xsize(8)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 

*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk_v2.png", as(png) replace
*-------------------------------------------------------------------------------		
*Active Transport - Land Use
admetan lnor lnlci lnuci if activity==2 & (walkhealth == "{bf:8.Land Use}"), eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking_3, replace) xlabel(0.5(1)4  0.12 1 6.5,labsize(small))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) ysize(10) xsize(30)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 
		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk_v3.png", as(png) replace
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------				
*Active Transport Walking (500m Buffer)		
admetan lnor lnlci lnuci if activity==2 & Subcat == "500m" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures" "500m Buffer", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(medium)) ///
		dp(2) name(forest_AT_walking_500, replace) xlabel(0.50(1)2.0 1 2.0, labsize(medsmall))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) ysize(1.0) xsize(3)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 

*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk_500.png", as(png) replace
*-------------------------------------------------------------------------------		
*Active Transport Walking (1000m Buffer)
admetan lnor lnlci lnuci if activity==2 & Subcat == "1000m" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures" "1000m Buffer", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(medium)) ///
		dp(2) name(forest_AT_walking_1000, replace) xlabel(0.50(1)2 0.5 1 2.0, labsize(medsmall))  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white) ///
		favours(<10 mins walking commute/week # >10 mins walking comute/week) ysize(1.5) xsize(5)) ///
		study(Author) by(walkhealth) nooverall nosubgroup 		
*Export graph
graph export "`outputpath'/version01/3-output/Scoping Review/active_forest_walk_1000.png", as(png) replace		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		
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
		favours(<10 mins activity/week # >10 mins activity/week) ysize(25) xsize(100)) ///
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
		favours(<10 mins activity/week # >10 mins activity/week) ysize(25) xsize(100)) ///
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

#delimit;
confunnel lnor or_se if ipen!=1, contours(0.1 1 5 10) name(funnel, replace) 
			xlab(-2.0 -1.2 0 1.2 2.0, labsize(small)) xtitle("Odds Ratio (log scale)") 
			ylab(.8(.1)0) ytitle("Standard Error") 
			
			twowayopts(plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            bgcolor(white) )
			
			legendopts(row(2))	
			legend(order(10 "Relationships" 1 "p < 0.001" 2 "0.001 < p < 0.01"
						 5 "0.01 < p < 0.05" 6 "0.05 < p < 0.10" 0 "p > 0.10")
						 row(2))
			note(" ")

			;
#delimit cr


*-------------------------------------------------------------------------------


*Encode Walkability Categories
encode walkhealth, gen(walkhealth_cat)

*-------------------------------------------------------------------------------
*Active Communting	
	#delimit;
	graph twoway
		(sc walkhealth_cat or if or<=1 & activity==1 & ipen!=1, msize(3) msymbol(smcircle_hollow) mlc(gs0) mlw(0.1) ) 
		(sc walkhealth_cat or if or<=1 & activity==2 & ipen!=1, msize(3) msymbol(smcircle_hollow) mlc(gs0) mlw(0.1) ) 
		
		(sc walkhealth_cat or if or>1 & activity==1 & ipen!=1, msize(3) msymbol(smcircle) mlc(gs0) mfc("84 39 143") mlw(0.1) )
		(sc walkhealth_cat or if or>1 & activity==2 & ipen!=1, msize(3) msymbol(smcircle) mlc(gs0) mfc("84 39 143") mlw(0.1) )
		
		, xline(1, lcolor(black))
		
				ylab(1"Surveillance" 2"Experience" 3"Traffic Safety" 4"Community" 5"Greenspace" 6"Density"
				 7"Connectivity" 8"Land Use" 
			,
			angle(0) nogrid glc(gs16) labsize(2))
			
			ytitle("{bf:Built Environment Domain}", size(2) ) 
			yscale(reverse)
			
			xscale(fill)
			xlab(0.4(0.2)2.7 "1.0", labs(2.5) nogrid glc(gs16))
			xtitle("{bf:Odds Ratio}", size(2) )
			
			title("{bf:Active Communting}", color(black) size(small))
			
				legend(size(2) position(1) ring(0) bm(t=1 b=4 l=5 r=0) colf cols(2)
                region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
                order(2 4) 
                lab(2 "Negative/Null") lab(4 "Positive")  
				title("{bf:Relationships}", color(black) size(small))
                )
				
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) ilcolor(black) lw(thin) lcolor(black)) 
            bgcolor(white) 
            ysize(6) xsize(10)
			
			name(active_commute, replace)
		;
		#delimit cr
*-------------------------------------------------------------------------------
*Leisure-time activity
	#delimit;
	graph twoway
		(sc walkhealth_cat or if or<=1 & activity==3 & ipen!=1, msize(3) msymbol(smcircle_hollow) mlc(gs0) mlw(0.1) ) 
		
		(sc walkhealth_cat or if or>1 & activity==3 & ipen!=1, msize(3) msymbol(smcircle) mlc(gs0) mfc("84 39 143") mlw(0.1) )
		
		, xline(1, lcolor(black))
		
				ylab(1"Surveillance" 2"Experience" 3"Traffic Safety" 4"Community" 5"Greenspace" 6"Density"
				 7"Connectivity" 8"Land Use" 
			,
			angle(0) nogrid glc(gs16) labsize(2))
			ytitle("{bf:Built Environment Domain}", size(2) ) 
			yscale(reverse)
			
			xscale(fill)
			xlab(0.40(0.2)3.0 "1.0", labs(2.5) nogrid glc(gs16))
			xtitle("{bf:Odds Ratio}", size(2) )
			
			title("{bf:Leisure-time PA}", color(black) size(small))
			
			legend(off)
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 
            ysize(6) xsize(10)
			
			name(leisure, replace)
		;
		#delimit cr
*-------------------------------------------------------------------------------
*MVPA and Total PA
	#delimit;
	graph twoway
		(sc walkhealth_cat or if or<=1 & activity==4 & ipen!=1, msize(3) msymbol(smcircle_hollow) mlc(gs0) mlw(0.1) jitter(0.5)) 
		(sc walkhealth_cat or if or<=1 & activity==5 & ipen!=1, msize(3) msymbol(smcircle_hollow) mlc(gs0) mlw(0.1) jitter(0.5)) 
		
		(sc walkhealth_cat or if or>1 & activity==4 & ipen!=1, msize(3) msymbol(smcircle) mlc(gs0) mfc("84 39 143") mlw(0.1) jitter(0.5))
		(sc walkhealth_cat or if or>1 & activity==5 & ipen!=1, msize(3) msymbol(smcircle) mlc(gs0) mfc("84 39 143") mlw(0.1) jitter(0.5))	
		, xline(1, lcolor(black))
		
				ylab(1"Surveillance" 2"Experience" 3"Traffic Safety" 4"Community" 5"Greenspace" 6"Density"
				 7"Connectivity" 8"Land Use" 
			,
			angle(0) nogrid glc(gs16) labsize(2))
			ytitle("{bf:Built Environment Domain}", size(2) ) 
			yscale(reverse)
			
			xscale(fill)
			xlab(0.80(0.1)1.8 "1.0", labs(2.5) nogrid glc(gs16))
			xtitle("{bf:Odds Ratio}", size(2) )
			
			title("{bf:MVPA and Total Activity}", color(black) size(small))
			
			legend(off)
				
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 
            ysize(6) xsize(10)
			
			name(mvpa_total, replace)
		;
		#delimit cr
*-------------------------------------------------------------------------------
*Combine graphs

	#delimit;
	
	graph combine active_commute leisure mvpa_total	
		, 
		
		col(1)
		
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
        graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
        ysize(6) xsize(10)
			
		name(combine_BE, replace)
		;
		#delimit cr
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
