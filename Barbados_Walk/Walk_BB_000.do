clear
capture log close
cls


**  GENERAL DO-FILE COMMENTS
**  Program:		Walk_BB_000.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	Walkability Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	26/07/2020
**	Date Modified: 	11/09/2020
**  Algorithm Task: Walkability Analysis Descriptions


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

DO & py FILES

1) Walk_BB_001 - Joining ED and land use layer within GIS (Python)

2) Walk_BB_002 - Land use mix - Entropy Index Calculation (STATA)

3) Walk_BB_003 - Creation of Land Use Mix Layer (Python)

4) Walk_BB_004 - Creation of Bus Stop Density Layer (Python)

5) Walk_BB_005 - Creation of Street Intersection Density Layer (Python)

6) Walk_BB_006 - Creating Housing/Residential Density Layer (Python)

7) Walk_BB_007 - Creating Walkability Attributes Layer (Python)

8) Walk_BB_008 - Walkability Index Calculation (STATA)

9) Walk_BB_009 - Creating Walkability Index Layer (Python)

10) Walk_BB_010 - Creating Walkability and Socioeconomic Status Layer (Python)

11) Walk_BB_011 - Walkability Hotspot Analysis (Python)

12) Walk_BB_012 - Creating Walkability and SES categories (STATA)

13) Walk_BB_013 - IPEN Walkability Country/Site Comparison (STATA)

14) Walk_BB_014 - Area Level walkability and active transport analysis (STATA)

15) Walk_BB_015 - Analysis of Walkscore by ED (STATA)

16) Walk_BB_016 - Creating Destination Density Attributes (Python)

17) Walk_BB_017 - Creating Moveability Index (STATA)

18) Walk_BB_018 - Limits of Agreement for Walkability Measures (STATA)

19) Walk_BB_019 - Data Driven Walkbility Index & Limits of Agreement (STATA)

20) Walk_BB_020 - Multi-level analysis of Area Level walkability and SES (STATA)

21) Walk_BB_021 - Walk score computation by parcel level for Barbados (STATA)
	Walk_BB_021_1 - Geocoded centroid of parcels for Barbados (STATA)

22) Walk_BB_022 - Creating Walkability Index based on road and footpath connectivity (STATA)

23) Walk_BB_023 - Walkscore Computation by Building footprint Level (STATA)
	Walk_BB_023)1 - Geocoded centroid of building footprints for Barbados (STATA)

24) Walk_BB_024 - Road and Footpath Walkability Computation (STATA)

25) Walk_BB_025 - Walkscore Computation by ECHORN Participant address (STATA)
	Walk_BB_025_1 - Geocoded centroid of ECHORN Participants for Barbados (STATA)

26) Walk_BB_026 - Creating new walkability index using Walkability Framework (STATA)


