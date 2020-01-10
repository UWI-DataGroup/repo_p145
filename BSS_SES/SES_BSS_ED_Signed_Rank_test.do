
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
**	Date Modified: 	10/01/2020
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
*local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - PROJECT_p145/data_p145"
** Logfiles to unencrypted location
local logpath "X:/The University of the West Indies/DataGroup - repo_data/data_p145"

*-------------------------------------------------------------------------------

*Open log file to store results

log using "`logpath'/version01\3-output\BSS_SES\Sign_Rank_Results/pairwise_comparisons.log", name(Sign_Rank_Test) replace

*Open dataset from encrypted location

use "`datapath'/version01/2-working/BSS_SES/BSS_SES_003_vsm_large", clear



*Wilcoxon Signed Rank Test of rankings

*-------------------------------------------------------------------------------

*Within VSM small rank Model

foreach a in 	rank_s_pca rank_s_eigen_var rank_s_eigen_pro rank_s_i5per_var rank_s_i5per_pro ///
				rank_s_c80pe_var rank_s_c80pe_pro rank_s_c90pe_var rank_s_c90pe_pro ///
				rank_s_horn_var rank_s_horn_pro rank_vsm_small_cv_eigen_var ///
				rank_vsm_small_cv_eigen_pro rank_vsm_small_cv_i5per_var ///
				rank_vsm_small_cv_i5per_pro rank_vsm_small_cv_c80pe_var ///
				rank_vsm_small_cv_c80pe_pro rank_vsm_small_cv_c90pe_var ///
				rank_vsm_small_cv_c90pe_pro  ///
				rank_vsm_small_minBIC_eigen_var ///
				rank_vsm_small_minBIC_eigen_pro rank_vsm_small_minBIC_i5per_var ///
				rank_vsm_small_minBIC_i5per_pro rank_vsm_small_minBIC_c80pe_var ///
				rank_vsm_small_minBIC_c80pe_pro rank_vsm_small_minBIC_c90pe_var ///
				rank_vsm_small_minBIC_c90pe_pro  ///
				 rank_vsm_small_adapt_eigen_var ///
				rank_vsm_small_adapt_eigen_pro rank_vsm_small_adapt_i5per_var ///
				rank_vsm_small_adapt_i5per_pro rank_vsm_small_adapt_c80pe_var ///
				rank_vsm_small_adapt_c80pe_pro rank_vsm_small_adapt_c90pe_var ///
				rank_vsm_small_adapt_c90pe_pro  ///
				 {

	foreach b in rank_s_pca rank_s_eigen_var rank_s_eigen_pro rank_s_i5per_var rank_s_i5per_pro ///
				rank_s_c80pe_var rank_s_c80pe_pro rank_s_c90pe_var rank_s_c90pe_pro ///
				rank_s_horn_var rank_s_horn_pro rank_vsm_small_cv_eigen_var ///
				rank_vsm_small_cv_eigen_pro rank_vsm_small_cv_i5per_var ///
				rank_vsm_small_cv_i5per_pro rank_vsm_small_cv_c80pe_var ///
				rank_vsm_small_cv_c80pe_pro rank_vsm_small_cv_c90pe_var ///
				rank_vsm_small_cv_c90pe_pro ///
				rank_vsm_small_minBIC_eigen_var ///
				rank_vsm_small_minBIC_eigen_pro rank_vsm_small_minBIC_i5per_var ///
				rank_vsm_small_minBIC_i5per_pro rank_vsm_small_minBIC_c80pe_var ///
				rank_vsm_small_minBIC_c80pe_pro rank_vsm_small_minBIC_c90pe_var ///
				rank_vsm_small_minBIC_c90pe_pro  ///
				rank_vsm_small_adapt_eigen_var ///
				rank_vsm_small_adapt_eigen_pro rank_vsm_small_adapt_i5per_var ///
				rank_vsm_small_adapt_i5per_pro rank_vsm_small_adapt_c80pe_var ///
				rank_vsm_small_adapt_c80pe_pro rank_vsm_small_adapt_c90pe_var ///
				rank_vsm_small_adapt_c90pe_pro  ///
				 {
				
signrank `a' = `b'

}
}


*-------------------------------------------------------------------------------

*Within VSM medium rank Model

