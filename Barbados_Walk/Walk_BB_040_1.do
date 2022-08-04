local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/SharePoint - The University of the West Indies/DataGroup - data_p145"
cd "`datapath'/version01/2-working/Walkability/"

*Save results in table

putexcel set "`datapath'/version01/2-working/Walkability/Regression_Results.xlsx", replace sheet("Table 3")

putexcel B1= "Unadjusted Model", bold
putexcel B3= "Outcome"
putexcel C3= "Coeff"
putexcel D3= "95% CI (LL)"
putexcel E3= "95% CI (UL)"
putexcel F3= "p-value"


putexcel B5= "Overall walking (mins/week)", bold
putexcel B6= "Walking for pleasure (mins/week)", bold
putexcel B7= "Walking for exercise (mins/week)", bold
putexcel B8= "Leisure Activity (mins/week)", bold
putexcel B9= "MVPA (mins/week)", bold
putexcel B10= "Total activity (mins/week)", bold
putexcel B11= "Distance travelled (km)", bold

metobit walk walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C5= a[1,1]
putexcel D5= a[5,1]
putexcel E5= a[6,1]
putexcel F5= a[4,1]

metobit walkPleasureMin walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C6= a[1,1]
putexcel D6= a[5,1]
putexcel E6= a[6,1]
putexcel F6= a[4,1]

metobit walkExerMin walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C7= a[1,1]
putexcel D7= a[5,1]
putexcel E7= a[6,1]
putexcel F7= a[4,1]

metobit LEIStime walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C8= a[1,1]
putexcel D8= a[5,1]
putexcel E8= a[6,1]
putexcel F8= a[4,1]

metobit mvpa_mins walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C9= a[1,1]
putexcel D9= a[5,1]
putexcel E9= a[6,1]
putexcel F9= a[4,1]

metobit total_time walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C10= a[1,1]
putexcel D10= a[5,1]
putexcel E10= a[6,1]
putexcel F10= a[4,1]

