library(scales)

pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/pyrate_mcmc_logs/RJMCMC_NoPreds/temnospondyli_pyrate_1_Grj_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)

age = c(-309.6694236388722, -290.1)
Q_mean = 8.29629411970856
Q_hpd_m = 7.5912977076935615
Q_hpd_M = 8.98908792914453
plot(age,age,type = 'n', ylim = c(0, 15.583552833261798), xlim = c(-309.6694236388722,-201.99977794808532), ylab = 'Preservation rate', xlab = 'Ma',main='Temnospondyli Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 2.570259023940824
Q_hpd_m = 2.066617730781881
Q_hpd_M = 3.0541172333452358
segments(x0=age[1], y0 = 8.29629411970856, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 1.416557861744468
Q_hpd_m = 1.1189000836362373
Q_hpd_M = 1.7100500579326567
segments(x0=age[1], y0 = 2.570259023940824, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 0.36153032440312016
Q_hpd_m = 0.2215799005250955
Q_hpd_M = 0.5106094990278462
segments(x0=age[1], y0 = 1.416557861744468, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 0.4246967793821114
Q_hpd_m = 0.22653148425501043
Q_hpd_M = 0.628504502415969
segments(x0=age[1], y0 = 0.36153032440312016, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 0.5743927952332266
Q_hpd_m = 0.35285529623196427
Q_hpd_M = 0.7852467247025829
segments(x0=age[1], y0 = 0.4246967793821114, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 12.250306123932136
Q_hpd_m = 10.787653303734007
Q_hpd_M = 13.748882728281789
segments(x0=age[1], y0 = 0.5743927952332266, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 1.8819163378714985
Q_hpd_m = 1.337891109779474
Q_hpd_M = 2.4075666742252024
segments(x0=age[1], y0 = 12.250306123932136, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 1.7610404116203404
Q_hpd_m = 1.1563797734405847
Q_hpd_M = 2.4040145236506434
segments(x0=age[1], y0 = 1.8819163378714985, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.9876733850793044
Q_hpd_m = 0.6730143960737542
Q_hpd_M = 1.275527686984582
segments(x0=age[1], y0 = 1.7610404116203404, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 1.1253464768562829
Q_hpd_m = 0.7176018493636617
Q_hpd_M = 1.4446044354994643
segments(x0=age[1], y0 = 0.9876733850793044, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 1.0760667462354014
Q_hpd_m = 0.6793160081621745
Q_hpd_M = 1.3975017673064192
segments(x0=age[1], y0 = 1.1253464768562829, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -201.99977794808532)
Q_mean = 0.43977608727428397
Q_hpd_m = 0.1942913259258005
Q_hpd_M = 0.7226576175427754
segments(x0=age[1], y0 = 1.0760667462354014, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()