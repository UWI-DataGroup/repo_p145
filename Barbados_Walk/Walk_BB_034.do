
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_034.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	30/09/2021
**	Date Modified: 	22/10/2021
**  Algorithm Task: Combining HoTN and ECHORN data


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

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p120"
local hotnpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p124"
local dopath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The UWI - Cave Hill Campus/Github Repositories"

*_______________________________________________________________________________

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
replace obese = 1 if bmi>=30 & bmi!=.
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

save "`datapath'/version01/2-working/Walkability/walkability_paper_001_hotn.dta", replace

*_______________________________________________________________________________

use "`echornpath'/version03/02-working/survey_wave1_weighted.dta", clear
merge 1:1 key using "`datapath'/version01/2-working/Walkability/Barbados/walkability_ECHORN_participants.dta"

merge 1:1 key using "`echornpath'/version03/01-input/GPAQ_Files_CDRC_041921/gpaq_clean.dta", nogenerate
merge 1:1 key using "`echornpath'/version03/02-working/wave1_framingham_allcvdrisk_prepared.dta", nogenerate
replace ED = "556" if key == "BB2263"
keep if siteid == 3
destring ED, replace 
drop RPH11 -RPH103
drop NU1 - NU107

*Cummulative biological risk
gen sbp_echorn = bp_systolic
gen dbp_echorn = bp_diastolic
gen tchol_echorn = TOTAL_CHOLESTEROL
gen hdl_echorn = hdl
gen ldl_echorn = ldl
gen hba1c_echorn = HBA1C
gen glucose_echorn = glucose
gen asthma_echorn = Asthma_COPD
replace asthma_echorn = 0 if Asthma_COPD == .

*Active Commuting variables
gen commute_day = p9
label var commute_day "Active Commuting (day)"

gen commute_wk = p9*p8
label var commute_wk "Active Commuting (week)"

gen APA = .
replace APA = 0 if commute_wk==0
replace APA = 1 if commute_wk>0 & commute_wk!=.
label var APA "Engaging in Active Commuting"
label define APA 0"Zero active commuting" 1"Engaging in active commuting"
label value APA APA

gen commute_cat = . 
replace commute_cat = 0 if commute_wk==0
replace commute_cat = 1 if commute_wk >0 & commute_wk<150
replace commute_cat = 2 if commute_wk>=150 & commute_wk!=.
label var commute_cat "Active Commuting Categories"
label define commute_cat 0"Inactive" 1"Insufficiently Active" 2"Active"
label value commute_cat commute_cat

*Smoking
gen smoke_echorn = HB24

*Car Ownership
gen car_echorn = .
replace car_echorn = 1 if D96 == 0
replace car_echorn = 0 if D96>0 & D96 !=.

*Education
gen education=.
replace education=1 if D13==0 | D13==1 | D13==2
replace education=2 if D13==3
replace education=3 if D13==4 | D13==5
replace education=4 if D13==6 | D13==7 | D13==8 | D13==9
label variable education "Education categories"
label define education 1 "less than high school" 2 "high school graduate" 3 "associates degree/some college" 4 "college degree"
label values education education 

*BMI
gen bmi_echorn = weight / ((height/100)^2)
*gen bmi = weight / ((height/100)^2)

*Obesity
gen obese = .
replace obese = 1 if bmi>=30 & bmi!=.
replace obese = 0 if bmi<30

rename ascvd10 ascvd10_echorn

keep gender partage bmi_echorn ED commute_day commute_wk APA commute_cat education car_echorn obese smoke_echorn sbp_echorn dbp_echorn tchol_echorn hdl_echorn ldl_echorn hba1c_echorn glucose_echorn asthma_echorn ascvd10_echorn

gen study2 = "ECHORN"
drop if gender == .

save "`datapath'/version01/2-working/Walkability/walkability_paper_001_echorn.dta", replace

*Neighbourhood Level variables
use "`datapath'/version01/2-working/Walkability/walkability_paper_001.dta", replace
keep ED Road_Foot_I_Density LUM Residential walkability  walkscore walkability_factor Area parish total_pop SES_census crime_density BD_ht ERS ERS_cat IED educ_census pop_density ln_pop_density building_density crime_pop t_income_median_us

