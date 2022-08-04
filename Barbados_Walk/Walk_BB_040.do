clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_040.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	31/05/2022
**	Date Modified: 	31/05/2022
**  Algorithm Task: Paper #2 PhD Analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150
 
 set seed 1234
 
 *Setting working directory

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
local hotnpath "X:/The University of the West Indies/DataGroup - repo_data/data_p124"
local echornpath "X:/The University of the West Indies/DataGroup - repo_data/data_p120"


*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"
*local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p120"
*local hotnpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p124"
*local dopath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The UWI - Cave Hill Campus/Github Repositories"
 
 
 /*Overall preamble
 
This algorithm combines data on macrolevel features of the built environment with 
individual phyiscal activity behaviour and 10-year CVD risk.

The inidivudal data will be sourced from the nationally representative study sample
Health of the Nation.

*/

*Load in dataset
use "`datapath'/version01/2-working/Walkability/walkability_SES.dta", clear

*Remove any erronous data
drop if ED==.

*Create Z-scores
zscore Residential 
zscore Road_Foot_I_Density 
zscore LUM 
zscore walkability

*Walkabiluty Index (min-max scaled)
gen walkability_new = (walkability - -3.099427)/(15.65749 - -3.099427)
replace walkability_new = walkability_new*100

*To represent 10% increase in walkabilty index (Use for regression models)
gen walkability_new_10 = walkability_new/10
		
*Save dataset
save "`datapath'/version01/2-working/Walkability/walkability_paper_002.dta", replace
*-------------------------------------------------------------------------------

*Link HoTN and ECHORN with neighbourhood walkability
use "`hotnpath'/version01/Hotnanalysis/hotn_v4.1/hotn_v41RPAQBOUTS_adjV2.dta", clear
merge 1:1 pid using "`echornpath'/version02/2-working/hotn_cvdrisk_prepared.dta", nogenerate
rename ed ED

gen bmi_hotn = weight / ((height/100)^2)
*gen bmi = weight / ((height/100)^2)

*Cummulatie biological risk variables
egen sbp_hotn = rowmean(sbp2 sbp3)
egen dbp_hotn = rowmean(dbp2 dbp3)
*egen hr_hotn = rowmean(hr2 hr3)
gen hba1c_hotn = hba1c
gen glucose_hotn = fplas * 18
gen tchol_hotn = tchol * 38.67
gen hdl_hotn = hdl * 38.67
gen ldl_hotn = ldl * 38.67
gen asthma_hotn = .
replace asthma_hotn = 0 if asthma == 2
replace asthma_hotn = 1 if asthma == 1
gen copd_hotn = .
replace copd_hotn = 0 if copd == 2
replace copd_hotn = 1 if copd == 1

*Car ownership/Use
gen car = .
replace car = 0 if transport1 == 4
replace car = 1 if transport1 == 1
replace car = 1 if transport1 == 2
replace car = 0 if transport1 == 3

gen car_new = .
replace car_new = 1 if transport ==1
replace car_new = 0 if transport !=1

gen car_hotn = .
replace car_hotn = 1 if transport1 == 1 | transport1 == 2 | transport1 == 3
replace car_hotn = 0 if transport1 == 4

*Overweight
gen over = .
replace over = 0 if bmi<24.99
replace over = 1 if bmi>=25 & bmi!=.

*Obesity
gen obese = .
replace obese = 100 if bmi>=30 & bmi!=.
replace obese = 0 if bmi<30

gen educ_new = .
replace educ_new = 1 if educ == 1 | educ == 2 | educ == 3
replace educ_new = 2 if educ == 4 | educ == 5 | educ == 7
replace educ_new = 3 if educ == 6 | educ == 8 | educ == 9

label var educ_new "Education"
label define educ_new 1"Primary" 2"Secondary" 3"Teritary"
label value educ_new educ_new

foreach x in CYCLEadj WALKadj LEIStime{
	replace `x' = `x'*60
	replace `x' = `x'*7
}

replace walkPleasureMin = walkPleasureMin*walkPleasure
replace walkExerMin = walkExerMin*walkExer


egen walk = rowtotal(WALKadj walkExerMin walkPleasureMin)
replace walk = . if WALKadj == . & walkExerMin == . & walkPleasureMin == .

gen wtravel_n = wtravel/4
tab wtravel_n
recode wtravel_n (0.25/1=1) (1.25/2=2) (2.25/3=3) (3.75=4) (4.5/5=5) (5.25=6) (7=7)
gen commute_wk_echorn = WALKadj*wtravel_n

