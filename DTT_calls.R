source("DTT_2.R")

# Default values:
  # thin_to = 100,
  # burnin = 0.15,
  # translate = 0,
  # output = "diversity_trajectory.pdf",
  # title = "Diversity Through Time (# Genera)",
  # time_start = 320,
  # time_end = 190,
  # time_by = 0.01,
  # save_plot = TRUE,
  # return_data = FALSE

################### A: MCMC_NO_PREDICTORS
plot_diversity_through_time(path = "temnospondyli/mcmc_no_predictors/A_rjmcmc_sampled_every_20k/",
                            output = "temnospondyli_DTT.pdf",
                            title = "Temnospondyli RJMCMC 1 Myr Global Diversity Trajectory")