merge m:m ED using "`datapath'/version01/2-working/Walkability/walkability_paper_001_echorn.dta", nogenerate
merge m:m ED using "`datapath'/version01/2-working/Walkability/walkability_paper_001_hotn.dta", nogenerate
merge m:m ED using "`datapath'/version01/2-working/Walkability/neighbourhood_charc_add.dta", nogenerate

gen study = .
replace study = 1 if study1 == "HoTN"
replace study = 2 if study2 == "ECHORN"
label var study "Study Type"
label define study 1"HoTN" 2"ECHORN", modify
label value study study
tab study
drop if study == .

gen sbp_combine= .
replace sbp_combine = sbp_hotn if study == 1
replace sbp_combine = sbp_echorn if study == 2

gen sbp_cbr = . 
replace sbp_cbr = 0 if sbp_combine <140
replace sbp_cbr = 1 if sbp_combine >=140 & sbp_combine!=.

gen dbp_combine= .
replace dbp_combine = dbp_hotn if study == 1
replace dbp_combine = dbp_echorn if study == 2

gen dbp_cbr = . 
replace dbp_cbr = 0 if dbp_combine <140
replace dbp_cbr = 1 if dbp_combine >=140 & dbp_combine!=.

gen tchol_combine= .
replace tchol_combine = tchol_hotn if study == 1
replace tchol_combine = tchol_echorn if study == 2

gen tchol_cbr = . 
replace tchol_cbr = 0 if tchol_combine <240
replace tchol_cbr = 1 if tchol_combine >=240 & tchol_combine!=.

gen hdl_combine= .
replace hdl_combine = hdl_hotn if study == 1
replace hdl_combine = hdl_echorn if study == 2

gen hdl_cbr = . 
replace hdl_cbr = 1 if hdl_combine <=35
replace hdl_cbr = 0 if hdl_combine >35 & hdl_combine!=.

gen ldl_combine= .
replace ldl_combine = ldl_hotn if study == 1
replace ldl_combine = ldl_echorn if study == 2

gen ldl_cbr = . 
replace ldl_cbr = 0 if ldl_combine <160
replace ldl_cbr = 1 if ldl_combine >=160 & ldl_combine!=.

gen glucose_combine= .
replace glucose_combine = glucose_hotn if study == 1
replace glucose_combine = glucose_echorn if study == 2

gen glucose_cbr = . 
replace glucose_cbr = 0 if glucose_combine <100
replace glucose_cbr = 1 if glucose_combine >=100 & glucose_combine!=.

gen hba1c_combine= .
replace hba1c_combine = hba1c_hotn if study == 1
replace hba1c_combine = hba1c_echorn if study == 2

gen hba1c_cbr = . 
replace hba1c_cbr = 0 if hba1c_combine <6.4
replace hba1c_cbr = 1 if hba1c_combine >=6.4 & hba1c_combine!=.

gen asthma_combine = .
replace asthma_combine = 0 if asthma_hotn == 0 | asthma_echorn == 0
replace asthma_combine = 1 if asthma_hotn == 1 | asthma_echorn == 1

*BMI
drop bmi
gen bmi = . 
replace bmi = bmi_hotn if bmi_hotn!=.
replace bmi = bmi_echorn if bmi_echorn!=.
label var bmi "Body Mass Index"

gen bmi_cbr = .
replace bmi_cbr = 0 if bmi<25
replace bmi_cbr = 1 if bmi>=25 & bmi!=.


*Cummulative Biological Risk
egen cbr = rowtotal(asthma_combine bmi_cbr sbp_cbr dbp_cbr tchol_cbr ldl_cbr hdl_cbr glucose_cbr hba1c_cbr)
gen cbr_cat = .
replace cbr_cat = 0 if cbr<3
replace cbr_cat = 1 if cbr>=3  & cbr!=.

*Smoking
drop smoke
gen smoke = .
replace smoke = 1 if smoke_echorn == 1 | smoke_hotn == 1
replace smoke = 0 if smoke_echorn == 0 | smoke_hotn == 0

drop walk
gen walk = .
replace walk = commute_wk_echorn if commute_wk_echorn!=.
replace walk = commute_wk if commute_wk!=.



