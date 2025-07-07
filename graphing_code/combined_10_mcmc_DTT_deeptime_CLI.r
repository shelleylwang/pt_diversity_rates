#!/usr/bin/env Rscript

# Load required libraries
suppressMessages({
  library(argparse)
  library(ggplot2)
  library(deeptime)
})

# Create argument parser
parser <- ArgumentParser(description = "Generate diversity trajectory plots with geological time scale")

# Add arguments
parser$add_argument("-path_to_ltt", "--path_to_ltt", 
                   required = TRUE,
                   help = "Required. Path to the LTT script file")

parser$add_argument("-translate", "--translate", 
                   type = "double", default = 0,
                   help = "Translation value to add to time_events (default: 0). Use if you used -translate with BDNN. You may have to use the -custom_xlim if you're using this option")

parser$add_argument("-title", "--title", 
                   default = "Diversity Trajectory",
                   help = "Plot title (default: 'Diversity Trajectory')")

parser$add_argument("-max_xlim", "--max_xlim", 
                   action = "store_true", default = FALSE,
                   help = "Use maximum time range for x-axis (default: FALSE)")

parser$add_argument("-max_ylim", "--max_ylim", 
                   action = "store_true", default = FALSE,
                   help = "Use maximum diversity range for y-axis within x-limits (default: FALSE)")

parser$add_argument("-custom_xlim", "--custom_xlim", 
                   default = "-280,-235",
                   help = "Custom x-axis limits as -custom_xlim='min,max' (default format and value (equal sign required): -custom_xlim='-280,-235')")

parser$add_argument("-custom_ylim", "--custom_ylim", 
                   default = "0,110",
                   help = "Custom y-axis limits as -custom_ylim='min,max' (default: '0,110')")

parser$add_argument("-ticks", "--ticks", 
                   type = "integer", default = 5,
                   help = "Interval for x-axis ticks (default: 5)")

parser$add_argument("-save_as", "--save_as", 
                   required = TRUE,
                   help = "Required. Output file path for saving the plot")

# Parse arguments
args <- parser$parse_args()

# Parse custom limits
parse_limits <- function(limit_string) {
  limits <- as.numeric(unlist(strsplit(limit_string, ",")))
  if (length(limits) != 2) {
    stop("Limits must be provided as 'min,max'")
  }
  return(limits)
}

custom_xlim <- parse_limits(args$custom_xlim)
custom_ylim <- parse_limits(args$custom_ylim)

# Importing the ts, div_traj, and time_events vectors by loading in from the LTT script
ltt_text <- readLines(args$path_to_ltt, warn = FALSE)

# Extracting the lines that contain the ts, div_traj, and time_events vectors
ts <- grep("^\\s*ts\\s*=", ltt_text, value = TRUE)
time_events <- grep("^\\s*time_events\\s*=", ltt_text, value = TRUE)
div_traj <- grep("^\\s*div_traj\\s*=", ltt_text, value = TRUE)

# Execute those lines
eval(parse(text = ts))
eval(parse(text = time_events))
eval(parse(text = div_traj))

# Apply translation if specified
if (args$translate != 0) {
  time_events <- time_events + args$translate
}

# Mass extinction positions
perm_trias_extinction <- -252
guadalupian_extinction <- -261

# Dataframe
diversity_df <- data.frame(time = -time_events, diversity = div_traj)

# Create the base plot
plot <- ggplot(diversity_df, aes(x = time, y = diversity)) +
  geom_step() +
  # Add mass extinction lines
  geom_vline(xintercept = guadalupian_extinction, 
             color = "red", linetype = "dashed") +
  geom_vline(xintercept = perm_trias_extinction, 
             color = "red", linetype = "dashed", linewidth = 0.5) +
  scale_x_continuous(breaks = seq(from = -5000, to = 0, by = args$ticks)) +
  labs(
    title = args$title,
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
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# Determine xlim and ylim based on arguments
if (args$max_xlim) {
  xlim_values <- c(-max(ts) - 1, 0)
} else {
  xlim_values <- custom_xlim
}

if (args$max_ylim) {
  ylim_values <- c(0, max(diversity_df$diversity[diversity_df$time >= xlim_values[1] & 
                                                diversity_df$time <= xlim_values[2]]) + 1)
} else {
  ylim_values <- custom_ylim
}

# Add coord_geo with determined limits
plot <- plot +
  coord_geo(
    dat = list("international epochs", "international periods"),
    expand = FALSE,
    abbrv = list(TRUE, FALSE),
    pos = list("bottom", "bottom"),
    alpha = 1,
    height = unit(1, "line"),
    neg = TRUE,
    xlim = xlim_values,
    ylim = ylim_values
  )

# Display the plot
print(plot)

# Save as PDF with custom dimensions
ggsave(args$save_as, plot = plot, width = 8, height = 8, units = "in")

cat("Plot saved to:", args$save_as, "\n")