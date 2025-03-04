# Comprehensive MCMC Analysis with coda
# This script demonstrates how to use the coda package to analyze MCMC output
# from a tab-separated log file with iterations as rows and parameters as columns

# Load required packages
library(coda)    # For MCMC diagnostics and summaries
library(ggplot2) # For enhanced plotting (optional but useful)

# Set working directory if needed
# setwd("/path/to/your/directory")

#==========================================
# 1. LOADING AND PREPARING MCMC SAMPLES
#==========================================

# Read in the MCMC log file (tab-separated)
# The file should have iterations as rows and parameters as columns
# The first column is often the iteration number which we'll exclude (select = -1)
mcmc_data <- read.table("mcmc.log", header = TRUE, sep = "\t")

# Check the structure of the data
str(mcmc_data)
# This shows the structure of the dataframe, including column names and data types

# Convert to an mcmc object
# We'll assume the first column is iteration number and exclude it
# If your file doesn't have an iteration column, remove the 'select = -1' part
mcmc_object <- as.mcmc(mcmc_data[, -1])  

# If you have multiple chains, you can combine them into an mcmc.list object
# For example, if you have 3 separate chain files:
# chain1 <- as.mcmc(read.table("chain1.log", header = TRUE, sep = "\t")[, -1])
# chain2 <- as.mcmc(read.table("chain2.log", header = TRUE, sep = "\t")[, -1])
# chain3 <- as.mcmc(read.table("chain3.log", header = TRUE, sep = "\t")[, -1])
# mcmc_list <- mcmc.list(list(chain1, chain2, chain3))

# For this example, we'll create a mock mcmc.list with a single chain
mcmc_list <- mcmc.list(list(mcmc_object))

# Determine burn-in (e.g., first 10% of samples)
# Burn-in removes the initial samples when the chain might not have converged yet
burnin <- floor(nrow(mcmc_data) * 0.1)
mcmc_object_burned <- window(mcmc_object, start = burnin + 1)
mcmc_list_burned <- mcmc.list(list(mcmc_object_burned))

# Thinning the chain if needed
# Thinning keeps every nth sample to reduce autocorrelation
thin_interval <- 5  # Keep every 5th sample
mcmc_thinned <- window(mcmc_object, thin = thin_interval)

#==========================================
# 2. BASIC SUMMARY STATISTICS
#==========================================

# Get basic summary statistics for all parameters
summary_stats <- summary(mcmc_object)
print(summary_stats)
# This outputs mean, standard deviation, quantiles and other statistics for each parameter

# For a more detailed summary including HPD intervals
summary_stats_detailed <- summary(mcmc_object, quantiles = c(0.025, 0.25, 0.5, 0.75, 0.975))
print(summary_stats_detailed)
# This provides additional quantiles to better understand the distribution

# Highest Posterior Density (HPD) intervals
# HPD intervals are the shortest intervals containing a specified probability mass
hpd_intervals <- HPDinterval(mcmc_object, prob = 0.95)
print(hpd_intervals)
# This shows the 95% highest posterior density intervals for each parameter

# Effective sample size (ESS)
# ESS estimates how many independent samples the autocorrelated MCMC samples are equivalent to
ess <- effectiveSize(mcmc_object)
print(ess)
# Lower ESS values indicate higher autocorrelation, suggesting you may need more samples

#==========================================
# 3. CONVERGENCE DIAGNOSTICS
#==========================================

# Geweke diagnostic
# Tests if the mean of the first part of the chain is equal to the mean of the last part
geweke_diag <- geweke.diag(mcmc_object)
print(geweke_diag)
# Z-scores outside of +/- 1.96 suggest potential lack of convergence

# Geweke plot
# Visual representation of the Geweke diagnostic
geweke_plot <- geweke.plot(mcmc_object)
# If values consistently fall outside the confidence bands, it suggests non-convergence

# Heidelberger and Welch diagnostic
# Tests stationarity and if the chain length is sufficient
heidel_diag <- heidel.diag(mcmc_object)
print(heidel_diag)
# Look for 'passed' results in stationarity test and half-width test

# Raftery and Lewis diagnostic
# Estimates the run length needed for accurate quantile estimation
raftery_diag <- raftery.diag(mcmc_object)
print(raftery_diag)
# Provides recommended burn-in, total iterations, and thinning interval

