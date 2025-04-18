# Calling the function `plot_diversity_through_time` from the source file `DTT_serial.R` or `DTT_parallel.R`
# Comment out which script is needed
# DTT = Diversity Through Time Plot

# source("DTT_serial.R")
source("DTT_parallel.R")

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


################ A_REPTILIA (mcmc_no_predictors) 
# A_rjmcmc_sampled_every_10k
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_10k", output = "reptilia_A_rjmcmc_sampled_every_10k_DTT.pdf", title = "Reptilia RJMCMC 1 Myr Global Diversity Trajectory")
# A_rjmcmc_sampled_every_20k
# Has ANSI encoding
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_rjmcmc_sampled_every_20k", output = "reptilia_A_rjmcmc_sampled_every_20k_DTT.pdf", title = "Reptilia RJMCMC 1 Myr Global Diversity Trajectory")
# A_bdmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdmcmc", output = "reptilia_A_bdmcmc_DTT.pdf", title = "Reptilia BDMCMC 1 Myr Global Diversity Trajectory")
# A_bdnn
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn", output = "reptilia_A_bdnn_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# A_bdnn_update
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn_update", output = "reptilia_A_bdnn_update_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# A_mcmc_200_Iterations
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_mcmc_200_Iterations", output = "reptilia_A_mcmc_200_its_DTT.pdf", title = "Reptilia MCMC 1 Myr Global Diversity Trajectory")

################### A_SYNAPSIDA (mcmc_no_predictors)
# A_rjmcmc_sampled_every_20k
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_rjmcmc_sampled_every_20k", output = "synapsida_A_rjmcmc_sampled_every_20k_DTT.pdf", title = "Synapsida RJMCMC 1 Myr Global Diversity Trajectory")
# A_bdmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdmcmc", output = "synapsida_A_bdmcmc_DTT.pdf", title = "Synapsida BDMCMC 1 Myr Global Diversity Trajectory")
# A_bdnn
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn", output = "synapsida_A_bdnn_DTT.pdf", title = "Synapsida BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# A_bdnn_update
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_bdnn_update", output = "synapsida_A_bdnn_update_DTT.pdf", title = "Synapsida BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# A_mcmc_200_Iterations
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_no_predictors/A_mcmc_200_Iterations", output = "synapsida_A_mcmc_200_its_DTT.pdf", title = "Synapsida MCMC 1 Myr Global Diversity Trajectory")

################### A_TEMNOSPONDYLI (mcmc_no_predictors)
# A_rjmcmc_sampled_every_20k
#plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_rjmcmc_sampled_every_20k", output = "temnospondyli_A_rjmcmc_sampled_every_20k_DTT.pdf", title = "Temnospondyli RJMCMC 1 Myr Global Diversity Trajectory")
# A_bdmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdmcmc", output = "temnospondyli_A_bdmcmc_DTT.pdf", title = "Temnospondyli BDMCMC 1 Myr Global Diversity Trajectory")
# A_bdnn
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn", output = "temnospondyli_A_bdnn_DTT.pdf", title = "Temnospondyli BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# A_bdnn_update
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_bdnn_update", output = "temnospondyli_A_bdnn_update_DTT.pdf", title = "Temnospondyli BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# A_mcmc_200_Iterations
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_mcmc_200_Iterations", output = "temnospondyli_A_mcmc_200_its_DTT.pdf", title = "Temnospondyli MCMC 1 Myr Global Diversity Trajectory")
# ADE
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/ADE", output = "temnospondyli_ADE_DTT.pdf", title = "Temnospondyli ADE 1 Myr Global Diversity Trajectory")


######################### B Section (mcmc_predictors) #####################

################### B_REPTILIA (mcmc_predictors)
# B_bdnn_stdscaled_only_4_2_update
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only_4_2_update", output = "reptilia_B_bdnn_stdscaled_only_4_2_update_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory")
# B_bdnn_stdscaled_cbrt
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_cbrt", output = "reptilia_B_bdnn_stdscaled_cbrt_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_log
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_log", output = "reptilia_B_bdnn_stdscaled_log_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_boxcox", output = "reptilia_B_bdnn_stdscaled_boxcox_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only", output = "reptilia_B_bdnn_stdscaled_only_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_only_8_4_nodes
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_stdscaled_only_8_4_nodes", output = "reptilia_B_bdnn_stdscaled_only_8_4_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_covar_mcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc", output = "reptilia_B_covar_mcmc_DTT.pdf", title = "Reptilia CoVar 1 Myr Global Diversity Trajectory")
# B_bdnn_lats_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_bdnn_lats_only", output = "reptilia_B_bdnn_lats_only_DTT.pdf", title = "Reptilia BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_covar_rjmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_rjmcmc", output = "reptilia_B_covar_rjmcmc_DTT.pdf", title = "Reptilia CoVar RJMCMC 1 Myr Global Diversity Trajectory",
                            translate = 175)
