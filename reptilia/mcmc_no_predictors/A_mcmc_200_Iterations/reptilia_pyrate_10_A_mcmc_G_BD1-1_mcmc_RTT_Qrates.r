library(scales)


#pdf(file='C:\Users\SimoesLabAdmin\Documents\BDNN_Arielli\reptilia\mcmc_no_predictors\A_mcmc_200_Iterations/reptilia_pyrate_10_A_mcmc_G_BD1-1_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)
#pdf with forward slashes
pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/A_mcmc_200_Iterations/reptilia_pyrate_10_A_mcmc_G_BD1-1_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)

age = c(-298.7179806915973, -290.1)
Q_mean = 0.4914704192839388
Q_hpd_m = 0.21383135328891184
Q_hpd_M = 0.8028296525384132
plot(age,age,type = 'n', ylim = c(0, 15.434177473776183), xlim = c(-298.7179806915973,-198.3418968457304), ylab = 'Preservation rate', xlab = 'Ma',main='Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 4.992603704547469
Q_hpd_m = 4.372612163687658
Q_hpd_M = 5.682841321182362
segments(x0=age[1], y0 = 0.4914704192839388, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 0.5537667467391612
Q_hpd_m = 0.3967935486204011
Q_hpd_M = 0.7240115608602778
segments(x0=age[1], y0 = 4.992603704547469, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 0.9189638180608963
Q_hpd_m = 0.48029082624937575
Q_hpd_M = 1.5535983345526385
segments(x0=age[1], y0 = 0.5537667467391612, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 2.9543342008885367
Q_hpd_m = 1.8018164736063746
Q_hpd_M = 4.582907636526052
segments(x0=age[1], y0 = 0.9189638180608963, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 12.832395723821726
Q_hpd_m = 11.469512158831545
Q_hpd_M = 14.281697834364987
segments(x0=age[1], y0 = 2.9543342008885367, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 1.3572548400302402
Q_hpd_m = 1.097827631009821
Q_hpd_M = 1.620807529299246
segments(x0=age[1], y0 = 12.832395723821726, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 1.5085391683837535
Q_hpd_m = 1.2742959355676713
Q_hpd_M = 1.758111602793556
segments(x0=age[1], y0 = 1.3572548400302402, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 1.6768538696634343
Q_hpd_m = 1.3847299671775362
Q_hpd_M = 1.992771092571713
segments(x0=age[1], y0 = 1.5085391683837535, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.4071806450956975
Q_hpd_m = 0.3411568797398157
Q_hpd_M = 0.4742568402266949
segments(x0=age[1], y0 = 1.6768538696634343, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 0.8132095719651709
Q_hpd_m = 0.7261060756572799
Q_hpd_M = 0.9034636192583836
segments(x0=age[1], y0 = 0.4071806450956975, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 0.8297082649769655
Q_hpd_m = 0.7358663101630556
Q_hpd_M = 0.9253385841336907
segments(x0=age[1], y0 = 0.8132095719651709, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -198.3418968457304)
Q_mean = 1.0974319057100628
Q_hpd_m = 0.9548850255267937
Q_hpd_M = 1.253908475416235
segments(x0=age[1], y0 = 0.8297082649769655, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()