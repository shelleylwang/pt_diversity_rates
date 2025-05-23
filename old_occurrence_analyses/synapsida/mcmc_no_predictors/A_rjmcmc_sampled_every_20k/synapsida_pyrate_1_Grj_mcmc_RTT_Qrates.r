library(scales)


pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/pyrate_mcmc_logs/RJMCMC_NoPreds/synapsida_pyrate_1_Grj_mcmc_RTT_Qrates.pdf', width=0.6*9, height=0.6*7)

age = c(-308.33443724808694, -290.1)
Q_mean = 0.9635845939633028
Q_hpd_m = 0.7502181327898316
Q_hpd_M = 1.1746652474643307
plot(age,age,type = 'n', ylim = c(0, 8.033087648658995), xlim = c(-308.33443724808694,-201.4254105884459), ylab = 'Preservation rate', xlab = 'Ma',main='Synapsida Preservation rates' )
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-290.1, -283.5)
Q_mean = 1.5190960626396373
Q_hpd_m = 1.1841021188784895
Q_hpd_M = 1.8698513331919213
segments(x0=age[1], y0 = 0.9635845939633028, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-283.5, -273.0)
Q_mean = 0.874158134521711
Q_hpd_m = 0.7076777238111414
Q_hpd_M = 1.0517004114494617
segments(x0=age[1], y0 = 1.5190960626396373, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-273.0, -264.3)
Q_mean = 0.9885689652208044
Q_hpd_m = 0.7872840296954504
Q_hpd_M = 1.1990737802453162
segments(x0=age[1], y0 = 0.874158134521711, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-264.3, -259.5)
Q_mean = 1.3861173935755102
Q_hpd_m = 1.17213660114016
Q_hpd_M = 1.628142058583786
segments(x0=age[1], y0 = 0.9885689652208044, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-259.5, -252.0)
Q_mean = 4.692484200182026
Q_hpd_m = 4.194751876774272
Q_hpd_M = 5.223263558709211
segments(x0=age[1], y0 = 1.3861173935755102, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-252.0, -247.0)
Q_mean = 4.851023634193516
Q_hpd_m = 4.178707158640268
Q_hpd_M = 5.571540140059456
segments(x0=age[1], y0 = 4.692484200182026, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-247.0, -242.0)
Q_mean = 2.6782187055263864
Q_hpd_m = 1.998996317804786
Q_hpd_M = 3.4180257062961252
segments(x0=age[1], y0 = 4.851023634193516, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-242.0, -237.0)
Q_mean = 5.540589520467506
Q_hpd_m = 4.290669759852197
Q_hpd_M = 6.712023644322372
segments(x0=age[1], y0 = 2.6782187055263864, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-237.0, -227.0)
Q_mean = 0.5689908704876788
Q_hpd_m = 0.3906523622317331
Q_hpd_M = 0.7639519967859656
segments(x0=age[1], y0 = 5.540589520467506, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-227.0, -217.0)
Q_mean = 1.193578678945647
Q_hpd_m = 0.9130506006487509
Q_hpd_M = 1.5212959432450193
segments(x0=age[1], y0 = 0.5689908704876788, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-217.0, -208.0)
Q_mean = 0.9109635303423045
Q_hpd_m = 0.655956272034173
Q_hpd_M = 1.171021274878071
segments(x0=age[1], y0 = 1.193578678945647, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
age = c(-208.0, -201.4254105884459)
Q_mean = 0.8802023831040806
Q_hpd_m = 0.5579473193157061
Q_hpd_M = 1.206466317048694
segments(x0=age[1], y0 = 0.9109635303423045, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
n <- dev.off()