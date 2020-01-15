
clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_004_large.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	28/10/2019
**	Date Modified: 	15/01/2019
**  Algorithm Task: Correlations, PCA Analysis and LASSO regression (Large Variable Model)


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
log using "`logpath'/version01/3-output/BSS_SES/PCA Results/VSM_large.log", name(VSM_large) replace

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

List of SES Variables (Gender-specific)

Variables - male/female

Ethnicity: Non-black population [Male/Female]
Age: Median age; Young age dependency; Old age dependency [Male/Female]
Household size: Mean household size
Housing Tenure: Housing tenure -  Owner; Housing tenure - Renting
Single Parent: Single Mother
Education: Less than secondary education; Tertiary education [Male/Female]
Income: Median income; Low income ($0-49999); High income (>$150000) [Male/Female]
Unemployment [Male/Female]
Crowding: Liveborn children >5
Crime: Crime victim
Occupation: Management occupations; Professional occupations; Technical occupations; Non-technical occupations [Male/Female]
Household Structure: Household structure: number of rooms; Household structure: number of bedrooms; Household structure: number of bathrooms
Toilet: Toilet presence 
Vehicle Status: Vehicle Ownership; No Vehicle Ownership
Household Amentities: Stove; Refrigerator; Microwave; Computer; Radio; Television; Washing Machine
Household lighting: Electricity 

*/

**Initalize macros
global large_list	per_f_non_black per_m_non_black							///
					f_age_median m_age_median 								///
					per_f_young_age_depend per_m_young_age_depend 			///
					per_f_old_age_depend per_m_old_age_depend 				///
					hsize_mean per_htenure_owned per_renting per_smother_total ///
					per_f_education_less_secondary per_m_education_less_secondary  ///
					per_f_education_tertiary per_m_education_tertiary		///
					per_f_income_0_49 per_m_income_0_49						///
					per_f_high_income per_m_high_income						///
					f_income_median m_income_median 						///
					per_f_unemployment per_m_unemployment					///			
					per_live_5_more per_crime_victim ///
					per_f_manage_occupation per_m_manage_occupation			///
					per_f_prof_occupation per_m_prof_occupation				///
					per_f_prof_techoccupation per_m_prof_techoccupation ///			
					per_f_prof_n_techoccupation per_m_prof_n_techoccupation ///
					per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0		///
					per_toilet_presence										///
					per_vehicle_presence per_vehicles_0 per_amentities_stove	///
					per_amentities_fridge per_amentities_microwave 	///
					per_amentities_tv per_amentities_radio			///
					per_amentities_wash per_amentities_computer	///
					per_electricity			
global ED

** Describe SES categories
des $large_list
sum $large_list
tabstat $large_list, by(parish) stat(mean)
corr $large_list

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

			xlab(0(100)1200 , labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill lc(gs0))
			xtitle("Correlations", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(100)1200, tlc(gs0))

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
graph export "`outputpath'/SES_Index/05_Outputs/scatter_plot_ses_vsm_large.png", replace height(550)
restore

*-------------------------------------------------------------------------------
*PCA Analysis - Unrotated

*Inital PCA analysis
pca $large_list, blanks(0.3)

*Screeplot
screeplot, yline(1)
graph export "`outputpath'/SES_Index/05_Outputs/screeplot_ses_vsm_large.png", replace height(550)

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
egen rank_l_pca = rank(-_pca)
label var rank_l_pca "Ranking of PCA SES scores for VSM large model usnig unrotated PCA"


*-------------------------------------------------------------------------------
*PCA Analysis using eigen values >1 = 6 components using Orthogonal rotation

*Inital PCA analysis
pca $large_list, mineigen(1) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(8) blanks(0.3)

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
egen rank_l_eigen_var = rank(-_eigen_var)
label var rank_l_eigen_var  "Ranking of PCA SES scores for VSM large model usnig Eigen >1 and Varimax Rotated PCA"

*-------------------------------------------------------------------------------
*PCA Analysis using eigen values >1 = 3 components using Oblique rotation

*Inital PCA analysis
pca $large_list, mineigen(1) blanks(0.3)

*Oblique rotation
rotate, promax components(8) blanks(0.3)

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
egen rank_l_eigen_pro = rank(-_eigen_pro)
label var rank_l_eigen_pro  "Ranking of PCA SES scores for VSM large model usnig Eigen >1 and Promax Rotated PCA"


*-------------------------------------------------------------------------------
*PCA Analysis using individual variance (>5%) = 4 components using Varimax rotation

