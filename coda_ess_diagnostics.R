# This script takes a directory of mcmc.log files and calculates the effective sample size (ESS) for 
# select columns in each file. It assesses the quality of the ESS values and prints the results.
# This is meant to help fill out the "Diagnostics" of the "analyses_log.xlsm" sheet

library(coda)
library(data.table)


# Define the function
analyze_ess_diagnostics <- function(working_dir, encoding = "UTF-8") {
  # Set working directory
  original_dir <- getwd()
  setwd(working_dir)
  
  # Find all mcmc.log files
  mcmc_files <- list.files(path = working_dir, pattern = "mcmc\\.log$", full.names = FALSE)
  
  # Check if any matching files were found
  if (length(mcmc_files) == 0) {
    warning("No mcmc.log files found in ", working_dir)
    setwd(original_dir)
    return(NULL)
  }
  
  cat("Found", length(mcmc_files), "mcmc.log files in", working_dir, "\n")
  
  # Store ESS tables for later output
  all_ess_tables <- list() 
  
  # Columns we're interested in - defined once outside the loop
  desired_columns <- c('posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')
  
  # Process each file
  for (file_name in mcmc_files) {
    cat("Processing:", file_name, "\n")
    
    # Full path to the file
    file_path <- file.path(working_dir, file_name)
    
    # Read header to get column names using data.table
    tryCatch({
      # Use fread to quickly check the header
      header <- data.table::fread(file_path, nrows = 1, sep = "\t", encoding = encoding)
      column_names <- names(header)
      
      # Find which of our desired columns actually exist in the file
      available_columns <- column_names[column_names %in% desired_columns]
      
      if (length(available_columns) == 0) {
        cat("No desired columns found in", file_name, ". Skipping this file. \n")
        next
      } 

      # Read only the columns we need using data.table's select parameter
      mcmc_data <- data.table::fread(
        file_path, 
        select = available_columns,
        sep = "\t",
        encoding = encoding
      )
      
      if (ncol(mcmc_data) == 0) {
        warning(paste("No columns could be read from", file_name))
        next
      }
      
      # Convert to mcmc object
      mcmc_object <- as.mcmc(as.matrix(mcmc_data))
      
      # Calculate effective sample size
      ess <- effectiveSize(mcmc_object)
      
      # Commented out: Print the ESS values in a table format
      # ess_table <- data.frame(Column = names(ess), ESS = ess)
      # print(ess_table)
      
      # Determine the quality of the ESS values
      if (any(ess < 100)) {
        quality <- "Poor"
      } else if (any(ess <= 200)) {
        quality <- "Fair"
      } else {
        quality <- "Good"
      }
      
      # Print the quality of the file
      cat("Quality:", quality, "\n\n")
      
      # Add to collection
      all_ess_tables[[file_name]] <- ess
      
    }, error = function(e) {
      cat("Error processing file:", file_name, "\n", e$message, "\n")
    })
  }
  
  # Reset working directory
  setwd(original_dir)
  
  return(all_ess_tables)
}


#################################################### CALLING IT

################ A_REPTILIA (mcmc_no_predictors) 
# A_rjmcmc_sampled_every_10k
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_10k")
# A_rjmcmc_sampled_every_20k
# Has ANSI encoding
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_20k", encoding = "Latin-1")
# A_bdmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdmcmc")
# A_bdnn
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn")
# A_bdnn_update
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn_update")
# A_mcmc_200_Iterations
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_mcmc_200_Iterations")

################### A_SYNAPSIDA (mcmc_no_predictors)
# A_rjmcmc_sampled_every_20k
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_rjmcmc_sampled_every_20k")
# A_bdmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdmcmc")
# A_bdnn
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn")
# A_bdnn_update
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn_update")
# A_mcmc_200_Iterations
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_mcmc_200_Iterations")

################### A_TEMNOSPONDYLI (mcmc_no_predictors)
# A_rjmcmc_sampled_every_20k
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_rjmcmc_sampled_every_20k")
# A_bdmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdmcmc")
# A_bdnn
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn")
# A_bdnn_update
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn_update")
# A_mcmc_200_Iterations
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_mcmc_200_Iterations")
# ADE
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/ADE")



######################### B Section (mcmc_predictors) #####################

