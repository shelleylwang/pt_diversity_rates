#' Diversity Through Time (DTT) Function
#'
#' This function calculates and plots diversity trajectories with uncertainty from MCMC outputs.
#' It processes mcmc.log files from PyRate analyses to create diversity through time plots.
#' The central plotting code was written by Dr. Torsten Hauffe, while changes, additional functional, formatting, and
#' command-line calls + function format (reusability) was added later
#'
#' @param path Path to directory containing MCMC files (default: '.')
#' @param thin_to Thin each MCMC log's samples to this number (default: 100)
#' @param burnin Proportion of samples to discard as burnin (default: 0.15)
#' @param translate Time translation value in Ma (default: 0)
#' @param output Output PDF filename (default: 'diversity_trajectory.pdf')
#' @param title Plot title (default: 'Diversity Through Time (# Genera)')
#' @param time_start Start time for analysis in Ma (default: 320)
#' @param time_end End time for analysis in Ma (default: 190)
#' @param time_by Time increment for analysis in Ma (default: 0.01) 
#' @param save_plot Whether to save the plot to a file (default: TRUE)
#' @param return_data Whether to return the diversity data frame (default: FALSE)
#' @return If return_data is TRUE, returns a data frame with diversity values and credible intervals
#'
#' @examples
#' # CALLING THE FUNCTION IN ANOTHER R SCRIPT
#' source("DTT_2.R")
#' 
#' # Default parameters
#' plot_diversity_through_time()
#'
#' # Custom parameters
#' plot_diversity_through_time(
#'   path = "./reptilia/mcmc_predictors/",
#'   thin_to = 100,
#'   burnin = 0.15,
#'   translate = 175,
#'   output = "reptilia_ltt_with_uncertainty.pdf",
#'   title = "Reptilia BDNN 1 Myr Global Diversity Trajectory",
#'   time_start = 320,
#'   time_end = 190
#' )
#'
#' # Return data instead of plotting
#' diversity_data <- plot_diversity_through_time(return_data = TRUE, save_plot = FALSE)
#' 
#' # CALLING FROM THE COMMAND LINE
#' # Run the script with default parameters
#' Rscript DTT_2.R -p ./mcmc_results -t 20 -b 0.2 -o results.pdf
#'
plot_diversity_through_time <- function(path = ".", 
                                        thin_to = 100,
                                        burnin = 0.15,
                                        translate = 0,
                                        output = "diversity_trajectory.pdf",
                                        title = "Diversity Through Time (# Genera)",
                                        time_start = 320,
                                        time_end = 190,
                                        time_by = 0.01,
                                        save_plot = TRUE,
                                        return_data = FALSE) {
  
  # Load required libraries with suppressed startup messages
  suppressPackageStartupMessages({
    require(coda)      # For statistical analysis
    require(ggplot2)   # For plotting
    require(gridExtra) # For plot arrangement
    require(deeptime)  # For geological time scale visualization
  })
  
  # Helper function to monitor memory usage
  monitor_memory <- function() {
    mem_used <- gc()  # Force garbage collection and get memory stats
    cat(sprintf("Memory used: %.2f MB\n", mem_used[2,2] * 0.001))
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
    Out <- approx(x = -Times,
                  y = Lineages,
                  xout = -TimeVec,
                  method = 'constant',
                  yleft = 0)$y
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
    
    # Check if there are no non-zero values - this likely means translate parameter was missed
    if (length(not0) == 0) {
      stop("No non-zero diversity values found. You likely forgot to use the translate parameter (-tr or translate=). This parameter should be the inverse of (negation of) the value used with the -translate argument in PyRate. If you used -translate -10 in PyRate, use translate = 10 or -tr 10")
    }
    
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
  
  # Define time vector for LTT calculation
  TimeVecLtt <- seq(time_start, time_end, by = -time_by)
  
  # Find all mcmc.log files in the directory
  all_files <- list.files(path = path, pattern = "mcmc\\.log$", full.names = TRUE)
  
  # Filter out files containing "combined"
  mcmc_files <- all_files[!grepl("combined", all_files)]
  
  if (length(mcmc_files) == 0) {
    stop("No suitable mcmc.log files found in the specified directory. Check that the mcmc.log files do not contain the word 'combined' in the file name, as this disqualifies them from processing. Change the file name if necessary.")
  }
  
  cat(sprintf("Found %d mcmc.log files to process.\n", length(mcmc_files)))
  
  # Calculate expected number of samples precisely
  expected_curves <- length(mcmc_files) * thin_to
  
  # Add a 10% buffer to account for any possible variations
  max_curves <- ceiling(expected_curves * 1.1)
  
  cat(sprintf("Expected to generate %d curves, allocating space for %d (10%% buffer).\n", 
              expected_curves, max_curves))
  
  # Perform initial validation checks
  cat("Validation checks:\n")
  
  # Calculate and report memory requirements
  points_per_curve <- length(TimeVecLtt)
  estimated_total_curves <- length(mcmc_files) * thin_to
  estimated_memory_mb <- (points_per_curve * estimated_total_curves * 8) / (1024^2)
  
  cat(sprintf("Time points per curve: %d\n", points_per_curve))
  cat(sprintf("Estimated total curves to generate: %d\n", estimated_total_curves))
  cat(sprintf("Estimated memory requirement: %.2f MB\n", estimated_memory_mb))
  
  if (estimated_memory_mb > 1000) {  # Warning if over 1GB
    warning(sprintf("This operation may require %.2f GB of memory", estimated_memory_mb/1024))
  }
  
  # Initialize matrix for LTT curves with an estimated size
  Ltt <- matrix(NA_real_,
                ncol = max_curves,
                nrow = length(TimeVecLtt))
  
  # Process MCMC samples
  Counter <- 1
  cat("Starting MCMC processing...\n")
  monitor_memory()
  
  for (i in 1:length(mcmc_files)) {
    filename <- mcmc_files[i]
    file_basename <- basename(filename)
    
    cat(sprintf("\nProcessing file %d of %d: %s\n", i, length(mcmc_files), file_basename))
    
    tryCatch({
      cat(sprintf("Reading file: %s\n", filename))
      # Try first with UTF-8 encoding, then with ANSI (Windows-1252) if that fails
      McmcLog <- tryCatch({
        read.table(filename, header = TRUE, sep = '\t', fileEncoding = "UTF-8")
      }, error = function(e) {
        cat(sprintf("UTF-8 encoding failed, trying Windows-1252 (ANSI) encoding...\n"))
        read.table(filename, header = TRUE, sep = '\t', fileEncoding = "Windows-1252")
      })    
      cat(sprintf("Read %d rows from MCMC log\n", nrow(McmcLog)))
      
      McmcLog <- removeBurnin(McmcLog, Burnin = burnin)
      cat(sprintf("After burnin: %d rows\n", nrow(McmcLog)))
      
      McmcLog <- applyThin(McmcLog, Thin = thin_to)
      cat(sprintf("After thinning: %d rows\n", nrow(McmcLog)))
      
      monitor_memory()
      
      ColnamesLog <- colnames(McmcLog)
      IdxTs <- grepl('_TS', ColnamesLog)
      IdxTe <- grepl('_TE', ColnamesLog)
      
      # Check if we have TS and TE columns
      if (sum(IdxTs) == 0 || sum(IdxTe) == 0) {
        warning(sprintf("File %s does not contain TS or TE columns, skipping.", file_basename))
        next
      }
      
      cat("Processing individual MCMC samples...\n")
      for (j in 1:nrow(McmcLog)) {
        if (j %% 10 == 0) {  # Show progress every 10 samples
          cat(sprintf("\rProcessing sample %d of %d", j, nrow(McmcLog)))
        }
        
        # Check if we're about to exceed the buffer
        if (Counter > max_curves) {
          stop(sprintf("Error: Exceeded allocated matrix size (%d). Increase buffer percentage.", max_curves))
        }
        
        Ltt[, Counter] <- getLtt(Ts = McmcLog[j, IdxTs] + translate,
                                 Te = McmcLog[j, IdxTe] + translate,
                                 TimeVecLtt)
        Counter <- Counter + 1
      }
      cat("\n")  # New line after sample processing
    }, error = function(e) {
      warning(sprintf("Error processing file %s: %s", file_basename, e$message))
    })
  }
  
  # Trim any unused columns in Ltt
  if (Counter <= ncol(Ltt)) {
    Ltt <- Ltt[, 1:(Counter-1)]
    cat(sprintf("Trimmed Ltt matrix to %d columns\n", ncol(Ltt)))
  }
  
  # Calculate credible intervals
  cat("Calculating credible intervals...\n")
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
  
  # If only returning data, skip plotting
  if (return_data) {
    return(diversity_df)
  }
  
  # Format axis labels
  format_labels <- function(x) {
    return(sprintf("%.0f", abs(x)))
  }
  
  # Create plot
  cat("Creating plot...\n")
  p2 <- ggplot(diversity_df[NotZero, ], aes(x = time)) +
    geom_step(aes(y = mean_diversity), color = 'purple', linewidth = 1) +
    geom_ribbon(aes(ymin = lower_95, ymax = upper_95), 
                fill = adjustcolor('purple', alpha = 0.15)) +
    geom_ribbon(aes(ymin = lower_75, ymax = upper_75), 
                fill = adjustcolor('purple', alpha = 0.15)) +
    coord_geo(xlim = c(-time_start, -time_end), 
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
    geom_vline(xintercept = c(-65, -200, -251, -367, -445),  # Major mass extinctions
               linetype = "dashed", 
               color = "gray") +
    scale_x_continuous(limits = c(-time_start, -time_end),
                       breaks = seq(-time_start, -time_end, by = 10),
                       labels = format_labels) +
    labs(title = title,
         x = "Time (Ma)",
         y = "Diversity Through Time (# Genera)") +
    theme_classic() +
    theme(plot.margin = unit(c(2, 1, 1, 1), "cm"),
          plot.title = element_text(size = 36, 
                                    face = "bold", 
                                    hjust = 0.5, 
                                    margin = margin(b = 30)),
          axis.title.x = element_text(size = 28, 
                                      face = "bold", 
                                      margin = margin(t = 50)),
          axis.title.y = element_text(size = 28, 
                                      face = "bold", 
                                      margin = margin(r = 45)),
          axis.text = element_text(size = 24, face = "bold"))
  
  if (save_plot) {
    # Save the plot to PDF in the specified directory
    output_path <- file.path(path, output)
    cat(sprintf("Saving plot to: %s\n", output_path))
    pdf(output_path, width = 20, height = 16)
    grid.arrange(p2, ncol = 1)
    dev.off()
    
    # Print completion message with full path
    cat(sprintf("Analysis complete. Plot saved to: %s\n", output_path))
  }
  
  # Return the plot object
  return(p2)
}

# Example usage when script is run directly
if (sys.nframe() == 0) {
  # Parse command line arguments
  args <- commandArgs(trailingOnly = TRUE)
  
  # Show help if requested
  if (length(args) == 0 || "-h" %in% args || "--help" %in% args) {
    cat("Usage: Rscript DTT.R [options]
    
Options:
  -h, --help            Show this help message and exit
  -p PATH               Path to directory containing MCMC files (default: '.')
  -t THIN_TO            Thin each MCMC log's samples to this number (default: 100)
  -b BURNIN             Proportion of samples to discard as burnin (default: 0.15)
  -tr TRANSLATE         Time translation value in Ma (default: 0). 
                        Use this if the -translate argument was used in the original PyRate run. 
                        It should = the negative of the PyRate -translate argument value 
  -o OUTPUT             Output PDF filename (default: 'diversity_trajectory.pdf')
  --title TITLE         Plot title (default: 'Diversity Through Time (# Genera)')
  --time-start VALUE    Start time for analysis in Ma (default: 320)
  --time-end VALUE      End time for analysis in Ma (default: 190)
  --time-by VALUE       Time increment for analysis in Ma (default: 0.01)
  --save-plot VALUE     Whether to save the plot to a file (default: TRUE)
  --return-data VALUE   Whether to return the diversity data frame (default: FALSE)

Example:
  Rscript DTT.R -p ./mcmc_results -t 20 -b 0.2 -o results.pdf\n")
    quit(save = "no", status = 0)
  }
  
  # Initialize default values for all possible parameters
  params <- list(
    path = ".", # Current Directory
    thin_to = 100,
    burnin = 0.15,
    translate = 0,
    output = "diversity_trajectory.pdf",
    title = "Diversity Through Time (# Genera)",
    time_start = 320,
    time_end = 190,
    time_by = 0.01,
    save_plot = TRUE,
    return_data = FALSE
  )
  
  # Parse command line arguments
  i <- 1
  while (i <= length(args)) {
    if (args[i] == "-p") {
      params$path <- args[i + 1]
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
    } else if (args[i] == "--time-start") {
      params$time_start <- as.numeric(args[i + 1])
      i <- i + 2
    } else if (args[i] == "--time-end") {
      params$time_end <- as.numeric(args[i + 1])
      i <- i + 2
    } else if (args[i] == "--time-by") {
      params$time_by <- as.numeric(args[i + 1])
      i <- i + 2
    } else if (args[i] == "--save-plot") {
      params$save_plot <- as.logical(args[i + 1])
      i <- i + 2
    } else if (args[i] == "--return-data") {
      params$return_data <- as.logical(args[i + 1])
      i <- i + 2
    } else {
      warning(paste("Unknown argument:", args[i]))
      i <- i + 1
    }
  }
  
  # Call the function with command line arguments
  plot_diversity_through_time(
    path = params$path,
    thin_to = params$thin_to,
    burnin = params$burnin,
    translate = params$translate,
    output = params$output,
    title = params$title,
    time_start = params$time_start,
    time_end = params$time_end,
    time_by = params$time_by,
    save_plot = params$save_plot,
    return_data = params$return_data
  )
}