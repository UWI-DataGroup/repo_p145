
clear
capture log close
cls

//Note: This algorithm can only be run after all do files are created

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_000_1.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	15/01/2019
**	Date Modified: 	15/01/2019
**  Algorithm Task: DO-FILE STATA LOOP for SES Analysis


/*
This analysis loop will be based on the statistical analysis plan set out in
SES_BSS_ED_000 
*/



*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
local dofilepath "C:/Users/810000689/OneDrive - The University of the West Indies/Github Repositories/"


*Do file loop

local ses "002 003 003_1 004_small 004_medium 004_large merge Sign_Rank_test" 

foreach a in 001 {
foreach b in 002 {
foreach c in 003 {
foreach d in 003_1 {
foreach e in 004_small {
foreach f in 004_medium {
foreach g in 004_large {
foreach h in merge {
foreach i in Sign_Rank_test  {

do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`a'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`b'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`c'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`d'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`e'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`f'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`g'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`h'" }
do "`dofilepath'/repo_p145\BSS_SES\SES_BSS_ED_`i'" }

*-------------------------END---------------------------------------------------
