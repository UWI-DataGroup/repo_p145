
clear
capture log close
cls

**  DO-FILE META DATA INFORMATION
**  Program:		MAPS_prep_002.do
**  Project:      	Streetscapres- PhD & Walkability
**	Sub-Project:	Pilot MAPS UNESCO Heritiage Site Barbados
**  Analyst:		Kern Rocke
**	Date Created:	25/07/2019
**	Date Modified: 	12/06/2019
**  Algorithm Task: MAPS Repeat Segments & Crossings Wide Format Data Management, Scoring and Sub-scale creation


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
use "`datapath'/version01/2-working/MAPS/MAPS_Recoding_Scoring", clear

********************************************************************************

//SEGMENTS

********************************************************************************


preserve

drop if redcap_repeat_instrument=="maps_route"
keep if maps_segment==2
drop routeid-maps_route_complete time_start-Route_Overall 
keep type_segment redcap_repeat_instance record_id Sidewalk_S1 PosBldgHtSetbks_S1 Buffers_Pos_S1 Trees_S1 S1_17 BldgHt_RdWdthSetbk_Ratio_S1 Segments_Pos_S1 Segment_Neg_S1 Overall_Segment

*Reshape to wide format to calculate mean subscale scores for each route
reshape wide type_segment - Overall_Segment, i(record_id) j(redcap_repeat_instance)

//Positive Setback and Building Height Subscale Score - Mean
egen PosBldgHtSetbks_S1 = rowmean(PosBldgHtSetbks_S11 PosBldgHtSetbks_S12 ///
									PosBldgHtSetbks_S13 PosBldgHtSetbks_S14 /// 
									PosBldgHtSetbks_S15 PosBldgHtSetbks_S16)
label var PosBldgHtSetbks_S1 "Positive Setbacks/Bldg. Height: Positive subscale"

//Sidewalk Subscale Score - Mean
egen Sidewalk_S1 = rowmean(Sidewalk_S11 Sidewalk_S12 ///
							Sidewalk_S13 Sidewalk_S14 /// 
							Sidewalk_S15 Sidewalk_S16)
label var Sidewalk_S1 "Sidewalk: Positive subscale"

//Buffer Positive Subscale Score - Mean
egen Buffers_Pos_S1 = rowmean(Buffers_Pos_S11 Buffers_Pos_S12 ///
							Buffers_Pos_S13 Buffers_Pos_S14 /// 
							Buffers_Pos_S15 Buffers_Pos_S16)
label var Buffers_Pos_S1 "Buffers: Positive Subscale"

//Trees Positive Subscale Score - Mean
egen Trees_S1 = rowmean(Trees_S11 Trees_S12 ///
							Trees_S13 Trees_S14 /// 
							Trees_S15 Trees_S16)
label var Trees_S1 "Trees: Positive subscale"

//Building Height: Road Width+Setback Avgs. Ratio Positive Subscale Score - Mean
egen BldgHt_RdWdthSetbk_Ratio_S1 = rowmean(BldgHt_RdWdthSetbk_Ratio_S11 BldgHt_RdWdthSetbk_Ratio_S12 ///
											BldgHt_RdWdthSetbk_Ratio_S13 BldgHt_RdWdthSetbk_Ratio_S14 /// 
											BldgHt_RdWdthSetbk_Ratio_S15 BldgHt_RdWdthSetbk_Ratio_S16)
label var BldgHt_RdWdthSetbk_Ratio_S1 "Building Height: Road Width+Setback Avgs. Ratio"

gen BldgHt_RdWdthSetbk_Ratio_Scores = BldgHt_RdWdthSetbk_Ratio_S1
recode BldgHt_RdWdthSetbk_Ratio_Scores (min/0.49999=0) (0.50/0.99999=1) (1.0/1.99999=3) (2.0/2.99999=2) (3.0/max=1)
label define BldgHt_RdWdthSetbk_Ratio_Scores 0"Lowest - 0.499" 1"0.50 - 0.999; 3.0 - Highest" 2"2.0 - 2.999" 3"1.0 - 1.999"
label value BldgHt_RdWdthSetbk_Ratio_Scores BldgHt_RdWdthSetbk_Ratio_Scores
label var BldgHt_RdWdthSetbk_Ratio_Scores "Scores for the ratio"

//Positive Segements Subscale - Mean
egen Segments_Pos_S1 = rowmean(Segments_Pos_S11 Segments_Pos_S12 ///
								Segments_Pos_S13 Segments_Pos_S14 /// 
								Segments_Pos_S15 Segments_Pos_S16)
label var Segments_Pos_S1 "Sum of positive segments subscales"

//Negative Segements Subscale - Mean
egen Segment_Neg_S1 = rowmean(Segment_Neg_S11 Segment_Neg_S12 ///
								Segment_Neg_S13 Segment_Neg_S14 /// 
								Segment_Neg_S15 Segment_Neg_S16)
label var Segment_Neg_S1 "Sum of negative segments subscales"

