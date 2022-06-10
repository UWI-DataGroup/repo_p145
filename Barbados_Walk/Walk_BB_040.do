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
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*local hotnpath "X:/The University of the West Indies/DataGroup - repo_data/data_p124"
*local echornpath "X:/The University of the West Indies/DataGroup - repo_data/data_p120"


*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p120"
local hotnpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p124"
local dopath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The UWI - Cave Hill Campus/Github Repositories"
 
 
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
}

egen walk = rowtotal(WALKadj ewalk_mins pwalk_mins)
replace walk = . if WALKadj == . & ewalk_mins == . & pwalk_mins == .

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

*Declear survey weighted dataset
svyset ED [pweight=wfinal1_ad], strata(region) vce(linearized) singleunit(missing)

*-------------------------------------------------------------------------------

*Table 1: Socio-demographics by walkability tertiles

svy linearized: mean age car bmi obese hyper diab smoke_hotn zero_walk walk walk_transport mvpa_mins who_inactiverpaq ascvd10_hotn , over(walkability_tertiles)  cformat(%9.1f) 
