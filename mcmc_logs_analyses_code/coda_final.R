# Comprehensive MCMC Analysis with coda
# This script demonstrates how to use the coda package to analyze MCMC output
# And outputs trace + density plots as a pdf, and ess values as a pdf

############################################################################
library(coda)      # For MCMC diagnostics
library(ggplot2)   # For plotting
library(gridExtra) # For arranging plots
library(grid)      # For grid graphics
library(data.table) # For faster data reading and manipulation

analyze_mcmc <- function(working_dir, file_pattern = "(mcmc|MBD)\\.log$", encoding = "UTF-8") {
  # Set working directory
  original_dir <- getwd()
  setwd(working_dir)
  
  # Find all files matching the provided pattern
  mcmc_files <- list.files(pattern = file_pattern, full.names = FALSE)
  
  # Check if any matching files were found
  if (length(mcmc_files) == 0) {
    warning("No files matching pattern '", file_pattern, "' found in ", working_dir)
    setwd(original_dir)
    return(NULL)
  }
  
  cat("Found", length(mcmc_files), "log files in", working_dir, "\n")
  
  # Initialize output files
  pdf_diagnostics_file <- file.path(working_dir, "combined_mcmc_diagnostics_plots.pdf")
  pdf_ess_file <- file.path(working_dir, "combined_mcmc_ess.pdf")
  
  # Open the PDF device for diagnostic plots
  pdf(pdf_diagnostics_file, width = 12, height = 8)
  
  # Store ESS tables for later output
  all_ess_tables <- list() 
  
  # Columns we're interested in - defined once outside the loop
  desired_columns <- c('it', 'posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')
  
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
      
      cat("Found columns in", file_name, ":", paste(available_columns, collapse=", "), "\n")
      
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
      
      # Extract info from 'it' column and then remove it
      it_col <- as.numeric(tail(mcmc_data$it, 2))  # Just the last two values
      mcmc_data[, it := NULL]  # Remove 'it' column
      
      # Convert to mcmc object
      mcmc_object <- as.mcmc(as.matrix(mcmc_data))
      
      # Calculate effective sample size
      ess <- effectiveSize(mcmc_object)
      
      # Create ESS table
      ess_df <- t(round(ess))
      colnames(ess_df) <- names(ess)
      row.names(ess_df) <- "ESS"
      
      # Add to collection
      all_ess_tables[[file_name]] <- list(
        title = paste("ESS for", file_name),
        iterations = it_col[2],
        sampling_rate = it_col[2] - it_col[1],
        data = as.data.frame(ess_df),
        low_ess = ess < 200
      )
      
      # Add title page for this file's plots
      grid.newpage()
      grid.text(paste("MCMC Diagnostics for", file_name), gp = gpar(fontsize = 20))
      
      # Prepare plot generation
      param_names <- colnames(mcmc_object)
      params_per_page <- 3
      num_pages <- ceiling(length(param_names) / params_per_page)
      
      # Pre-calculate data frames for each parameter to avoid redundant operations
      plot_data <- list()
      for (i in seq_along(param_names)) {
        plot_data[[i]] <- data.frame(
          Iteration = as.vector(time(mcmc_object)),
          Value = as.vector(mcmc_object[, i])
        )
      }
      
      # Format parameter names once
      nice_names <- lapply(param_names, function(name) {
        nice <- gsub("_", " ", name)
        paste0(toupper(substr(nice, 1, 1)), substr(nice, 2, nchar(nice)))
      })
      
      # Create diagnostic plots page by page
      for (page in 1:num_pages) {
        # Determine parameters for this page
        start_idx <- (page - 1) * params_per_page + 1
        end_idx <- min(page * params_per_page, length(param_names))
        
        plot_list <- list()
        plot_idx <- 1
        
        for (i in start_idx:end_idx) {
          df <- plot_data[[i]]
          nice_title <- nice_names[[i]]
          
          # Trace plot
          p1 <- ggplot(df, aes(x = Iteration, y = Value)) +
            geom_line() +
            ggtitle(paste(nice_title, "Trace")) +
            theme_minimal() +
            theme(plot.title = element_text(size = 10),
                  axis.title = element_text(size = 8),
                  axis.text = element_text(size = 7))
          
          # Density plot
          p2 <- ggplot(df, aes(x = Value)) +
            geom_density(fill = "lightblue", alpha = 0.7) +
            ggtitle(paste(nice_title, "Density")) +
            theme_minimal() +
            theme(plot.title = element_text(size = 10),
                  axis.title = element_text(size = 8),
                  axis.text = element_text(size = 7))
          
          plot_list[[plot_idx]] <- p1
          plot_list[[plot_idx + 1]] <- p2
          plot_idx <- plot_idx + 2
        }
        
        # Fill empty plot slots if needed
        while (length(plot_list) < 6) {
          plot_list[[length(plot_list) + 1]] <- ggplot() + theme_void()
        }
        
        # Arrange plots in a grid
        grid.arrange(grobs = plot_list, ncol = 2, nrow = 3)
      }
      
    }, error = function(e) {
      warning(paste("Error processing file:", file_name, "-", e$message))
      next
    })
    
    cat("Completed processing file:", file_name, "\n\n")
  }
  
  # Close diagnostic plots PDF
  dev.off()
  
  # Create ESS summary PDF if we have any data
  if (length(all_ess_tables) > 0) {
    pdf(pdf_ess_file, width = 8.5, height = 11)
    
    # Set the number of tables per page to 10 as requested
    tables_per_page <- 10
    num_pages <- ceiling(length(all_ess_tables) / tables_per_page)
    
    # Process each page
    for (page in 1:num_pages) {
      # Create a new page
      grid.newpage()
      
      # Add page title (moved down slightly)
      grid.text("MCMC Effective Sample Size (ESS) Summary", 
                x = 0.5, y = 0.94, 
                gp = gpar(fontface = "bold", fontsize = 14))
      
      # Determine which tables go on this page
      start_idx <- (page - 1) * tables_per_page + 1
      end_idx <- min(page * tables_per_page, length(all_ess_tables))
      page_tables <- all_ess_tables[start_idx:end_idx]
      
      # Calculate height for each table section with additional spacing between groups
      # Always calculate height as if there were 10 tables per page for consistent spacing
      section_height <- 0.85 / tables_per_page  # tables_per_page is already set to 10
      
      # Draw each table for this page
      for (i in seq_along(page_tables)) {
        table_info <- page_tables[[i]]
        table_idx <- start_idx + i - 1
        
        # Set up colors for low ESS values
        col_colors <- rep("black", length(table_info$low_ess))
        col_colors[table_info$low_ess] <- "red"
        
        # Calculate vertical position for this table with more spacing between groups
        y_position <- 0.91 - (i - 0.5) * section_height 
        
        # Create viewport for this table section
        pushViewport(viewport(x = 0.5, y = y_position, width = 0.95, height = section_height * 0.9))
        
        # Draw title
        grid.text(table_info$title, x = 0.5, y = 0.95, 
                  gp = gpar(fontface = "bold", fontsize = 9))
        
        # Draw subtitle
        grid.text(paste("Iterations:", table_info$iterations, 
                        "Sampling Rate:", table_info$sampling_rate), 
                  x = 0.5, y = 0.75, 
                  gp = gpar(fontface = "italic", fontsize = 8))
        
        # Create and draw table
        tbl <- tableGrob(
          table_info$data,
          rows = NULL,
          theme = ttheme_minimal(
            core = list(
              fg_params = list(col = col_colors, fontsize = 9)
            ),
            colhead = list(
              fg_params = list(col = col_colors, fontface = "bold", fontsize = 9),
              bg_params = list(fill = "lightgray")
            ),
            rowhead = list(
              fg_params = list(fontface = "bold", fontsize = 9)
            )
          )
        )
        
        # Create the vplayout to position the table
        pushViewport(viewport(y = 0.37, height = 0.5))
        
        # Draw the table
        grid.draw(tbl)
        
        popViewport(2) # Pop table and positioning viewports
      }
    }
    
    dev.off()
  }
  
  setwd(original_dir)
  
  cat("Analysis complete.\n")
  cat("Output files:\n")
  cat("1. Diagnostic plots:", pdf_diagnostics_file, "\n")
  cat("2. ESS tables:", pdf_ess_file, "\n")
  
  # Return invisibly
  invisible(all_ess_tables)
}

