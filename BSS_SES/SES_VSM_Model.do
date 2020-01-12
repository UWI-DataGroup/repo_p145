/*

VARIABLE MODEL

Three models will be constructed for the computation of the SES index score for 
Barbados using census data collected from the year 2010. 

Sample size: 583

The variable models will be as follows

1) Small
2) Medium
3) Large

The large model will include sex-specifc variables while the small and medium 
models will contain non sex-specifc variables. 

--------------------------------------------------------------------------------
1) Small Model - 11 variables

Median age
Less than secondary education
Low income ($0-49999)
No vehicle
Management occupations
Unemployment
Stove
Refrigerator
Washing machine
Television
Computer

global small_list	t_age_median per_education_less_secondary per_t_income_0_49 ///
					per_vehicles_0 per_prof_occupation per_unemployment ///
					per_amentities_stove per_amentities_fridge ///
					per_amentities_wash per_amentities_tv ///
					per_amentities_computer
					
global ED

--------------------------------------------------------------------------------

2) Medium Model - 34 variabels

Non-black population 
Median age
Young age dependency
Old age dependency
Mean household size
Housing tenure -  Owner
Housing tenure - Renting
Single Mother
Less than secondary education
Tertiary education
Median income
Low income ($0-49999)
High income (>$150000)
Unemployment
Liveborn children >5
Crime victim
Management occupations
Professional occupations
Technical occupations
Non-technical occupations
Household structure: number of rooms
Household structure: number of bedrooms
Household structure: number of bathrooms
Toilet presence 
Vehicle Ownership
No Vehicle Ownership
Stove
Refrigerator
Microwave
Computer
Radio
Television
Washing Machine
Household lighting: Electricity 

global medium_list	per_t_non_black t_age_median per_t_young_age_depend 	///
					per_t_old_age_depend ///
					hsize_mean per_htenure_owned per_renting per_smother_total ///
					per_t_education_less_secondary per_t_education_tertiary ///
					per_t_income_0_49 per_t_high_income t_income_median ///
					per_t_unemployment per_live_5_more per_crime_victim ///
					per_t_manage_occupation		///
					per_t_prof_occupation per_t_prof_techoccupation ///
					per_t_prof_n_techoccupation per_rooms_less_3 ///
					per_bedrooms_less_2 per_bathroom_0 per_vehicle_presence ///
					per_vehicles_0 per_amentities_stove per_amentities_fridge ///
					per_amentities_microwave per_amentities_tv ///
					per_amentities_radio per_amentities_wash ///
					per_amentities_computer per_electricity per_toilet_presence
					
global ED

--------------------------------------------------------------------------------

3) Large Model - 48 variables [sex-specific models]

Non-black population										(Male/Female)
Median age													(Male/Female)
Young age dependency										(Male/Female)
Old age dependency											(Male/Female)
Mean household size
Housing tenure -  Owner
Housing tenure - Renting
Single Mother
Less than secondary education								(Male/Female)
Tertiary education											(Male/Female)
Median income												(Male/Female)
Low income ($0-49999)										(Male/Female)
High income (>$150000)										(Male/Female)
Unemployment												(Male/Female)
Liveborn children >5
Crime victim
Management occupations										(Male/Female)
Professional occupations									(Male/Female)
Technical occupations										(Male/Female)
Non-technical occupations									(Male/Female)
Household structure: number of rooms
Household structure: number of bedrooms
Household structure: number of bathrooms
Toilet presence
Vehicle Ownership
No Vehicle Ownership
Stove
Refrigerator
Microwave
Computer
Radio
Television
Washing Machine
Household lighting: Electricity


global large_list	per_f_non_black per_m_non_black							///

					f_age_median m_age_median 								///
					per_f_young_age_depend per_m_young_age_depend 			///
					per_f_old_age_depend per_m_old_age_depend 				///
					
					hsize_mean per_htenure_owned per_renting per_smother_total ///
					
					per_f_education_less_secondary per_m_education_less_secondary  ///
					per_f_education_tertiary per_m_education_tertiary		///
					
					per_f_income_0_49 per_m_income_0_49						///
					per_f_high_income per_m_high_income						///
					f_income_median m_income_median 						///
					
					per_f_unemployment per_m_unemployment					///
										
					per_live_5_more per_crime_victim ///
					
					per_f_manage_occupation per_m_manage_occupation			///
					per_f_prof_occupation per_m_prof_occupation				///
					per_f_prof_techoccupation per_m_prof_techoccupation ///			
					per_f_prof_n_techoccupation per_m_prof_n_techoccupation ///
					
					per_rooms_less_3 per_bedrooms_less_2 per_bathroom_0		///
					
					per_toilet_presence										///
					
					per_vehicle_presence per_vehicles_0 per_amentities_stove	///
					per_amentities_fridge per_amentities_microwave 	///
					per_amentities_tv per_amentities_radio			///
					per_amentities_wash per_amentities_computer	///
					
					per_electricity
					
					


global ED

--------------------------------------------------------------------------------





























*/
