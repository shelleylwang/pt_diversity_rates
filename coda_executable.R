# Comprehensive MCMC Analysis with coda
# This script demonstrates how to use the coda package to analyze MCMC output
# from a tab-separated log file with iterations as rows and parameters as columns

# Load required packages
library(coda)    # For MCMC diagnostics and summaries
library(ggplot2) 
library(gridExtra)

# analyze_mcmc <- function(working_dir) {
#   # Set working directory
#   original_dir <- getwd()
#   setwd(working_dir)
  
#   # Find all files ending with "mcmc.log"
#   mcmc_files <- list.files(path = working_dir, pattern = "mcmc\\.log$", full.names = FALSE)
  
#   # Check if any matching files were found
#   if (length(mcmc_files) == 0) {
#     warning("No files ending with 'mcmc.log' found in the working directory. Check directory path. Path should begin from current working directory.")
#     setwd(original_dir)
#     return(NULL)
#   }
  
#   # Process each file
#   for (file_name in mcmc_files) {
#     cat("Processing file:", file_name, "\n")
    
#     # Columns to read in (if the file contains them)
#     columns <- c('posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')
    
#     # Full path to the file
#     file_path <- file.path(working_dir, file_name)
    
#     # Read the header to get column names
#     header <- read.table(file_name, header = TRUE, sep = "\t", nrows = 1)
#     column_names <- colnames(header)
    
#     # Create a vector specifying which columns to read
#     # Set unwanted columns to "NULL"
#     col_classes <- sapply(column_names, function(x) if (x %in% columns) NA else "NULL")
    
#     # Read in the data with selected columns
#     mcmc_data <- read.table(file_name, header = TRUE, sep = "\t", colClasses = col_classes)
    
#     # Check the structure of the data
#     str(mcmc_data)
    
#     # Convert to an mcmc object
#     mcmc_object <- as.mcmc(mcmc_data)  
    
#     # Determine burn-in (e.g., first 10% of samples)
#     burnin <- floor(nrow(mcmc_data) * 0.1)
#     mcmc_object_burned <- window(mcmc_object, start = burnin + 1)
#     mcmc_list_burned <- mcmc.list(list(mcmc_object_burned))
    
#     # Effective sample size (ESS)
#     # ESS estimates how many independent samples the autocorrelated MCMC samples are equivalent to
#     ess <- effectiveSize(mcmc_object)
#     print(ess)
    
#     # Save ESS to file in output directory
#     output_file <- gsub("\\.log$", "", file_name)
#     ess_file <- paste0(output_file, "_mcmc_ess.txt")
#     capture.output(ess, file = ess_file)
    
#     # Save plots of MCMC diagnostics with 6 plots per page (3 parameters)
#     pdf_file <- paste0(output_file, "_mcmc_diagnostics_plots.pdf")
#     pdf(pdf_file, width=12, height=8)
    
#     # Get parameter names
#     param_names <- colnames(mcmc_object)
#     num_params <- length(param_names)
    
#     # Calculate how many pages we need
#     params_per_page <- 3  # 3 parameters per page
#     num_pages <- ceiling(num_params / params_per_page)
    
#     # Loop through each page
#     for (page in 1:num_pages) {
#       # Determine which parameters to plot on this page
#       start_idx <- (page - 1) * params_per_page + 1
#       end_idx <- min(page * params_per_page, num_params)
      
#       # Create a list to hold all plots for this page
#       plot_list <- list()
      
#       # Create plots for each parameter on this page
#       plot_idx <- 1
#       for (i in start_idx:end_idx) {
#         # Create a data frame for ggplot
#         df <- data.frame(
#           Iteration = as.vector(time(mcmc_object)),
#           Value = as.vector(mcmc_object[,i])
#         )
        
#         # Convert parameter name to a title-case format
#         nice_title <- gsub("_", " ", param_names[i])
#         nice_title <- paste0(toupper(substr(nice_title, 1, 1)), 
#                            substr(nice_title, 2, nchar(nice_title)))
        
#         # Trace plot
#         p1 <- ggplot(df, aes(x = Iteration, y = Value)) +
#           geom_line() +
#           ggtitle(paste(nice_title, "Trace")) +
#           theme_minimal() +
#           theme(plot.title = element_text(size = 10),
#                 axis.title = element_text(size = 8),
#                 axis.text = element_text(size = 7))
        
#         # Density plot
#         p2 <- ggplot(df, aes(x = Value)) +
#           geom_density(fill = "lightblue", alpha = 0.7) +
#           ggtitle(paste(nice_title, "Density")) +
#           theme_minimal() +
#           theme(plot.title = element_text(size = 10),
#                 axis.title = element_text(size = 8),
#                 axis.text = element_text(size = 7))
        
#         # Add to plot list
#         plot_list[[plot_idx]] <- p1
#         plot_list[[plot_idx + 1]] <- p2
        
#         plot_idx <- plot_idx + 2
#       }
      
#       # If we don't have enough plots to fill the page, add empty plots
#       while (length(plot_list) < 6) {
#         plot_list[[length(plot_list) + 1]] <- ggplot() + theme_void()
#       }
      
#       # Arrange all plots in a 3x2 grid and print to PDF
#       print(do.call(grid.arrange, c(plot_list, ncol = 2, nrow = 3)))
#     }
    
#     dev.off()
#     cat("Completed processing file:", file_name, "\n\n")
#   }
  
#   # Reset to original working directory
#   setwd(original_dir)
# }