*Age
gen age = . 
replace age = partage if partage!=.
replace age = agey if agey!=.

*Gender
gen sex_1 = . 
replace sex_1 = 1 if sex == 1 & gender == 2
replace sex_1 = 1 if sex == 1 | gender == 2
replace sex_1 = 2 if sex == 2 | gender == 1
label var sex_1 "Sex of participant"
label define sex_1 1"Female" 2"Male", modify
label value sex_1 sex_1

*Car ownership/Use
drop car
gen car = . 
replace car = car_echorn if car_echorn!=.
replace car = car_hotn if car_hotn!=.
label var car "Car ownership/Use car for commuting"
label define car 0"No" 1"Yes", modify
label value car car

*Education
gen education_1 = . 
replace education_1 = 1 if education == 1 | educ_new == 1
replace education_1 = 2 if education == 2 | educ_new == 2
replace education_1 = 3 if education == 3 | education ==4 | educ_new == 3
label var education_1 "Education"
label define education_1 1"Primary/Less" 2"Secondary" 3"Tertiary", modify
label value education_1 education_1

*Underweight
gen under = .
replace under = 0 if bmi >=18.5 & bmi!=.
replace under = 1 if bmi<18.5
label var under "Underweight"

*Overweight
drop over
gen over = .
replace over = 0 if bmi<25
replace over = 1 if bmi >=25 & bmi<30 & bmi!=.
label var over "Overweight"

*Obesity
drop obese
gen obese = .
replace obese = 0 if bmi<30
replace obese = 1 if bmi >=30 & bmi!=.
label var obese "Obesity"

*American Heart Association CVD Risk Score (%)
gen ascvd10 = .
replace ascvd10 = ascvd10_hotn if study == 1
replace ascvd10 = ascvd10_echorn if study == 2
label var ascvd10 "AHA CVD Risk Score (%)"

*Age Categories
gen age_cat = . 
replace age_cat = 1 if age <60
replace age_cat = 2 if age>=60 & age!=.
label var age_cat "Age Categories"
label define age_cat 1"<60" 2">=60"
label value age_cat age_cat

*SES Categories
xtile SES_cat = SES_census, nq(10)
recode SES_cat (1/4=1) (5/6=2) (7/10=3)
label var SES_cat "SES Categories"
label define SES_cat 1"Low" 2"Medium" 3"High"
label value SES_cat SES_cat



/*
xtile walk_3 = walkability, nq(3)
label define walk_3 1"Low" 2"Medium" 3"High"
label value walk_3 walk_3
zinb walk i.walk_3 , inflate(i.walk_3) nolog irr cformat(%9.2f) vce(cluster ED)
zinb walk i.walk_3 i.sex_1 age bmi car i.education_1 SES_census Area smoke, inflate(i.walk_3 sex_1 age bmi car i.education_1 SES_census Area smoke) nolog irr cformat(%9.2f) vce(cluster ED)
*/
cls

*Create walkability tertiles
xtile walk_3 = walkability, nq(3)
label var walk_3 "Walkability Categories"
label define walk_3 1"Low" 2"Medium" 3"High"
label value walk_3 walk_3


*Rounding off age to 0 decimal places
replace age = round(age, 1.0)

