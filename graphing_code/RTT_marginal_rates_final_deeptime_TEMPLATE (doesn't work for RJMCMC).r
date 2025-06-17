library(ggplot2)
library(scales)
library(gridExtra)
library(grid)
library(deeptime)


# Function to create the gradient polygon data for ggplot
create_gradient_polygons <- function(age, hpd_M, hpd_m, mean_m, color, alpha_base = 0.25) {
  N <- 100
  beta <- (1:(N-1))/N
  alpha_shape <- 0.25
  cat <- 1 - (beta^(1/alpha_shape))
  
  polygon_data <- data.frame()
  
  for (i in 1:(N-1)) {
    trans <- 1/N + 2/N
    
    upper_bound <- hpd_M - ((hpd_M - mean_m) * cat[i])
    lower_bound <- hpd_m + ((mean_m - hpd_m) * cat[i])
    
    # Create polygon vertices
    poly_df <- data.frame(
      x = c(age, rev(age)),
      y = c(upper_bound, rev(lower_bound)),
      group = i,
      alpha = trans,
      color = color
    )
    
    polygon_data <- rbind(polygon_data, poly_df)
  }
  
  return(polygon_data)
}

# Create age vector
age <- (0:(298-1)) * -1

# Mass extinction positions
perm_trias_extinction <- -252
guadalupian_extinction <- -261

# Custom tick positions
x_ticks <- seq(-300, -200, by=10)
x_tick_labels <- abs(x_ticks)

# You'll need to replace these with your actual data vectors:
# L_hpd_M95, L_hpd_m95, L_mean (speciation data)
# M_hpd_M95, M_hpd_m95, M_mean (extinction data)  
# R_hpd_M95, R_hpd_m95, R_mean (net diversification data)

# Example data creation (replace with your actual data)
# L_hpd_M95 <- your_speciation_upper_hpd
# L_hpd_m95 <- your_speciation_lower_hpd
# L_mean <- your_speciation_mean
# M_hpd_M95 <- your_extinction_upper_hpd
# M_hpd_m95 <- your_extinction_lower_hpd
# M_mean <- your_extinction_mean
# R_hpd_M95 <- your_net_div_upper_hpd
# R_hpd_m95 <- your_net_div_lower_hpd
# R_mean <- your_net_div_mean

# Create gradient polygon data for each plot
spec_polygons <- create_gradient_polygons(age, L_hpd_M95, L_hpd_m95, L_mean, "#4c4cec")
ext_polygons <- create_gradient_polygons(age, M_hpd_M95, M_hpd_m95, M_mean, "#e34a33")
net_polygons <- create_gradient_polygons(age, R_hpd_M95, R_hpd_m95, R_mean, "#504A4B")

# Create mean line data
spec_line_data <- data.frame(x = rev(age), y = rev(L_mean))
ext_line_data <- data.frame(x = rev(age), y = rev(M_mean))
net_line_data <- data.frame(x = rev(age), y = rev(R_mean))

# Base theme to match original styling
base_theme <- theme_classic() +
  theme(
    plot.title = element_text(size = 14, hjust = 0.5, margin = margin(b = 20)),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 9),
    axis.title.x = element_text(margin = margin(t = 15)),
    axis.title.y = element_text(margin = margin(r = 15)),
    plot.margin = margin(t = 20, r = 10, b = 20, l = 20),
    panel.grid = element_blank()
  )

# Plot 1: Speciation rate
p1 <- ggplot() +
  geom_polygon(data = spec_polygons, 
               aes(x = x, y = y, group = group, alpha = alpha), 
               fill = "#4c4cec", color = NA) +
  geom_line(data = spec_line_data, 
            aes(x = x, y = y), 
            color = "#4c4cec", size = 1.2) +
  geom_vline(xintercept = perm_trias_extinction, color = "red", linetype = "dashed") +
    coord_geo(xlim = c(-300, -200),
            expand = FALSE,
            clip = "on",
            dat = list("international epochs", "international periods"),
            abbrv = list(TRUE, FALSE),
            pos = list("bottom", "bottom"),
            alpha = 1,
            height = unit(1, "line"),
            rot = 0,
            size = "auto",
            neg = TRUE) +
  geom_vline(xintercept = guadalupian_extinction, color = "red", linetype = "dashed") +
  scale_x_continuous(breaks = x_ticks, labels = x_tick_labels, limits = c(-300, -200)) +
  scale_y_continuous(limits = c(0, 1)) +
  scale_alpha_identity() +
  ############################################ CHANGE GRAPH TITLE
  labs(title = "Synapsida: MCMC By Stages No Preds",
       x = "Ma",
       y = "Speciation rate") +
  base_theme

# Plot 2: Extinction rate
p2 <- ggplot() +
  geom_polygon(data = ext_polygons, 
               aes(x = x, y = y, group = group, alpha = alpha), 
               fill = "#e34a33", color = NA) +
  geom_line(data = ext_line_data, 
            aes(x = x, y = y), 
            color = "#e34a33", size = 1.2) +
  geom_vline(xintercept = perm_trias_extinction, color = "red", linetype = "dashed") +
  geom_vline(xintercept = guadalupian_extinction, color = "red", linetype = "dashed") +
   coord_geo(xlim = c(-300, -200),
            expand = FALSE,
            clip = "on",
            dat = list("international epochs", "international periods"),
            abbrv = list(TRUE, FALSE),
            pos = list("bottom", "bottom"),
            alpha = 1,
            height = unit(1, "line"),
            rot = 0,
            size = "auto",
            neg = TRUE) +
    scale_x_continuous(breaks = x_ticks, labels = x_tick_labels, limits = c(-300, -200)) +
  scale_y_continuous(limits = c(0, 1)) +
  scale_alpha_identity() +
  labs(x = "Ma",
       y = "Extinction rate") +
  base_theme +
  theme(plot.title = element_blank())

# Plot 3: Net diversification rate
p3 <- ggplot() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  geom_polygon(data = net_polygons, 
               aes(x = x, y = y, group = group, alpha = alpha), 
               fill = "#504A4B", color = NA) +
  geom_line(data = net_line_data, 
            aes(x = x, y = y), 
            color = "#504A4B", size = 1.2) +
  geom_vline(xintercept = perm_trias_extinction, color = "red", linetype = "dashed") +
  geom_vline(xintercept = guadalupian_extinction, color = "red", linetype = "dashed") +
   coord_geo(xlim = c(-300, -200),
            expand = FALSE,
            clip = "on",
            dat = list("international epochs", "international periods"),
            abbrv = list(TRUE, FALSE),
            pos = list("bottom", "bottom"),
            alpha = 1,
            height = unit(1, "line"),
            rot = 0,
            size = "auto",
            neg = TRUE) +
  scale_x_continuous(breaks = x_ticks, labels = x_tick_labels, limits = c(-300, -200)) +
  scale_y_continuous(limits = c(-0.5, 1)) +
  scale_alpha_identity() +
  labs(x = "Ma",
       y = "Net diversification rate") +
  base_theme +
  theme(plot.title = element_blank())

# Combine plots
combined_plot <- grid.arrange(p1, p2, p3, ncol = 1, heights = c(1.2, 1, 1))

# Save theplot
######################################################## USE CUSTOM PATH
ggsave("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/updated_occurrence_analyses/model_1/combined_10_marginal_rates_RTT_deeptime_final.pdf", 
       combined_plot, 
       width = 8, 
       height = 10.8, 
       units = "in")

# To display the plot
print(combined_plot)