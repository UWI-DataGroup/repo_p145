
clear
capture log close
cls

**  DO-FILE META DATA INFORMATION
**  Program:		MAPS_analysis_000.do
**  Project:      	Streetscapres- PhD & Walkability
**	Sub-Project:	Pilot MAPS UNESCO Heritiage Site Barbados
**  Analyst:		Kern Rocke
**	Date Created:	03/08/2019
**	Date Modified: 	12/06/2019
**  Algorithm Task: Overall Audit Descriptives


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
cd "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
*cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145


/*	IMPORTANT: 

	The following STATA do files should be excuted prior the excuting this 
	do files

	1) MAPS_prep_001.do
	2) MAPS_prep_002.do

*/

*Load in dataset from encrypted location
use "`datapath'/version01/2-working/MAPS/MAPS_Recoding_Scoring.dta", clear

*----------------------BEGIN----------------------------------------------------

**Overall Descriptives

*Time taken to conduct audit
mean time_diff, cformat(%tcHH:MM)

*Recoding mixed into commercial
recode type (3=2)
recode type_segment (3=2)

* Frequencies for type of routes, segments and crossings

*Route
tab type

*Segment
tab type_segment

*Crossing
recode type_crossing (1=.) (2=.) if instrument_type==1
recode type_crossing (1=.) (2=.) if instrument_type==2
tab type_crossing

*Number of segments per route
preserve
collapse (count) type_segment, by(record_id)
sum type_segment
restore

*Number of crossings per route
preserve
collapse (count) type_crossing, by(record_id)
sum type_crossing
restore

*Internal Consistency - Cronh Alpha
use "`datapath'/version01/2-working/MAPS/MAPS_Overall", clear
alpha Res_Density_Mix_recode - C1_7c

*---------------------END-------------------------------------------------------
