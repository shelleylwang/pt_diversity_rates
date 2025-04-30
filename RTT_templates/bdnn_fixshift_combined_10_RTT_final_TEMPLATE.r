## FINAL RTT GRAPH, PROPER FORMATTING CODE BELOW

##################################################### Change file path
pdf(file='C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox/combined_10_RTT_final.pdf', width = 8, height = 10.8, useDingbats = FALSE)

# Set up the layout for 3 vertical plots
par(mfrow=c(3,1), cex.main=1.7, cex.lab=1.4, cex.axis=1.3,
    mgp=c(3.5, 1, 0),      # distance of axis labels from plot
    oma=c(2, 2, 2, 0))     # outer margins for the entire figure

################################################### Your data vectors, time_vec through div_upr (longevity vectors excluded for our purposes)

# Calculate positions for the mass extinction events
perm_trias_extinction = 252 # End-Permian mass extinction (252 Ma)
guadalupian_extinction = 261 # Guadalupian extinction (261 Ma)

# Define custom tick positions at 10 MY intervals
x_ticks <- seq(300, 200, by=-10)
x_tick_labels <- x_ticks

# Convert time_vec to negative values to match your desired format
time_vec_neg <- -time_vec  # Converting to negative for plotting consistency

# First plot: Speciation rate
par(mar=c(5, 5, 4.5, 2))  # bottom, left, top, right margins
plot(time_vec, sp_mean, type='n', ylim=c(0, 1), xlim=c(300, 200),
     ############################################################ Change PDF title
     ylab='Speciation rate', xlab='Ma', main='Reptilia BDNN By Stages',
     xaxt='n', cex.main=1.5, cex.lab=1.4, cex.axis=1.3) # xaxt removes default x axis
axis(1, at=x_ticks, labels=x_tick_labels, cex.axis=1.3) # Custom x-axis with 10MY interval ticks

# Plot the confidence intervals and mean line
not_NA = !is.na(sp_mean)
polygon(c(time_vec[not_NA], rev(time_vec[not_NA])), 
        c(sp_lwr[not_NA], rev(sp_upr[not_NA])), 
        col = adjustcolor('#4c4cec', alpha = 0.5), border = NA)
lines(time_vec[not_NA], sp_mean[not_NA], col = '#4c4cec', lwd = 3)

# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2)
abline(v=guadalupian_extinction, col="red", lty=2)

# Second plot: Extinction rate
par(mar=c(5, 5, 1, 2))  # bottom, left, top, right margins. Reduced top margin to 2.5 (from 4.5)
plot(time_vec, ex_mean, type='n', ylim=c(0, 0.6), xlim=c(300, 200),
     ylab='Extinction rate', xlab='Ma', 
     xaxt='n', cex.lab=1.4, cex.axis=1.3)
axis(1, at=x_ticks, labels=x_tick_labels, cex.axis=1.3)

# Plot the confidence intervals and mean line
not_NA = !is.na(ex_mean)
polygon(c(time_vec[not_NA], rev(time_vec[not_NA])), 
        c(ex_lwr[not_NA], rev(ex_upr[not_NA])), 
        col = adjustcolor('#e34a33', alpha = 0.5), border = NA)
lines(time_vec[not_NA], ex_mean[not_NA], col = '#e34a33', lwd = 3)

# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2)
abline(v=guadalupian_extinction, col="red", lty=2)

# Third plot: Net diversification rate
par(mar=c(5, 5, 1, 2))  # bottom, left, top, right margins. Reduced top margin to 2.5 (from 4.5)
plot(time_vec, div_mean, type='n', ylim=c(-0.4, 0.8), xlim=c(300, 200),
     ylab='Net diversification rate', xlab='Ma',
     xaxt='n', cex.lab=1.4, cex.axis=1.3)
axis(1, at=x_ticks, labels=x_tick_labels, cex.axis=1.3)

# Plot the confidence intervals and mean line
not_NA = !is.na(div_mean)
polygon(c(time_vec[not_NA], rev(time_vec[not_NA])), 
        c(div_lwr[not_NA], rev(div_upr[not_NA])), 
        col = adjustcolor('black', alpha = 0.3), border = NA)
lines(time_vec[not_NA], div_mean[not_NA], col = 'black', lwd = 3)

# Add horizontal line at y=0 for the net diversification rate
abline(h = 0, col = 'black', lty = 2)

# Add vertical lines for mass extinction events
abline(v=perm_trias_extinction, col="red", lty=2)
abline(v=guadalupian_extinction, col="red", lty=2)

dev.off()