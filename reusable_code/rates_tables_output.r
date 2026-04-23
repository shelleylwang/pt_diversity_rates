
  library(optparse)
  library(ggplot2)
  library(scales)
  library(gridExtra)
  library(deeptime)
  library(gtable)
  library(grid)


ltt_path = "ltt_script.R"
rtt_path = "rtt_script.R"

# Read and parse LTT script
ltt_text <- readLines(opt$ltt_path, warn = FALSE)
ts <- grep("^\\s*ts\\s*=", ltt_text, value = TRUE)
time_events <- grep("^\\s*time_events\\s*=", ltt_text, value = TRUE)
div_traj <- grep("^\\s*div_traj\\s*=", ltt_text, value = TRUE)

# Execute those lines
eval(parse(text = ts))
eval(parse(text = time_events))
eval(parse(text = div_traj))

# Apply translation if specified
time_events = time_events + opt$translate
if (opt$translate != 0) {
  cat(paste("Applied time back-translation of", opt$translate, "Myr\n"))
}

# Create diversity dataframe
diversity_df <- data.frame(time = -time_events, diversity = div_traj)

# Handle DTT ylim
dtt_ylim_actual <- if (identical(dtt_ylim, "auto")) {
  c(0, max(diversity_df$diversity[diversity_df$time >= xlim_vals[1] & 
                                   diversity_df$time <= xlim_vals[2]]) + 1)
} else {
  dtt_ylim
}

# Create DTT plot
DTT_plot <- ggplot(diversity_df, aes(x = time, y = diversity)) +
  geom_step() +
  scale_x_continuous(breaks = x_ticks) +
  labs(x = "Time (Ma)", y = "Number of Genera") +
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
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  coord_geo(
    dat = list("international ages", "international periods"),
    expand = FALSE,
    abbrv = list(TRUE, FALSE),
    pos = list("bottom", "bottom"),
    alpha = 1,
    height = unit(1, "line"),
    neg = TRUE,
    xlim = xlim_vals,
    ylim = dtt_ylim_actual
  )

# Add extinction event lines to DTT plot if specified
if (length(extinction_events) > 0) {
  DTT_plot <- DTT_plot + 
    geom_vline(xintercept = extinction_events, color = "red", linetype = "dashed")
}

cat("DTT plot created\n")

########################## RTT ###########################

# Read RTT script
rtt_text <- readLines(opt$rtt_path, warn = FALSE)

# Search for NON-BDNN, NON-RJMCMC vectors
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

# Search for BDNN vectors
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

# Search for RJMCMC vectors
time <- grep("^\\s*time\\s*=", rtt_text, value = TRUE)
rate <- grep("^\\s*rate\\s*=", rtt_text, value = TRUE)
minHPD <- grep("^\\s*minHPD\\s*=", rtt_text, value = TRUE)
maxHPD <- grep("^\\s*maxHPD\\s*=", rtt_text, value = TRUE)
net_rate <- grep("^\\s*net_rate\\s*=", rtt_text, value = TRUE)
net_minHPD <- grep("^\\s*net_minHPD\\s*=", rtt_text, value = TRUE)
net_maxHPD <- grep("^\\s*net_maxHPD\\s*=", rtt_text, value = TRUE)

