library(ggplot2)
library(scales)
library(gridExtra)
library(deeptime)
library(gtable)
library(grid)



################### DTT #######################


# ADD ts, div_traj, and time_events vectors by loading in from the default _LTT.r script
######### CHANGE THE PATH TO THE DEFAULT _LTT.R SCRIPT
# reading in default _LTT.r script as text, where each line from the default script is a separate element in the readLines vector
ltt_text <- readLines("C:\\Users\\SimoesLabAdmin\\Documents\\pt_diversity_rates\\updated_occurrence_analyses\\model_8\\reptilia_all_offset_biohpc\\DTTs\\combined_10_mcmc_LTT.r", warn = FALSE) 
# extracting the lines that contain the ts, div_traj, and time_events vectors
ts <- grep("^\\s*ts\\s*=", ltt_text, value = TRUE)
time_events <- grep("^\\s*time_events\\s*=", ltt_text, value = TRUE)
div_traj <- grep("^\\s*div_traj\\s*=", ltt_text, value = TRUE)
# Execute those lines
eval(parse(text = ts))
eval(parse(text = time_events))
eval(parse(text = div_traj))

############# If you used -translate with BDNN, you'll need to add back the translated value to the time_events vec
time_events = time_events + 175

# Mass extinction positions
perm_trias_extinction <- -252
guadalupian_extinction <- -261

# Dataframe
diversity_df <- data.frame(time = -time_events, diversity = div_traj)

# Ggplot
DTT_plot <- ggplot(diversity_df, aes(x = time, y = diversity)) +
  geom_step() +
# Add mass extinction lines
    geom_vline(xintercept = guadalupian_extinction, 
               color = "red", linetype = "dashed") +
    geom_vline(xintercept = perm_trias_extinction, 
               color = "red", linetype = "dashed", linewidth = 0.5) +
  #xlim(-max(ts) - 1, 0) + #### Commented out because xlim is set in coord_geo. If you want to see the full range, you can remove xlim from coord_geo, uncomment this
    scale_x_continuous(breaks = seq(from = -300, to = 0, by = 5)) +
  labs(
    x = "Time (Ma)",
    y = "Number of Genera"
  ) +
  theme_classic() + 
    theme(
      text = element_text(size = 12),
      axis.text.x = element_text(size = 12),
      axis.ticks.x = element_line(),
      axis.text.y = element_text(size = 10),
      axis.title = element_text(size = 12),
      axis.title.x = element_text(size = 12, margin = margin(t = 15)),
      axis.title.y = element_text(margin = margin(r = 15)),
      plot.title = element_text(size = 14, hjust = 0.5, margin = margin(b = 15)),
      plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"), # unit(c(top, right, bottom, left), "unit")
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()) +
    coord_geo(
      dat = list("international epochs", "international periods"),
      expand= FALSE,
      abbrv = list(TRUE, FALSE),
      pos = list("bottom", "bottom"),
      alpha = 1,
      height = unit(1, "line"),
      neg = TRUE,
      xlim = c(-280, -235), ############################# CHANGE THIS TO MODIFY X LIMITS, I.E., TIME FRAME
      ############# comment the below line out if you want ylim to be the max(diversity) within the xlim range
      #ylim = c(0, max(diversity_df$diversity[diversity_df$time >= -280 & diversity_df$time <= -235]) + 1) # Adjust y limits based on the data
      ylim = c(0, 110), # Set ylim by hand so diff models can have be comparable
    )


DTT_plot


#--------------------------------------------------------------------------------
########################## RTT  ###########################

library(ggplot2)
library(scales)
library(gridExtra)
library(deeptime)
library(gtable)
library(grid)

##############  PREPPING DATA VECTORS, COPY IN THE PATH TO THE RTT SCRIPT
rtt_text <- readLines("C:/Users/SimoesLabAdmin/Documents/pt_diversity_rates/updated_occurrence_analyses/model_8/reptilia_all_offset_biohpc/RTTs/combined_10_RTT.r", warn = FALSE)

# Search for lines in rtt_text that contain any of the vectors we need
# Note that vectors in BDNN, RJMCMC, and non-BDNN/non-RJMCMC models have different names, so we'll need to do some transformations and conditionals
# age = time (should be negative, descending, so -1, -2, for ex)
# L = Speciation, M = extinction, R = netdiversification, M95 = max 95% HPD, m95 = min 95% HPD, mean = rate (central line)

