#setwd("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli")
setwd('/Volumes/My Passport/pt_diversity_rates')
source("mcmc_logs_analyses_code/coda_final_2.R")
source("mcmc_logs_analyses_code/coda_ess_diagnostics.R")


############## MODEL 1
analyze_ess_diagnostics("updated_occurrence_analyses/model_1/reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/model_1/reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/model_1/synapsida")
analyze_mcmc("updated_occurrence_analyses/model_1/synapsida")

############## MODEL 2
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/synapsida")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/synapsida")
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all")
# GIBBS
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/synapsida_gibbs")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/synapsida_gibbs")
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_terr_gibbs")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_terr_gibbs")
# 200 ITERATIONS
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/synapsida_200")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/synapsida_200")
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_terr_200")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_terr_200")


############## MODEL 3
analyze_ess_diagnostics("updated_occurrence_analyses/model_3/reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/model_3/reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/model_3/synapsida")
analyze_mcmc("updated_occurrence_analyses/model_3/synapsida")


############## MODEL 4
analyze_ess_diagnostics("updated_occurrence_analyses/model_4/reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/model_4/reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/model_4/synapsida")
analyze_mcmc("updated_occurrence_analyses/model_4/synapsida")


############## MODEL 5
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_all")
# GIBBS
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all_gibbs")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_all_gibbs")
# 200 ITERATIONS
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all_200")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_all_200")


############## MODEL 6
analyze_ess_diagnostics("updated_occurrence_analyses/model_6/reptilia_all")
analyze_mcmc("updated_occurrence_analyses/model_6/reptilia_all")
analyze_ess_diagnostics('updated_occurrence_analyses/gl_models/model_6/synapsida')
analyze_mcmc("updated_occurrence_analyses/model_6/synapsida")

############## MODEL 7
analyze_ess_diagnostics("updated_occurrence_analyses/model_7/reptilia_all")
analyze_mcmc("updated_occurrence_analyses/model_7/reptilia_all")
analyze_ess_diagnostics("updated_occurrence_analyses/model_7/synapsida")
analyze_mcmc("updated_occurrence_analyses/model_7/synapsida")

################################################################################
############## MODELS USING OCCS THAT INCLUDED NULL LATS #######################
############## MODEL A
analyze_ess_diagnostics("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_A_reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_A_reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_A_synapsida")
analyze_mcmc("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_A_synapsida")



############## MODEL 2
analyze_ess_diagnostics("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_2_reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_2_reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_2_synapsida")
analyze_mcmc("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_2_synapsida")
analyze_ess_diagnostics("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_5_reptilia_all")
analyze_mcmc("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_5_reptilia_all")