# Helper function to detect encoding of a file
detect_encoding <- function(file_path) {
  # Try to read file with different encodings
  encodings <- c("UTF-8", "Latin-1", "ASCII", "ANSI")
  
  for (enc in encodings) {
    tryCatch({
      con <- file(file_path, "rt", encoding = enc)
      first_line <- readLines(con, n = 1)
      close(con)
      return(enc)
    }, error = function(e) {
      # Try next encoding
    }, warning = function(w) {
      # Try next encoding
    })
  }
  
  # Default to UTF-8 if no encoding works
  return("UTF-8")
}

# Function that automatically detects encoding
analyze_mcmc_auto <- function(working_dir, file_pattern = "(mcmc|MBD)\\.log$") {
  # Find first matching file for encoding detection
  mcmc_files <- list.files(path = working_dir, pattern = file_pattern, full.names = TRUE)
  
  if (length(mcmc_files) > 0) {
    # Detect encoding from first file
    encoding <- detect_encoding(mcmc_files[1])
    cat("Detected encoding:", encoding, "\n")
  } else {
    encoding <- "UTF-8"  # Default
  }
  
  # Run the analysis with detected encoding
  analyze_mcmc(working_dir, file_pattern = file_pattern, encoding = encoding)
}

# Example usage:
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_10k")
# With custom file pattern:
# analyze_mcmc("C:/path/to/files", file_pattern = "custom_mcmc.*\\.log$")
# Or with automatic encoding detection:
# analyze_mcmc_auto("C:/path/to/files")
# With custom file pattern and auto encoding:
# analyze_mcmc_auto("C:/path/to/files", file_pattern = "custom_mcmc.*\\.log$")

