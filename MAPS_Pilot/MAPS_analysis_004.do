
clear
capture log close
cls

**  DO-FILE META DATA INFORMATION
**  Program:		MAPS_analysis_004.do
**  Project:      	Streetscapres- PhD & Walkability
**	Sub-Project:	Pilot MAPS UNESCO Heritiage Site Barbados
**  Analyst:		Kern Rocke
**	Date Created:	30/07/2019
**	Date Modified: 	12/02/2020



** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"
*cd "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
*local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145



/*	IMPORTANT: 

	The following STATA do files should be excuted prior the excuting this 
	do file
	1) MAPS_prep_001.do
	2) MAPS_prep_002.do
	3) MAPS_prep_003.do
	
	Install the command asdoc
	ssc install asdoc
*/


use "`datapath'/version01/2-working/MAPS/MAPS_Overall", clear

*--------------------------------BEGIN------------------------------------------

*Change Directory path to store word results
cd "X:/The University of the West Indies/DataGroup - repo_data/data_p145/version01/3-output/MAPS"

*Route Subscale Scores

recode type (3=2)
	tabstat Res_Density_Mix_recode  Shops  Restaur_Ent Institu_Svc 			///
			Public_Rec Private_Rec DLU_pos DLU_Neg DLU_Overall  			///
			Pos_Streetscape Pos_AesthSoc Neg_AesthSoc AesthSoc_Overall   	///
			Route_Overall, by(type) stat(mean sem) long col(stat)

		
*Segment Subscale Scores
 
	tabstat PosBldgHtSetbks_S1 Sidewalk_S1 Buffers_Pos_S1 Trees_S1 			///
			BldgHt_RdWdthSetbk_Ratio_Scores Segments_Pos_S1					///
			Segment_Neg_S1 Overall_Segment , by(type) stat(mean sem) 		///
			long col(stat) 

			
*Crossing Subscale Scores

   tabstat CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1		///
			PosCrossChars_C1 OverallCrossScore_C1,						///
			 by(type) stat(mean sem) long col(stat)  
			
*Overall 

   tabstat Overall_Positive Overall_Negative 		///
			Overall_Grand pedestrian_design,		///
			 by(type) stat(mean sem) long col(stat)  


 
 

////////////////////////////////////////////////////////////////////////////////
*Route Subscale Scores
	asdoc tabstat Res_Density_Mix_recode  Shops  Restaur_Ent Institu_Svc 			///
			Public_Rec Private_Rec DLU_pos DLU_Neg DLU_Overall  			///
			Pos_Streetscape Pos_AesthSoc Neg_AesthSoc AesthSoc_Overall   	///
			Route_Overall,  stat(mean semean) long col(stat) label save(Subscales.doc)

		
*Segment Subscale Scores
 
	asdoc tabstat PosBldgHtSetbks_S1 Sidewalk_S1 Buffers_Pos_S1 Trees_S1 			///
			BldgHt_RdWdthSetbk_Ratio_Scores Segments_Pos_S1					///
			Segment_Neg_S1 Overall_Segment ,  stat(mean semean) 		///
			long col(stat) label append save(Subscales.doc)

			
*Crossing Subscale Scores

   asdoc tabstat CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1		///
			PosCrossChars_C1 OverallCrossScore_C1,						///
			  stat(mean semean) long col(stat)  label append save(Subscales.doc)
			
*Overall 

   asdoc tabstat Overall_Positive Overall_Negative 		///
			Overall_Grand pedestrian_design,		///
			  stat(mean semean) long col(stat) label append save(Subscales.doc)
			 
////////////////////////////////////////////////////////////////////////////////
	 
*Route Subscale Scores
	asdoc tabstat Res_Density_Mix_recode  Shops  Restaur_Ent Institu_Svc 			///
			Public_Rec Private_Rec DLU_pos DLU_Neg DLU_Overall  			///
			Pos_Streetscape Pos_AesthSoc Neg_AesthSoc AesthSoc_Overall   	///
			Route_Overall, by(type) stat(mean semean) long col(stat) label save(Subscales.doc)

		
*Segment Subscale Scores
 
	asdoc tabstat PosBldgHtSetbks_S1 Sidewalk_S1 Buffers_Pos_S1 Trees_S1 			///
			BldgHt_RdWdthSetbk_Ratio_Scores Segments_Pos_S1					///
			Segment_Neg_S1 Overall_Segment , by(type) stat(mean semean) 		///
			long col(stat) label append save(Subscales.doc)

			
*Crossing Subscale Scores

   asdoc tabstat CrosswalkAmenities_C1 Curb_Qual_C1 IntsectCtrlSign_C1		///
			PosCrossChars_C1 OverallCrossScore_C1,						///
			 by(type) stat(mean semean) long col(stat)  label append save(Subscales.doc)
			
*Overall 

   asdoc tabstat Overall_Positive Overall_Negative 		///
			Overall_Grand pedestrian_design,		///
			 by(type) stat(mean semean) long col(stat) label append save(Subscales.doc)


*----------------------------------END------------------------------------------

