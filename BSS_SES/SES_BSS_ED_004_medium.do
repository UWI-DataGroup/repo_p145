
clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_005.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	28/10/2019
**	Date Modified: 	18/12/2019
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
*local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

**Aggregated output path
*WINDOWS
local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"
*MAC
*local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"


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

/*
   --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      14.3839      10.8624             0.4231       0.4231
           Comp2 |      3.52151      1.13001             0.1036       0.5266
           Comp3 |       2.3915       .22291             0.0703       0.5970
           Comp4 |      2.16859      .626139             0.0638       0.6607
           Comp5 |      1.54245      .243378             0.0454       0.7061
           Comp6 |      1.29907      .323195             0.0382       0.7443
           Comp7 |      .975874      .173241             0.0287       0.7730
           Comp8 |      .802634     .0789591             0.0236       0.7966
           Comp9 |      .723674     .0441472             0.0213       0.8179
          Comp10 |      .679527     .0568522             0.0200       0.8379
          Comp11 |      .622675     .0394132             0.0183       0.8562
          Comp12 |      .583262     .0723968             0.0172       0.8734
          Comp13 |      .510865     .0417348             0.0150       0.8884
          Comp14 |       .46913     .0563175             0.0138       0.9022
          Comp15 |      .412813      .043207             0.0121       0.9143
          Comp16 |      .369606    .00888058             0.0109       0.9252
          Comp17 |      .360725     .0557177             0.0106       0.9358
          Comp18 |      .305007      .050994             0.0090       0.9448
          Comp19 |      .254013     .0254348             0.0075       0.9523
          Comp20 |      .228579     .0133026             0.0067       0.9590
          Comp21 |      .215276      .038243             0.0063       0.9653
          Comp22 |      .177033     .0104863             0.0052       0.9705
          Comp23 |      .166547     .0217543             0.0049       0.9754
          Comp24 |      .144792     .0190556             0.0043       0.9797
          Comp25 |      .125737     .0101103             0.0037       0.9834
          Comp26 |      .115626       .02378             0.0034       0.9868
          Comp27 |     .0918465    .00708583             0.0027       0.9895
          Comp28 |     .0847607    .00521802             0.0025       0.9920
          Comp29 |     .0795427    .00973258             0.0023       0.9943
          Comp30 |     .0698101     .0255449             0.0021       0.9964
          Comp31 |     .0442652    .00811312             0.0013       0.9977
          Comp32 |     .0361521     .0111493             0.0011       0.9987
          Comp33 |     .0250027    .00676212             0.0007       0.9995
          Comp34 |     .0182406            .             0.0005       1.0000
    --------------------------------------------------------------------------


*/

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

/*

Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          13.943316   14.383874     .44055867
 2          3.0964143   3.5215095     .4250952
 3          2.0074587   2.3914965     .38403773
 4          1.8262894   2.1685866     .3422972
 5          1.2224535   1.5424472     .31999373
 6          1.0159452   1.2990695     .28312433
--------------------------------------------------
Criterion: retain adjusted components > 1


*/

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
*Replace missing code 999999 with .
replace t_income_median = . if t_income_median>559999

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
lassoselect id = 31		// Selecting model 31- Model with the lowest BIC
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
/* LASSO Variable Selection outputpath

----------------------------------------------------------------
                               |    cv       minBIC    adaptive 
-------------------------------+--------------------------------
                   per_renting |     x         x          x     
          per_vehicle_presence |     x         x          x     
per_t_education_less_secondary |     x         x          x     
             per_smother_total |     x         x          x     
           per_bedrooms_less_2 |     x         x          x     
                    hsize_mean |     x                    x     
           per_amentities_wash |     x                    x     
      per_amentities_microwave |     x         x          x     
               per_t_non_black |     x         x          x     
               t_income_median |     x         x          x     
     per_t_prof_techoccupation |     x         x          x     
        per_t_young_age_depend |     x         x          x     
      per_t_education_tertiary |     x         x     
             per_amentities_tv |     x    
                per_bathroom_0 |     x         x          x     
   per_t_prof_n_techoccupation |     x         x     
             per_t_high_income |     x         x     
               per_live_5_more |     x         x     
              per_rooms_less_3 |     x    
              per_crime_victim |     x    
          per_t_old_age_depend |     x    
                per_vehicles_0 |     x    
             per_t_income_0_49 |     x    
       per_t_manage_occupation |     x         x     
            per_t_unemployment |     x    
             per_htenure_owned |               x     
                         _cons |     x         x          x     
----------------------------------------------------------------

NOTE:

Postselection	coefficients
				
Name	data	MSE	R-squared	Obs
				
cv	          
	0	1.58e+07	0.5024	504
	1	1.31e+07	0.3707	1,580
				
minBIC	          
	0	1.62e+07	0.4873	504
	1	1.15e+07	0.4502	1,580
				
adaptive	          
	0	1.62e+07	0.4885	504
	1	1.12e+07	0.4626	1,580
				

After assessing goodness of fit the following models should be considered for final 
selection: CV and minBIC

--------------------------------------------------------------------------------
*/

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

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          9.005173    9.3591393     .35396636
 2          2.3929114   2.7226836     .32977223
 3          1.7158778   2.0023188     .28644097
 4          1.3942023   1.6344442     .24024189
 5          1.1692612   1.3855433     .21628213
 6          .82285574   1.0129953     .19013953
