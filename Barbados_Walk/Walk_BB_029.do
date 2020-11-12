clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_029.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	06/11/2020
**	Date Modified: 	09/11/2020
**  Algorithm Task: Examining Marcoscale Walkability measures with ECHORN wave 1 PA data


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
log using "`logpath'/version01/3-output/Walkability/walk_BB_029.log",  replace

*-------------------------------------------------------------------------------


*Load in ECHORN participant data
import excel "`echornpath'/version03/addresses_CDRC.xlsx", sheet("addresses_CDRC") firstrow clear

*Minor cleaning
drop cont_partadd1 cont_partadd2

*Save data
save "`datapath'/version01/2-working/Walkability/Barbados/walkability_ECHORN_participants.dta", replace


*Merge in wave 1 ECHORN data
merge 1:1 key using "`echornpath'/version03/02-working/survey_wave1_weighted.dta", nogenerate
merge 1:1 key using "`echornpath'/version03/02-working/risk_comparison.dta", nogenerate

*Keep Barbados data
keep if siteid == 3

*Minor cleaning
destring ED, replace

*Merge in walkability and SES measures for Barbados
merge m:1 ED using "`datapath'/version01/2-working/Walkability/Barbados/walk_measure.dta", nogenerate
merge m:1 ED using "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_medium.dta", nogenerate

*Minor data cleaning
rename _eigen_var SES

*Physical Activity analysis from 002d_ecs_allrisk_prep_wave1

