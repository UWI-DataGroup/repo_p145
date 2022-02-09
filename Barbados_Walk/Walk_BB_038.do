
clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_038.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index 
**  Analyst:		Kern Rocke
**	Date Created:	09/11/2021
**	Date Modified: 	16/10/2021
**  Algorithm Task: Cluster & Spatial Autoregressive Analysis


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150
 
 set seed 1234

*Setting working directory

*-------------------------------------------------------------------------------
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*WINDOWS OS (Alternative)
*local datapath "X:/The UWI - Cave Hill Campus/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p145"
local echornpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p120"
local hotnpath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - SharePoint - The University of the West Indies/DataGroup - data_p124"
local dopath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The UWI - Cave Hill Campus/Github Repositories"

*_______________________________________________________________________________

*Load in ED level greenness data (import from csv)
import delimited "/Users/kernrocke/Downloads/ED_fix_BB/ED_BB_ndvi.csv"

*Minor cleaning
rename _mean ndvi
label var ndvi "Normalized Difference Vegetative Index"

rename enum_no1 ED
label var ED "Enumeration Districts"

*Merge in Neighbourhood Characteristics
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/neighbourhood_charc_add.dta", nogenerate
merge 1:1 ED using "`datapath'/version01/2-working/Walkability/walkability_SES.dta", nogenerate

*-------------------------------------------------------------------------------

*Creating Cluster Variable representing greeness and walkability

*Cluster Analysis using kmeans method
cluster kmeans walkability ndvi, k(4) measure(L2) start(krandom)

*Create cluster variable
gen cluster = .
replace cluster = 1 if _clus_1 ==3
replace cluster = 4 if _clus_1 ==2
replace cluster = 3 if _clus_1 ==4
replace cluster = 2 if _clus_1 ==1

label var cluster "K-means Cluster (Walkability and Greenness)"
label define cluster 1"Somewhat walkable green (sweet spots)" 2"Car dependent green" 3"Very walkable grey" 4"Somewhat walkable grey (sour spots)", modify
label value cluster cluster

*Basic Summary statistics
tabstat walkability ndvi, by(cluster) statistics( median p25 p75 ) columns(statistics) format(%9.2f) nototal

*-------------------------------------------------------------------------------

*Mapping

*Convert shapefile to be loaded in STATA
spshape2dta /Users/kernrocke/Downloads/ED_fix_BB/ED_analysis.shp, replace
use "/Users/kernrocke/Downloads/ED_analysis.dta", replace
spset

*Minor cleaning
replace PARISHNAM1 = "Christ Church" if PARISHNAM1 == "Christ Churc"

*Rename variables
rename ED_spatial ndvi
label var ndvi "Normalized Difference Vegetative Index"
rename ED_spati_1 Greenspace_Density
label var Greenspace_Density "Green Space Density (Parks and open green spaces)"
rename ED_spati_2 walkability
label var walkability "Walkability Index"
rename ED_spati_3 walkscore
label var walkscore "Walk Score"
rename ED_spati_4 SES
label var SES "Socioeconomic Status"
rename ED_spati_5 crime_density
label var crime_density "Crime Density"
rename ED_spati_6 ERS
label var ERS "Economic Residential Segregation"
rename ED_spati_7 IED
label var IED "Index of Economic Dissimilarity"
rename ED_spati_8 pop_density
label var pop_density "Population Density"
rename ED_spati_9 building_density
label var building_density "Building Density"
rename ED_spati10 crime_pop
label var crime_pop "Crime per 1000"

*Destring variables
destring ndvi, replace
destring Greenspace_Density, replace
destring walkability, replace
destring walkscore, replace
destring SES, replace
destring crime_density, replace
destring ERS, replace
destring IED, replace
destring pop_density, replace
destring building_density, replace
destring crime_pop, replace

rename ENUM_NO1 ED

merge 1:1 ED using "`datapath'/version01/2-working/Walkability/neighbourhood_charc_add.dta", nogenerate

*Create Spatial Matrix
spmatrix create contiguity W, replace
spmatrix create idistance M, replace


*Spatial Autoregressive Models
spregress walkability ndvi SES pop_density, gs2sls dvarlag(W) 
spregress walkability ndvi SES pop_density, gs2sls errorlag(W) 
spregress walkability ndvi SES pop_density, gs2sls dvarlag(W) errorlag(W) 


*----------------------------CREATION OF MAPS-----------------------------------
*Creating Chrolopleth map of walkability
#delimit;
	grmap walkability, 
		title("Spatial Distribution of" "Neighbourhood Walkability Index") 
		legend(on order(2 "Very Low" 3 "Low" 
						4 "Medium" 5 "High" 
						6 "Very High") 
						region(lcolor(black)) title(Key, size(small)) position(2))
		fcolor(RdYlGn) clmethod(quantile) clnumber(5) 
		legenda(on) legtitle(Key) legorder(lohi) legstyle(1)
		name(Walkability_Index, replace)