/*
   --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      17.9414      13.8105             0.3738       0.3738
           Comp2 |      4.13087      .562257             0.0861       0.4598
           Comp3 |      3.56861      .822292             0.0743       0.5342
      ^    Comp4 |      2.74632      .562418             0.0572       0.5914
           Comp5 |       2.1839      .435215             0.0455       0.6369
           Comp6 |      1.74869      .354651             0.0364       0.6733
           Comp7 |      1.39404      .373392             0.0290       0.7024
           Comp8 |      1.02065     .0427369             0.0213       0.7236
           Comp9 |      .977908     .0535427             0.0204       0.7440
          Comp10 |      .924366     .0653314             0.0193       0.7633
          Comp11 |      .859034     .0328959             0.0179       0.7812
          Comp12 |      .826138     .0507609             0.0172       0.7984
      *   Comp13 |      .775377     .0569863             0.0162       0.8145
          Comp14 |      .718391     .0119512             0.0150       0.8295
          Comp15 |       .70644     .0181691             0.0147       0.8442
          Comp16 |      .688271     .0616634             0.0143       0.8586
          Comp17 |      .626607     .0733028             0.0131       0.8716
          Comp18 |      .553305     .0644438             0.0115       0.8831
          Comp19 |      .488861     .0268404             0.0102       0.8933
      **  Comp20 |       .46202      .044541             0.0096       0.9029
          Comp21 |      .417479     .0315675             0.0087       0.9116
          Comp22 |      .385912    .00207826             0.0080       0.9197
          Comp23 |      .383834     .0353635             0.0080       0.9277
          Comp24 |       .34847     .0396245             0.0073       0.9349
          Comp25 |      .308846     .0438427             0.0064       0.9414
          Comp26 |      .265003    .00344967             0.0055       0.9469
          Comp27 |      .261553     .0286279             0.0054       0.9523
          Comp28 |      .232925    .00988747             0.0049       0.9572
          Comp29 |      .223038      .021572             0.0046       0.9618
          Comp30 |      .201466    .00602956             0.0042       0.9660
          Comp31 |      .195436      .012144             0.0041       0.9701
          Comp32 |      .183292     .0145111             0.0038       0.9739
          Comp33 |      .168781     .0191579             0.0035       0.9774
          Comp34 |      .149623     .0141531             0.0031       0.9806
          Comp35 |       .13547    .00985761             0.0028       0.9834
          Comp36 |      .125613     .0186473             0.0026       0.9860
          Comp37 |      .106965     .0210417             0.0022       0.9882
          Comp38 |     .0859236    .00333646             0.0018       0.9900
          Comp39 |     .0825872    .00876304             0.0017       0.9917
          Comp40 |     .0738241    .00511894             0.0015       0.9933
          Comp41 |     .0687052    .00604878             0.0014       0.9947
          Comp42 |     .0626564     .0158168             0.0013       0.9960
          Comp43 |     .0468396    .00493652             0.0010       0.9970
          Comp44 |     .0419031     .0060875             0.0009       0.9979
          Comp45 |     .0358156     .0103723             0.0007       0.9986
          Comp46 |     .0254433    .00177277             0.0005       0.9991
          Comp47 |     .0236705    .00594155             0.0005       0.9996
          Comp48 |      .017729            .             0.0004       1.0000
    --------------------------------------------------------------------------



*/

*Inital PCA analysis
pca $large_list, components(4) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(4) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _i5per_var*

egen _i5per_var = rowtotal(_i5per_var*)
label var _i5per_var "SES Score for all components using individual percentage variance explained >5% using varimax rotation"
drop _i5per_var1 - _i5per_var4

*Ranking of SES index score using PCA - individual variance (>5%) and varimax rotation			
egen rank_l_i5per_var = rank(-_i5per_var)
label var rank_l_i5per_var  "Ranking of PCA SES scores for VSM large model usnig Indivdual variance (>5%) and Varimax Rotated PCA"


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
egen rank_l_i5per_pro = rank(-_i5per_pro)
label var rank_l_i5per_pro  "Ranking of PCA SES scores for VSM large model usnig Indivdual variance (>5%) and promax Rotated PCA"


**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (80%) = 9 components

*Inital PCA analysis
pca $large_list, components(13) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(13) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c80pe_var*

egen _c80pe_var = rowtotal(_c80pe_var*)
label var _c80pe_var "SES Score for all components using cummulative percentage variance explained 80% using varimax rotation"
drop _c80pe_var1 - _c80pe_var9

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_l_c80pe_var = rank(-_c80pe_var)
label var rank_l_c80pe_var  "Ranking of PCA SES scores for VSM large model usnig Cummulative variance (>90%) and varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(13) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c80pe_pro*

