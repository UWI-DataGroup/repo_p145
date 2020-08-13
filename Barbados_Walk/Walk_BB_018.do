

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_018.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	12/08/2020
**	Date Modified: 	12/08/2020
**  Algorithm Task: Limits of Agreement for Walkability Measures


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
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Walkability/walk_BB_017.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Load in IPEN walkability index data from encrypted location
use "`datapath'/version01/2-working/Walkability/Walk_index.dta", clear

*Merge in walk score data 
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Walk_score.dta", nogenerate

*Merge in movability data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Moveability_index.dta", nogenerate


*Creating walkability index using Stockton approach https://core.ac.uk/download/pdf/190901731.pdf

*Create deciles for each walkability measure
xtile Intersection_10 = Intersection, nq(10)
xtile LUM_10 = LUM, nq(10)
xtile Residential_10 = Residential, nq(10)

*Sum the deciles for each walkability measure
egen walk_10 = rowtotal(Intersection_10 LUM_10 Residential_10)

*Create z-scores for Limits of Agreement plot
zscore walkability
zscore walkscore
zscore moveability
zscore walk_10

*Label newly created z-score variables
label var z_walkability "IPEN Walkability Index Z-score"
label var z_walkscore "Walk Score Z-Score"
label var z_moveability "Movability Index Z-score"
label var z_walk_10 "Stockton Walkability Z-score"

*-------------------------------------------------------------------------------

*Create limit of agreement plots

* 1) IPEN Walkability vs Walk Score
#delimit ;
batplot z_walkability z_walkscore, 
								notrend name(IPEN_walkscore)  
								ytitle("WI-WS") xtitle("Mean of WI & WS")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/IPEN_walkscore_BA", replace)
    ;
#delimit cr


* 2) IPEN Walkability vs Movability Index
#delimit ;
batplot z_walkability z_moveability, 
									notrend name(IPEN_movability)  
									ytitle("WI-MI") xtitle("Mean of WI & MI")
									moptions(mlabp(5)) sc(jitter(6))
									ylab(, nogrid)
									plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
									graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
									saving("`outputpath'/version01/3-output/Walkability/IPEN_moveability_BA", replace)
    ;
#delimit cr

* 3) IPEN Walkability vs Stockton Walkability
#delimit ;
batplot z_walkability z_walk_10, 
								notrend name(IPEN_walk10)  
								ytitle("WI-W10") xtitle("Mean of WI & W10")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/IPEN_walk10_BA", replace)
    ;
#delimit cr							
								
* 4) Walk Score vs Movability Index
#delimit ;								
batplot z_walkscore z_moveability, 
								notrend name(walkscore_moveability)  
								ytitle("WS-MI") xtitle("Mean of WS & MI")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/walkscore_moveability_BA", replace)
    ;
#delimit cr	

* 5) Walk Score vs Stockton Walkability
#delimit ;	
batplot z_walkscore z_walk_10, 
							notrend name(walkscore_walk10)  
							ytitle("WS-W10") xtitle("Mean of WS & W10")
							moptions(mlabp(5)) sc(jitter(6))
							ylab(, nogrid)
							plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
							graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
							saving("`outputpath'/version01/3-output/Walkability/walkscore_wal10_BA", replace)
    ;
#delimit cr

* 6) Movability vs Stockton Walkability
#delimit ;	
batplot z_moveability z_walk_10, 
								notrend name(moveability_walk10) 
								ytitle("MI-W10") xtitle("Mean of MI & W10")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/moveability_walk10_BA", replace)
    ;
#delimit cr

*Combine Graphs

#delimit ;

graph combine 
				"`outputpath'/version01/3-output/Walkability/IPEN_walkscore_BA"
				"`outputpath'/version01/3-output/Walkability/IPEN_moveability_BA"
				"`outputpath'/version01/3-output/Walkability/IPEN_walk10_BA"
				"`outputpath'/version01/3-output/Walkability/walkscore_moveability_BA"
				"`outputpath'/version01/3-output/Walkability/walkscore_wal10_BA"
				"`outputpath'/version01/3-output/Walkability/moveability_walk10_BA"
				,
				title(Limits of Agreement for Walkability Measures,
				color(black) size(medium)
				)
				caption("Note: WI- IPEN Walkability Index; WS- Walk Score; MI- Movability Index; W10- Stockton Walkability" 
				"All indices are presented as z-scores", position(5) span 
				size(vsmall) color(black) ring(3.5))
				plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
				graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
				
    ;
