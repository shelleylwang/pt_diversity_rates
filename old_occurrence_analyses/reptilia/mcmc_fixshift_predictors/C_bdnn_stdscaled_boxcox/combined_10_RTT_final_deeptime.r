## RTT's WITH DEEPTIME GEOL STAGES AT BOTTOM

library(ggplot2)
library(deeptime)
library(gridExtra)

################################################### Data vectors, time_vec through div_upr (longevity vectors excluded for our purposes)
time_vec=c(299.1275939941406, 290.10001,290.1,283.50001,283.5,273.00001,273.0,264.30001,264.3,259.50001,259.5,252.00001,252.0,247.00001,247.0,242.00001,242.0,237.00001,237.0,227.00001,227.0,217.00001,217.0,208.00001,208.0,197.69842910766602)
sp_mean=c(0.4507543477332311, 0.4507543477332311,0.1469709438102613,0.1469709438102613,0.050120576987700824,0.050120576987700824,0.21262644146057788,0.21262644146057788,0.22760250391279072,0.22760250391279072,0.22408702001135428,0.22408702001135428,0.7176421621146309,0.7176421621146309,0.21795666925686824,0.21795666925686824,0.19087545451130036,0.19087545451130036,0.1576540965153183,0.1576540965153183,0.059741088667478105,0.059741088667478105,0.04206756739560999,0.04206756739560999,0.07399021727062782,0.07399021727062782)
sp_lwr=c(0.13642255490305438, 0.13642255490305438,0.05631599288563185,0.05631599288563185,0.0054796715180046975,0.0054796715180046975,0.06420409692152802,0.06420409692152802,0.08365155402470026,0.08365155402470026,0.12197787318686777,0.12197787318686777,0.5357138987817127,0.5357138987817127,0.1498672353202547,0.1498672353202547,0.11664029999376807,0.11664029999376807,0.11665695449933279,0.11665695449933279,0.037208248280190585,0.037208248280190585,0.02528959017285719,0.02528959017285719,0.03640259764159094,0.03640259764159094)
sp_upr=c(0.8218952948596441, 0.8218952948596441,0.243908394983242,0.243908394983242,0.1052590120197801,0.1052590120197801,0.36548042208780795,0.36548042208780795,0.3851268389905617,0.3851268389905617,0.3272370016545786,0.3272370016545786,0.9028254145465365,0.9028254145465365,0.28210505169426275,0.28210505169426275,0.254649818166539,0.254649818166539,0.20492432344873557,0.20492432344873557,0.08124469518277208,0.08124469518277208,0.059719626038102,0.059719626038102,0.10861898693296647,0.10861898693296647)
ex_mean=c(0.10017657514049562, 0.10017657514049562,0.1001219633321072,0.1001219633321072,0.07374142764659664,0.07374142764659664,0.1853975600797472,0.1853975600797472,0.1911933320444712,0.1911933320444712,0.26169118977080347,0.26169118977080347,0.36355301816146324,0.36355301816146324,0.2105116808674451,0.2105116808674451,0.2244260390581298,0.2244260390581298,0.10451843671726946,0.10451843671726946,0.03880672121595992,0.03880672121595992,0.08243419116668983,0.08243419116668983,0.3283380391933865,0.3283380391933865)
ex_lwr=c(0.012921601731328013, 0.012921601731328013,0.03342630199130984,0.03342630199130984,0.01052303880824076,0.01052303880824076,0.05899359003954352,0.05899359003954352,0.06739075308079145,0.06739075308079145,0.16315172589412258,0.16315172589412258,0.22292460308196474,0.22292460308196474,0.15279183866164298,0.15279183866164298,0.14720884237457424,0.14720884237457424,0.0745855326397436,0.0745855326397436,0.02129997405003879,0.02129997405003879,0.05634021093687037,0.05634021093687037,0.2662015396627408,0.2662015396627408)
ex_upr=c(0.20571972806567856, 0.20571972806567856,0.1721821648491061,0.1721821648491061,0.14466661826474012,0.14466661826474012,0.31154627909885496,0.31154627909885496,0.30773359301289643,0.30773359301289643,0.3644697442803146,0.3644697442803146,0.5199982007951703,0.5199982007951703,0.27256177032357926,0.27256177032357926,0.3031671515661427,0.3031671515661427,0.13802602078576223,0.13802602078576223,0.05960348582943132,0.05960348582943132,0.11149000873094386,0.11149000873094386,0.39913950001671994,0.39913950001671994)
div_mean=c(0.35057777259273665, 0.35057777259273665,0.046848980478154056,0.046848980478154056,-0.0236208506588958,-0.0236208506588958,0.027228881380831016,0.027228881380831016,0.03640917186831969,0.03640917186831969,-0.03760416975944921,-0.03760416975944921,0.3540891439531668,0.3540891439531668,0.007444988389422939,0.007444988389422939,-0.03355058454682896,-0.03355058454682896,0.05313565979804878,0.05313565979804878,0.020934367451518145,0.020934367451518145,-0.0403666237710798,-0.0403666237710798,-0.25434782192275857,-0.25434782192275857)
div_lwr=c(0.03232494542040237, 0.03232494542040237,-0.0667849931670311,-0.0667849931670311,-0.11566479500075907,-0.11566479500075907,-0.17736438511096692,-0.17736438511096692,-0.1286402397871949,-0.1286402397871949,-0.17074537076901067,-0.17074537076901067,0.14311187123624897,0.14311187123624897,-0.0737053964488475,-0.0737053964488475,-0.14286082080192852,-0.14286082080192852,0.00046019961863327796,0.00046019961863327796,-0.004825149926465308,-0.004825149926465308,-0.0719672810665275,-0.0719672810665275,-0.3296873093772761,-0.3296873093772761)
div_upr=c(0.7554651103960633, 0.7554651103960633,0.16086158126391997,0.16086158126391997,0.0520544557049611,0.0520544557049611,0.21788267502768216,0.21788267502768216,0.22107756556333005,0.22107756556333005,0.08656617402034236,0.08656617402034236,0.5786297523752524,0.5786297523752524,0.09222726070071424,0.09222726070071424,0.07534624579315627,0.07534624579315627,0.1073238057193416,0.1073238057193416,0.04682061078055704,0.04682061078055704,-0.00929640612227383,-0.00929640612227383,-0.1835243295300958,-0.1835243295300958)


