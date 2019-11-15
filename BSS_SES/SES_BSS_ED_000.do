clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_000.do
**  Project:      	Macroscale Walkability- PhD
**  Analyst:		Kern Rocke
**	Date Created:	21/10/2019
**	Date Modified: 	05/11/2019
**  Algorithm Task: Statistical Analysis Plan


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200


**---------------------------------------------------

/*
ANALYSIS OUTLINE

Development of SES and social depreviaion index scores for Barbados by Enummeration District

Dataset: SES estimates from 2010 Census by ED of Barbados 

Socioeconmic status is integral for determining socioeconomic inequalitites among neighbourhoods and communities in low resource settings.
This is especially important as this may be a driving force for health inequalities and barriers to health access and living in Barbados
Furthermore, in determining walkability and areas in which it should be assessed we plan to use the methods suggested by IPEN in the consideration of
varying levels of walkability and socioeconmic status. 

Proposed statistical analysis technique: Principle component analysis (PCA)

Results from theses analyses well then be categorized into declies whereby deciles 1-4 will be considered low ses and deciles 7-10 will be considered high SES.
This will then be visualized on ED maps for Barbados and study sites for ECHORN. 

The raw estimates which were given will be converted to percentages based on the population size for the respective ennumeration district. 

The literature has suggested that there is no defined listing of variables which should be used for the computation of SES index using census data.

Measures for SES which will be considered are:
1) Income
2) Education
3) Crime
4) Occupation
5) Main activity
6) Age
7) Ethnicity
8) Household size
9) Single mothers and liveborn children
10) Liveborn children
11) Work activity
12) Relationship to head of household
13) House Tenureship
14) Vehicle Ownership
15) Household Ammentities
16) Number of rooms
17) Number of bedrooms
18) Number of bathrooms
19) Religion
20) Toilet presence
21) Marial status

An idea for future work could be examining the Socioeconmic environment spatially across ECHORN sites.
(Note: Data can be obtained for USVI and Puerto Rico by ED level from US.gov repositories?)


1) Data cleaning 
    Algorithim : SES_BSS_ED_001
    This will be used to import raw data for each SES category into STATA.
    Removal of any irrelavant data will be done

2) Data management
    Algorithim : SES_BSS_ED_002
    This will be used to merge all sex-specific datasets into one location
    Creation of final dataset to be used for analysis

3) Data manipulation 
    Algorithim : SES_BSS_ED_003
    This will be used to generarte estimates for each SES catgory by ED to be used for PCA
    Creation of analysis dataset to be used for part 2

4) Data Analysis 
    Algorithim : SES_BSS_ED_004
    This will be used to construct SES composite and social depreviation scores by ED using principal compoennt analysis (PCA)
    Creation of analysis dataset to be used for geospatial mapping of Barbados

Note:
Plot correlation coefficents (yaxis) and number of combinations (refer to Ian's dietary patterns analysis)
This will be a scatter plot

*Note:
Consider in addition analysis using "Lasso (availabile in STATA v16)"
This can be used to compare to the results obtained from PCA analysis


BARADOS SES INDEX MODEL

Proposed Variable Model for SES/SEP index

1)	Total Median income
2)	Education less than secondary
3)	Crime murder
4)	Crime shooting
5)	Crime robbery
6)	Crime victim
7)	Median age (Total)
8)	Household size mean
9)	House tenure owner
10)	House tenure private rent
11)	House tenure government rent
12)	Professional Occupations
13)	Number of rooms
14)	Number of bedrooms
15)	Number of bathrooms
16)	Vehicle owner
17)	Electricity
18)	Single/never married
19)	Home Amenities (stove, refrigerator, microwave, television, radio, washing machine)
20)	Single mothers 
21)	Main activity working
22)	Main activity no working
23)	Work activity not working


*/
