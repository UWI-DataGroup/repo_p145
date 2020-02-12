clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		MAPS_stat_plan_000.do
**	Project:		PhD - Streetscapes
**  Sub-Project:    Microscale Audit of Pedestrain Streetscapes Pilot
**  Analyst:		Kern Rocke
**	Date Created:	13/11/2019
**	Date Modified: 	13/11/2019
**  Algorithm Task: Statistical Analysis Plan


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

/*


General Comments
This file details the statistical analysis plan for the analysis of the microscale audit of 
pedestrian streetscapes pilot of Bridgetown and the Garriosn, Barbados WI. 


Analysis Tasks

1) Presentation of instrument metrics
	1) Length and time taken to conduct audit
	2) Internal consistency of sub-scales and the overall tool (Cronbach alpha)
	
2) Prevalence estimates with 95% CI of all sub-scales for route, segement and crossing 

3) Examine differences between prevalence estimates between residential and commercial areas
	using Wald tests.


*/
