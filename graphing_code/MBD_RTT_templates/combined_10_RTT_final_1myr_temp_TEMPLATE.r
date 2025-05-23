

####################################################### CHANGE FILE PATH
pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_covar/C_covar_MBD_1myr_temp/combined_10_RTT_final.pdf',width=0.6*25, height=0.6*10)
library(scales)

# "translated" refers to the time bins in the MBD predictors directories .txt files being shifted 175 years towards the present
# This wasn't necessary for the C_covar run, but was done anyway, so the MBD preds needed to be shifted to match

# According to code below, 
# clade_2 = "Mod_scaled_translated"
# clade_3 = "mean_scaled_translated"

# According to any backscale.txt (env variables are all the same values in reptilia_backscale.txt, synapsida, temnospondyli)
# "Mod_scaled_translated" pre-scaling values: mean = 1.736411352917647, sd = 1.4416263255546373
# "mean_scaled_translated" pre-scaling values: mean = 30.001950201176474, sd = 3.1925277166671595

# Defining these as variables:
clade_2_mean = 1.736411352917647
clade_2_sd = 1.4416263255546373
clade_3_mean = 30.001950201176474
clade_3_sd = 3.1925277166671595

##################################################### ADD CLADE_1, CLADE_2 ETC. VECTORS

# Print the first five items in clade_2, and a message indicating that the values are z-transformed
print("Mod_scaled_translated z-transformed values:")
print(clade_2[1:5])

# Print the first five items in clade_3, and a message indicating that the values are z-transformed
print("mean_scaled_translated z-transformed values:")
print(clade_3[1:5])

# Reversing each clade vector's z transformations
clade_2 = clade_2 * clade_2_sd + clade_2_mean
clade_3 = clade_3 * clade_3_sd + clade_3_mean

# Print the first five items in clade_2, and a message indicating that the values are reverse z-transformed
print("Mod_scaled_translated reverse z-transformed values (Mod):")
print(clade_2[1:5])

# Print the first five items in clade_3, and a message indicating that the values are reverse z-transformed
print("mean_scaled_translated reverse z-transformed values (mean):")
print(clade_3[1:5])

# Calculate positions for the mass extinction events
perm_trias_extinction = -252 # End-Permian mass extinction (252 Ma)
guadalupian_extinction = -261 # Guadalupian extinction (261 Ma)

# Define custom tick positions at 10 MY intervals
x_ticks <- seq(-300, -200, by=10)
x_tick_labels <- abs(x_ticks)

######################################################### ADD t = VECTOR
time = -t - 175 ########################### REMOVE THE -175 IF MODEL RUN WAS NOT TRANSLATED BY -175
######################################### ADD S, SP_HDPS, E, EX_HDPS VECTORS

XLIM = c(-300,-200) # CHANGED THIS FROM c(min(time[clade_1>0]),0)
par(mfrow=c(1,2))
########################################### CHANGE YLIM IF NEEDED (TO COMMON SCALE)
YLIM = c(0,max(c(sp_hdp_M[clade_1>0],ex_hdp_M[clade_1>0])))
YLIMsmall = c(0,max(c(sp_hdp_M50[clade_1>0],ex_hdp_M50[clade_1>0])))
plot(speciation[clade_1>0] ~ time[clade_1>0],type="l",col="#4c4cec", 
     xaxt = 'n', lwd=3,main="Speciation rates - Combined effects", ylim = YLIM,xlab="Time (Ma)",ylab="Speciation rates",xlim=XLIM)
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
mtext("Exponential correlations")
polygon(c(time[clade_1>0], rev(time[clade_1>0])), c(sp_hdp_M[clade_1>0], rev(sp_hdp_m[clade_1>0])), col = alpha("#4c4cec",0.1), border = NA)    
polygon(c(time[clade_1>0], rev(time[clade_1>0])), c(sp_hdp_M50[clade_1>0], rev(sp_hdp_m50[clade_1>0])), col = alpha("#4c4cec",0.3), border = NA)    
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)
plot(extinction[clade_1>0] ~ time[clade_1>0],type="l",col="#e34a33", 
     xaxt = 'n', lwd=3,main="Extinction rates - Combined effects", ylim = YLIM,xlab="Time (Ma)",ylab="Extinction rates",xlim=XLIM)
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
mtext("Exponential correlations")
polygon(c(time[clade_1>0], rev(time[clade_1>0])), c(ex_hdp_M[clade_1>0], rev(ex_hdp_m[clade_1>0])), col = alpha("#e34a33",0.1), border = NA)    
polygon(c(time[clade_1>0], rev(time[clade_1>0])), c(ex_hdp_M50[clade_1>0], rev(ex_hdp_m50[clade_1>0])), col = alpha("#e34a33",0.3), border = NA)    
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)


