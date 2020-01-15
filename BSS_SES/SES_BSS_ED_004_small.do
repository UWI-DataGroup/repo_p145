clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_004_small.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	28/10/2019
**	Date Modified: 	15/01/2019
**  Algorithm Task: Correlations, PCA Analysis and LASSO regression (Small Variable Model)


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

**Aggregated output path
*WINDOWS
local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"
*MAC
*local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*Open log file to store results
log using "`logpath'/version01/3-output/BSS_SES/PCA_Results/VSM_small.log", name(VSM_small) replace


*-------------------------------------------------------------------------------

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

*Replace missing code 999999 with .
replace t_income_median = . if t_income_median>559999

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
global small_list	t_age_median per_t_education_less_secondary per_t_income_0_49 ///
					per_vehicles_0 per_t_prof_occupation per_t_unemployment ///
					per_amentities_stove per_amentities_fridge ///
					per_amentities_wash per_amentities_tv ///
					per_amentities_computer
			
global ED

** Describe SES categories
des $small_list
sum $small_list
tabstat $small_list, by(parish) stat(mean)
corr $small_list

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

			xlab(0(5)60 , labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill lc(gs0))
			xtitle("Correlations", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(5)60, tlc(gs0))

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
graph export "`outputpath'/SES_Index/05_Outputs/scatter_plot_ses_vsm_small.png", replace height(550)
restore

*-------------------------------------------------------------------------------
*PCA Analysis - Unrotated

*Inital PCA analysis
pca $small_list, blanks(0.3)

*Screeplot
screeplot, yline(1)
graph export "`outputpath'/SES_Index/05_Outputs/screeplot_ses_vsm_small.png", replace height(550)

*Orthogonal rotation
rotate, varimax blanks(0.3)

*Oblique rotation
rotate, promax blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_pca*

egen ses_score_pca = rowtotal(ses_score_pca*)
label var ses_score_pca "SES Score for all components after PCA"
drop ses_score_pca1 - ses_score_pca11

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*Ranking of SES index score using PCA - no-rotation				
egen rank_s_pca = rank(-ses_score_pca)
label var rank_s_pca "Ranking of PCA SES scores for VSM small model usnig unrotated PCA"


*-------------------------------------------------------------------------------
*PCA Analysis using eigen values >1 = 3 components using Orthogonal rotation

*Inital PCA analysis
pca $small_list, mineigen(1) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(3) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_eigen_vari*

egen ses_score_eigen_vari = rowtotal(ses_score_eigen_vari*)
label var ses_score_eigen_vari "SES Score for all components using eigen >1 using Varimax rotation"
drop ses_score_eigen_vari1 - ses_score_eigen_vari3

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*Ranking of SES index score using PCA - Eigen >1 and varimax rotation			
egen rank_s_eigen_var = rank(-ses_score_eigen_vari)
label var rank_s_eigen_var  "Ranking of PCA SES scores for VSM small model usnig Eigen >1 and Varimax Rotated PCA"

*-------------------------------------------------------------------------------
*PCA Analysis using eigen values >1 = 3 components using Oblique rotation

*Inital PCA analysis
pca $small_list, mineigen(1) blanks(0.3)

*Oblique rotation
rotate, promax components(3) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_eigen_pro*

egen ses_score_eigen_pro = rowtotal(ses_score_eigen_pro*)
label var ses_score_eigen_pro "SES Score for all components using eigen >1 using Promax rotation"
drop ses_score_eigen_pro1 - ses_score_eigen_pro3

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*Ranking of SES index score using PCA - Eigen >1 and promax rotation				
egen rank_s_eigen_pro = rank(-ses_score_eigen_pro)
label var rank_s_eigen_pro  "Ranking of PCA SES scores for VSM small model usnig Eigen >1 and Promax Rotated PCA"


*-------------------------------------------------------------------------------
*PCA Analysis using individual variance (>5%) = 5 components using Varimax rotation

