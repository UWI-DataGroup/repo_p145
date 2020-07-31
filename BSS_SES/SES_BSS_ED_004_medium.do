
clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_004_medium.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	28/10/2019
**	Date Modified: 	15/01/2019
**  Algorithm Task: Correlations, PCA Analysis and LASSO regression (Medium Variable Model)


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
log using "`logpath'/version01/3-output/BSS_SES/PCA_Results/VSM_medium.log",  replace

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

/*

List of SES Variables 

Ethnicity: Non-black population 
Age: Median age; Young age dependency; Old age dependency
Household size: Mean household size
Housing Tenure: Housing tenure -  Owner; Housing tenure - Renting
Single Parent: Single Mother
Education: Less than secondary education; Tertiary education
Income: Median income; Low income ($0-49999); High income (>$150000)
Unemployment
Crowding: Liveborn children >5
Crime: Crime victim
Occupation: Management occupations; Professional occupations; Technical occupations; Non-technical occupations
Household Structure: Household structure: number of rooms; Household structure: number of bedrooms; Household structure: number of bathrooms
Toilet: Toilet presence 
Vehicle Status: Vehicle Ownership; No Vehicle Ownership
Household Amentities: Stove; Refrigerator; Microwave; Computer; Radio; Television; Washing Machine
Household lighting: Electricity 

*/

**Initalize macros
global medium_list	per_t_non_black t_age_median per_t_young_age_depend 	///
					per_t_old_age_depend ///
					hsize_mean per_htenure_owned per_renting per_smother_total ///
					per_t_education_less_secondary per_t_education_tertiary ///
					per_t_income_0_49 per_t_high_income t_income_median ///
					per_t_unemployment per_live_5_more per_crime_victim ///
					per_t_manage_occupation		///
					per_t_prof_occupation per_t_prof_techoccupation ///
					per_t_prof_n_techoccupation per_rooms_less_3 ///
					per_bedrooms_less_2 per_bathroom_0 per_vehicle_presence ///
					per_vehicles_0 per_amentities_stove per_amentities_fridge ///
					per_amentities_microwave per_amentities_tv ///
					per_amentities_radio per_amentities_wash ///
					per_amentities_computer per_electricity per_toilet_presence
			
global ED

** Describe SES categories
des $medium_list
sum $medium_list
tabstat $medium_list, by(parish) stat(mean)
corr $medium_list

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

			xlab(0(50)600 , labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill lc(gs0))
			xtitle("Correlations", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(50)600, tlc(gs0))

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
graph export "`outputpath'/SES_Index/05_Outputs/scatter_plot_ses_vsm_medium.png", replace height(550)
restore

*-------------------------------------------------------------------------------
*PCA Analysis - Unrotated

*Inital PCA analysis
pca $medium_list, blanks(0.3)

*Screeplot
screeplot, yline(1)
graph export "`outputpath'/SES_Index/05_Outputs/screeplot_ses_vsm_medium.png", replace height(550)

*Orthogonal rotation
rotate, varimax blanks(0.3)

*Oblique rotation
rotate, promax blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _pca*

egen _pca = rowtotal(_pca*)
label var _pca "SES Score for all components after PCA"
drop _pca1 - _pca34

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*Ranking of SES index score using PCA - no-rotation				
egen rank_m_pca = rank(-_pca)
label var rank_m_pca "Ranking of PCA SES scores for VSM medium model usnig unrotated PCA"


*-------------------------------------------------------------------------------
*PCA Analysis using eigen values >1 = 6 components using Orthogonal rotation

*Inital PCA analysis
pca $medium_list, mineigen(1) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(6) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _eigen_var*

egen _eigen_var = rowtotal(_eigen_var*)
label var _eigen_var "SES Score for all components using eigen >1 using Varimax rotation"
drop _eigen_var1 - _eigen_var6

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*Ranking of SES index score using PCA - Eigen >1 and varimax rotation			
egen rank_m_eigen_var = rank(-_eigen_var)
label var rank_m_eigen_var  "Ranking of PCA SES scores for VSM medium model usnig Eigen >1 and Varimax Rotated PCA"

*-------------------------------------------------------------------------------
*PCA Analysis using eigen values >1 = 3 components using Oblique rotation

*Inital PCA analysis
pca $medium_list, mineigen(1) blanks(0.3)

*Oblique rotation
rotate, promax components(6) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _eigen_pro*

