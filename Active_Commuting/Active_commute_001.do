

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Active_Commute_001.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Regional Active Commuting WHO STEPS
**  Analyst:		Kern Rocke
**	Date Created:	30/11/2020
**	Date Modified: 	02/12/2020
**  Algorithm Task: Comparison of GPAQ Physical Activity Country Estimates


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
local echornpath "X:/The University of the West Indies/DataGroup - repo_data/data_p120"

*WINDOWS OS (Alternative)
*local echornpath "X:/The UWI - Cave Hill Campus/DataGroup - PROJECT_p120"

*MAC OS
*local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p120"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/WHO STEPS/Active_BB_001.log",  replace

*-------------------------------------------------------------------------------


use "`datapath'/version01/1-input/WHO STEPS/survey_wave1_weighted1.dta", clear

** PHYSICAL INACTIVITY
    ** *********************************************************************************************************************************************************
    * Starting with looking at prevalence of inactivity according to WHO guidelines: 150 minutes of moderate intensity activity per week OR 75 minutes of vigorous intensity 
    * per week OR an equivalent combination, achieving at least 600 MET-minutes per week. 
    *********************************************************************************************************************************************************
                    *------------------------------------------------------------------------------------------------------
                    * ACTIVITY AT WORK: Questions HB1 - HB8
                    *------------------------------------------------------------------------------------------------------
                    *VIGOROUS WORK ACTIVITY (HB1-HB4)
                    tab HB1, miss 
                    /*
                    Does your work |
                            involve |
                    vigorous/strenu |
                    ous-intensity |
                    activity that |
                        causes larg |      Freq.     Percent        Cum.
                    ----------------+-----------------------------------
                                No |      2,429       82.03       82.03
                                Yes |        491       16.58       98.62
                                . |         41        1.38      100.00
                    ----------------+-----------------------------------
                            Total |      2,961      100.00                */

                    tab HB2, miss
                    /*
                        In a |
                        typical |
                    week, on |
                    how many |
                    days do you |
                            do |
                    vigorous/st |
                    renuous-int |
                    ensity ac |      Freq.     Percent        Cum.
                    ------------+-----------------------------------
                            0 |         14        0.47        0.47
                            1 |         21        0.71        1.18
                            2 |         59        1.99        3.17
                            3 |         89        3.01        6.18
                            4 |         55        1.86        8.04
                            5 |        136        4.59       12.63
                            6 |         55        1.86       14.49
                            7 |         49        1.65       16.14
                            . |      2,483       83.86      100.00
                    ------------+-----------------------------------
                        Total |      2,961      100.00             */

                    * If answered "no" to HB1, then HB2 should have been skipped and "0" days should not have been an option. Need to recode those to .z (not applicable)
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

                    *MODERATE WORK ACTIVITY (HB5 - HB8)
                    tab HB5, miss 
                    /*
                    Does your work |
                            involve |
                    moderate-intens |
                    ity activity |
                        that causes |
                    small increase |      Freq.     Percent        Cum.
                    ----------------+-----------------------------------
                                No |      1,609       54.34       54.34
                                Yes |      1,313       44.34       98.68
                                . |         39        1.32      100.00
                    ----------------+-----------------------------------
                            Total |      2,961      100.00                */

                    tab HB6, miss 

                    /*    In a |
                        typical |
                    week, on |
                    how many |
                    days do you |
                    do moderate |
                    intensity |
                    activities |
                            a |      Freq.     Percent        Cum.
                    ------------+-----------------------------------
                            0 |         19        0.64        0.64
                            1 |         54        1.82        2.47
                            2 |        140        4.73        7.19
                            3 |        236        7.97       15.16
                            4 |        139        4.69       19.86
                            5 |        376       12.70       32.56
                            6 |        133        4.49       37.05
                            7 |        195        6.59       43.63
                            . |      1,669       56.37      100.00
                    ------------+-----------------------------------
                        Total |      2,961      100.00                */

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

                    *------------------------------------------------------------------------------------------------------
                    * ACTIVITY DURING ACTIVE TRANSPORT: Questions HB9 - HB12
                    *------------------------------------------------------------------------------------------------------
                    tab HB9, miss 

                    /* Do you walk or |
                    use a bicycle |
                    (pedal cycle) |
                    for at least 10 |
                            minutes |
                        continuous |      Freq.     Percent        Cum.
                    ----------------+-----------------------------------
                                No |      1,648       55.66       55.66
                                Yes |      1,283       43.33       98.99
                                . |         30        1.01      100.00
                    ----------------+-----------------------------------
                            Total |      2,961      100.00                */

                    tab HB10, miss 

                    /*     In a |
                        typical |
                    week, on |
                    how many |
                    days do you |
                        walk or |
                    bicycle for |
                    at least 10 |
                            mi |      Freq.     Percent        Cum.
                    ------------+-----------------------------------
                            0 |         11        0.37        0.37
                            1 |         33        1.11        1.49
                            2 |        126        4.26        5.74
                            3 |        203        6.86       12.60
                            4 |        136        4.59       17.19
                            5 |        362       12.23       29.42
                            6 |         87        2.94       32.35
                            7 |        309       10.44       42.79
                            . |      1,694       57.21      100.00
                    ------------+-----------------------------------
                        Total |      2,961      100.00            */


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
                    gen mpwT=mpdT*HB10 
                    replace mpwT=.z if HB10==.z 

                    *Calculating MET-min per week for active transport (assuming MET value of 4 for active transport)
                    gen TMET=mpwT*4
                    replace TMET=.z if HB10==.z 
                    label variable TMET "MET-min per week from active transport"
                    *histogram TMET, by(siteid)
                    table siteid, c(median TMET)

                    *------------------------------------------------------------------------------------------------------
                    * RECREATIONAL ACTIVITY: Questions HB13 - HB20
                    *------------------------------------------------------------------------------------------------------
                    **VIGOROUS ACTIVITY (questions HB13-HB16)
                    tab HB13, miss 

                    /*Do you do any |
                    vigorous/strenu |
                    ous-intensity |
                    sports, fitness |
                    or recreational |
                                (l |      Freq.     Percent        Cum.
                    ----------------+-----------------------------------
                                No |      2,395       80.88       80.88
                                Yes |        518       17.49       98.38
                                . |         48        1.62      100.00
                    ----------------+-----------------------------------
                            Total |      2,961      100.00            */

                    tab HB14, miss

                    /*    In a |
                        typical |
                    week, on |
                    how many |
                    days do you |
                            do |
                    vigorous/st |
                    renuous-int |
                    ensity sp |      Freq.     Percent        Cum.
                    ------------+-----------------------------------
                            0 |         14        0.47        0.47
                            1 |         59        1.99        2.47
                            2 |        101        3.41        5.88
                            3 |        150        5.07       10.94
                            4 |         78        2.63       13.58
                            5 |         77        2.60       16.18
                            6 |         19        0.64       16.82
                            7 |          9        0.30       17.12
                            . |      2,454       82.88      100.00
                    ------------+-----------------------------------
                        Total |      2,961      100.00             */



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

                    *MODERATE RECREATIONAL ACTIVITY (questions HB17 - HB20)
                    tab HB17, miss

                    /*Do you do any |
                    moderate-intens |
                        ity sports, |
                        fitness or |
                    recreational |
                    (leisure) ac |      Freq.     Percent        Cum.
                    ----------------+-----------------------------------
                                No |      1,849       62.45       62.45
                                Yes |      1,066       36.00       98.45
                                . |         46        1.55      100.00
                    ----------------+-----------------------------------
                            Total |      2,961      100.00            */

                    tab HB18, miss

                    /* In a |
                        typical |
                    week, on |
                    how many |
                    days do you |
                    do moderate |
                    intensity |
                        sports, |
                        fitn |      Freq.     Percent        Cum.
                    ------------+-----------------------------------
                            0 |         40        1.35        1.35
                            1 |         81        2.74        4.09
                            2 |        222        7.50       11.58
                            3 |        306       10.33       21.92
                            4 |        151        5.10       27.02
                            5 |        162        5.47       32.49
                            6 |         40        1.35       33.84
                            7 |         50        1.69       35.53
                            . |      1,909       64.47      100.00
                    ------------+-----------------------------------
                        Total |      2,961      100.00               */


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

                                        *------------------------------------------------------------------------------------------------------
                                        * TOTAL MET MINUTES PER WEEK AND INACTIVITY PREVALENCE
                                        *------------------------------------------------------------------------------------------------------
                                        /* GPAQ analysis guide states that if either of the following conditions are met, the respondent should be removed from all analyses, resulting in the same denominator across 
                                        all domains and analyses: 
                                        1) More than 16 hours reported in ANY sub-domain
                                        2) Inconsistent answers (e.g. 0 days reported, but values >0 in corresponding time variables)
                                        */

                                        generate PAclean=1
                                        replace PAclean=0 if mpdVW==.a | mpdMW==.a | mpdT==.a | mpdVR==.a | mpdMR==.a 
                                        replace PAclean=0 if HB1==0 & HB2>=1 & HB2<=7 
                                        replace PAclean=0 if HB5==0 & HB6>=1 & HB6<=7 
                                        replace PAclean=0 if HB9==0 & HB10>=1 & HB10<=7
                                        replace PAclean=0 if HB13==0 & HB14>=1 & HB14<=7  
                                        replace PAclean=0 if HB17==0 & HB18>=1 & HB18<=7  

                                        *TOTAL MET MINUTES PER WEEK FROM ALL DOMAINS
                                        egen totMETmin=rowtotal(VWMET MWMET TMET VRMET MRMET)
                                        replace totMETmin=. if PAclean==0
                                        gen inactive=.
                                        replace inactive=1 if totMETmin<600
                                        replace inactive=0 if totMETmin>=600 & totMETmin<.
                                        label variable inactive "inactive WHO recommendations"
                                        label define inactive 0 "active" 1 "inactive"
                                        label values inactive inactive 
										
