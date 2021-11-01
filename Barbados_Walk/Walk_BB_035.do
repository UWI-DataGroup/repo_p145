
clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_035.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	13/10/2021
**	Date Modified: 	22/10/2021
**  Algorithm Task: Creating survey weighted estimates and Population graphs for Individual Data analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*MAC OS 
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p145"
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - data_p120"

**********************************
** WHO WORLD STANDARD POPULATION
**********************************

** (2) Standard World population (WHO 2002 standard)
** REFERENCE
** Age-standardization of rates: A new WHO-standard, 2000
** Ahmad OB, Boschi-Pinto C, Lopez AD, Murray CJL, Lozano R, Inoue M.
** GPE Discussion paper Series No: 31
** EIP/GPE/EBD. World Health Organization

** An important practical reason for choosing the WHO world standard population over other standards 
** (eg. US Standard Population 2000) is that this is the only standard population to be offered
** in 21 categories - and so adequately covering the elderly in fine detail
** The US/European oldest age category = 85+
** The World population offers 85-89, 90-94, 95-99, 100+ 
** More appropriate for this elderly disease, perhaps?

*Barbados
import delimited "`echornpath'/version02/1-input/BB_US.csv", clear

gen age = real(regexs(1)) if regexm(ïagegroupyearsofage,"([0-9]+)")
drop ïagegroupyearsofage
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

rename malepopulation pop1
rename femalepopulation pop2
tabstat pop1 pop2, stat(sum)

keep if agegr !=.

reshape long pop, i(age) j(sex_1)
collapse (sum) pop, by(agegr sex_1)
drop if agegr == .
gen totpop = .
replace totpop = 143013 if sex_1 == 1
replace totpop = 152865 if sex_1 == 2

gen WHO_pop = . 
replace WHO_pop =7.93 if agegr == 25
replace WHO_pop =7.61 if agegr == 30
replace WHO_pop =7.15 if agegr == 35
replace WHO_pop =6.69 if agegr == 40
replace WHO_pop =6.04 if agegr == 45
replace WHO_pop =5.37 if agegr == 50
replace WHO_pop =4.55 if agegr == 55
replace WHO_pop =3.72 if agegr == 60
replace WHO_pop =2.96 if agegr == 65
replace WHO_pop =2.21 if agegr == 70
replace WHO_pop =1.52 if agegr == 75
replace WHO_pop =0.91  if agegr == 80
replace WHO_pop =0.63  if agegr == 85
gen totpop_WHO = 100

gen pop_who = .
replace pop_who = WHO_pop/totpop_WHO

gen pop_us = .
replace pop_us = pop/totpop 
gen cid = 52
egen id = seq()

*Save dataset
save "`echornpath'/version02/1-input/BB_US.dta", replace


*Load in combined sample data for population estimates
use"`datapath'/version01/2-working/Walkability/walkability_paper_001_combine.dta", clear

*Round off Age variable
replace age = round(age, 1.0)

drop agegr
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
label define agegr 25"25-29" 30"30-34" 35"35-39" 40"40-44" 45"45-49" ///
				   50"50-54" 55"55-59" 60"60-64" 65"65-69" 70"70-74" ///
				   75"75-79" 80"80-84" 85"85+", modify
label value agegr agegr 		   

keep  age sex_1 agegr
gen pop = 1
collapse (sum) pop, by(agegr sex_1)
gen sp1 = .
replace sp1 = 2242

gen percsample = (pop/sp1)


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

*Minor cleaning
sort agegr sex_1
egen id = seq()
order id 

*Merge in US census bureau estimates (IDB)
merge 1:1 id using "`echornpath'/version02/1-input/BB_US.dta", nogenerate

*Remove ID
drop id 

preserve

keep pop pop_us pop_who percsample UScb2021 WHO2000 agegr sex_1

reshape wide pop pop_us pop_who percsample UScb2021 WHO2000, i(agegr) j(sex_1)

gen zero = 0
gen sp1 = .
replace sp1 = 2242

