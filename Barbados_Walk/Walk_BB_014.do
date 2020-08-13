

clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_014.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	03/08/2020
**	Date Modified: 	03/08/2020
**  Algorithm Task: Area Level walkability and active transport analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150



import excel "/Users/kernrocke/Downloads/Barbados_ECHORN_ED.xlsx", sheet("Sheet1") firstrow clear
sort ED
destring ED, replace
merge m:1 ED using "/Users/kernrocke/Downloads/walkability.dta"
drop if key == ""
drop _merge
save "/Users/kernrocke/Downloads/walkability_ED.dta", replace



use "/Users/kernrocke/Downloads/survey_wave1_weighted1.dta", clear
keep if siteid == 3
sort key
merge 1:1 key using "/Users/kernrocke/Downloads/walkability_ED.dta"
drop _merge


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
                    gen mpwT=mpdMW*HB10 
                    replace mpwT=.z if HB10==.z 

                    *Calculating MET-min per week for active transport (assuming MET value of 4 for active transport)
                    gen TMET=mpwT*4
                    replace TMET=.z if HB10==.z 
                    label variable TMET "MET-min per week from active transport"
                    *histogram TMET, by(siteid)
                    table siteid, c(median TMET)
					
					
** EDUCATION
**GROUPED AS FOLLOWS: 1) less than high school; 2) high school graduate; 3) associates degree or some college; 4) College degree    

gen educ=.
replace educ=1 if D13==0 | D13==1 | D13==2
replace educ=2 if D13==3
replace educ=3 if D13==4 | D13==5
replace educ=4 if D13==6 | D13==7 | D13==8 | D13==9
label variable educ "Education categories"
label define educ 1 "less than high school" 2 "high school graduate" 3 "associates degree/some college" 4 "college degree"
label values educ educ
gen primary_plus  = (educ==1)
gen second = (educ==2)
gen second_plus = (educ==3)
gen tertiary = (educ==4) 

** OCCUPATION: grouped as skilled, semi-skilled, and unskilled labour
gen prof = (Major_Category_Code==1|Major_Category_Code==2|Major_Category_Code==3)
label variable prof "professional occupation"
gen semi_prof = (Major_Category_Code==4|Major_Category_Code==5|Major_Category_Code==6|Major_Category_Code==7|Major_Category_Code==8)
label variable semi_prof "semi-professional occupation"
gen non_prof = (Major_Category_Code==9)
label variable non_prof "non-professional occupation"
gen occ=.
replace occ=1 if (Major_Category_Code==1|Major_Category_Code==2|Major_Category_Code==3)
replace occ=2 if (Major_Category_Code==4|Major_Category_Code==5|Major_Category_Code==6|Major_Category_Code==7|Major_Category_Code==8)
replace occ=3 if (Major_Category_Code==9)
label variable occ "occupational group"
label define occ 1 "Professional" 2 "Semi-professional" 3 "Non-professional"
label values occ occ 

gen TMET_week = TMET/7

gen travel_cat = . 
replace travel_cat = 1 if TMET_week >=600
replace travel_cat = 0 if TMET_week <600
replace travel_cat = . if TMET_week == .


*Regression Equation:
foreach x in z_InD z_LUM z_Res walkabilty {

regress TMET `x' gender partage i.educ i.occ, vce(robust)

logistic travel_cat `x' gender partage i.educ i.occ, vce(robust)

}