egen _c80pe_pro = rowtotal(_c80pe_pro*)
label var _c80pe_pro "SES Score for all components using cummulative percentage variance explained 80% using promax Rotated PCA"
drop _c80pe_pro1 - _c80pe_pro9

*Ranking of SES index score using PCA - individual variance (>5%) and promax rotation			
egen rank_l_c80pe_pro = rank(-_c80pe_pro)
label var rank_l_c80pe_pro  "Ranking of PCA SES scores for VSM large model usnig Cummulative variance (>80%) and promax Rotated PCA"

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
*PCA Analysis using cummulative variance (90%) = 20 components

*Inital PCA analysis
pca $large_list, components(20) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(20) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c90pe_var*

egen _c90pe_var = rowtotal(_c90pe_var*)
label var _c90pe_var "SES Score for all components using cummulative percentage variance explained 90% using varimax Rotated PCA"
drop _c90pe_var1 - _c90pe_var14

*Ranking of SES index score using PCA - cummulative variance (>90%) and varimax rotation			
egen rank_l_c90pe_var = rank(-_c90pe_var)
label var rank_l_c90pe_var  "Ranking of PCA SES scores for VSM large model usnig Cummulative variance (>90%) and varimax Rotated PCA"


*****************************

*Oblique rotation
rotate, promax components(20) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _c90pe_pro*

egen _c90pe_pro = rowtotal(_c90pe_pro*)
label var _c90pe_pro "SES Score for all components using cummulative percentage variance explained 90% using promax Rotated PCA"
drop _c90pe_pro1 - _c90pe_pro14

*Ranking of SES index score using PCA - cummulative variance (>90%) and promax rotation			
egen rank_l_c90pe_pro = rank(-_c90pe_pro)
label var rank_l_c90pe_pro  "Ranking of PCA SES scores for VSM large model usnig Cummulative variance (>90%) and promax Rotated PCA"

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

*-------------------------------------------------------------------------------
* Horn Parallel PCA analysis = 7 components

/*

Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          17.342165   17.941394     .59922945
 2          3.6069215   4.1308709     .52394938
 3          3.0820918   3.5686136     .48652172
 4          2.3128149   2.7463219     .43350697
 5          1.7605013   2.1839043     .42340302
 6          1.365646    1.7486889     .38304281
 7          1.0267512   1.3940376     .36728644
 8          .69777956   1.0206452     .32286561
--------------------------------------------------

Criterion: retain adjusted components > 1


*/

*Horn's Parallel Analysis
paran $large_list, graph color iterations(1000)
graph export "`outputpath'/SES_Index/05_Outputs/horn_pca_vsm_large.png", replace

*Inital PCA analysis
pca $large_list, components(7) blanks(0.3)

*Orthogonal rotation
rotate, varimax components(7) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _horn_var*

egen _horn_var = rowtotal(_horn_var*)
label var _horn_var "SES Score for all components using Horn Parallel Analysis"
drop _horn_var1 - _horn_var6

*Ranking of SES index score using PCA - Horn Parallel Analysis and promax rotation			
egen rank_l_horn_var = rank(-_horn_var)
label var rank_l_horn_var  "Ranking of PCA SES scores for VSM large model usnig Horn Paralell Analysis and varimax Rotated PCA"


*************

*Oblique rotation
rotate, promax components(7) blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict _horn_pro*

egen _horn_pro = rowtotal(_horn_pro*)
label var _horn_pro "SES Score for all components using Horn Parallel Analysis"
drop _horn_pro1 - _horn_pro6

*Ranking of SES index score using PCA - Horn Parallel Analysis and promax rotation			
egen rank_l_horn_pro = rank(-_horn_pro)
label var rank_l_horn_pro  "Ranking of PCA SES scores for VSM large model usnig Horn Paralell Analysis and promax Rotated PCA"


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
lasso linear pop_density $large_list if data==0, rseed(1234)
cvplot					// Cross-validation plot
estimates store cv 		// Storing estimates of linear model


*LASSO BIC model
lassoknots, display(nonzero osr2 bic)
lassoselect id = 31		// Selecting model 31- Model with the lowest BIC
cvplot					// Cross-validation plot with bic and linear model
estimates store minBIC	// Storing estimates minimum BIC model