# #B_covar_mcmc/MBD_env_vars_gamma_exponential
#plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential", output = "reptilia_B_MBD_env_vars_gamma_exp_DTT.pdf", title = "Reptilia MBD 1 Myr Global Diversity Trajectory")
# #B_covar_mcmc/MBD_env_vars_gamma_linear
#plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear", output = "reptilia_B_MBD_env_vars_gamma_lin_DTT.pdf", title = "Reptilia MBD 1 Myr Global Diversity Trajectory")
# #B_covar_mcmc/MBD_1myr_temp_gamma_exponential
#plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential", output = "reptilia_B_MBD_1myr_temp_gamma_exp_DTT.pdf", title = "Reptilia MBD 1 Myr Global Diversity Trajectory")
# #B_covar_mcmc/MBD_1myr_temp_gamma_linear
#plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear", output = "reptilia_B_MBD_1myr_temp_gamma_lin_DTT.pdf", title = "Reptilia MBD 1 Myr Global Diversity Trajectory")


################### B_SYNAPSIDA (mcmc_predictors)
# B_bdnn_stdscaled_cbrt
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_cbrt", output = "synapsida_B_bdnn_stdscaled_cbrt_DTT.pdf", title = "Synapsida BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_log
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_log", output = "synapsida_B_bdnn_stdscaled_log_DTT.pdf", title = "Synapsida BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_boxcox", output = "synapsida_B_bdnn_stdscaled_boxcox_DTT.pdf", title = "Synapsida BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_stdscaled_only", output = "synapsida_B_bdnn_stdscaled_only_DTT.pdf", title = "Synapsida BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_covar_mcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc", output = "synapsida_B_covar_mcmc_DTT.pdf", title = "Synapsida CoVar 1 Myr Global Diversity Trajectory")
# B_bdnn_lats_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_bdnn_lats_only", output = "synapsida_B_bdnn_lats_only_DTT.pdf", title = "Synapsida BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_covar_rjmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_rjmcmc", output = "synapsida_B_covar_rjmcmc_DTT.pdf", title = "Synapsida coVar RJMCMC 1 Myr Global Diversity Trajectory",
                            translate = 175)
# # B_covar_mcmc/MBD_env_vars_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential", output = "synapsida_B_MBD_env_vars_gamma_exp_DTT.pdf", title = "Synapsida MBD 1 Myr Global Diversity Trajectory")
# # B_covar_mcmc/MBD_env_vars_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear", output = "synapsida_B_MBD_env_vars_gamma_lin_DTT.pdf", title = "Synapsida MBD 1 Myr Global Diversity Trajectory")
# # B_covar_mcmc/MBD_1myr_temp_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential", output = "synapsida_B_MBD_1myr_temp_gamma_exp_DTT.pdf", title = "Synapsida MBD 1 Myr Global Diversity Trajectory")
# # B_covar_mcmc/MBD_1myr_temp_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear", output = "synapsida_B_MBD_1myr_temp_gamma_lin_DTT.pdf", title = "Synapsida MBD 1 Myr Global Diversity Trajectory")

################### B_TEMNOSPONDYLI (mcmc_predictors)
source("DTT_parallel.R")
# B_bdnn_stdscaled_cbrt
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_cbrt/B_bdnn_stdscaled_cbrt_concatenated_logs", output = "temnospondyli_B_bdnn_stdscaled_cbrt_DTT_parallel.pdf", title = "Temnospondyli BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_log
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_log/B_bdnn_stdscaled_log_concatenated_logs", output = "temnospondyli_B_bdnn_stdscaled_log_DTT_parallel.pdf", title = "Temnospondyli BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_boxcox/B_bdnn_stdscaled_boxcox_concatenated_logs", output = "temnospondyli_B_bdnn_stdscaled_boxcox_DTT_parallel.pdf", title = "Temnospondyli BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_bdnn_stdscaled_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_stdscaled_only", output = "temnospondyli_B_bdnn_stdscaled_only_continuous_DTT_parallel.pdf", title = "Temnospondyli BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_covar_mcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc", output = "temnospondyli_B_covar_mcmc_DTT_parallel.pdf", title = "Temnospondyli CoVar 1 Myr Global Diversity Trajectory")
# B_bdnn_lats_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_bdnn_lats_only", output = "temnospondyli_B_bdnn_lats_only_DTT_parallel.pdf", title = "Temnospondyli BDNN 1 Myr Global Diversity Trajectory", 
                            translate = 175)
# B_covar_rjmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_rjmcmc", output = "temnospondyli_B_covar_rjmcmc_DTT.pdf", title = "Temnospondyli CoVar RJMCMC 1 Myr Global Diversity Trajectory",
                            translate = 175)
