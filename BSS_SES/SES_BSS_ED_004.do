clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_004.do
**  Project:      	Macroscale Walkability- PhD
**  Analyst:		Kern Rocke
**	Date Created:	28/10/2019
**	Date Modified: 	20/11/2019
**  Algorithm Task: Correlations and Inital PCA Analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 80

*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

**Aggregated data path
local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"

/*
Note check correlations between variables. Correlations giving r=0.99 should not be 
considered

Check median income values of 999999. This may be indicated as missing values.
Consider using income proportions

Retention of Components using the following criteria
1) Eigen Value >1
2) Indivudal percent variance explained >5%
3) Cummulative percent variance explained 80%
4) Cummulative percent variance explained 90%
5) Horn's Parallel PCA Analysis
*/

** ------------------------------------------
** FILE 1-PCA ANALYSIS
** ------------------------------------------

use "`datapath'/version01/2-working/BSS_SES/BSS_SES_002", clear

*List of SES Variables 

*1) Income: per_t_income_0_49 per_high_income t_income_median
*2) Education: per_education_less_secondary per_t_education_tertiary
*3) Age: t_age_median per_young_age_depend per_old_age_depend
*4) Home Amentities:  per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_tv per_amentities_radio per_amentities_wash per_amentities_computer
*5) Occupation: per_prof_occupation per_prof_techoccupation per_prof_n_techoccupation 
*6) House Tenure: per_htenure_owned per_renting
*7) Work Activity: per_t_wactivity_government per_private_wactivity
*8) Crime: per_crime_victim
*9) Household Size: hsize_mean
*10) Crowding: per_live_5_more
*11) Single Mother: per_smother_total
*12) Marital Status: per_marital_n_married
*13) Household Structure: per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0
*14) Vehicle Ownership: per_vehicle_presence
*15) Unemployment: per_unemployment per_t_wactivity_no_work



**Initalize macros
global xlist	per_t_income_0_49  per_high_income t_income_median	///
				t_age_median per_young_age_depend per_old_age_depend	///
				per_education_less_secondary per_t_education_tertiary	///
				per_htenure_owned per_renting	///
				per_amentities_stove per_amentities_fridge ///
				per_amentities_microwave per_amentities_tv ///
				per_amentities_radio per_amentities_wash  ///
				per_amentities_computer	///
				per_t_wactivity_government per_private_wactivity ///
				per_prof_occupation per_prof_techoccupation ///
				per_prof_n_techoccupation		///
				per_unemployment per_t_wactivity_no_work	///
				per_crime_victim per_smother_total per_marital_n_married	///
				per_vehicle_presence ///
				hsize_mean per_rooms_less_3 per_bedrooms_less_2 	///
				per_bathroom_0 per_live_5_more 	///
			
global ED

** Describe SES categories
des $xlist
sum $xlist
tabstat $xlist, by(parish) stat(mean)
corr $xlist

**Correlations between SES categories
preserve
matrix CORR = r(C) 
mata
    a=st_matrix("CORR")
    LCORR=vech(a)
    CORR = st_matrix("CORR", LCORR)
end
svmat CORR
keep CORR 
drop if CORR == 1 
drop if CORR == .
gen ind = _n

    ** Plot the correlations --> INDEX PLOT
    ** To visually show the correlation sizes 
    #delimit ;
	graph twoway
		/// Correlation
		(sc CORR ind , msize(3.5) m(o) mlc(gs0) mfc("41 89 255 %75") mlw(0.1))
		,
			graphregion(color(gs16)) 
            ysize(5) xsize(10)

			xlab(0(25)550 , labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill lc(gs0))
			xtitle("Correlations", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(25)550, tlc(gs0))

			ylab(-1.0(0.1)1.0
			,
			valuelabel labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.2f))
			yscale(noline lw(vthin) )
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2))

            yline(0, lc(gs2 ) lp("-"))

			legend(off size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3 4)
			lab(2 "Min 30q70")
			lab(3 "Max 30q70")
			lab(4 "Regional 30q70")
            )
            name(corelations)
            ;
    #delimit cr
graph export "`outputpath'/SES_Index/05_Outputs/scatter_plot_ses.png", replace height(550)
restore

*-------------------------------------------------------------------------------
*Inital PCA analysis
pca $xlist, blanks(0.3)

*Screeplot
screeplot, yline(1)
graph export "`outputpath'/SES_Index/05_Outputs/screeplot_ses.png", replace height(550)

*Orthogonal rotation
rotate, varimax blanks(0.3)

*Oblique rotation
rotate, promax blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_pca*

egen ses_score_pca = rowtotal(ses_score*)
label var ses_score_pca "SES Score for all components after PCA"
drop ses_score_pca1 - ses_score_pca33

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using eigen values >1 = 7 components

*Inital PCA analysis
pca $xlist, mineigen(1) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(7) blanks(0.3)

*Oblique rotation
rotate, promax components(7) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_eigen*

egen ses_score_eigen = rowtotal(ses_score_eigen*)
label var ses_score_eigen "SES Score for all components using eigen >1"
drop ses_score_eigen1 - ses_score_eigen7

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using individual variance (>5%) = 5 components