*Minor cleaning										
rename siteid country
rename gender sex

*Create variables for daily PA for work and Leisure
egen mvpdL = rowtotal(mpdVR mpdMR)
egen mvpdW = rowtotal(mpdVW mpdMW)

*Save Activity dataset
save "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity", replace

*-------------------------------------------------------------------------------

*Collapse dataset for both male and female estimates
collapse (mean) inactive mvpdW mpdT mvpdL, by(country)

*Save sex-specific dataset
save "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity_total.dta", replace

*-------------------------------------------------------------------------------

*Open ECHORN dataset
use "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity", clear

*Collapse dataset for male and female estimates
collapse (mean) inactive mvpdW mpdT mvpdL, by(country sex)

*Save sex-specific dataset
save "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity_sex.dta", replace

*Merge dataset
append using "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity_total.dta"


replace sex = 3 if sex==.
label define sex 1"Male" 2"Female" 3"Both", modify
label value sex sex

replace inactive = inactive * 100
									
reshape wide inactive mvpdW mpdT mvpdL, i(country) j(sex)
rename inactive1 m_inactive
rename inactive2 f_inactive
rename inactive3 t_inactive

gen country1 = .
replace country1= 2 if country == 3 //Barbados
replace country1= 9 if country == 1 //USVI
replace country1= 7 if country == 2 //Puerto Rico
replace country1= 8 if country == 4 //Trinidad

