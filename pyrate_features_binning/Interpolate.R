setwd("C:\\Users\\SimoesLabAdmin\\Documents\\pt_diversity_rates\\")

# Read files
#-----------
FixShiftsFile <- file.path("updated_occurrence_analyses", "data", "Perm-Trias",
                           "Time_bins_1myr_and_stages.txt")
FixShifts <- read.table(FixShiftsFile, header = FALSE)[, 1]


BridgeFile <- file.path("updated_occurrence_analyses", "data", "AF_climactic_data",
                       "reptilia_terr_BRIDGE_z_trans_filtered.txt")
Bridge <- read.table(BridgeFile, sep = "\t", header = TRUE)


IsoFile <- file.path("updated_occurrence_analyses", "data", "Perm-Trias",
                     "songEA_isotopic_data_pt_1myr",
                     "isotopic_1myr_binary_stages_timevar.txt")
Iso <- read.table(IsoFile, sep = "\t", header = TRUE, check.names = FALSE)


# Piecewise constant interpolation for Bridge data
#-------------------------------------------------

TimeBinsBridge <- unique(sort(c(FixShifts, Bridge$Time)))

Bridge$MidPoints <- c(198,
                     (Bridge$Time[1:(length(Bridge$Time) - 1)] + 
                        Bridge$Time[2:length(Bridge$Time)]) / 2)

BridgeInter <- data.frame(Time = TimeBinsBridge,
                          mat_z_trans	= NA_real_,
                          map_z_trans	= NA_real_,
                          wmm_z_trans	= NA_real_,
                          cmm_z_trans	= NA_real_,
                          wmmcmm_z_trans	= NA_real_,
                          wetmon_z_trans	= NA_real_,
                          drymon_z_trans	= NA_real_,
                          wetdry_z_trans	= NA_real_,
                          "208-217" = 0,
                          "217-227" = 0,
                          "227-237" = 0,
                          "237-242" = 0,
                          "242-246.7" = 0,
                          "246.7-252" = 0,
                          "252-259.5" = 0,
                          "259.5-264.3" = 0,
                          "264.3-274.4" = 0,
                          "274.4-283.5" = 0,
                          "283.5-290.1" = 0,
                          check.names = FALSE)	

# Interpolation
for (i in 2:(ncol(Bridge) - 1)) {
  BridgeInter[, i] <- approx(x = Bridge$MidPoints,
                             y = Bridge[, i],
                             xout = TimeBinsBridge,
                             method = "constant", rule = 2)$y
}

# One hot encoded stages
BridgeInter$"208-217"[TimeBinsBridge >= 208 & TimeBinsBridge < 217] <- 1
BridgeInter$"217-227"[TimeBinsBridge >= 217 & TimeBinsBridge < 227] <- 1
BridgeInter$"227-237"[TimeBinsBridge >= 227 & TimeBinsBridge < 237] <- 1
BridgeInter$"237-242"[TimeBinsBridge >= 237 & TimeBinsBridge < 242] <- 1
BridgeInter$"242-246.7"[TimeBinsBridge >= 242 & TimeBinsBridge < 246.7] <- 1
BridgeInter$"246.7-252"[TimeBinsBridge >= 246.7 & TimeBinsBridge < 252] <- 1
BridgeInter$"252-259.5"[TimeBinsBridge >= 252 & TimeBinsBridge < 259.5] <- 1
BridgeInter$"259.5-264.3"[TimeBinsBridge >= 259.5 & TimeBinsBridge < 264.3] <- 1
BridgeInter$"264.3-274.4"[TimeBinsBridge >= 264.3 & TimeBinsBridge < 274.4] <- 1
BridgeInter$"274.4-283.5"[TimeBinsBridge >= 274.4 & TimeBinsBridge < 283.5] <- 1
BridgeInter$"283.5-290.1"[TimeBinsBridge >= 283.5 & TimeBinsBridge < 290.1] <- 1

# Write to disk
InterFileBridge <- file.path("updated_occurrence_analyses", "data",
                             "AF_climactic_data",
                             "BRIDGE_and_binary_stages_data",
                             "rep_terr_BRIDGE_stages_timevar_1myr_interpolated.txt")
write.table(BridgeInter, InterFileBridge,
            row.names = FALSE, quote = FALSE, sep = "\t")


# Linear interpolation for isotope data
#--------------------------------------
TimeBinsIso <- unique(sort(c(FixShifts, Iso$Time)))