*LASSO Adapative model
lasso linear pop_density $large_list if data==0, selection(adaptive) rseed(1234)
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
per_m_education_less_secondary |     x         x          x     
           per_amentities_wash |     x                    x     
                    hsize_mean |     x                    x     
           per_bedrooms_less_2 |     x         x          x     
         per_f_prof_occupation |     x                    x     
               per_f_non_black |     x         x          x     
             per_smother_total |     x         x          x     
        per_m_young_age_depend |     x         x          x     
             per_m_income_0_49 |     x                    x     
      per_m_education_tertiary |     x         x          x     
          per_f_old_age_depend |     x                    x     
   per_m_prof_n_techoccupation |     x         x          x     
               m_income_median |     x                    x     
             per_amentities_tv |     x                    x     
     per_f_prof_techoccupation |     x         x          x     
       per_amentities_computer |     x                    x     
        per_f_young_age_depend |     x         x          x     
            per_f_unemployment |     x                    x     
      per_amentities_microwave |     x         x          x     
                per_bathroom_0 |     x         x          x     
              per_crime_victim |     x                    x     
               f_income_median |     x    
             per_f_high_income |     x    
              per_rooms_less_3 |     x    
               per_live_5_more |     x    
            per_m_unemployment |     x    
         per_m_prof_occupation |     x    
per_f_education_less_secondary |     x    
             per_htenure_owned |               x     
     per_m_prof_techoccupation |               x     
                  m_age_median |               x     
             per_m_high_income |               x     
                         _cons |     x         x          x     
----------------------------------------------------------------


NOTE:

Postselection	coefficients
				
-------------------------------------------------------------
Name               data |         MSE    R-squared        Obs
------------------------+------------------------------------
cv                      |
                      0 |    1.46e+07       0.5161        583
                      1 |     9359367       0.5514      1,580
------------------------+------------------------------------
minBIC                  |
                      0 |    1.55e+07       0.4885        583
                      1 |     9795306       0.5305      1,580
------------------------+------------------------------------
adaptive                |
                      0 |    1.47e+07       0.5145        583
                      1 |     9129182       0.5625      1,580
-------------------------------------------------------------


				

After assessing goodness of fit the following models should be considered for final 
selection: adaptive

--------------------------------------------------------------------------------
*/

*PCA Model with LASSO variable selection

global large_list_cv			per_renting per_vehicle_presence ///
								per_m_education_less_secondary ////
								per_amentities_wash hsize_mean ///
								per_bedrooms_less_2 per_f_prof_occupation ///
								per_f_non_black per_smother_total ///
								per_m_young_age_depend per_m_income_0_49 ///
								per_m_education_tertiary per_f_old_age_depend ///
								per_m_prof_n_techoccupation m_income_median ///
								per_amentities_tv per_f_prof_techoccupation ///
								per_amentities_computer per_f_young_age_depend ///
								per_f_unemployment per_amentities_microwave ///
								per_bathroom_0 per_crime_victim f_income_median ///
								per_f_high_income per_rooms_less_3 ///
								per_live_5_more per_m_unemployment ///
								per_m_prof_occupation per_f_education_less_secondary 

global large_list_minBIC		per_renting per_vehicle_presence ///
								per_m_education_less_secondary ///
								per_bedrooms_less_2  per_f_prof_occupation ///
								per_f_non_black per_smother_total ///
								per_m_young_age_depend per_m_education_tertiary ///
								per_m_prof_n_techoccupation per_f_prof_techoccupation ///
								per_f_young_age_depend per_f_unemployment ///
								per_amentities_microwave per_bathroom_0 ///
								per_htenure_owned per_m_prof_techoccupation ///
								m_age_median per_m_high_income


global large_list_adaptive		per_renting per_vehicle_presence ///
								per_m_education_less_secondary per_amentities_wash ///
								hsize_mean per_bedrooms_less_2  per_f_prof_occupation ///
								per_f_non_black per_smother_total ///
								per_m_young_age_depend per_m_income_0_49 ///
								per_m_education_tertiary per_f_old_age_depend ///
								per_m_prof_n_techoccupation m_income_median ///
								per_amentities_tv per_f_prof_techoccupation ///
								per_amentities_computer per_f_young_age_depend ///
								per_f_unemployment per_amentities_microwave ///
								per_bathroom_0 per_crime_victim
*-------------------------------------------------------------------------------

