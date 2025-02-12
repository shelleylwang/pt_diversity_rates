#!/usr/bin/env Rscript

### Example Usage:
### Rscript LTT_with_uncertainty.R -p ./reptilia/mcmc_predictors/B_covar_mcmc 
### -n 10 -t 100 -b 0.15 -o reptilia_B_covar_mcmc_ltt_with_uncertainty.pdf
### --title "Reptilia diversity Trajectory" --prefix "reptilia_pyrate"
### --file-pattern "_G_COVhp_BDS_mcmc.log"

# Load required libraries with suppressed startup messages for cleaner output
suppressPackageStartupMessages({
  library(coda)      # For statistical analysis
  library(ggplot2)   # For plotting
  library(gridExtra) # For plot arrangement
  library(deeptime)  # For geological time scale visualization
})

# Helper function to monitor memory usage throughout script execution
monitor_memory <- function() {
  mem_used <- gc()  # Force garbage collection and get memory stats
  cat(sprintf("Memory used: %.2f MB\n", mem_used[2,2] * 0.000001))
}

# Function to parse and validate command line arguments
parse_args <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  
  # Show help if requested
  if (length(args) == 0 || "-h" %in% args || "--help" %in% args) {
    cat("Usage: Rscript LTT_with_uncertainty.R [options]
    
Options:
  -h, --help            Show this help message and exit
  -p PATH               Path to directory containing MCMC files (default: '.')
  -n NUM_REPLICATES     Number of MCMC replicates to process (default: 10)
  -t THIN_TO            Thin each MCMC log's samples to this number (default: 50)
  -b BURNIN             Proportion of samples to discard as burnin (default: 0.15)
  -tr TRANSLATE         Time translation value in Ma (default: 0). 
                        Use this if the -translate argument was used in the original PyRate run. 
                        It should = the negative of the PyRate -translate argument value 
  -o OUTPUT             Output PDF filename (default: 'diversity_trajectory.pdf')
  --title TITLE         Plot title (default: 'Diversity Trajectory')
  --prefix PREFIX       File prefix for MCMC files (default: 'reptilia_pyrate_')
  --file-pattern PAT    File suffix pattern (default: '_G_COVhp_BDS_mcmc.log')

Example:
  Rscript LTT_with_uncertainty.R -p ./mcmc_results -n 5 -t 20 -b 0.2 -o results.pdf

Note: 
  - Burnin should be between 0 and 1
  - Thin_to should be greater than 0
  - Num_replicates should be greater than 0\n")
    quit(save = "no", status = 0)
  }
  
  # Initialize default values for all possible parameters
  params <- list(
    path = ".", # Current Directory
    num_replicates = 10,
    thin_to = 50,
    burnin = 0.15,
    translate = 0,
    output = "diversity_trajectory.pdf",
    title = "Diversity Trajectory",
    prefix = "reptilia_pyrate_",
    file_pattern = "_G_COVhp_BDS_mcmc.log"
  )
  
  # Parse command line arguments
  i <- 1
  while (i <= length(args)) {
    if (args[i] == "-p") {
      params$path <- args[i + 1]
      i <- i + 2
    } else if (args[i] == "-n") {
      params$num_replicates <- as.integer(args[i + 1])
      i <- i + 2
    } else if (args[i] == "-t") {
      params$thin_to <- as.integer(args[i + 1])
      i <- i + 2
    } else if (args[i] == "-b") {
      params$burnin <- as.numeric(args[i + 1])
      i <- i + 2
    } else if (args[i] == "-tr") {
      params$translate <- as.numeric(args[i + 1])
      i <- i + 2
    } else if (args[i] == "-o") {
      params$output <- args[i + 1]
      i <- i + 2
    } else if (args[i] == "--title") {
      params$title <- args[i + 1]
      i <- i + 2
    } else if (args[i] == "--prefix") {
      params$prefix <- args[i + 1]
      i <- i + 2
    } else if (args[i] == "--file-pattern") {
      params$file_pattern <- args[i + 1]
      i <- i + 2
    } else {
      warning(paste("Unknown argument:", args[i]))
      i <- i + 1
    }
  }
  
  return(params)
}