################### B_REPTILIA (mcmc_predictors)
# B_bdnn_stdscaled_only_4_2_update
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only_4_2_update")
# B_bdnn_stdscaled_cbrt
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_cbrt")
# B_bdnn_stdscaled_log
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_log")
# B_bdnn_stdscaled_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_boxcox")
# B_bdnn_stdscaled_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only")
# B_bdnn_stdscaled_only_8_4_nodes
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only_8_4_nodes")
# B_covar_mcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc")
# B_bdnn_lats_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_lats_only")
# B_covar_rjmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_rjmcmc")
# B_covar_mcmc/MBD_env_vars_gamma_exponential
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential")
# B_covar_mcmc/MBD_env_vars_gamma_linear
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear")
# B_covar_mcmc/MBD_1myr_temp_gamma_exponential
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential")
# B_covar_mcmc/MBD_1myr_temp_gamma_linear
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear")



################### B_SYNAPSIDA (mcmc_predictors)
# B_bdnn_stdscaled_cbrt
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_cbrt")
# B_bdnn_stdscaled_log
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_log")
# B_bdnn_stdscaled_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_boxcox")
# B_bdnn_stdscaled_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_only")
# B_covar_mcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc")
# B_bdnn_lats_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_lats_only")
# B_covar_rjmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_rjmcmc")
# B_covar_mcmc/MBD_env_vars_gamma_exponential
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential")
# B_covar_mcmc/MBD_env_vars_gamma_linear
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear")
# B_covar_mcmc/MBD_1myr_temp_gamma_exponential
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential")
# B_covar_mcmc/MBD_1myr_temp_gamma_linear
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear")

################### B_TEMNOSPONDYLI (mcmc_predictors)
# B_bdnn_stdscaled_cbrt
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/B_bdnn_stdscaled_cbrt_concatenated_logs")
# B_bdnn_stdscaled_log
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_log/B_bdnn_stdscaled_log_concatenated_logs")
# B_bdnn_stdscaled_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_boxcox/B_bdnn_stdscaled_boxcox_concatenated_logs")
# B_bdnn_stdscaled_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_only/B_bdnn_stdscaled_only_concatenated_logs")
# B_covar_mcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc")
# B_bdnn_lats_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_lats_only")
# B_covar_rjmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_rjmcmc")
# B_covar_mcmc/MBD_env_vars_gamma_exponential
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential")
# B_covar_mcmc/MBD_env_vars_gamma_linear
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear")
# B_covar_mcmc/MBD_1myr_temp_gamma_exponential
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential")
# B_covar_mcmc/MBD_1myr_temp_gamma_linear
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear")

######################### C Section (mcmc_fixshift_predictors) #####################

################### C_REPTILIA (mcmc_fixshift_predictors)
# C_bdnn_lats_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_lats_only")
# C_bdnn_minmax_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox")
# C_bdnn_minmax_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_minmax_only")
# C_bdnn_stdscaled_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox")
# C_bdnn_stdscaled_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_only")
# C_covar
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar")

################### C_SYNAPSIDA (mcmc_fixshift_predictors)
# C_bdnn_lats_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_lats_only")
# C_bdnn_minmax_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox")
# C_bdnn_minmax_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_minmax_only")
# C_bdnn_stdscaled_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox")
# C_bdnn_stdscaled_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_stdscaled_only")
# C_covar
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar")
# C_covar_test
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar_test")

################### C_TEMSNOSPONDYLI (mcmc_fixshift_predictors)
# C_bdnn_lats_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_lats_only")
# C_bdnn_minmax_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox")
# C_bdnn_minmax_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_minmax_only")
# C_bdnn_stdscaled_boxcox
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox")
# C_bdnn_stdscaled_only
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_stdscaled_only")
# C_covar
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar")


######################### D Section (mcmc_fixshift_no_predictors) #####################

################### D_REPTILIA (mcmc_fixshift_no_predictors)
# D_bdmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdmcmc")
# D_bdnn
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn")
# D_bdnn_update
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn_update")
# D_mcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_mcmc")


################### D_SYNAPSIDA (mcmc_fixshift_no_predictors)
# D_bdmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdmcmc")
# D_bdnn
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdnn")
# D_bdnn_update
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdnn_update")
# D_mcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_mcmc")


################### D_TEMSNOSPONDYLI (mcmc_fixshift_no_predictors)
# D_bdmcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdmcmc")
# D_bdnn
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdnn")
# D_bdnn_update
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdnn_update")
# D_mcmc
analyze_ess_diagnostics("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_mcmc")
