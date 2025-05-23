# Load required library
library(scales)

# Set the correct working directory
setwd("C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/pyrate_mcmc_logs/covar2")

# Print current working directory
print(paste("Current working directory:", getwd()))

# Attempt to create PDF
tryCatch({
  pdf(file='Reptilia_cleaned_pyrate_input_1_200_run_1_COVhp_BDS_mcmc_RTT_Qrates.pdf', width=0.6*9, height=0.6*7)
  
  age = c(-298.1992379827224, -290.1)
  Q_mean = 0.32926682968043
  Q_hpd_m = 0.016961011401898124
  Q_hpd_M = 0.7804604758962235
  plot(age,age,type = 'n', ylim = c(0, 2.084109494484484), xlim = c(-298.1992379827224,-198.8111385297757), ylab = 'Preservation rate', xlab = 'Ma',main='Preservation rates' )
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-290.1, -283.5)
  Q_mean = 1.1011242128301717
  Q_hpd_m = 0.8353225178545559
  Q_hpd_M = 1.3630158056232016
  segments(x0=age[1], y0 = 0.32926682968043, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-283.5, -273.0)
  Q_mean = 0.7968341322822939
  Q_hpd_m = 0.5873208829844433
  Q_hpd_M = 1.0130243244581154
  segments(x0=age[1], y0 = 1.1011242128301717, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-273.0, -264.3)
  Q_mean = 0.3662395352684808
  Q_hpd_m = 0.251364601084303
  Q_hpd_M = 0.49902706439962835
  segments(x0=age[1], y0 = 0.7968341322822939, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-264.3, -259.5)
  Q_mean = 0.7824927041823279
  Q_hpd_m = 0.591243721401363
  Q_hpd_M = 0.9933203967935882
  segments(x0=age[1], y0 = 0.3662395352684808, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-259.5, -252.0)
  Q_mean = 0.7078985765709291
  Q_hpd_m = 0.5856194715746459
  Q_hpd_M = 0.8375583649363519
  segments(x0=age[1], y0 = 0.7824927041823279, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-252.0, -247.0)
  Q_mean = 1.4132595888993194
  Q_hpd_m = 1.2471816636119377
  Q_hpd_M = 1.579756177164562
  segments(x0=age[1], y0 = 0.7078985765709291, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-247.0, -242.0)
  Q_mean = 1.1954849846456774
  Q_hpd_m = 1.0838767416536408
  Q_hpd_M = 1.309199303119841
  segments(x0=age[1], y0 = 1.4132595888993194, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-242.0, -237.0)
  Q_mean = 1.1485673601911102
  Q_hpd_m = 1.030296644739074
  Q_hpd_M = 1.2754668131254963
  segments(x0=age[1], y0 = 1.1954849846456774, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-237.0, -227.0)
  Q_mean = 0.376840104586892
  Q_hpd_m = 0.33109966903520555
  Q_hpd_M = 0.4231516637486287
  segments(x0=age[1], y0 = 1.1485673601911102, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-227.0, -217.0)
  Q_mean = 0.4427199680443649
  Q_hpd_m = 0.3986803339251009
  Q_hpd_M = 0.4836550533237196
  segments(x0=age[1], y0 = 0.376840104586892, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-217.0, -208.0)
  Q_mean = 0.5412079141310667
  Q_hpd_m = 0.4927844608292977
  Q_hpd_M = 0.5941909317005128
  segments(x0=age[1], y0 = 0.4427199680443649, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  age = c(-208.0, -198.8111385297757)
  Q_mean = 1.345392123412924
  Q_hpd_m = 1.2321422414909502
  Q_hpd_M = 1.461361368299349
  segments(x0=age[1], y0 = 0.5412079141310667, x1 = age[1], y1 = Q_mean, col = "#756bb1", lwd=3)
  segments(x0=age[1], y0 = Q_mean, x1 = age[2], y1 = Q_mean, col = "#756bb1", lwd=3)
  polygon( c(age, rev(age)), c(Q_hpd_m, Q_hpd_m, Q_hpd_M, Q_hpd_M), col = alpha("#756bb1",0.5), border = NA)
  
  # Close the PDF device
  dev.off()
  
  print("PDF created successfully!")
}, error = function(e) {
  print(paste("An error occurred:", e$message))
}, finally = {
  # Make sure to close the PDF device if it's open
  if (dev.cur() > 1) dev.off()
})

# Print the list of files in the current directory
print("Files in the current directory:")
print(list.files())