#delimit cr

graph export "`outputpath'/version01/3-output/Walkability/Limits_Agree_Walkability.png", replace as(png)	


********************************************************************************
********************************************************************************


*Trend Limit of Agreement plots

*Create limit of agreement plots

* 1) IPEN Walkability vs Walk Score
#delimit ;
batplot z_walkability z_walkscore, 
								name(IPEN_walkscore_trend)  
								ytitle("WI-WS") xtitle("Mean of WI & WS")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/IPEN_walkscore_BA_trend", replace)
    ;
#delimit cr


* 2) IPEN Walkability vs Movability Index
#delimit ;
batplot z_walkability z_moveability, 
									name(IPEN_movability_trend)  
									ytitle("WI-MI") xtitle("Mean of WI & MI")
									moptions(mlabp(5)) sc(jitter(6))
									ylab(, nogrid)
									plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
									graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
									saving("`outputpath'/version01/3-output/Walkability/IPEN_moveability_BA_trend", replace)
    ;
#delimit cr

* 3) IPEN Walkability vs Stockton Walkability
#delimit ;
batplot z_walkability z_walk_10, 
								name(IPEN_walk10_trend)  
								ytitle("WI-W10") xtitle("Mean of WI & W10")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/IPEN_walk10_BA_trend", replace)
    ;
#delimit cr							
								
* 4) Walk Score vs Movability Index
#delimit ;								
batplot z_walkscore z_moveability, 
								name(walkscore_moveability_trend)  
								ytitle("WS-MI") xtitle("Mean of WS & MI")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/walkscore_moveability_BA_trend", replace)
    ;
#delimit cr	

* 5) Walk Score vs Stockton Walkability
#delimit ;	
batplot z_walkscore z_walk_10, 
							name(walkscore_walk10_trend)  
							ytitle("WS-W10") xtitle("Mean of WS & W10")
							moptions(mlabp(5)) sc(jitter(6))
							ylab(, nogrid)
							plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
							graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
							saving("`outputpath'/version01/3-output/Walkability/walkscore_wal10_BA_trend", replace)
    ;
#delimit cr

* 6) Movability vs Stockton Walkability
#delimit ;	
batplot z_moveability z_walk_10, 
								 name(moveability_walk10_trend) 
								ytitle("MI-W10") xtitle("Mean of MI & W10")
								moptions(mlabp(5)) sc(jitter(6))
								ylab(, nogrid)
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
								saving("`outputpath'/version01/3-output/Walkability/moveability_walk10_BA_trend", replace)
    ;
#delimit cr

*Combine Graphs

#delimit ;

graph combine 
				"`outputpath'/version01/3-output/Walkability/IPEN_walkscore_BA_trend"
				"`outputpath'/version01/3-output/Walkability/IPEN_moveability_BA_trend"
				"`outputpath'/version01/3-output/Walkability/IPEN_walk10_BA_trend"
				"`outputpath'/version01/3-output/Walkability/walkscore_moveability_BA_trend"
				"`outputpath'/version01/3-output/Walkability/walkscore_wal10_BA_trend"
				"`outputpath'/version01/3-output/Walkability/moveability_walk10_BA_trend"
				,
				title(Limits of Agreement for Walkability Measures,
				color(black) size(medium)
				)
				caption("Note: WI- IPEN Walkability Index; WS- Walk Score; MI- Movability Index; W10- Stockton Walkability" 
				"All indices are presented as z-scores", position(5) span 
				size(vsmall) color(black) ring(3.5))
				plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
				graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
				
    ;
#delimit cr

*Export Graph
graph export "`outputpath'/version01/3-output/Walkability/Limits_Agree_Walkability_trend.png", replace as(png)		

*Save dataset
save "`datapath'/version01/2-working/Walkability/Walk_agree.dta", replace
	
