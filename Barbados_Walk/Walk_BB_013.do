
**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_0013.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	31/07/2020
**	Date Modified: 	18/05/2022
**  Algorithm Task: IPEN Walkability Country/Site Comparison (boxplot)


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
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

** Do file path

*Windows OS
*local dopath "X:/OneDrive - The University of the West Indies/Github Repositories/repo_p145"

*MAC OS
local dopath "/Users/kernrocke/OneDrive - The University of the West Indies/Github Repositories/repo_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
*log using "`logpath'/version01/3-output/Walkability/walk_BB_013.log",  replace

*Import data from encrypted location
import excel "`datapath'/version01/1-input/Walkability/IPEN_BIM.xlsx", sheet("Sheet1") firstrow clear


replace Mean = -4.21730977184e-10 in 17

encode A, gen(study1)
gen p_25 = Mean + (-0.675*SD)
gen p_75 = Mean + (0.675*SD)
replace p_25 = -2.07163 in 17
replace p_75 = 1.203318 in 17
replace Max = 5.764262 in 17
replace Min = -3.137781 in 17

* Note: Lower adjacent : -3.137781; upper adjacent: 5.764262

*twoway rbar p_25 Median study || rbar Median p_75 study || rspike p_25 Min study || rspike p_75 Max study || rcap Min Min study, msize (*6) || rcap Max Max study || scatter Mean study, msymbol(Oh) msize(*2) legend(off) xlabel ( 1 "Pooled IPEN Data" 2 "Adelaide, AUS" 3 "Ghent BEL" 4 "Curitiba, BRA" 5 "Bogota, COL" 6 "Olomouc, CZE" 7 "Aarhus, DNK" 8 "Hong Kong, HKG" 9 "Cuernavaca, MEX" 10 "Christchurch, NZL"  11 "North Shore, NLZ" 12 "Waitakere, NLZ" 13 "Wellington, NLZ" 14 "Stoke on Trent, GBR" 15 "Baltimore, USA" 16 "Seattle, USA" 17 "Barbados, BRB"))

gen study = .
replace study = 1 if A == "Pooled"
replace study = 2 if A == "Adelaide,"
replace study = 3 if A == "Ghent"
replace study = 4 if A == "Curitiba"
replace study = 5 if A == "Bogota"
replace study = 6 if A == "Olomouc"
replace study = 7 if A == "Aarhus"
replace study = 8 if A == "Hong Kong"
replace study = 9 if A == "Cuernavaca"
replace study = 10 if A == "Christchurch"
replace study = 11 if A == "North Shore"
replace study = 12 if A == "Waitakere"
replace study = 13 if A == "Wellington"
replace study = 14 if A == "Stoke-on-Trent"
replace study = 15 if A == "Baltimore"
replace study = 16 if A == "Seattle"
replace study = 17 if A == "Barbados"

gen graph = .
replace graph = 1 if study <9
replace graph = 2 if study >8

#delimit ;

twoway 
	   rbar p_25 Median study, 
								fcolor(gs14) lcolor(gs0) lwidth(.4)  barw(.6) 
								horizontal || 
								
       rbar  Median p_75 study, 
								fcolor(gs14) lcolor(gs0) lwidth (.4) barw(.6) 
								horizontal || 
								
       rspike p_25 Min study, 
								lcolor(black) horizontal || 
								
       rspike p_75 Max study, 
								lcolor(black) horizontal || 
								
       rcap Min Min study, 
								msize(*1) lcolor(black) horizontal || 
								
       rcap Max Max study, 
								msize(*1) pstyle(p1) horizontal || 
								
	   rbar p_25 Median study if study == 17, 
								fcolor(blue*.5) lcolor(black) lwidth(.4) 
								barw(.6) horizontal || 
								
       rbar  Median p_75 study if study == 17, 
								fcolor(blue*.5) lcolor(black) lwidth(.4) 
								barw(.6) horizontal || 
								
       scatter study Mean, 
								yscale(reverse) xlabel(-6(1)12) msymbol(X) 
								msize(*2) fcolor(gs12) mcolor(black) 
								legend(off)  
								ylabel(  1 "Pooled IPEN Data" 
										 2 "Adelaide, AUS" 
										 3 "Ghent, BEL" 
										 4 "Curitiba, BRA" 
										 5 "Bogota, COL" 
										 6 "Olomouc, CZE" 
										 7 "Aarhus, DNK" 
										 8 "Hong Kong, HKG" 
										 9 "Cuernavaca, MEX" 
										 10 "Christchurch, NZL"  
										 11 "North Shore, NZL" 
										 12 "Waitakere, NZL" 
										 13 "Wellington, NZL" 
										 14 "Stoke on Trent, GBR" 
										 15 "Baltimore, USA" 
										 16 "Seattle, USA" 
										 17 "Barbados, BRB"
										 
										 , angle(0) labsize(small) nogrid) 
										 
								xtitle(Walkability Index) 
								graphregion(fcolor(gs15)) 
								xline(0, lpattern(dash) lcolor(black))  
								ytitle("City, Country") 
								title("IPEN Walkability Index Comparisons", 
								color(black)) caption("X = Mean, | = Median", 
								position(5) size(vsmall))
								plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
								graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))

    ;
#delimit cr

log close