egen _eigen_pro = rowtotal(_eigen_pro*)
label var _eigen_pro "SES Score for all components using eigen >1 using Promax rotation"
drop _eigen_pro1 - _eigen_pro6

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*Ranking of SES index score using PCA - Eigen >1 and promax rotation				
egen rank_m_eigen_pro = rank(-_eigen_pro)
label var rank_m_eigen_pro  "Ranking of PCA SES scores for VSM medium model usnig Eigen >1 and Promax Rotated PCA"


*-------------------------------------------------------------------------------
*PCA Analysis using individual variance (>5%) = 4 components using Varimax rotation

*Inital PCA analysis
pca $medium_list, components(4) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(4) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _i5per_var*

egen _i5per_var = rowtotal(_i5per_var*)
label var _i5per_var "SES Score for all components using individual percentage variance explained >5% using varimax rotation"
drop _i5per_var1 - _i5per_var4

*Ranking of SES index score using PCA - individual variance (>5%) and varimax rotation			
egen rank_m_i5per_var = rank(-_i5per_var)
label var rank_m_i5per_var  "Ranking of PCA SES scores for VSM medium model usnig Indivdual variance (>5%) and Varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _i5per_pro*

egen _i5per_pro = rowtotal(_i5per_pro*)
label var _i5per_pro "SES Score for all components using individual percentage variance explained >5% using promax rotation"
drop _i5per_pro1 - _i5per_pro4

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_m_i5per_pro = rank(-_i5per_pro)
label var rank_m_i5per_pro  "Ranking of PCA SES scores for VSM medium model usnig Indivdual variance (>5%) and promax Rotated PCA"


**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (80%) = 9 components

*Inital PCA analysis
pca $medium_list, components(9) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(9) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c80pe_var*

egen _c80pe_var = rowtotal(_c80pe_var*)
label var _c80pe_var "SES Score for all components using cummulative percentage variance explained 80% using varimax rotation"
drop _c80pe_var1 - _c80pe_var9

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_m_c80pe_var = rank(-_c80pe_var)
label var rank_m_c80pe_var  "Ranking of PCA SES scores for VSM medium model usnig Cummulative variance (>90%) and varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(9) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c80pe_pro*

egen _c80pe_pro = rowtotal(_c80pe_pro*)
label var _c80pe_pro "SES Score for all components using cummulative percentage variance explained 80% using promax Rotated PCA"
drop _c80pe_pro1 - _c80pe_pro9

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_m_c80pe_pro = rank(-_c80pe_pro)
label var rank_m_c80pe_pro  "Ranking of PCA SES scores for VSM medium model usnig Cummulative variance (>80%) and promax Rotated PCA"

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (90%) = 14 components

*Inital PCA analysis
pca $medium_list, components(14) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(14) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c90pe_var*

egen _c90pe_var = rowtotal(_c90pe_var*)
label var _c90pe_var "SES Score for all components using cummulative percentage variance explained 90% using varimax Rotated PCA"
drop _c90pe_var1 - _c90pe_var14

*Ranking of SES index score using PCA - cummulative variance (>90%) and varimax rotation			
egen rank_m_c90pe_var = rank(-_c90pe_var)
label var rank_m_c90pe_var  "Ranking of PCA SES scores for VSM medium model usnig Cummulative variance (>90%) and varimax Rotated PCA"


*****************************

*Oblique rotation
rotate, promax components(14) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c90pe_pro*

egen _c90pe_pro = rowtotal(_c90pe_pro*)
label var _c90pe_pro "SES Score for all components using cummulative percentage variance explained 90% using promax Rotated PCA"
drop _c90pe_pro1 - _c90pe_pro14

*Ranking of SES index score using PCA - cummulative variance (>90%) and promax rotation			
egen rank_m_c90pe_pro = rank(-_c90pe_pro)
label var rank_m_c90pe_pro  "Ranking of PCA SES scores for VSM medium model usnig Cummulative variance (>90%) and promax Rotated PCA"

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
* Horn Parallel PCA analysis = 3 components

*Horn's Parallel Analysis
paran $medium_list, graph color iterations(1000)
graph export "`outputpath'/SES_Index/05_Outputs/horn_pca_vsm_medium.png", replace

*Inital PCA analysis
pca $medium_list, components(6) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(6) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _horn_var*

egen _horn_var = rowtotal(_horn_var*)
label var _horn_var "SES Score for all components using Horn Parallel Analysis"
drop _horn_var1 - _horn_var6

*Ranking of SES index score using PCA - Horn Parallel Analysis and promax rotation			
egen rank_m_horn_var = rank(-_horn_var)
label var rank_m_horn_var  "Ranking of PCA SES scores for VSM medium model usnig Horn Paralell Analysis and varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(6) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _horn_pro*

