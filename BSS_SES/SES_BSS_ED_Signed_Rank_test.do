
clear
capture log close
cls

//Note: This algorithm can only be run after SES_BSS_ED_002

**  GENERAL DO-FILE COMMENTS
**  Program:		SES_BSS_ED_003.do
**  Project:      	Macroscale Walkability- PhD
**	Sub-Project:	SES Index Computation
**  Analyst:		Kern Rocke
**	Date Created:	24/10/2019
**	Date Modified: 	23/12/2019
**  Algorithm Task: Wilcoxon Signed Rank Test Analysis


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
local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p145

*-------------------------------------------------------------------------------

*LARGE VARIABLE SELECTION MODEL

use "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_large", clear

/*
rank__pca rank__eigen_var rank__eigen_pro rank__i5per_var rank__i5per_pro rank__c80pe_var rank__c80pe_pro rank__c90pe_var rank__c90pe_pro rank__horn_var rank__horn_pro rank_vsm_large_cv_eigen_var rank_vsm_large_cv_eigen_pro rank_vsm_large_cv_i5per_var rank_vsm_large_cv_i5per_pro rank_vsm_large_cv_c80pe_var rank_vsm_large_cv_c80pe_pro rank_vsm_large_cv_c90pe_var rank_vsm_large_cv_c90pe_pro rank_vsm_large_cv_horn_var rank_vsm_large_cv_horn_pro rank_vsm_large_minBIC_eigen_var rank_vsm_large_minBIC_eigen_pro rank_vsm_large_minBIC_i5per_var rank_vsm_large_minBIC_i5per_pro rank_vsm_large_minBIC_c80pe_var rank_vsm_large_minBIC_c80pe_pro rank_vsm_large_minBIC_c90pe_var rank_vsm_large_minBIC_c90pe_pro rank_vsm_large_minBIC_horn_var rank_vsm_large_minBIC_horn_pro rank_vsm_large_adapt_eigen_var rank_vsm_large_adapt_eigen_pro rank_vsm_large_adapt_i5per_var rank_vsm_large_adapt_i5per_pro rank_vsm_large_adapt_c80pe_var rank_vsm_large_adapt_c80pe_pro rank_vsm_large_adapt_c90pe_var rank_vsm_large_adapt_c90pe_pro rank_vsm_large_adapt_horn_var rank_vsm_large_adapt_horn_pro
*/


*Wilcoxon Signed Rank Test of rankings

*-------------------------------------------------------------------------------

*Within VSM large rank Model

foreach x in 	rank__pca rank__eigen_var rank__eigen_pro rank__i5per_var rank__i5per_pro ///
				rank__c80pe_var rank__c80pe_pro rank__c90pe_var rank__c90pe_pro ///
				rank__horn_var rank__horn_pro rank_vsm_large_cv_eigen_var ///
				rank_vsm_large_cv_eigen_pro rank_vsm_large_cv_i5per_var ///
				rank_vsm_large_cv_i5per_pro rank_vsm_large_cv_c80pe_var ///
				rank_vsm_large_cv_c80pe_pro rank_vsm_large_cv_c90pe_var ///
				rank_vsm_large_cv_c90pe_pro rank_vsm_large_cv_horn_var ///
				rank_vsm_large_cv_horn_pro rank_vsm_large_minBIC_eigen_var ///
				rank_vsm_large_minBIC_eigen_pro rank_vsm_large_minBIC_i5per_var ///
				rank_vsm_large_minBIC_i5per_pro rank_vsm_large_minBIC_c80pe_var ///
				rank_vsm_large_minBIC_c80pe_pro rank_vsm_large_minBIC_c90pe_var ///
				rank_vsm_large_minBIC_c90pe_pro rank_vsm_large_minBIC_horn_var ///
				rank_vsm_large_minBIC_horn_pro rank_vsm_large_adapt_eigen_var ///
				rank_vsm_large_adapt_eigen_pro rank_vsm_large_adapt_i5per_var ///
				rank_vsm_large_adapt_i5per_pro rank_vsm_large_adapt_c80pe_var ///
				rank_vsm_large_adapt_c80pe_pro rank_vsm_large_adapt_c90pe_var ///
				rank_vsm_large_adapt_c90pe_pro rank_vsm_large_adapt_horn_var ///
				rank_vsm_large_adapt_horn_pro {

	foreach y in rank__pca rank__eigen_var rank__eigen_pro rank__i5per_var rank__i5per_pro ///
				rank__c80pe_var rank__c80pe_pro rank__c90pe_var rank__c90pe_pro ///
				rank__horn_var rank__horn_pro rank_vsm_large_cv_eigen_var ///
				rank_vsm_large_cv_eigen_pro rank_vsm_large_cv_i5per_var ///
				rank_vsm_large_cv_i5per_pro rank_vsm_large_cv_c80pe_var ///
				rank_vsm_large_cv_c80pe_pro rank_vsm_large_cv_c90pe_var ///
				rank_vsm_large_cv_c90pe_pro rank_vsm_large_cv_horn_var ///
				rank_vsm_large_cv_horn_pro rank_vsm_large_minBIC_eigen_var ///
				rank_vsm_large_minBIC_eigen_pro rank_vsm_large_minBIC_i5per_var ///
				rank_vsm_large_minBIC_i5per_pro rank_vsm_large_minBIC_c80pe_var ///
				rank_vsm_large_minBIC_c80pe_pro rank_vsm_large_minBIC_c90pe_var ///
				rank_vsm_large_minBIC_c90pe_pro rank_vsm_large_minBIC_horn_var ///
				rank_vsm_large_minBIC_horn_pro rank_vsm_large_adapt_eigen_var ///
				rank_vsm_large_adapt_eigen_pro rank_vsm_large_adapt_i5per_var ///
				rank_vsm_large_adapt_i5per_pro rank_vsm_large_adapt_c80pe_var ///
				rank_vsm_large_adapt_c80pe_pro rank_vsm_large_adapt_c90pe_var ///
				rank_vsm_large_adapt_c90pe_pro rank_vsm_large_adapt_horn_var ///
				rank_vsm_large_adapt_horn_pro {
				
signrank `x' = `y'

}
}

*-------------------------------------------------------------------------------