{
*Creating age groups
gen agegr = . 
replace agegr = 25 if age>=25 & age<30 & age!=.
replace agegr = 30 if age>=30 & age<35 & age!=.
replace agegr = 35 if age>=35 & age<40 & age!=.
replace agegr = 40 if age>=40 & age<45 & age!=.
replace agegr = 45 if age>=45 & age<50 & age!=.
replace agegr = 50 if age>=50 & age<55 & age!=.
replace agegr = 55 if age>=55 & age<60 & age!=.
replace agegr = 60 if age>=60 & age<65 & age!=.
replace agegr = 65 if age>=65 & age<70 & age!=.
replace agegr = 70 if age>=70 & age<75 & age!=.
replace agegr = 75 if age>=75 & age<80 & age!=.
replace agegr = 80 if age>=80 & age<85 & age!=.
replace agegr = 85 if age>=85 & age!=.

label var agegr "Age Groups"
label define agegr 25"25-29" 30"30-34" 35"35-39" 40"40-44" 45"45-49" 50"50-54" ///
				  55"55-59" 60"60-64" 65"65-69" 70"70-74" 75"75-79" 80"80-84" ///
				  85"85+"
label value agegr agegr

*Creating Strata Regions
drop region
gen region = . 
replace region = 1 if parish == 8 // St. Michael
replace region = 2 if parish == 1 | parish == 10 // Christ Church & St. Phillip
replace region = 3 if parish == 3 | parish == 4 | parish == 11 // St.George, St.James, St.Thomas
replace region = 4 if parish == 5 | parish == 6 | parish == 7 | parish == 9

label var region "FOUR major Barbados regions"
label define region 1"One" 2"Two" 3"Three" 4"Four", modify
label value region region			

*Creating Poststratification categories based on age and sex
gen poststrata = .
*Female
replace poststrata = 1 if agegr == 25 & sex_1 == 1
replace poststrata = 3 if agegr == 30 & sex_1 == 1
replace poststrata = 5 if agegr == 35 & sex_1 == 1
replace poststrata = 7 if agegr == 40 & sex_1 == 1
replace poststrata = 9 if agegr == 45 & sex_1 == 1
replace poststrata = 11 if agegr == 50 & sex_1 == 1
replace poststrata = 13 if agegr == 55 & sex_1 == 1
replace poststrata = 15 if agegr == 60 & sex_1 == 1
replace poststrata = 17 if agegr == 65 & sex_1 == 1
replace poststrata = 19 if agegr == 70 & sex_1 == 1
replace poststrata = 21 if agegr == 75 & sex_1 == 1
replace poststrata = 23 if agegr == 80 & sex_1 == 1
replace poststrata = 25 if agegr == 85 & sex_1 == 1
*Male
replace poststrata = 2 if agegr == 25 & sex_1 == 2
replace poststrata = 4 if agegr == 30 & sex_1 == 2
replace poststrata = 6 if agegr == 35 & sex_1 == 2
replace poststrata = 8 if agegr == 40 & sex_1 == 2
replace poststrata = 10 if agegr == 45 & sex_1 == 2
replace poststrata = 12 if agegr == 50 & sex_1 == 2
replace poststrata = 14 if agegr == 55 & sex_1 == 2
replace poststrata = 16 if agegr == 60 & sex_1 == 2
replace poststrata = 18 if agegr == 65 & sex_1 == 2
replace poststrata = 20 if agegr == 70 & sex_1 == 2
replace poststrata = 22 if agegr == 75 & sex_1 == 2
replace poststrata = 24 if agegr == 80 & sex_1 == 2
replace poststrata = 26 if agegr == 85 & sex_1 == 2

*Creation of poststratification weights based on US 2021 census and WHO 2000 standard population

*add in weight based on US census bureau 2021
gen UScb2021=.

**BARBADOS
*women
replace UScb2021 = 1.75386611008205 if sex_1==1 & agegr==25
replace UScb2021 = 1.23704966958005 if sex_1==1 & agegr==30
replace UScb2021 = 0.994962425785737 if sex_1==1 & agegr==35
replace UScb2021 = 0.407421616949035 if sex_1==1 & agegr==40
replace UScb2021 = 0.503960409574977 if sex_1==1 & agegr==45
replace UScb2021 = 0.418291765126915 if sex_1==1 & agegr==50
replace UScb2021 = 0.401135667178276 if sex_1==1 & agegr==55
replace UScb2021 = 0.491007395863238 if sex_1==1 & agegr==60
replace UScb2021 = 0.577571329525073 if sex_1==1 & agegr==65
replace UScb2021 = 0.469501956029375 if sex_1==1 & agegr==70
replace UScb2021 = 0.546536888572776 if sex_1==1 & agegr==75
replace UScb2021 = 0.499388788948023 if sex_1==1 & agegr==80
replace UScb2021 = 0.860908302221529 if sex_1==1 & agegr==85 
*men
replace UScb2021 = 3.44869002626353 if sex_1==2 & agegr==25
replace UScb2021 = 2.61922395998423 if sex_1==2 & agegr==30
replace UScb2021 = 1.75495481132358 if sex_1==2 & agegr==35
replace UScb2021 = 0.797262830032208 if sex_1==2 & agegr==40
replace UScb2021 = 0.860287453371113 if sex_1==2 & agegr==45
replace UScb2021 = 0.806923805452884 if sex_1==2 & agegr==50
replace UScb2021 = 0.892891635130874 if sex_1==2 & agegr==55
replace UScb2021 = 0.718281281528148 if sex_1==2 & agegr==60
replace UScb2021 = 0.700812378039498 if sex_1==2 & agegr==65
replace UScb2021 = 0.743505347415019 if sex_1==2 & agegr==70
replace UScb2021 = 0.567784910202251 if sex_1==2 & agegr==75
replace UScb2021 = 0.518613469542925 if sex_1==2 & agegr==80
replace UScb2021 = 1.17881621933252 if sex_1==2 & agegr==85

*add in weight based on WHO 2000 standard population
gen WHO2000=.

replace WHO2000 = 4.23310361762209 if sex_1==1 & agegr==25
replace WHO2000 = 2.79699203904763 if sex_1==1 & agegr==30
replace WHO2000 = 1.97904701274617 if sex_1==1 & agegr==35
replace WHO2000 = 0.790094919294022 if sex_1==1 & agegr==40
replace WHO2000 = 0.825711903101888 if sex_1==1 & agegr==45
replace WHO2000 = 0.565236383539727 if sex_1==1 & agegr==50
replace WHO2000 = 0.476686869110167 if sex_1==1 & agegr==55
replace WHO2000 = 0.508551039658779 if sex_1==1 & agegr==60
replace WHO2000 = 0.557674047055632 if sex_1==1 & agegr==65
replace WHO2000 = 0.505593557685708 if sex_1==1 & agegr==70
replace WHO2000 = 0.587557692753713 if sex_1==1 & agegr==75
replace WHO2000 = 0.485765988907454 if sex_1==1 & agegr==80
replace WHO2000 = 0.618986811194401 if sex_1==1 & agegr==85

*Men
replace WHO2000 = 8.46625242884291 if sex_1==2 & agegr==25
replace WHO2000 = 5.8833079498102 if sex_1==2 & agegr==30
replace WHO2000 = 3.56228265093616 if sex_1==2 & agegr==35
replace WHO2000 = 1.58868681414052 if sex_1==2 & agegr==40
replace WHO2000 = 1.44060600856731 if sex_1==2 & agegr==45
replace WHO2000 = 1.12519172261195 if sex_1==2 & agegr==50
replace WHO2000 = 1.12099889624724 if sex_1==2 & agegr==55
replace WHO2000 = 0.834024617178217 if sex_1==2 & agegr==60
replace WHO2000 = 0.819297784297715 if sex_1==2 & agegr==65
replace WHO2000 = 1.0542183042827 if sex_1==2 & agegr==70
replace WHO2000 = 0.896797488967031 if sex_1==2 & agegr==75
replace WHO2000 = 0.887051965648669 if sex_1==2 & agegr==80
replace WHO2000 = 2.03382230478509 if sex_1==2 & agegr==85
}

