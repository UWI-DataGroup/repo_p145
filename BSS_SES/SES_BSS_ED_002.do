clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_001

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_002.do
**  Project:      	Macroscale Walkability- PhD
**  Analyst:		Kern Rocke
**	Date Created:	17/10/2019
**	Date Modified: 	05/11/2019
**  Algorithm Task: Data Management and Merging 


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 80

*Setting working directory
** Dataset to encrypted location
/*
WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*/
*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

/*

Main task: Create one working dataset containing all Barbados SES data by EDs
Sub tasks: 
1) Merge sex-specific datasets for each SES category. 
(Note this shoudld utilize 7 different datasets)

2) Merge non-sex specific datasets to sex specific datasets

3) Consider combining all datasets into one final dataset
 
*/


*Begin merging male data then female then total. 

/////	MALE 	////	

*Load in 1st dataset
use "`datapath'/version01/1-input/BSS_SES/male_race_SES", clear

*Merge gender specific datasets
foreach x in age education income mactivity wactivity occupation {
merge 1:1 ED using "`datapath'/version01/1-input/BSS_SES/male_`x'_SES.dta", nogenerate
                    }
*Save dataset
save "`datapath'/version01/2-working/BSS_SES/male_SES", replace
	
********************************************************************************
	
/////	FEMALE 	////	
	
*Load in 1st dataset
use "`datapath'/version01/1-input/BSS_SES/female_race_SES", clear

*Merge gender specific datasets
foreach x in age education income mactivity wactivity occupation {
merge 1:1 ED using "`datapath'/version01/1-input/BSS_SES/female_`x'_SES.dta", nogenerate
                    }
*Save dataset
save "`datapath'/version01/2-working/BSS_SES/female_SES", replace

********************************************************************************

/////	TOTAL 	////	
	
*Load in 1st dataset
use "`datapath'/version01/1-input/BSS_SES/total_race_SES", clear

*Merge total specific datasets
foreach x in age education income mactivity wactivity occupation {
merge 1:1 ED using "`datapath'/version01/1-input/BSS_SES/total_`x'_SES.dta", nogenerate
                    }

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/total_SES", replace

********************************************************************************
********************************************************************************

////// MERGING ALL DATA  ///////

*Load in Total SES dataset
use "`datapath'/version01/2-working/BSS_SES/total_SES", clear

*Merge sex-specific datasets
foreach x in male female {
merge 1:1 ED using "`datapath'/version01/2-working/BSS_SES/`x'_SES", nogenerate
}

*Merge non-gender specific datasets
foreach x in household_size house_tenure single_mother_liveborn ///
			relationship_to_head household_size liveborn crime additional {
merge 1:1 ED using "`datapath'/version01/1-input/BSS_SES/`x'_SES.dta", nogenerate
                    }	

drop in 584

*Decode string parish variable
encode parish, gen(parish1)
drop parish
rename parish1 parish

*Re-order variables
order parish total_pop, after(ED)

*Label data
label data "SES by Ennumeration Districts - Barbabdos Statistical Service"

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/BSS_SES_001", replace
