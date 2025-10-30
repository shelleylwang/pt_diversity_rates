# --------- Helper: Evaluate a single assignment line ---------
parse_vector <- function(line) {
  eval(parse(text = line))
}

# --------- Format data into tidy data.frame ---------
to_dataframe <- function(age, mean, hpd_min, hpd_max, label) {
  data.frame(
    age = age,
    variable = label,
    mean = mean,
    hpd_min = hpd_min,
    hpd_max = hpd_max,
    stringsAsFactors = FALSE
  )
}

# --------- Parser for BDMCMC ---------
parse_bdmcmc <- function(lines) {
  keys <- c("L_hpd_m95", "L_hpd_M95", "L_mean",
            "M_hpd_m95", "M_hpd_M95", "M_mean",
            "R_hpd_m95", "R_hpd_M95", "R_mean", "age")
  matches <- sapply(keys, function(k) grep(paste0("^\\s*", k, "\\s*="), lines, value = TRUE))
  
  if (all(lengths(matches) > 0)) {
    values <- lapply(matches, function(x) parse_vector(x[[1]]))
    names(values) <- keys
    message("BDMCMC vectors loaded successfully.")
    
    df <- rbind(
      to_dataframe(values$age, values$L_mean, values$L_hpd_m95, values$L_hpd_M95, "L"),
      to_dataframe(values$age, values$M_mean, values$M_hpd_m95, values$M_hpd_M95, "M"),
      to_dataframe(values$age, values$R_mean, values$R_hpd_m95, values$R_hpd_M95, "R")
    )
    return(df)
  }
  return(NULL)
}

# --------- Parser for BDNN ---------
parse_bdnn <- function(lines) {
  keys <- c("time_vec", "sp_mean", "ex_mean", "div_mean",
            "sp_lwr", "ex_lwr", "div_lwr",
            "sp_upr", "ex_upr", "div_upr")
  matches <- sapply(keys, function(k) grep(paste0("^\\s*", k, "\\s*="), lines, value = TRUE))
  
  if (all(lengths(matches) > 0)) {
    v <- lapply(matches, function(x) parse_vector(x[[1]]))
    names(v) <- keys
    
    v$time_vec <- rev(-v$time_vec)
    reverse_keys <- setdiff(names(v), "time_vec")
    v[reverse_keys] <- lapply(v[reverse_keys], rev)
    
    df <- rbind(
      to_dataframe(v$time_vec, v$sp_mean, v$sp_lwr, v$sp_upr, "L"),
      to_dataframe(v$time_vec, v$ex_mean, v$ex_lwr, v$ex_upr, "M"),
      to_dataframe(v$time_vec, v$div_mean, v$div_lwr, v$div_upr, "R")
    )
    message("BDNN vectors loaded successfully.")
    return(df)
  }
  return(NULL)
}