# Searching for NON-BDNN, NON-RJMCMC VECTORS
L_hpd_m95 <- grep("^\\s*L_hpd_m95\\s*=", rtt_text, value = TRUE)
L_hpd_M95 <- grep("^\\s*L_hpd_M95\\s*=", rtt_text, value = TRUE)
L_mean <- grep("^\\s*L_mean\\s*=", rtt_text, value = TRUE)
M_hpd_m95 <- grep("^\\s*M_hpd_m95\\s*=", rtt_text, value = TRUE)
M_hpd_M95 <- grep("^\\s*M_hpd_M95\\s*=", rtt_text, value = TRUE)
M_mean <- grep("^\\s*M_mean\\s*=", rtt_text, value = TRUE)
R_hpd_m95 <- grep("^\\s*R_hpd_m95\\s*=", rtt_text, value = TRUE)
R_hpd_M95 <- grep("^\\s*R_hpd_M95\\s*=", rtt_text, value = TRUE)
R_mean <- grep("^\\s*R_mean\\s*=", rtt_text, value = TRUE)
age <- grep("^\\s*age\\s*=", rtt_text, value = TRUE)

# Searching for BDNN VECTORS
time_vec <- grep("^\\s*time_vec\\s*=", rtt_text, value = TRUE)
sp_mean <- grep("^\\s*sp_mean\\s*=", rtt_text, value = TRUE)
ex_mean <- grep("^\\s*ex_mean\\s*=", rtt_text, value = TRUE)
div_mean <- grep("^\\s*div_mean\\s*=", rtt_text, value = TRUE)
sp_lwr <- grep("^\\s*sp_lwr\\s*=", rtt_text, value = TRUE)
ex_lwr <- grep("^\\s*ex_lwr\\s*=", rtt_text, value = TRUE)
div_lwr <- grep("^\\s*div_lwr\\s*=", rtt_text, value = TRUE)
sp_upr <- grep("^\\s*sp_upr\\s*=", rtt_text, value = TRUE)
ex_upr <- grep("^\\s*ex_upr\\s*=", rtt_text, value = TRUE)
div_upr <- grep("^\\s*div_upr\\s*=", rtt_text, value = TRUE)

# Search for RJMCMC VECTORS
time <- grep("^\\s*time\\s*=", rtt_text, value = TRUE)
rate <- grep("^\\s*rate\\s*=", rtt_text, value = TRUE)
minHPD <- grep("^\\s*minHPD\\s*=", rtt_text, value = TRUE)
maxHPD <- grep("^\\s*maxHPD\\s*=", rtt_text, value = TRUE)
# All the RJMCMC div vectors have net_ prefix
net_rate <- grep("^\\s*net_rate\\s*=", rtt_text, value = TRUE)  
net_minHPD <- grep("^\\s*net_minHPD\\s*=", rtt_text, value = TRUE)
net_maxHPD <- grep("^\\s*net_maxHPD\\s*=", rtt_text, value = TRUE)

