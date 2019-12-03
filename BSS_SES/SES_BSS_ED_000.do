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
Consider in addition analysis using "Lasso (availabile in STATA v16)" or lasso2 addon availabile - 
Not possible with no outcome variable. Consider using population density

This can be used to compare to the results obtained from PCA analysis

*-------------------------------------------------------------------------------

BARADOS SES INDEX MODEL

Proposed Variable Model for SES/SEP index

*Income
per_t_income_0_49  per_high_income t_income_median

*Age
t_age_median per_young_age_depend per_old_age_depend

*Education
per_education_less_secondary per_t_education_tertiary

*House Tenure
per_htenure_owned per_renting

*Household Ammentities 
per_amentities_stove per_amentities_fridge per_amentities_microwave ///
per_amentities_tv  per_amentities_radio per_amentities_wash  ///
per_amentities_computer

*Work Activity 
per_t_wactivity_government per_private_wactivity 

*Occupation
per_prof_occupation per_prof_techoccupation per_prof_n_techoccupation

*Unemployment
per_unemployment per_t_wactivity_no_work 

*Crime 
per_crime_victim 

*Single Mother
per_smother_total 

*Martial Status
per_marital_n_married

*Vehicle Ownership
per_vehicle_presence 

*Household Structure
hsize_mean per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0

*Liveborn Children
per_live_5_more 

*-------------------------------------------------------------------------------

SENSITIVITY ANALYSIS

Sensitiivity analysis will be conducted repeating pca analysis using the following
matrix (15 models)

Variable model x component retention methods

Variable model: 
1) Large ses variable set
2) Medium size ses variable set
3) Small size ses variable set 

Component retention method 
1) Eigen Value >1
2) Indivudal percent variance explained >5%
3) Cummulative percent variance explained 80%
4) Cummulative percent variance explained 90%
5) Horn's Parallel PCA Analysis


*/

*-------------------------------------------------------------------------------


*LARGE VARIABLE MODEL


*1) Income: per_t_income_0_49 per_high_income t_income_median


*2) Education: per_education_less_secondary per_t_education_tertiary


*3) Age: t_age_median per_young_age_depend per_old_age_depend


*4) Home Amentities:  per_amentities_stove per_amentities_fridge per_amentities_microwave per_amentities_tv per_amentities_radio per_amentities_wash per_amentities_computer


*5) Occupation: per_prof_occupation per_prof_techoccupation per_prof_n_techoccupation 


*6) House Tenure: per_htenure_owned per_renting


*7) Work Activity: per_t_wactivity_government per_private_wactivity


*8) Crime: per_crime_victim


*9) Household Size: hsize_mean


*10) Crowding: per_live_5_more


*11) Single Mother: per_smother_total


*12) Marital Status: per_marital_n_married


*13) Household Structure: per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0


*14) Vehicle Ownership: per_vehicle_presence *****per_vehicles_0


*15) Unemployment: per_unemployment per_t_wactivity_no_work



/*

Ethnicity
Non-black population (Total Population)

Age
Median Age; young age dependancy; old age dependancy (Total Population)

Household Size
Mean household size; ****house hold size >=6 persons (Total Population)

Housing Tenure
House tenure: Owner; House tenure: renting (Government and Private) (Total Population)

Single Mother (Total Population)

Education
Education less than secondary; Teritary Education (Total Population / Male or Female breakdown?)

Income (Yearly Pay)
Median Income (Total / Male or Female); Low income; High income

Work Activity
Unemployment (Student****, Retired***, looking for work, home duties*****, incapaciated****)  [Total population  /  Male or Female?]

Women with liveborn children
Liveborn children >5

Crime
Crime Victim

Occupation
Management; Professional; Technical; Non-technical Occupation (Male / Female)

Marital Status****
Single (Never married & seperated), Married

Household structure
Number of rooms; number of bedrooms; number of bathrooms, toilet

Vehicle Ownership 
No Vehicle; Vehicle

Household Amentities
Stove, Refridgerator, Microwave, Computer, Radio, Television, Washing Machine, Computer


*-------------------------------------------------------------------------------


Note: Analysis change

Analysis will be based on the following criteria

1) Variable Selection Model
	a) Large size variable set 
	b) Medium size variable set
	c) Small size variable set 
	
	*Note consider adding variable one by one using the jack-knife approach
	
2) Component retention models	
	a) PCA eigen >1
	b) Indivdual component variance explained >5%
	c) Cummulative variance explained >70/80%
	d) Horn parallel analysis
	
3) Rotation method
	a) Orthogonal rotation - Varimax
	b) Non-Orthogonal rotation - Oblique
	
	
Once combinations of each criteria is conducted predicted variable scores for 
each method will be ranked based on the enumeration district.

An examination of the differences between rankings will be used to determine which 
method will be preferential.

Following this ses scores will be mapped by enumeration district for Barbados

Future work may examine linking neighbourhood variability in SES by cardiovascular
risk/walkability for Barbados  - Possible PhD outputs. 

Consider creating structural equation model for the analysis of socioeconomic 
status (takes into account measurement error)

/////////

References

Geyer S, Hemstrom O, Peter R, Vagero D. Education, income, and occupational class 
cannot be used interchangeably in social epidemiology. Empirical evidence against a 
common practice. Journal of epidemiology and community health 2006;60(9):804-10.

Davey Smith G, Hart C, Hole D, et al. Education and occupational social class: which 
is the more important indicator of mortality risk? Journal of epidemiology and community 
health 1998;52(3):153-60

////////

*-------------------------------------------------------------------------------