//Overall Segments Subscale - Mean
egen Overall_Segment = rowmean(Overall_Segment1 Overall_Segment2 ///
								Overall_Segment3 Overall_Segment4 /// 
								Overall_Segment5 Overall_Segment6)
label var Overall_Segment "Overall segment score"

*Remove repeat variables
drop type_segment1 - Overall_Segment6

sort record_id

** Save the file reading for further data management
save "`datapath'/version01/1-input/MAPS/Segment Subscale Scores", replace

restore


////////////////////////////////////////////////////////////////////////////////


********************************************************************************

//CROSSINGS

********************************************************************************

preserve

drop if redcap_repeat_instrument=="maps_route"
keep if mapscrossings_complete==2
drop routeid-maps_route_complete time_start-Route_Overall 
keep CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1 PosCrossChars_C1 OverallCrossScore_C1 record_id redcap_repeat_instance

*Reshape to wide format to calculate mean subscale scores for each route
reshape wide CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1 PosCrossChars_C1 OverallCrossScore_C1, i(record_id) j(redcap_repeat_instance)

//Cross Walk Street Amenities Subscale Score - Mean
egen CrosswalkAmenities_C1 = rowmean(CrosswalkAmenities_C11 CrosswalkAmenities_C12 ///
										CrosswalkAmenities_C13 CrosswalkAmenities_C14 /// 
										CrosswalkAmenities_C15 CrosswalkAmenities_C16 ///
										CrosswalkAmenities_C17)
label var CrosswalkAmenities_C1 "Crosswalk amenities: Positive scale"

//Curb Quality Subscale Score - Mean
egen Curb_Qual_C1 = rowmean(Curb_Qual_C11 Curb_Qual_C12 ///
							Curb_Qual_C13 Curb_Qual_C14 /// 
							Curb_Qual_C15 Curb_Qual_C16 ///
							Curb_Qual_C17)
label var Curb_Qual_C1 "Curb Quality and Presence Subscale"

//Intersection Control/Signage Positive Subscale Score - Mean
egen IntsectCtrlSign_C1 = rowmean(IntsectCtrlSign_C11 IntsectCtrlSign_C12 ///
									IntsectCtrlSign_C13 IntsectCtrlSign_C14 /// 
									IntsectCtrlSign_C15 IntsectCtrlSign_C16 ///
									IntsectCtrlSign_C17)
label var IntsectCtrlSign_C1 "Intersection Control/Signage: Positive subscale"

// Positive Crossing Subscale Score - Mean
egen PosCrossChars_C1 = rowmean(PosCrossChars_C11 PosCrossChars_C12 ///
								PosCrossChars_C13 PosCrossChars_C14 /// 
								PosCrossChars_C15 PosCrossChars_C16 ///
								PosCrossChars_C17)
label var PosCrossChars_C1 "Positive Crossing Subscale"

// Overall Crossing Score - Mean
egen OverallCrossScore_C1 = rowmean(OverallCrossScore_C11 OverallCrossScore_C12 ///
									OverallCrossScore_C13 OverallCrossScore_C14 /// 
									OverallCrossScore_C15 OverallCrossScore_C16 ///
									OverallCrossScore_C17)
label var OverallCrossScore_C1 "Overall Crossing Score"


*Remove repeat variables
drop CrosswalkAmenities_C11 - OverallCrossScore_C17

sort record_id

** Save the file reading for further data management
save "`datapath'/version01/1-input/MAPS/Crossing Subscale Scores", replace

restore

////////////////////////////////////////////////////////////////////////////////

********************************************************************************

//Retriving variables for Pedestrian Subscale Scoring

********************************************************************************

//Smallest and largest setback scores combined - Wide format (Mean)

preserve
drop if redcap_repeat_instrument=="maps_route"
keep if maps_segment==2
drop routeid-maps_route_complete time_start-Route_Overall 
keep S1_26_27_points record_id redcap_repeat_instance

*Reshape to wide format to calculate mean subscale scores for each route
reshape wide S1_26_27_points, i(record_id) j(redcap_repeat_instance)

egen S1_26_27_points = rowmean(S1_26_27_points1 S1_26_27_points2 ///
								S1_26_27_points3 S1_26_27_points4 ///
								S1_26_27_points5 S1_26_27_points6)
label var S1_26_27_points "Smallest and largest setback scores combined"
drop S1_26_27_points1 - S1_26_27_points6
save "`datapath'/version01/1-input/MAPS/Small_large_setback_combined_wide", replace
restore
********************************************************************************

********************************************************************************
preserve
drop if redcap_repeat_instrument=="maps_route"
keep if mapscrossings_complete==2
drop routeid-maps_route_complete time_start-Route_Overall 
keep  record_id redcap_repeat_instance C1_3b C1_3c C1_3d C1_5a_positive C1_5b_positive C1_7c

*Reshape to wide format to calculate mean subscale scores for each route
reshape wide C1_3b C1_3c C1_3d C1_5a_positive C1_5b_positive C1_7c, i(record_id) j(redcap_repeat_instance)

