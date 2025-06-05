setwd("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli")
source("mcmc_logs_analyses_code/coda_final.R")
source("mcmc_logs_analyses_code/coda_ess_diagnostics.R")


############## MODEL 1
analyze_ess_diagnostics("updated_occurrence_analyses/model_1/reptilia_all")
analyze_mcmc("updated_occurrence_analyses/model_1/reptilia_all")

analyze_ess_diagnostics("updated_occurrence_analyses/model_1/reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/model_1/reptilia_terr")

analyze_ess_diagnostics("updated_occurrence_analyses/model_1/synapsida")
analyze_mcmc("updated_occurrence_analyses/model_1/synapsida")



############## MODEL 2
analyze_ess_diagnostics("updated_occurrence_analyses/model_2/reptilia_terr")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_terr")

analyze_ess_diagnostics("updated_occurrence_analyses/model_2/synapsida")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/synapsida")



############## MODEL 5
analyze_ess_diagnostics("updated_occurrence_analyses/model_2_and_5/reptilia_all")
analyze_mcmc("updated_occurrence_analyses/model_2_and_5/reptilia_all")



