# Comprehensive MCMC Analysis with coda
# This script demonstrates how to use the coda package to analyze MCMC output
# from a tab-separated log file with iterations as rows and parameters as columns

# Load required packages
library(coda)    # For MCMC diagnostics and summaries
library(ggplot2) 
library(gridExtra)

# Set working directory
setwd("reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_10k")

# Columns I want to read in (if the file contains them)
columns <- c('posterior', 'prior', 'PP_lik', 'BD_lik', 'k_birth', 'k_death', 'RJ_hp')

# Read the header to get column names
header <- read.table("reptilia_pyrate_1_A_rjmcmc_Grj_mcmc.log", header = TRUE, sep = "\t", nrows = 1)
column_names <- colnames(header)

# Create a vector specifying which columns to read
# Set unwanted columns to "NULL"
col_classes <- sapply(column_names, function(x) if (x %in% columns) NA else "NULL")

# Read in the data with selected columns
mcmc_data <- read.table("reptilia_pyrate_1_A_rjmcmc_Grj_mcmc.log", header = TRUE, sep = "\t", colClasses = col_classes)

# Check the structure of the data
str(mcmc_data)

# Convert to an mcmc object
mcmc_object <- as.mcmc(mcmc_data)  

# Determine burn-in (e.g., first 10% of samples)
burnin <- floor(nrow(mcmc_data) * 0.1)
mcmc_object_burned <- window(mcmc_object, start = burnin + 1)
mcmc_list_burned <- mcmc.list(list(mcmc_object_burned))

# Effective sample size (ESS)
# ESS estimates how many independent samples the autocorrelated MCMC samples are equivalent to
ess <- effectiveSize(mcmc_object)
print(ess)
capture.output(ess, file = "mcmc_ess.txt")


# Save plots of MCMC diagnostics with 6 plots per page (3 parameters)
pdf("mcmc_diagnostics_plots.pdf", width=12, height=8)

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
      Value = as.vector(mcmc_object[,i])
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
  # This is the key fix - we need to use print() to create a new page
  print(do.call(grid.arrange, c(plot_list, ncol = 2, nrow = 3)))
}

dev.off()