# --------- Parser for RJMCMC ---------
parse_rjmcmc <- function(lines) {
  rate_lines <- grep("^\\s*rate\\s*=", lines, value = TRUE)
  minHPD_lines <- grep("^\\s*minHPD\\s*=", lines, value = TRUE)
  maxHPD_lines <- grep("^\\s*maxHPD\\s*=", lines, value = TRUE)
  time_line <- grep("^\\s*time\\s*=", lines, value = TRUE)
  
  if (length(rate_lines) >= 2 && length(minHPD_lines) >= 2 && length(maxHPD_lines) >= 2 && length(time_line) >= 1) {
    age <- eval(parse(text = sub("^\\s*time\\s*=\\s*", "", time_line[1])))
    rate_1 <- eval(parse(text = sub("^\\s*rate\\s*=\\s*", "", rate_lines[1])))
    rate_2 <- eval(parse(text = sub("^\\s*rate\\s*=\\s*", "", rate_lines[2])))
    minHPD_1 <- eval(parse(text = sub("^\\s*minHPD\\s*=\\s*", "", minHPD_lines[1])))
    minHPD_2 <- eval(parse(text = sub("^\\s*minHPD\\s*=\\s*", "", minHPD_lines[2])))
    maxHPD_1 <- eval(parse(text = sub("^\\s*maxHPD\\s*=\\s*", "", maxHPD_lines[1])))
    maxHPD_2 <- eval(parse(text = sub("^\\s*maxHPD\\s*=\\s*", "", maxHPD_lines[2])))
    
    R_mean <- eval(parse(text = sub("^\\s*net_rate\\s*=\\s*", "", grep("^\\s*net_rate\\s*=", lines, value = TRUE)[1])))
    R_hpd_m95 <- eval(parse(text = sub("^\\s*net_minHPD\\s*=\\s*", "", grep("^\\s*net_minHPD\\s*=", lines, value = TRUE)[1])))
    R_hpd_M95 <- eval(parse(text = sub("^\\s*net_maxHPD\\s*=\\s*", "", grep("^\\s*net_maxHPD\\s*=", lines, value = TRUE)[1])))
    
    df <- rbind(
      to_dataframe(age, rate_1, minHPD_1, maxHPD_1, "L"),
      to_dataframe(age, rate_2, minHPD_2, maxHPD_2, "M"),
      to_dataframe(age, R_mean, R_hpd_m95, R_hpd_M95, "R")
    )
    message("RJMCMC vectors loaded successfully.")
    return(df)
  }
  return(NULL)
}

# --------- Main Function ---------
parse_rtt_script <- function(filepath, model_type = c("BDMCMC", "BDNN", "RJMCMC")) {
  model_type <- match.arg(model_type)
  lines <- readLines(filepath, warn = FALSE)
  
  df <- switch(model_type,
               BDMCMC = parse_bdmcmc(lines),
               BDNN   = parse_bdnn(lines),
               RJMCMC = parse_rjmcmc(lines)
  )
  
  if (is.null(df)) {
    message(sprintf("No %s vectors found or could not be parsed.", model_type))
    return(NULL)
  }
  
  return(df)
}

#############################

setwd("D:/Programas/PyRate/Datasets/P-T Tetrapods/2_Syn-Rep(terr)_P-T_1myr_RJMCMC_NoPred/reptilia_terr_200")

# Parse and return a tidy data.frame
rtt_rep <- parse_rtt_script("RTT_plots_RJMCMC.r", model_type = "RJMCMC")

# Example ggplot
library(ggplot2)
ggplot(rtt_rep, aes(x = age, y = mean, fill = variable)) +
  geom_ribbon(aes(ymin = hpd_min, ymax = hpd_max), alpha = 0.3) +
  geom_line(aes(color = variable)) +
  theme_minimal()


#PLOTTING FUNCTIONS


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



# Function to create each plot with smooth polygons and geological timescale
create_plot_with_geo <- function(poly_data, mean_data, color,  
                                 ylab, ylim, show_x_axis = FALSE) {
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
                       limits = c(-300, -200), name = NULL) +
    # Labels and titles
    labs(y = ylab) +
    # Set y limits with coord_cartesian for smooth polygons
    coord_cartesian(ylim = ylim, xlim = c(-300, -200), expand = FALSE) +
    # Remove legend and adjust alpha scale
    scale_alpha_continuous(range = c(0.005, 0.05), guide = "none") +
    # Theme adjustments
    theme_classic() +
    theme(
      text = element_text(size = 12),
      axis.text.x = if(show_x_axis) element_text(size = 12) else element_blank(),
      axis.ticks.x = if(show_x_axis) element_line() else element_blank(),
      axis.text.y = element_text(size = 10),
      axis.title = element_text(size = 12),
      axis.title.x = element_text(size = 12, margin = margin(t = 15)),
      axis.title.y = element_text(margin = margin(r = 15)),
      plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"), # unit(c(top, right, bottom, left), "unit")
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


# Mass extinction events
perm_trias_extinction <- -252 
guadalupian_extinction <- -261

# Custom tick positions
x_ticks <- seq(-300, -200, by=5) ###################### CHANGE THIS TO MODIFY X TICKS
x_tick_labels <- abs(x_ticks)

