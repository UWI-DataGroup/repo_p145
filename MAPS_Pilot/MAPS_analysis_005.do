
clear
capture log close
cls

**  DO-FILE META DATA INFORMATION
**  Program:		MAPS_analysis_004.do
**  Project:      	Streetscapres- PhD & Walkability
**	Sub-Project:	Pilot MAPS UNESCO Heritiage Site Barbados
**  Analyst:		Kern Rocke
**	Date Created:	30/07/2019
**	Date Modified: 	01/08/2019


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200


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
	The following STATA do file should be excuted prior the excuting this 
	do file
	1) MAPS_prep_001.do
	2) MAPS_prep_002.do
	3) MAPS_prep_003.do
*/


*Reading in dataset
use "`datapath'/version01/2-working/MAPS/MAPS_Overall", clear

*--------------------------------BEGIN------------------------------------------


*Recoding mixed to commercial
recode type (3=2)


////////////////////////////////////////////////////////////////////////////////
**Test for assessing Normal distribution

*Skewness and Kurtosis Tests

*Route Subscale Scores

sktest		Res_Density_Mix_recode  Shops  Restaur_Ent Institu_Svc 			///
			Public_Rec Private_Rec DLU_pos DLU_Neg DLU_Overall  			///
			Pos_Streetscape Pos_AesthSoc Neg_AesthSoc AesthSoc_Overall   	///
			Route_Overall

			
*Segment Subscale Scores

sktest		PosBldgHtSetbks_S1 Sidewalk_S1 Buffers_Pos_S1 Trees_S1 			///
			BldgHt_RdWdthSetbk_Ratio_Scores Segments_Pos_S1					///
			Segment_Neg_S1 Overall_Segment
			
			
*Crossing Subscale Scores
			
sktest		CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1		///
			PosCrossChars_C1 OverallCrossScore_C1
			
sktest		Overall_Positive Overall_Negative 		///
			Overall_Grand pedestrian_design	
			
*Shapiro Wilks Test

*Route Subscale Scores
			
swilk		Res_Density_Mix_recode  Shops  Restaur_Ent Institu_Svc 			///
			Public_Rec Private_Rec DLU_pos DLU_Neg DLU_Overall  			///
			Pos_Streetscape Pos_AesthSoc Neg_AesthSoc AesthSoc_Overall   	///
			Route_Overall

*Segment Subscale Scores

swilk		PosBldgHtSetbks_S1 Sidewalk_S1 Buffers_Pos_S1 Trees_S1 			///
			BldgHt_RdWdthSetbk_Ratio_Scores Segments_Pos_S1					///
			Segment_Neg_S1 Overall_Segment

			
			*Crossing Subscale Scores			
swilk		CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1		///
			PosCrossChars_C1 OverallCrossScore_C1
			
swilk		Overall_Positive Overall_Negative 		///
			Overall_Grand pedestrian_design	

////////////////////////////////////////////////////////////////////////////////

*Inferential Statistical Analyses

/*
Note: Due to sub-scale scores being derived from ordinal data, non-parametric 
analyses shall be used
*/
			
**Mann Whitney U test

*Route Subscale Scores

foreach x of varlist Res_Density_Mix_recode  Shops  Restaur_Ent Institu_Svc 			///
			Public_Rec Private_Rec DLU_pos DLU_Neg DLU_Overall  			///
			Pos_Streetscape Pos_AesthSoc Neg_AesthSoc AesthSoc_Overall   	///
			Route_Overall{
ranksum `x', by(type) 
}
 
 
*Segment Subscale Scores

foreach x of varlist PosBldgHtSetbks_S1 Sidewalk_S1 Buffers_Pos_S1 Trees_S1 			///
			BldgHt_RdWdthSetbk_Ratio_Scores Segments_Pos_S1					///
			Segment_Neg_S1 Overall_Segment{
ranksum `x', by(type) 
}


*Crossing Subscale Scores

foreach x of varlist CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1		///
			PosCrossChars_C1 OverallCrossScore_C1{
ranksum `x', by(type) 
}


*Overall

foreach x of varlist Overall_Positive Overall_Negative 		///
			Overall_Grand pedestrian_design{
ranksum `x', by(type) 
}

 *----------------------------------END------------------------------------------

