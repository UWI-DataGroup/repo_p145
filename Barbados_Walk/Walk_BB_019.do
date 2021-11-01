


clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_019.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	12/08/2020
**	Date Modified: 	12/08/2020
**  Algorithm Task: Data Driven Walkbility Index & Limits of Agreement


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
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Walkability/walk_BB_019.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

/*
Create walkability variable with the following:
1) Population Density
2) Residential Density
3) Intersection Density
4) Bus Stop Density
5) Destination Density
6) Land Use Mix
*/

*Install user-driven command
ssc install batplot, replace

*Load in data from encrypted location
use "`datapath'/version01/2-working/Walkability/Walk_agree.dta", clear

*Merge in SES data to obtain Population per ED
merge 1:1 ED using "`datapath'/version01/1-input/BSS_SES/additional_SES.dta"

*Remove unnecssary variables
drop marital_married - _merge

*Create Population Density 
gen pop_density = total_pop/Area

*Create z-score variables for population and destinatio density
zscore pop_density
zscore Destination_Density

*Factor analysis of built environment attributes
factor Residential Intersection LUM Bus_Stop_Density pop_density Destination_Density

*Predict scores for component 1 & 2 (eigen>1)
predict p1 p2 p3 p4
egen walk_factor = rowtotal(p1 p2 p3 p4)
drop p1 p2 p3 p4

*Create z-score variable for factor analysis walkability
zscore walk_factor

*-------------------------------------------------------------------------------

*Create limit of agreement plots with No Trend

* 1) IPEN Walkability vs Walkability factor
#delimit ;
batplot z_walkability z_walk_factor, 
								name(IPEN_walkfactor) notrend 
								ytitle("WIx-WF") xtitle("Mean of WIx & WF")
								ylab(, nogrid)
								moptions(mlabp(5) mfc(yellow)) sc(jitter(6))
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/IPEN_walkfactor_BA", replace)
     ;
#delimit cr


* 2) Walk Score vs Walkability factor
#delimit ;
batplot z_walkscore z_walk_factor, 
									name(Walkscore_walkfactor)  notrend
									ytitle("WS-WF") xtitle("Mean of WS & WF")
									ylab(, nogrid)
									moptions(mlabp(5) mfc(yellow)) sc(jitter(6))
									plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
									graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
									saving("`outputpath'/version01/3-output/Walkability/Walkscore_walkfactor_BA", replace)
    ;
#delimit cr

* 3) Moveability vs Walkability factor
#delimit ;
batplot z_moveability z_walk_factor, 
								name(Movability_walkfactor)  notrend
								ytitle("MIx-WF") xtitle("Mean of MIx & WF")
								ylab(, nogrid)
								moptions(mlabp(5) mfc(yellow)) sc(jitter(6))
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/Moveability_walkfactor_BA", replace)
    ;
#delimit cr							
								
* 4) Stockton Walkability vs Walkability factor
#delimit ;								
batplot z_walk_10 z_walk_factor, 
								name(walk10_walkfactor)  notrend
								ytitle("W10-WF") xtitle("Mean of W10 & WF")
								ylab(, nogrid)
								moptions(mlabp(5) mfc(yellow)) sc(jitter(6))
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/walk10_walkfactor_BA", replace)
    ;
#delimit cr	

*-------------------------------------------------------------------------------

*Create limit of agreement plots with Trend

* 1) IPEN Walkability vs Walkability factor
#delimit ;
batplot z_walkability z_walk_factor, 
								name(IPEN_walkfactor_trend)  
								ytitle("WIx-WF") xtitle("Mean of WIx & WF")
								ylab(, nogrid)
								moptions(mlabp(5) mfc(blue)) sc(jitter(6))
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/IPEN_walkfactor_BA_trend", replace)
     ;
#delimit cr


* 2) Walk Score vs Walkability factor
#delimit ;
batplot z_walkscore z_walk_factor, 
									name(Walkscore_walkfactor_trend)  
									ytitle("WS-WF") xtitle("Mean of WS & WF")
									ylab(, nogrid)
									moptions(mlabp(5) mfc(blue)) sc(jitter(6))
									plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
									graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
									saving("`outputpath'/version01/3-output/Walkability/Walkscore_walkfactor_BA_trend", replace)
    ;
#delimit cr

* 3) Moveability vs Walkability factor
#delimit ;
batplot z_moveability z_walk_factor, 
								name(Movability_walkfactor_trend)  
								ytitle("MIx-WF") xtitle("Mean of MIx & WF")
								ylab(, nogrid)
								moptions(mlabp(5) mfc(blue)) sc(jitter(6))
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/Moveability_walkfactor_BA_trend", replace)
    ;
#delimit cr							
								
* 4) Stockton Walkability vs Walkability factor
#delimit ;								
batplot z_walk_10 z_walk_factor, 
								name(walk10_walkfactor_trend)  
								ytitle("W10-WF") xtitle("Mean of W10 & WF")
								ylab(, nogrid)
								moptions(mlabp(5) mfc(blue)) sc(jitter(6))
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/walk10_walkfactor_BA_trend", replace)
    ;
#delimit cr	

*-------------------------------------------------------------------------------

*Combine Graphs

#delimit ;

graph combine 
				"`outputpath'/version01/3-output/Walkability/IPEN_walkfactor_BA"
				"`outputpath'/version01/3-output/Walkability/Walkscore_walkfactor_BA"
				"`outputpath'/version01/3-output/Walkability/Moveability_walkfactor_BA"
				"`outputpath'/version01/3-output/Walkability/walk10_walkfactor_BA"
				"`outputpath'/version01/3-output/Walkability/IPEN_walkfactor_BA_trend"
				"`outputpath'/version01/3-output/Walkability/Walkscore_walkfactor_BA_trend"
				"`outputpath'/version01/3-output/Walkability/Moveability_walkfactor_BA_trend"
				"`outputpath'/version01/3-output/Walkability/walk10_walkfactor_BA_trend"
				
				,
				title(Limits of Agreement for Theory driven Walkability vs Data driven Walkability,
				color(black) size(medium)
				)
				caption("Note: WIx- IPEN Walkability Index; WS- Walk Score; MIx- Movability Index; W10- Stockton Walkability; WF- Factor Analysis Walkability" 
				"All indices are presented as z-scores" "First row = No trend; Second row = Trend", position(5) 
				size(vsmall) color(black) ring(3.5) span)
				plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
				graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
				col(4)
				
    ;
#delimit cr

graph export "`outputpath'/version01/3-output/Walkability/Limits_Agree_Walkability_Factor.png", replace as(png)	

*-------------------------------------------------------------------------------

*Summary Stats and correlations
tabstat walkability walkscore moveability walk_10 walk_factor, stat(mean sd median iqr min max) col(stat)
pwcorr walkability walkscore moveability walk_10 walk_factor

*Save dataset
save "`datapath'/version01/2-working/Walkability/Walk_factor.dta", replace

*Close log file
log close	
	
