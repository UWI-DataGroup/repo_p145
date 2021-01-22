


** HEADER -----------------------------------------------------

*Clear screen
cls

*DO FILE META DATA
    //  algorithm name          BE_scoping_review_004
    //  project:                PhD Streetscapes
	//	sub-project:			Built environment scoping review
    //  analysts:               Kern ROCKE
    //  date first created      25-AUG-2020
    // 	date last modified      25-AUG-2020
    //  algorithm task          Creating graphics of basic descriptives of included studies (Counts)
    //  status                  Ongoing

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
log using "`logpath'/version01/3-output/Scoping Review/SR_PA_004.log",  replace

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*Load in data from encrypted location
use "`datapath'/version01/2-working/Scoping Review/Full_text_BE_PA.dta", clear

*Minor Data Cleaning
label var north_central_setting___6 "Mexico"
label var south_america_setting___3  "Brazil"
label var south_america_setting___4  "Chile"
label var south_america_setting___5  "Colombia"
label var aims_countries___9   "Singapore"

label var be_gis___1 "Remote Sensing"
label var be_gis___2 "GPS"
label var be_gis___3 "Desktop Mapping"
label var be_gis___4 "Audit"

label var  be_attributes___1 "Residential/Population Density"
label var  be_attributes___2 "Street Connectivity/Street Intersections"
label var  be_attributes___3 "Mixed Land-Use"
label var  be_attributes___4 "Retail Floor"
label var  be_attributes___5 "Public Space/Parks/Open Space"
label var  be_attributes___6 "Recreation land use proximity"
label var  be_attributes___7 "Non-Recreational land use proximity"
label var  be_attributes___8 "Transit proximity/access"
label var  be_attributes___9 "Trails/sidewalks/pathways/cycle ways"
label var  be_attributes___10 "Pedestrian amenities (street lighting/shade)"
label var  be_attributes___11 "Walkability/Pedestrian index"
label var  be_attributes___12 "Sprawl/Urban sprawl/Urban form"
label var  be_attributes___13 "Other"

label var activity_type___1 "Recreational walking"
label var activity_type___2 "Transportation walking"
label var activity_type___3 "General walking"
label var activity_type___4 "Cycling/biking"
label var activity_type___5 "Walk/Cycle"
label var activity_type___6 "Moderate to vigorous physical activity"
label var activity_type___7 "Other"

*-------------------------------------------------------------------------------

*Data Entry correction
replace be_gis___3 = 0 in 7
replace be_gis___4 = 1 in 7
replace be_gis___3 = 1 in 65

*-------------------------------------------------------------------------------

*Included countries
#delimit ;

mrgraph hbar 
			north_central_setting___6 
			south_america_setting___3 
			south_america_setting___4 
			south_america_setting___5 
			aims_countries___9 
				if data_extractor == 1 & status == 1, 
						stat(freq) ytitle("Count") 
						bar(1, fcolor(green) fintensity(inten60)) 
						blabel(bar, format(%9.0f)) 
						ylabel(0(5)25, nogrid labsize(small))
						title("Countries of Included Studies", size(small) color(black))
						
						plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
						graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
						
						oversubopts(label(labsize(vsmall)))
						
						saving("`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Countries_Included", replace)

		;
#delimit cr

*-------------------------------------------------------------------------------

*Type of Built Environment Objective Measures
#delimit ;

mrgraph hbar
			be_gis___1 be_gis___2 be_gis___3 be_gis___4 
					if data_extractor == 1 & status == 1, 
						stat(freq) ytitle("Count") 
						bar(1, fcolor(red) fintensity(inten60)) 
						blabel(bar, format(%9.0f)) 
						ylabel(0(5)30, nogrid labsize(vsmall))
						title("Type of Objective Built Environment Measure", size(small) color(black))
						
						plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
						graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
						
						oversubopts(label(labsize(vsmall)))
						
						saving("`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Measure_BE", replace)

		;
#delimit cr

*-------------------------------------------------------------------------------

*Type of Built Environment Attributes
#delimit ;

mrgraph hbar
			be_attributes___1 - be_attributes___13
					if data_extractor == 2 & status == 1, 
						stat(freq) ytitle("Count") 
						bar(1, fcolor(purple) fintensity(inten60)) 
						blabel(bar, format(%9.0f)) 
						ylabel(0(5)25, nogrid labsize(vsmall))
						title("Type of Built Environment Attribute", span size(small) color(black))
												
						plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
						graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
						
						oversubopts(label(labsize(vsmall)))
						
						saving("`outputpath'/version01/3-output/Scoping Review/SR_BEPA_BE_Type", replace)


		;
#delimit cr

*-------------------------------------------------------------------------------

*Physical Activity Measure type
#delimit ;

graph hbar (count)
		if data_extractor == 2 & status == 1,
			over(pa_measure_type, lab(labs(2))) 
			bar(1, fcolor(blue) fintensity(inten60)) 
			blabel(bar, format(%9.0f)) 
			ylabel(0(5)25, nogrid labsize(small))
			ytitle("Count") 
			title("Physical Activity Measure type", span size(small) color(black))
			
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			
						
			saving("`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Measure_PA", replace)
			
		;
#delimit cr

*-------------------------------------------------------------------------------

*Type of Physical Activity
#delimit ;

mrgraph hbar
			activity_type___1 - activity_type___7
					if data_extractor == 2 & status == 1, 
						stat(freq) ytitle("Count") 
						bar(1, fcolor(pink) fintensity(inten60)) 
						blabel(bar, format(%9.0f)) 
						ylabel(0(5)15, nogrid labsize(small))
						title("Type of Physical Activity", span size(small) color(black))
						
						plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
						graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
						
						oversubopts(label(labsize(vsmall)))
						
						saving("`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Activity_PA", replace)

		;
#delimit cr

*-------------------------------------------------------------------------------

*Combined Graphs

#delimit ;

graph combine 
				"`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Countries_Included"
				"`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Measure_PA"
				"`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Activity_PA"
				"`outputpath'/version01/3-output/Scoping Review/SR_BEPA_Measure_BE"
				"`outputpath'/version01/3-output/Scoping Review/SR_BEPA_BE_Type"
				
				,
				title("Decriptives for Scoping Review",
				color(black) size(medium))
				
				plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
				graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
				
				iscale(0.6)
				
				col(2)

				
    ;
#delimit cr

graph export "`outputpath'/version01/3-output/Scoping Review/Scoping_Review_Descriptives.png", replace as(png)	

*Close log file
log close

