
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		MAPS_ECS_001.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	ECS Microscale Walkability
**  Analyst:		Kern Rocke
**	Date Created:	04/11/2020
**	Date Modified: 	04/11/2020
**  Algorithm Task: Sample size calculation


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

*WINDOWS OS Alternative
*local datapath "X:/The UWI - Cave Hill Campus//DataGroup - repo_data/data_p145

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*WINDOWS OS Alternative
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------
*Data merge and cleaning

*Load in walkability and SES data from encrypted location
import delimited "`datapath'/version01/2-working/Walkability/Barbados/Walkability_SES.csv", clear

*Minor data cleaning in preparation for data merge
rename ed ED

*Merge participant identifiers by ED
merge 1:m ED using "/Users/kernrocke/Downloads/ECHRON_par_ED.dta"

*Remove any unssuccessful merge data
keep if _merge == 3
rename _merge _merge1

*Merge participant characteristic data
merge 1:1 key using "/Users/kernrocke/Downloads/cvd_ECHORN.dta"

*Remove any unsuccessful merge
keep if _merge==3

*-------------------------------------------------------------------------------
*Cleaning of walkability and ses categories
encode walk_ses, gen(walk_ses1)
drop walk_ses
rename walk_ses1 walk_ses

*Examining distribution of active transport physical activity
ladder TMET

*Examining number of EDs that are either High walkability & high SES OR Low walkability & low SES
unique ED if walk_ses == 1 | walk_ses == 4 

*Looking at differences in mean active transport and walkability/SES categories
oneway TMET walk_ses, tab
tabstat TMET totMETmin inactive, by(walk_ses) stat(mean sd) col(stat)


*Sample size estimation (no graph)
power onemean 5238.193, diff(0.65(0.1)1.15) power(0.70(0.05)0.99) fpc(1008)

*Sample size estimation graph (1008)
power onemean 5238.193, diff(0.65(0.1)1.15) power(0.70(0.05)0.99) fpc(1008)  ///
		graph( xline(0.8) ///
		title("Sample size Calculation", c(black)) ///
		subtitle("Community and Individual Level Data Collection") ///
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		legend(on cols(6) title(Effect Size (d), c(black))) ///
		name(MAP_1008) ///
		note("") ///
		ytitle("Sample size (n) per neighbourhood", margin(small)) ///
		xlab(, labs(3.5) nogrid glc(gs16)) ///
	    ylab( , labs(3.5) nogrid glc(gs16) angle(0)))
		


*totMETmin