egen walk_transport = rowtotal(CYCLEadj WALKadj)
replace walk_transport = . if WALKadj == . & CYCLEadj == .

gen zero_commute =.
replace zero_commute = 0 if walk_transport == 0
replace zero_commute = 1 if walk_transport >0 & walk_transport !=.

gen zero_leisure =.
replace zero_leisure = 0 if LEIStime == 0
replace zero_leisure = 1 if LEIStime >0 & LEIStime !=.

gen zero_mvpa =.
replace zero_mvpa = 0 if mvpa_mins == 0
replace zero_mvpa = 1 if mvpa_mins >0 & mvpa_mins !=.

gen zero_walk =.
replace zero_walk = 0 if walk == 0
replace zero_walk = 1 if walk >0 & walk !=.

gen missing = . 
replace missing = 1 if  walk_transport !=. | walk !=. | mvpa_mins !=. | LEIStime !=.
replace missing = 0 if walk_transport ==. & walk ==. & mvpa_mins ==. & LEIStime ==.

tab missing

gen smoke_hotn = .
replace smoke_hotn = 1 if smoke == 1
replace smoke_hotn = 0 if smoke == 2

gen study1 = "HoTN"
rename ascvd_risk10 ascvd10_hotn
replace ascvd10_hotn = ascvd10_hotn * 100

save "`datapath'/version01/2-working/Walkability/walkability_paper_002_hotn.dta", replace
*-------------------------------------------------------------------------------

*Merge in Neighbourhood Features
merge m:m ED using "`datapath'/version01/2-working/Walkability/walkability_paper_002.dta", nogenerate
merge m:m ED using "`datapath'/version01/2-working/Walkability/neighbourhood_charc_add.dta", nogenerate

*Remove empty cells
drop if pid == .

*Create walkability Tertiles
xtile walkability_tertiles = walkability, nq(3)

label var walkability_tertiles "Walkability Tertiles"
label define walkability_tertiles 1"Low" 2"Medium" 3"High"
label value walkability_tertiles walkability_tertiles

*Create age variables // Rounding off age to 0 decimal places
gen age = agey
replace age = round(age, 1.0)

*Recode Self-reported hypertension and diabetes variable for analysis 
recode hyper (2=0)
label define yes_no 0"No" 1"Yes"
label value hyper yes_no
replace hyper = 100 if  hyper==1

recode diab (2=0)
label value diab yes_no
replace diab = 100 if diab==1

replace smoke_hotn = 100 if smoke_hotn==1
replace who_inactiverpaq = 100 if who_inactiverpaq==1
replace car = 100 if car==1
replace zero_walk = 100 if zero_walk==1 

gen htn_new = .
replace htn_new = 1 if sbp_hotn>=140 & dbp_hotn>=90 & sbp_hotn!=. & dbp_hotn!=.
replace htn_new = 0 if sbp_hotn<140 | dbp_hotn<90
replace htn_new = 1 if hyperp==1
replace htn_new = 1 if hyperm ==1

gen ethnic_new = ethnic
recode ethnic_new (3/max=2)
label var ethnic_new "Ethncity (Black/Non-Black)"
label define ethnic_new 1"Black" 2"Non-Black"
label value ethnic_new ethnic_new

xtile walk_cat_3 = walkability_new_10, nq(3)

replace mvpa_mins = mvpa_mins*7

*Declear survey weighted dataset
svyset ED [pweight=wfinal1_ad], strata(region) vce(linearized) singleunit(missing)

*-------------------------------------------------------------------------------

*Table 1: Socio-demographics by walkability tertiles

svy linearized: mean age car bmi obese hyper diab smoke_hotn zero_walk walk walk_transport mvpa_mins who_inactiverpaq ascvd10_hotn , over(walkability_tertiles)  cformat(%9.1f) 


*Scaling Built Environemnt Variables


gen Res_10 = Residential/10
gen Con_10 = Road_Foot_I_Density/10
gen LUM_10 = LUM/10
gen Green_10 = Greenspace_Density/10
gen Bus_10 = Bus_Stop_Density/10

egen total_time = rowtotal(LIGHTtime MODERATEtime VIGOROUStime)
replace total_time = total_time*60
replace total_time = total_time*7

cls