--------------------------------------------------
Criterion: retain adjusted components > 1

RETAIN 5 components

*/

*-------------------------------------------------------------------------------

*LASSO CROSS-VALIDATION VARIABLE SELECTION MODEL

*Principle Component Analysis Model	(EIGEN VALUE >1)						
pca $medium_list_cv, mineigen(1)

/*

 --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      9.35914      6.63646             0.3744       0.3744
           Comp2 |      2.72268      .720365             0.1089       0.4833
           Comp3 |      2.00232      .367875             0.0801       0.5634
           Comp4 |      1.63444      .248901             0.0654       0.6287
           Comp5 |      1.38554      .372548             0.0554       0.6842
           Comp6 |        1.013       .14382             0.0405       0.7247
           Comp7 |      .869175      .138018             0.0348       0.7595
           Comp8 |      .731157     .0545327             0.0292       0.7887
           Comp9 |      .676625     .0331073             0.0271       0.8158
          Comp10 |      .643517     .0835612             0.0257       0.8415
          Comp11 |      .559956     .0548644             0.0224       0.8639
          Comp12 |      .505092     .0586199             0.0202       0.8841
          Comp13 |      .446472     .0645967             0.0179       0.9020
          Comp14 |      .381875     .0205212             0.0153       0.9172
          Comp15 |      .361354     .0706743             0.0145       0.9317
          Comp16 |       .29068     .0128137             0.0116       0.9433
          Comp17 |      .277866      .033918             0.0111       0.9544
          Comp18 |      .243948     .0248268             0.0098       0.9642
          Comp19 |      .219121     .0464291             0.0088       0.9730
          Comp20 |      .172692     .0157341             0.0069       0.9799
          Comp21 |      .156958     .0246387             0.0063       0.9861
          Comp22 |      .132319     .0282258             0.0053       0.9914
          Comp23 |      .104093     .0192728             0.0042       0.9956
          Comp24 |     .0848206     .0596643             0.0034       0.9990
          Comp25 |     .0251562            .             0.0010       1.0000
    --------------------------------------------------------------------------


	*/

*Varimax Rotation
rotate, varimax components(6) blank(.3)

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
rotate, promax components(6) blanks(0.3)

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

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          6.2984365   6.5756779     .27724135
 2          1.7682507   2.0073871     .23913646
 3          1.2693523   1.4926261     .22327375
 4          .95174136   1.1369665     .18522513
 5          .8903262    1.0346004     .14427423
--------------------------------------------------
Criterion: retain adjusted components > 1

RETAIN 3 components for horn's analysis
*/


*Principle Component Analysis Model							
pca $medium_list_minBIC, mineigen(1)

/*

 --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      6.57568      4.56829             0.3868       0.3868
           Comp2 |      2.00739      .514761             0.1181       0.5049
           Comp3 |      1.49263       .35566             0.0878       0.5927
           Comp4 |      1.13697      .102366             0.0669       0.6596
           Comp5 |       1.0346      .340545             0.0609       0.7204
           Comp6 |      .694056     .0322597             0.0408       0.7613
           Comp7 |      .661796     .0451011             0.0389       0.8002
           Comp8 |      .616695      .124306             0.0363       0.8365
           Comp9 |      .492388     .0433656             0.0290       0.8654
          Comp10 |      .449023     .0439731             0.0264       0.8918
          Comp11 |       .40505     .0591154             0.0238       0.9157
          Comp12 |      .345934      .025416             0.0203       0.9360
          Comp13 |      .320518     .0184274             0.0189       0.9549
          Comp14 |      .302091     .0968359             0.0178       0.9726
          Comp15 |      .205255     .0646099             0.0121       0.9847
          Comp16 |      .140645     .0213523             0.0083       0.9930
          Comp17 |      .119293            .             0.0070       1.0000
    --------------------------------------------------------------------------


	*/


*Varimax Rotation
rotate, varimax components(5) blank(.3)

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
rotate, promax components(5) blanks(0.3)

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

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          5.0949893   5.3417539     .24676454
 2          1.6367507   1.8344287     .19767797
 3          .96161849   1.1432195     .18160105
 4          .88589837   1.0051469     .11924851
--------------------------------------------------
Criterion: retain adjusted components > 1

*/


*Principle Component Analysis Model							
pca $medium_list_adaptive, mineigen(1)

/*

 --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      5.34175      3.50733             0.4109       0.4109
           Comp2 |      1.83443      .691209             0.1411       0.5520
           Comp3 |      1.14322      .138073             0.0879       0.6400
           Comp4 |      1.00515      .183071             0.0773       0.7173
           Comp5 |      .822075      .189419             0.0632       0.7805
           Comp6 |      .632656      .133903             0.0487       0.8292
           Comp7 |      .498754     .0310887             0.0384       0.8675
           Comp8 |      .467665     .0299233             0.0360       0.9035
           Comp9 |      .437742      .106978             0.0337       0.9372
          Comp10 |      .330763      .097715             0.0254       0.9626
          Comp11 |      .233048     .0649066             0.0179       0.9806
          Comp12 |      .168142     .0835369             0.0129       0.9935
          Comp13 |     .0846048            .             0.0065       1.0000
    --------------------------------------------------------------------------


	*/


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


*-------------------------End---------------------------------------------------