# Execute NON-BDNN, NON-RJMCMC vectors only if all those vectors were found/exist
if (length(L_hpd_m95) > 0 && length(L_hpd_M95) > 0 && length(L_mean) > 0 &&
    length(M_hpd_m95) > 0 && length(M_hpd_M95) > 0 && length(M_mean) > 0 &&
    length(R_hpd_m95) > 0 && length(R_hpd_M95) > 0 && length(R_mean) > 0 &&
    length(age) > 0) {
  
  eval(parse(text = L_hpd_m95))
  eval(parse(text = L_hpd_M95))
  eval(parse(text = L_mean))
  eval(parse(text = M_hpd_m95))
  eval(parse(text = M_hpd_M95))
  eval(parse(text = M_mean))
  eval(parse(text = R_hpd_m95))
  eval(parse(text = R_hpd_M95))
  eval(parse(text = R_mean))
  eval(parse(text = age))
  
  print("Non-BDNN, Non-RJMCMC vectors loaded successfully.")
  
  # Execute BDNN vectors only if all those vectors were found/exist AND the first condition was not met
} else if (length(time_vec) > 0 && length(sp_mean) > 0 && length(ex_mean) > 0 &&
           length(div_mean) > 0 && length(sp_lwr) > 0 && length(ex_lwr) > 0 &&
           length(div_lwr) > 0 && length(sp_upr) > 0 && length(ex_upr) > 0 &&
           length(div_upr) > 0) {
  
  eval(parse(text = time_vec))
  time_vec <- -time_vec  # Convert to negative time for plotting  
  eval(parse(text = sp_mean))
  eval(parse(text = ex_mean))
  eval(parse(text = div_mean))
  eval(parse(text = sp_lwr))
  eval(parse(text = ex_lwr))
  eval(parse(text = div_lwr))
  eval(parse(text = sp_upr))
  eval(parse(text = ex_upr))
  eval(parse(text = div_upr))
  # Now reverse all of these vectors
  time_vec <- rev(time_vec)
  sp_mean <- rev(sp_mean)
  ex_mean <- rev(ex_mean)
  div_mean <- rev(div_mean)
  sp_lwr <- rev(sp_lwr)
  ex_lwr <- rev(ex_lwr)
  div_lwr <- rev(div_lwr)
  sp_upr <- rev(sp_upr)
  ex_upr <- rev(ex_upr)
  div_upr <- rev(div_upr)
  # RENAME the BDNN vectors to match the NON-BDNN, Non-RJMCMC vectors so that the following graphing code works
  L_hpd_m95 <- sp_lwr
  L_hpd_M95 <- sp_upr
  L_mean <- sp_mean
  M_hpd_m95 <- ex_lwr
  M_hpd_M95 <- ex_upr
  M_mean <- ex_mean
  R_hpd_m95 <- div_lwr
  R_hpd_M95 <- div_upr
  R_mean <- div_mean
  age <- time_vec
  
  print("BDNN vectors loaded successfully.")
  
  # Execute RJMCMC vectors only if all those vectors were found/exist AND the previous conditions were not met
} else if (length(time) > 2 && length(rate) > 2 && length(minHPD) > 2 &&
           length(maxHPD) > 2) {
  # The grep found multiple lines, so we need to parse them
  # Parse and create numbered variables for each of the vars found
  for (i in seq_along(rate)) {
    rhs <- sub("^\\s*rate\\s*=\\s*", "", rate[i])
    assign(paste0("rate_", i), eval(parse(text = rhs)))
  }
  
  for (i in seq_along(minHPD)) {
    rhs <- sub("^\\s*minHPD\\s*=\\s*", "", minHPD[i])
    assign(paste0("minHPD_", i), eval(parse(text = rhs)))
  }
  
  for (i in seq_along(maxHPD)) {
    rhs <- sub("^\\s*maxHPD\\s*=\\s*", "", maxHPD[i])
    assign(paste0("maxHPD_", i), eval(parse(text = rhs)))
  }
  
  L_mean <- rate_1
  M_mean <- rate_2
  L_hpd_m95 <- minHPD_1
  L_hpd_M95 <- maxHPD_1
  M_hpd_m95 <- minHPD_2
  M_hpd_M95 <- maxHPD_2
  
  age <- eval(parse(text = sub("^\\s*time\\s*=\\s*", "", grep("^\\s*time\\s*=", rtt_text, value = TRUE)[1])))
  R_mean <- eval(parse(text = sub("^\\s*net_rate\\s*=\\s*", "", grep("^\\s*net_rate\\s*=", rtt_text, value = TRUE))))
  R_hpd_m95 <- eval(parse(text = sub("^\\s*net_minHPD\\s*=\\s*", "", grep("^\\s*net_minHPD\\s*=", rtt_text, value = TRUE))))
  R_hpd_M95 <- eval(parse(text = sub("^\\s*net_maxHPD\\s*=\\s*", "", grep("^\\s*net_maxHPD\\s*=\\s*", rtt_text, value = TRUE))))
  
  print("RJMCMC vectors loaded successfully.")
  
} else {
  print("No complete set of vectors found in the provided RTT script.")
}

# Mass extinction events
perm_trias_extinction <- -252 
guadalupian_extinction <- -261

# Custom tick positions
x_ticks <- seq(-300, -200, by=5) ###################### CHANGE THIS TO MODIFY X TICKS
x_tick_labels <- abs(x_ticks)

# Modified plot_RTT function that returns data for ggplot
get_RTT_data <- function(age, hpd_M, hpd_m, mean_m, color) {
    N <- 100
    beta <- (1:(N-1))/N
    alpha_shape <- 0.25
    cat <- 1-(beta^(1./alpha_shape))
    
    # Create data frame for the polygons
    poly_data <- data.frame()
    
    for (i in 1:(N-1)) {
        trans <- 1/N + 2/N
        upper <- hpd_M-((hpd_M-mean_m)*cat[i])
        lower <- hpd_m+((mean_m-hpd_m)*cat[i])
        
        temp_df <- data.frame(
            age = c(age, rev(age)),
            y = c(upper, rev(lower)),
            group = i,
            alpha = trans
        )
        poly_data <- rbind(poly_data, temp_df)
    }
    
    return(list(poly_data = poly_data, mean_data = data.frame(age = age, y = mean_m)))
}