save "`datapath'/version01/2-working/Walkability/walkability_paper_001_combine.dta", replace

*-------------------------------------------------------------------------

cls

foreach x in Residential LUM Road_Foot_I_Density walkability {
	
	zscore `x'
	zinb walk z_`x' , inflate(z_`x') nolog irr cformat(%9.2f) vce(cluster ED)

	zinb walk z_`x' i.sex_1 age bmi car i.education_1 SES_census Area smoke, inflate(z_`x' sex_1 age bmi car i.education_1 SES_census Area smoke) nolog irr cformat(%9.2f) vce(cluster ED)
	
}

cls

*Table 1 - Descriptives (Individual Characteristics)
**Gender
tab sex_1 if walk!=., gen(sex)
tab sex walk_3 if walk!=., chi2 nofreq
*Female
proportion sex1 if walk!=., cformat(%9.2f) percent
proportion sex1 if walk!=., over(walk_3) cformat(%9.2f) percent
oneway sex1 walk_3 if walk!=.
*Male
proportion sex2 if walk!=., cformat(%9.2f) percent
proportion sex2 if walk!=., over(walk_3) cformat(%9.2f) percent
oneway sex2 walk_3 if walk!=.
**Age
mean age if walk!=. , cformat(%9.2f)
mean age if walk!=., over(walk_3) cformat(%9.2f)
oneway age walk_3 if walk!=.
**Education
tab education_1 if walk!=., gen(education)
tab education_1 walk_3 if walk!=., chi2 nofreq
*Primary
proportion education1 if walk!=., cformat(%9.2f) percent
proportion education1 if walk!=., over(walk_3) cformat(%9.2f) percent
oneway education1 walk_3 if walk!=.
*Secondary
proportion education2 if walk!=., cformat(%9.2f) percent
proportion education2 if walk!=., over(walk_3) cformat(%9.2f) percent
oneway education2 walk_3 if walk!=.
*Tertiary
proportion education3 if walk!=., cformat(%9.2f) percent
proportion education3 if walk!=., over(walk_3) cformat(%9.2f) percent
oneway education3 walk_3 if walk!=.
**BMI
mean bmi if walk!=. , cformat(%9.2f)
mean bmi if walk!=., over(walk_3) cformat(%9.2f)
oneway bmi walk_3 if walk!=.
*Underweight
proportion under if walk!=., cformat(%9.2f) percent
proportion under if walk!=., over(walk_3) cformat(%9.2f) percent
oneway under walk_3 if walk!=.
*Overweight
proportion over if walk!=., cformat(%9.2f) percent
proportion over if walk!=., over(walk_3) cformat(%9.2f) percent
oneway over walk_3 if walk
*Obese
proportion obese if walk!=., cformat(%9.2f) percent
proportion obese if walk!=., over(walk_3) cformat(%9.2f) percent
oneway obese walk_3 if walk!=.
**Smoking
proportion smoke if walk!=., cformat(%9.2f) percent
proportion smoke if walk!=., over(walk_3) cformat(%9.2f) percent
oneway smoke walk_3 if walk!=.
**Overall walking
mean walk if walk!=. , cformat(%9.2f)
mean walk if walk!=., over(walk_3) cformat(%9.2f)
oneway walk walk_3 if walk!=.


