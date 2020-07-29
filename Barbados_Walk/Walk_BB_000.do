clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_000.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	26/07/2020
**	Date Modified: 	27/07/2020
**  Algorithm Task: Walkability Descriptions


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 150

*-------------------------------------------------------------------------------
/*
Walkabilty Index

Walkability refers to the infrastructure in place which allows for effective 
movement to known destinations within a specified spatial location. 

This is usually computed using objective measures of the built environment.
Attributes usually used to compute this index are:
	1) Residential Density
	2) Street Connectivity
	3) Mixed Land Use
	4) Retail Floor
	5) Bus Stop Density
	6) Park Density
	
This study will be computing walkability for the country of Barbados at the 
enumeration district level which is the smallest statistical area unit used to 
assess populations at for periodic census evaluation. 

This analysis uses a blend of geospatial and statistical analysis to estimate the 
walkability distribution in Barbados. 

The index used follows similar computations used by the International Physical
Activity and Environment Network (IPEN) Project

Reference:
Frank LD, Sallis JF, Saelens BE, Leary L, Cain K, Conway TL, et al. 
The development of a walkability index: application to the Neighborhood Quality 
of Life Study. Br J Sports Med. 2010 Oct;44(13):924�33. 

The walkability index includes the following components
	1) Residential Density: (Number of households within each ED/Area of ED)
	2) Street Connectivity (Intersections >/=3): (Number of intersection within each ED/Area of ED)
	3) Mixed Land Use (Entropy Index): -1*sum of p x ln(p) / ln(k)
		p- Proportion of land use compared to overall ED land use area
		k- Number of land uses with ED


Note: Area within each ED was determined within GIS using a local projected coorrdinate
system of Barabdos 1938 Grid or Transformation of Global projected coordinate 
system of the World Geodetic System 1984 Universe Transvers Metecrator 21 North. 

Area was calculated as square kilometers


*-------------------------------------------------------------------------------

DO FILES

1) Walk_BB_001 - Joining ED and land use layer within GIS

2) Walk_BB_002 - Land use mix - Entropy Index Calculation

3) Walk_BB_003 - Creation of Bus Stop Density Layer



