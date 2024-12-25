library(coda)
library(ggplot2)
library(gridExtra)
library(deeptime)

setwd("c:/Users/SimoesLabAdmin/Documents/BDNN_Arielli")

removeBurnin <- function(L, Burnin) {
  L <- L[-c(1:round(nrow(L) * Burnin)), ]
  return(L)
}

applyThin <- function(L, Thin = 0) {
  if (Thin > 0) {
    N <- nrow(L)
    ThinIdx <- floor(seq(1, N, by = N/Thin))
    L <- L[ThinIdx, ]
  }
  return(L)
}
 # Function to calculate the Lineage Through Time curve
getLtt <- function(Ts, Te, TimeVec) {
  Ts <- unlist(Ts) # Convert Ts to a vector
  Te <- unlist(Te)
  ChangeTe <- rep(-1, length(Te)) # Initialize a vector of -1s with the same length as the number of extinction times. Each -1 = death of a lineage
  ChangeTe[Te == 0.0] <- 0 # If the extinction time is 0, set the corresponding value in ChangeTe to 0, which means the lineage is still alive
  Change <- c(rep(1, length(Ts)), ChangeTe) # Concatenate vectors of 1s (addition of a lineage) and -1s or 0's (extinction of a lineage) into one vector
  Times <- c(Ts, Te) # Concatenate vectors of speciation and extinction times
  Ord <- order(Times, decreasing = TRUE) # Order the times in descending order
  Change <- Change[Ord] # Reorder the changes in lineages according to the ordered times
  Times <- Times[Ord] # Reorder the times
  Lineages <- cumsum(Change) # Calculate the cumulative sum of the changes in lineages  = the number of lineages at each time point
  Out <- approx(x = rev(Times), # Interpolate the number of lineages at each time point in TimeVec
                # x = time points in ascending order
                y = rev(Lineages),# The number of lineages at each time point
                xout = TimeVec,# The time points at which the LTT curve will be calculated
                method = 'constant', # Interpolation method
                yright = 0)$y # Value to return if xout is greater than the maximum x value
  return(Out)
}

# Get credible interval
getHPD <- function(x, Prob = 0.95) {
  if (sum(!is.na(x)) > 1) {
    Out <- HPDinterval(as.mcmc(x), prob = Prob)[1:2] # function from the coda library
  }
  else {
    Out <- c(NA, NA)
  }
  return(Out) 
}

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

Path <- "C:\\Users\\SimoesLabAdmin\\Documents\\BDNN_Arielli\\temnospondyli\\mcmc_no_predictors\\RJMCMC"

# Number of replicates
NumReplicates <- 10
# Number of subsamples to be taken from each replicates' MCMC file
ThinTo <- 100
# Burnin (% of each replicates' MCMC file to remove, i.e., number of rows to remove from the beginning of each MCMC file)
Burnin <- 0.15
# Optional translate time towards the past (positive) or the present (negative)
Translate <- 0

# Time steps of the LTT, i.e. the time points at which the LTT curve will be calculated
# The LTT curve is a plot of the number of lineages through time
# The later functions will calculate the number of lineages that exist at 190, then at 190.01, then at 190.02, etc.
TimeVecLtt <- seq(300, 190, by = -0.01)

# Matrix to get the LTT for the MCMC samples
Ltt <- matrix(NA_real_, # Initializing with NA_real_values
              ncol = NumReplicates * ThinTo, # Columns = the number of replicates * the number of subsamples taken from each replicate
              # So each column is one MCMC sample for one replicate. There will be first rep's 100 samps, them the next rep's 100 samps, etc.
              nrow = length(TimeVecLtt)) # Number of rows is the length of TimeVecLtt (the # of time points in the LTT curve)
              # Each row is one time point, the count of lineages across every sample from every replicate
# So this matrix will be = 
# At each x value of the graph (one row), the number of lineages at that time for each of the 10 replicates
# And each MCMC sample (column), the LTT curve for that specific sample of that specific replicate (its # lineages through time)


