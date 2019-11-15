clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_003

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_004.do
**  Project:      	Macroscale Walkability- PhD
**  Analyst:		Kern Rocke
**	Date Created:	28/10/2019
**	Date Modified: 	11/11/2019
**  Algorithm Task: Correlations and Inital PCA Analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 80

*Setting working directory
** Dataset to encrypted location
/*
WINDOWS OS
local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*/
*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

/*
Note check correlations between variables. Correlations giving r=0.99 should not be 
considered

Check median income values of 999999. This may be indicated as missing values.
Consider using income proportions
*/

** ------------------------------------------
** FILE 1- DATA PREPARATION
** ------------------------------------------

use "`datapath'/version01/2-working/BSS_SES/BSS_SES_002", clear

*List of SES Variables 

*1) Income: per_t_income_0_49 per_high_income
*2) Education: per_education_less_secondary
*3) Age: t_age_median per_age_depend
*4) Home Amentities:  per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_tv per_amentities_radio per_amentities_wash
*5) Occupation: per_prof_occupation per_prof_techoccupation per_prof_n_techoccupation 
*6) House Tenure: per_htenure_owned per_renting
*7) Work Activity: per_t_wactivity_no_work per_t_wactivity_government per_t_wactivity_private_enter per_private_wactivity
*8) Crime: per_crime_victim
*9) Household Size: hsize_mean
*10) Population Density: pop_density
*11) Single Mother: per_smother_total
*12) Marital Status: per_marital_n_married
*13) Household Structure: per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0
*14) Vehicle Ownership: per_vehicle_presence



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


** Describe SES categories
des $xlist
sum $xlist
corr $xlist
tabstat $xlist, by(parish) stat(mean)

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
	gr twoway
		/// Correlation
		(sc CORR ind , msize(3.5) m(o) mlc(gs0) mfc("41 89 255") mlw(0.1))
		,
			graphregion(color(gs16)) 
            ysize(5) xsize(10)

			xlab(0(25)500 , labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill lc(gs0))
			xtitle("Correlations", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(25)500, tlc(gs0))

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
restore

*Inital PCA analysis
paran $xlist, graph color

pca $xlist

*Orthogonal rotation
rotate, varimax blanks(0.3)

*Oblique rotation
rotate, promax blanks(0.3)

**Adding loadings estimates to the existing dataset
estat loadings
predict ses_score

**KMO measure for sampling adequacy
**Note: values 0.70 and higher are desireable 
estat kmo 

**Summary of ses index scores
sum ses_score
tabstat ses_score, by(parish) stat(mean median)

**Categorize SES index scores into deciles
xtile ses_dec = ses, nq(10)

**Categorize deciles into high and low SES
gen ses_cat = ses_dec
recode ses_cat (1/4=3) (5/6=2) (7/10=1)
label var ses_cat "Socioeconomic Index Categories"
label define ses_cat 3"High" 1"Low" 2"Medium"
label value ses_cat ses_cat

**Tabulate SES by ED and parishes
tab ses_cat parish

*Label Data
label data "SES Indicators by Ennumeration Districts - Barbabdos Statistical Service (p3)"

*Save dataset
save "`datapath'/version01/2-working/BSS_SES/BSS_SES_003", replace

*Save data in Excel format for GIS import
export excel "`datapath'/version01/2-working/BSS_SES/SES_data.xlsx", firstrow(variables) replace