# # B_covar_mcmc/MBD_env_vars_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_exponential", output = "temnospondyli_B_MBD_env_vars_gamma_exp_DTT.pdf", title = "Temnospondyli MBD 1 Myr Global Diversity Trajectory")
# # B_covar_mcmc/MBD_env_vars_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_env_vars_gamma_linear", output = "temnospondyli_B_MBD_env_vars_gamma_lin_DTT.pdf", title = "Temnospondyli MBD 1 Myr Global Diversity Trajectory")
# # B_covar_mcmc/MBD_1myr_temp_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_exponential", output = "temnospondyli_B_MBD_1myr_temp_gamma_exp_DTT.pdf", title = "Temnospondyli MBD 1 Myr Global Diversity Trajectory")
# # B_covar_mcmc/MBD_1myr_temp_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_predictors/B_covar_mcmc/MBD_1myr_temp_gamma_linear", output = "temnospondyli_B_MBD_1myr_temp_gamma_lin_DTT.pdf", title = "Temnospondyli MBD 1 Myr Global Diversity Trajectory")

######################### C Section (mcmc_fixshift_predictors) #####################

################### C_REPTILIA (mcmc_fixshift_predictors)
# C_bdnn_lats_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_lats_only", output = "reptilia_C_bdnn_lats_only_DTT.pdf", title = "Reptilia BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_minmax_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox", output = "reptilia_C_bdnn_minmax_boxcox_DTT.pdf", title = "Reptilia BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_minmax_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_minmax_only", output = "reptilia_C_bdnn_minmax_only_DTT.pdf", title = "Reptilia BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_stdscaled_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox", output = "reptilia_C_bdnn_stdscaled_boxcox_DTT.pdf", title = "Reptilia BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_stdscaled_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_only", output = "reptilia_C_bdnn_stdscaled_only_DTT.pdf", title = "Reptilia BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_covar
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar", output = "reptilia_C_covar_DTT.pdf", title = "Reptilia CoVar By Stages Global Diversity Trajectory",
                            translate = 175)
# # C_covar/MBD_env_vars_horseshoe_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_env_vars_horseshoe_exponential", output = "reptilia_C_MBD_env_vars_horseshoe_exp_DTT.pdf", title = "Reptilia MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_env_vars_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_exponential", output = "reptilia_C_MBD_env_vars_gamma_exp_DTT.pdf", title = "Reptilia MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_env_vars_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_linear", output = "reptilia_C_MBD_env_vars_gamma_lin_DTT.pdf", title = "Reptilia MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_1myr_temp_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_exponential", output = "reptilia_C_MBD_1myr_temp_gamma_ex_DTT.pdf", title = "Reptilia MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_1myr_temp_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_linear", output = "reptilia_C_MBD_1myr_temp_gamma_lin_DTT.pdf", title = "Reptilia MBD By Stages Global Diversity Trajectory")

################### C_SYNAPSIDA (mcmc_fixshift_predictors)
# C_bdnn_lats_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_lats_only", output = "synapsida_C_bdnn_lats_only_DTT.pdf", title = "Synapsida BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_minmax_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox", output = "synapsida_C_bdnn_minmax_boxcox_DTT.pdf", title = "Synapsida BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_minmax_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_minmax_only", output = "synapsida_C_bdnn_minmax_only_DTT.pdf", title = "Synapsida BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_stdscaled_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox", output = "synapsida_C_bdnn_stdscaled_boxcox_DTT.pdf", title = "Synapsida BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_bdnn_stdscaled_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_stdscaled_only", output = "synapsida_C_bdnn_stdscaled_only_DTT.pdf", title = "Synapsida BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_covar
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar", output = "synapsida_C_covar_DTT.pdf", title = "Synapsida CoVar By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_covar_test
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar_test", output = "synapsida_C_covar_test_DTT.pdf", title = "Synapsida CoVar By Stages Global Diversity Trajectory",
                            translate = 175)
# # C_covar/MBD_env_vars_horseshoe_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_horseshoe_exponential", output = "synapsida_C_MBD_env_vars_horseshoe_exp_DTT.pdf", title = "Synapsida MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_env_vars_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_exponential", output = "synapsida_C_MBD_env_vars_gamma_exp_DTT.pdf", title = "Synapsida MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_env_vars_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_linear", output = "synapsida_C_MBD_env_vars_gamma_lin_DTT.pdf", title = "Synapsida MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_1myr_temp_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_exponential", output = "synapsida_C_MBD_1myr_temp_gamma_exp_DTT.pdf", title = "Synapsida MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_1myr_temp_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_linear", output = "synapsida_C_MBD_1myr_temp_gamma_lin_DTT.pdf", title = "Synapsida MBD By Stages Global Diversity Trajectory")


