
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		ECS_pop.do
**  Project:      	Adult-ECS
**	Sub-Project:	Survey Weight
**  Analyst:		Kern Rocke
**	Date Created:	01/10/2021
**	Date Modified: 	02/02/2021
**  Algorithm Task: Population Pyramid


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150


*Setting working directory

*-------------------------------------------------------------------------------
** Dataset to encrypted location
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p120"

*-------------------------------------------------------------------------------
*Barbados
import delimited "`echornpath'/version02/1-input/BB_US.csv", clear

gen age = real(regexs(1)) if regexm(agegroupyearsofage,"([0-9]+)")
drop agegroupyearsofage
gen agegrp = .
replace agegr = 40 if age>=40 & age<50 & age!=.
replace agegr = 50 if age>=50 & age<60 & age!=.
replace agegr = 60 if age>=60 & age<70 & age!=.
replace agegr = 70 if age>=70 & age!=.

rename malepopulation pop1
rename femalepopulation pop2
tabstat pop1 pop2, stat(sum)

keep if agegr !=.


reshape long pop, i(age) j(gender)
collapse (sum) pop, by(agegrp gender)
drop if agegr == .
gen totpop = .
replace totpop = 143013 if gender == 1
replace totpop = 152865 if gender == 2

gen pop_us = .
replace pop_us = pop/totpop 
gen cid = 52

*Save dataset
save "`echornpath'/version02/1-input/BB_US.dta", replace

*-------------------------------------------------------------------------------
*Trinidad
import delimited "`echornpath'/version02/1-input/TT_US.csv", clear

gen age = real(regexs(1)) if regexm(agegroupyearsofage,"([0-9]+)")
drop agegroupyearsofage
gen agegrp = .
replace agegr = 40 if age>=40 & age<50 & age!=.
replace agegr = 50 if age>=50 & age<60 & age!=.
replace agegr = 60 if age>=60 & age<70 & age!=.
replace agegr = 70 if age>=70 & age!=.

rename malepopulation pop1
rename femalepopulation pop2
tabstat pop1 pop2, stat(sum)

keep if agegr !=.

reshape long pop, i(age) j(gender)
collapse (sum) pop, by(agegrp gender)
drop if agegr == .
gen totpop = .
replace totpop = 624387 if gender == 1
replace totpop = 609458 if gender == 2

gen pop_us = .
replace pop_us = pop/totpop 
gen cid = 780

*Save dataset
save "`echornpath'/version02/1-input/TT_US.dta", replace

*-------------------------------------------------------------------------------
*Puerto Rico
import delimited "`echornpath'/version02/1-input/PR_US.csv", clear

gen age = real(regexs(1)) if regexm(agegroupyearsofage,"([0-9]+)")
drop agegroupyearsofage
gen agegrp = .
replace agegr = 40 if age>=40 & age<50 & age!=.
replace agegr = 50 if age>=50 & age<60 & age!=.
replace agegr = 60 if age>=60 & age<70 & age!=.
replace agegr = 70 if age>=70 & age!=.

rename malepopulation pop1
rename femalepopulation pop2
tabstat pop1 pop2, stat(sum)

keep if agegr !=.

reshape long pop, i(age) j(gender)
collapse (sum) pop, by(agegrp gender)
drop if agegr == .
gen totpop = .
replace totpop = 1656173 if gender == 1
replace totpop = 1816685 if gender == 2

gen pop_us = .
replace pop_us = pop/totpop 
gen cid = 630

*Save dataset
save "`echornpath'/version02/1-input/PR_US.dta", replace

*-------------------------------------------------------------------------------
*USVI
import delimited "`echornpath'/version02/1-input/USVI_US.csv", clear

gen age = real(regexs(1)) if regexm(agegroupyearsofage,"([0-9]+)")
drop agegroupyearsofage
gen agegrp = .
replace agegr = 40 if age>=40 & age<50 & age!=.
replace agegr = 50 if age>=50 & age<60 & age!=.
replace agegr = 60 if age>=60 & age<70 & age!=.
replace agegr = 70 if age>=70 & age!=.

rename malepopulation pop1
rename femalepopulation pop2
tabstat pop1 pop2, stat(sum)

keep if agegr !=.

reshape long pop, i(age) j(gender)
collapse (sum) pop, by(agegrp gender)
drop if agegr == .
gen totpop = .
replace totpop = 51531 if gender == 1
replace totpop = 56181 if gender == 2

gen pop_us = .
replace pop_us = pop/totpop 
gen cid = 850

*Save dataset
save "`echornpath'/version02/1-input/USVI_US.dta", replace

*-------------------------------------------------------------------------------
*Add PR data 
append using "`echornpath'/version02/1-input/PR_US.dta"

*Add TT data
append using "`echornpath'/version02/1-input/TT_US.dta"

*Add BB data
append using "`echornpath'/version02/1-input/BB_US.dta"

*Minor cleaning
sort cid agegr gender
keep pop_us cid
egen id = seq()
order id 

*Save data
save "`echornpath'/version02/1-input/combine_US.dta", replace