# Create plotting data for each rate
L_data <- get_RTT_data(age, L_hpd_M95, L_hpd_m95, L_mean, "#4c4cec")
M_data <- get_RTT_data(age, M_hpd_M95, M_hpd_m95, M_mean, "#e34a33")
R_data <- get_RTT_data(age, R_hpd_M95, R_hpd_m95, R_mean, "#504A4B")

# Function to create each plot with smooth polygons and geological timescale
create_plot_with_geo <- function(poly_data, mean_data, color, title, ylab, ylim, show_x_axis = FALSE) {
  # Create main plot
  main_plot <- ggplot() +
    # Plot the HPD intervals with transparency gradient
    geom_polygon(data = poly_data, 
                aes(x = age, y = y, group = group, alpha = alpha), 
                fill = color, na.rm = TRUE) +
    # Plot the mean line
    geom_line(data = mean_data, 
             aes(x = age, y = y), 
             color = color, size = 1.2, lineend = "round") +
    # Add mass extinction lines
    geom_vline(xintercept = guadalupian_extinction, 
               color = "red", linetype = "dashed") +
    geom_vline(xintercept = perm_trias_extinction, 
               color = "red", linetype = "dashed", size = 0.5) +
    # Custom x-axis
    scale_x_continuous(breaks = x_ticks, labels = if(show_x_axis) x_tick_labels else NULL, 
                      limits = c(-300, -200), name = if(show_x_axis) "Ma" else NULL) +
    # Labels and titles
    labs(title = title, y = ylab) +
    # Set y limits with coord_cartesian for smooth polygons
    coord_cartesian(ylim = ylim, xlim = c(-300, -200), expand = FALSE) +
    # Remove legend and adjust alpha scale
    scale_alpha_continuous(range = c(0.005, 0.05), guide = "none") +
    # Theme adjustments
    theme_classic() +
    theme(
      text = element_text(size = 10),
      axis.text.x = if(show_x_axis) element_text(size = 10) else element_blank(),
      axis.ticks.x = if(show_x_axis) element_line() else element_blank(),
      axis.text.y = element_text(size = 9),
      axis.title = element_text(size = 10),
      axis.title.x = element_text(size = 10, margin = margin(t = 15)),
      axis.title.y = element_text(margin = margin(r = 15)),
      plot.title = element_text(size = 14, hjust = 0.5, margin = margin(b = 15)),
      plot.margin = unit(c(0.5, 0.5, if(show_x_axis) 0.5 else 0.1, 0.5), "cm"), # unit(c(top, right, bottom, left), "unit")
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )
  
  # Add horizontal line for net diversification plot
  if (ylab == "Net diversification rate") {
    main_plot <- main_plot + geom_hline(yintercept = 0, linetype = "dashed", color = "black")
  }
  
  # Add geological timescale directly to the plot
  main_plot <- main_plot + 
  # Custom x-axis 
    coord_geo(
      dat = list("international epochs", "international periods"),
      expand= FALSE,
      abbrv = list(TRUE, FALSE),
      pos = list("bottom", "bottom"),
      alpha = 1,
      ylim = ylim, ######### COMMENT THIS OUT TO AUTO-SCALE Y AXIS (even if you pass a ylim argument, if this is commented out, it will auto-scale based on data vectors)
      height = unit(1, "line"),
      neg = TRUE,
      xlim = c(-280, -235)) ############################# CHANGE THIS TO MODIFY X LIMITS, I.E., TIME FRAME
  
  return(main_plot)
}

############# CALL THE FUNCTION WITH CUSTOM ARGUMENTS
############# TITLE, YLIM
p1 <- create_plot_with_geo(L_data$poly_data, L_data$mean_data, "#4c4cec", 
                         "All Reptilia Model 8: BDNN MCMC by 1Myr with Isotopic Predictors", 
                         "Speciation rate", c(0, 2), show_x_axis = TRUE) 

p2 <- create_plot_with_geo(M_data$poly_data, M_data$mean_data, "#e34a33", 
                         "", "Extinction rate", c(0, 2), show_x_axis = TRUE)

p3 <- create_plot_with_geo(R_data$poly_data, R_data$mean_data, "#504A4B", 
                         "", "Net diversification rate", c(-0.5, 2), show_x_axis = TRUE)



########################### Final DTT + RTT plots #######################


# Combine all plots
combined_plots <- grid.arrange(
  p1, p2, p3, DTT_plot,
  ncol = 1,
  heights = c(1, 1, 1, 1),
  top = ""
)
combined_plots
ggsave(plot = combined_plots, "C:/Users/SimoesLabAdmin/Documents/pt_diversity_rates/updated_occurrence_analyses/model_8/reptilia_all_offset_biohpc/Plot_Rep_All_DTT_RTT.pdf", width = 8, height = 14)