/*
    --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      6.02972      4.36909             0.5482       0.5482
           Comp2 |      1.66063      .492305             0.1510       0.6991
           Comp3 |      1.16832      .374791             0.1062       0.8053
           Comp4 |      .793532      .206051             0.0721       0.8775
           Comp5 |      .587481      .291092             0.0534       0.9309
           Comp6 |      .296389      .120966             0.0269       0.9578
           Comp7 |      .175423     .0581858             0.0159       0.9738
           Comp8 |      .117238     .0232056             0.0107       0.9844
           Comp9 |      .094032     .0460069             0.0085       0.9930
          Comp10 |     .0480251     .0188195             0.0044       0.9973
          Comp11 |     .0292056            .             0.0027       1.0000
    --------------------------------------------------------------------------

*/

*Inital PCA analysis
pca $small_list, components(5) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(5) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_i_5percent_vari*

egen ses_score_i_5percent_vari = rowtotal(ses_score_i_5percent_vari*)
label var ses_score_i_5percent_vari "SES Score for all components using individual percentage variance explained >5% using varimax rotation"
drop ses_score_i_5percent_vari1 - ses_score_i_5percent_vari5

*Ranking of SES index score using PCA - individual variance (>5%) and varimax rotation			
egen rank_s_i5per_var = rank(-ses_score_i_5percent_vari)
label var rank_s_i5per_var  "Ranking of PCA SES scores for VSM small model usnig Indivdual variance (>5%) and Varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_i_5percent_pro*

egen ses_score_i_5percent_pro = rowtotal(ses_score_i_5percent_pro*)
label var ses_score_i_5percent_pro "SES Score for all components using individual percentage variance explained >5% using promax rotation"
drop ses_score_i_5percent_pro1 - ses_score_i_5percent_pro5

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_s_i5per_pro = rank(-ses_score_i_5percent_pro)
label var rank_s_i5per_pro  "Ranking of PCA SES scores for VSM small model usnig Indivdual variance (>5%) and promax Rotated PCA"


**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (80%) = 3 components

*Inital PCA analysis
pca $small_list, components(3) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(3) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_c_80percent_vari*

egen ses_score_c_80percent_vari = rowtotal(ses_score_c_80percent_vari*)
label var ses_score_c_80percent_vari "SES Score for all components using cummulative percentage variance explained 80% using varimax rotation"
drop ses_score_c_80percent_vari1 - ses_score_c_80percent_vari3

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_s_c80pe_var = rank(-ses_score_c_80percent_vari)
label var rank_s_c80pe_var  "Ranking of PCA SES scores for VSM small model usnig Cummulative variance (>90%) and varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(3) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_c_80percent_pro*

egen ses_score_c_80percent_pro = rowtotal(ses_score_c_80percent_pro*)
label var ses_score_c_80percent_pro "SES Score for all components using cummulative percentage variance explained 80% using promax Rotated PCA"
drop ses_score_c_80percent_pro1 - ses_score_c_80percent_pro3

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_s_c80pe_pro = rank(-ses_score_c_80percent_pro)
label var rank_s_c80pe_pro  "Ranking of PCA SES scores for VSM small model usnig Cummulative variance (>80%) and promax Rotated PCA"

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (90%) = 5 components

*Inital PCA analysis
pca $small_list, components(5) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(5) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_c_90percent_vari*

egen ses_score_c_90percent_vari = rowtotal(ses_score_c_90percent_vari*)
label var ses_score_c_90percent_vari "SES Score for all components using cummulative percentage variance explained 90% using varimax Rotated PCA"
drop ses_score_c_90percent_vari1 - ses_score_c_90percent_vari5

*Ranking of SES index score using PCA - cummulative variance (>90%) and varimax rotation			
egen rank_s_c90pe_var = rank(-ses_score_c_90percent_vari)
label var rank_s_c90pe_var  "Ranking of PCA SES scores for VSM small model usnig Cummulative variance (>90%) and varimax Rotated PCA"