gen pop1_per = pop1/sp1 // Sample Female
gen pop2_per = pop2/sp1 // Sample Male

replace pop2_per = -pop2_per
replace pop_us2 = -pop_us2
replace pop_who2 = -pop_who2

label var agegr "Age Groups"
label define agegr 25"25-29" 30"30-34" 35"35-39" 40"40-44" 45"45-49" ///
				   50"50-54" 55"55-59" 60"60-64" 65"65-69" 70"70-74" ///
				   75"75-79" 80"80-84" 85"85+", modify
label value agegr agegr 

#delimit ;
	twoway 
	/// men 
	(bar pop2_per agegr, horizontal lw(thin) lc(gs11) fc("23 190 207") fintensity(30) barwidth(5) lcolor(gs4)lwidth(vthin)) ||
	/// women
	(bar pop1_per agegr, horizontal lw(thin) lc(gs11) fc("227 119 194") fintensity(30) barwidth(5) lcolor(gs4) lwidth(vthin)) ||
	/// men (age<40)
	(bar pop2_per agegr if agegr<40, horizontal lw(thin) lc(gs11) fc("23 190 207") fintensity(80) barwidth(5) lcolor(gs4)lwidth(vthin)) ||
	/// women (age<40)
	(bar pop1_per agegr if agegr<40, horizontal lw(thin) lc(gs11) fc("227 119 194") fintensity(80) barwidth(5) lcolor(gs4) lwidth(vthin)) ||

	/// WHO 2000 Estimates
	(connect agegr pop_who1, symbol(O) mc(gs0) lc(gs0))
	(connect agegr pop_who2, symbol(O) mc(gs0) lc(gs0))

	(sc agegr zero, mlabel(agegr) mlabcolor(black) msymbol(i) mlabposition(0))
	, 

	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(fcolor(gs16) lcolor(black) lwidth(thin) lpattern(solid)) ysize(3) 

	title("Unadjusted", c(black))
	name(Unadjusted, replace)
	xtitle("Percentage (%) of Residents", size(small)) ytitle("")
	plotregion(style(none))
	ysca(noline) ylabel(none)
	xsca(noline titlegap(0.5))
	xlabel( 0.03 "3" 0.05 "5" 0.07 "7" 0.10 "10" 0 "0" -0.03 "3" -0.05 "5" -0.07 "7" -0.10 "10", tlength(0) 
	nogrid )
	legend(size(small) position(12) bm(t=1 b=0 l=0 r=0) colf cols(5)
	region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(1 2 3 4 5)
	lab(2 "Females")
	lab(1 "Males") 
	lab(3 "Male (HoTN)")
	lab(4 "Females (HoTN)")
	lab(5 "WHO 2000")
	
	
	);
#delimit cr
restore
*-------------------------------------------------------------------------------
gen pop_combine = pop/sp1
gen weight = pop_us/pop_combine    // US census 2011
gen weight_who = pop_who/pop_combine   //WHO 2000


*Survey Weighted Analysis

*Set dataset as complex survey using previously derived weights
svyset _n [pweight=weight], vce(linearized) singleunit(missing)
svy linearized : total pop, over(agegr sex_1)

*Using population estimates produced above create new variable with new estimates
gen pop_adjust = .

replace pop_adjust = 159.2459 if sex_1==1 & agegr==25
replace pop_adjust = 168.8245 if sex_1==1 & agegr==30
replace pop_adjust = 160.2963 if sex_1==1 & agegr==35
replace pop_adjust = 177.1803 if sex_1==1 & agegr==40
replace pop_adjust = 188.452 if sex_1==1 & agegr==45
replace pop_adjust = 176.1926 if sex_1==1 & agegr==50
replace pop_adjust = 157.8193 if sex_1==1 & agegr==55
replace pop_adjust = 124.694 if sex_1==1 & agegr==60
replace pop_adjust = 78.35313 if sex_1==1 & agegr==65
replace pop_adjust = 53.3328 if sex_1==1 & agegr==70
replace pop_adjust = 33.72101 if sex_1==1 & agegr==75
replace pop_adjust = 21.08543 if sex_1==1 & agegr==80
replace pop_adjust = 16.46074 if sex_1==1 & agegr==85

