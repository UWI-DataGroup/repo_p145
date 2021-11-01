clear

cls
** HEADER -----------------------------------------------------
	**  DO-FILE METADATA
	**  Program:		ECS_BB_Spatial_Cleaning
	**  Project:      	PhD Streetscapes
	**	Sub-Project:	Microscale Walkability
	**  Analyst:		Kern Rocke
	**	Date Created:	12/08/2021
	**	Date Modified:  12/08/2021
	**  Algorithm Task: Cleaning spatial coordinates

    ** General algorithm set-up
    version 13
    set more 1
    set linesize 80


import delimited "/Users/kernrocke/Downloads/ECS_BB.csv"
keep name latitude longitude ___key ed
rename name address
rename ___key key
rename ed ED
label var key "Key"
label var address "Address"


foreach x in  15 32 49 67 81 98 118 133 155 166 181 196 241 273 309 324 363 379 396 422 436 455 486 504 517 536 556 566 581 {
	
	duplicates drop latitude longitude if ED==`x', force
}
drop if latitude == .
count
sort ED latitude longitude
browse latitude longitude ED

*---------------------------------------------------------------
