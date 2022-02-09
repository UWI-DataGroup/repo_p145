
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		BE_scoping_review_006.do
**  Project:      	PhD Streetscapes
**	Sub-Project:	Built Environment Scoping Review
**  Analyst:		Kern Rocke
**	Date Created:	23/01/2021
**	Date Modified: 	08/02/2022
**  Algorithm Task: Creating Line Trend of Published Studies from PubMed


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
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

** Logfiles to unencrypted location

*WINDOWS
*local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

**Aggregated output path

*WINDOWS
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results
*log using "`logpath'/version01/3-output/Scoping Review/SR_PA_006.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*Load in data from encrypted location
import delimited "`datapath'/version01/1-input/Scoping Review/csv-builtenvir-set-3.csv", clear

*Tabulation of number of studies by year
tab publicationyear

*Sort by year
sort publicationyear

*Create counts for studies by year
by publicationyear: gen studies = _N

*Collaspe into a new dataset
collapse (mean) studies, by(publicationyear)

*Smoothing for the development of estimates for graphing if needed
lowess studies publicationyear, gen(study)

*Declare dataset time series
tsset publicationyear, yearly

*Fill in missing year with no published studies
tsfill
replace studies = 0 if studies == .

*Two way line graph showing trend of studies published
#delimit;
twoway connected studies publicationyear 
			if publicationyear!=2021, 
				sort xline(2010) xline(2019) ylab(0(20)200, 
				angle(horizontal) nogrid) xlab(1989(2)2020 2010 2019 2020, labsize(msmall)
				angle(45)) ytitle("Number of studies") mcolor(orange) 
				msize(medium) msymbol(circle) mlabel(studies) mlabsize(small) mlabposition(11) 
				lcolor(blue) lwidth(medthick) connect(direct)
				plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
				graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) bgcolor(white)
				name(PubMed_results, replace)
				
				;
#delimit cr

*Edits to graph

gr_edit .plotregion1.AddLine added_lines editor 2011.033316807968 50.13863592117382 2018.078113063756 50.13863592117382
gr_edit .plotregion1.added_lines_new = 1
gr_edit .plotregion1.added_lines_rec = 1
gr_edit .plotregion1.added_lines[1].style.editstyle  linestyle( width(thick) color(black) pattern(solid)) headstyle( symbol(circle) linestyle( width(thin) color(black) pattern(solid)) fillcolor(black) size(large) angle(stdarrow) backsymbol(none) backline( width(thin) color(black) pattern(solid)) backcolor(black) backsize(zero) backangle(stdarrow)) headpos(head) editcopy
// edits

gr_edit .plotregion1.AddTextBox added_text editor 41.26800400270991 2010.523316807968
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Scoping Review (2010-19)
// editor text[1] edits

gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Scoping Review (2010-19)
// editor text[1] edits

*Export graph to encrypted location
graph export "`datapath'/version01/3-output/Scoping Review/studies_trend_pubmed.png", as(png) replace
