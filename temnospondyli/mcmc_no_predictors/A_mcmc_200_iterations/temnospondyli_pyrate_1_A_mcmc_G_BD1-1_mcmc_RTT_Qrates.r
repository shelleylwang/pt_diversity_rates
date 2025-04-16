library(scales)


#pdf(file='C:\Users\SimoesLabAdmin\Documents\BDNN_Arielli\temnospondyli\mcmc_no_predictors\A_mcmc_200_iterations/temnospondyli_pyrate_1_A_mcmc_G_BD1-1_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)
#pdf with forward slashes
pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_no_predictors/A_mcmc_200_iterations/temnospondyli_pyrate_1_A_mcmc_G_BD1-1_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)
age = c(-309.8832168193317, -290.1)
Q_mean = 7.737176425883716
Q_hpd_m = 7.12987045168964
Q_hpd_M = 8.403369707493919
plot(age,age,type = 'n', ylim = c(0, 16.75103209659887), xlim = c(-309.8832168193317,-201.7867914275552), ylab = 'Preservation rate', xlab = 'Ma',main='Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 2.2353884835984226
Q_hpd_m = 1.8079511388981684
Q_hpd_M = 2.6718575308206063
segments(x0=age[1], y0 = 7.737176425883716, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 1.494653209341282
Q_hpd_m = 1.2203768839395261
Q_hpd_M = 1.8100974331844548
segments(x0=age[1], y0 = 2.2353884835984226, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 0.3312178087277676
Q_hpd_m = 0.22045328785996834
Q_hpd_M = 0.45201878991172734
segments(x0=age[1], y0 = 1.494653209341282, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 0.49890483633650845
Q_hpd_m = 0.26965425382996727
Q_hpd_M = 0.7339014468924255
segments(x0=age[1], y0 = 0.3312178087277676, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 0.643893952056501
Q_hpd_m = 0.41312039173762827
Q_hpd_M = 0.8936460617744793
segments(x0=age[1], y0 = 0.49890483633650845, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 13.704732873015915
Q_hpd_m = 11.665239020127027
Q_hpd_M = 15.54270667773546
segments(x0=age[1], y0 = 0.643893952056501, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 1.7955300464763542
Q_hpd_m = 1.0951773730127432
Q_hpd_M = 2.4568855025142757
segments(x0=age[1], y0 = 13.704732873015915, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 2.1618327969351676
Q_hpd_m = 1.4779146680204593
Q_hpd_M = 2.9110909141274792
segments(x0=age[1], y0 = 1.7955300464763542, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.9729216949225774
Q_hpd_m = 0.7488374801590514
Q_hpd_M = 1.2016675174000953
segments(x0=age[1], y0 = 2.1618327969351676, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 1.122901674044964
Q_hpd_m = 0.8695273916112928
Q_hpd_M = 1.385337381565648
segments(x0=age[1], y0 = 0.9729216949225774, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 1.2963987036616422
Q_hpd_m = 1.0147694026180414
Q_hpd_M = 1.595869067609603
segments(x0=age[1], y0 = 1.122901674044964, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -201.7867914275552)
Q_mean = 0.6473162579938009
Q_hpd_m = 0.3048807724652214
Q_hpd_M = 1.001019074158442
segments(x0=age[1], y0 = 1.2963987036616422, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()