egen C1_3b = rowmean(C1_3b1 C1_3b2 C1_3b3 C1_3b4 C1_3b5 C1_3b6 C1_3b7)
label var C1_3b "Signalization - walk signs (Mean)"

egen C1_3c = rowmean(C1_3c1 C1_3c2 C1_3c3 C1_3c4 C1_3c5 C1_3c6 C1_3c7)
label var C1_3c "Signalization - Push Buttons (Mean)"

egen C1_3d = rowmean(C1_3d1 C1_3d2 C1_3d3 C1_3d4 C1_3d5 C1_3d6 C1_3d7)
label var C1_3d "Signalization - Countdown signals (Mean)"

egen C1_5a_positive = rowmean(C1_5a_positive1 C1_5a_positive2 C1_5a_positive3 ///
								C1_5a_positive4 C1_5a_positive5 C1_5a_positive6 ///
								C1_5a_positive7)
label var C1_5a_positive "Pre-crossing curb"

egen C1_5b_positive = rowmean(C1_5b_positive1 C1_5b_positive2 C1_5b_positive3 ///
								C1_5b_positive4 C1_5b_positive5 C1_5b_positive6 ///
								C1_5b_positive7)
label var C1_5b_positive "Post-crossing curb"

egen C1_7c = rowmean(C1_7c1 C1_7c2 C1_7c3 C1_7c4 C1_7c5 C1_7c6 C1_7c7)
label var C1_7c "Crossing Aids Present (Mean)"


drop C1_3b1-C1_5b_positive7
save "`datapath'/version01/1-input/MAPS/Crossing_pedestrian_design_wide", replace
restore
********************************************************************************

********************************************************************************
preserve 
keep if instrument_type==1
keep record_id LU7c SS7b SS7c
save "`datapath'/version01/1-input/MAPS/Route_pedestrian_design", replace
restore

////////////////////////////////////////////////////////////////////////////////

********************************************************************************

//MERGING Datasets for Subscale and Overall Scoring for Routes

********************************************************************************

preserve
keep if instrument_type==1
keep record_id type time_start - Route_Overall
save "`datapath'/version01/1-input/MAPS/MAPS Routes", replace
merge 1:1 record_id using "`datapath'/version01/1-input/MAPS/Segment Subscale Scores"
drop _merge
merge 1:1 record_id using "`datapath'/version01/1-input/MAPS/Crossing Subscale Scores"
drop _merge
merge 1:1 record_id using "`datapath'/version01/1-input/MAPS/Route_pedestrian_design"
drop _merge
merge 1:1 record_id using "`datapath'/version01/1-input/MAPS/Small_large_setback_combined_wide"
drop _merge
merge 1:1 record_id using "`datapath'/version01/1-input/MAPS/Crossing_pedestrian_design_wide" 
 
********************************************************************************

//Overall Scoring

********************************************************************************
recode PosCrossChars_C1 (.=25)
egen Overall_Positive = rowtotal(DLU_pos Pos_Streetscape Segments_Pos_S1 PosCrossChars_C1)
label var Overall_Positive "Overall Positive"

gen Overall_Negative = DLU_Neg + Neg_AesthSoc + Segment_Neg_S1
label var Overall_Negative "Overall Negative"

gen Overall_Grand = Overall_Positive - Overall_Negative
label var Overall_Grand "Overall Grand"

********************************************************************************

//Pedestrian Design Scoring - Cross Domain Sub-scale

********************************************************************************
/*
These are the included variables for the Pedestrian design subscale

Pedestrian design subscale (open-air market, trash cans, benches setback, 
ped walk signals, push buttons, countdown signals, ramps, crossing aids)

Excluded items not included due to not being collected due to lack of applicability in Barbados:
kiosks
hawkers and shops

*/

gen pedestrian_design = LU7c + SS7b + SS7c + S1_26_27_points + C1_3b + C1_3c + C1_3d + C1_5a_positive + C1_5b_positive + C1_7c
label var pedestrian_design "Pedestrian Design"

*-------------------------------------------------------------------------------

*Save data to encrypted location
save "`datapath'/version01/2-working/MAPS/MAPS_Overall", replace

*-------------------------------------------------------------------------------

*Import attribute table from ArcGIS
import excel "`datapath'/version01/1-input/MAPS/route_audit_v1.xls", sheet("route_audit_v1") firstrow clear

*Destring road length variable
destring PopupInfo, replace

*Renaming variables
rename RID record_id
rename PopupInfo road_length

*Keep variables of interest
keep record_id road_length

*Relabel road length variable
label var road_length "Route Length (m)"

*Save dataset to encrypted location
save "`datapath'/version01/1-input/MAPS/route_audit_v1", replace

*Open MAPS_Overall data
use "`datapath'/version01/2-working/MAPS/MAPS_Overall.dta", clear

*Merge attribute data from ArcGIS
drop _merge
merge 1:1 record_id using "`datapath'/version01/1-input/MAPS/route_audit_v1" 
drop _merge
order road_length, before(type)

*Save data to encrypted location
save "`datapath'/version01/2-working/MAPS/MAPS_Overall", replace

restore
*--------------------------END--------------------------------------------------