egen _horn_pro = rowtotal(_horn_pro*)
label var _horn_pro "SES Score for all components using Horn Parallel Analysis"
drop _horn_pro1 - _horn_pro6

*Ranking of SES index score using PCA - Horn Parallel Analysis and promax rotation			
egen rank_m_horn_pro = rank(-_horn_pro)
label var rank_m_horn_pro  "Ranking of PCA SES scores for VSM medium model usnig Horn Paralell Analysis and promax Rotated PCA"


**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 
*-------------------------------------------------------------------------------
			
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
lasso linear pop_density $medium_list if data==0, rseed(1234)
cvplot					// Cross-validation plot
estimates store cv 		// Storing estimates of linear model


*LASSO BIC model
lassoknots, display(nonzero osr2 bic)
lassoselect id = 30		// Selecting model 30- Model with the lowest BIC
cvplot					// Cross-validation plot with bic and linear model
estimates store minBIC	// Storing estimates minimum BIC model


*LASSO Adapative model
lasso linear pop_density $medium_list if data==0, selection(adaptive) rseed(1234)
estimates store adaptive	// Storing estimates of adaptive model


* Table of standardized coeficients used for each model
lassocoef cv minBIC adaptive, sort(coef, standardized) nofvlabel


*Assess goodness of fit for each of the models used on training datasets
lassogof cv minBIC adaptive,  over(data) postselection

tabstat _est_cv _est_minBIC _est_adaptive, by(parish) stat(mean)

restore 


*-------------------------------------------------------------------------------


*PCA Model with LASSO variable selection

global medium_list_cv			per_renting per_vehicle_presence ///
								per_t_education_less_secondary per_smother_total ///
								per_bedrooms_less_2 hsize_mean per_amentities_wash ///
								per_amentities_microwave per_t_non_black ///
								t_income_median per_t_prof_techoccupation ///
								per_t_young_age_depend per_t_education_tertiary ///
								per_amentities_tv per_bathroom_0 ///
								per_t_prof_n_techoccupation per_t_high_income ///
								per_live_5_more per_rooms_less_3 per_crime_victim ///
								per_t_old_age_depend per_vehicles_0 ///
								per_t_income_0_49 per_t_manage_occupation ///
								per_t_unemployment

global medium_list_minBIC		per_renting per_vehicle_presence ///
								per_t_education_less_secondary per_smother_total ///
								per_bedrooms_less_2  per_amentities_microwave ///
								per_t_non_black t_income_median ///
								per_t_prof_techoccupation per_t_young_age_depend ///
								per_t_education_tertiary per_bathroom_0 ///
								per_t_prof_n_techoccupation per_t_high_income ///
								per_live_5_more per_t_manage_occupation ///
								per_htenure_owned

global medium_list_adaptive		per_renting per_vehicle_presence ///
								per_t_education_less_secondary per_smother_total ///
								per_bedrooms_less_2 hsize_mean per_amentities_wash ///
								per_amentities_microwave per_t_non_black ///
								t_income_median per_t_prof_techoccupation ///
								per_t_young_age_depend  per_bathroom_0
*-------------------------------------------------------------------------------

*Horn Paralell Analysis
paran $medium_list_cv, graph color iterations(1000)

*-------------------------------------------------------------------------------

*LASSO CROSS-VALIDATION VARIABLE SELECTION MODEL

*Principle Component Analysis Model	(EIGEN VALUE >1)						
pca $medium_list_cv, mineigen(1)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_cv_eigen_var = rowtotal( com*)
tabstat _vsm_medium_cv_eigen_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_eigen_var = rank(-_vsm_medium_cv_eigen_var)
label var rank_vsm_medium_cv_eigen_var "Ranking of PCA Scores using Eigen value >1 and varimax for VSM medium modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_cv_eigen_pro = rowtotal( com*)
tabstat _vsm_medium_cv_eigen_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_eigen_pro = rank(-_vsm_medium_cv_eigen_pro)
label var rank_vsm_medium_cv_eigen_pro "Ranking of PCA Scores using Eigen value >1 and promax for VSM medium modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $medium_list_cv, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_cv_i5per_var = rowtotal( com*)
tabstat _vsm_medium_cv_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_i5per_var = rank(-_vsm_medium_cv_i5per_var)
label var rank_vsm_medium_cv_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM medium modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_cv_i5per_pro = rowtotal( com*)
tabstat _vsm_medium_cv_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_i5per_pro = rank(-_vsm_medium_cv_i5per_pro)
label var rank_vsm_medium_cv_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM medium modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $medium_list_cv, components(9)

