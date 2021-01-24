
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_005.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	20/01/2021
**	Date Modified: 	23/01/2021
**  Algorithm Task: Creating Funnel and Forest Plots


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

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
log using "`logpath'/version01/3-output/Scoping Review/SR_PA_005.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

/*
Important to note this analysis is not for the purposes of a meta-analysis of the 
scoping review. 

This analysis seeks to examine the overall association between physical activity and 
built environment attributes. 

Activity outcomes which will be examoined will be:
	1) Active Transport
	2) Leisure-time Physical Activity
	3) Moderate to Vigorous Physical Activity
	
Estimates being used in this analysis are from adjusted multivariable regression models

Initially we will start off with studies reporting odds ratios, then move onto studies 
reporting continous estimates.

*/


*Load in data from encrypted location
import excel "/Users/kernrocke/Downloads/Scoping_Review_Association.xlsx", sheet("Sheet6") firstrow clear

/*Install user-driven commands for forest and funnel plots
ssc install admetan, replace
ssc install metafunnel, replace
ssc install metabias, replace
*/
encode BE, gen(built)
encode Activity_type, gen(activity)
rename Effect_size or
gen lnor = ln(or)
gen lnlci = ln(Lower)
gen lnuci = ln(Upper)
gen or_se = (lnuci - lnlci) / (2*invnormal(0.975))
sort Author_year
gen author = .
order author Author_year
tostring author, replace
replace author = "" if author == "."
replace author = "Andrade 2019" in 1/2
replace author = "Borchardt 2019" in 3/14
replace author = "Christiansen 2016" in 15/22
replace author = "Dias 2019" in 23/30
replace author = "Faerstein 2018" in 31/35
replace author = "Giehl 2016" in 36/42
replace author = "Gomez 2010a" in 43/53
replace author = "Gomez 2010" in 54/57
replace author = "Hino 2011" in 58/60
replace author = "Hino 2013" in 61/70
replace author = "Hino 2019" in 71/74
replace author = "Lee 2016" in 75/76
replace author = "Lim 2017" in 77
replace author = "Parra 2010" in 78/80
replace author = "Schipperijin 2017" in 81/83
replace author = "Siqueiraels 2013" in 84/85

label var BE `"`"{bf:Built Envrionment}"' `"{bf:Attributes}"'"'
label var Author_year `"`"{bf:Studies}"'"'

*Bolding Built Environment Attributes String
replace BE = "{bf:Walkability Index}" if BE == "Walkability Index"	
replace BE = "{bf:Residential Density}" if BE == "Residential Density"
replace BE = "{bf:Land Use}" if BE == "Land Use"
replace BE = "{bf:Greenness}" if BE == "Greenness"
replace BE = "{bf:Connectivity}" if BE == "Connectivity"
replace BE = "{bf:Proximity to Denstinations}" if BE == "Proximity to Denstinations"
*-------------------------------------------------------------------------------		

*Forest Plot
**Active Transport
admetan lnor lnlci lnuci if activity==1 & population == "Adult", eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment" "Adults", ///
		color(black) size(medsmall)) caption("Outcome: walking/cycling for transport >10 minutes/week", span size(vsmall)) ///
		dp(2) name(forest_AT_adult, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author_year) by(BE) nooverall nosubgroup  
		
		
admetan lnor lnlci lnuci if activity==1 & population == "Children" | population == "Both", eform(Studies) effect(OR) ///
		forestplot( title("Active Transport and Built Environment" "Children & Both (Adults & Chilren)", ///
		color(black) size(medsmall)) caption("Outcome: walking/cycling for transport >10 minutes/week", span size(vsmall)) ///
		dp(2) name(forest_AT_child, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author_year) by(BE) nooverall nosubgroup  		
		
*-------------------------------------------------------------------------------		
		
**Leisure-time Physical Activity

admetan lnor lnlci lnuci if activity==2 & population == "Adult", eform(Studies) effect(OR) ///
		forestplot( title("Leisture Time Physical Activity and Built Environment" "Adults", ///
		color(black) size(medsmall)) caption("Outcome: rrecreational activity/walking >10 minutes/week", span size(vsmall)) ///
		dp(2) name(forest_LtPA_adult, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author_year) by(BE) nooverall nosubgroup 
		
admetan lnor lnlci lnuci if activity==2 & population == "Children" | population == "Both", eform(Studies) effect(OR) ///
		forestplot( title("Leisture Time Physical Activity and Built Environment" "Children & Both (Adults & Chilren)", ///
		color(black) size(medsmall)) caption("Outcome: recreational activity/walking >10 minutes/week", span size(vsmall)) ///
		dp(2) name(forest_LtPA_child, replace) xlabel(0.50(1)4 0.4 1)  ///
		aspect(0) plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) ///
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)) ///
		study(Author_year) by(BE) nooverall nosubgroup  
		
*-------------------------------------------------------------------------------		
		
*Contour Funnel Plot
#delimit;
confunnel lnor or_se, contours(0.1 1 5 10) name(funnel, replace) 
			xlab(-1.4(.4)1.4 0) xtitle("Odds Ratio (log scale)") 
			ylab(.5(.1)0) ytitle("Standard Error") 
			
			twowayopts(plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
            graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
            bgcolor(white) )
			by(activity)
			legendopts(row(2))	
			note(" ")

			;
#delimit cr
gr_edit .note.draw_view.setstyle, style(no)
// note edits

gr_edit .legend.plotregion1.label[2].text = {}
gr_edit .legend.plotregion1.label[2].text.Arrpush p < 0.001
// label[2] edits

gr_edit .legend.plotregion1.label[3].text = {}
gr_edit .legend.plotregion1.label[3].text.Arrpush 0.001 < p < 0.01
// label[3] edits

gr_edit .legend.plotregion1.label[4].text = {}
gr_edit .legend.plotregion1.label[4].text.Arrpush 0.01 < p < 0.05
// label[4] edits

gr_edit .legend.plotregion1.label[5].text = {}
gr_edit .legend.plotregion1.label[5].text.Arrpush 0.05 < p < 0.10
// label[5] edits

gr_edit .legend.plotregion1.label[6].text = {}
gr_edit .legend.plotregion1.label[6].text.Arrpush p > 0.10
// label[6] edits

gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy

*Testing for publication bias (Egger Test)
**Active Transport
metabias lnor or_se if activity == 1, egger 
**Leisure-time Physical Activity
metabias lnor or_se if activity == 2, egger 
*confunnel lnor or_se, contours(0.1 1 5 10)  twowayopts(legend (order(0 1 2 3 4 5 ) lab(1 "p<0.001") lab(2 "0.001<p<0.01") lab(3 "0.01<p<0.05") lab(4 "0.05<p<0.1") lab(5 "p>0.1")))