######################################################### ADD t = VECTOR
time = -t - 175 ########################### REMOVE THE -175 IF MODEL RUN WAS NOT TRANSLATED BY -175
######################################################### ADD speciation and extinction VECTORS FOR CLADE_1
par(mfrow=c(1,2))
plot(speciation[clade_1>0] ~ time[clade_1>0],type="l",col="#4c4cec", 
     ########################################### CHANGE YLIM BELOW IF NEEDED (TO COMMON SCALE)
     xaxt = 'n', lwd=3,main="Effect of: Diversity dependence", ylim =c(0,max(c(speciation,extinction))+0.05*max(c(speciation,extinction))),xlab="Time (Ma)",ylab="Speciation and extinction rates",xlim=XLIM) 
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
######################################################## ADD MTEXT()
lines(extinction[clade_1>0] ~ time[clade_1>0], col="#e34a33", lwd=3)
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)
plot(clade_1[clade_1>0] ~ time[clade_1>0],type="l", 
     xaxt = 'n', main = "Trajectory of variable: Diversity dependence",xlab="Time (Ma)",ylab="Rescaled value",xlim=XLIM)
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)


######################################################### ADD t = VECTOR
time = -t - 175 ########################### REMOVE THE -175 IF MODEL RUN WAS NOT TRANSLATED BY -175
######################################################### ADD speciation and extinction VECTORS FOR CLADE_2
par(mfrow=c(1,2))
plot(speciation[clade_1>0] ~ time[clade_1>0],type="l",col="#4c4cec", 
     ########################################### CHANGE YLIM BELOW IF NEEDED (TO COMMON SCALE)
     xaxt='n',lwd=3,main="Effect of: Mod_scaled_translated", ylim =c(0,max(c(speciation,extinction))+0.05*max(c(speciation,extinction))),xlab="Time (Ma)",ylab="Speciation and extinction rates",xlim=XLIM)
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
######################################################## ADD MTEXT()
lines(extinction[clade_1>0] ~ time[clade_1>0], col="#e34a33", lwd=3)
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)
plot(clade_2[clade_1>0] ~ time[clade_1>0],type="l", 
     xaxt='n',main = "Trajectory of variable: Mod_scaled_translated",xlab="Time (Ma)",ylab="Rescaled value",xlim=XLIM)
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)


######################################################### ADD t = VECTOR
time = -t - 175 ########################### REMOVE THE -175 IF MODEL RUN WAS NOT TRANSLATED BY -175
######################################################### ADD speciation and extinction VECTORS FOR CLADE_3
par(mfrow=c(1,2))
plot(speciation[clade_1>0] ~ time[clade_1>0],type="l",col="#4c4cec", 
     ########################################### CHANGE YLIM BELOW IF NEEDED (TO COMMON SCALE)
     xaxt='n', lwd=3,main="Effect of: mean_scaled_translated", ylim = c(0,max(c(speciation,extinction))+0.05*max(c(speciation,extinction))),xlab="Time (Ma)",ylab="Speciation and extinction rates",xlim=XLIM)
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
######################################################## ADD MTEXT()
lines(extinction[clade_1>0] ~ time[clade_1>0], col="#e34a33", lwd=3)
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)
plot(clade_3[clade_1>0] ~ time[clade_1>0],type="l", 
     xaxt = 'n',main = "Trajectory of variable: mean_scaled_translated",xlab="Time (Ma)",ylab="Rescaled value",xlim=XLIM)
axis(1, at=x_ticks, labels=x_tick_labels) # Custom x-axis with 10MY interval ticks
# abline(v=-c(65,200,251,367,445),lty=2,col="gray")
# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2) 
abline(v=guadalupian_extinction, col="red", lty=2)


n<-dev.off()