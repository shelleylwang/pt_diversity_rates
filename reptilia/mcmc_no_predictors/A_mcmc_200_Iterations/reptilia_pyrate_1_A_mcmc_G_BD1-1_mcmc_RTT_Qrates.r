library(scales)


pdf(file='C:\Users\SimoesLabAdmin\Documents\BDNN_Arielli\reptilia\mcmc_no_predictors\A_mcmc_200_Iterations/reptilia_pyrate_1_A_mcmc_G_BD1-1_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)

age = c(-298.34749280280886, -290.1)
Q_mean = 0.7102878900956877
Q_hpd_m = 0.2974386069434796
Q_hpd_M = 1.1908171327591306
plot(age,age,type = 'n', ylim = c(0, 16.57855470509292), xlim = c(-298.34749280280886,-198.3492535081246), ylab = 'Preservation rate', xlab = 'Ma',main='Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 4.977428273388563
Q_hpd_m = 4.164874624963157
Q_hpd_M = 5.731840732901868
segments(x0=age[1], y0 = 0.7102878900956877, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 0.6791406662362789
Q_hpd_m = 0.4588306430463821
Q_hpd_M = 0.9540061482940199
segments(x0=age[1], y0 = 4.977428273388563, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 1.125664853849027
Q_hpd_m = 0.5075798229895343
Q_hpd_M = 1.8651846968792807
segments(x0=age[1], y0 = 0.6791406662362789, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 2.444812441893447
Q_hpd_m = 1.737891853346394
Q_hpd_M = 3.1653687443779637
segments(x0=age[1], y0 = 1.125664853849027, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 13.037205827012194
Q_hpd_m = 11.638158815769373
Q_hpd_M = 14.425078662525117
segments(x0=age[1], y0 = 2.444812441893447, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 1.3287482805313822
Q_hpd_m = 1.0765223654495744
Q_hpd_M = 1.5875926470855697
segments(x0=age[1], y0 = 13.037205827012194, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 1.3318742414225395
Q_hpd_m = 1.1291144516811622
Q_hpd_M = 1.5359194096003501
segments(x0=age[1], y0 = 1.3287482805313822, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 1.7422164028851586
Q_hpd_m = 1.4084424990827575
Q_hpd_M = 2.0658712151388197
segments(x0=age[1], y0 = 1.3318742414225395, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.39697104536429567
Q_hpd_m = 0.330759916291624
Q_hpd_M = 0.4630811822578642
segments(x0=age[1], y0 = 1.7422164028851586, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 0.7724700707427163
Q_hpd_m = 0.6770579677739007
Q_hpd_M = 0.8692396244583693
segments(x0=age[1], y0 = 0.39697104536429567, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 0.781324561704077
Q_hpd_m = 0.6877236575659335
Q_hpd_M = 0.8797571719782638
segments(x0=age[1], y0 = 0.7724700707427163, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -198.3492535081246)
Q_mean = 1.0574911148839417
Q_hpd_m = 0.9215807085814393
Q_hpd_M = 1.2040725621597306
segments(x0=age[1], y0 = 0.781324561704077, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()