clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_030.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/11/2020
**	Date Modified: 	10/02/2020
**  Algorithm Task: Walkability and SES Analysis (Area-levl Analysis)


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

*WINDOWS OS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS OS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

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
*log using "`logpath'/version01/3-output/Walkability/walk_BB_030.log",  replace

*-------------------------------------------------------------------------------

*Updated walkscore from building data
import delimited "`datapath'/version01/2-working/Walkability/Barbados/building_walkscore.csv", clear
rename id BID
save "`datapath'/version01/2-working/Walkability/Barbados/Barbados_building_walkscore.dta", replace
import delimited "`datapath'/version01/2-working/Walkability/Barbados/ED_building_Barbados.csv", clear
rename enum_no1 ED
rename objectid_2 BID
merge 1:1 BID using "`datapath'/version01/2-working/Walkability/Barbados/Barbados_building_walkscore.dta", nogenerate
collapse (mean) walkscore, by(ED)
drop if ED== .
label var walkscore "Walk Score"
gen walkscore_cat = .
replace walkscore_cat = 1 if walkscore <= 24
replace walkscore_cat = 2 if walkscore >=25 & walkscore<=49 & walkscore !=.
replace walkscore_cat = 2 if walkscore >=50 & walkscore<=69 & walkscore !=.
replace walkscore_cat = 3 if walkscore >=50 & walkscore<=69 & walkscore !=.
replace walkscore_cat = 4 if walkscore >=70 & walkscore !=.
tab walkscore_cat
label var walkscore_cat "Walk Score Categories"
save "`datapath'/version01/2-working/Walkability/Barbados/Barbados_WS.dta", replace

*Import road and foot walkability index data
use "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.dta", clear
keep ED walkability_road_foot Residential LUM Road_Foot_I_Density
rename walkability_road_foot walkability
save "`datapath'/version01/2-working/Walkability/Barbados/Barbados_WI.dta", replace

*Import Moveability index and walkability index (decile method) data
use "`datapath'/version01/2-working/Walkability/moveability_walk_10_Barbados.dta", clear
keep ED moveability walk_10 Area
label var walk_10 "Walkability index (Decile method)"
save "`datapath'/version01/2-working/Walkability/Barbados/Barbados_MI_W10.dta", replace

*Import Data driven walkability index
use "`datapath'/version01/2-working/Walkability/PCA_Data_Walk_Barbados.dta", clear
rename factor walkability_factor
label var walkability_factor "Data-Driven Walkability Index"
keep ED walkability_factor
save "`datapath'/version01/2-working/Walkability/Barbados/Barbados_WF.dta", replace

*Building data- For Building Density
import delimited "`datapath'/version01/2-working/Walkability/Barbados/buildings_count.csv", clear
rename enum_no1 ED
rename numpoints building_count
save "`datapath'/version01/2-working/Walkability/building_count.dta", replace

*Parking data - For Parking Density
import delimited "`datapath'/version01/2-working/Walkability/Barbados/parking.csv", clear
rename enum_no1 ED
rename numpoints parking
save "`datapath'/version01/2-working/Walkability/Barbados/parking.dta", replace

*Building Height data - Average building height per ED
import delimited "`datapath'/version01/2-working/Walkability/Barbados/BD_height.csv", clear
rename enum_no1 ED
collapse (mean) avg_height, by(ED)
rename avg_height BD_ht
label var BD_ht "Building Height (Avg)"
save "`datapath'/version01/2-working/Walkability/Barbados/BD_height.dta", replace

clear
*Load in WI data
use "`datapath'/version01/2-working/Walkability/Barbados/Barbados_WI.dta", clear

*Merge in WS data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/Barbados_WS.dta", nogenerate

*Merge in MI & W10 data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/Barbados_MI_W10.dta", nogenerate

*Merge in WF data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/Barbados_WF.dta", nogenerate

label var ED "Enumeration Districts"

*Merge in SES data
merge m:1 ED using "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_medium.dta", nogenerate

*Merge in Building Data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/building_count.dta", nogenerate

*Merge in Parking Data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/parking.dta", nogenerate

*Merge in Building Height Data
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/BD_height.dta", nogenerate