*****************************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_c_90percent_pro*

egen ses_score_c_90percent_pro = rowtotal(ses_score_c_90percent_pro*)
label var ses_score_c_90percent_pro "SES Score for all components using cummulative percentage variance explained 90% using promax Rotated PCA"
drop ses_score_c_90percent_pro1 - ses_score_c_90percent_pro5

*Ranking of SES index score using PCA - cummulative variance (>90%) and promax rotation			
egen rank_s_c90pe_pro = rank(-ses_score_c_90percent_pro)
label var rank_s_c90pe_pro  "Ranking of PCA SES scores for VSM small model usnig Cummulative variance (>90%) and promax Rotated PCA"

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
* Horn Parallel PCA analysis = 3 components

/*

Results of Horn's Parallel Analysis for principal components
330 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          5.8084057   6.0297224     .2213167
 2          1.4933177   1.6606285     .16731083
 3          1.0524206   1.1683235     .1159029
--------------------------------------------------
Criterion: retain adjusted components > 1

*/

*Horn's Parallel Analysis
paran $small_list, graph color iterations(1000)
graph export "`outputpath'/SES_Index/05_Outputs/horn_pca_vsm_small.png", replace

*Inital PCA analysis
pca $small_list, components(3) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(3) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_horn_vari*

egen ses_score_horn_vari = rowtotal(ses_score_horn_vari*)
label var ses_score_horn_vari "SES Score for all components using Horn Parallel Analysis"
drop ses_score_horn_vari1 - ses_score_horn_vari3

*Ranking of SES index score using PCA - Horn Parallel Analysis and promax rotation			
egen rank_s_horn_var = rank(-ses_score_horn_vari)
label var rank_s_horn_var  "Ranking of PCA SES scores for VSM small model usnig Horn Paralell Analysis and varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(3) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score_horn_pro*

egen ses_score_horn_pro = rowtotal(ses_score_horn_pro*)
label var ses_score_horn_pro "SES Score for all components using Horn Parallel Analysis"
drop ses_score_horn_pro1 - ses_score_horn_pro3

*Ranking of SES index score using PCA - Horn Parallel Analysis and promax rotation			
egen rank_s_horn_pro = rank(-ses_score_horn_pro)
label var rank_s_horn_pro  "Ranking of PCA SES scores for VSM small model usnig Horn Paralell Analysis and promax Rotated PCA"


**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 
*-------------------------------------------------------------------------------


**Summary of ses index scores
sum ses_score*
tabstat ses_score*, by(parish) stat(mean median)

*-------------------------------------------------------------------------------

*-----------------------------LASSO---------------------------------------------
preserve

gen t_cat = .
replace t_cat = 0 if t_income_median==.
recode t_cat (.=1)

tab t_cat

*Imputation Model
mi set mlong
misstable sum t_income_median
mi register imputed t_income_median 
set seed 29390

*Predictive Mean Matching
mi impute chained (regress) t_income_median = t_age_median hsize_mean , add(20)
	
*Listing mean total median income for missing median income EDs											
mi estimate: mean t_income_median if t_cat==0, over(ED)

gen data = _mi_m
recode data (2/max=1) 
tab data

*-------------------------------------------------------------------------------

*Lasso linear model
lasso linear pop_density $small_list if data==0, rseed(1234)
cvplot					// Cross-validation plot
estimates store cv 		// Storing estimates of linear model


*LASSO BIC model
lassoknots, display(nonzero osr2 bic)
lassoselect id = 36		// Selecting model 36- Model with the lowest BIC
cvplot					// Cross-validation plot with bic and linear model
estimates store minBIC	// Storing estimates minimum BIC model


*LASSO Adapative model
lasso linear pop_density $small_list if data==0, selection(adaptive) rseed(1234)
estimates store adaptive	// Storing estimates of adaptive model


* Table of standardized coeficients used for each model
lassocoef cv minBIC adaptive, sort(coef, standardized) nofvlabel


