

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_008.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	13/06/2021
**	Date Modified: 	13/06/2021
**  Algorithm Task: Creating Contour-Enhanced Plots for Relationships


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
*/



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


*Creating variables for forest plots
gen lnor = .
gen lnlci = .
gen lnuci = .
replace lnor = ln(or) 
replace lnlci = ln(Lower) 
replace lnuci = ln(Upper) 
gen or_se = .
replace or_se = (lnuci - lnlci) / (2*invnormal(0.975)) 

*Create PA variable
gen PA = .
replace PA = 1 if activity == 1
replace PA = 1 if activity == 2
replace PA = 2 if activity == 3
replace PA = 3 if activity == 4
replace PA = 3 if activity == 5

label var PA "Physical Activity Type"
label define PA 1"Active Transport" 2"Leisure-time PA" 3"MVPA/Total PA"
label value PA PA

#delimit;
confunnel lnor or_se if ipen!=1, contours(0.1 1 5 10) name(funnel, replace) 
			
			contcolor(green)
			xlab(-2.0 -1.2 0 1.2 2.0, labsize(small)) xtitle("Odds Ratio (log scale)") 
			ylab(.84(.1)0) ytitle("Standard Error") 
			
			scatteropts(mfcolor(purple%20) mlw(0.1) mlc(gs0)) 
			
			twowayopts(plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			

            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            bgcolor(white) )
			
			legendopts(row(2) region(lcolor(gs16)))	
			legend(order(10 "Relationships" 1 "p < 0.001" 2 "0.001 < p < 0.01"
						 5 "0.01 < p < 0.05" 6 "0.05 < p < 0.10" 0 "p > 0.10")
						 row(2))
			note(" ")

			;
#delimit cr

metabias lnor or_se if ipen!=1, egger 


*-------------------------------------------------------------------------------
#delimit;
confunnel lnor or_se if ipen!=1, by(PA, col(3)) contours(0.1 1 5 10) name(funnel_PA_3, replace) 
			
			contcolor(green)
			xlab(-2.0 -1.2 0 1.2 2.0, labsize(small)) xtitle("Odds Ratio (log scale)") 
			ylab(.84(.1)0) ytitle("Standard Error") 
			
			scatteropts(mfcolor(purple%20) mlw(0.1) mlc(gs0)) 
			
			twowayopts(plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			

            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            bgcolor(white) )
			
			legendopts(row(2) region(lcolor(gs16)))	
			legend(order(10 "Relationships" 1 "p < 0.001" 2 "0.001 < p < 0.01"
						 5 "0.01 < p < 0.05" 6 "0.05 < p < 0.10" 0 "p > 0.10")
						 row(2))
			note(" ")
			
			;
#delimit cr
by PA, sort: metabias lnor or_se if ipen!=1, egger 