*Minor data cleaning
rename _eigen_var SES
*-------------------------------------------------------------------------------
cls

/*
Age Dependency - t_age_depend
High Income - per_t_high_income
Median Income - t_income_median
No Vehicle - per_vehicles_0
Population Density - pop_density
Crime - crime_density


*/

gen crime_density = crime_victim/Area

*Addition of ICE variable (Economic Residential Segregation)
egen total_income = rowtotal(t_income_0_49 t_income_50_99 t_income_100_149 t_income_150_199 t_income_200_over)

gen ERS = ((t_income_200_over+t_income_150_199) - t_income_0_49)/ total_income

*gen ICE = ((t_income_200_over+t_income_150_199+ t_income_100_149+ t_income_50_99) - t_income_0_49)/ total_income
label var ERS "Economic Residential Segregation"

gen ERS_cat = .
replace ERS_cat = 1 if ERS<=-0.8
replace ERS_cat = 2 if ERS>-0.8 & ERS<=-0.6
replace ERS_cat = 3 if ERS>-0.6 & ERS<=-0.4
replace ERS_cat = 4 if ERS>-0.4 & ERS<=-0.2
replace ERS_cat = 5 if ERS>-0.2 & ERS<=-0.0
replace ERS_cat = 6 if ERS>0.0 
tab ERS_cat 

*Addition of Index of Economic Dissimilarity (IED)
gen income_high = (t_income_150_199 + t_income_200_over)
tabstat income_high, by(parish) stat(sum)

/*
      parish |       sum
-------------+----------
Christ Churc |       171
  St. Andrew |         5
  St. George |        93
   St. James |       182
    St. John |        11
  St. Joseph |        11
    St. Lucy |         9
 St. Michael |       159
   St. Peter |        27
  St. Philip |        88
  St. Thomas |        67
-------------+----------
       Total |       823
------------------------

	
*/

*encode parish, gen(parish_cat)
gen parish_cat = parish

gen high_income_parish = .
replace high_income_parish = (income_high/171) if parish_cat == 1 // Christ Church
replace high_income_parish = (income_high/5) if parish_cat == 2 // St. Andrew
replace high_income_parish = (income_high/93) if parish_cat == 3 // St. George
replace high_income_parish = (income_high/182) if parish_cat == 4 // St. James
replace high_income_parish = (income_high/11) if parish_cat == 5 // St. John
replace high_income_parish = (income_high/11) if parish_cat == 6 // St. Joseph
replace high_income_parish = (income_high/9) if parish_cat == 7 // St. Lucy
replace high_income_parish = (income_high/159) if parish_cat == 8 // St. Michael
replace high_income_parish = (income_high/27) if parish_cat == 9 // St. Peter
replace high_income_parish = (income_high/88) if parish_cat == 10 // St. Philip
replace high_income_parish = (income_high/67) if parish_cat == 11 // St. Thomas


gen income_low = t_income_0_49
tabstat income_low, by(parish) stat(sum)

/*
      parish |       sum
-------------+----------
Christ Churc |     13050
  St. Andrew |      1336
  St. George |      6328
   St. James |      5727
    St. John |      2428
  St. Joseph |      1786
    St. Lucy |      2735
 St. Michael |     20127
   St. Peter |      3511
  St. Philip |      6741
  St. Thomas |      3975
-------------+----------
       Total |     67744
------------------------
*/

gen low_income_parish = .
replace low_income_parish = (income_low/13050) if parish_cat == 1 // Christ Church
replace low_income_parish = (income_low/1336) if parish_cat == 2 // St. Andrew
replace low_income_parish = (income_low/6328) if parish_cat == 3 // St. George
replace low_income_parish = (income_low/5727) if parish_cat == 4 // St. James
replace low_income_parish = (income_low/2428) if parish_cat == 5 // St. John
replace low_income_parish = (income_low/1786) if parish_cat == 6 // St. Joseph
replace low_income_parish = (income_low/2735) if parish_cat == 7 // St. Lucy
replace low_income_parish = (income_low/20127) if parish_cat == 8 // St. Michael
replace low_income_parish = (income_low/3511) if parish_cat == 9 // St. Peter
replace low_income_parish = (income_low/6741) if parish_cat == 10 // St. Philip
replace low_income_parish = (income_low/3975) if parish_cat == 11 // St. Thomas


