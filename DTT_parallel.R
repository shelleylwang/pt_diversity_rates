#' Diversity Through Time (DTT) Function - Optimized Version
#' 
#' This function calculates and plots diversity trajectories with uncertainty from MCMC outputs
#' It processes mcmc.log files from PyRate analyses to create diversity through time plots.
#' The function is optimized for speed and memory usage, and can use parallel processing.
#' The plot uses the deeptime R package for geological time scale visualization, with vertical
#' lines at major extinction events
#' 
#' This version can be sourced and used in another R script, or can be called from the command line
#' 
#' Example usage in an R script:
#' \preformatted{
#' source("DTT_parallel.R")
#' plot_diversity_through_time(path = "./mcmc_results", thin_to = 20, burnin = 0.1, output = "results.pdf")
#' }
#' 
#'
#' @param path Path to directory containing MCMC files (default: '.')
#' @param thin_to Thin each MCMC log's samples to this number (default: 100)
#' @param burnin Proportion of samples to discard as burnin (default: 0.15)
#' @param translate Time translation value in Ma (default: 0). Necessary if the original PyRate run used the -translate flag
#' @param output Output PDF filename (default: 'DTT.pdf')
#' @param title Plot title (default: 'Diversity Through Time (# Genera)')
#' @param time_start Start time for analysis in positive Ma (default: 320)
#' @param time_end End time for analysis in positive Ma (default: 190)
#' @param time_by Time increment for analysis in Ma (default: 0.01 (10 Ma)) 
#' @param save_plot Whether to save the plot to a file (default: TRUE)
#' @param return_data Whether to return the diversity data frame (default: FALSE)
#' @param parallel Use parallel processing if available (default: TRUE)
#' @param cores Number of cores to use for parallel processing (default: detectCores() - 1)
#' @return If return_data is TRUE, returns a data frame with diversity values and credible intervals
#'
plot_diversity_through_time <- function(path = ".", 
                                        thin_to = 100,
                                        burnin = 0.15,
                                        translate = 0,
                                        output = "DTT.pdf",
                                        title = "Diversity Through Time (# Genera)",
                                        time_start = 320,
                                        time_end = 190,
                                        time_by = 0.01,
                                        save_plot = TRUE,
                                        return_data = FALSE,
                                        parallel = TRUE,
                                        cores = NULL) {
  
  # Load required libraries with suppressed startup messages
  suppressPackageStartupMessages({
    require(coda)      # For statistical analysis
    require(ggplot2)   # For plotting
    require(gridExtra) # For plot arrangement
    require(deeptime)  # For geological time scale visualization
    require(data.table) # For faster data manipulation
    if (parallel) {
      require(parallel)   # For parallel processing
      require(doParallel) # For foreach parallel backend
      require(foreach)    # For parallel foreach loops
    }
  })
  
  # Setup parallel processing if requested
  if (parallel) {
    if (is.null(cores)) {
      cores <- max(1, parallel::detectCores() - 1)
    }
    cl <- makeCluster(cores)
    registerDoParallel(cl)
    on.exit(stopCluster(cl), add = TRUE)
    cat(sprintf("Using %d cores for parallel processing\n", cores))
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
      ThinIdx <- ceiling(seq(1, N, by = N/Thin))
      L <- L[ThinIdx[ThinIdx <= N], ]
    }
    return(L)
  }
  
  # Function to calculate lineage through time values - vectorized version
  getLtt <- function(Ts, Te, TimeVec) {
    # Convert inputs to vectors to ensure consistent handling
    Ts <- as.numeric(unlist(Ts))
    Te <- as.numeric(unlist(Te))
    
    # Create change points and sort
    ChangeTe <- rep(-1, length(Te))
    ChangeTe[Te == 0.0] <- 0
    Change <- c(rep(1, length(Ts)), ChangeTe)
    Times <- c(Ts, Te)
    Ord <- order(Times, decreasing = TRUE)
    Change <- Change[Ord]
    Times <- Times[Ord]
    
    # Calculate lineages through time
    Lineages <- cumsum(Change)
    
    # Interpolate for the time vector
    Out <- approx(x = -Times,
                  y = Lineages,
                  xout = -TimeVec,
                  method = 'constant',
                  yleft = 0)$y
    return(Out)
  }
  
  # Function to calculate highest posterior density intervals - more efficient implementation
  getHPD <- function(x, Prob = 0.95) {
    x <- x[!is.na(x)]
    if (length(x) > 1) {
      x_sorted <- sort(x)
      n <- length(x)
      
      # Calculate window width for specified probability
      width <- ceiling(Prob * n)
      
      # Find minimum interval width
      if (width < n) {
        window_width <- x_sorted[(width):n] - x_sorted[1:(n-width+1)]
        min_idx <- which.min(window_width)
        return(c(x_sorted[min_idx], x_sorted[min_idx + width - 1]))
      } else {
        return(c(min(x), max(x)))
      }
    } else if (length(x) == 1) {
      return(c(x, x))
    } else {
      return(c(NA, NA))
    }
  }
  
  # Function to identify non-zero regions in the data
  isNotZero <- function(x) {
    L <- length(x)
    # Create a logical vector and fill it with TRUE
    NotZero <- rep(TRUE, L)
    not0 <- which(x != 0 & !is.na(x))
    
    # Check if there are no non-zero values - this likely means translate parameter was missed
    if (length(not0) == 0) {
      stop("No non-zero diversity values found. You likely forgot to use the translate parameter (-tr or translate=). This parameter should be the inverse of (negation of) the value used with the -translate argument in PyRate. If you used -translate -10 in PyRate, use translate = 10 or -tr 10")
    }
    
    # Set values outside the valid range to FALSE
    if (min(not0) > 1) NotZero[1:(min(not0) - 1)] <- FALSE
    if (max(not0) < L) NotZero[(max(not0) + 1):L] <- FALSE
    
    return(NotZero)
  }
  
  # Define time vector for LTT calculation - precompute once
  TimeVecLtt <- seq(time_start, time_end, by = -time_by)
  
  # Find all mcmc.log files in the directory
  cat("Finding mcmc.log files...\n")
  all_files <- list.files(path = path, pattern = "mcmc\\.log$", full.names = TRUE)
  
  # Filter out files containing "combined"
  mcmc_files <- all_files[!grepl("combined", all_files)]
  
  if (length(mcmc_files) == 0) {
    stop("No suitable mcmc.log files found in the specified directory. Check two things: 1. The directory path, 2. that the mcmc.log files do not contain the word 'combined' in the file name, as this disqualifies them from processing. Change the file name if necessary.")
  }
  
  cat(sprintf("Found %d mcmc.log files to process.\n", length(mcmc_files)))
  
  # Preallocate space for results
  num_time_points <- length(TimeVecLtt)
  expected_curves <- length(mcmc_files) * thin_to
  
  # Process MCMC samples - main processing loop
  cat("Starting MCMC processing...\n")
  
  # Process files in parallel if requested
  if (parallel) {
    cat("Processing files in parallel...\n")
    
    # Process each file in parallel
    results <- foreach(i = 1:length(mcmc_files), 
                       .packages = c("data.table"),
                       .combine = 'cbind',
                       .errorhandling = 'remove') %dopar% {
                         
                         filename <- mcmc_files[i]
                         file_basename <- basename(filename)
                         cat(sprintf("Processing file %d of %d: %s\n", i, length(mcmc_files), file_basename))
                         
                         # Try first with UTF-8 encoding, then with ANSI (Windows-1252) if that fails
                         McmcLog <- tryCatch({
                           fread(filename, header = TRUE, sep = '\t', encoding = "UTF-8")
                         }, error = function(e) {
                           cat(sprintf("UTF-8 encoding failed for %s, trying Windows-1252 encoding...\n", file_basename))
                           fread(filename, header = TRUE, sep = '\t', encoding = "Windows-1252")
                         })
                         
                         # Convert to data.frame to maintain compatibility with the rest of the code
                         McmcLog <- as.data.frame(McmcLog)
                         initial_rows <- nrow(McmcLog)
                         cat(sprintf("File %s: Read %d rows from MCMC log\n", file_basename, initial_rows))
                         
                         # Apply burnin and thinning
                         McmcLog <- removeBurnin(McmcLog, Burnin = burnin)
                         after_burnin_rows <- nrow(McmcLog)
                         cat(sprintf("File %s: After burnin: %d rows (removed %d rows)\n", 
                                     file_basename, after_burnin_rows, initial_rows - after_burnin_rows))
                         
                         McmcLog <- applyThin(McmcLog, Thin = thin_to)
                         after_thinning_rows <- nrow(McmcLog)
                         cat(sprintf("File %s: After thinning: %d rows (thinned %d rows to %d rows)\n", 
                                     file_basename, after_thinning_rows, after_burnin_rows, after_thinning_rows))

                         
                         # Find TS and TE columns
                         ColnamesLog <- colnames(McmcLog)
                         IdxTs <- grep('_TS', ColnamesLog)
                         IdxTe <- grep('_TE', ColnamesLog)
                         
                         
                         # Notify user if a file had no TS or TE columns, and therefore was skipped
                         if (length(IdxTs) == 0 || length(IdxTe) == 0) {
                           warning(sprintf("File %s does not contain TS or TE columns, skipping.", basename(filename)))
                           return(NULL)
                         }
                         
                         # Process each MCMC sample and calculate LTT
                         ltt_results <- matrix(NA_real_, nrow = num_time_points, ncol = nrow(McmcLog))
                         
                         for (j in 1:nrow(McmcLog)) {
                           ltt_results[, j] <- getLtt(
                             Ts = McmcLog[j, IdxTs] + translate,
                             Te = McmcLog[j, IdxTe] + translate,
                             TimeVecLtt
                           )
                         }
                         
                         return(ltt_results)
                       }
    
    # Process results if not empty
    if (!is.null(results) && ncol(results) > 0) {
      Ltt <- results
      cat(sprintf("Parallel processing completed: generated %d LTT curves\n", ncol(Ltt)))
    } else {
      stop("No valid data could be processed from the MCMC files")
    }
    
  } else {
    # Sequential processing
    Ltt <- matrix(NA_real_, nrow = num_time_points, ncol = expected_curves)
    Counter <- 1
    
    for (i in 1:length(mcmc_files)) {
      filename <- mcmc_files[i]
      file_basename <- basename(filename)
      
      cat(sprintf("\nProcessing file %d of %d: %s\n", i, length(mcmc_files), file_basename))
      
      tryCatch({
        # Try first with UTF-8 encoding, then with ANSI (Windows-1252) if that fails
        McmcLog <- tryCatch({
          data.table::fread(filename, header = TRUE, sep = '\t', encoding = "UTF-8")
        }, error = function(e) {
          cat(sprintf("UTF-8 encoding failed, trying Windows-1252 (ANSI) encoding...\n"))
          data.table::fread(filename, header = TRUE, sep = '\t', encoding = "Windows-1252")
        })
        
        # Convert to data.frame
        McmcLog <- as.data.frame(McmcLog)
        cat(sprintf("Read %d rows from MCMC log\n", nrow(McmcLog)))
        
        McmcLog <- removeBurnin(McmcLog, Burnin = burnin)
        cat(sprintf("After burnin: %d rows\n", nrow(McmcLog)))
        
        McmcLog <- applyThin(McmcLog, Thin = thin_to)
        cat(sprintf("After thinning: %d rows\n", nrow(McmcLog)))
        
        ColnamesLog <- colnames(McmcLog)
        IdxTs <- grep('_TS', ColnamesLog)
        IdxTe <- grep('_TE', ColnamesLog)
        
        # Check if we have TS and TE columns
        if (length(IdxTs) == 0 || length(IdxTe) == 0) {
          warning(sprintf("File %s does not contain TS or TE columns, skipping.", file_basename))
          next
        }
        
        cat("Processing individual MCMC samples...\n")
        for (j in 1:nrow(McmcLog)) {
          if (j %% 10 == 0) {  # Show progress every 10 samples
            cat(sprintf("\rProcessing sample %d of %d", j, nrow(McmcLog)))
            flush.console()  # Ensure the message is displayed immediately
          }
          
          # Expand matrix if needed
          if (Counter > ncol(Ltt)) {
            Ltt <- cbind(Ltt, matrix(NA_real_, nrow = num_time_points, ncol = 100))
          }
          
          Ltt[, Counter] <- getLtt(
            Ts = McmcLog[j, IdxTs] + translate,
            Te = McmcLog[j, IdxTe] + translate,
            TimeVecLtt
          )
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
  }
  
  # Calculate statistics from Ltt
  cat("Calculating credible intervals...\n")
  cat(sprintf("Processing statistics for %d x %d matrix (%d curves across %d time points)\n", 
              nrow(Ltt), ncol(Ltt), ncol(Ltt), nrow(Ltt)))
  
  # Use apply2 which is faster for row operations
  LttMean <- rowMeans(Ltt, na.rm = TRUE)
  cat("Calculated mean diversity values\n")
  
  # Calculate credible intervals
  cat("Calculating 95% credible intervals...\n")
  LttCI95 <- t(apply(Ltt, 1, function(x) getHPD(x)))
  cat("Calculating 75% credible intervals...\n")
  LttCI75 <- t(apply(Ltt, 1, function(x) getHPD(x, Prob = 0.75)))
  cat("Finished calculating credible intervals\n")
  
  # Identify non-zero regions
  NotZero <- isNotZero(LttMean)
  
  # Create data frame for plotting
  diversity_df <- data.frame(
    time = -TimeVecLtt,
    mean_diversity = LttMean,
    lower_95 = LttCI95[, 1],
    upper_95 = LttCI95[, 2],
    lower_75 = LttCI75[, 1],
    upper_75 = LttCI75[, 2]
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
  -o OUTPUT             Output PDF filename (default: 'DTT.pdf')
  --title TITLE         Plot title (default: 'Diversity Through Time (# Genera)')
  --time-start VALUE    Start time for analysis in Ma (default: 320)
  --time-end VALUE      End time for analysis in Ma (default: 190)
  --time-by VALUE       Time increment for analysis in Ma (default: 0.01)
  --save-plot VALUE     Whether to save the plot to a file (default: TRUE)
  --return-data VALUE   Whether to return the diversity data frame (default: FALSE)
  --parallel VALUE      Whether to use parallel processing (default: TRUE)
  --cores VALUE         Number of cores to use for parallel processing (default: auto-detect)

Example Command Line usage:
  Rscript DTT.R -p ./mcmc_results -t 20 -b 0.1 -o results.pdf\n")
    quit(save = "no", status = 0)
  }
  
  # Initialize default values for all possible parameters
  params <- list(
    path = ".", # Current Directory
    thin_to = 100,
    burnin = 0.15,
    translate = 0,
    output = "DTT.pdf",
    title = "Diversity Through Time (# Genera)",
    time_start = 320,
    time_end = 190,
    time_by = 0.01,
    save_plot = TRUE,
    return_data = FALSE,
    parallel = TRUE,
    cores = NULL
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
    } else if (args[i] == "--parallel") {
      params$parallel <- as.logical(args[i + 1])
      i <- i + 2
    } else if (args[i] == "--cores") {
      params$cores <- as.integer(args[i + 1])
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
    return_data = params$return_data,
    parallel = params$parallel,
    cores = params$cores
  )
}