metobit distance_km walkability_new_10  [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C11= a[1,1]
putexcel D11= a[5,1]
putexcel E11= a[6,1]
putexcel F11= a[4,1]


*-------------------------------------------------------------------------------

putexcel H1= "Multivariable Adjusted Model", bold
putexcel H3= "Outcome", bold
putexcel I3= "Coeff", bold 
putexcel J3= "95% CI (LL)", bold 
putexcel K3= "95% CI (UL)", bold
putexcel L3= "p-value", bold

putexcel H5= "Overall walking (mins/week)", bold
putexcel H6= "Walking for pleasure (mins/week)", bold
putexcel H7= "Walking for exercise (mins/week)", bold
putexcel H8= "Leisure Activity (mins/week)", bold
putexcel H9= "MVPA (mins/week)", bold
putexcel H10= "Total activity (mins/week)", bold
putexcel H11= "Distance travelled (km)", bold


metobit walk walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I5= a[1,1]
putexcel J5= a[5,1]
putexcel K5= a[6,1]
putexcel L5= a[4,1]

metobit walkPleasureMin walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I6= a[1,1]
putexcel J6= a[5,1]
putexcel K6= a[6,1]
putexcel L6= a[4,1]

metobit walkExerMin walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I7= a[1,1]
putexcel J7= a[5,1]
putexcel K7= a[6,1]
putexcel L7= a[4,1]

metobit LEIStime walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I8= a[1,1]
putexcel J8= a[5,1]
putexcel K8= a[6,1]
putexcel L8= a[4,1]

metobit mvpa_mins walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I9= a[1,1]
putexcel J9= a[5,1]
putexcel K9= a[6,1]
putexcel L9= a[4,1]

metobit total_time walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I10= a[1,1]
putexcel J10= a[5,1]
putexcel K10= a[6,1]
putexcel L10= a[4,1]

metobit distance_km walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||parish: ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I11= a[1,1]
putexcel J11= a[5,1]
putexcel K11= a[6,1]
putexcel L11= a[4,1]



********************************************************************************

putexcel set "`datapath'/version01/2-working/Walkability/Regression_Results.xlsx", modify sheet("Table 3 (no parish)")

putexcel B1= "Unadjusted Model", bold
putexcel B3= "Outcome"
putexcel C3= "Coeff"
putexcel D3= "95% CI (LL)"
putexcel E3= "95% CI (UL)"
putexcel F3= "p-value"


putexcel B5= "Overall walking (mins/week)", bold
putexcel B6= "Walking for pleasure (mins/week)", bold
putexcel B7= "Walking for exercise (mins/week)", bold
putexcel B8= "Leisure Activity (mins/week)", bold
putexcel B9= "MVPA (mins/week)", bold
putexcel B10= "Total activity (mins/week)", bold
putexcel B11= "Distance travelled (km)", bold

metobit walk walkability_new_10  [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C5= a[1,1]
putexcel D5= a[5,1]
putexcel E5= a[6,1]
putexcel F5= a[4,1]

metobit walkPleasureMin walkability_new_10  [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C6= a[1,1]
putexcel D6= a[5,1]
putexcel E6= a[6,1]
putexcel F6= a[4,1]

metobit walkExerMin walkability_new_10  [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C7= a[1,1]
putexcel D7= a[5,1]
putexcel E7= a[6,1]
putexcel F7= a[4,1]

metobit LEIStime walkability_new_10  [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C8= a[1,1]
putexcel D8= a[5,1]
putexcel E8= a[6,1]
putexcel F8= a[4,1]

metobit mvpa_mins walkability_new_10  [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C9= a[1,1]
putexcel D9= a[5,1]
putexcel E9= a[6,1]
putexcel F9= a[4,1]

metobit total_time walkability_new_10  [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C10= a[1,1]
putexcel D10= a[5,1]
putexcel E10= a[6,1]
putexcel F10= a[4,1]

metobit distance_km walkability_new_10  [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel C11= a[1,1]
putexcel D11= a[5,1]
putexcel E11= a[6,1]
putexcel F11= a[4,1]


*-------------------------------------------------------------------------------

putexcel H1= "Multivariable Adjusted Model", bold
putexcel H3= "Outcome", bold
putexcel I3= "Coeff", bold 
putexcel J3= "95% CI (LL)", bold 
putexcel K3= "95% CI (UL)", bold
putexcel L3= "p-value", bold

putexcel H5= "Overall walking (mins/week)", bold
putexcel H6= "Walking for pleasure (mins/week)", bold
putexcel H7= "Walking for exercise (mins/week)", bold
putexcel H8= "Leisure Activity (mins/week)", bold
putexcel H9= "MVPA (mins/week)", bold
putexcel H10= "Total activity (mins/week)", bold
putexcel H11= "Distance travelled (km)", bold


metobit walk walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I5= a[1,1]
putexcel J5= a[5,1]
putexcel K5= a[6,1]
putexcel L5= a[4,1]

metobit walkPleasureMin walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I6= a[1,1]
putexcel J6= a[5,1]
putexcel K6= a[6,1]
putexcel L6= a[4,1]

metobit walkExerMin walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I7= a[1,1]
putexcel J7= a[5,1]
putexcel K7= a[6,1]
putexcel L7= a[4,1]

metobit LEIStime walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I8= a[1,1]
putexcel J8= a[5,1]
putexcel K8= a[6,1]
putexcel L8= a[4,1]

metobit mvpa_mins walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I9= a[1,1]
putexcel J9= a[5,1]
putexcel K9= a[6,1]
putexcel L9= a[4,1]

metobit total_time walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I10= a[1,1]
putexcel J10= a[5,1]
putexcel K10= a[6,1]
putexcel L10= a[4,1]

metobit distance_km walkability_new_10 age sex i.ethnic_new bmi SES htn_new diab car_new smoke [pweight = wps_b2010] ||ED:, ll(0) nolog cformat(%9.1f)
matrix a = r(table)
putexcel I11= a[1,1]
putexcel J11= a[5,1]
putexcel K11= a[6,1]
putexcel L11= a[4,1]


********************************************************************************

putexcel set "`datapath'/version01/2-working/Walkability/Regression_Results.xlsx", modify sheet("Table 4")

putexcel B1= "Unadjusted Model", bold
putexcel B3= "Outcome", bold
putexcel C3= "Coeff", bold
putexcel D3= "95% CI (LL)", bold
putexcel E3= "95% CI (UL)", bold
putexcel F3= "p-value", bold


putexcel B5= "10-year CVD Risk (%)", bold
putexcel B6= "Total Cholesterol", bold
putexcel B7= "SBP", bold
putexcel B8= "DBP", bold
putexcel B9= "Fasting glucose", bold
putexcel B10= "HBA1c", bold
putexcel B11= "BMI", bold


putexcel C12= "OR", bold
putexcel D12= "95% CI (LL)", bold
putexcel E12= "95% CI (UL)", bold
putexcel F12= "p-value", bold

putexcel B13= "10-year CVD Risk (>7.5%)", bold
putexcel B14= "10-year CVD Risk (>10%)", bold
putexcel B15= "10-year CVD Risk (>20%)", bold
putexcel B16= "Hypertension", bold
putexcel B17= "Diabetes", bold
putexcel B18= "Obesity", bold


mixed ascvd10_hotn walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel C5= a[1,1]
putexcel D5= a[5,1]
putexcel E5= a[6,1]
putexcel F5= a[4,1]

mixed fram_tchol walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel C6= a[1,1]
putexcel D6= a[5,1]
putexcel E6= a[6,1]
putexcel F6= a[4,1]

mixed fram_sbp walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel C7= a[1,1]
putexcel D7= a[5,1]
putexcel E7= a[6,1]
putexcel F7= a[4,1]

mixed dbp_hotn  walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel C8= a[1,1]
putexcel D8= a[5,1]
putexcel E8= a[6,1]
putexcel F8= a[4,1]

mixed glucose_hotn walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel C9= a[1,1]
putexcel D9= a[5,1]
putexcel E9= a[6,1]
putexcel F9= a[4,1]

mixed hba1c_hotn walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel C10= a[1,1]
putexcel D10= a[5,1]
putexcel E10= a[6,1]
putexcel F10= a[4,1]

mixed bmi walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel C11= a[1,1]
putexcel D11= a[5,1]
putexcel E11= a[6,1]
putexcel F11= a[4,1]

melogit cvd75 walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel C13= a[1,1]
putexcel D13= a[5,1]
putexcel E13= a[6,1]
putexcel F13= a[4,1]

melogit cvd10 walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel C14= a[1,1]
putexcel D14= a[5,1]
putexcel E14= a[6,1]
putexcel F14= a[4,1]

melogit cvd20 walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel C15= a[1,1]
putexcel D15= a[5,1]
putexcel E15= a[6,1]
putexcel F15= a[4,1]

melogit htn_new walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel C16= a[1,1]
putexcel D16= a[5,1]
putexcel E16= a[6,1]
putexcel F16= a[4,1]

melogit fram_diab walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel C17= a[1,1]
putexcel D17= a[5,1]
putexcel E17= a[6,1]
putexcel F17= a[4,1]

melogit obese walkability_new_10 if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel C18= a[1,1]
putexcel D18= a[5,1]
putexcel E18= a[6,1]
putexcel F18= a[4,1]


*-------------------------------------------------------------------------------

putexcel H1= "Multivariable Adjusted Model", bold
putexcel H3= "Outcome", bold
putexcel I3= "Coeff", bold 
putexcel J3= "95% CI (LL)", bold 
putexcel K3= "95% CI (UL)", bold
putexcel L3= "p-value", bold


putexcel I12= "OR", bold
putexcel J12= "95% CI (LL)", bold
putexcel K12= "95% CI (UL)", bold
putexcel L12= "p-value", bold

putexcel H5= "10-year CVD Risk (%)", bold
putexcel H6= "Total Cholesterol", bold
putexcel H7= "SBP", bold
putexcel H8= "DBP", bold
putexcel H9= "Fasting glucose", bold
putexcel H10= "HBA1c", bold
putexcel H11= "BMI", bold

putexcel H13= "10-year CVD Risk (>7.5%)", bold
putexcel H14= "10-year CVD Risk (>10%)", bold
putexcel H15= "10-year CVD Risk (>20%)", bold
putexcel H16= "Hypertension", bold
putexcel H17= "Diabetes", bold
putexcel H18= "Obesity", bold

/*
Models adjusted for: 
total time spent on activity, sex, age, education, BMI (when not an outcome)
Car ownership, Neighbourhood SES, Smoking and ethnicity
*/

mixed ascvd10_hotn walkability_new_10 total_time sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel I5= a[1,1]
putexcel J5= a[5,1]
putexcel K5= a[6,1]
putexcel L5= a[4,1]

mixed fram_tchol walkability_new_10 total_time sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel I6= a[1,1]
putexcel J6= a[5,1]
putexcel K6= a[6,1]
putexcel L6= a[4,1]

mixed fram_sbp walkability_new_10 total_time sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel I7= a[1,1]
putexcel J7= a[5,1]
putexcel K7= a[6,1]
putexcel L7= a[4,1]

mixed dbp_hotn  walkability_new_10 total_time sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel I8= a[1,1]
putexcel J8= a[5,1]
putexcel K8= a[6,1]
putexcel L8= a[4,1]

mixed glucose_hotn walkability_new_10 total_time sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel I9= a[1,1]
putexcel J9= a[5,1]
putexcel K9= a[6,1]
putexcel L9= a[4,1]

mixed hba1c_hotn walkability_new_10 total_time sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel I10= a[1,1]
putexcel J10= a[5,1]
putexcel K10= a[6,1]
putexcel L10= a[4,1]

mixed bmi walkability_new_10 total_time sex age i.educ_new car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f)
matrix a = r(table)
putexcel I11= a[1,1]
putexcel J11= a[5,1]
putexcel K11= a[6,1]
putexcel L11= a[4,1]

melogit cvd75 walkability_new_10 sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel I13= a[1,1]
putexcel J13= a[5,1]
putexcel K13= a[6,1]
putexcel L13= a[4,1]

melogit cvd10 walkability_new_10 sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:,  nolog cformat(%9.2f) or
matrix a = r(table)
putexcel I14= a[1,1]
putexcel J14= a[5,1]
putexcel K14= a[6,1]
putexcel L14= a[4,1]

melogit cvd20 walkability_new_10 sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel I15= a[1,1]
putexcel J15= a[5,1]
putexcel K15= a[6,1]
putexcel L15= a[4,1]

melogit htn_new walkability_new_10 sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel I16= a[1,1]
putexcel J16= a[5,1]
putexcel K16= a[6,1]
putexcel L16= a[4,1]

melogit fram_diab walkability_new_10 sex age i.educ_new bmi car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel I17= a[1,1]
putexcel J17= a[5,1]
putexcel K17= a[6,1]
putexcel L17= a[4,1]

melogit obese walkability_new_10 sex age i.educ_new car_new SES smoke ethnic_new if age>=40 [pweight = wps_b2010] ||parish: ||ED:, nolog cformat(%9.2f) or
matrix a = r(table)
putexcel I18= a[1,1]
putexcel J18= a[5,1]
putexcel K18= a[6,1]
putexcel L18= a[4,1]



putexcel C5:E11, overwritefmt nformat(#.##) 
putexcel C13:E18, overwritefmt nformat(#.##) 
putexcel I5:K11, overwritefmt nformat(#.##) 
putexcel I13:K18, overwritefmt nformat(#.##) 

putexcel F5:F11, overwritefmt nformat(#.###) 
putexcel F13:F18, overwritefmt nformat(#.###) 
putexcel L5:L11, overwritefmt nformat(#.###) 
putexcel L13:L18, overwritefmt nformat(#.###) 





