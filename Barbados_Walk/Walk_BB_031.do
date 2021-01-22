clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_031.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/11/2020
**	Date Modified: 	19/01/2020
**  Algorithm Task: Creating Regression Plots (Phd Seminar #2)


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
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS OS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS OS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**ECHORN data path

*WINDOWS OS
*local echornpath "X:/The University of the West Indies/DataGroup - repo_data/data_p120"

*WINDOWS OS (Alternative)
*local echornpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p120"

*MAC OS
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p120"

*-------------------------------------------------------------------------------

*Open log file to store results
*log using "`logpath'/version01/3-output/Walkability/walk_BB_031.log",  replace

*-------------------------------------------------------------------------------

*Load in dataset
use "`datapath'/version01/2-working/Walkability/walkability_SES.dta", clear

*-------------------------------------------------------------------------------

preserve 
foreach x in walkability walkscore moveability walkability_factor{
	zscore `x'
	regress z_`x' ib3.SES_dec crime_pop building_density ib8.parish  
	estimates store `x'
}	

#delimit;

coefplot (walkability, mlabels(1.SES_dec= .2720146  "IPEN Walkability" 2.SES_dec = .0927828 "IPEN walkability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
		 (walkscore, mlabels(1.SES_dec= .2168649  "Walk Score" 2.SES_dec = .0372374 "Walk Score") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
		 (moveability, mlabels(1.SES_dec= .3342229  "Moveability" 2.SES_dec = .090051 "Moveability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
		 (walkability_factor, mlabels(1.SES_dec= .1947413 "Data-Driven Walkability" 2.SES_dec = .0511553 "Data-Driven Walkability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
				, baselevel keep(1.SES_dec 2.SES_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					caption(" ",
						 size(small) color(black) position(7) span margin(small))
					name(SES_0, replace)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
					title("Linear Regression of Walkability and Socio-Economic Measures", size(medsmall) color(black))
					note(" ",
					size(small) color(black) position(7) span margin(small))
					xlabel(-0.4(0.2)0.6)

;

#delimit cr
*-------------------------------------------------------------------------------
#delimit;

coefplot (walkability, mlabels(1.SES_dec= .2720146  "IPEN Walkability" 2.SES_dec = .0927828 "IPEN walkability") ) 
		 (walkscore, mlabels(1.SES_dec= .2168649  "Walk Score" 2.SES_dec = .0372374 "Walk Score") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
		 (moveability, mlabels(1.SES_dec= .3342229  "Moveability" 2.SES_dec = .090051 "Moveability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
		 (walkability_factor, mlabels(1.SES_dec= .1947413 "Data-Driven Walkability" 2.SES_dec = .0511553 "Data-Driven Walkability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
				, baselevel keep(1.SES_dec 2.SES_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					caption("Reference: High Socioeconomic-Status",
						 size(small) color(black) position(7) span margin(small))
					name(SES_1, replace)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
					title("Linear Regression of Walkability and Socio-Economic Measures", size(medsmall) color(black))
					note("Adjusted for Parish, Building Density & Crime victim per 1000 population",
					size(small) color(black) position(7) span margin(small))
					xlabel(-0.4(0.2)0.6)

;

#delimit cr
*-------------------------------------------------------------------------------
#delimit;

coefplot (walkability, mlabels(1.SES_dec= .2720146  "IPEN Walkability" 2.SES_dec = .0927828 "IPEN walkability") ) 
		 (walkscore, mlabels(1.SES_dec= .2168649  "Walk Score" 2.SES_dec = .0372374 "Walk Score") ) 
		 (moveability, mlabels(1.SES_dec= .3342229  "Moveability" 2.SES_dec = .090051 "Moveability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
		 (walkability_factor, mlabels(1.SES_dec= .1947413 "Data-Driven Walkability" 2.SES_dec = .0511553 "Data-Driven Walkability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
				, baselevel keep(1.SES_dec 2.SES_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					caption("Reference: High Socioeconomic-Status",
						 size(small) color(black) position(7) span margin(small))
					name(SES_2, replace)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
					title("Linear Regression of Walkability and Socio-Economic Measures", size(medsmall) color(black))
					note("Adjusted for Parish, Building Density & Crime victim per 1000 population",
					size(small) color(black) position(7) span margin(small))
					xlabel(-0.4(0.2)0.6)

;

#delimit cr
*-------------------------------------------------------------------------------
#delimit;

coefplot (walkability, mlabels(1.SES_dec= .2720146  "IPEN Walkability" 2.SES_dec = .0927828 "IPEN walkability") ) 
		 (walkscore, mlabels(1.SES_dec= .2168649  "Walk Score" 2.SES_dec = .0372374 "Walk Score") ) 
		 (moveability, mlabels(1.SES_dec= .3342229  "Moveability" 2.SES_dec = .090051 "Moveability") ) 
		 (walkability_factor, mlabels(1.SES_dec= .1947413 "Data-Driven Walkability" 2.SES_dec = .0511553 "Data-Driven Walkability") mlabcolor(white) cismooth(color(white)) mcolor(white)) 
				, baselevel keep(1.SES_dec 2.SES_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					caption("Reference: High Socioeconomic-Status",
						 size(small) color(black) position(7) span margin(small))
					name(SES_3, replace)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
					title("Linear Regression of Walkability and Socio-Economic Measures", size(medsmall) color(black))
					note("Adjusted for Parish, Building Density & Crime victim per 1000 population",
					size(small) color(black) position(7) span margin(small))
					xlabel(-0.4(0.2)0.6)

;

#delimit cr
*-------------------------------------------------------------------------------
#delimit;

coefplot (walkability, mlabels(1.SES_dec= .2720146  "IPEN Walkability" 2.SES_dec = .0927828 "IPEN walkability") ) 
		 (walkscore, mlabels(1.SES_dec= .2168649  "Walk Score" 2.SES_dec = .0372374 "Walk Score") ) 
		 (moveability, mlabels(1.SES_dec= .3342229  "Moveability" 2.SES_dec = .090051 "Moveability") ) 
		 (walkability_factor, mlabels(1.SES_dec= .1947413 "Data-Driven Walkability" 2.SES_dec = .0511553 "Data-Driven Walkability") ) 
				, baselevel keep(1.SES_dec 2.SES_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					caption("Reference: High Socioeconomic-Status",
						 size(small) color(black) position(7) span margin(small))
					name(SES_4, replace)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
					title("Linear Regression of Walkability and Socio-Economic Measures", size(medsmall) color(black))
					note("Adjusted for Parish, Building Density & Crime victim per 1000 population",
					size(small) color(black) position(7) span margin(small))
					xlabel(-0.4(0.2)0.6)

;

#delimit cr
*-------------------------------------------------------------------------------

*Remove estimates
drop _est_walkability _est_walkscore _est_moveability _est_walkability_factor
restore
