setwd("C:/Users/SimoesLabAdmin/Documents/pt_diversity_rates")
#setwd('/Volumes/My Passport/pt_diversity_rates')
source("mcmc_logs_analyses_code/coda_final_2.R")
source("mcmc_logs_analyses_code/coda_ess_diagnostics.R")

analyze_ess_diagnostics("C:\\Users\\SimoesLabAdmin\\Documents\\pt_diversity_rates\\updated_occurrence_analyses\\model_9\\reptilia_terr_offset")
analyze_mcmc("C:\\Users\\SimoesLabAdmin\\Documents\\pt_diversity_rates\\updated_occurrence_analyses\\model_9\\reptilia_terr_offset")