*Assess goodness of fit for each of the models used on training datasets
lassogof cv minBIC adaptive,  over(data) postselection

tabstat _est_cv _est_minBIC _est_adaptive, by(parish) stat(mean)

restore 

*-------------------------------------------------------------------------------
/* LASSO Variable Selection outputpath

----------------------------------------------------------------
                               |    cv       minBIC    adaptive 
-------------------------------+--------------------------------
                per_vehicles_0 |     x         x          x     
          per_amentities_stove |     x         x          x     
           per_amentities_wash |     x         x          x     
per_t_education_less_secondary |     x         x          x     
                  t_age_median |     x         x          x     
             per_amentities_tv |     x                    x     
       per_amentities_computer |     x         x          x     
         per_t_prof_occupation |     x         x          x     
             per_t_income_0_49 |     x    
            per_t_unemployment |     x    
                         _cons |     x         x          x     
----------------------------------------------------------------

--------------------------------------------------------------------------------
*/

*PCA Model with LASSO variable selection

global small_list_cv		per_vehicles_0 per_amentities_stove per_amentities_wash	///
							per_t_education_less_secondary t_age_median per_amentities_tv	///
							per_amentities_computer per_t_prof_occupation per_t_income_0_49	///
							per_t_unemployment

global small_list_minBIC	per_vehicles_0 per_amentities_stove per_amentities_wash	///
							per_t_education_less_secondary t_age_median 	///
							per_amentities_computer per_t_prof_occupation 

global small_list_adapt		per_vehicles_0 per_amentities_stove per_amentities_wash	///
							per_t_education_less_secondary t_age_median per_amentities_tv	///
							per_amentities_computer per_t_prof_occupation 

*-------------------------------------------------------------------------------

*Horn Paralell Analysis
paran $small_list_cv, graph color iterations(1000)

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          5.106238    5.2793273     .17308939
 2          1.3760642   1.5108869     .13482273
 3          1.0436198   1.1356932     .09207344
--------------------------------------------------
Criterion: retain adjusted components > 1

*/


*Principle Component Analysis Model							
pca $small_list_cv, mineigen(1)

/*

 --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      5.27933      3.76844             0.5279       0.5279
           Comp2 |      1.51089      .375194             0.1511       0.6790
           Comp3 |      1.13569      .353401             0.1136       0.7926
           Comp4 |      .782293       .20769             0.0782       0.8708
           Comp5 |      .574602      .278927             0.0575       0.9283
           Comp6 |      .295675      .120284             0.0296       0.9578
           Comp7 |      .175391     .0617707             0.0175       0.9754
           Comp8 |      .113621      .019864             0.0114       0.9867
           Comp9 |     .0937567     .0550028             0.0094       0.9961
          Comp10 |     .0387539            .             0.0039       1.0000
    --------------------------------------------------------------------------

	*/


	*NOTE: Eigen and Horn Paralell Analysis same number of retained components
	
	
*Varimax Rotation
rotate, varimax components(3) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_cv_eigen_var = rowtotal( com*)
tabstat _vsm_small_cv_eigen_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_eigen_var = rank(-_vsm_small_cv_eigen_var)
label var rank_vsm_small_cv_eigen_var "Ranking of PCA Scores using Eigen value >1 and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(3) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_cv_eigen_pro = rowtotal( com*)
tabstat _vsm_small_cv_eigen_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_eigen_pro = rank(-_vsm_small_cv_eigen_pro)
label var rank_vsm_small_cv_eigen_pro "Ranking of PCA Scores using Eigen value >1 and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $small_list_cv, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_cv_i5per_var = rowtotal( com*)
tabstat _vsm_small_cv_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_i5per_var = rank(-_vsm_small_cv_i5per_var)
label var rank_vsm_small_cv_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_cv_i5per_pro = rowtotal( com*)
tabstat _vsm_small_cv_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_i5per_pro = rank(-_vsm_small_cv_i5per_pro)
label var rank_vsm_small_cv_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $small_list_cv, components(4)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_cv_c80pe_var = rowtotal( com*)
tabstat _vsm_small_cv_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_c80pe_var = rank(-_vsm_small_cv_c80pe_var)
label var rank_vsm_small_cv_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_cv_c80pe_pro = rowtotal( com*)
tabstat _vsm_small_cv_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_c80pe_pro = rank(-_vsm_small_cv_c80pe_pro)
label var rank_vsm_small_cv_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $small_list_cv, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_cv_c90pe_var = rowtotal( com*)
tabstat _vsm_small_cv_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_c90pe_var = rank(-_vsm_small_cv_c90pe_var)
label var rank_vsm_small_cv_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_cv_c90pe_pro = rowtotal( com*)
tabstat _vsm_small_cv_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_cv_c90pe_pro = rank(-_vsm_small_cv_c90pe_pro)
label var rank_vsm_small_cv_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM small model using CV from LASSO Regression"

