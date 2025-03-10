# Comprehensive MCMC Analysis with coda
# This script demonstrates how to use the coda package to analyze MCMC output
# from a tab-separated log file with iterations as rows and parameters as columns

# Load required packages
library(coda)    # For MCMC diagnostics and summaries
library(ggplot2) 
library(gridExtra)
library(grid)

analyze_mcmc <- function(working_dir) {
  # Set working directory
  original_dir <- getwd()
  setwd(working_dir)
  
  # Find all files ending with "mcmc.log"
  mcmc_files <- list.files(path = working_dir, pattern = "mcmc\\.log$", full.names = FALSE)
  
  # Check if any matching files were found
  if (length(mcmc_files) == 0) {
    warning("No files ending with 'mcmc.log' found in the working directory. Check directory path. Path should begin from current working directory.")
    setwd(original_dir)
    return(NULL)
  }
  
  # Initialize the output files
  ess_file <- file.path(working_dir, "combined_mcmc_ess.html")
  pdf_file <- file.path(working_dir, "combined_mcmc_diagnostics_plots.pdf")
  
  # Open the HTML file for writing
  html_conn <- file(ess_file, open = "wt")
  writeLines("<html><body>", html_conn)
  
  # Open the PDF device
  pdf(pdf_file, width = 12, height = 8)
  
  # Process each file
  for (file_name in mcmc_files) {
    cat("Processing file:", file_name, "\n")
    
    # Columns to read in (if the file contains them)
    columns <- c('posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')
    
    # Full path to the file
    file_path <- file.path(working_dir, file_name)
    
    # Read the header to get column names
    header <- tryCatch({
      read.table(file_path, header = TRUE, sep = "\t", nrows = 1)
    }, error = function(e) {
      warning(paste("Error reading file:", file_name))
      setwd(original_dir)
      return(NULL)
    })
    
    if (is.null(header)) next
    
    column_names <- colnames(header)
    
    # Create a vector specifying which columns to read
    # Set unwanted columns to "NULL"
    col_classes <- sapply(column_names, function(x) if (x %in% columns) NA else "NULL")
    
    # Read in the data with selected columns
    mcmc_data <- tryCatch({
      read.table(file_path, header = TRUE, sep = "\t", colClasses = col_classes)
    }, error = function(e) {
      warning(paste("Error reading data from file:", file_name))
      setwd(original_dir)
      return(NULL)
    })
    
    if (is.null(mcmc_data)) next
    
    # Check the structure of the data
    str(mcmc_data)
    
    # Convert to an mcmc object
    mcmc_object <- as.mcmc(mcmc_data)
    
    # Determine burn-in (e.g., first 10% of samples)
    burnin <- floor(nrow(mcmc_data) * 0.1)
    mcmc_object_burned <- window(mcmc_object, start = burnin + 1)
    mcmc_list_burned <- mcmc.list(list(mcmc_object_burned))
    
    # Effective sample size (ESS)
    # ESS estimates how many independent samples the auto-correlated MCMC samples are equivalent to
    ess <- effectiveSize(mcmc_object)
    print(ess)
    
    # Append ESS to the combined ESS file
    writeLines(paste("<h4>Effective Sample Size (ESS) for", file_name, ":</h4>"), html_conn)
    ess_text <- capture.output(ess)
    writeLines("<table border='1'><tr>", html_conn)
    # Write the header row
    for (name in names(ess)) {
      writeLines(paste("<td>", name, "</td>"), html_conn)
    }
    writeLines("</tr><tr>", html_conn)
    # Write the values row
    for (value in ess) {
      if (value < 200) {
        writeLines(paste("<td style='color:red;'>", round(value), "</td>"), html_conn)
      } else {
        writeLines(paste("<td>", round(value), "</td>"), html_conn)
      }
    }
    writeLines("</tr></table>", html_conn)
    
    # Add a title page to the PDF
    grid.newpage()
    grid.text(paste("MCMC Diagnostics for", file_name), gp = gpar(fontsize = 20))
    
    # Get parameter names
    param_names <- colnames(mcmc_object)
    num_params <- length(param_names)
    
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
          Value = as.vector(mcmc_object[, i])
        )
        
        # Convert parameter name to a title-case format
        nice_title <- gsub("_", " ", param_names[i])
        nice_title <- paste0(toupper(substr(nice_title, 1, 1)),
                             substr(nice_title, 2, nchar(nice_title)))
        
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
      print(do.call(grid.arrange, c(plot_list, ncol = 2, nrow = 3)))
    }
    
    cat("Completed processing file:", file_name, "\n\n")
  }
  
  # Close the PDF device
  dev.off()
  
  # Close the HTML file
  writeLines("</body></html>", html_conn)
  close(html_conn)
  
  # Reset to original working directory
  setwd(original_dir)
  
}


#### A_REPTILIA (mcmc_no_predictors)
# A_rjmcmc_sampled_every_10k
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_10k")

# A_rjmcmc_sampled_every_20k
#DID NOT RUN^^
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_20k")

# A_bdmcmc
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdmcmc")
# A_bdnn
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn")
# A_bdnn_update
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn_update")
# A_mcmc_200_Iterations
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_mcmc_200_Iterations")
