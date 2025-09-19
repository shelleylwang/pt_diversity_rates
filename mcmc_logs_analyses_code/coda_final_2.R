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
  # Validate working_dir
  if (!dir.exists(working_dir)) {
    stop("Directory not found: ", working_dir)
  }
  if (file.access(working_dir, mode = 2) != 0) {
    stop("No write permissions in directory: ", working_dir)
  }
  
  # Convert to absolute path to avoid confusion
  working_dir <- normalizePath(working_dir, winslash = "/")
  
  # Set working directory
  original_dir <- getwd() # Path set before the call of the function
  setwd(working_dir) # Path you provide
  # When you exit the function (for any reason, error or just finished), directory reverts back to original_dir
  on.exit(setwd(original_dir), add = TRUE)
  
  # Find all files matching the provided pattern - use current directory "." since we've already set working directory
  mcmc_files <- list.files(path = ".", pattern = file_pattern, full.names = FALSE)
  
  # Check if any matching files were found
  if (length(mcmc_files) == 0) {
    warning("No files matching pattern '", file_pattern, "' found in ", working_dir)
    return(NULL)
  }
  
  cat("Found", length(mcmc_files), "log files in", working_dir, "\n")
  
  # Initialize output files - use working_dir for absolute paths
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
    
    # Since we're in the working directory, just use the file name directly
    file_path <- file_name
    
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
      grid.text(paste("MCMC Diagnostics for", file_name), gp = gpar(fontsize = 10))
      
      # Prepare plot generation
      param_names <- colnames(mcmc_object)
      params_per_page <- 2
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
        while (length(plot_list) < 4) {
          plot_list[[length(plot_list) + 1]] <- ggplot() + theme_void()
        }
        
        # Arrange plots in a grid
        grid.arrange(grobs = plot_list, ncol = 2, nrow = 2)
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
  
  cat("Analysis complete.\n")
  cat("Output files:\n")
  cat("1. Diagnostic plots:", pdf_diagnostics_file, "\n")
  cat("2. ESS tables:", pdf_ess_file, "\n")
  
  # Return invisibly
  invisible(all_ess_tables)
}