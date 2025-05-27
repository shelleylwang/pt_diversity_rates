## RTT's WITH DEEPTIME GEOL STAGES AT BOTTOM

library(ggplot2)
library(deeptime)
library(gridExtra)

################################################### Data vectors, time_vec through div_upr (longevity vectors excluded for our purposes)
time_vec=c(311.35340881347656, 290.10001,290.1,283.50001,283.5,273.00001,273.0,264.30001,264.3,259.50001,259.5,252.00001,252.0,247.00001,247.0,242.00001,242.0,237.00001,237.0,227.00001,227.0,217.00001,217.0,208.00001,208.0,200.19962882995605)
sp_mean=c(0.18609151635911503, 0.18609151635911503,0.031565105666705125,0.031565105666705125,0.024892329664721685,0.024892329664721685,0.08888450254176382,0.08888450254176382,0.07518870582813032,0.07518870582813032,0.2524890654732718,0.2524890654732718,0.4673611550369219,0.4673611550369219,0.18315228324599842,0.18315228324599842,0.1297110569515588,0.1297110569515588,0.03165301323757876,0.03165301323757876,0.018700636226079707,0.018700636226079707,0.015088791658075747,0.015088791658075747,0.012900342557689442,0.012900342557689442)
sp_lwr=c(0.144293559013928, 0.144293559013928,0.005643861506733455,0.005643861506733455,0.006281466783438202,0.006281466783438202,0.022662131689408067,0.022662131689408067,0.0026379804225696067,0.0026379804225696067,0.092659676084439,0.092659676084439,0.30150683845095944,0.30150683845095944,0.06091510588921729,0.06091510588921729,0.017215761816213142,0.017215761816213142,0.0017363440185430177,0.0017363440185430177,0.0011838966984032227,0.0011838966984032227,0.00010050570752056437,0.00010050570752056437,5.463744050373746e-05,5.463744050373746e-05)
sp_upr=c(0.230335135163576, 0.230335135163576,0.06140943231727818,0.06140943231727818,0.049939555462027274,0.049939555462027274,0.16583065806940908,0.16583065806940908,0.18221242562480666,0.18221242562480666,0.432458528321409,0.432458528321409,0.656748972517247,0.656748972517247,0.3191555201919131,0.3191555201919131,0.2611941764287546,0.2611941764287546,0.0695015043587783,0.0695015043587783,0.040594919408573175,0.040594919408573175,0.03898124471013361,0.03898124471013361,0.037512007518077775,0.037512007518077775)
ex_mean=c(0.10483584937025205, 0.10483584937025205,0.057550010697067853,0.057550010697067853,0.06329653047335919,0.06329653047335919,0.16048821191934315,0.16048821191934315,0.21146720156011006,0.21146720156011006,0.15091071747178683,0.15091071747178683,0.46104763273195853,0.46104763273195853,0.25878598964523825,0.25878598964523825,0.1344804682966165,0.1344804682966165,0.053299143301637694,0.053299143301637694,0.04104040368719347,0.04104040368719347,0.05089522507201937,0.05089522507201937,0.1698854841552836,0.1698854841552836)
ex_lwr=c(0.07249542662448895, 0.07249542662448895,0.01983174451746446,0.01983174451746446,0.014312113702823622,0.014312113702823622,0.05225571828238576,0.05225571828238576,0.08878780226127955,0.08878780226127955,0.058168027767931785,0.058168027767931785,0.301388405665025,0.301388405665025,0.11368841821796692,0.11368841821796692,0.019276862673213574,0.019276862673213574,0.021828991372894065,0.021828991372894065,0.014296975189011456,0.014296975189011456,0.007815367742348192,0.007815367742348192,0.054926914658006226,0.054926914658006226)
ex_upr=c(0.1397490431344977, 0.1397490431344977,0.09782471430727818,0.09782471430727818,0.11307537710197677,0.11307537710197677,0.27859651669337854,0.27859651669337854,0.343790443051074,0.343790443051074,0.24676270508453138,0.24676270508453138,0.6186963647480594,0.6186963647480594,0.4006890718462113,0.4006890718462113,0.27006906668824443,0.27006906668824443,0.09481296957299117,0.09481296957299117,0.06925216402827387,0.06925216402827387,0.09692421002892324,0.09692421002892324,0.3032553767130584,0.3032553767130584)
div_mean=c(0.08125566698886327, 0.08125566698886327,-0.025984905030362777,-0.025984905030362777,-0.038404200808637635,-0.038404200808637635,-0.07160370937757915,-0.07160370937757915,-0.1362784957319793,-0.1362784957319793,0.10157834800148467,0.10157834800148467,0.0063135223049635095,0.0063135223049635095,-0.07563370639923986,-0.07563370639923986,-0.0047694113450575445,-0.0047694113450575445,-0.021646130064058904,-0.021646130064058904,-0.022339767461113866,-0.022339767461113866,-0.03580643341394365,-0.03580643341394365,-0.15698514159759452,-0.15698514159759452)
div_lwr=c(0.02276847338151125, 0.02276847338151125,-0.0761869090595881,-0.0761869090595881,-0.09394973387738403,-0.09394973387738403,-0.2126711478309772,-0.2126711478309772,-0.3077154012195952,-0.3077154012195952,-0.08297959555981219,-0.08297959555981219,-0.19459620529691507,-0.19459620529691507,-0.27263670649896066,-0.27263670649896066,-0.188305995392896,-0.188305995392896,-0.07143943047630073,-0.07143943047630073,-0.05765904030452522,-0.05765904030452522,-0.0842061339811842,-0.0842061339811842,-0.29643018888207323,-0.29643018888207323)
div_upr=c(0.13378977782590468, 0.13378977782590468,0.01953050435718056,0.01953050435718056,0.0167528292238142,0.0167528292238142,0.05315003214833246,0.05315003214833246,0.03527079745850202,0.03527079745850202,0.2954141773044838,0.2954141773044838,0.2057209935597779,0.2057209935597779,0.10421552937384904,0.10421552937384904,0.18424187333361064,0.18424187333361064,0.03408818931171847,0.03408818931171847,0.013549761196141999,0.013549761196141999,0.012013100965068272,0.012013100965068272,-0.045868151341034245,-0.045868151341034245)


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
  labs(title = "Temnospondyli BDNN By Stages With Environmental Predictors",
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
ggsave(file = 'C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox/combined_10_RTT_final_deeptime.pdf',
       plot = combined_plot, width = 8, height = 10.8, dpi = 300)