;
#delimit cr


*Creating Chrolopleth map of walkscore
#delimit;
	grmap walkscore, 
		title("Walkable Ammenitites") 
		legend(on order(2 "Very Low" 3 "Low" 
						4 "Medium" 5 "High" 
						6 "Very High") 
						region(lcolor(black)) title(Key, size(small)) position(2))
		fcolor(RdYlGn) clmethod(quantile) clnumber(5) 
		legenda(on) legtitle(Key) legorder(lohi) legstyle(1)
		name(Walkscore, replace)
;
#delimit cr


*Creating Chrolopleth map of SES
#delimit;
	grmap SES, 
		title("SES") 
		legend(on order(2 "Very Low SES" 3 "Low SES" 
						4 "Medium SES" 5 "High SES" 
						6 "Very High SES") 
						region(lcolor(black)) title(Key, size(small)) position(2))
		fcolor(YlOrBr) clmethod(quantile) clnumber(5) 
		legenda(on) legtitle(Key) legorder(lohi) legstyle(1)
		name(SES, replace)
;
#delimit cr


*Creating Chrolopleth map of ERS
#delimit;
	grmap ERS, 
		title("ERS") 
		legend(on order(2 "Very Low ERS" 3 "Low ERS" 
						4 "Medium ERS" 5 "High ERS" 
						6 "Very High ERS") 
						region(lcolor(black)) title(Key, size(small)) position(2))
		fcolor(Oranges) clmethod(quantile) clnumber(5) 
		legenda(on) legtitle(Key) legorder(lohi) legstyle(1)
		name(ERS, replace)
;
#delimit cr

*Creating Chrolopleth map of IED
#delimit;
	grmap IED, 
		title("IED") 
		legend(on order(2 "Very Low IED" 3 "Low IED" 
						4 "Medium IED" 5 "High IED" 
						6 "Very High IED") 
						region(lcolor(black)) title(Key, size(small)) position(2))
		fcolor(Greens) clmethod(quantile) clnumber(5) 
		legenda(on) legtitle(Key) legorder(lohi) legstyle(1)
		name(IED, replace)
;
#delimit cr


*Combine Graphs Social Structure graphs
#delimit;
graph combine SES ERS IED, 
			row(1) 
			note("Note: SES- Socioeconomic Status; ERS- Economic Residential Segregation; IED- Index Economic Dissimilarity", 
			size(vsmall) color(black)) 
			title("Spatial Distribution of Social Neighbourhood Measures", color(black)) 
			name(social, replace)
;
#delimit cr


*Combine Graphs Walkability graphs
#delimit;
graph combine Walkability_Index Walkscore, 
			row(1) 
			title("Spatial Distribution of Walkability Neighbourhood Measures", 
			color(black)) 
			name(walk, replace)
;
#delimit cr


*-------------------------------------------------------------------------------




#delimit;
	grmap walkability, 
		title("Enumeration District") 
		legend(on order(2 "Very Low" 3 "Low" 
						4 "Medium" 5 "High" 
						6 "Very High") 
						region(lcolor(black)) title(Key, size(small)) position(2))
		fcolor(RdYlGn) clmethod(quantile) clnumber(5) 
		legenda(on) legtitle(Key) legorder(lohi) legstyle(1)
		name(Walkability_Index_ED, replace)
;
#delimit cr

*-------------------------------------------------------------------------------
collapse (mean) walkability, by(PARISHNAM1)
rename PARISHNAM1 parish
encode parish, gen(parish_id)
label var parish "Parish"
label var walkability "Walkability Index"
save "walkability_parish", replace
*-------------------------------------------------------------------------------

use "/Users/kernrocke/Downloads/Barbados_Parish_v2.dta", clear
spset
rename NAME_1 parish
rename ID_1 parish_id
merge 1:1 parish_id using "walkability_parish"

#delimit;
	grmap walkability, 
		title("Parish") 
		legend(on order(2 "Very Low" 3 "Low" 
						4 "Medium" 5 "High" 
						6 "Very High") 
						region(lcolor(black)) title(Key, size(small)) position(2))
		fcolor(RdYlGn) clmethod(quantile) clnumber(5) 
		legenda(on) legtitle(Key) legorder(lohi) legstyle(1)
		name(Walkability_Index_parish, replace)
;
#delimit cr


*Combine Graphs Walkability graphs by administrative boundary
#delimit;
graph combine Walkability_Index_ED Walkability_Index_parish, 
			row(1) 
			title("Spatial Distribution of Walkability Neighbourhood Measures", 
			color(black)) 
			name(walk_ED_parish, replace)
;
#delimit cr