*Varimax Rotation
rotate, varimax components(9) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_cv_c80pe_var = rowtotal( com*)
tabstat _vsm_medium_cv_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_c80pe_var = rank(-_vsm_medium_cv_c80pe_var)
label var rank_vsm_medium_cv_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM medium modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(9) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_cv_c80pe_pro = rowtotal( com*)
tabstat _vsm_medium_cv_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_c80pe_pro = rank(-_vsm_medium_cv_c80pe_pro)
label var rank_vsm_medium_cv_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM medium modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $medium_list_cv, components(13)

*Varimax Rotation
rotate, varimax components(13) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_cv_c90pe_var = rowtotal( com*)
tabstat _vsm_medium_cv_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_c90pe_var = rank(-_vsm_medium_cv_c90pe_var)
label var rank_vsm_medium_cv_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM medium modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(13) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_cv_c90pe_pro = rowtotal( com*)
tabstat _vsm_medium_cv_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_c90pe_pro = rank(-_vsm_medium_cv_c90pe_pro)
label var rank_vsm_medium_cv_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM medium modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Principle Component Analysis Model	(Horn Parallel Analysis)						
pca $medium_list_cv, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_cv_horn_var = rowtotal( com*)
tabstat _vsm_medium_cv_horn_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_horn_var = rank(-_vsm_medium_cv_horn_var)
label var rank_vsm_medium_cv_horn_var "Ranking of PCA Scores using Horn parallel analysis and varimax for VSM medium modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_cv_horn_pro = rowtotal( com*)
tabstat _vsm_medium_cv_horn_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_cv_horn_pro = rank(-_vsm_medium_cv_horn_pro)
label var rank_vsm_medium_cv_horn_pro "Ranking of PCA Scores using Horn parallel analysis and promax for VSM medium modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*LASSO MINIMUM BIC VARIABLE MODEL

*Horn Paralell Analysis
paran $medium_list_minBIC, graph color iterations(1000)

*Principle Component Analysis Model							
pca $medium_list_minBIC, mineigen(1)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_minBIC_eigen_var = rowtotal( com*)
tabstat _vsm_medium_minBIC_eigen_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_eigen_var = rank(-_vsm_medium_minBIC_eigen_var)
label var rank_vsm_medium_minBIC_eigen_var "Ranking of PCA Scores using Eigen value >1 and varimax for VSM medium modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_minBIC_eigen_pro = rowtotal( com*)
tabstat _vsm_medium_minBIC_eigen_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_eigen_pro = rank(-_vsm_medium_minBIC_eigen_pro)
label var rank_vsm_medium_minBIC_eigen_pro "Ranking of PCA Scores using Eigen value >1 and promax for VSM medium modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $medium_list_minBIC, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_minBIC_i5per_var = rowtotal( com*)
tabstat _vsm_medium_minBIC_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_i5per_var = rank(-_vsm_medium_minBIC_i5per_var)
label var rank_vsm_medium_minBIC_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM medium modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_minBIC_i5per_pro = rowtotal( com*)
tabstat _vsm_medium_minBIC_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_i5per_pro = rank(-_vsm_medium_minBIC_i5per_pro)
label var rank_vsm_medium_minBIC_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM medium modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $medium_list_minBIC, components(7)

*Varimax Rotation
rotate, varimax components(7) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_minBIC_c80pe_var = rowtotal( com*)
tabstat _vsm_medium_minBIC_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_c80pe_var = rank(-_vsm_medium_minBIC_c80pe_var)
label var rank_vsm_medium_minBIC_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM medium modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(7) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_minBIC_c80pe_pro = rowtotal( com*)
tabstat _vsm_medium_minBIC_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_c80pe_pro = rank(-_vsm_medium_minBIC_c80pe_pro)
label var rank_vsm_medium_minBIC_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM medium modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $medium_list_minBIC, components(11)

*Varimax Rotation
rotate, varimax components(11) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_minBIC_c90pe_var = rowtotal( com*)
tabstat _vsm_medium_minBIC_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_c90pe_var = rank(-_vsm_medium_minBIC_c90pe_var)
label var rank_vsm_medium_minBIC_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM medium modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(11) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_minBIC_c90pe_pro = rowtotal( com*)
tabstat _vsm_medium_minBIC_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_c90pe_pro = rank(-_vsm_medium_minBIC_c90pe_pro)
label var rank_vsm_medium_minBIC_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM medium modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Principle Component Analysis Model	(Horn Parallel Analysis)						
pca $medium_list_minBIC, components(3)