/*Unadjusted models
foreach x of varlist walkability_new_10 Res_10 Con_10 LUM_10 Green_10 Bus_10{
	
metobit walk `x' [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
}


Multivariable adjusted models
foreach x of varlist walkability_new_10 Res_10 Con_10 LUM_10 Green_10 Bus_10{
	
metobit total_time `x' age sex i.ethnic_new bmi SES htn_new diab car_new [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
}
*/
gen cvd75 = .
replace cvd75 = 1 if ascvd10_hotn>=7.5 & ascvd10_hotn!=.
replace cvd75 = 0 if ascvd10_hotn<7.5

gen cvd10 = .
replace cvd10 = 1 if ascvd10_hotn>=10 & ascvd10_hotn!=.
replace cvd10 = 0 if ascvd10_hotn<10

gen cvd20 = .
replace cvd20 = 1 if ascvd10_hotn>=20 & ascvd10_hotn!=.
replace cvd20 = 0 if ascvd10_hotn<20


replace obese = 1 if obese ==100 

*Save dataset
save "`datapath'/version01/2-working/Walkability/walkability_paper_002_v1.dta", replace

*Add objective PA data
use "`hotnpath'/version01/3-output/HotN_actiheart_ForFurtherAnalysis.dta", clear

rename ed ED
keep pid mvpa_act PAEE_consolidated

save "`datapath'/version01/2-working/Walkability/walkability_paper_objective_PA_hotn.dta", replace

use "`datapath'/version01/2-working/Walkability/walkability_paper_002_v1.dta", replace
merge 1:1 pid using "`datapath'/version01/2-working/Walkability/walkability_paper_objective_PA_hotn.dta", nogenerate

