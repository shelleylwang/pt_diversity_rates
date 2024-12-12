library(coda)

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



Path <- "C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_bdnn"

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
                                  paste0('reptilia_pyrate_', i,
                                         '_G_BDS_BDNN_4_2Tc_mcmc.log')),
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
# (not needed in this example but polygons are ugly
#  when there are times without any taxon)
NotZero <- isNotZero(LttCI95[2, ])


par(las = 1, mar = c(4, 4, 0.5, 0.5))
plot(0, 0, type = 'n', ylab = 'Taxa (N)', xlab = 'Time (Ma)',
     xlim = c(max(TimeVecLtt), 0.0), ylim = c(-5, max(LttCI95, na.rm = TRUE)))
# 95% credible interval
polygon(c(TimeVecLtt[NotZero], rev(TimeVecLtt[NotZero])), 
        c(LttCI95[1, NotZero], rev(LttCI95[2, NotZero])),
        col = adjustcolor('purple', alpha = 0.15), border = NA)
# 75% credible interval
polygon(c(TimeVecLtt[NotZero], rev(TimeVecLtt[NotZero])), 
        c(LttCI75[1, NotZero], rev(LttCI75[2, NotZero])),
        col = adjustcolor('purple', alpha = 0.15), border = NA)
# Mean diversity
lines(TimeVecLtt[NotZero], LttMean[NotZero],
      type = 's', col = 'purple', lwd = 2)

print(p)