*Horn Paralell Analysis
paran $large_list_cv, graph color iterations(1000)

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          9.6784605   10.07974      .40127957
 2          2.1993534   2.5625249     .36317158
 3          2.0954665   2.4510468     .35558033
 4          1.7020365   2.0039799     .30194342
 5          1.2169766   1.454676      .23769939
 6          .97129416   1.1829891     .21169496
 7          .90302518   1.0887749     .18574977
--------------------------------------------------

Criterion: retain adjusted components > 1

RETAIN 5 components

*/

*-------------------------------------------------------------------------------

*LASSO CROSS-VALIDATION VARIABLE SELECTION MODEL

*Principle Component Analysis Model	(EIGEN VALUE >1)						
pca $large_list_cv, mineigen(1)

/*

 --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      10.0797      7.51722             0.3360       0.3360
           Comp2 |      2.56252      .111478             0.0854       0.4214
           Comp3 |      2.45105      .447067             0.0817       0.5031
           Comp4 |      2.00398      .549304             0.0668       0.5699
           Comp5 |      1.45468      .271687             0.0485       0.6184
           Comp6 |      1.18299     .0942142             0.0394       0.6578
           Comp7 |      1.08877      .222769             0.0363       0.6941
           Comp8 |      .866006    .00850611             0.0289       0.7230
           Comp9 |        .8575      .097159             0.0286       0.7516
          Comp10 |      .760341     .0392761             0.0253       0.7769
          Comp11 |      .721065     .0445672             0.0240       0.8010
          Comp12 |      .676498     .0242931             0.0225       0.8235
          Comp13 |      .652205     .0759092             0.0217       0.8452
          Comp14 |      .576296    .00541207             0.0192       0.8645
          Comp15 |      .570884      .069888             0.0190       0.8835
          Comp16 |      .500996     .0578834             0.0167       0.9002
          Comp17 |      .443112     .0998303             0.0148       0.9150
          Comp18 |      .343282     .0163689             0.0114       0.9264
          Comp19 |      .326913     .0329369             0.0109       0.9373
          Comp20 |      .293976     .0242505             0.0098       0.9471
          Comp21 |      .269725      .041814             0.0090       0.9561
          Comp22 |      .227911     .0151972             0.0076       0.9637
          Comp23 |      .212714     .0147942             0.0071       0.9708
          Comp24 |       .19792     .0202456             0.0066       0.9774
          Comp25 |      .177675     .0360686             0.0059       0.9833
          Comp26 |      .141606     .0338348             0.0047       0.9880
          Comp27 |      .107771    .00339702             0.0036       0.9916
          Comp28 |      .104374     .0225287             0.0035       0.9951
          Comp29 |     .0818454      .016193             0.0027       0.9978
          Comp30 |     .0656524            .             0.0022       1.0000
    --------------------------------------------------------------------------



	*/

*Varimax Rotation
rotate, varimax components(7) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_cv_eigen_var = rowtotal( com*)
tabstat _vsm_large_cv_eigen_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_eigen_var = rank(-_vsm_large_cv_eigen_var)
label var rank_vsm_large_cv_eigen_var "Ranking of PCA Scores using Eigen value >1 and varimax for VSM large modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(7) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_cv_eigen_pro = rowtotal( com*)
tabstat _vsm_large_cv_eigen_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_eigen_pro = rank(-_vsm_large_cv_eigen_pro)
label var rank_vsm_large_cv_eigen_pro "Ranking of PCA Scores using Eigen value >1 and promax for VSM large modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $large_list_cv, components(4)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_cv_i5per_var = rowtotal( com*)
tabstat _vsm_large_cv_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_i5per_var = rank(-_vsm_large_cv_i5per_var)
label var rank_vsm_large_cv_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM large modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_cv_i5per_pro = rowtotal( com*)
tabstat _vsm_large_cv_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_i5per_pro = rank(-_vsm_large_cv_i5per_pro)
label var rank_vsm_large_cv_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM large modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $large_list_cv, components(11)

*Varimax Rotation
rotate, varimax components(11) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_cv_c80pe_var = rowtotal( com*)
tabstat _vsm_large_cv_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_c80pe_var = rank(-_vsm_large_cv_c80pe_var)
label var rank_vsm_large_cv_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM large modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(11) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_cv_c80pe_pro = rowtotal( com*)
tabstat _vsm_large_cv_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_c80pe_pro = rank(-_vsm_large_cv_c80pe_pro)
label var rank_vsm_large_cv_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM large modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $large_list_cv, components(16)

