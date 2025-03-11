# Comprehensive MCMC Analysis with coda
# This script demonstrates how to use the coda package to analyze MCMC output
# And outputs trace + density plots as a pdf, and ess values as a pdf

library(coda)      # For MCMC diagnostics
library(ggplot2)   # For plotting
library(gridExtra) # For arranging plots
library(grid)      # For grid graphics

analyze_mcmc <- function(working_dir) {
  # Set working directory
  original_dir <- getwd()
  setwd(working_dir)
  
  # Find all mcmc.log files
  mcmc_files <- list.files(path = working_dir, pattern = "mcmc\\.log$", full.names = FALSE)
  
  if (length(mcmc_files) == 0) {
    warning("No mcmc.log files found in", working_dir)
    setwd(original_dir)
    return(NULL)
  }
  
  # Initialize output files
  pdf_diagnostics_file <- file.path(working_dir, "combined_mcmc_diagnostics_plots.pdf")
  pdf_ess_file <- file.path(working_dir, "combined_mcmc_ess.pdf")
  
  # Open the PDF device for diagnostic plots
  pdf(pdf_diagnostics_file, width = 13, height = 8)
  
  # Store ESS tables for later output
  all_ess_tables <- list() 
  
  # Process each file
  for (file_name in mcmc_files) {
    cat("Processing:", file_name, "\n")
    
    # Columns to read
    columns <- c('posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')
    
    # Read the header
    header <- tryCatch({
      read.table(file.path(working_dir, file_name), header = TRUE, sep = "\t", nrows = 1)
    }, error = function(e) {
      warning("Error reading file:", file_name)
      return(NULL)
    })
    
    if (is.null(header)) next
    
    # Determine which columns to read
    col_classes <- sapply(colnames(header), function(x) if (x %in% columns) NA else "NULL")
    
    # Read the data
    mcmc_data <- tryCatch({
      read.table(file.path(working_dir, file_name), header = TRUE, sep = "\t", colClasses = col_classes)
    }, error = function(e) {
      warning("Error reading data:", file_name)
      return(NULL)
    })
    
    if (is.null(mcmc_data)) next
    
    # Convert to mcmc object
    mcmc_object <- as.mcmc(mcmc_data)
    
    # Calculate effective sample size
    ess <- effectiveSize(mcmc_object)
    print(ess)
    
    # Create transposed ESS table
    ess_df <- t(round(ess))
    colnames(ess_df) <- names(ess)
    row.names(ess_df) <- "ESS"
    
    # Add to collection
    all_ess_tables[[file_name]] <- list(
      title = paste("ESS for", file_name),
      data = as.data.frame(ess_df),
      low_ess = ess < 200
    )
    
    # Add title page for this file's plots
    grid.newpage()
    grid.text(paste("MCMC Diagnostics for", file_name), gp = gpar(fontsize = 20))
    
    # Create diagnostic plots
    param_names <- colnames(mcmc_object)
    params_per_page <- 3
    num_pages <- ceiling(length(param_names) / params_per_page)
    
    for (page in 1:num_pages) {
      # Determine parameters for this page
      start_idx <- (page - 1) * params_per_page + 1
      end_idx <- min(page * params_per_page, length(param_names))
      
      plot_list <- list()
      plot_idx <- 1
      
      for (i in start_idx:end_idx) {
        df <- data.frame(
          Iteration = as.vector(time(mcmc_object)),
          Value = as.vector(mcmc_object[, i])
        )
        
        # Convert parameter name to nice format
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
  }
  
  # Close diagnostic plots PDF
  dev.off()
  
  # Create ESS summary PDF (landscape)
  pdf(pdf_ess_file, width = 8.5, height = 11)
  
  num_tables <- length(all_ess_tables)
  if (num_tables > 0) {
    grid.newpage()
    
    # Add main title
    grid.text("MCMC Effective Sample Size (ESS) Summary", 
              x = 0.5, y = 0.97, 
              gp = gpar(fontface = "bold", fontsize = 14))
    
    # Create layout
    pushViewport(viewport(x = 0.5, y = 0.5, width = 0.95, height = 0.9))
    pushViewport(viewport(layout = grid.layout(num_tables, 1)))
    
    # Draw each table
    for (i in seq_along(all_ess_tables)) {
      table_info <- all_ess_tables[[i]]
      
      # Set up colors for low ESS values
      col_colors <- rep("black", length(table_info$low_ess))
      col_colors[table_info$low_ess] <- "red"
      
      # Create table viewport
      pushViewport(viewport(layout.pos.row = i, layout.pos.col = 1))
      
      # Draw title
      grid.text(table_info$title, x = 0.5, y = 0.85, 
                gp = gpar(fontface = "bold", fontsize = 9))
      
      # Create and draw table
      tbl <- tableGrob(
        table_info$data,
        rows = NULL,
        theme = ttheme_minimal(
          core = list(fg_params = list(col = col_colors, fontsize = 9)),
          colhead = list(fg_params = list(fontface = "bold", fontsize = 9),
                         bg_params = list(fill = "lightgray")),
          rowhead = list(fg_params = list(fontface = "bold", fontsize = 9))
        )
      )
      
      pushViewport(viewport(y = 0.4, height = 0.6))
      grid.draw(tbl)
      popViewport(2)
    }
    
    popViewport(1)
  }
  
  dev.off()
  setwd(original_dir)
  
  cat("Analysis complete.\n")
  cat("Output files:\n")
  cat("1. Diagnostic plots:", pdf_diagnostics_file, "\n")
  cat("2. ESS tables:", pdf_ess_file, "\n")
}

######################### RUNNING FUNCTION ####################################

################### A_REPTILIA (mcmc_no_predictors)
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

################### A_SYNAPSIDA (mcmc_no_predictors)
# A_rjmcmc_sampled_every_20k
#DID NOT RUN^^
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_rjmcmc_sampled_every_20k")

# A_bdmcmc
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdmcmc")
# A_bdnn
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn")
# A_bdnn_update
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn_update")
# A_mcmc_200_Iterations
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_mcmc_200_Iterations")

################### A_TEMNOSPONDYLI (mcmc_no_predictors)
# A_rjmcmc_sampled_every_10k
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_rjmcmc_sampled_every_10k")

# A_rjmcmc_sampled_every_20k
#DID NOT RUN^^
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_rjmcmc_sampled_every_20k")

# A_bdmcmc
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdmcmc")
# A_bdnn
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn")
# A_bdnn_update
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn_update")
# A_mcmc_200_Iterations
analyze_mcmc("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_mcmc_200_Iterations")