gen IED = (0.5*(abs(high_income_parish - low_income_parish)))*100
label var IED "Index of Economic Dissimilarity"

*Create SES deciles
xtile SES_10 = SES , nq(10)
label var SES_10 "SES Index in Deciles"

*-------------------------------------------------------------------------------
*Population with secondary or more education

gen educ = ((t_education_secondary + t_education_post_secondary + t_education_tertiary)/total_pop) *100
label var educ "Percentage total population with secondary or more education"

*-------------------------------------------------------------------------------

*Log Transforming Population density (per sq km)
drop pop_density
gen pop_density = total_pop/Area
label var pop_density "Population Density"
sktest pop_density
*gladder pop_density
gen ln_pop_density = ln(pop_density)
label var ln_pop_density "Log-Transformed Population Density"

*-------------------------------------------------------------------------------

*Building Density
gen building_density = building_count/Area
label var building_density "Building Density"

*-------------------------------------------------------------------------------

*Crime per 1000
gen crime_pop = (crime_victim/total_pop)*1000
label var crime_pop "Crime Victims per 1000"

*-------------------------------------------------------------------------------

gen parking_density = parking/Area
label var parking_density "Parking Density"

*-------------------------------------------------------------------------------

*Create decile variables for SES, ERS, IED

*SES Deciles
xtile SES_dec = SES, nq(10)
*Recode into three groups (Low, Medium/Middle, High)
recode SES_dec (2=1) (3=1) (4=1) (5=2) (6=2) (7=3) (8=3) (9=3) (10=3)
label var SES_dec "SES Categories"
label define SES_dec 1"Low SES" 2"Middle SES" 3"High SES"
label value SES_dec SES_dec

*ERS Deciles
xtile ERS_dec = ERS, nq(10)
*Recode into three groups (Low, Medium/Middle, High)
recode ERS_dec (2=1) (3=1) (4=1) (5=2) (6=2) (7=3) (8=3) (9=3) (10=3)
label var ERS_dec "ERS Categories"
label define ERS_dec 1"Low ERS" 2"Middle ERS" 3"High ERS"
label value ERS_dec ERS_dec

*IED Deciles
xtile IED_dec = IED, nq(10)
*Recode into three groups (Low, Medium/Middle, High)
recode IED_dec (2=1) (3=1) (4=1) (5=2) (6=2) (7=3) (8=3) (9=3) (10=3)
label var IED_dec "IED Categories"
label define IED_dec 1"Low IED" 2"Middle IED" 3"High IED"
label value IED_dec IED_dec

*-------------------------------------------------------------------------------

*Create Low and High Walkability 

*IPEN Walkability Index
xtile WI_cat = walkability, nq(10)
*Recode into three groups (Low, Medium/Middle, High)
recode WI_cat (2=1) (3=1) (4=1) (5=2) (6=2) (7=3) (8=3) (9=3) (10=3)
label var WI_cat "Walkability Index Categories"
label define WI_cat 1"Low Walkability" 2"Medium Walkability" 3"High Walkability"
label value WI_cat WI_cat

*Walk Score
xtile WS_cat = walkscore, nq(10)
*Recode into three groups (Low, Medium/Middle, High)
recode WS_cat (2=1) (3=1) (4=1) (5=2) (6=2) (7=3) (8=3) (9=3) (10=3)
label var WS_cat "Walkability Index Categories"
label define WS_cat 1"Low Walkability" 2"Medium Walkability" 3"High Walkability"
label value WS_cat WS_cat

*Moveability Index
xtile MI_cat = moveability, nq(10)
*Recode into three groups (Low, Medium/Middle, High)
recode MI_cat (2=1) (3=1) (4=1) (5=2) (6=2) (7=3) (8=3) (9=3) (10=3)
label var MI_cat "Moveability Index Categories"
label define MI_cat 1"Low Moveability" 2"Medium Moveability" 3"High Moveability"
label value MI_cat MI_cat

*-------------------------------------------------------------------------------

*Save dataset
save "`datapath'/version01/2-working/Walkability/walkability_SES.dta", replace
*-------------------------------------------------------------------------------