# ######################### RUNNING FUNCTION ####################################
# 
# ######################### RUNS FROM TORSTEN ###################################
# analyze_mcmc("C:/Users/SimoesLabAdmin/Downloads/SE_stripped",file_pattern = ".*\\.log$")
# 
# 
# ######################### A Section (mcmc_no_predictors) #####################
# 
# ################ A_REPTILIA (mcmc_no_predictors) 
# # A_rjmcmc_sampled_every_10k
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_10k")
# # A_rjmcmc_sampled_every_20k
# # Has ANSI encoding
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_20k", encoding = "Latin-1")
# # A_bdmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdmcmc")
# # A_bdnn
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn")
# # A_bdnn_update
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn_update")
# # A_mcmc_200_Iterations
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_mcmc_200_Iterations")
# 
# ################### A_SYNAPSIDA (mcmc_no_predictors)
# # A_rjmcmc_sampled_every_20k
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_rjmcmc_sampled_every_20k")
# # A_bdmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdmcmc")
# # A_bdnn
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn")
# # A_bdnn_update
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn_update")
# # A_mcmc_200_Iterations
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_mcmc_200_Iterations")
# 
# ################### A_TEMNOSPONDYLI (mcmc_no_predictors)
# # A_rjmcmc_sampled_every_20k
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_rjmcmc_sampled_every_20k")
# # A_bdmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdmcmc")
# # A_bdnn
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn")
# # A_bdnn_update
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn_update")
# # A_mcmc_200_Iterations
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_mcmc_200_Iterations")
# # ADE
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/ADE")
# 
# 
# 
# ######################### B Section (mcmc_predictors) #####################
# 
# ################### B_REPTILIA (mcmc_predictors)
# # B_bdnn_stdscaled_only_4_2_update
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only_4_2_update")
# # B_bdnn_stdscaled_cbrt
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_cbrt")
# # B_bdnn_stdscaled_log
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_log")
# # B_bdnn_stdscaled_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_boxcox")
# # B_bdnn_stdscaled_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only")
# # B_bdnn_stdscaled_only_8_4_nodes
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only_8_4_nodes")
# # B_covar_mcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc")
# # B_bdnn_lats_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_lats_only")
# # B_covar_rjmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_rjmcmc")
# # # B_covar_mcmc/MBD_env_vars_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential")
# # # B_covar_mcmc/MBD_env_vars_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear")
# # # B_covar_mcmc/MBD_1myr_temp_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential")
# # # B_covar_mcmc/MBD_1myr_temp_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear")
# 
# # B_covar_mcmc/B_covar_MBD_env_vars
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/B_covar_MBD_env_vars")
# # B_covar_mcmc/B_covar_MBD_1myr_temp
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/B_covar_MBD_1myr_temp")
# 
# 
# ################### B_SYNAPSIDA (mcmc_predictors)
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/pyrate_mcmc_logs/TEST_B_bdnn_stdscaled_only_continuous_4_2_update_tt")
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/pyrate_mcmc_logs/TEST_B_bdnn_stdscaled_only")
# 
# # B_bdnn_stdscaled_cbrt
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_cbrt")
# # B_bdnn_stdscaled_log
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_log")
# # B_bdnn_stdscaled_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_boxcox")
# # B_bdnn_stdscaled_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_only")
# # B_covar_mcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc")
# # B_bdnn_lats_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_lats_only")
# # B_covar_rjmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_rjmcmc")
# # # B_covar_mcmc/MBD_env_vars_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential")
# # # B_covar_mcmc/MBD_env_vars_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear")
# # # B_covar_mcmc/MBD_1myr_temp_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential")
# # # B_covar_mcmc/MBD_1myr_temp_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear")
# 
# # B_covar_mcmc/B_covar_MBD_env_vars
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/B_covar_MBD_env_vars")
# # B_covar_mcmc/B_covar_MBD_1myr_temp
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/B_covar_MBD_1myr_temp")
# 
# ################### B_TEMNOSPONDYLI (mcmc_predictors)
# # B_bdnn_stdscaled_cbrt
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/B_bdnn_stdscaled_cbrt_concatenated_logs")
# # B_bdnn_stdscaled_log
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_log/B_bdnn_stdscaled_log_concatenated_logs")
# # B_bdnn_stdscaled_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_boxcox/B_bdnn_stdscaled_boxcox_concatenated_logs")
# # B_bdnn_stdscaled_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_only")
# # B_covar_mcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc")
# # B_bdnn_lats_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_lats_only")
# # B_covar_rjmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_rjmcmc")
# # # B_covar_mcmc/MBD_env_vars_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential")
# # # B_covar_mcmc/MBD_env_vars_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear")
# # # B_covar_mcmc/MBD_1myr_temp_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential")
# # # B_covar_mcmc/MBD_1myr_temp_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear")
# 
# # B_covar_mcmc/B_covar_MBD_env_vars
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/B_covar_MBD_env_vars")
# # B_covar_mcmc/B_covar_MBD_1myr_temp
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/B_covar_MBD_1myr_temp")
# 
# 
# ######################### C Section (mcmc_fixshift_predictors) #####################
# 
# ################### C_REPTILIA (mcmc_fixshift_predictors)
# # C_bdnn_lats_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_lats_only")
# # C_bdnn_minmax_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox")
# # C_bdnn_minmax_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_minmax_only")
# # C_bdnn_stdscaled_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox")
# # C_bdnn_stdscaled_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_only")
# # C_covar
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar")
# # # C_covar/MBD_env_vars_horseshoe_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_env_vars_horseshoe_exponential")
# # # C_covar/MBD_env_vars_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_exponential")
# # # C_covar/MBD_env_vars_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_linear")
# # # C_covar/MBD_1myr_temp_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_exponential")
# # # C_covar/MBD_1myr_temp_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_linear")
# 
# # C_covar/C_covar_MBD_env_vars
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/C_covar_MBD_env_vars")
# # C_covar/C_covar_MBD_1myr_temp
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/C_covar_MBD_1myr_temp")
# 
# ################### C_SYNAPSIDA (mcmc_fixshift_predictors)
# # C_bdnn_lats_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_lats_only")
# # C_bdnn_minmax_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox")
# # C_bdnn_minmax_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_minmax_only")
# # C_bdnn_stdscaled_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox")
# # C_bdnn_stdscaled_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_stdscaled_only")
# # C_covar
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar")
# # # C_covar_horseshoe_exp_env_vars
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/C_covar_MBD_horseshoe_exp_env_vars")
# # # C_covar_horseshoe_exp_1myr_temp
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/C_covar_MBD_horseshoe_exp_1myr_temp")
# 
# # C_covar/C_covar_MBD_env_vars
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/C_covar_MBD_env_vars")
# # C_covar/C_covar_MBD_1myr_temp
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/C_covar_MBD_1myr_temp")
# 
# ###### Later call
# # # C_covar/MBD_env_vars_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_exponential")
# # # C_covar/MBD_env_vars_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_linear")
# # # C_covar/MBD_1myr_temp_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_exponential")
# # # C_covar/MBD_1myr_temp_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_linear")
# # ######
# # 
# # # C_covar_test
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar_test")
# # # C_covar/MBD_env_vars_horseshoe_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_horseshoe_exponential")
# # # C_covar/MBD_env_vars_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_exponential")
# # # C_covar/MBD_env_vars_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_linear")
# # # C_covar/MBD_1myr_temp_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_exponential")
# # # C_covar/MBD_1myr_temp_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_linear")
# 
# ################### C_TEMSNOSPONDYLI (mcmc_fixshift_predictors)
# # C_bdnn_lats_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_lats_only")
# # C_bdnn_minmax_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox")
# # C_bdnn_minmax_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_minmax_only")
# # C_bdnn_stdscaled_boxcox
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox")
# # C_bdnn_stdscaled_only
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_stdscaled_only")
# # C_covar
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar")
# # # C_covar/MBD_env_vars_horseshoe_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_env_vars_horseshoe_exponential")
# # # C_covar_horseshoe_exp_env_vars
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/C_covar_MBD_horseshoe_exp_env_vars")
# # # C_covar_horseshoe_exp_1myr_temp
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/C_covar_MBD_horseshoe_exp_1myr_temp")
# 
# # # C_covar/MBD_env_vars_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_exponential")
# # # C_covar/MBD_env_vars_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_linear")
# # # C_covar/MBD_1myr_temp_gamma_exponential
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_exponential")
# # # C_covar/MBD_1myr_temp_gamma_linear
# # analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_linear")
# 
# # C_covar/C_covar_MBD_env_vars
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/C_covar_MBD_env_vars")
# # C_covar/C_covar_MBD_1myr_temp
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/C_covar_MBD_1myr_temp")
# 
# ######################### D Section (mcmc_fixshift_no_predictors) #####################
# 
# ################### D_REPTILIA (mcmc_fixshift_no_predictors)
# # D_bdmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdmcmc")
# # D_bdnn
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn")
# # D_bdnn_update
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn_update")
# # D_mcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_mcmc")
# 
# 
# ################### D_SYNAPSIDA (mcmc_fixshift_no_predictors)
# # D_bdmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdmcmc")
# # D_bdnn
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdnn")
# # D_bdnn_update
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdnn_update")
# # D_mcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_mcmc")
# 
# 
# ################### D_TEMSNOSPONDYLI (mcmc_fixshift_no_predictors)
# # D_bdmcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdmcmc")
# # D_bdnn
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdnn")
# # D_bdnn_update
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdnn_update")
# # D_mcmc
# analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_mcmc")