# Calculate positions for the mass extinction events
perm_trias_extinction = 252 # End-Permian mass extinction (252 Ma)
guadalupian_extinction = 261 # Guadalupian extinction (261 Ma)

# Format axis labels function
format_labels <- function(x) {
  return(sprintf("%.0f", abs(x)))
}

# Convert time vector to negative for coord_geo
time_vec_neg <- -time_vec

# Create data frames for each plot
sp_data <- data.frame(
  time = time_vec_neg,
  mean = sp_mean,
  lower = sp_lwr,
  upper = sp_upr
)
sp_data <- sp_data[!is.na(sp_data$mean), ]

ex_data <- data.frame(
  time = time_vec_neg,
  mean = ex_mean,
  lower = ex_lwr,
  upper = ex_upr
)
ex_data <- ex_data[!is.na(ex_data$mean), ]

div_data <- data.frame(
  time = time_vec_neg,
  mean = div_mean,
  lower = div_lwr,
  upper = div_upr
)
div_data <- div_data[!is.na(div_data$mean), ]

# Create the first plot: Speciation rate
sp_plot <- ggplot(sp_data) +
  geom_ribbon(aes(x = time, ymin = lower, ymax = upper), 
              fill = "#4c4cec", alpha = 0.5) +
  geom_line(aes(x = time, y = mean), color = "#4c4cec", linewidth = 1.2) +
  geom_vline(xintercept = -perm_trias_extinction, color = "red", linetype = "dashed") +
  geom_vline(xintercept = -guadalupian_extinction, color = "red", linetype = "dashed") +
  scale_x_reverse() +
  ############################################################## CHANGE PDF TITLE
  labs(title = "Reptilia BDNN By Stages With Environmental Predictors",
       y = "Speciation rate", x = "Time (Ma)") +
  coord_geo(xlim = c(-300, -200),
            expand = FALSE,
            clip = "on",
            dat = list("international epochs", "international periods"),
            abbrv = list(TRUE, FALSE),
            pos = list("bottom", "bottom"),
            alpha = 1,
            height = unit(1, "line"),
            rot = 0,
            size = "auto",
            neg = TRUE) +
  scale_x_continuous(limits = c(-320, -190),
                     breaks = seq(-320, -190, by = 10),
                     labels = format_labels) +
  ################################################# REMOVE SCALE_Y_CONTINUOUS IF YOU WANT AUTO Y SCALE
  ################################################# OR CHANGE SCALE_Y_CONTINUOUS IF NEEDED TO ADJUST Y SCALE
  scale_y_continuous(limits = c(0, 1),
                     breaks = seq(0, 1, by = 0.2),
                     labels = function(x) sprintf("%.1f", x)) +
  theme_classic() +
  theme(plot.margin = unit(c(1, 1, 0.5, 1), "cm"),
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10))