################### C_TEMSNOSPONDYLI (mcmc_fixshift_predictors)
# C_bdnn_lats_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_lats_only", output = "temnospondyli_C_bdnn_lats_only_DTT.pdf", title = "Temnospondyli BDNN By Stages Global Diversity Trajectory",
                            translate = 175)
# C_bdnn_minmax_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_minmax_boxcox", output = "temnospondyli_C_bdnn_minmax_boxcox_DTT.pdf", title = "Temnospondyli BDNN By Stages Global Diversity Trajectory",
                            translate = 175)
# C_bdnn_minmax_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_minmax_only", output = "temnospondyli_C_bdnn_minmax_only_DTT.pdf", title = "Temnospondyli BDNN By Stages Global Diversity Trajectory",
                            translate = 175)
# C_bdnn_stdscaled_boxcox
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox", output = "temnospondyli_C_bdnn_stdscaled_boxcox_DTT.pdf", title = "Temnospondyli BDNN By Stages Global Diversity Trajectory",
                            translate = 175)
# C_bdnn_stdscaled_only
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_stdscaled_only", output = "temnospondyli_C_bdnn_stdscaled_only_DTT.pdf", title = "Temnospondyli BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# C_covar
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar", output = "temnospondyli_C_covar_DTT.pdf", title = "Temnospondyli CoVar By Stages Global Diversity Trajectory",
                            translate = 175)
# # C_covar/MBD_env_vars_horseshoe_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_env_vars_horseshoe_exponential", output = "temnospondyli_MBD_env_vars_horseshoe_exp_DTT.pdf", title = "Temnospondyli MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_env_vars_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_exponential", output = "temnospondyli_C_MBD_env_vars_gamma_exp_DTT.pdf", title = "Temnospondyli MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_env_vars_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_env_vars_gamma_linear", output = "temnospondyli_C_MBD_env_vars_gamma_lin_DTT.pdf", title = "Temnospondyli MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_1myr_temp_gamma_exponential
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_exponential", output = "temnospondyli_C_MBD_1myr_temp_gamma_exp_DTT.pdf", title = "Temnospondyli MBD By Stages Global Diversity Trajectory")
# # C_covar/MBD_1myr_temp_gamma_linear
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/MBD_1myr_temp_gamma_linear", output = "temnospondyli_C_MBD_1myr_temp_gamma_lin_DTT.pdf", title = "Temnospondyli MBD By Stages Global Diversity Trajectory")

######################### D Section (mcmc_fixshift_no_predictors) #####################

################### D_REPTILIA (mcmc_fixshift_no_predictors)
# D_bdmcmc
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdmcmc", output = "reptilia_D_bdmcmc_DTT.pdf", title = "Reptilia BDMCMC By Stages Global Diversity Trajectory")
# D_bdnn
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn", output = "reptilia_D_bdnn_DTT.pdf", title = "Reptilia BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# D_bdnn_update
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn_update", output = "reptilia_D_bdnn_update_DTT.pdf", title = "Reptilia BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# D_mcmc
# plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_mcmc", output = "reptilia_D_mcmc_DTT.pdf", title = "Reptilia MCMC By Stages Global Diversity Trajectory")


################### D_SYNAPSIDA (mcmc_fixshift_no_predictors)
# D_bdmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdmcmc (D_mcmc)", output = "synapsida_D_mcmc_DTT.pdf", title = "Synapsida MCMC By Stages Global Diversity Trajectory")
# D_bdnn
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdnn", output = "synapsida_D_bdnn_DTT_parallel.pdf", title = "Synapsida BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# D_bdnn_update
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdnn_update", output = "synapsida_D_bdnn_update_DTT.pdf", title = "Synapsida BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# D_mcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_mcmc", output = "synapsida_D_mcmc_DTT.pdf", title = "Synapsida MCMC By Stages Global Diversity Trajectory")


################### D_TEMSNOSPONDYLI (mcmc_fixshift_no_predictors)
# D_bdmcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdmcmc (D_mcmc)", output = "temnospondyli_D_mcmc_DTT.pdf", title = "Temnospondyli BDMCMC By Stages Global Diversity Trajectory")
# D_bdnn
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdnn", output = "temnospondyli_D_bdnn_DTT.pdf", title = "Temnospondyli BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# D_bdnn_update
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdnn_update", output = "temnospondyli_D_bdnn_update_DTT.pdf", title = "Temnospondyli BDNN By Stages Global Diversity Trajectory", 
                            translate = 175)
# D_mcmc
plot_diversity_through_time(path = "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_mcmc", output = "temnospondyli_D_mcmc_DTT.pdf", title = "Temnospondyli MCMC By Stages Global Diversity Trajectory")
