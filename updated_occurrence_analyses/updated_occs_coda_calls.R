setwd("C:/Users/SimoesLabAdmin/Documents/pt_diversity_rates")
#setwd('/Volumes/My Passport/pt_diversity_rates')
source("mcmc_logs_analyses_code/coda_final_2.R")
source("mcmc_logs_analyses_code/coda_ess_diagnostics.R")

analyze_ess_diagnostics("C:\\Users\\SimoesLabAdmin\\Downloads")
analyze_mcmc("C:\\Users\\SimoesLabAdmin\\Downloads\\model_9\\synapsida_offset")