drop country
rename country1 country

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity_reshape.dta", replace


*-------------------------------------------------------
*-------------------------------------------------------

*Load in data from encrypted location

*BAHAMAS
use "`datapath'/version01/1-input/WHO STEPS/bhs2011.dta", clear

*Create country variable
gen country = 1

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Bahamas_2011.dta", replace

*-------------------------------------------------------

*BRITISH VIRGIN ISLANDS
use "`datapath'/version01/1-input/WHO STEPS/BVI2009.dta", clear

*Create country variable
gen country = 3

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/BVI_2009.dta", replace

*---------------------------------------------------------

*CAYMAN ISLANDS
use "`datapath'/version01/1-input/WHO STEPS/CYM2012.dta", clear

*Create country variable
gen country = 4

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Cayman_2012.dta", replace

*------------------------------------------------------------

*Grenada
use "`datapath'/version01/1-input/WHO STEPS/GRD2010.dta", clear

*Create country variable
gen country = 5

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Grenada_2010.dta", replace

*-------------------------------------------------------------

*Guyana
use "`datapath'/version01/1-input/WHO STEPS/guy2016.dta", clear

*Create country variable
gen country = 6

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/Guyana_2016.dta", replace

*-------------------------------------------------------------

clear

*Comine datasets
use "`datapath'/version01/2-working/WHO STEPS/Bahamas_2011.dta", clear
append using "`datapath'/version01/2-working/WHO STEPS/BVI_2009.dta", force
append using "`datapath'/version01/2-working/WHO STEPS/Cayman_2012.dta", force
append using "`datapath'/version01/2-working/WHO STEPS/Grenada_2010.dta", force
append using "`datapath'/version01/2-working/WHO STEPS/Guyana_2016.dta", force


*Label country variable
label var country "Country"
label define country 1"Bahamas" 2"Barbados" 3"British Virgin Islands" ///
					 4"Cayman Islands" 5"Grenada" 6"Guyana"
label value country country

*Keep variables of interest
keep sex age p1-p15b country

*-------------------------------------------------------------------------------

