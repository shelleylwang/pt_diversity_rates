# This script takes a directory of mcmc.log files and calculates the effective sample size (ESS) for 
# select columns in each file. It assesses the quality of the ESS values and prints the results.
# This is meant to help fill out the "Diagnostics" of the "analyses_log.xlsm" sheet

library(coda)
library(data.table)


# Define the function
analyze_ess_diagnostics <- function(working_dir, encoding = "UTF-8") {
  # Find all mcmc.log OR MBD.log files using full path
  mcmc_files <- list.files(path = working_dir, pattern = "(mcmc|MBD)\\.log$", full.names = FALSE)
  
  # Check if any matching files were found
  if (length(mcmc_files) == 0) {
    warning("No mcmc.log or MBD.log files found in ", working_dir)
    return(NULL)
  }
  
  cat("Found", length(mcmc_files), "log files in", working_dir, "\n")
  
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
  
  return(all_ess_tables)
}

