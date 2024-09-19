library(scales)


pdf(file='./test_reptilia/reptilia/pyrate_mcmc_logs/rjmcmc/Reptilia_cleaned_pyrate_input_1_Grj_mcmc_RTT_Qrates.pdf', width=0.6*9, height=0.6*7)

age = c(-298.1993145266445, -290.1)
Q_mean = 0.40893614578763043
Q_hpd_m = 0.01588183029650272
Q_hpd_M = 1.0963465491141897
plot(age,age,type = 'n', ylim = c(0, 3.7950904271191894), xlim = c(-298.1993145266445,-199.40701032190503), ylab = 'Preservation rate', xlab = 'Ma',main='Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 1.5067622815873043
Q_hpd_m = 0.9928325890235489
Q_hpd_M = 2.0634976522437825
segments(x0=age[1], y0 = 0.40893614578763043, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 1.3164343333434216
Q_hpd_m = 0.6371847788745303
Q_hpd_M = 2.2138473445214886
segments(x0=age[1], y0 = 1.5067622815873043, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 0.4454728393233705
Q_hpd_m = 0.2553024090305285
Q_hpd_M = 0.6575023602132548
segments(x0=age[1], y0 = 1.3164343333434216, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 0.7520071302823941
Q_hpd_m = 0.5061153898007144
Q_hpd_M = 1.0047243712886793
segments(x0=age[1], y0 = 0.4454728393233705, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 0.643861273748576
Q_hpd_m = 0.4912793630911033
Q_hpd_M = 0.7893110768779946
segments(x0=age[1], y0 = 0.7520071302823941, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 1.3067478381081123
Q_hpd_m = 1.1229225887140861
Q_hpd_M = 1.484880419799825
segments(x0=age[1], y0 = 0.643861273748576, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 1.3605895297953388
Q_hpd_m = 1.2017600717433128
Q_hpd_M = 1.5304711931319128
segments(x0=age[1], y0 = 1.3067478381081123, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 1.332991493568054
Q_hpd_m = 1.1604455656821424
Q_hpd_M = 1.514813585382392
segments(x0=age[1], y0 = 1.3605895297953388, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.4106350102584047
Q_hpd_m = 0.3543948805052899
Q_hpd_M = 0.4689769381075854
segments(x0=age[1], y0 = 1.332991493568054, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 0.5253814540536005
Q_hpd_m = 0.4646188481705291
Q_hpd_M = 0.5893559018715301
segments(x0=age[1], y0 = 0.4106350102584047, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 0.6257568741902996
Q_hpd_m = 0.552261048316038
Q_hpd_M = 0.6973136937409216
segments(x0=age[1], y0 = 0.5253814540536005, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -199.40701032190503)
Q_mean = 1.6382767733190244
Q_hpd_m = 1.4498666962103324
Q_hpd_M = 1.82109620003792
segments(x0=age[1], y0 = 0.6257568741902996, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()