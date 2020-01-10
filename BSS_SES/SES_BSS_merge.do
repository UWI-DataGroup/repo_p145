clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_004*

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_merge.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	10/01/2020
**	Date Modified: 	10/01/2020
**  Algorithm Task: Merging SES VSM datasets


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

*MAC OS
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"

** Logfiles to unencrypted location
*local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

**Aggregated output path
*WINDOWS
local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p145"
*MAC
*local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p145"


*-------------------------------------------------------------------------------

*Open data from encrypted location