/*
    --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      12.6344      9.80967             0.3829       0.3829
           Comp2 |      2.82478      .195424             0.0856       0.4685
           Comp3 |      2.62936      .358153             0.0797       0.5481
           Comp4 |       2.2712      .585077             0.0688       0.6170
           Comp5 |      1.68613       .34913             0.0511       0.6681
           Comp6 |        1.337      .290586             0.0405       0.7086
           Comp7 |      1.04641     .0886104             0.0317       0.7403
           Comp8 |        .9578      .159713             0.0290       0.7693
           Comp9 |      .798087     .0196157             0.0242       0.7935
          Comp10 |      .778471     .0928513             0.0236       0.8171
          Comp11 |       .68562     .0511191             0.0208       0.8379
          Comp12 |      .634501     .0693547             0.0192       0.8571
          Comp13 |      .565146    .00964337             0.0171       0.8742
          Comp14 |      .555503      .100081             0.0168       0.8910
          Comp15 |      .455421    .00657658             0.0138       0.9048
          Comp16 |      .448845     .0633384             0.0136       0.9184
          Comp17 |      .385506     .0564637             0.0117       0.9301
          Comp18 |      .329043     .0202059             0.0100       0.9401
          Comp19 |      .308837     .0531587             0.0094       0.9495
          Comp20 |      .255678     .0287641             0.0077       0.9572
          Comp21 |      .226914     .0304081             0.0069       0.9641
          Comp22 |      .196506     .0376352             0.0060       0.9700
          Comp23 |      .158871     .0149684             0.0048       0.9749
          Comp24 |      .143902    .00981023             0.0044       0.9792
          Comp25 |      .134092     .0308772             0.0041       0.9833
          Comp26 |      .103215    .00921606             0.0031       0.9864
          Comp27 |     .0939987     .0139721             0.0028       0.9893
          Comp28 |     .0800266    .00572894             0.0024       0.9917
          Comp29 |     .0742976    .00734626             0.0023       0.9939
          Comp30 |     .0669514    .00543985             0.0020       0.9960
          Comp31 |     .0615115     .0172721             0.0019       0.9978
          Comp32 |     .0442394      .016537             0.0013       0.9992
          Comp33 |     .0277024            .             0.0008       1.0000
    --------------------------------------------------------------------------
*/

*Inital PCA analysis
pca $xlist, components(5) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(5) blanks(0.3)

*Oblique rotation
rotate, promax components(5) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_i_5percent*

egen ses_score_i_5percent = rowtotal(ses_score_i_5percent*)
label var ses_score_i_5percent "SES Score for all components using individual percentage variance explained >5%"
drop ses_score_i_5percent1 - ses_score_i_5percent5

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (80%) = 10 components

*Inital PCA analysis
pca $xlist, components(10) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(10) blanks(0.3)

*Oblique rotation
rotate, promax components(10) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_c_80percent*

egen ses_score_c_80percent = rowtotal(ses_score_c_80percent*)
label var ses_score_c_80percent "SES Score for all components using cummulative percentage variance explained 80%"
drop ses_score_c_80percent1 - ses_score_c_80percent10

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (90%) = 15 components

*Inital PCA analysis
pca $xlist, components(15) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(15) blanks(0.3)

*Oblique rotation
rotate, promax components(15) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_c_90percent*

egen ses_score_c_90percent = rowtotal(ses_score_c_90percent*)
label var ses_score_c_90percent "SES Score for all components using cummulative percentage variance explained 90%"
drop ses_score_c_90percent1 - ses_score_c_90percent15

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
* Horn Parallel PCA analysis = 6 components

/*
Results of Horn's Parallel Analysis for principal components
990 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          12.168001   12.634446     .46644461
 2          2.41983     2.8247803     .40495038
 3          2.2983861   2.629356      .33096993
 4          1.9595735   2.2712033     .31162977
 5          1.3866227   1.686126      .29950333
 6          1.0767359   1.3369963     .26026046
 7          .7986174    1.0464099     .24779248
--------------------------------------------------
Criterion: retain adjusted components > 1
*/

*Horn's Parallel Analysis
paran $xlist, graph color 
graph export "`outputpath'/SES_Index/05_Outputs/horn_pca.png", replace

*Inital PCA analysis
pca $xlist, components(6) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(6) blanks(0.3)

*Oblique rotation
rotate, promax components(6) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_horn*

egen ses_score_horn = rowtotal(ses_score_horn*)
label var ses_score_horn "SES Score for all components using Horn Parallel Analysis"
drop ses_score_horn1 - ses_score_horn6

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 
*-------------------------------------------------------------------------------


**Summary of ses index scores
sum ses_score*
tabstat ses_score*, by(parish) stat(mean median)


*Loop for SES categortization
foreach x in  ses_score_pca ses_score_eigen ses_score_i_5percent ///
				ses_score_c_80percent ses_score_c_90percent ses_score_horn {

**Categorize SES index scores into deciles				
xtile ses_dec_`x' = `x', nq(10)			

**Categorize deciles into high and low SES
gen ses_cat_`x' = ses_dec_`x'
recode ses_cat_`x' (1/4=1) (5/6=2) (7/10=3)
label var ses_cat_`x' "Socioeconomic Index Categories `x'"
label define ses_cat_`x' 3"High" 1"Low" 2"Medium"
label value ses_cat_`x' ses_cat_`x'			
		
**Tabulate SES by ED and parishes
tab ses_cat_`x' parish
				}

*Label Data
label data "SES Indicators by Ennumeration Districts - Barbabdos Statistical Service (p3)"

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/BSS_SES_003", replace

*Save data in Excel format for GIS import
export excel "`datapath'/version01/2-working/BSS_SES/SES_data.xlsx", firstrow(variables) replace


*-------------------------End---------------------------------------------------