analyze_mcmc <- function(working_dir) {
  # Set working directory
  original_dir <- getwd()
  setwd(working_dir)
  
  # Find all files ending with "mcmc.log"
  mcmc_files <- list.files(path = working_dir, pattern = "mcmc\\.log$", full.names = FALSE)
  
  # Check if any matching files were found
  if (length(mcmc_files) == 0) {
    warning("No files ending with 'mcmc.log' found in the working directory.")
    setwd(original_dir)
    return(NULL)
  }
  
  # Create single output files for all results
  combined_pdf_file <- "combined_mcmc_diagnostics_plots.pdf"
  combined_ess_file <- "combined_mcmc_ess.txt"
  
  # Open the PDF file for all plots
  pdf(combined_pdf_file, width=12, height=8)
  
  # Open a connection to the ESS file
  ess_conn <- file(combined_ess_file, "w")
  
  # Process each file
  for (file_name in mcmc_files) {
    cat("Processing file:", file_name, "\n")
    
    # Write file name as header in ESS file
    cat("====================================================\n", file = ess_conn)
    cat("Results for file:", file_name, "\n", file = ess_conn)
    cat("====================================================\n", file = ess_conn)
    
    # Columns to read in (if the file contains them)
    columns <- c('posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')
    
    # Full path to the file
    file_path <- file.path(working_dir, file_name)
    
    # Read the header to get column names
    header <- read.table(file_name, header = TRUE, sep = "\t", nrows = 1)
    column_names <- colnames(header)
    
    # Create a vector specifying which columns to read
    # Set unwanted columns to "NULL"
    col_classes <- sapply(column_names, function(x) if (x %in% columns) NA else "NULL")
    
    # Read in the data with selected columns
    mcmc_data <- read.table(file_name, header = TRUE, sep = "\t", colClasses = col_classes)
    
    # Check the structure of the data
    str_output <- capture.output(str(mcmc_data))
    cat(paste(str_output, collapse = "\n"), "\n", file = ess_conn)
    
    # Convert to an mcmc object
    mcmc_object <- as.mcmc(mcmc_data)  
    
    # Determine burn-in (e.g., first 10% of samples)
    burnin <- floor(nrow(mcmc_data) * 0.1)
    mcmc_object_burned <- window(mcmc_object, start = burnin + 1)
    mcmc_list_burned <- mcmc.list(list(mcmc_object_burned))
    
    # Effective sample size (ESS)
    # ESS estimates how many independent samples the autocorrelated MCMC samples are equivalent to
    ess <- effectiveSize(mcmc_object)
    ess_output <- capture.output(print(ess))
    cat(paste(ess_output, collapse = "\n"), "\n\n", file = ess_conn)
    
    # Get parameter names
    param_names <- colnames(mcmc_object)
    num_params <- length(param_names)
    
    # Add a title page for this file's plots
    grid.newpage()
    grid.text(paste("MCMC Diagnostics for:", file_name), 
              x = 0.5, y = 0.5, 
              gp = gpar(fontsize = 20, fontface = "bold"))
    
    # Calculate how many pages we need
    params_per_page <- 3  # 3 parameters per page
    num_pages <- ceiling(num_params / params_per_page)
    
    # Loop through each page
    for (page in 1:num_pages) {
      # Determine which parameters to plot on this page
      start_idx <- (page - 1) * params_per_page + 1
      end_idx <- min(page * params_per_page, num_params)
      
      # Create a list to hold all plots for this page
      plot_list <- list()
      
      # Create plots for each parameter on this page
      plot_idx <- 1
      for (i in start_idx:end_idx) {
        # Create a data frame for ggplot
        df <- data.frame(
          Iteration = as.vector(time(mcmc_object)),
          Value = as.vector(mcmc_object[,i])
        )
        
        # Convert parameter name to a title-case format
        nice_title <- gsub("_", " ", param_names[i])
        nice_title <- paste0(toupper(substr(nice_title, 1, 1)), 
                           substr(nice_title, 2, nchar(nice_title)))
        
        # File name as subtitle for both plots
        file_subtitle <- paste("File:", file_name)
        
        # Trace plot
        p1 <- ggplot(df, aes(x = Iteration, y = Value)) +
          geom_line() +
          ggtitle(paste(nice_title, "Trace")) +
          labs(subtitle = file_subtitle) +
          theme_minimal() +
          theme(plot.title = element_text(size = 10),
                plot.subtitle = element_text(size = 8, color = "blue"),
                axis.title = element_text(size = 8),
                axis.text = element_text(size = 7))
        
        # Density plot
        p2 <- ggplot(df, aes(x = Value)) +
          geom_density(fill = "lightblue", alpha = 0.7) +
          ggtitle(paste(nice_title, "Density")) +
          labs(subtitle = file_subtitle) +
          theme_minimal() +
          theme(plot.title = element_text(size = 10),
                plot.subtitle = element_text(size = 8, color = "blue"),
                axis.title = element_text(size = 8),
                axis.text = element_text(size = 7))
        
        # Add to plot list
        plot_list[[plot_idx]] <- p1
        plot_list[[plot_idx + 1]] <- p2
        
        plot_idx <- plot_idx + 2
      }
      
      # If we don't have enough plots to fill the page, add empty plots
      while (length(plot_list) < 6) {
        plot_list[[length(plot_list) + 1]] <- ggplot() + theme_void()
      }
      
      # Arrange all plots in a 3x2 grid and print to PDF
      print(do.call(grid.arrange, c(plot_list, ncol = 2, nrow = 3, 
                                     top = textGrob(paste("Page", page, "of", num_pages, "for file:", file_name),
                                                   gp = gpar(fontsize = 12)))))
    }
    
    cat("Completed processing file:", file_name, "\n\n")
  }
  
  # Close the PDF and ESS file
  dev.off()
  close(ess_conn)
  
  cat("Output files created:\n")
  cat("1.", combined_pdf_file, "\n")
  cat("2.", combined_ess_file, "\n")
  
  # Reset to original working directory
  setwd(original_dir)
}