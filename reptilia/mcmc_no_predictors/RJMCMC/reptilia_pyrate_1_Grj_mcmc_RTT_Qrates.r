library(scales)

pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/pyrate_mcmc_logs/RJMCMC_NoPreds/reptilia_pyrate_1_Grj_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)

age = c(-298.7418948011353, -290.1)
Q_mean = 0.5393663911989134
Q_hpd_m = 0.239198183381652
Q_hpd_M = 0.9038558256218944
plot(age,age,type = 'n', ylim = c(0, 15.647868498168995), xlim = c(-298.7418948011353,-199.4142926760205), ylab = 'Preservation rate', xlab = 'Ma',main='Reptilia Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 4.877551455440904
Q_hpd_m = 4.13603566117472
Q_hpd_M = 5.588531701567901
segments(x0=age[1], y0 = 0.5393663911989134, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 0.6944705537617597
Q_hpd_m = 0.4704347577561965
Q_hpd_M = 0.9522131363919639
segments(x0=age[1], y0 = 4.877551455440904, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 1.4812193609432216
Q_hpd_m = 0.7812787990667187
Q_hpd_M = 2.3449397441106044
segments(x0=age[1], y0 = 0.6944705537617597, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 4.813460714464743
Q_hpd_m = 3.6239250295926575
Q_hpd_M = 6.091526692029447
segments(x0=age[1], y0 = 1.4812193609432216, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 12.94089606748374
Q_hpd_m = 11.60552499611987
Q_hpd_M = 14.3511325074156
segments(x0=age[1], y0 = 4.813460714464743, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 1.7856852641377348
Q_hpd_m = 1.4649632351912756
Q_hpd_M = 2.0931806303344005
segments(x0=age[1], y0 = 12.94089606748374, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 1.389359868406424
Q_hpd_m = 1.16692038295806
Q_hpd_M = 1.621257367017287
segments(x0=age[1], y0 = 1.7856852641377348, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 1.9830867081243115
Q_hpd_m = 1.6265979739068512
Q_hpd_M = 2.3719635881008716
segments(x0=age[1], y0 = 1.389359868406424, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.3938162660136381
Q_hpd_m = 0.322626475722895
Q_hpd_M = 0.4683476358926465
segments(x0=age[1], y0 = 1.9830867081243115, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 0.8101059538974927
Q_hpd_m = 0.7132954620427872
Q_hpd_M = 0.9147425085880848
segments(x0=age[1], y0 = 0.3938162660136381, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 0.7969969038114133
Q_hpd_m = 0.6991572511845459
Q_hpd_M = 0.8982971906424078
segments(x0=age[1], y0 = 0.8101059538974927, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -199.4142926760205)
Q_mean = 1.158743156805311
Q_hpd_m = 0.9950206908797249
Q_hpd_M = 1.3175142161580813
segments(x0=age[1], y0 = 0.7969969038114133, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()