library(scales)


pdf(file='C:\Users\SimoesLabAdmin\Documents\BDNN_Arielli\synapsida\mcmc_no_predictors\A_mcmc_200_iterations/synapsida_pyrate_1_A_mcmc_G_BD1-1_mcmc_RTT_Qrates.pdf',width=0.6*9, height=0.6*7)

age = c(-309.78617734745336, -290.1)
Q_mean = 1.0169217104994233
Q_hpd_m = 0.7548111538940768
Q_hpd_M = 1.2578147009895015
plot(age,age,type = 'n', ylim = c(0, 10.072897057684123), xlim = c(-309.78617734745336,-201.32850173484906), ylab = 'Preservation rate', xlab = 'Ma',main='Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 2.157011306418906
Q_hpd_m = 1.5179203244100812
Q_hpd_M = 2.7202570538112676
segments(x0=age[1], y0 = 1.0169217104994233, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 1.0734045702321529
Q_hpd_m = 0.7792224701041202
Q_hpd_M = 1.346023227465958
segments(x0=age[1], y0 = 2.157011306418906, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 0.9608425146007965
Q_hpd_m = 0.6992287652021493
Q_hpd_M = 1.1956216165072864
segments(x0=age[1], y0 = 1.0734045702321529, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 1.2820967393134108
Q_hpd_m = 0.9964075975388166
Q_hpd_M = 1.5482276837685465
segments(x0=age[1], y0 = 0.9608425146007965, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 4.732389851152214
Q_hpd_m = 3.8259179642325143
Q_hpd_M = 5.491784645427156
segments(x0=age[1], y0 = 1.2820967393134108, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 4.908115367095281
Q_hpd_m = 4.155735429705735
Q_hpd_M = 5.599469763644808
segments(x0=age[1], y0 = 4.732389851152214, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 2.8748851704149923
Q_hpd_m = 2.0160924433542493
Q_hpd_M = 3.8530664625950988
segments(x0=age[1], y0 = 4.908115367095281, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 6.9670287904203345
Q_hpd_m = 5.78430200930897
Q_hpd_M = 8.297260168113253
segments(x0=age[1], y0 = 2.8748851704149923, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.7309629473508761
Q_hpd_m = 0.48496623989670895
Q_hpd_M = 0.9944205329477436
segments(x0=age[1], y0 = 6.9670287904203345, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 0.9439231034851555
Q_hpd_m = 0.7216172504293453
Q_hpd_M = 1.1758510002614146
segments(x0=age[1], y0 = 0.7309629473508761, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 1.0024209183612292
Q_hpd_m = 0.7425941666298608
Q_hpd_M = 1.2676467474648774
segments(x0=age[1], y0 = 0.9439231034851555, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -201.32850173484906)
Q_mean = 1.3902164352327013
Q_hpd_m = 0.7895886516852824
Q_hpd_M = 2.08789390884305
segments(x0=age[1], y0 = 1.0024209183612292, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()