*Varimax Rotation
rotate, varimax components(16) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_cv_c90pe_var = rowtotal( com*)
tabstat _vsm_large_cv_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_c90pe_var = rank(-_vsm_large_cv_c90pe_var)
label var rank_vsm_large_cv_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM large modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(16) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_cv_c90pe_pro = rowtotal( com*)
tabstat _vsm_large_cv_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_c90pe_pro = rank(-_vsm_large_cv_c90pe_pro)
label var rank_vsm_large_cv_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM large modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Principle Component Analysis Model	(Horn Parallel Analysis)						
pca $large_list_cv, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_cv_horn_var = rowtotal( com*)
tabstat _vsm_large_cv_horn_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_horn_var = rank(-_vsm_large_cv_horn_var)
label var rank_vsm_large_cv_horn_var "Ranking of PCA Scores using Horn parallel analysis and varimax for VSM large modell using CV from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_cv_horn_pro = rowtotal( com*)
tabstat _vsm_large_cv_horn_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_cv_horn_pro = rank(-_vsm_large_cv_horn_pro)
label var rank_vsm_large_cv_horn_pro "Ranking of PCA Scores using Horn parallel analysis and promax for VSM large modell using CV from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*LASSO MINIMUM BIC VARIABLE MODEL

*Horn Paralell Analysis
paran $large_list_minBIC, graph color iterations(1000)

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          6.2708919   6.5811428     .31025088
 2          1.8005195   2.080676      .28015649
 3          1.5163694   1.7083992     .19202983
 4          1.0651813   1.2293144     .16413307
 5          .92528641   1.0750819     .14979553
--------------------------------------------------
Criterion: retain adjusted components > 1

RETAIN 3 components for horn's analysis
*/


*Principle Component Analysis Model							
pca $large_list_minBIC, mineigen(1)

/*

 --------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      6.58114      4.50047             0.3464       0.3464
           Comp2 |      2.08068      .372277             0.1095       0.4559
           Comp3 |       1.7084      .479085             0.0899       0.5458
           Comp4 |      1.22931      .154232             0.0647       0.6105
           Comp5 |      1.07508       .10566             0.0566       0.6671
           Comp6 |      .969422      .109259             0.0510       0.7181
           Comp7 |      .860163       .13187             0.0453       0.7634
           Comp8 |      .728292      .105884             0.0383       0.8017
           Comp9 |      .622409     .0409818             0.0328       0.8345
          Comp10 |      .581427      .134578             0.0306       0.8651
          Comp11 |      .446849     .0193642             0.0235       0.8886
          Comp12 |      .427485     .0270021             0.0225       0.9111
          Comp13 |      .400482     .0549928             0.0211       0.9322
          Comp14 |       .34549     .0239111             0.0182       0.9503
          Comp15 |      .321579     .0917661             0.0169       0.9673
          Comp16 |      .229813      .068556             0.0121       0.9794
          Comp17 |      .161257      .028922             0.0085       0.9879
          Comp18 |      .132335       .03395             0.0070       0.9948
          Comp19 |     .0983846            .             0.0052       1.0000
    --------------------------------------------------------------------------



	*/


*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_minBIC_eigen_var = rowtotal( com*)
tabstat _vsm_large_minBIC_eigen_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_eigen_var = rank(-_vsm_large_minBIC_eigen_var)
label var rank_vsm_large_minBIC_eigen_var "Ranking of PCA Scores using Eigen value >1 and varimax for VSM large modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_minBIC_eigen_pro = rowtotal( com*)
tabstat _vsm_large_minBIC_eigen_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_eigen_pro = rank(-_vsm_large_minBIC_eigen_pro)
label var rank_vsm_large_minBIC_eigen_pro "Ranking of PCA Scores using Eigen value >1 and promax for VSM large modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $large_list_minBIC, components(6)

*Varimax Rotation
rotate, varimax components(6) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_minBIC_i5per_var = rowtotal( com*)
tabstat _vsm_large_minBIC_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_i5per_var = rank(-_vsm_large_minBIC_i5per_var)
label var rank_vsm_large_minBIC_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM large modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(6) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_minBIC_i5per_pro = rowtotal( com*)
tabstat _vsm_large_minBIC_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_i5per_pro = rank(-_vsm_large_minBIC_i5per_pro)
label var rank_vsm_large_minBIC_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM large modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $large_list_minBIC, components(8)

*Varimax Rotation
rotate, varimax components(8) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_minBIC_c80pe_var = rowtotal( com*)
tabstat _vsm_large_minBIC_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_c80pe_var = rank(-_vsm_large_minBIC_c80pe_var)
label var rank_vsm_large_minBIC_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM large modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(8) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_minBIC_c80pe_pro = rowtotal( com*)
tabstat _vsm_large_minBIC_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_c80pe_pro = rank(-_vsm_large_minBIC_c80pe_pro)
label var rank_vsm_large_minBIC_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM large modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $large_list_minBIC, components(12)