*Table 1 - Descriptives (Neighbourhood Characteristics)

*-------------------------------------------------------------------------------
**Neighbourhood Size
mean Area if walk!=. , cformat(%9.2f)
mean Area if walk!=., over(walk_3) cformat(%9.2f)
oneway Area walk_3 if walk!=.

**Population density
mean pop_density if walk!=. , cformat(%9.2f)
mean pop_density if walk!=., over(walk_3) cformat(%9.2f)
oneway pop_density walk_3 if walk!=.

**Socioeconomic Status
mean SES_census if walk!=. , cformat(%9.2f)
mean SES_census if walk!=., over(walk_3) cformat(%9.2f)
oneway SES_census walk_3 if walk!=.

**Residential Density
mean Residential if walk!=. , cformat(%9.2f)
mean Residential if walk!=., over(walk_3) cformat(%9.2f)
oneway Residential walk_3 if walk!=.

**Street Connectivity
mean Road_Foot_I_Density if walk!=. , cformat(%9.2f)
mean Road_Foot_I_Density if walk!=., over(walk_3) cformat(%9.2f)
oneway Road_Foot_I_Density walk_3 if walk!=.

**Bus Stop Density
mean Bus_Stop_Density if walk!=. , cformat(%9.2f)
mean Bus_Stop_Density if walk!=., over(walk_3) cformat(%9.2f)
oneway Bus_Stop_Density walk_3 if walk!=.

**Traffic Calming Features
mean traffic_calm if walk!=. , cformat(%9.2f)
mean traffic_calm if walk!=., over(walk_3) cformat(%9.2f)
oneway traffic_calm walk_3 if walk!=.

**Land Use Mix
mean LUM if walk!=. , cformat(%9.2f)
mean LUM if walk!=., over(walk_3) cformat(%9.2f)
oneway LUM walk_3 if walk!=.

**Green Space Density
mean Greenspace_Density if walk!=. , cformat(%9.2f)
mean Greenspace_Density if walk!=., over(walk_3) cformat(%9.2f)
oneway Greenspace_Density walk_3 if walk!=.