*-------------------------------------------------------------------------------

*Horn Paralell Analysis
paran $small_list_minBIC, graph color iterations(1000)

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          4.3277629   4.4407981     .1130352
 2          1.0060924   1.0680717     .06197929
--------------------------------------------------
Criterion: retain adjusted components > 1

*/


*Principle Component Analysis Model							
pca $small_list_minBIC, components(2)

/*

 
    --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |       4.4408      3.37273             0.6344       0.6344
           Comp2 |      1.06807      .348758             0.1526       0.7870
           Comp3 |      .719313      .327757             0.1028       0.8897
           Comp4 |      .391556      .208844             0.0559       0.9457
           Comp5 |      .182713     .0765356             0.0261       0.9718
           Comp6 |      .106177     .0148064             0.0152       0.9869
           Comp7 |     .0913708            .             0.0131       1.0000
    --------------------------------------------------------------------------

	*/

	*NOTE: Eigen and Horn Paralell Analysis same number of retained components
	
	
*Varimax Rotation
rotate, varimax components(2) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen ses_score_vsm_small_minBIC_var = rowtotal( com*)
tabstat ses_score_vsm_small_minBIC_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_eigen_var = rank(-ses_score_vsm_small_minBIC_var)
label var rank_vsm_small_minBIC_eigen_var "Ranking of PCA Scores using varimax for VSM small modell using minBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(2) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen ses_score_vsm_small_minBIC_pro = rowtotal( com*)
tabstat ses_score_vsm_small_minBIC_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_eigen_pro = rank(-ses_score_vsm_small_minBIC_pro)
label var rank_vsm_small_minBIC_eigen_pro "Ranking of PCA Scores using promax for VSM small modell using minBIC from LASSO Regression"

*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $small_list_minBIC, components(4)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_minBIC_i5per_var = rowtotal( com*)
tabstat _vsm_small_minBIC_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_i5per_var = rank(-_vsm_small_minBIC_i5per_var)
label var rank_vsm_small_minBIC_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_minBIC_i5per_pro = rowtotal( com*)
tabstat _vsm_small_minBIC_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_i5per_pro = rank(-_vsm_small_minBIC_i5per_pro)
label var rank_vsm_small_minBIC_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $small_list_minBIC, components(3)

*Varimax Rotation
rotate, varimax components(3) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_minBIC_c80pe_var = rowtotal( com*)
tabstat _vsm_small_minBIC_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_c80pe_var = rank(-_vsm_small_minBIC_c80pe_var)
label var rank_vsm_small_minBIC_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(3) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_minBIC_c80pe_pro = rowtotal( com*)
tabstat _vsm_small_minBIC_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_c80pe_pro = rank(-_vsm_small_minBIC_c80pe_pro)
label var rank_vsm_small_minBIC_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $small_list_minBIC, components(4)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_minBIC_c90pe_var = rowtotal( com*)
tabstat _vsm_small_minBIC_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_c90pe_var = rank(-_vsm_small_minBIC_c90pe_var)
label var rank_vsm_small_minBIC_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_minBIC_c90pe_pro = rowtotal( com*)
tabstat _vsm_small_minBIC_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_minBIC_c90pe_pro = rank(-_vsm_small_minBIC_c90pe_pro)
label var rank_vsm_small_minBIC_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Horn Paralell Analysis
paran $small_list_adapt, graph color iterations(1000)

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          4.8674841   5.0457323     .17824817
 2          1.2094838   1.3568093     .14732552