*Varimax Rotation
rotate, varimax components(12) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_minBIC_c90pe_var = rowtotal( com*)
tabstat _vsm_large_minBIC_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_c90pe_var = rank(-_vsm_large_minBIC_c90pe_var)
label var rank_vsm_large_minBIC_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM large modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(12) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_minBIC_c90pe_pro = rowtotal( com*)
tabstat _vsm_large_minBIC_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_c90pe_pro = rank(-_vsm_large_minBIC_c90pe_pro)
label var rank_vsm_large_minBIC_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM large modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Principle Component Analysis Model	(Horn Parallel Analysis)						
pca $large_list_minBIC, components(4)

*Varimax Rotation
rotate, varimax components(4) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_minBIC_horn_var = rowtotal( com*)
tabstat _vsm_large_minBIC_horn_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_horn_var = rank(-_vsm_large_minBIC_horn_var)
label var rank_vsm_large_minBIC_horn_var "Ranking of PCA Scores using Horn parallel analysis and varimax for VSM large modell using MINBIC from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(4) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_minBIC_horn_pro = rowtotal( com*)
tabstat _vsm_large_minBIC_horn_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_minBIC_horn_pro = rank(-_vsm_large_minBIC_horn_pro)
label var rank_vsm_large_minBIC_horn_pro "Ranking of PCA Scores using Horn parallel analysis and promax for VSM large modell using MINBIC from LASSO Regression"


*-------------------------------------------------------------------------------

*Horn Paralell Analysis
paran $large_list_adaptive, graph color iterations(1000)

/*
Results of Horn's Parallel Analysis for principal components
1000 iterations, using the mean estimate

--------------------------------------------------
Component   Adjusted    Unadjusted    Estimated
or Factor   Eigenvalue  Eigenvalue    Bias
--------------------------------------------------
 1          8.2057865   8.5706247     .36483824
 2          1.8025529   2.1325432     .32999027
 3          1.5429649   1.8219733     .27900839
 4          1.2223388   1.471297      .24895823
 5          1.0814076   1.2799271     .19851959
 6          .85962505   1.0365682     .17694318
--------------------------------------------------

Criterion: retain adjusted components > 1

*/


*Principle Component Analysis Model							
pca $large_list_adaptive, mineigen(1)

/*

--------------------------------------------------------------------------
       Component |   Eigenvalue   Difference         Proportion   Cumulative
    -------------+------------------------------------------------------------
           Comp1 |      8.57062      6.43808             0.3726       0.3726
           Comp2 |      2.13254       .31057             0.0927       0.4654
           Comp3 |      1.82197      .350676             0.0792       0.5446
           Comp4 |       1.4713       .19137             0.0640       0.6085
           Comp5 |      1.27993      .243359             0.0556       0.6642
           Comp6 |      1.03657     .0468545             0.0451       0.7093
           Comp7 |      .989714      .142476             0.0430       0.7523
           Comp8 |      .847238       .13074             0.0368       0.7891
           Comp9 |      .716498     .0562335             0.0312       0.8203
          Comp10 |      .660265     .0935384             0.0287       0.8490
          Comp11 |      .566726     .0620921             0.0246       0.8736
          Comp12 |      .504634     .0770044             0.0219       0.8956
          Comp13 |       .42763     .0519332             0.0186       0.9142
          Comp14 |      .375696     .0706072             0.0163       0.9305
          Comp15 |      .305089     .0280496             0.0133       0.9438
          Comp16 |       .27704     .0377238             0.0120       0.9558
          Comp17 |      .239316     .0159361             0.0104       0.9662
          Comp18 |       .22338     .0414258             0.0097       0.9759
          Comp19 |      .181954     .0692408             0.0079       0.9838
          Comp20 |      .112713    .00542349             0.0049       0.9887
          Comp21 |       .10729     .0238265             0.0047       0.9934
          Comp22 |     .0834631     .0150414             0.0036       0.9970
          Comp23 |     .0684217            .             0.0030       1.0000
    --------------------------------------------------------------------------



	*/