*Regression Models for Active transport and walkability measures										
foreach x in walkability walkscore  moveability walk_10 walkability_factor{

mixed `x' SES || parish:
mixed `x' SES ERS || parish:
mixed `x' SES IED || parish:
mixed `x' SES IED ERS t_age_median per_vehicles_0 crime_pop || parish:

}
cls

foreach x in walkability walkscore  moveability walk_10 walkability_factor {
	foreach y in SES ERS i.ERS_cat IED{

regress `x' `y'  educ t_age_median per_t_unemployment crime_pop

	}
}


*Regression results plots
preserve
label var SES "SES"
label var ERS "ERS"
label var IED "IED"

regress walkability SES  educ t_age_median per_t_unemployment ln_pop_density crime_pop ib8.parish
estimates store regress
mixed walkability SES  educ t_age_median per_t_unemployment crime_pop ln_pop_density || parish:
estimates store mixed
regress walkability SES 
estimates store unadjust_regress
mixed walkability SES || parish:
estimates store unadjust_mixed

coefplot unadjust_regress regress unadjust_mixed mixed, keep (SES) name(SES)  ///
							xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(off)

drop _est_unadjust_regress _est_regress _est_unadjust_mixed _est_mixed
regress walkability ERS  educ t_age_median per_t_unemployment ln_pop_density crime_pop ib8.parish 
estimates store regress
mixed walkability ERS  educ t_age_median per_t_unemployment crime_pop ln_pop_density || parish:
estimates store mixed
regress walkability ERS 
estimates store unadjust_regress
mixed walkability ERS || parish:
estimates store unadjust_mixed

coefplot unadjust_regress regress unadjust_mixed mixed, keep (ERS) name(ERS) ///
							xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(off)

drop _est_unadjust_regress _est_regress _est_unadjust_mixed _est_mixed
regress walkability IED  educ t_age_median per_t_unemployment ln_pop_density crime_pop ib8.parish 
estimates store regress
mixed walkability IED educ t_age_median per_t_unemployment crime_pop ln_pop_density || parish:
estimates store mixed
regress walkability IED 
estimates store unadjust_regress
mixed walkability IED || parish:
estimates store unadjust_mixed

coefplot unadjust_regress regress unadjust_mixed mixed, keep (IED) name(IED) ///
							xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(off)

graph combine SES ERS IED, name(combine_method) col(3)

graph drop SES ERS IED 
drop _est_unadjust_regress _est_regress _est_unadjust_mixed _est_mixed

/*Comparison of walkbility index; walkscore and moveability

A multivariable model will be used for comparisons. 

Based on results obtained above we will use a linear regression model for simplicity

For comparisons convert measures to z-scores

*/

*-------------------------------------------------------------------------------

*Estimates for SES across walkability measures