# Helper function to remove burn-in period from MCMC samples
removeBurnin <- function(L, Burnin) {
  L <- L[-c(1:round(nrow(L) * Burnin)), ]
  return(L)
}

# Helper function to thin MCMC samples
applyThin <- function(L, Thin = 0) {
  if (Thin > 0) {
    N <- nrow(L)
    ThinIdx <- floor(seq(1, N, by = N/Thin))
    L <- L[ThinIdx, ]
  }
  return(L)
}

# Function to calculate lineage through time values
getLtt <- function(Ts, Te, TimeVec) {
  Ts <- unlist(Ts)
  Te <- unlist(Te)
  ChangeTe <- rep(-1, length(Te))
  ChangeTe[Te == 0.0] <- 0
  Change <- c(rep(1, length(Ts)), ChangeTe)
  Times <- c(Ts, Te)
  Ord <- order(Times, decreasing = TRUE)
  Change <- Change[Ord]
  Times <- Times[Ord]
  Lineages <- cumsum(Change)
  Out <- approx(x = rev(Times),
                y = rev(Lineages),
                xout = TimeVec,
                method = 'constant',
                yright = 0)$y
  return(Out)
}

# Function to calculate highest posterior density intervals
getHPD <- function(x, Prob = 0.95) {
  if (sum(!is.na(x)) > 1) {
    Out <- HPDinterval(as.mcmc(x), prob = Prob)[1:2]
  }
  else {
    Out <- c(NA, NA)
  }
  return(Out)
}

# Function to identify non-zero regions in the data
isNotZero <- function(x) {
  L <- length(x)
  NotZero <- rep(TRUE, L)
  not0 <- which(x != 0 & !is.na(x))
  m <- min(not0)
  if (m > 1 || x[m] == 0 || is.na(x[m])) {
    NotZero[1:(m - 1)] <- FALSE
  }
  M <- max(not0)
  if (M < L) {
    NotZero[(M + 1):L] <- FALSE
  }
  return(NotZero)
}

# Parse command line arguments
args <- parse_args()

# Define time vector for LTT calculation
TimeVecLtt <- seq(300, 190, by = -0.01)

# Perform initial validation checks
cat("Validation checks:\n")

# Check for missing files
missing_files <- c()
for (i in 1:args$num_replicates) {
  filename <- file.path(args$path,
                        paste0(args$prefix, i, args$file_pattern))
  if (!file.exists(filename)) {
    missing_files <- c(missing_files, filename)
  }
}
if (length(missing_files) > 0) {
  stop(sprintf("Missing files:\n%s", paste(missing_files, collapse="\n")))
}

# Calculate and report memory requirements
points_per_curve <- length(TimeVecLtt)
total_curves <- args$num_replicates * args$thin_to
estimated_memory_mb <- (points_per_curve * total_curves * 8) / (1024^2)

cat(sprintf("Time points per curve: %d\n", points_per_curve))
cat(sprintf("Total curves to generate: %d\n", total_curves))
cat(sprintf("Estimated memory requirement: %.2f MB\n", estimated_memory_mb))

if (estimated_memory_mb > 1000) {  # Warning if over 1GB
  warning(sprintf("This operation may require %.2f GB of memory", estimated_memory_mb/1024))
  readline("Press Enter to continue or Ctrl+C to abort...")
}

# Initialize matrix for LTT curves
Ltt <- matrix(NA_real_,
              ncol = args$num_replicates * args$thin_to,
              nrow = length(TimeVecLtt))

# Process MCMC samples
Counter <- 1
cat("Starting MCMC processing...\n")
monitor_memory()

