library(ggplot2)
library(deeptime)

####### ADD ts, div_traj, and time_events vectors from pyrate default _LTT.r script
ts=c()
time_events=c()
div_traj=c()

# Mass extinction positions
perm_trias_extinction <- -252
guadalupian_extinction <- -261

# Dataframe
diversity_df <- data.frame(time = -time_events, diversity = div_traj)

# Ggplot
plot <- ggplot(diversity_df, aes(x = time, y = diversity)) +
  geom_step() +
# Add mass extinction lines
    geom_vline(xintercept = guadalupian_extinction, 
               color = "red", linetype = "dashed") +
    geom_vline(xintercept = perm_trias_extinction, 
               color = "red", linetype = "dashed", linewidth = 0.5) +
  #xlim(-max(ts) - 1, 0) + #### Commented out because xlim is set in coord_geo. If you want to see the full range, you can remove xlim from coord_geo, uncomment this
    scale_x_continuous(breaks = seq(from = -300, to = 0, by = 5)) +
  labs(
    title = "Terrestrial Reptilia Model 1 Diversity Trajectory", ##### SET MODEL/CLADE TITLE
    x = "Time (Ma)",
    y = "Number of Lineages"
  ) +
  theme_classic() + 
    theme(
      text = element_text(size = 10),
      axis.text.x = element_text(size = 10),
      axis.ticks.x = element_line(),
      axis.text.y = element_text(size = 9),
      axis.title = element_text(size = 10),
      axis.title.x = element_text(size = 10, margin = margin(t = 15)),
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
      ############# ylim should be the max(diversity) within the xlim range
      ylim = c(0, max(diversity_df$diversity[diversity_df$time >= -280 & diversity_df$time <= -235]) + 1) # Adjust y limits based on the data
     #ylim = c(0, 100), # Adjust y limits if necessary. Comment this out if you want to set ylim by hand
    )


# Display the plot
plot

# Save as PDF with custom dimensions
###### CHANGE PDF PATH
ggsave('/combined_10_DTT_deeptime.pdf', plot = plot, width = 8, height = 8, units = "in")