*Varimax Rotation
rotate, varimax components(3) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_minBIC_horn_var = rowtotal( com*)
tabstat _vsm_medium_minBIC_horn_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_horn_var = rank(-_vsm_medium_minBIC_horn_var)
label var rank_vsm_medium_minBIC_horn_var "Ranking of PCA Scores using Horn parallel analysis and varimax for VSM medium modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(3) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_minBIC_horn_pro = rowtotal( com*)
tabstat _vsm_medium_minBIC_horn_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_minBIC_horn_pro = rank(-_vsm_medium_minBIC_horn_pro)
label var rank_vsm_medium_minBIC_horn_pro "Ranking of PCA Scores using Horn parallel analysis and promax for VSM medium modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------

*Horn Paralell Analysis
paran $medium_list_adaptive, graph color iterations(1000)

*Principle Component Analysis Model							
pca $medium_list_adaptive, mineigen(1)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_adapt_eigen_var = rowtotal( com*)
tabstat _vsm_medium_adapt_eigen_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_eigen_var = rank(-_vsm_medium_adapt_eigen_var)
label var rank_vsm_medium_adapt_eigen_var "Ranking of PCA Scores using Eigen value >1 and varimax for VSM medium model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_adapt_eigen_pro = rowtotal( com*)
tabstat _vsm_medium_adapt_eigen_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_eigen_pro = rank(-_vsm_medium_adapt_eigen_pro)
label var rank_vsm_medium_adapt_eigen_pro "Ranking of PCA Scores using Eigen value >1 and promax for VSM medium model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $medium_list_adaptive, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_adapt_i5per_var = rowtotal( com*)
tabstat _vsm_medium_adapt_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_i5per_var = rank(-_vsm_medium_adapt_i5per_var)
label var rank_vsm_medium_adapt_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM medium model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_adapt_i5per_pro = rowtotal( com*)
tabstat _vsm_medium_adapt_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_i5per_pro = rank(-_vsm_medium_adapt_i5per_pro)
label var rank_vsm_medium_adapt_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM medium model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $medium_list_adaptive, components(6)

*Varimax Rotation
rotate, varimax components(6) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_adapt_c80pe_var = rowtotal( com*)
tabstat _vsm_medium_adapt_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_c80pe_var = rank(-_vsm_medium_adapt_c80pe_var)
label var rank_vsm_medium_adapt_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM medium model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(6) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_adapt_c80pe_pro = rowtotal( com*)
tabstat _vsm_medium_adapt_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_c80pe_pro = rank(-_vsm_medium_adapt_c80pe_pro)
label var rank_vsm_medium_adapt_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM medium model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $medium_list_adaptive, components(8)

*Varimax Rotation
rotate, varimax components(8) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_adapt_c90pe_var = rowtotal( com*)
tabstat _vsm_medium_adapt_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_c90pe_var = rank(-_vsm_medium_adapt_c90pe_var)
label var rank_vsm_medium_adapt_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM medium model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(8) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_adapt_c90pe_pro = rowtotal( com*)
tabstat _vsm_medium_adapt_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_c90pe_pro = rank(-_vsm_medium_adapt_c90pe_pro)
label var rank_vsm_medium_adapt_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM medium model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Principle Component Analysis Model	(Horn Parallel Analysis)						
pca $medium_list_adaptive, components(2)

*Varimax Rotation
rotate, varimax components(2) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_medium_adapt_horn_var = rowtotal( com*)
tabstat _vsm_medium_adapt_horn_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_horn_var = rank(-_vsm_medium_adapt_horn_var)
label var rank_vsm_medium_adapt_horn_var "Ranking of PCA Scores using Horn parallel analysis and varimax for VSM medium model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(2) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_medium_adapt_horn_pro = rowtotal( com*)
tabstat _vsm_medium_adapt_horn_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_medium_adapt_horn_pro = rank(-_vsm_medium_adapt_horn_pro)
label var rank_vsm_medium_adapt_horn_pro "Ranking of PCA Scores using Horn parallel analysis and promax for VSM medium model using Selection Adaptive from LASSO Regression"

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Label Data
label data "SES Indicators by Ennumeration Districts - Barbabdos Statistical Service (Medium SES Variable Model)"

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_medium", replace

*Save data in Excel format for GIS import
export excel "`datapath'/version01/2-working/BSS_SES/SES_data_vsm_medium.xlsx", firstrow(variables) replace

log close VSM_medium

*-------------------------End---------------------------------------------------