*-------------------------------------------------------------------------------
/*
*Run Excel do file
do "`dopath/Walk_BB_040_1'"


/*

zero_walk_0 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        531       55.03       55.03
          1 |        434       44.97      100.00
------------+-----------------------------------
      Total |        965      100.00

zero_LEISti |
       me_0 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        907       73.50       73.50
          1 |        327       26.50      100.00
------------+-----------------------------------
      Total |      1,234      100.00

zero_mvpa_m |
      ins_0 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        930       75.36       75.36
          1 |        304       24.64      100.00
------------+-----------------------------------
      Total |      1,234      100.00

zero_total_ |
     time_0 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,083       87.76       87.76
          1 |        151       12.24      100.00
------------+-----------------------------------
      Total |      1,234      100.00

	  
    ce_km_0 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        704       95.14       95.14
          1 |         36        4.86      100.00
------------+-----------------------------------
      Total |        740      100.00

cls


*SES Index (min-max scaled)
gen SES_new = (SES - -8.739673)/(18.238 - -8.739673)
replace SES_new = SES_new*100





tab sex, gen(sex_)

foreach x of varlist walk LEIStime mvpa_mins TOTtime distance_km  {
	
tobit `x' walkability_new_10 [pweight = wps_b2010] , ll(0) vce(cluster ED) nolog cformat(%9.1f)
}

svy linearized: mean TOTtime  if walk!=.,  over(walk_cat_3)  cformat(%9.1f) 

tobit walk walkability_new_10 age sex i.ethnic bmi SES htn_new diab car_new parish [pweight = wps_b2010] , ll(0) vce(cluster ED) nolog cformat(%9.2f)




cls
foreach x of varlist cvd_75 cvd_10 cvd_20{

logistic `x' walkability_new_10 , cformat(%9.2f) vce(cluster ED)

}



cls
foreach x of varlist cvd_75 cvd_10 cvd_20{

logistic `x' walkability_new_10 age sex walk i.ethnic_new bmi SES car_new ib2.smoke if age>=40, cformat(%9.2f) vce(cluster ED)

}


cls

local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*Save results in table

putexcel set "`datapath'/version01/2-working/Walkability/Regression_Results.xlsx", modify sheet("Table 3")

putexcel B1= "Unadjusted Model", bold
putexcel B3= "Outcome"
putexcel C3= "Coeff"
putexcel D3= "95% CI (LL)"
putexcel E3= "95% CI (UL)"
putexcel F3= "p-value"


putexcel B5= "Overall walking (mins/week)", bold
putexcel B6= "Walking for pleasure (mins/week)", bold
putexcel B7= "Walking for exercise (mins/week)", bold
putexcel B8= "Leisure Activity (mins/week)", bold
putexcel B9= "MVPA (mins/week)", bold
putexcel B10= "Total activity (mins/week)", bold
putexcel B11= "Distance travelled (km)", bold

metobit walk walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C5= a[1,1]
putexcel D5= a[5,1]
putexcel E5= a[6,1]
putexcel F5= a[4,1]

metobit walkPleasureMin walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C6= a[1,1]
putexcel D6= a[5,1]
putexcel E6= a[6,1]
putexcel F6= a[4,1]

metobit walkExerMin walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C7= a[1,1]
putexcel D7= a[5,1]
putexcel E7= a[6,1]
putexcel F7= a[4,1]

metobit LEIStime walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C8= a[1,1]
putexcel D8= a[5,1]
putexcel E8= a[6,1]
putexcel F8= a[4,1]

metobit mvpa_mins walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C9= a[1,1]
putexcel D9= a[5,1]
putexcel E9= a[6,1]
putexcel F9= a[4,1]

metobit total_time walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C10= a[1,1]
putexcel D10= a[5,1]
putexcel E10= a[6,1]
putexcel F10= a[4,1]

metobit distance_km walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C11= a[1,1]
putexcel D11= a[5,1]
putexcel E11= a[6,1]
putexcel F11= a[4,1]


*-------------------------------------------------------------------------------

putexcel H1= "Multivariable Adjusted Model", bold
putexcel H3= "Outcome", bold
putexcel I3= "Coeff", bold 
putexcel J3= "95% CI (LL)", bold 
putexcel K3= "95% CI (UL)", bold
putexcel L3= "p-value", bold

putexcel H5= "Overall walking (mins/week)", bold
putexcel H6= "Walking for pleasure (mins/week)", bold
putexcel H7= "Walking for exercise (mins/week)", bold
putexcel H8= "Leisure Activity (mins/week)", bold
putexcel H9= "MVPA (mins/week)", bold
putexcel H10= "Total activity (mins/week)", bold
putexcel H11= "Distance travelled (km)", bold


metobit walk walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I5= a[1,1]
putexcel J5= a[5,1]
putexcel K5= a[6,1]
putexcel L5= a[4,1]

metobit walkPleasureMin walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I6= a[1,1]
putexcel J6= a[5,1]
putexcel K6= a[6,1]
putexcel L6= a[4,1]

metobit walkExerMin walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I7= a[1,1]
putexcel J7= a[5,1]
putexcel K7= a[6,1]
putexcel L7= a[4,1]

metobit LEIStime walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I8= a[1,1]
putexcel J8= a[5,1]
putexcel K8= a[6,1]
putexcel L8= a[4,1]

metobit mvpa_mins walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I9= a[1,1]
putexcel J9= a[5,1]
putexcel K9= a[6,1]
putexcel L9= a[4,1]

metobit total_time walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I10= a[1,1]
putexcel J10= a[5,1]
putexcel K10= a[6,1]
putexcel L10= a[4,1]

metobit distance_km walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I11= a[1,1]
putexcel J11= a[5,1]
putexcel K11= a[6,1]
putexcel L11= a[4,1]








gen cvd75 = .
replace cvd75 = 1 if ascvd10_hotn>=7.5 & ascvd10_hotn!=.
replace cvd75 = 0 if ascvd10_hotn<7.5

gen cvd20 = .
replace cvd20 = 1 if ascvd10_hotn>=20 & ascvd10_hotn!=.
replace cvd20 = 0 if ascvd10_hotn<20

mixed ascvd10_hotn walkability_new_10 i.sex age i.ethnic_new bmi SES htn_new diab car_new smoke TOTtime i.educ_new if age>=40 [pweight = wps_b2010] ||parish: ||ED: , cformat(%9.2f) nolog
margins, at(walkability=(0(10)100))
#delimit;

marginsplot,
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index)
	title(Overall, color(black))
	ylab(#6, angle(horizontal) nogrid)
	plotopts(mcolor(black) lcolor(black) msize(tiny))
	ciopts(lcolor(black))
	name(g1, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
	ysize(3)
	plotregion(style(none))
	
	;
	
#delimit cr

margins sex, at(walkability=(0(10)100))

#delimit ;
marginsplot, 
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index) 
	title(Sex, color(black))
	ylab(#6, angle(horizontal) nogrid)
	
	plot1opts(mcolor("214 39 40") lcolor("214 39 40") msize(tiny))
	ci1opts(lcolor("214 39 40"))
	
	plot2opts(mcolor("49 130 189") lcolor("49 130 189") msize(tiny))
	ci2opts(lcolor("49 130 189"))
	
	name(g2, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr

graph combine g1 g2