# Detect and load appropriate vector format
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
  
  cat("Loaded standard PyRate model vectors\n")
  
} else if (length(time_vec) > 0 && length(sp_mean) > 0 && length(ex_mean) > 0 &&
           length(div_mean) > 0 && length(sp_lwr) > 0 && length(ex_lwr) > 0 &&
           length(div_lwr) > 0 && length(sp_upr) > 0 && length(ex_upr) > 0 &&
           length(div_upr) > 0) {
  
  eval(parse(text = time_vec))
  time_vec <- -time_vec
  eval(parse(text = sp_mean))
  eval(parse(text = ex_mean))
  eval(parse(text = div_mean))
  eval(parse(text = sp_lwr))
  eval(parse(text = ex_lwr))
  eval(parse(text = div_lwr))
  eval(parse(text = sp_upr))
  eval(parse(text = ex_upr))
  eval(parse(text = div_upr))
  
  # Reverse vectors
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
  
  # Rename for compatibility
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
  
  cat("Loaded BDNN model vectors\n")
  
} else if (length(time) > 2 && length(rate) > 2 && length(minHPD) > 2 &&
           length(maxHPD) > 2) {
  
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
  
  age <- eval(parse(text = sub("^\\s*time\\s*=\\s*", "", 
                               grep("^\\s*time\\s*=", rtt_text, value = TRUE)[1])))
  R_mean <- eval(parse(text = sub("^\\s*net_rate\\s*=\\s*", "", 
                                  grep("^\\s*net_rate\\s*=", rtt_text, value = TRUE))))
  R_hpd_m95 <- eval(parse(text = sub("^\\s*net_minHPD\\s*=\\s*", "", 
                                     grep("^\\s*net_minHPD\\s*=", rtt_text, value = TRUE))))
  R_hpd_M95 <- eval(parse(text = sub("^\\s*net_maxHPD\\s*=\\s*", "", 
                                     grep("^\\s*net_maxHPD\\s*=", rtt_text, value = TRUE))))
  
  cat("Loaded RJMCMC model vectors\n")
  
} else {
  stop("Error: Could not detect valid rate vectors in RTT file", call.=FALSE)
}

# Function to prepare RTT plotting data
get_RTT_data <- function(age, hpd_M, hpd_m, mean_m, color) {
  N <- 100
  beta <- (1:(N-1))/N
  alpha_shape <- 0.25
  cat <- 1-(beta^(1./alpha_shape))
  
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

# Create plotting data
L_data <- get_RTT_data(age, L_hpd_M95, L_hpd_m95, L_mean, "#4c4cec")
M_data <- get_RTT_data(age, M_hpd_M95, M_hpd_m95, M_mean, "#e34a33")
R_data <- get_RTT_data(age, R_hpd_M95, R_hpd_m95, R_mean, "#504A4B")

# Function to create RTT plots with geological timescale
create_plot_with_geo <- function(poly_data, mean_data, color, title, ylab, 
                                ylim, show_x_axis = FALSE) {
  main_plot <- ggplot() +
    geom_polygon(data = poly_data, 
                aes(x = age, y = y, group = group, alpha = alpha), 
                fill = color, na.rm = TRUE) +
    geom_line(data = mean_data, 
             aes(x = age, y = y), 
             color = color, linewidth = 1.2, lineend = "round") +
    scale_x_continuous(breaks = x_ticks, 
                      labels = if(show_x_axis) x_tick_labels else NULL, 
                      name = if(show_x_axis) "Ma" else NULL) +
    labs(title = title, y = ylab) +
    coord_cartesian(ylim = ylim, expand = FALSE) +
    scale_alpha_continuous(range = c(0.005, 0.05), guide = "none") +
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
      plot.margin = unit(c(0.5, 0.5, if(show_x_axis) 0.5 else 0.1, 0.5), "cm"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )
  
  # Add extinction event lines if specified
  if (length(extinction_events) > 0) {
    main_plot <- main_plot + 
      geom_vline(xintercept = extinction_events, color = "red", linetype = "dashed")
  }
  
  # Add zero line for net diversification
  if (ylab == "Net diversification rate") {
    main_plot <- main_plot + geom_hline(yintercept = 0, linetype = "dashed", color = "black")
  }
  
  # Add geological timescale
  main_plot <- main_plot + 
    coord_geo(
      dat = list("international ages", "international periods"),
      expand = FALSE,
      abbrv = list(TRUE, FALSE),
      pos = list("bottom", "bottom"),
      alpha = 1,
      ylim = ylim,
      height = unit(1, "line"),
      neg = TRUE,
      xlim = xlim_vals
    )
  
  return(main_plot)
}

cat("Creating RTT plots...\n")

# Open null device to prevent Rplots.pdf creation (random file)
pdf(NULL)

# Create individual plots
p1 <- create_plot_with_geo(L_data$poly_data, L_data$mean_data, "#4c4cec", 
                           opt$title, "Speciation rate", spec_ylim, show_x_axis = TRUE)

p2 <- create_plot_with_geo(M_data$poly_data, M_data$mean_data, "#e34a33", 
                           "", "Extinction rate", ext_ylim, show_x_axis = TRUE)

p3 <- create_plot_with_geo(R_data$poly_data, R_data$mean_data, "#504A4B", 
                           "", "Net diversification rate", div_ylim, show_x_axis = TRUE)