IsoInter <- data.frame(Time = TimeBinsIso,
                       mean_pt_1myr_z_trans	= NA_real_,
                       Mod_R_deltaTMyr_pt_1myr_z_trans	= NA_real_,
                       "208-217" = 0,
                       "217-227" = 0,
                       "227-237" = 0,
                       "237-242" = 0,
                       "242-246.7" = 0,
                       "246.7-252" = 0,
                       "252-259.5" = 0,
                       "259.5-264.3" = 0,
                       "264.3-274.4" = 0,
                       "274.4-283.5" = 0,
                       "283.5-290.1" = 0,
                       check.names = FALSE)

# Interpolation
for (i in 2:3) {
  IsoInter[, i] <- approx(x = Iso$Time,
                          y = Iso[, i],
                          xout = TimeBinsIso,
                          method = "linear", rule = 2)$y
}

# One hot encoded stages
IsoInter$"208-217"[TimeBinsIso >= 208 & TimeBinsIso < 217] <- 1
IsoInter$"217-227"[TimeBinsIso >= 217 & TimeBinsIso < 227] <- 1
IsoInter$"227-237"[TimeBinsIso >= 227 & TimeBinsIso < 237] <- 1
IsoInter$"237-242"[TimeBinsIso >= 237 & TimeBinsIso < 242] <- 1
IsoInter$"242-246.7"[TimeBinsIso >= 242 & TimeBinsIso < 246.7] <- 1
IsoInter$"246.7-252"[TimeBinsIso >= 246.7 & TimeBinsIso < 252] <- 1
IsoInter$"252-259.5"[TimeBinsIso >= 252 & TimeBinsIso < 259.5] <- 1
IsoInter$"259.5-264.3"[TimeBinsIso >= 259.5 & TimeBinsIso < 264.3] <- 1
IsoInter$"264.3-274.4"[TimeBinsIso >= 264.3 & TimeBinsIso < 274.4] <- 1
IsoInter$"274.4-283.5"[TimeBinsIso >= 274.4 & TimeBinsIso < 283.5] <- 1
IsoInter$"283.5-290.1"[TimeBinsIso >= 283.5 & TimeBinsIso < 290.1] <- 1

# Write to disk
InterFileIso <- file.path("updated_occurrence_analyses", "data", "Perm-Trias",
                          "songEA_isotopic_data_pt_1myr",
                          "isotopic_1myr_binary_stages_timevar_interpolated.txt")
write.table(IsoInter, InterFileIso,
            row.names = FALSE, quote = FALSE, sep = "\t")


#------#
# Plot #
#------#

# Previous piecewise constant interpolation
Mat <- rep(Bridge$mat_z_trans, each = 2)
Time <- c(Bridge$Time, Bridge$Time[2:nrow(Bridge)] - 0.001)
Time[length(Time) + 1] <- 300 
Ord <- order(Time)
Time <- Time[Ord]


png("MAT.png", width = 1200, height = 700, pointsize = 18)
par(las = 1, mar = c(4, 4, 0.5, 0.5))
plot(mat_z_trans ~ Time, data = Bridge, xlim = c(300, 200), type = "n")
B <- par()$usr
rect(xleft = 208, xright = B[2], ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = 217, xright = 208, ybottom = B[3], ytop = B[4],
     border = NA, col = "orange")
rect(xleft = 227, xright = 217, ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = 237, xright = 227, ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = 242, xright = 237, ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = 246.7, xright = 242, ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = 252, xright = 246.7, ybottom = B[3], ytop = B[4],
     border = NA, col = "orange")
rect(xleft = 259.5, xright = 252, ybottom = B[3], ytop = B[4],
     border = NA, col = "orange")
rect(xleft = 264.3, xright = 259.5, ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = 274.4, xright = 264.3, ybottom = B[3], ytop = B[4],
     border = NA, col = "orange")
rect(xleft = 283.5, xright = 274.4, ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = 290.1, xright = 283.5, ybottom = B[3], ytop = B[4],
     border = NA, col = "grey90")
rect(xleft = B[1], xright = 290.1, ybottom = B[3], ytop = B[4],
     border = NA, col = "orange")
abline(v = c(208, 217, 227, 237, 242, 246.7, 252,
             259.5, 264.3, 274.4, 283.5, 290.1),
       lty = 2, lwd = 2, col = "dodgerblue")
lines(mat_z_trans ~ Time, data = Bridge,
      lty = 2, lwd = 4)
lines(Mat ~ Time, lty = 3,
      lwd = 4, col = "purple")
points(mat_z_trans ~ Time, data = Bridge, pch = 19, cex = 1.5)
lines(TimeBinsBridge, BridgeInter$mat_z_trans + 0.01,
      lty = 3, lwd = 4, col = "green3")
dev.off()





