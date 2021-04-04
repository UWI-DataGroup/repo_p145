


*********************************************************************************************************************************************************
*   DESCRIPTION OF PHYSICAL ACTIVITY IN ECHORN DATASET
*********************************************************************************************************************************************************
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
tab inactive siteid, col miss 
tab inactive siteid if gender==1, col miss
tab inactive siteid if gender==2, col miss


/*inactive |
       WHO |
recommenda |                    Site
     tions | US Virgin  Puerto Ri   Barbados  Trinidad  |     Total
-----------+--------------------------------------------+----------
    active |       160        273        555        429 |     1,417 
           |     45.33      35.41      55.06      51.75 |     47.86 
-----------+--------------------------------------------+----------
  inactive |       189        493        449        393 |     1,524 
           |     53.54      63.94      44.54      47.41 |     51.47 
-----------+--------------------------------------------+----------
         . |         4          5          4          7 |        20 
           |      1.13       0.65       0.40       0.84 |      0.68 
-----------+--------------------------------------------+----------
     Total |       353        771      1,008        829 |     2,961 
           |    100.00     100.00     100.00     100.00 |    100.00 */

tab inactive gender if siteid==3 & partage>=45 & partage<65, col miss // comparing to HotN RPAQ out of interest in 45-64 age group (inactive men: 35%; women: 63%) 

 /*inactive|
       WHO |
recommenda |        Gender
     tions |      Male     Female |     Total
-----------+----------------------+----------
    active |       117        230 |       347 
           |     63.24      52.39 |     55.61 
-----------+----------------------+----------
  inactive |        67        208 |       275 
           |     36.22      47.38 |     44.07 
-----------+----------------------+----------
         . |         1          1 |         2 
           |      0.54       0.23 |      0.32 
-----------+----------------------+----------
     Total |       185        439 |       624 
           |    100.00     100.00 |    100.00  */
		   
		   
replace HB21 = 2 if HB22 >18 & HB21 == 1

gen mpdS=.
replace mpdS=(HB22*60) if HB21==1
replace mpdS=HB22 if HB21==2

*Calculating min per week for sedentary
gen mpwS=mpdS*HB10 
replace mpwS=.z if HB10==.z 

egen leisure = rowmean (mpdMR mpdVR)
egen work_activity = rowtotal(mpdVW mpdMW)
egen totalpa = rowtotal(work_activity leisure mpdT)