foreach x in walkability walkscore moveability walkability_factor{
zscore `x'
regress z_`x' SES crime_pop building_density ib8.parish  
estimates store `x'
}

*Regression Plots for SES
#delimit;
coefplot (walkability, mlabels(SES= -.0379427 "IPEN Walkability")) 
		 (walkscore, mlabels(SES= -.0160782 "Walk Score")) 
		 (moveability, mlabels(SES= -.0335497 "Moveability"))
		 (walkability_factor, mlabels(SES= -.0277193 "Data-Driven Walkability"))
		 , keep(SES) name(SES) 
			xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(off)	
			xscale(range(-0.08 0.02)) ciopts(recast(rcap))
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr

*Remove estimates
drop _est_walkability _est_walkscore _est_moveability _est_walkability_factor			
*-------------------------------------------------------------------------------			

*Estimates for ERS across walkability measures
			
foreach x in walkability walkscore moveability walkability_factor{
regress z_`x' ERS crime_pop building_density ib8.parish 
estimates store `x'
}			
			
*Regression Plots for ERS
#delimit;
coefplot (walkability, mlabels(ERS= -1.327857 "IPEN Walkability")) 
		 (walkscore, mlabels(ERS= -1.673832 "Walk Score")) 
		 (moveability, mlabels(ERS= -1.347434 "Moveability"))
		 (walkability_factor, mlabels(ERS= -1.178293 "Data-Driven Walkability"))
		 , keep(ERS) name(ERS) 
			xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(off)	
			xscale(range(-2.5 1.0)) ciopts(recast(rcap))
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr

*Remove estimates
drop _est_walkability _est_walkscore _est_moveability _est_walkability_factor			
*-------------------------------------------------------------------------------

*Estimates for IED across walkability measures
			
foreach x in walkability walkscore moveability walkability_factor{
regress z_`x' IED crime_pop building_density ib8.parish  
estimates store `x'
}	

*Regression Plots for IED		
#delimit; 			
coefplot (walkability, mlabels(IED= -.0297685 "IPEN Walkability")) 
		 (walkscore, mlabels(IED= -.0444287 "Walk Score")) 
		 (moveability, mlabels(IED= -.0146038 "Moveability"))
		 (walkability_factor, mlabels(IED=  -.0096852 "Data-Driven Walkability"))
		 , keep(IED) name(IED) 
			xline(0, lcolor(black) lwidth(thin) lpattern(dash)) legend(off)	
			xscale(range(-0.08 0.02)) ciopts(recast(rcap))
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr

*Remove estimates
drop _est_walkability _est_walkscore _est_moveability _est_walkability_factor	
*-------------------------------------------------------------------------------

*Create combined graph
#delimit;			
graph combine SES ERS IED, 
		name(combine_walk) 
		col(3) 
		note("Adjusted for Median Age, %Secondary or more education, %Unemployment, Crime Density & Parish",
		size(small) color(black) position(7) span margin(small))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		
;
#delimit cr

*Remove older graphs
graph drop SES ERS IED 

*-------------------------------------------------------------------------------

*Estimates for SES across walkability measures

foreach x in walkability walkscore moveability walkability_factor{
	regress z_`x' ib3.SES_dec crime_pop building_density ib8.parish  
	estimates store `x'
}	

#delimit;

coefplot (walkability, mlabels(1.SES_dec= .2720146  "IPEN Walkability" 2.SES_dec = .0927828 "IPEN walkability")) 
		 (walkscore, mlabels(1.SES_dec= .2168649  "Walk Score" 2.SES_dec = .0372374 "Walk Score")) 
		 (moveability, mlabels(1.SES_dec= .3342229  "Moveability" 2.SES_dec = .090051 "Moveability")) 
		 (walkability_factor, mlabels(1.SES_dec= .1947413 "Data-Driven Walkability" 2.SES_dec = .0511553 "Data-Driven Walkability")) 
				, baselevel keep(1.SES_dec 2.SES_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					note("Reference: High Socioeconomic-Status",
						 size(small) color(black) position(7) span margin(small))
					name(SES)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))

;

#delimit cr

*Remove estimates
drop _est_walkability _est_walkscore _est_moveability _est_walkability_factor
*-------------------------------------------------------------------------------
*Estimates for ERS across walkability measures

foreach x in walkability walkscore moveability walkability_factor{
	regress z_`x' ib3.ERS_dec crime_pop building_density ib8.parish 
	estimates store `x'
}	

#delimit;

coefplot (walkability, mlabels(1.ERS_dec= .4166131  "IPEN Walkability" 2.ERS_dec = .0482702 "IPEN walkability")) 
		 (walkscore, mlabels(1.ERS_dec= .5045217  "Walk Score" 2.ERS_dec = .1793562 "Walk Score")) 
		 (moveability, mlabels(1.ERS_dec= .4498494  "Moveability" 2.ERS_dec = .1145965 "Moveability")) 
		 (walkability_factor, mlabels(1.ERS_dec= .3928293 "Data-Driven Walkability" 2.ERS_dec = .1344261 "Data-Driven Walkability")) 
				, baselevel keep(1.ERS_dec 2.ERS_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					note("Reference: High Economic Residential Segregation",
						 size(small) color(black) position(6) span margin(small))
					name(ERS)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))

;

#delimit cr

*Remove estimates
drop _est_walkability _est_walkscore _est_moveability _est_walkability_factor

*-------------------------------------------------------------------------------

*Estimates for IED across walkability measures

foreach x in walkability walkscore moveability walkability_factor{
	regress z_`x' ib3.IED_dec crime_pop building_density ib8.parish  
	estimates store `x'
}	

#delimit;

coefplot (walkability, mlabels(1.IED_dec= .1455587  "IPEN Walkability" 2.IED_dec = .0558819 "IPEN walkability")) 
		 (walkscore, mlabels(1.IED_dec= .209227  "Walk Score" 2.IED_dec = .175044 "Walk Score")) 
		 (moveability, mlabels(1.IED_dec= .0378012  "Moveability" 2.IED_dec = .0717168 "Moveability")) 
		 (walkability_factor, mlabels(1.IED_dec= .0326398 "Data-Driven Walkability" 2.IED_dec = .0322711 "Data-Driven Walkability")) 
				, baselevel keep(1.IED_dec 2.IED_dec) 
					xline(0, lcolor(black) lwidth(thin) lpattern(dash)) 
					ciopts(recast(rcap)) legend(off)
					note("Reference: High Economic Dissimilarity",
						 size(small) color(black) position(7) span margin(small))
					name(IED)
					plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
					graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))

;

#delimit cr

*Remove estimates
drop _est_walkability _est_walkscore _est_moveability _est_walkability_factor
*-------------------------------------------------------------------------------

*Create combined graph
#delimit;			
graph combine SES ERS IED, 
		name(combine_cat) 
		col(3) 
		note("Adjusted for Parish, Building Density & Crime per 1000 population",
		size(small) color(black) position(7) span margin(small))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		title("Linear Regression of Walkability and Socio-Economic Measures", size(medsmall) color(black))
		
;
#delimit cr

*Remove older graphs
graph drop SES ERS IED 

*-------------------------------------------------------------------------------

restore
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

preserve
lowess walkability SES, gen(walk)nog
twoway scatter walkability SES, mcolor(none) msymbol(none) || line walk SES, sort clstyle(solid) name(g1, replace) legend(off)
mkspline2 SES_knot = SES, cubic nknots(5) displayknots
drop SES_knot*
mkspline2 SES_spline = SES, cubic nknots(5)

*-------------------------------------------------------------------------------
*Walkability Index
regress walkability SES_spline* 
#delimit;
adjustrcspline , name(g2, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WI") ylabel(, angle(horizontal)) xtitle("Socioeconomic Status") 
		addplot(histogram SES, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Walkability Index", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Walk Score
regress walkscore SES_spline* 
#delimit;
adjustrcspline , name(g3, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WS") ylabel(, angle(horizontal)) xtitle("Socioeconomic Status") 
		addplot(histogram SES, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Walk Score", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Moveability Index
regress moveability SES_spline*  
#delimit;
adjustrcspline , name(g4, replace)  ciopts(col(gs13)) 
		ytitle("Predicted MI") ylabel(, angle(horizontal)) xtitle("Socioeconomic Status") 
		addplot(histogram SES, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Moveability Index", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Data Driven Walkability Index
regress walkability_factor SES_spline* 
#delimit;
adjustrcspline , name(g5, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WF") ylabel(, angle(horizontal)) xtitle("Socioeconomic Status") 
		addplot(histogram SES, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2)) 
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Data-Driven Walkability", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Combine Graph
#delimit ; 
graph combine g2 g3 g4 g5, col(2) name(combine_SES_spline) 
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		title("Relationship between Neighbourhood Walkability" "and Area-level SES", 
		size(medium) color(black))

;
#delimit cr

graph drop g1 g2 g3 g4 g5

restore

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

preserve
lowess walkability ERS, gen(walk)nog
twoway scatter walkability ERS, mcolor(none) msymbol(none) || line walk ERS, sort clstyle(solid) name(g1, replace) legend(off)
mkspline2 ERS_knot = ERS, cubic nknots(5) displayknots
drop ERS_knot*
mkspline2 ERS_spline = ERS, cubic nknots(5)

*-------------------------------------------------------------------------------
*Walkability Index
regress walkability ERS_spline* 
#delimit;
adjustrcspline , name(g2, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WI") ylabel(, angle(horizontal) ) xtitle("Economic Residential Segregation") 
		addplot(histogram ERS, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Walkability Index", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Walk Score
regress walkscore ERS_spline* 
#delimit;
adjustrcspline , name(g3, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WS") ylabel(, angle(horizontal)) xtitle("Economic Residential Segregation") 
		addplot(histogram ERS, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Walk Score", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Moveability Index
regress moveability ERS_spline* 
#delimit;
adjustrcspline , name(g4, replace)  ciopts(col(gs13)) 
		ytitle("Predicted MI") ylabel(, angle(horizontal)) xtitle("Economic Residential Segregation") 
		addplot(histogram ERS, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Moveability Index", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Data Driven Walkability Index
regress walkability_factor ERS_spline* 
#delimit;
adjustrcspline , name(g5, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WF") ylabel(, angle(horizontal)) xtitle("Economic Residential Segregation") 
		addplot(histogram ERS, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2)) 
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Data-Driven Walkability", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Combine Graph
#delimit ; 
graph combine g2 g3 g4 g5, col(2) name(combine_ERS_spline) 
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		title("Relationship between Neighbourhood Walkability" "and Area-level ERS", 
		size(medium) color(black))
		

;
#delimit cr

graph drop g2 g3 g4 g5

restore

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

preserve
lowess walkability IED, gen(walk)nog
twoway scatter walkability IED, mcolor(none) msymbol(none) || line walk IED, sort clstyle(solid) name(g1, replace) legend(off)
mkspline2 IED_knot = IED, cubic nknots(5) displayknots
drop IED_knot*
mkspline2 IED_spline = IED, cubic nknots(5)

*-------------------------------------------------------------------------------
*Walkability Index
regress walkability IED_spline*  
#delimit;
adjustrcspline , name(g2, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WI") ylabel(, angle(horizontal) ) xtitle("Index of Economic Dissimilarity") 
		addplot(histogram IED, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Walkability Index", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Walk Score
regress walkscore IED_spline* 
#delimit;
adjustrcspline , name(g3, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WS") ylabel(, angle(horizontal)) xtitle("Index of Economic Dissimilarity") 
		addplot(histogram IED, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Walk Score", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Moveability Index
regress moveability IED_spline* 
#delimit;
adjustrcspline , name(g4, replace)  ciopts(col(gs13)) 
		ytitle("Predicted MI") ylabel(, angle(horizontal)) xtitle("Index of Economic Dissimilarity") 
		addplot(histogram IED, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2))
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Moveability Index", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Data Driven Walkability Index
regress walkability_factor IED_spline* 
#delimit;
adjustrcspline , name(g5, replace)  ciopts(col(gs13)) 
		ytitle("Predicted WF") ylabel(, angle(horizontal)) xtitle("Index of Economic Dissimilarity") 
		addplot(histogram IED, percent ylabel(, axis(2) angle(horizontal)) fcolor(none) lcolor(gs7) yaxis(2)) 
		legend(on order(1) lab(1 "95% CI") region(fcolor(gs16) lw(vthin) ))
		title("Data-Driven Walkability", size(medsmall) color(black))
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
;
#delimit cr
*-------------------------------------------------------------------------------
*Combine Graph
#delimit ; 
graph combine g2 g3 g4 g5, col(2) name(combine_IED_spline) 
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
		title("Relationship between Neighbourhood Walkability" "and Area-level IED", 
		size(medium) color(black))

;
#delimit cr

graph drop g1 g2 g3 g4 g5

restore

*-------------------------------------------------------------------------------

/*Keep the following Data
keep walkability walkscore moveability walkability_factor SES SES_dec ERS ERS_dec ///
	 IED IED_dec ln_pop_density crime_density parish ED
	 
*Save dataset
save "`datapath'/version01/2-working/Walkability/walkability_SES.dta", replace

/*
*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/walkability_indices_road_foot.dta", nogenerate force



merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Destination_Density.dta", nogenerate force

merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/parking.dta", nogenerate


merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Slope_Barbados.dta", nogenerate

merge 1:1 ED using "`datapath'/version01/2-working/Walkability/Traffic_Calming_Barbados.dta", nogenerate


cls
foreach x in pop_density crime_density ERS IED Residential Road_Foot_I_Density ///
			 LUM walkability walkscore moveability walkability_factor  {
			 
		kwallis `x', by(SES_dec)
		}