**Destination_Density
mean Destination_Density if walk!=. , cformat(%9.2f)
mean Destination_Density if walk!=., over(walk_3) cformat(%9.2f)
oneway Destination_Density walk_3 if walk!=.

**Ligthing Density
mean light_density if walk!=. , cformat(%9.2f)
mean light_density if walk!=., over(walk_3) cformat(%9.2f)
oneway light_density walk_3 if walk!=.

**Parking Density
mean parking_density if walk!=. , cformat(%9.2f)
mean parking_density if walk!=., over(walk_3) cformat(%9.2f)
oneway parking_density walk_3 if walk!=.

*-------------------------------------------------------------------------------

*Regression Model

*Undadjusted Model
foreach x of varlist walkability Residential Road_Foot_I_Density Bus_Stop_Density traffic_calm LUM Greenspace_Density Destination_Density light_density parking_density {
	
	zinb walk `x' , inflate(`x') irr cformat(%9.2f) nolog vce(cluster ED)
}
	zinb walk i.walk_3 if walk_3!=2, inflate(i.walk_3) irr cformat(%9.2f) nolog vce(cluster ED)
	
*-------------------------------------------------------------------------------
*Indivdual characteristics adjusted Model (Model 1)
foreach x of varlist walkability Residential Road_Foot_I_Density Bus_Stop_Density traffic_calm LUM Greenspace_Density Destination_Density light_density parking_density {
	
	zinb walk `x' i.sex_1 age bmi car i.education_1 smoke sbp_combine dbp_combine, inflate(`x' i.sex_1 age bmi car i.education_1 smoke sbp_combine dbp_combine) irr cformat(%9.2f) nolog vce(cluster ED)
}
	zinb walk i.walk_3 i.sex_1 age bmi car i.education_1 smoke sbp_combine dbp_combine if walk_3!=2, inflate(i.walk_3 i.sex_1 age bmi car i.education_1 smoke sbp_combine dbp_combine) irr cformat(%9.2f) nolog vce(cluster ED)
	
*-------------------------------------------------------------------------------
*Neighbourhood characteristics & Model 1 adjusted Model (Model 2)	
foreach x of varlist walkability Residential Road_Foot_I_Density Bus_Stop_Density traffic_calm LUM Greenspace_Density Destination_Density light_density parking_density {
	
	zinb walk `x' i.sex_1 age bmi car i.education_1 smoke sbp_combine dbp_combine SES_census Area, inflate(`x' i.sex_1 age bmi car i.education_1 smoke sbp_combine dbp_combine SES_census Area) irr cformat(%9.2f) nolog vce(cluster ED)
}
	zinb walk i.walk_3 i.sex_1 age bmi car i.education_1 smoke SES_census Area sbp_combine dbp_combine if walk_3!=2, inflate(i.walk_3 i.sex_1 age bmi car i.education_1 smoke sbp_combine dbp_combine SES_census Area) irr cformat(%9.2f) nolog vce(cluster ED)

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
cls
*CBR Models (Unadjusted) - Results presented as logistic and multi-levle models.
foreach x of varlist walkability Residential Road_Foot_I_Density Bus_Stop_Density traffic_calm LUM Greenspace_Density Destination_Density light_density parking_density {
	
	logistic cbr_cat `x', nolog vce(cluster ED)
	meqrlogit cbr_cat `x' || ED:, nolog or
	
}
	logistic cbr_cat i.walk_3 if walk_3!=2, nolog vce(cluster ED)
	meqrlogit cbr_cat i.walk_3 || ED: if walk_3!=2, nolog or
	
	
/*
References

https://www.academia.edu/55090104/Neighbourhood_characteristics_and_cumulative_biological_risk_evidence_from_the_Jamaica_Health_and_Lifestyle_Survey_2008_a_cross_sectional_study?email_work_card=view-paper

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3530361/

https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3428227/ 

*/

*CVD Risk

*Overall
regress ascvd10 walkability walk i.sex_1 age i.education_1 bmi car SES_census, vce(cluster ED) cformat(%9.2f)
margins, at(walkability=(-3(2)17))