for (i in 1:args$num_replicates) {
  cat(sprintf("\nProcessing replicate %d of %d\n", i, args$num_replicates))
  
  filename <- file.path(args$path,
                        paste0(args$prefix, i, args$file_pattern))
  
  cat(sprintf("Reading file: %s\n", filename))
  McmcLog <- read.table(filename, header = TRUE, sep = '\t')
  cat(sprintf("Read %d rows from MCMC log\n", nrow(McmcLog)))
  
  McmcLog <- removeBurnin(McmcLog, Burnin = args$burnin)
  cat(sprintf("After burnin: %d rows\n", nrow(McmcLog)))
  
  McmcLog <- applyThin(McmcLog, Thin = args$thin_to)
  cat(sprintf("After thinning: %d rows\n", nrow(McmcLog)))
  
  monitor_memory()
  
  ColnamesLog <- colnames(McmcLog)
  IdxTs <- grepl('_TS', ColnamesLog)
  IdxTe <- grepl('_TE', ColnamesLog)
  
  cat("Processing individual MCMC samples...\n")
  for (j in 1:nrow(McmcLog)) {
    if (j %% 10 == 0) {  # Show progress every 10 samples
      cat(sprintf("\rProcessing sample %d of %d", j, nrow(McmcLog)))
    }
    
    Ltt[, Counter] <- getLtt(Ts = McmcLog[j, IdxTs] + args$translate,
                             Te = McmcLog[j, IdxTe] + args$translate,
                             TimeVecLtt)
    Counter <- Counter + 1
  }
  cat("\n")  # New line after sample processing
}

# Calculate credible intervals
LttCI95 <- apply(Ltt, 1, function(x) getHPD(x))
LttCI75 <- apply(Ltt, 1, function(x) getHPD(x, Prob = 0.75))
LttMean <- rowMeans(Ltt, na.rm = TRUE)
NotZero <- isNotZero(LttCI95[2, ])

# Create data frame for plotting
diversity_df <- data.frame(
  time = -TimeVecLtt,
  mean_diversity = LttMean,
  lower_95 = LttCI95[1, ],
  upper_95 = LttCI95[2, ],
  lower_75 = LttCI75[1, ],
  upper_75 = LttCI75[2, ]
)

# Format axis labels
format_labels <- function(x) {
  return(sprintf("%.0f", abs(x)))
}

# Create plot
p2 <- ggplot(diversity_df[NotZero, ], aes(x = time)) +
  geom_step(aes(y = mean_diversity), color = 'purple', size = 1) +
  geom_ribbon(aes(ymin = lower_95, ymax = upper_95), 
              fill = adjustcolor('purple', alpha = 0.15)) +
  geom_ribbon(aes(ymin = lower_75, ymax = upper_75), 
              fill = adjustcolor('purple', alpha = 0.15)) +
  coord_geo(xlim = c(-300, -190), 
            expand = FALSE, 
            clip = "on",
            dat = list("international epochs", "international periods"),
            abbrv = list(TRUE, FALSE),
            pos = list("bottom", "bottom"),
            alpha = 1,
            height = unit(2, "line"),
            rot = 0,
            size = list(6, 5),
            neg = TRUE) +
  geom_vline(xintercept = c(-65, -200, -251, -367, -445),
             linetype = "dashed", 
             color = "gray") +
  scale_x_continuous(limits = c(-300, -190),
                     breaks = seq(-300, -190, by = 10),
                     labels = format_labels) +
  labs(title = args$title,
       x = "Time (Ma)",
       y = "Number of Taxa") +
  theme_classic() +
  theme(plot.margin = unit(c(2, 1, 1, 1), "cm"),
        plot.title = element_text(size = 32, 
                                  face = "bold", 
                                  hjust = 0.5, 
                                  margin = margin(b = 30)),
        axis.title = element_text(size = 24, 
                                  face = "bold", 
                                  margin = margin(t = 20, r = 20, b = 20, l = 20)),
        axis.text = element_text(size = 20, face = "bold"))

# Save the plot to PDF in the specified directory
output_path <- file.path(args$path, args$output)
pdf(output_path, width = 20, height = 20)
grid.arrange(p2, ncol = 1)
dev.off()

# Print completion message with full path
cat(sprintf("Analysis complete. Plot saved to: %s\n", output_path))