**Create Active commuting variables **

*Recode Don't know to missing
recode p8 (77=.)
recode p9a (77=.)
recode p9b (77=.)

*Convert Hours to minutes
gen hour_min_T = p9a*60

*Minutes of active transport per day
egen mpdT = rowtotal(hour_min p9b)
replace mpdT = .a if p9a>16
label var mpdT "Minutes of Active Transport per day"

*Minutes of active transport per week
gen mpwT = mpdT*p8
label var mpwT "Minutes of Active Transport per week"

*Calculating MET-min per week for active transport (assuming MET value of 4 for active transport)
gen TMET=mpwT*4
label variable TMET "MET-min per week from active transport"

*-------------------------------------------------------------------------------

**Create Physical Activity for Work **

***VIGORIUS ACTIVITY****

*Recode Don't know to missing
recode p2 (77=.)
recode p3a (77=.)
recode p3b (77=.)

*Convert Hours to minutes
gen hour_min_VW = p3a*60

*Minutes of vigorous physical activity for work per day
egen vpdW = rowtotal(hour_min_VW p3b)
replace vpdW = .a if p3a>16
label var vpdW "Minutes of Vigorous Physical Activity for Work day"

*Minutes of vigorous physical activity for work per week
gen vpwW = vpdW*p2
label var vpwW "Minutes of Vigorous Physical Activity for Work per week"

*Calculating MET-min per week for vigorous physical activity at work (assuming MET value of 8 for vigorous physical activity)
gen VWMET=vpwW*8
label variable VWMET "MET-min per week from Vigorous Physical Activity at Work"


*-------------------------------------------------------------------------------

***MODERATE ACTIVITY****

*Recode Don't know to missing
recode p5 (77=.)
recode p6a (77=.)
recode p6b (77=.)

*Convert Hours to minutes
gen hour_min_MW = p6a*60

*Minutes of moderate physical activity for work per day
egen mpdW = rowtotal(hour_min_MW p6b)
replace mpdW = .a if p6a>16
label var mpdW "Minutes of Moderate Physical Activity for Work day"

*Minutes of moderate physical activity for work per week
gen mpwW = mpdW*p5
label var vpwW "Minutes of Vigorous Physical Activity for Work per week"

*Calculating MET-min per week for physical activity for work (assuming MET value of 4 for moderate physical activity)
gen MWMET=mpwW*4
label variable MWMET "MET-min per week from Moderate Physical Activity at Work"


*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------

**Create Physical Activity for Leisure **

***VIGORIUS ACTIVITY****

*Recode Don't know to missing
recode p11 (77=.)
recode p12a (77=.)
recode p12b (77=.)

*Convert Hours to minutes
gen hour_min_VL = p12a*60

*Minutes of vigorous physical activity for Leisure per day
egen vpdL = rowtotal(hour_min_VL p12b)
replace vpdL = .a if p12a>16
label var vpdL "Minutes of Vigorous Physical Activity for Leisure day"

*Minutes of vigorous physical activity for Leisure per week
gen vpwL = vpdL*p11
label var vpwL "Minutes of Vigorous Physical Activity for Leisure per week"

*Calculating MET-min per week for vigorous physical activity for Leisure (assuming MET value of 8 for vigorous physical activity)
gen VLMET=vpwL*8
label variable VLMET "MET-min per week from Vigorous Physical Activity for Leisure"


*-------------------------------------------------------------------------------

***MODERATE ACTIVITY****

*Recode Don't know to missing
recode p14 (77=.)
recode p15a (77=.)
recode p15b (77=.)

*Convert Hours to minutes
gen hour_min_ML = p15a*60

*Minutes of active transport per day
egen mpdL = rowtotal(hour_min_ML p15b)
replace mpdL = .a if p15a>16
label var mpdL "Minutes of Moderate Physical Activity for Leisure day"

*Minutes of active transport per week
gen mpwL = mpdL*p14
label var vpwL "Minutes of VModerate Physical Activity  for Leisure per week"

*Calculating MET-min per week for physical activity for Leisure (assuming MET value of 4 for moderate physical activity)
gen MLMET=mpwL*4
label variable MLMET "MET-min per week from Moderate Physical Activity for Leisure"

*-------------------------------------------------------------------------------
*mpdT mpdL mpdW vpdL vpdWW

egen mvpdL = rowtotal(mpdL vpdL)
egen mvpdW = rowtotal(mpdW vpdW)

*Total Physical Activity
egen total_pa = rowtotal(TMET VWMET MWMET VLMET MLMET)
label var total_pa "Total Physical Activity METS minutes/week"