replace pop_adjust = 148.3813 if sex_1==2 & agegr==25
replace pop_adjust = 159.0292 if sex_1==2 & agegr==30
replace pop_adjust = 152.532 if sex_1==2 & agegr==35
replace pop_adjust = 167.6825 if sex_1==2 & agegr==40
replace pop_adjust = 179.7384 if sex_1==2 & agegr==45
replace pop_adjust = 171.5985 if sex_1==2 & agegr==50
replace pop_adjust = 162.3439 if sex_1==2 & agegr==55
replace pop_adjust = 136.0761 if sex_1==2 & agegr==60
replace pop_adjust = 91.48985 if sex_1==2 & agegr==65
replace pop_adjust = 68.99139 if sex_1==2 & agegr==70
replace pop_adjust = 50.67288 if sex_1==2 & agegr==75
replace pop_adjust = 35.99168 if sex_1==2 & agegr==80
replace pop_adjust = 35.94768 if sex_1==2 & agegr==85

*Population estimates using the WHO standard population
svyset _n [pweight=weight_who], vce(linearized) singleunit(missing)
svy linearized : total pop, over(agegr sex_1)

gen pop_adjust_who = .

replace pop_adjust_who =177.7906 if sex_1==1 & agegr==25
replace pop_adjust_who =170.6162 if sex_1==1 & agegr==30
replace pop_adjust_who =160.303 if sex_1==1 & agegr==35
replace pop_adjust_who =149.9898 if sex_1==1 & agegr==40
replace pop_adjust_who =135.4168 if sex_1==1 & agegr==45
replace pop_adjust_who =120.3954 if sex_1==1 & agegr==50
replace pop_adjust_who =102.011 if sex_1==1 & agegr==55
replace pop_adjust_who =83.4024 if sex_1==1 & agegr==60
replace pop_adjust_who =66.3632 if sex_1==1 & agegr==65
replace pop_adjust_who =49.5482 if sex_1==1 & agegr==70
replace pop_adjust_who =34.0784 if sex_1==1 & agegr==75
replace pop_adjust_who =20.4022 if sex_1==1 & agegr==80
replace pop_adjust_who =14.1246 if sex_1==1 & agegr==85

replace pop_adjust_who =177.7906 if sex_1==2 & agegr==25
replace pop_adjust_who =170.6162 if sex_1==2 & agegr==30
replace pop_adjust_who =160.303 if sex_1==2 & agegr==35
replace pop_adjust_who =149.9898 if sex_1==2 & agegr==40
replace pop_adjust_who =135.4168 if sex_1==2 & agegr==45
replace pop_adjust_who =120.3954 if sex_1==2 & agegr==50
replace pop_adjust_who =102.011 if sex_1==2 & agegr==55
replace pop_adjust_who =83.4024 if sex_1==2 & agegr==60
replace pop_adjust_who =66.3632 if sex_1==2 & agegr==65
replace pop_adjust_who =49.5482 if sex_1==2 & agegr==70
replace pop_adjust_who =34.0784 if sex_1==2 & agegr==75
replace pop_adjust_who =20.4022 if sex_1==2 & agegr==80
replace pop_adjust_who =14.1246 if sex_1==2 & agegr==85



*Creating Survey Weight adjusted Population Pyramids 
preserve

keep pop pop_us pop_who pop_adjust pop_adjust_who percsample UScb2021 WHO2000 agegr sex_1

reshape wide pop pop_adjust pop_adjust_who pop_us pop_who percsample UScb2021 WHO2000 ///
		, i(agegr) j(sex_1)

gen zero = 0
gen sp1 = .
replace sp1 = 2242		
		
gen pop1_per = pop_adjust1/sp1 // Adjusted Male
gen pop2_per = pop_adjust2/sp1 // Adjusted Female

**********************************************************
gen pop1_per_who = pop_adjust_who1/sp1 // WHO 2000 Adjusted Male
gen pop2_per_who = pop_adjust_who2/sp1 // WHO 2000 Adjusted Female

