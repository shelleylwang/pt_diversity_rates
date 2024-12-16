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

getHPD <- function(x, Prob = 0.95) {
  if (sum(!is.na(x)) > 1) {
    Out <- HPDinterval(as.mcmc(x), prob = Prob)[1:2]
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

Path <- "C:\\Users\\SimoesLabAdmin\\Documents\\BDNN_Arielli\\synapsida\\mcmc_no_predictors\\RJMCMC"

# Number of replicates
NumReplicates <- 10
# Number of subsamples
ThinTo <- 50
# Burnin
Burnin <- 0.25
# Optional translate time towards the past (positive) or the present (negative)
Translate <- 0

# Time steps of the LTT
TimeVecLtt <- seq(190, 300, by = 0.01)

# Matrix to get the LTT for the MCMC samples
Ltt <- matrix(NA_real_,
              ncol = NumReplicates * ThinTo,
              nrow = length(TimeVecLtt))

Counter <- 1
for (i in 1:NumReplicates) {
  McmcLog <- read.table(file.path(Path, 
                                  paste0('synapsida_pyrate_', i,
                                         '_Grj_mcmc.log')),
                        header = TRUE, sep = '\t')

  McmcLog <- removeBurnin(McmcLog, Burnin = Burnin)
  McmcLog <- applyThin(McmcLog, Thin = ThinTo)
  
  ColnamesLog <- colnames(McmcLog)
  IdxTs <- grepl('_TS', ColnamesLog)
  IdxTe <- grepl('_TE', ColnamesLog)
  for (j in 1:nrow(McmcLog)){
    Ltt[, Counter] <- getLtt(Ts = McmcLog[j, IdxTs] + Translate,
                             Te = McmcLog[j, IdxTe] + Translate,
                             TimeVecLtt)
    Counter <- Counter + 1
  }
}

# 95 and 75% credible interval
LttCI95 <- apply(Ltt, 1, function(x) getHPD(x))
LttCI75 <- apply(Ltt, 1, function(x) getHPD(x, Prob = 0.75))

# Mean diversity
LttMean <- rowMeans(Ltt, na.rm = TRUE)

# For plotting, identify time steps where we have diversity > 0
NotZero <- isNotZero(LttCI95[2, ])

# Create data frame for diversity trajectory
diversity_df <- data.frame(
  time = TimeVecLtt,
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
  coord_geo(xlim = c(300, 190), expand = FALSE, clip = "on",
            dat = list("international epochs", "international periods"), abbrv = list(TRUE, FALSE), 
            pos = list("bottom", "bottom"), alpha = 1, height = unit(2, "line"),
            rot = 0, size = list(6, 5), neg = TRUE) +
  geom_ribbon(aes(ymin = lower_95, ymax = upper_95), fill = adjustcolor('purple', alpha = 0.15)) +
  geom_ribbon(aes(ymin = lower_75, ymax = upper_75), fill = adjustcolor('purple', alpha = 0.15)) +
  geom_step(aes(y = mean_diversity), color = 'purple', size = 1) +
  labs(title = "Synapsida Diversity Trajectory",
       x = "Time (Ma)",
       y = "Number of Taxa") +
  geom_vline(xintercept = c(-65, -200, -251, -367, -445), 
            linetype = "dashed", color = "gray") +
  scale_x_continuous(limits = c(300, 190), breaks = seq(300, 190, by = 10), labels = format_labels) +
  theme_classic() +
  theme(plot.margin = unit(c(2, 1, 1, 1), "cm"),
        plot.title = element_text(size = 32, face = "bold", hjust = 0.5, margin = margin(b = 30)),
        axis.title = element_text(size = 24, face = "bold", margin = margin(t = 20, r = 20, b = 20, l = 20)),
        axis.text = element_text(size = 20, face = "bold"))

# Display plot in RStudio
grid.arrange(p2, ncol = 1)

# Save to PDF
pdf("C:\\Users\\SimoesLabAdmin\\Documents\\BDNN_Arielli\\synapsida\\mcmc_no_predictors\\RJMCMC\\synapsida_ltt_uncertainty.pdf", width = 20, height = 20)
grid.arrange(p2, ncol = 1)
dev.off()