*Physical Inactivity variable
gen inactive = .
replace inactive = 1 if total_pa <600
replace inactive = 0 if total_pa>=600

label var inactive "Physical Inactivity"
label define inactive 0"Active" 1"Inactive"
label value inactive inactive

*Save dataset
save "`datapath'/version01/2-working/WHO STEPS/WHO_STEPS_Caribbean.dta", replace

proportion inactive, over(country) cformat(%9.2f)

collapse (mean) inactive mpdT mvpdL mvpdW, by(country sex)
save "`datapath'/version01/2-working/WHO STEPS/WHO_STEPS_sex_inactive.dta", replace

use "`datapath'/version01/2-working/WHO STEPS/WHO_STEPS_Caribbean.dta", clear
collapse (mean) inactive mpdT mvpdL mvpdW, by(country)

save "`datapath'/version01/2-working/WHO STEPS/WHO_STEPS_total_inactive.dta", replace
append using "`datapath'/version01/2-working/WHO STEPS/WHO_STEPS_sex_inactive.dta"

*Sex variable cleaning
encode sex, gen(sex1)
replace sex1 = 3 if sex1==.
drop sex
rename sex1 sex
label define sex 1"Male" 2"Female" 3"Both", modify
label value sex sex

replace inactive = inactive * 100

*Minor
reshape wide inactive mpdT mvpdL mvpdW, i(country) j(sex)
rename inactive1 m_inactive
rename inactive2 f_inactive
rename inactive3 t_inactive

*Add in ECHORN data
append using "`datapath'/version01/2-working/WHO STEPS/ECHORN_activity_reshape.dta"

*-------------------------------------------------------------------------------

*Equiplot
#delimit;

	graph twoway
		(rspike m_inactive f_inactive country, hor lc(gs6) lw(0.25))
		(sc country m_inactive , msize(3) m(o) mlc(gs0) mfc("84 39 143") mlw(0.1))
        (sc country f_inactive , msize(3) m(o) mlc(gs0) mfc("158 154 200") mlw(0.1))
        (sc country t_inactive , msize(3) m(*) mlc(gs0) mfc("sand") mlw(0.1))
		
		,
            plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            bgcolor(white) 
            ysize(10) xsize(6)
			
			xscale(fill)
			xlab(10(10)60, labs(4) nogrid glc(gs16))
			xtitle("Prevalence of Inactivity (%)", size(4) margin(l=2 r=2 t=5 b=2))
			xmtick(10(5)60, tl(1.5))
			
			ylab(1"Bahamas" 2"Barbados" 3"BVI" 4"Cayman Islands" 5"Grenada" 6"Guyana"
				 7"Puerto Rico" 8"Trinidad" 9"USVI"
			,
			angle(0) nogrid glc(gs16))
			ytitle("", size(2.5) margin(l=2 r=5 t=2 b=2)) 
			yscale(reverse)
			
			legend(size(4) position(3) ring(0) bm(t=1 b=4 l=5 r=0) colf cols(1)
                region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
                order(2 3 4) 
                lab(2 "Male") lab(3 "Female")  lab(4 "Both")
                )
			name(Equiplot)
               ;
#delimit cr

*-------------------------------------------------------------------------------

*Stacked Bar Chart showing Activity Breakdown

#delimit;

		graph hbar (mean) mvpdW3 mpdT3 mvpdL3
		, 
		stack 
		over(country, relabel(1"Bahamas"
							  2"Barbados"
							  3"BVI"
							  4"Cayman Islands"
							  5"Grenada"
							  6"Guyana"
							  7"Puerto Rico" 
							  8"Trinidad" 
							  9"USVI"))
							  
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
        graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		
		blabel(none, format(%9.0f) pos(outside) size(medsmall))
		
		bar(1, bc(blue*0.65) blw(vthin) blc(gs0))
		bar(2, bc(red*0.65) blw(vthin) blc(gs0))
		bar(3, bc(green*0.65) blw(vthin) blc(gs0))
		
		ylab(0(50)350, nogrid glc(gs0)) yscale(range(0(50)350))
	    ytitle("", margin(t=3) size(medium)) 
		
		legend(size(medium)  cols(2)
				region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
				order(1 2 3)
				lab(1 "Occupational PA (min/d)")
				lab(2 "Travel PA (min/d)")
				lab(3 "Recreation PA (min/d)")
				)
				
		name(stack_bar)


;
#delimit cr

*-------------------------------------------------------------------------------