# Create the second plot: Extinction rate
ex_plot <- ggplot(ex_data) +
  geom_ribbon(aes(x = time, ymin = lower, ymax = upper), 
              fill = "#e34a33", alpha = 0.5) +
  geom_line(aes(x = time, y = mean), color = "#e34a33", linewidth = 1.2) +
  geom_vline(xintercept = -perm_trias_extinction, color = "red", linetype = "dashed") +
  geom_vline(xintercept = -guadalupian_extinction, color = "red", linetype = "dashed") +
  scale_x_reverse() +
  labs(y = "Extinction rate", x = "Time (Ma)") +
  coord_geo(xlim = c(-300, -200),
            expand = FALSE,
            clip = "on",
            dat = list("international epochs", "international periods"),
            abbrv = list(TRUE, FALSE),
            pos = list("bottom", "bottom"),
            alpha = 1,
            height = unit(1, "line"),
            rot = 0,
            size = "auto",
            neg = TRUE) +
  scale_x_continuous(limits = c(-320, -190),
                     breaks = seq(-320, -190, by = 10),
                     labels = format_labels) +
  ################################################# REMOVE SCALE_Y_CONTINUOUS IF YOU WANT AUTO Y SCALE
  ################################################# OR CHANGE SCALE_Y_CONTINUOUS IF NEEDED TO ADJUST Y SCALE
  scale_y_continuous(limits = c(0, 1),
                     breaks = seq(0, 1, by = 0.2),
                     labels = function(x) sprintf("%.1f", x)) +
  theme_classic() +
  theme(plot.margin = unit(c(0.5, 1, 0.5, 1), "cm"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10))

# Create the third plot: Net diversification rate
div_plot <- ggplot(div_data) +
  geom_ribbon(aes(x = time, ymin = lower, ymax = upper), 
              fill = "black", alpha = 0.3) +
  geom_line(aes(x = time, y = mean), color = "black", linewidth = 1.2) +
  geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
  geom_vline(xintercept = -perm_trias_extinction, color = "red", linetype = "dashed") +
  geom_vline(xintercept = -guadalupian_extinction, color = "red", linetype = "dashed") +
  scale_x_reverse() +
  labs(y = "Net diversification rate", x = "Time (Ma)") +
  coord_geo(xlim = c(-300, -200),
            expand = FALSE,
            clip = "on",
            dat = list("international epochs", "international periods"),
            abbrv = list(TRUE, FALSE),
            pos = list("bottom", "bottom"),
            alpha = 1,
            height = unit(1, "line"),
            rot = 0,
            size = "auto",
            neg = TRUE) +
  scale_x_continuous(limits = c(-320, -190),
                     breaks = seq(-320, -190, by = 10),
                     labels = format_labels) +
  ################################################# REMOVE SCALE_Y_CONTINUOUS IF YOU WANT AUTO Y SCALE
  ################################################# OR CHANGE SCALE_Y_CONTINUOUS IF NEEDED TO ADJUST Y SCALE
  scale_y_continuous(limits = c(-0.5, 1),
                     breaks = seq(-0.5, 1, by = 0.25),
                     labels = function(x) sprintf("%.1f", x)) +
  theme_classic() +
  theme(plot.margin = unit(c(0.5, 1, 1, 1), "cm"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10))

# Combine all plots using gridExtra
combined_plot <- gridExtra::grid.arrange(sp_plot, ex_plot, div_plot, 
                                         ncol = 1, heights = c(1.2, 1, 1))

# Save the combined plot
######################################################################### CHANGE FILE PATH
ggsave(file = 'C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox/combined_10_RTT_final_deeptime.pdf',
       plot = combined_plot, width = 8, height = 10.8, dpi = 300)