######################### VERSION THAT DOES ENCODING CHECKING ON MCMC FILES 
# (Takes longer/much slower)

# library(coda)      # For MCMC diagnostics
# library(ggplot2)   # For plotting
# library(gridExtra) # For arranging plots
# library(grid)      # For grid graphics
# 
# analyze_mcmc <- function(working_dir) {
#   # Set working directory
#   original_dir <- getwd()
#   setwd(working_dir)
#   
#   # Find all mcmc.log files
#   mcmc_files <- list.files(path = working_dir, pattern = "mcmc\\.log$", full.names = FALSE)
#   
#   # Check if any matching files were found
#   if (length(mcmc_files) == 0) {
#     warning("No mcmc.log files found in", working_dir)
#     setwd(original_dir)
#     return(NULL)
#   }
#   
#   cat("Found", length(mcmc_files), "mcmc.log files in", working_dir, "\n")
#   
#   # Initialize output files
#   pdf_diagnostics_file <- file.path(working_dir, "combined_mcmc_diagnostics_plots.pdf")
#   pdf_ess_file <- file.path(working_dir, "combined_mcmc_ess.pdf")
#   
#   # Open the PDF device for diagnostic plots
#   pdf(pdf_diagnostics_file, width = 12, height = 8)
#   
#   # Store ESS tables for later output
#   all_ess_tables <- list() 
#   
#   # Process each file
#   for (file_name in mcmc_files) {
#     cat("Processing:", file_name, "\n")
#     
#     # Columns we're interested in (if the file contains any of them)
#     desired_columns <- c('it', 'posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')
#     
#     # Full path to the file
#     file_path <- file.path(working_dir, file_name)
#     
#     # Detect file encoding
#     encoding <- tryCatch({
#       file_info <- system(paste("file -bi", shQuote(file_path)), intern = TRUE)
#       if (grepl("charset=iso-8859-1", file_info)) {
#         "latin1"
#       } else {
#         "UTF-8"
#       }
#     }, error = function(e) {
#       warning(paste("Error detecting encoding for file:", file_name))
#       setwd(original_dir)
#       return(NULL)
#     })
#     
#     if (is.null(encoding)) next
#     
#     # Read the header to get column names
      # header <- tryCatch({
      #   read.table(file_path, header = TRUE, sep = "\t", nrows = 1, fileEncoding = "UTF-8")
      # }, error = function(e) {
      #   warning(paste("Error reading file:", file_name, ". Check encoding."))
      #   setwd(original_dir)
      #   return(NULL)
      # })
      
      # if (is.null(header)) {
      #   next
      # }