# Gelman-Rubin diagnostic (requires multiple chains)
# Compares within-chain and between-chain variance
# For demonstration, we'll use our single chain twice (in practice, use real separate chains)
if (length(mcmc_list) > 1) {
  gelman_diag <- gelman.diag(mcmc_list)
  print(gelman_diag)
  # Values close to 1.0 indicate convergence; values above 1.1 suggest lack of convergence
  
  # Gelman-Rubin plot
  gelman_plot <- gelman.plot(mcmc_list)
  # The plot should show lines converging to 1.0 as iterations increase
}

# Autocorrelation
# Measures how consecutive samples are correlated
autocorr_values <- autocorr(mcmc_object)
print(autocorr_values)
# High autocorrelation at high lags indicates poor mixing

# Autocorrelation plot
autocorr_plot <- autocorr.plot(mcmc_object)
# Ideally, autocorrelation should quickly drop to near zero as lag increases

#==========================================
# 4. VISUALIZATIONS
#==========================================

# Trace plots (shows the parameter values across iterations)
# Helps assess mixing and stationarity
trace_plots <- traceplot(mcmc_object)
# Look for chains that explore the parameter space well without getting stuck

# Density plots (shows the posterior distributions)
density_plots <- densplot(mcmc_object)
# Shows the estimated posterior density for each parameter

# Combined trace and density plots
# Combines both plots for more comprehensive assessment
trace_density <- plot(mcmc_object)
# This is useful for quick visual assessment of convergence and distribution shape

# Autocorrelation function plots
acf_plots <- autocorr.plot(mcmc_object)
# Shows how autocorrelation decreases with increasing lag

# Crosscorrelation plots
# Shows correlations between parameters
crosscorr_plot <- crosscorr.plot(mcmc_object)
# High correlations may indicate model identifiability issues

# Cumuplot (cumulative quantile plot)
# Shows how quantiles stabilize over iterations
cumuplot(mcmc_object)
# If lines stabilize to horizontal, it suggests convergence

# For multiple chains, you can create running mean plots
if (length(mcmc_list) > 1) {
  running_mean_plot <- plot(mcmc_list)
  # Different chains should converge to the same running mean
}

#==========================================
# 5. ADVANCED ANALYSIS
#==========================================

# Calculate Monte Carlo Standard Error (MCSE)
# Estimates the error in the posterior mean estimate due to Monte Carlo sampling
mcse <- mcse(mcmc_object)
print(mcse)
# Lower values indicate more precise estimates of the posterior mean

# Batch means to estimate variance
# An alternative method to estimate the variance of the posterior mean
batch_means <- spectrum0.ar(mcmc_object)
print(batch_means)
# Provides variance estimates accounting for autocorrelation

# Time series analysis of the chains
# Can help identify patterns or issues in the sampling
spec_plot <- spectrum0(mcmc_object)
# The spectral density at frequency zero is related to the effective sample size

#==========================================
# 6. SAVING RESULTS
#==========================================

# Save summary statistics to a file
capture.output(summary_stats, file = "mcmc_summary.txt")
# This saves all the summary statistics to a text file

# Save key diagnostic results
diagnostics_results <- list(
  geweke = geweke_diag,
  heidelberger = heidel_diag,
  raftery = raftery_diag,
  effective_size = ess,
  hpd_intervals = hpd_intervals
)
saveRDS(diagnostics_results, "mcmc_diagnostics.rds")
# This saves the diagnostic results in an R-specific format for later use

# Save plots (optional, requires graphics device)
pdf("mcmc_diagnostics_plots.pdf")
traceplot(mcmc_object, main = "Trace Plots")
densplot(mcmc_object, main = "Density Plots")
autocorr.plot(mcmc_object, main = "Autocorrelation Plots")
crosscorr.plot(mcmc_object, main = "Crosscorrelation Plot")
if (length(mcmc_list) > 1) {
  gelman.plot(mcmc_list, main = "Gelman-Rubin Plot")
}
dev.off()
# This creates a PDF with multiple diagnostic plots

#==========================================
# 7. EXAMPLE INTERPRETATION
#==========================================

# Example of how to interpret results (would be customized to your specific model):
# 
# 1. Check trace plots for good mixing (chains should move freely and cover the parameter space)
# 2. Verify effective sample size is sufficient (rule of thumb: ESS > 1000 for reliable inference)
# 3. Ensure Gelman-Rubin statistic is close to 1.0 if using multiple chains
# 4. Check if autocorrelation decreases rapidly with lag
# 5. Verify convergence diagnostics (Geweke, Heidelberger-Welch) show convergence
# 6. Examine posterior density plots for expected shapes
# 7. Interpret parameter estimates and credible intervals in context of your model