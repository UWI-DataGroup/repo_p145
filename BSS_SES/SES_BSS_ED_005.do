clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_004

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_005.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	14/11/2019
**	Date Modified: 	21/11/2019
**  Algorithm Task: Multiple Imputation and Lasso Prediction


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Setting working directory
** Dataset to encrypted location
/*
WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*/
*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
cd "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

*Load in dataset
use "`datapath'/version01/2-working/BSS_SES/BSS_SES_003", clear

*MULTIPLE IMPUTATION

/*
Note: Median income within some of the EDs are missing, therefore imputation 
will be used to replace these estimates. 

Values of 999999 were used to idenitfy as missing

Imputation method: Predictive mean matching or multivariate chained equations 
will be used.

*/

**Initalize macros
global xlist per_t_income_0_49 t_age_median per_education_less_secondary ///
				per_crime_victim hsize_mean per_htenure_owned ///
				pop_density per_renting per_high_income per_electricity ///
				per_vehicle_presence per_smother_total per_marital_n_married ///
				per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0 ///
				per_prof_occupation per_amentities_stove per_amentities_fridge ///
				per_amentities_microwave per_amentities_tv per_amentities_radio ///
				per_amentities_wash per_t_wactivity_no_work per_age_depend ///
				per_t_wactivity_government per_t_wactivity_private_enter ///
				per_private_wactivity per_live_5_more per_prof_n_techoccupation ///
				per_prof_techoccupation per_unemployment
global ED

*Descriptives of t_income_median
sum t_income_median
tabstat t_income_median, by(parish)
tabstat t_income_median, by(ED)

*Replace missing code 999999 with .
replace t_income_median = . if t_income_median>559999

gen t_cat = .
replace t_cat = 0 if t_income_median==.
recode t_cat (.=1)

*Imputation Model
preserve
mi set mlong
misstable sum t_income_median
mi register imputed t_income_median 
set seed 29390
*Predictive Mean Matching
mi impute chained (regress) t_income_median = t_age_median hsize_mean , add(20)	
*Listing mean total median income for missing median income EDs											
mi estimate: mean t_income_median if t_cat==0, over(ED)
*Principle Component Analysis Model				
pca $xlist, mineigen(1)
pca $xlist, mineigen(1) components(5)
rotate, varimax components(5) blank(0.3)
predict com*
egen ses = rowtotal(com1 com2 com3 com4 com5)

*Creating Training and Testing data for lasso mode
*Note testing sample obtained from imputed datasets
gen sample = _mi_m
recode sample (1/max=1)

* Group 1 - Training dataset; Group 2 - Testing dataset

egen ses = rowtotal(com1 com2 com3 com4 com5)
lasso linear com1 $test1 if sample ==0, rseed(1234)
cvplot
estimate store cv
lassoknots, display(nonzero osr2 bic)
*Select model with lowest BIC
lassoselect id = 10
cvplot
estimates store minBIC
lasso linear com1 $test1 if sample ==0, selection(adaptive) rseed(1234)
*Selecting an adaptive model
estimates store adaptive
lassocoef cv minBIC adaptive, sort(coef, standardized) nofvlabel
lassogof cv minBIC adaptive, over(sample) postselection

restore


