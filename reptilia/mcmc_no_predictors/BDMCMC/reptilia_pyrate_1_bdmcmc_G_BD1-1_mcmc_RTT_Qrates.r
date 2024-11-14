library(scales)

pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_no_predictors/BDMCMC/reptilia_pyrate_1_bdmcmc_G_BD1-1_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)

age = c(-298.7419419984017, -290.1)
Q_mean = 0.4630972153720101
Q_hpd_m = 0.203146714477061
Q_hpd_M = 0.7723521704199846
plot(age,age,type = 'n', ylim = c(0, 15.34450402313613), xlim = c(-298.7419419984017,-198.44955910407327), ylab = 'Preservation rate', xlab = 'Ma',main='Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 4.857221839038722
Q_hpd_m = 4.1469940109506265
Q_hpd_M = 5.586684573124185
segments(x0=age[1], y0 = 0.4630972153720101, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 0.6931015727827288
Q_hpd_m = 0.4715289447181785
Q_hpd_M = 0.9410771989392859
segments(x0=age[1], y0 = 4.857221839038722, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 1.4398795846740096
Q_hpd_m = 0.7882379286788943
Q_hpd_M = 2.247331497879845
segments(x0=age[1], y0 = 0.6931015727827288, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 4.8269669965849715
Q_hpd_m = 3.646546621713061
Q_hpd_M = 6.104802233115321
segments(x0=age[1], y0 = 1.4398795846740096, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 12.784888947435286
Q_hpd_m = 11.435906050353351
Q_hpd_M = 14.158198903895988
segments(x0=age[1], y0 = 4.8269669965849715, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 1.4605241433682952
Q_hpd_m = 1.1919026537900088
Q_hpd_M = 1.738048055124311
segments(x0=age[1], y0 = 12.784888947435286, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 1.4629112580702888
Q_hpd_m = 1.225833860982052
Q_hpd_M = 1.6888386523742251
segments(x0=age[1], y0 = 1.4605241433682952, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 1.8517878532956649
Q_hpd_m = 1.5123096258017348
Q_hpd_M = 2.1911791586165394
segments(x0=age[1], y0 = 1.4629112580702888, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.4208622492667792
Q_hpd_m = 0.348576843352432
Q_hpd_M = 0.4911560068094671
segments(x0=age[1], y0 = 1.8517878532956649, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 0.8553845408842593
Q_hpd_m = 0.7597098792119701
Q_hpd_M = 0.9550051808730918
segments(x0=age[1], y0 = 0.4208622492667792, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 0.8484223198548205
Q_hpd_m = 0.7520942874070603
Q_hpd_M = 0.9493877711454701
segments(x0=age[1], y0 = 0.8553845408842593, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -198.44955910407327)
Q_mean = 1.1275589696063275
Q_hpd_m = 0.9723938025056705
Q_hpd_M = 1.2848369291601167
segments(x0=age[1], y0 = 0.8484223198548205, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()