replace pop2_per = -pop2_per
replace pop2_per_who = -pop2_per_who
replace pop_us2 = -pop_us2
replace pop_who2 = -pop_who2


#delimit ;
	twoway 
	/// men 
	(bar pop2_per agegr, horizontal lw(thin) lc(gs11) fc("23 190 207") fintensity(30) barwidth(5) lcolor(gs4)lwidth(vthin)) ||
	/// women
	(bar pop1_per agegr, horizontal lw(thin) lc(gs11) fc("227 119 194") fintensity(30) barwidth(5) lcolor(gs4) lwidth(vthin)) ||
	/// US Census Estimates
	(connect agegr pop_us1, symbol(T) mc(gs0) lc(gs0))
	(connect agegr pop_us2, symbol(T) mc(gs0) lc(gs0))

	(sc agegr zero, mlabel(agegr) mlabcolor(black) msymbol(i) mlabposition(0))
	, 

	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(fcolor(gs16) lcolor(black) lwidth(thin) lpattern(solid)) ysize(3) 

	title("US Census 2021 Adjusted", c(black))
	name(Adjusted, replace)
	xtitle("Percentage of Residents", size(small)) ytitle("")
	plotregion(style(none))
	ysca(noline) ylabel(none)
	xsca(noline titlegap(0.5))
	xlabel( 0.03 "3" 0.05 "5" 0.07 "7" 0.10 "10" 0 "0" -0.03 "3" -0.05 "5" -0.07 "7" -0.10 "10", tlength(0) 
	nogrid )
	legend(size(small) position(12) bm(t=1 b=0 l=0 r=0) colf cols(4)
	region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(1 2 3 )
	lab(2 "Females")
	lab(1 "Males") 
	lab(3 "US Census 2021")
	
	
	);
#delimit cr

*************************

#delimit ;
	twoway 
	/// men 
	(bar pop2_per_who agegr, horizontal lw(thin) lc(gs11) fc("23 190 207") fintensity(30) barwidth(5) lcolor(gs4)lwidth(vthin)) ||
	/// women
	(bar pop1_per_who agegr, horizontal lw(thin) lc(gs11) fc("227 119 194") fintensity(30) barwidth(5) lcolor(gs4) lwidth(vthin)) ||
	/// WHO 2000 Estimates
	(connect agegr pop_who1, symbol(O) mc(gs0) lc(gs0))
	(connect agegr pop_who2, symbol(O) mc(gs0) lc(gs0))

	(sc agegr zero, mlabel(agegr) mlabcolor(black) msymbol(i) mlabposition(0))
	, 

	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(fcolor(gs16) lcolor(black) lwidth(thin) lpattern(solid)) ysize(3) 

	title("WHO 2000 Adjusted", c(black))
	name(Adjusted_WHO, replace)
	xtitle("Percentage (%) of Residents", size(small)) ytitle("")
	plotregion(style(none))
	ysca(noline) ylabel(none)
	xsca(noline titlegap(0.5))
	xlabel( 0.03 "3" 0.05 "5" 0.07 "7" 0.10 "10" 0 "0" -0.03 "3" -0.05 "5" -0.07 "7" -0.10 "10", tlength(0) 
	nogrid )
	legend(size(small) position(12) bm(t=1 b=0 l=0 r=0) colf cols(4)
	region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(1 2 3 )
	lab(2 "Females")
	lab(1 "Males") 
	lab(3 "WHO 2000")
	
	
	);
#delimit cr
restore


*Combine unadjusted and adjusted graphs

#delimit;
graph combine Unadjusted Adjusted Adjusted_WHO, 
			col(3)
			name(Combined, replace) title("Population Pyramids for Indivudal-level data", c(black))			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3) xsize(9)
			plotregion(style(none))
			
			caption("Source: Adult ECHORN (Wave 1) & Health of the Nation, 2021 US Census (IDB Estimates), WHO 2000 Standard Population", span size(vsmall))
	;
#delimit cr