*Varimax Rotation
rotate, varimax components(6) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_adapt_eigen_var = rowtotal( com*)
tabstat _vsm_large_adapt_eigen_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_eigen_var = rank(-_vsm_large_adapt_eigen_var)
label var rank_vsm_large_adapt_eigen_var "Ranking of PCA Scores using Eigen value >1 and varimax for VSM large model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(6) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_adapt_eigen_pro = rowtotal( com*)
tabstat _vsm_large_adapt_eigen_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_eigen_pro = rank(-_vsm_large_adapt_eigen_pro)
label var rank_vsm_large_adapt_eigen_pro "Ranking of PCA Scores using Eigen value >1 and promax for VSM large model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Indivdual Variance Explained >5%)						
pca $large_list_adaptive, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_adapt_i5per_var = rowtotal( com*)
tabstat _vsm_large_adapt_i5per_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_i5per_var = rank(-_vsm_large_adapt_i5per_var)
label var rank_vsm_large_adapt_i5per_var "Ranking of PCA Scores using Individual variance explained >5% and varimax for VSM large model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_adapt_i5per_pro = rowtotal( com*)
tabstat _vsm_large_adapt_i5per_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_i5per_pro = rank(-_vsm_large_adapt_i5per_pro)
label var rank_vsm_large_adapt_i5per_pro "Ranking of PCA Scores using Individual variance explained >5% and promax for VSM large model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >80%)						
pca $large_list_adaptive, components(9)

*Varimax Rotation
rotate, varimax components(9) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_adapt_c80pe_var = rowtotal( com*)
tabstat _vsm_large_adapt_c80pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_c80pe_var = rank(-_vsm_large_adapt_c80pe_var)
label var rank_vsm_large_adapt_c80pe_var "Ranking of PCA Scores using Cummulative variance explained >80% and varimax for VSM large model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(9) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_adapt_c80pe_pro = rowtotal( com*)
tabstat _vsm_large_adapt_c80pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_c80pe_pro = rank(-_vsm_large_adapt_c80pe_pro)
label var rank_vsm_large_adapt_c80pe_pro "Ranking of PCA Scores using Cummulative variance explained >80% and promax for VSM large model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Principle Component Analysis Model	(Cummulative Variance Explained >90%)						
pca $large_list_adaptive, components(13)

*Varimax Rotation
rotate, varimax components(13) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_adapt_c90pe_var = rowtotal( com*)
tabstat _vsm_large_adapt_c90pe_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_c90pe_var = rank(-_vsm_large_adapt_c90pe_var)
label var rank_vsm_large_adapt_c90pe_var "Ranking of PCA Scores using Cummulative variance explained >90% and varimax for VSM large model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(13) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_adapt_c90pe_pro = rowtotal( com*)
tabstat _vsm_large_adapt_c90pe_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_c90pe_pro = rank(-_vsm_large_adapt_c90pe_pro)
label var rank_vsm_large_adapt_c90pe_pro "Ranking of PCA Scores using Cummulative variance explained >90% and promax for VSM large model using Selection Adaptive from LASSO Regression"


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Principle Component Analysis Model	(Horn Parallel Analysis)						
pca $large_list_adaptive, components(5)

*Varimax Rotation
rotate, varimax components(5) blank(.3)

*Predicting component scores
predict com*

*Generation of SES score varimax rotation
egen _vsm_large_adapt_horn_var = rowtotal( com*)
tabstat _vsm_large_adapt_horn_var, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_horn_var = rank(-_vsm_large_adapt_horn_var)
label var rank_vsm_large_adapt_horn_var "Ranking of PCA Scores using Horn parallel analysis and varimax for VSM large model using Selection Adaptive from LASSO Regression"

**********************

*Oblique rotation
rotate, promax components(5) blanks(0.3)

*Predicting component scores
predict com*

*Generation of SES score promax rotation
egen _vsm_large_adapt_horn_pro = rowtotal( com*)
tabstat _vsm_large_adapt_horn_pro, by(parish) stat(mean)

drop com*

*Ranking of ses score from lasso variable selection method
egen rank_vsm_large_adapt_horn_pro = rank(-_vsm_large_adapt_horn_pro)
label var rank_vsm_large_adapt_horn_pro "Ranking of PCA Scores using Horn parallel analysis and promax for VSM large model using Selection Adaptive from LASSO Regression"

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Label Data
label data "SES Indicators by Ennumeration Districts - Barbabdos Statistical Service (Large SES Variable Model)"

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_large", replace

*Save data in Excel format for GIS import
export excel "`datapath'/version01/2-working/BSS_SES/SES_data_vsm_large.xlsx", firstrow(variables) replace

log close VSM_large

*-------------------------End---------------------------------------------------