Counter <- 1
for (i in 1:NumReplicates) { # For each of the 10 replicates, LOOP through the following
  McmcLog <- read.table(file.path(Path, # Read in MCMC log as a dataframe, where each row is an MCMC sample
                                  paste0('temnospondyli_pyrate_', i,
                                         '_Grj_mcmc.log')),
                        header = TRUE, sep = '\t')

  McmcLog <- removeBurnin(McmcLog, Burnin = Burnin) # Remove burn in with function
  McmcLog <- applyThin(McmcLog, Thin = ThinTo) # Thin MCMC log with function
  
  ColnamesLog <- colnames(McmcLog)
  IdxTs <- grepl('_TS', ColnamesLog) # All column names that end with '_TS' (time of speciation) are identified as start times
  IdxTe <- grepl('_TE', ColnamesLog) # All column names that end with '_TE' (time of extinction) are identified as end times
  for (j in 1:nrow(McmcLog)){ # Another loop, iterating over the rows of the thinned McmcLog dataframe. where each row is a thinned MCMC sample
    Ltt[, Counter] <- getLtt(Ts = McmcLog[j, IdxTs] + Translate, # Extract each lineage's ts and te from the jth row of the thinned MCMC log
                             Te = McmcLog[j, IdxTe] + Translate,
                             TimeVecLtt) #getLtt calcuates the LTT curve for the jth MCMC sample (which = one column for the resulting Ltt matrix))
    Counter <- Counter + 1
  }
}

# 95 and 75% credible interval
LttCI95 <- apply(Ltt, 1, function(x) getHPD(x)) # use Ltt matrix (all Ltt curves for all MCMC samples for all replicates), use apply()
# to iterate over all rows and get the 95% HPD interval for each row (each time point in the LTT curve)
LttCI75 <- apply(Ltt, 1, function(x) getHPD(x, Prob = 0.75))

# Mean diversity
LttMean <- rowMeans(Ltt, na.rm = TRUE)

# For plotting, identify time steps where we have diversity > 0
NotZero <- isNotZero(LttCI95[2, ])

# Create data frame for diversity trajectory
diversity_df <- data.frame(
  time = -TimeVecLtt, ## changed to negs
  mean_diversity = LttMean,
  lower_95 = LttCI95[1, ],
  upper_95 = LttCI95[2, ],
  lower_75 = LttCI75[1, ],
  upper_75 = LttCI75[2, ]
)

# Function to format axis labels without negative signs
format_labels <- function(x) {
  return(sprintf("%.0f", abs(x)))
}

# Plot diversity trajectory with ggplot2

p2 <- ggplot(diversity_df[NotZero, ], aes(x = time)) +
  # First define the basic data representation layers
  geom_step(aes(y = mean_diversity), color = 'purple', size = 1) +
  geom_ribbon(aes(ymin = lower_95, ymax = upper_95), fill = adjustcolor('purple', alpha = 0.15)) +
  geom_ribbon(aes(ymin = lower_75, ymax = upper_75), fill = adjustcolor('purple', alpha = 0.15)) +
  
  
  # # Coordinate system and geological time scale
  # coord_geo(xlim = c(300, 190), expand = FALSE, clip = "on",
  #           dat = list("epochs", "periods"), abbrv = list(TRUE, FALSE), 
  #           pos = list("bottom", "bottom"), alpha = 1, height = unit(2, "line"),
  #           rot = 0, size = list(6, 5), neg = TRUE) +
  # Add geological time scale using coord_geo from deeptime
  coord_geo(xlim = c(-300, -190), expand = FALSE, clip = "on", ## changed to negs
           dat = list("international epochs", "international periods"), 
           abbrv = list(TRUE, FALSE), 
           pos = list("bottom", "bottom"), 
           alpha = 1, 
           height = unit(2, "line"),
           rot = 0, 
           size = list(6, 5), 
           neg = T) +
  
  # Add reference lines for key geological boundaries
  geom_vline(xintercept = c(-65, -200, -251, -367, -445), ## changed to negs
             linetype = "dashed", color = "gray") +
  
  # Scale transformation with formatted labels
  scale_x_continuous(limits = c(-300, -190),
                     breaks = seq(-300, -190, by = 10),
                     labels = format_labels) +
  # scale_x_reverse(limits = c(300, 190), 
    #             breaks = seq(300, 190, by = -10), ## original sign (not changed)
     #            labels = format_labels) +
  # Labels and theming come last
  labs(title = "Temnospondyli Diversity Trajectory",
       x = "Time (Ma)",
       y = "Number of Taxa") +
  theme_classic() +
  theme(plot.margin = unit(c(2, 1, 1, 1), "cm"),
        plot.title = element_text(size = 32, face = "bold", hjust = 0.5, margin = margin(b = 30)),
        axis.title = element_text(size = 24, face = "bold", margin = margin(t = 20, r = 20, b = 20, l = 20)),
        axis.text = element_text(size = 20, face = "bold"))

# Display plot in RStudio
grid.arrange(p2, ncol = 1)

# Save to PDF
pdf("C:\\Users\\SimoesLabAdmin\\Documents\\BDNN_Arielli\\temnospondyli\\mcmc_no_predictors\\RJMCMC\\temnospondyli_ltt_uncertainty.pdf", width = 20, height = 20)
grid.arrange(p2, ncol = 1)
dev.off()