#     
#     column_names <- colnames(header)
#     
#     # Find which of our desired columns actually exist in the file
#     available_columns <- column_names[column_names %in% desired_columns]
#     
#     if (length(available_columns) == 0) {
    #   cat("No desired columns found in", file_name, ". Skipping this file. \n")
    #   next
    # } else {
    #   cat("Found columns in", file_name, ":", paste(available_columns, collapse=", "), "\n")
    # }
#     
#     # Create a vector specifying which columns to read
#     # Set unwanted columns to "NULL"
#     col_classes <- sapply(column_names, function(x) if (x %in% available_columns) NA else "NULL")
#     
#     # Read in the data with selected columns
#     mcmc_data <- tryCatch({
#       read.table(file_path, header = TRUE, sep = "\t", colClasses = col_classes, fileEncoding = encoding)
#     }, error = function(e) {
#       warning(paste("Error reading data from", file_name, ":", e$message))
#       return(NULL)
#     })
#     
#     if (is.null(mcmc_data)) {
#     next
#     } 
#     
#     if (ncol(mcmc_data) == 0) {
#       warning(paste("No columns could be read from", file_name))
#       next
#     }
#     
#     
#     # Save just the last two cells of the 'it' column as a numeric vector for pdf
#     it_col <- as.numeric(tail(mcmc_data$it, 2))     
#   
#     # Remove the 'it' column by name
#     mcmc_data <- mcmc_data[, !colnames(mcmc_data) %in% "it", drop = FALSE]
#     
#     # Check the structure of the data
#     str(mcmc_data)
#     
#     # Convert to an mcmc object
#     mcmc_object <- as.mcmc(mcmc_data)
#     
#     # Calculate effective sample size
#     ess <- effectiveSize(mcmc_object)
#     print(ess)
#     
#     # Create transposed ESS table
#     ess_df <- t(round(ess))
#     colnames(ess_df) <- names(ess)
#     row.names(ess_df) <- "ESS"
#     
#     # Add to collection
#     all_ess_tables[[file_name]] <- list(
#       title = paste("ESS for", file_name),
#       iterations = it_col[2],
#       sampling_rate = it_col[2] - it_col[1],
#       data = as.data.frame(ess_df),
#       low_ess = ess < 200
#     )
#     
#     # Add title page for this file's plots
#     grid.newpage()
#     grid.text(paste("MCMC Diagnostics for", file_name), gp = gpar(fontsize = 20))
#     
#     # Create diagnostic plots
#     param_names <- colnames(mcmc_object)
#     params_per_page <- 3
#     num_pages <- ceiling(length(param_names) / params_per_page)
#     
#     for (page in 1:num_pages) {
#       # Determine parameters for this page
#       start_idx <- (page - 1) * params_per_page + 1
#       end_idx <- min(page * params_per_page, length(param_names))
#       
#       plot_list <- list()
#       plot_idx <- 1
#       
#       for (i in start_idx:end_idx) {
#         df <- data.frame(
#           Iteration = as.vector(time(mcmc_object)),
#           Value = as.vector(mcmc_object[, i])
#         )
#         
#         # Convert parameter name to nice format
#         nice_title <- gsub("_", " ", param_names[i])
#         nice_title <- paste0(toupper(substr(nice_title, 1, 1)), 
#                              substr(nice_title, 2, nchar(nice_title)))
#         
#         # Trace plot
#         p1 <- ggplot(df, aes(x = Iteration, y = Value)) +
#           geom_line() +
#           ggtitle(paste(nice_title, "Trace")) +
#           theme_minimal() +
#           theme(plot.title = element_text(size = 10),
#                 axis.title = element_text(size = 8),
#                 axis.text = element_text(size = 7))
#         
#         # Density plot
#         p2 <- ggplot(df, aes(x = Value)) +
#           geom_density(fill = "lightblue", alpha = 0.7) +
#           ggtitle(paste(nice_title, "Density")) +
#           theme_minimal() +
#           theme(plot.title = element_text(size = 10),
#                 axis.title = element_text(size = 8),
#                 axis.text = element_text(size = 7))
#         
#         plot_list[[plot_idx]] <- p1
#         plot_list[[plot_idx + 1]] <- p2
#         plot_idx <- plot_idx + 2
#       }
#       
#       # Fill empty plot slots if needed
#       while (length(plot_list) < 6) {
#         plot_list[[length(plot_list) + 1]] <- ggplot() + theme_void()
#       }
#       
#       # Arrange plots in a grid
#       grid.arrange(grobs = plot_list, ncol = 2, nrow = 3)
#     }
#     
#     cat("Completed processing file:", file_name, "\n\n")
#   }
#   
#   # Close diagnostic plots PDF
#   dev.off()
#   
#   # Create ESS summary PDF
#   pdf(pdf_ess_file, width = 8.5, height = 11)
#   
#   num_tables <- length(all_ess_tables)
#   if (num_tables > 0) {
#     grid.newpage()
#     
#     # Add main title
#     grid.text("MCMC Effective Sample Size (ESS) Summary", 
#               x = 0.5, y = 0.97, 
#               gp = gpar(fontface = "bold", fontsize = 14))
#     
#     # Create layout
#     pushViewport(viewport(x = 0.5, y = 0.5, width = 0.95, height = 0.9))
#     pushViewport(viewport(layout = grid.layout(num_tables, 1)))
#     
#     # Draw each table
#     for (i in seq_along(all_ess_tables)) {
#       table_info <- all_ess_tables[[i]]
#       
#       # Set up colors for low ESS values - entire columns including headers
#       col_colors <- rep("black", length(table_info$low_ess))
#       col_colors[table_info$low_ess] <- "red"
#       
#       # Create header colors matching the column colors
#       header_colors <- col_colors
#       
#       # Create table viewport
#       pushViewport(viewport(layout.pos.row = i, layout.pos.col = 1))
#       
#       # Draw title
#       grid.text(table_info$title, x = 0.5, y = 0.95, 
#                 gp = gpar(fontface = "bold", fontsize = 9))
#       
#       # Draw subtitle
#       grid.text(paste("Iterations:", table_info$iterations, 
#                       "Sampling Rate:", table_info$sampling_rate), 
#                 x = 0.5, y = 0.85, 
#                 gp = gpar(fontface = "italic", fontsize = 8))
#       
#       # Create and draw table
#       tbl <- tableGrob(
#         table_info$data,
#         rows = NULL,
#         theme = ttheme_minimal(
#           core = list(
#             fg_params = list(col = col_colors, fontsize = 9)
#           ),
#           colhead = list(
#             fg_params = list(col = header_colors, fontface = "bold", fontsize = 9),
#             bg_params = list(fill = "lightgray")
#           ),
#           rowhead = list(
#             fg_params = list(fontface = "bold", fontsize = 9)
#           )
#         )
#       )
#       
#       # Create the vplayout to position the table
#       vp <- viewport(y = 0.35, height = 0.6)
#       pushViewport(vp)
#       
#       # Draw the table
#       grid.draw(tbl)
#       
#       popViewport(2) # Pop both viewports
#     }
#     
#     popViewport(1)
#   }
#   
#   dev.off()
#   setwd(original_dir)
#   
#   cat("Analysis complete.\n")
#   cat("Output files:\n")
#   cat("1. Diagnostic plots:", pdf_diagnostics_file, "\n")
#   cat("2. ESS tables:", pdf_ess_file, "\n")
# }
# 