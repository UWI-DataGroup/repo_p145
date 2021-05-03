
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_005.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	20/01/2021
**	Date Modified: 	01/02/2021
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
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - data_p145"


*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - data_p145"


*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - data_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"

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

*Install user-driven commands for forest and funnel plots
ssc install admetan, replace
ssc install metan, replace
ssc install metafunnel, replace
ssc install metabias, replace


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

*Bolding of variable labels
label var BEMeasure `"`"{bf:Built Envrionment}"' `"{bf:Attributes}"'"'
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
		color(black) size(medsmall)) caption("Outcome: cycling for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_cycling, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup 
		
*Active Transport Walking (No Buffer)
admetan lnor lnlci lnuci if activity==2 & Subcat == "" | Subcat == "High SES" | Subcat == "Low SES" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup 
		
*Active Transport Walking (500m Buffer)		
admetan lnor lnlci lnuci if activity==2 & Subcat == "500m" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures" "500m Buffer", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking_500, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup 

*Active Transport Walking (1000m Buffer)
admetan lnor lnlci lnuci if activity==2 & Subcat == "1000m" , eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment Measures" "1000m Buffer", ///
		color(black) size(medsmall)) caption("Outcome: walking for transport (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_walking_1000, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup 		
		
*-------------------------------------------------------------------------------		
		
**Leisure-time Physical Activity

admetan lnor lnlci lnuci if activity==3 & (BE == "{bf:Land Use}" | BE == "{bf:Proximity to Destinations}" | BE == "{bf:Walkability Index}") , eform(Studies) effect(OR) ///
		forestplot( title("Leisure Time Physical Activity and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Leisure-time Physical Activity (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_LtPA_LUM_Prox, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup 

admetan lnor lnlci lnuci if activity==3 & (BE == "{bf:Open Greenspace}" | BE == "{bf:Route Characteristics}") , eform(Studies) effect(OR) ///
		forestplot( title("Leisure Time Physical Activity and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Leisure-time Physical Activity (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_LtPA_Green_Route, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup

admetan lnor lnlci lnuci if activity==3 & (BE == "{bf:Population Density}" | BE == "{bf:Residential Density}" | BE == "{bf:Street Connectivity}" | BE == "{bf:Transit}" ) , eform(Studies) effect(OR) ///
		forestplot( title("Leisure Time Physical Activity and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Leisure-time Physical Activity (10/150 min per week)", span size(vsmall)) ///
		dp(2) name(forest_LtPA_Pop_Res, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup
		
*-------------------------------------------------------------------------------	

admetan lnor lnlci lnuci if activity==4 & (Estimatetype == "Odds Ratio"  | Estimatetype == "Prevalence Ratio") ///
		& (BE== "{bf:Land Use}" | BE== "{bf:Open Greenspace}" | BE== "{bf:Proximity to Destinations}" | ///
		BE== "{bf:Residential Density}") , eform(Studies) effect(OR) ///
		forestplot( title("MVPA and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Moderate to Vigorous Physical Activity per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_cycling, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup 

admetan lnor lnlci lnuci if activity==4 & (Estimatetype == "Odds Ratio"  | Estimatetype == "Prevalence Ratio") ///
		& (BE== "{bf:Retail Floor}" | BE== "{bf:Route Characteristics}" | BE== "{bf:Street Connectivity}" | ///
		BE== "{bf:Transit}") , eform(Studies) effect(OR) ///
		forestplot( title("MVPA and Built Environment Measures", ///
		color(black) size(medsmall)) caption("Outcome: Moderate to Vigorous Physical Activity per week)", span size(vsmall)) ///
		dp(2) name(forest_AT_cycling, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author) by(BE) nooverall nosubgroup 

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
			xlab(-2.0 -1.2 0 1.2 2.0) xtitle("Odds Ratio (log scale)") 
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

*Testing for publication bias (Egger Test)
**Active Transport
metabias lnor or_se if activity_new == 1, egger 
**Leisure-time Physical Activity
metabias lnor or_se if activity_new == 2, egger 
**Moderate to Vigorous Physical Activity
metabias lnor or_se if activity_new == 3, egger 
*confunnel lnor or_se, contours(0.1 1 5 10)  twowayopts(legend (order(0 1 2 3 4 5 ) lab(1 "p<0.001") lab(2 "0.001<p<0.01") lab(3 "0.01<p<0.05") lab(4 "0.05<p<0.1") lab(5 "p>0.1")))