/*
Lasso - Least Absolute Shrinkage and Selection

Installing lassopack package

ssc install lassopack


preserve
*Replace missing code 999999 with .
replace t_income_median = . if t_income_median>559999

*Imputation Model

mi set mlong
misstable sum t_income_median
mi register imputed t_income_median
set seed 29390
*Predictive Mean Matching
mi impute pmm t_income_median $xlist, add(20) knn(5)

*PCA analysis and SES score creation
pca $xlist, mineigen(1)
predict com1 com2 com3 com4
egen ses = rowtotal(com1 com2 com3 com4)

*Run Lasso Model on training data (Orginal EDs 1-583)
lasso2 ses $xlist if _mi_m==0 , adaptive long ols postres lambda()
cvlasso $xlist
lasso2, lic(bic) 

*Use lambda=.650616022965666 (selected by EBIC)
lasso2 ses $xlist if _mi_m==0, adaptive long ols postres ///
								lambda(.650616022965666)
predict ses_lasso

restore

**************************************************************

NOTE:

lasso2 ses $test1 if _mi_m==0 , adaptive long ols postres lambda()
cvlasso $xlist
lasso2, lic(bic) 


*Income
per_t_income_0_49  per_high_income 

*Age
t_age_median per_age_depend per_old_age_depend

*Education
per_education_less_secondary per_t_education_tertiary

*House Tenure
per_htenure_owned per_renting

*House Ammentities 
per_amentities_stove per_amentities_fridge per_amentities_microwave ///
per_amentities_tv  per_amentities_radio per_amentities_wash  ///
per_amentities_computer

*Work Activity 
per_t_wactivity_government per_private_wactivity 

*Occupation
per_prof_occupation per_prof_techoccupation per_prof_n_techoccupation

*Unemployment
per_unemployment per_t_wactivity_no_work 

*Crime 
per_crime_victim 

*Single Mother
per_smother_total 

*Martial Status
per_marital_n_married

*Vehicle Ownership
per_vehicle_presence 

*Household Structure
hsize_mean per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0

*Liveborn Children
per_live_5_more 

*Population Density 
 


egen home = rowmean(per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_tv  per_amentities_radio per_amentities_wash per_amentities_computer)

global test per_t_income_0_49  per_high_income t_age_median per_age_depend ///
			per_old_age_depend per_education_less_secondary ///
			per_t_education_tertiary per_htenure_owned per_renting ///
			per_amentities_stove per_amentities_fridge per_amentities_microwave ///
			per_amentities_tv  per_amentities_radio per_amentities_wash /// 
			per_amentities_computer per_t_wactivity_government ///
			per_private_wactivity per_prof_occupation per_prof_techoccupation ///
			per_prof_n_techoccupation per_unemployment per_t_wactivity_no_work ///
			per_crime_victim per_smother_total per_marital_n_married ///
			per_vehicle_presence hsize_mean per_rooms_less_3 ///
			per_bedrooms_less_2 per_bathroom_0 per_live_5_more 
global ED
			
			
global test1 per_t_income_0_49  per_high_income t_age_median per_age_depend ///
			per_old_age_depend per_education_less_secondary ///
			per_t_education_tertiary per_htenure_owned per_renting ///
			home per_t_wactivity_government ///
			per_private_wactivity per_prof_occupation per_prof_techoccupation ///
			per_prof_n_techoccupation per_unemployment per_t_wactivity_no_work ///
			per_crime_victim per_smother_total per_marital_n_married ///
			per_vehicle_presence hsize_mean per_rooms_less_3 ///
			per_bedrooms_less_2 per_bathroom_0 per_live_5_more 
global ED

*/




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

/////	 LASSO MODEL	/////

**Initalize macros
global xlist	per_t_income_0_49  per_high_income 	///
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


* Lasso Model
lasso2 pop_density $xlist , adaptive long ols postres lambda()
lasso2, lic(bic)
cvlasso $xlist

*Lasso Model with Lambda = 592439480.9524772
lasso2 pop_density $xlist , adaptive long ols postres lambda(592439480.9524772)
lasso2, lic(bic)
cvlasso $xlist

preserve
cls
*LASSO (STATA 16)
vl set, categorical(4) uncertain(0)

*Creating training and testing datasets
splitsample, generate(sample) nsplit(2) rseed(1234)

*Lasso linear model
lasso linear pop_density $xlist if sample ==1, rseed(1234)
cvplot					// Cross-validation plot
estimates store cv 		// Storing estimates of linear model


*LASSO BIC model
lassoknots, display(nonzero osr2 bic)
lassoselect id = 25		// Selecting model 25- Model with the lowest BIC
cvplot					// Cross-validation plot with bic and linear model
estimates store minBIC	// Storing estimates minimum BIC model


*LASSO Adapative model
lasso linear pop_density $xlist if sample ==1, selection(adaptive) rseed(1234)
estimates store adaptive	// Storing estimates of adaptive model


* Table of standardized coeficients used for each model
lassocoef cv minBIC adaptive, sort(coef, standardized) nofvlabel

/*
--------------------------------------------------------------
                             |    cv       minBIC    adaptive 
-----------------------------+--------------------------------
        per_vehicle_presence |     x         x          x     
                 per_renting |     x         x          x     
per_education_less_secondary |     x         x          x     
           per_smother_total |     x         x          x     
        per_young_age_depend |     x         x          x     
    per_amentities_microwave |     x                    x     
         per_bedrooms_less_2 |     x         x          x     
     per_prof_techoccupation |     x         x          x     
       per_marital_n_married |     x         x     
    per_t_education_tertiary |     x         x          x     
              per_bathroom_0 |     x         x          x     
       per_private_wactivity |     x    
           per_t_income_0_49 |     x    
            per_crime_victim |     x    
   per_prof_n_techoccupation |     x         x     
                       _cons |     x         x          x     
--------------------------------------------------------------
*/


*Assess goodness of fit for each of the models used on training datasets
lassogof cv minBIC adaptive, over(sample) postselection

*-------------------------------------------------------------------------------

global minBIClist	per_vehicle_presence  per_renting per_education_less_secondary ///
					per_smother_total per_young_age_depend  ///
					per_bedrooms_less_2 per_prof_techoccupation per_marital_n_married ///
					per_t_education_tertiary per_bathroom_0 
global ED


*PCA Analysis using variables from minBIC model
pca $minBIClist, mineigen(1) blank(0.3)
rotate, varimax blank(0.3)
estat loadings
estat kmo 

*Paran Horn Analysis
paran $minBIClist, graph color
pca $minBIClist, components(2) blank(0.3)
rotate, varimax blank(0.3) components(2)
estat loadings
estat kmo


*-------------------------------END---------------------------------------------