#delimit ;
marginsplot, 
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index) 
	title(Overall, color(black))
	ylab(, angle(horizontal) nogrid)
	plotopts(mcolor(black) lcolor(black) msize(tiny))
	ciopts(lcolor(black))
	name(g1, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr
*-------------------------------------------------------------------------------

*Sex
regress ascvd10 walkability walk i.sex_1 i.age_cat i.education_1 bmi car SES_census, vce(cluster ED) cformat(%9.2f)
margins sex_1, at(walkability=(-3(2)17))

#delimit ;
marginsplot, 
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index) 
	title(Sex, color(black))
	ylab(, angle(horizontal) nogrid)
	
	plot1opts(mcolor("255 152 150") lcolor("255 152 150") msize(tiny))
	ci1opts(lcolor("255 152 150"))
	
	plot2opts(mcolor("214 39 40") lcolor("214 39 40") msize(tiny))
	ci2opts(lcolor("214 39 40"))
	
	name(g2, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr

*-------------------------------------------------------------------------------

*Age Categories
regress ascvd10 walkability walk i.sex_1 i.age_cat i.education_1 bmi car SES_census, vce(cluster ED) cformat(%9.2f)
margins age_cat, at(walkability=(-3(2)17))

#delimit ;
marginsplot, 
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index) 
	title(Age Categories, color(black))
	ylab(, angle(horizontal) nogrid)
	
	plot1opts(mcolor("255 187 120") lcolor("255 187 120") msize(tiny))
	ci1opts(lcolor("255 187 120"))
	
	plot2opts(mcolor("255 127 14") lcolor("255 127 14") msize(tiny))
	ci2opts(lcolor("255 127 14"))
	
	name(g3, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr

*-------------------------------------------------------------------------------

*SES Categories
regress ascvd10 walkability walk i.sex_1 i.age_cat i.education_1 bmi car i.SES_cat, vce(cluster ED) cformat(%9.2f)
margins SES_cat if SES_cat!=2, at(walkability=(-3(2)17))

#delimit ;
marginsplot, 
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index) 
	title(SES, color(black))
	ylab(, angle(horizontal) nogrid)
	
	plot1opts(mcolor("152 223 138") lcolor("152 223 138") msize(tiny))
	ci1opts(lcolor("152 223 138"))
	
	plot2opts(mcolor("44 160 44") lcolor("44 160 44") msize(tiny))
	ci2opts(lcolor("44 160 44"))
	
	name(g4, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr

*-------------------------------------------------------------------------------
*Combining graphs
#delimit ;
graph combine g1 g2 g3 g4, 
	ycommon
	name(g5, replace)
			
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr	
*-------------------------------------------------------------------------------

*Age and Sex Interaction
regress ascvd10 walkability walk i.sex_1##i.age_cat i.education_1 bmi car SES_census, vce(cluster ED) cformat(%9.2f)
margins age_cat if sex_1 == 1, at(walkability=(-3(2)17))

#delimit ;
marginsplot, 
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index) 
	title(Female, color(black))
	ylab(, angle(horizontal) nogrid)
	
	plot1opts(mcolor("255 187 120") lcolor("255 187 120") msize(tiny))
	ci1opts(lcolor("255 187 120"))
	
	plot2opts(mcolor("255 127 14") lcolor("255 127 14") msize(tiny))
	ci2opts(lcolor("255 127 14"))
	
	name(g6, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr

margins age_cat if sex_1 == 2, at(walkability=(-3(2)17))

#delimit ;
marginsplot, 
	ytitle(10-year CVD Risk (%)) xtitle(Walkability Index) 
	title(Male, color(black))
	ylab(, angle(horizontal) nogrid)
	
	plot1opts(mcolor("255 187 120") lcolor("255 187 120") msize(tiny))
	ci1opts(lcolor("255 187 120"))
	
	plot2opts(mcolor("255 127 14") lcolor("255 127 14") msize(tiny))
	ci2opts(lcolor("255 127 14"))
	
	name(g7, replace)
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr

#delimit ;
graph combine g6 g7, 
	ycommon
	name(g8, replace)
	title("CVD Risk and Neighbourhood Walkability" "Sex and Age Group Interaction", color(black))
	
	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)
	plotregion(style(none))
	;
#delimit cr	



