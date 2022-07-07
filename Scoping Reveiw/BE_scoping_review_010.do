

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_010.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	03/07/2022
**	Date Modified: 	03/07/2022
**  Algorithm Task: Updated Evidence Gap Matrix


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

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local logpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local outputpath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
*log using "`logpath'/version01/3-output/Scoping Review/SR_PA_005.log",  replace


*-------------------------------------------------------------------------------

*Set active working directory
cd "`datapath'/version01/1-input/Scoping Review/"

*-------------------------------------------------------------------------------

import delimited record_id redcap_repeat_instrument redcap_repeat_instance author publication_year adjusted publication_informat_v_0 bemeasure walk_health___1 walk_health___2 walk_health___3 walk_health___4 walk_health___5 walk_health___6 walk_health___7 walk_health___8 walk_health___9 pa relationships_complete using "BEPAScopingReviewRel_DATA_NOHDRS_2022-07-03_1229.csv", varnames(nonames)

label data "BEPAScopingReviewRel_DATA_NOHDRS_2022-07-03_1229.csv"


label define adjusted_ 1 "Yes" 0 "No" 
label define publication_informat_v_0_ 0 "Incomplete" 1 "Unverified" 2 "Complete" 
label define walk_health___1_ 0 "Unchecked" 1 "Checked" 
label define walk_health___2_ 0 "Unchecked" 1 "Checked" 
label define walk_health___3_ 0 "Unchecked" 1 "Checked" 
label define walk_health___4_ 0 "Unchecked" 1 "Checked" 
label define walk_health___5_ 0 "Unchecked" 1 "Checked" 
label define walk_health___6_ 0 "Unchecked" 1 "Checked" 
label define walk_health___7_ 0 "Unchecked" 1 "Checked" 
label define walk_health___8_ 0 "Unchecked" 1 "Checked" 
label define walk_health___9_ 0 "Unchecked" 1 "Checked" 
label define pa_ 1 "Active Transport" 2 "Leisure-Time PA" 3 "MVPA/Total PA" 
label define relationships_complete_ 0 "Incomplete" 1 "Unverified" 2 "Complete" 
label values adjusted adjusted_
label values publication_informat_v_0 publication_informat_v_0_
label values walk_health___1 walk_health___1_
label values walk_health___2 walk_health___2_
label values walk_health___3 walk_health___3_
label values walk_health___4 walk_health___4_
label values walk_health___5 walk_health___5_
label values walk_health___6 walk_health___6_
label values walk_health___7 walk_health___7_
label values walk_health___8 walk_health___8_
label values walk_health___9 walk_health___9_
label values pa pa_
label values relationships_complete relationships_complete_



label variable record_id "Record ID"
label variable redcap_repeat_instrument "Repeat Instrument"
label variable redcap_repeat_instance "Repeat Instance"
label variable author "First author (last name)"
label variable publication_year "Year of publication"
label variable adjusted "Analyses Adjusted"
label variable publication_informat_v_0 "Complete?"
label variable bemeasure "Built Environment Feature"
label variable walk_health___1 "Walkability for Health (choice=Surveillance)"
label variable walk_health___2 "Walkability for Health (choice=Experience)"
label variable walk_health___3 "Walkability for Health (choice=Parking)"
label variable walk_health___4 "Walkability for Health (choice=Traffic Safety)"
label variable walk_health___5 "Walkability for Health (choice=Community)"
label variable walk_health___6 "Walkability for Health (choice=Greenspace)"
label variable walk_health___7 "Walkability for Health (choice=Density)"
label variable walk_health___8 "Walkability for Health (choice=Connectivity)"
label variable walk_health___9 "Walkability for Health (choice=Land Use)"
label variable pa "Physical Activity Measure"
label variable relationships_complete "Complete?"

order record_id redcap_repeat_instrument redcap_repeat_instance author publication_year adjusted publication_informat_v_0 bemeasure walk_health___1 walk_health___2 walk_health___3 walk_health___4 walk_health___5 walk_health___6 walk_health___7 walk_health___8 walk_health___9 pa relationships_complete 
set more off

*Create walkability for Health Categories
gen walkhealth = .
replace walkhealth = 1 if walk_health___1 == 1
replace walkhealth = 2 if walk_health___2 == 1
replace walkhealth = 3 if walk_health___3 == 1
replace walkhealth = 4 if walk_health___4 == 1
replace walkhealth = 5 if walk_health___5 == 1
replace walkhealth = 6 if walk_health___6 == 1
replace walkhealth = 7 if walk_health___7 == 1
replace walkhealth = 8 if walk_health___8 == 1
replace walkhealth = 9 if walk_health___9 == 1

*Label variable
label var walkhealth "Walkability for Health Categories"
label define walkhealth 1"Surveillance" 2"Experience" 3"Parking" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density" 8"Connectivity" 9"Land Use"
label value walkhealth walkhealth

*Restructure data for graphing purposes
gen relationship = 1 if walkhealth!=.

collapse (sum) relationship, by(walkhealth pa)

*Include parking data
set obs 27
replace pa = 1 in 25
replace pa = 2 in 26
replace pa = 3 in 27
replace walkhealth = 3 if walkhealth == .
replace relationship = 0 if relationship == .

*Minot adjustment for mapping purposes
rename pa PA
replace PA = 1.2 if PA==1
replace PA = 1 if PA ==1.2
replace PA = 2.85 if PA>2

*Create Evidence Gap Matrix
#delimit;
	graph twoway
			(scatter walkhealth PA if relationship==0, mfc("215 48 39") mlc(gs0) msize(7))
			(scatter walkhealth PA if relationship>0 & relationship<=3, mfc("252 141 89") mlc(gs0) msize(7))
			(scatter walkhealth PA if relationship>=4 & relationship<=5, mfc("254 224 139") mlc(gs0) msize(7))
			(scatter walkhealth PA if relationship>=6 & relationship<=8, mfc("217 239 139") mlc(gs0) msize(7))
			(scatter walkhealth PA if relationship>=9 & relationship<=10, mfc("145 207 96") mlc(gs0) msize(7))
			(scatter walkhealth PA if relationship>10 , mfc("26 152 80") mlc(gs0) msize(7))
				,		
			ylab(1"Surveillance" 2"Experience" 3"Parking" 4"Traffic Safety" 5"Community" 6"Greenspace" 7"Density"
				 8"Connectivity" 9"Land Use" 0.751" " 9.5" "
			,
			angle(0) nogrid notick glc(gs16) labsize(3))
			yscale(reverse)
			xscale(fill)
			xscale(alt)
			xlab(1"Active" 1.2"            Transport" 2.05"Leisure-time PA" 2.85"MVPA" 3.2" ", labs(3) nogrid notick glc(gs16))
			xtitle("{bf:Physical Activity Outcome}", size(3) )

			yline(0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.73,  lcolor(gs8) )
			xline(1.6 2.45 3.28 ,  lcolor(gs8) )
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin) lcolor(black)) 
            bgcolor(white) 
			
			legend(size(3) position(3) ring(10) bm(t=0 b=0 l=4 r=0) colf cols(1)
            region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0)) 
            order(1 2 3 4 5 6) 
            lab(1 "0") lab(2 "1-3") lab(3 "4-5")  lab(4 "6-8") lab(5 "9-10") lab(6 ">10") 
			title("{bf:Number of}" "{bf:Relationships}", color(black) size(small))
                )
				
			xsize(5)
					;
		#delimit cr