foreach c in 	rank_m_pca rank_m_eigen_var rank_m_eigen_pro rank_m_i5per_var rank_m_i5per_pro ///
				rank_m_c80pe_var rank_m_c80pe_pro rank_m_c90pe_var rank_m_c90pe_pro ///
				rank_m_horn_var rank_m_horn_pro rank_vsm_medium_cv_eigen_var ///
				rank_vsm_medium_cv_eigen_pro rank_vsm_medium_cv_i5per_var ///
				rank_vsm_medium_cv_i5per_pro rank_vsm_medium_cv_c80pe_var ///
				rank_vsm_medium_cv_c80pe_pro rank_vsm_medium_cv_c90pe_var ///
				rank_vsm_medium_cv_c90pe_pro rank_vsm_medium_cv_horn_var ///
				rank_vsm_medium_cv_horn_pro rank_vsm_medium_minBIC_eigen_var ///
				rank_vsm_medium_minBIC_eigen_pro rank_vsm_medium_minBIC_i5per_var ///
				rank_vsm_medium_minBIC_i5per_pro rank_vsm_medium_minBIC_c80pe_var ///
				rank_vsm_medium_minBIC_c80pe_pro rank_vsm_medium_minBIC_c90pe_var ///
				rank_vsm_medium_minBIC_c90pe_pro rank_vsm_medium_minBIC_horn_var ///
				rank_vsm_medium_minBIC_horn_pro rank_vsm_medium_adapt_eigen_var ///
				rank_vsm_medium_adapt_eigen_pro rank_vsm_medium_adapt_i5per_var ///
				rank_vsm_medium_adapt_i5per_pro rank_vsm_medium_adapt_c80pe_var ///
				rank_vsm_medium_adapt_c80pe_pro rank_vsm_medium_adapt_c90pe_var ///
				rank_vsm_medium_adapt_c90pe_pro rank_vsm_medium_adapt_horn_var ///
				rank_vsm_medium_adapt_horn_pro {

	foreach d in rank_m_pca rank_m_eigen_var rank_m_eigen_pro rank_m_i5per_var rank_m_i5per_pro ///
				rank_m_c80pe_var rank_m_c80pe_pro rank_m_c90pe_var rank_m_c90pe_pro ///
				rank_m_horn_var rank_m_horn_pro rank_vsm_medium_cv_eigen_var ///
				rank_vsm_medium_cv_eigen_pro rank_vsm_medium_cv_i5per_var ///
				rank_vsm_medium_cv_i5per_pro rank_vsm_medium_cv_c80pe_var ///
				rank_vsm_medium_cv_c80pe_pro rank_vsm_medium_cv_c90pe_var ///
				rank_vsm_medium_cv_c90pe_pro rank_vsm_medium_cv_horn_var ///
				rank_vsm_medium_cv_horn_pro rank_vsm_medium_minBIC_eigen_var ///
				rank_vsm_medium_minBIC_eigen_pro rank_vsm_medium_minBIC_i5per_var ///
				rank_vsm_medium_minBIC_i5per_pro rank_vsm_medium_minBIC_c80pe_var ///
				rank_vsm_medium_minBIC_c80pe_pro rank_vsm_medium_minBIC_c90pe_var ///
				rank_vsm_medium_minBIC_c90pe_pro rank_vsm_medium_minBIC_horn_var ///
				rank_vsm_medium_minBIC_horn_pro rank_vsm_medium_adapt_eigen_var ///
				rank_vsm_medium_adapt_eigen_pro rank_vsm_medium_adapt_i5per_var ///
				rank_vsm_medium_adapt_i5per_pro rank_vsm_medium_adapt_c80pe_var ///
				rank_vsm_medium_adapt_c80pe_pro rank_vsm_medium_adapt_c90pe_var ///
				rank_vsm_medium_adapt_c90pe_pro rank_vsm_medium_adapt_horn_var ///
				rank_vsm_medium_adapt_horn_pro {
				
signrank `c' = `d'

}
}


*-------------------------------------------------------------------------------

*Within VSM large rank Model

foreach e in 	rank_l_pca rank_l_eigen_var rank_l_eigen_pro rank_l_i5per_var rank_l_i5per_pro ///
				rank_l_c80pe_var rank_l_c80pe_pro rank_l_c90pe_var rank_l_c90pe_pro ///
				rank_l_horn_var rank_l_horn_pro rank_vsm_large_cv_eigen_var ///
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

	foreach f in rank_l_pca rank_l_eigen_var rank_l_eigen_pro rank_l_i5per_var rank_l_i5per_pro ///
				rank_l_c80pe_var rank_l_c80pe_pro rank_l_c90pe_var rank_l_c90pe_pro ///
				rank_l_horn_var rank_l_horn_pro rank_vsm_large_cv_eigen_var ///
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
				
signrank `e' = `f'

}
}

*-------------------------------------------------------------------------------