--------------------------------------------------

Criterion: retain adjusted components > 1
*/


*Principle Component Analysis Model							
pca $small_list_adapt, mineigen(1)

/*

  --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      5.04573      3.68892             0.6307       0.6307
           Comp2 |      1.35681      .627668             0.1696       0.8003
           Comp3 |      .729141      .292577             0.0911       0.8915
           Comp4 |      .436564      .253559             0.0546       0.9460
           Comp5 |      .183005     .0671847             0.0229       0.9689
           Comp6 |       .11582     .0217334             0.0145       0.9834
           Comp7 |     .0940865     .0552439             0.0118       0.9951
           Comp8 |     .0388426            .             0.0049       1.0000
    --------------------------------------------------------------------------


	*/

*Varimax Rotation
rotate, varimax components(2) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen ses_score_vsm_small_adapt_var = rowtotal( com*)
tabstat ses_score_vsm_small_adapt_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_eigen_var = rank(-ses_score_vsm_small_adapt_var)
label var rank_vsm_small_adapt_eigen_var "Ranking of PCA Scores using varimax for VSM small modell using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(2) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen ses_score_vsm_small_adapt_pro = rowtotal( com*)
tabstat ses_score_vsm_small_adapt_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_eigen_pro = rank(-ses_score_vsm_small_adapt_pro)
label var rank_vsm_small_adapt_eigen_pro "Ranking of PCA Scores using promax for VSM small modell using Selection Adaptive from LASSO Regression"

*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $small_list_adapt, components(4)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_adapt_i5per_var = rowtotal( com*)
tabstat _vsm_small_adapt_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_i5per_var = rank(-_vsm_small_adapt_i5per_var)
label var rank_vsm_small_adapt_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_adapt_i5per_pro = rowtotal( com*)
tabstat _vsm_small_adapt_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_i5per_pro = rank(-_vsm_small_adapt_i5per_pro)
label var rank_vsm_small_adapt_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $small_list_adapt, components(3)

*Varimax Rotation
rotate, varimax components(3) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_adapt_c80pe_var = rowtotal( com*)
tabstat _vsm_small_adapt_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_c80pe_var = rank(-_vsm_small_adapt_c80pe_var)
label var rank_vsm_small_adapt_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(3) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_adapt_c80pe_pro = rowtotal( com*)
tabstat _vsm_small_adapt_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_c80pe_pro = rank(-_vsm_small_adapt_c80pe_pro)
label var rank_vsm_small_adapt_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM small model using CV from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $small_list_adapt, components(4)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_small_adapt_c90pe_var = rowtotal( com*)
tabstat _vsm_small_adapt_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_c90pe_var = rank(-_vsm_small_adapt_c90pe_var)
label var rank_vsm_small_adapt_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM small model using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_small_adapt_c90pe_pro = rowtotal( com*)
tabstat _vsm_small_adapt_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_small_adapt_c90pe_pro = rank(-_vsm_small_adapt_c90pe_pro)
label var rank_vsm_small_adapt_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM small model using CV from LASSO Regression"



*-------------------------------------------------------------------------------

*Label Data
label data "SES Indicators by Ennumeration Districts - Barbabdos Statistical Service (Small SES Variable Model)"

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_small", replace

*Save data in Excel format for GIS import
export excel "`datapath'/version01/2-working/BSS_SES/SES_data_vsm_small.xlsx", firstrow(variables) replace

log close VSM_small

*-------------------------End---------------------------------------------------