** PHYSICAL INACTIVITY
    ** *********************************************************************************************************************************************************
    * Starting with looking at prevalence of inactivity according to WHO guidelines: 150 minutes of moderate intensity activity per week OR 75 minutes of vigorous intensity 
    * per week OR an equivalent combination, achieving at least 600 MET-minutes per week. 
    *********************************************************************************************************************************************************
                    recode HB2 0=.z
                    list HB2 if HB1==.
                    replace HB2=.z if HB1==0 | HB1==.
                    tab HB2, miss

                    *HB3 asks people to select hours or minutes, then HB4 asks for time spent doing vig activity in the units selected on a typical day
                    tab HB3, miss
                    tab HB4, miss 
                    codebook HB4 if HB3==1  // the range of hours of vig PA at a typical day at work is 0-52. 
                    codebook HB4 if HB3==2  // the range of minutes of vig PA at a typical day at work is 0-90

                    *Calculating min per day for vigorous work
                    gen mpdVW=.
                    replace mpdVW=(HB4*60) if HB3==1
                    replace mpdVW=HB4 if HB3==2
                    replace mpdVW=.a if HB4>16 & HB4<. & HB3==1 // according to GPAQ instructions, if more than 16 hours reported in ANY sub-domain, they should be removed from all analyses
                    codebook mpdVW 

                    *Calculating min per week for vigorous work
                    gen mpwVW=mpdVW*HB2 
                    replace mpwVW=.z if HB2==.z

                    *Calculating MET-min per week for vigorous work (assuming MET value of 8 for vigorous work)
                    gen VWMET=mpwVW*8
                    replace VWMET=.z if HB2==.z
                    label variable VWMET "MET-min per week from vigorous work"
                    *histogram VWMET, by(siteid)
                    table siteid, c(median VWMET)
                    * If answered "no" to HB5, then HB6 should have been skipped and "0" days should not have been an option. Need to recode those to .z (not applicable)
                    recode HB6 0=.z
                    list HB6 if HB5==.
                    replace HB6=.z if HB5==0 | HB5==.
                    tab HB6, miss

                    *HB7 asks people to select hours or minutes, then HB8 asks for time spent doing moderate activity in the units selected on a typical day
                    tab HB7, miss
                    tab HB8, miss 
                    codebook HB8 if HB7==1  // the range of hours of moderate PA at a typical day at work is 0-55
                    codebook HB8 if HB7==2  // the range of minutes of moderate PA at a typical day at work is 0-90

                    *Calculating min per day for moderate-intensity work
                    gen mpdMW=.
                    replace mpdMW=(HB8*60) if HB7==1
                    replace mpdMW=HB8 if HB7==2
                    replace mpdMW=.a if HB8>16 & HB8<. & HB7==1 // according to GPAQ instructions, if more than 16 hours reported in ANY sub-domain, they should be removed from all analyses
                    codebook mpdMW 

                    *Calculating min per week for moderate intensity work
                    gen mpwMW=mpdMW*HB6  
                    replace mpwMW=.z if HB6==.z 

                    *Calculating MET-min per week for moderate intensity work (assuming MET value of 4 for moderate work)
                    gen MWMET=mpwMW*4
                    replace MWMET=.z if HB6==.z 
                    label variable MWMET "MET-min per week from moderate work"
                    *histogram MWMET, by(siteid)
                    table siteid, c(median MWMET) 


                    * If answered "no" to HB9, then HB10 should have been skipped and "0" days should not have been an option. Need to recode those to .z (not applicable)
                    recode HB10 0=.z
                    list HB10 if HB9==.
                    replace HB10=.z if HB9==0 | HB9==.
                    tab HB10, miss

                    *HB11 asks people to select hours or minutes, then HB12 asks for time spent in active transport in the units selected on a typical day
                    tab HB11, miss
                    tab HB12, miss 
                    codebook HB12 if HB11==1  // the range of hours spent in active transport is 1-60. 
                    codebook HB12 if HB11==2  // the range of minutes spent in active transport is 0-90.

                    *Calculating min per day for active transport
                    gen mpdT=.
                    replace mpdT=(HB12*60) if HB11==1
                    replace mpdT=HB12 if HB11==2
                    replace mpdT=.a if HB12>16 & HB12<. & HB11==1 // according to GPAQ instructions, if more than 16 hours reported in ANY sub-domain, they should be removed from all analyses
                    codebook mpdT 

                    *Calculating min per week for active transport
                    gen mpwT=mpdMW*HB10 
                    replace mpwT=.z if HB10==.z 

                    *Calculating MET-min per week for active transport (assuming MET value of 4 for active transport)
                    gen TMET=mpwT*4
                    replace TMET=.z if HB10==.z 
                    label variable TMET "MET-min per week from active transport"
                    *histogram TMET, by(siteid)
                    table siteid, c(median TMET)



                    * If answered "no" to HB13, then HB14 should have been skipped and "0" days should not have been an option. Need to recode those to .z (not applicable)
                    recode HB14 0=.z
                    list HB14 if HB13==.
                    replace HB14=.z if HB13==0 | HB13==.
                    tab HB14, miss 


                    *HB15 asks people to select hours or minutes, then HB16 asks for time spent in vigorous recreational activity in the units selected on a typical day
                    tab HB15, miss
                    tab HB16, miss 
                    codebook HB16 if HB15==1  // the range of hours spent in vigorous recreational activity is 1-60. 
                    codebook HB16 if HB15==2  // the range of minutes spent in vigorous recreational activity is 0-90.

                    *Calculating min per day for vigorous recreational activity
                    gen mpdVR=.
                    replace mpdVR=(HB16*60) if HB15==1
                    replace mpdVR=HB16 if HB15==2
                    replace mpdVR=.a if HB16>16 & HB16<. & HB15==1 // according to GPAQ instructions, if more than 16 hours reported in ANY sub-domain, they should be removed from all analyses
                    codebook mpdVR

                    *Calculating min per week for vigorous recreational activity
                    gen mpwVR=mpdVR*HB14
                    replace mpwVR=.z if HB14==.z 

                    *Calculating MET-min per week for vigorous recreational activity (assuming MET value of 8 for vigorous recreational activity)
                    gen VRMET=mpwVR*8
                    replace VRMET=.z if HB14==.z 
                    label variable VRMET "MET-min per week from vigorous recreational activity"
                    *histogram VRMET, by(siteid)
                    table siteid, c(median VRMET)


                    * If answered "no" to HB17, then HB18 should have been skipped and "0" days should not have been an option. Need to recode those to .z (not applicable)
                    recode HB18 0=.z
                    list HB18 if HB17==.
                    replace HB18=.z if HB17==0 | HB17==.
                    tab HB18, miss 

                    *HB19 asks people to select hours or minutes, then HB20 asks for time spent in moderate recreational activity in the units selected on a typical day
                    tab HB19, miss
                    tab HB20, miss 
                    codebook HB20 if HB19==1  // the range of hours spent in moderate recreational activity is 0-7. 
                    codebook HB20 if HB19==2  // the range of minutes spent in moderate recreational activity is 0-7. 
                    *It's strange that the hours and minutes values all fall between 1 and 7. Can we check whether options for days of the week were given in error? The data dictionary says it was a free text response

                    *Calculating min per day for moderate recreational activity
                    gen mpdMR=.
                    replace mpdMR=(HB20*60) if HB19==1
                    replace mpdMR=HB20 if HB19==2
                    replace mpdMR=.a if HB20>16 & HB20<. & HB19==1 // according to GPAQ instructions, if more than 16 hours reported in ANY sub-domain, they should be removed from all analyses
                    codebook mpdMR

                    *Calculating min per week for moderate recreational activity
                    gen mpwMR=mpdMR*HB18
                    replace mpwMR=.z if HB18==.z 

                    *Calculating MET-min per week for moderate recreational activity (assuming MET value of 4 for moderate recreational activity)
                    gen MRMET=mpwMR*4
                    replace MRMET=.z if HB18==.z 
                    label variable MRMET "MET-min per week from moderate recreational activity"
                    *histogram MRMET, by(siteid)
                    table siteid, c(median MRMET) 

                  
*Regression Models for Active transport and walkability measures										
foreach x in walkability walkscore  moveability walk_10 factor{

regress TMET `x' SES, vce(robust)

}

