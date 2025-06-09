setwd("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli")
source("mcmc_logs_analyses_code/coda_final.R")
source("mcmc_logs_analyses_code/coda_ess_diagnostics.R")


############## MODEL 1
analyze_ess_diagnostics("updated_occurrence_analyses/model_1/reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/model_1/reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/model_1/synapsida")
# Check if R can see the directory
dir.exists("updated_occurrence_analyses/model_1/synapsida/")

# List files that R can see
list.files("updated_occurrence_analyses/model_1/synapsida/", full.names = TRUE)

# Check specifically for the pattern
list.files("updated_occurrence_analyses/model_1/synapsida/", 
           pattern = "(mcmc|MBD)\\.log$", full.names = TRUE)

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


############## MODEL 5
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_all")
# GIBBS
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all_gibbs")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_all_gibbs")
# 200 ITERATIONS
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all_200")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_all_200")




############## MODEL A
analyze_ess_diagnostics("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_A_reptilia_terr")
analyze_ess_diagnostics("updated_occurrence_analyses/models_using_occs_that_include_null_lats/model_A_synapsida")







