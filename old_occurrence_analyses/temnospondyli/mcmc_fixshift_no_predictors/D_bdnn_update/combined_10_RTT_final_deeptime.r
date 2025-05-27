## RTT's WITH DEEPTIME GEOL STAGES AT BOTTOM

library(ggplot2)
library(deeptime)
library(gridExtra)

################################################### Data vectors, time_vec through div_upr (longevity vectors excluded for our purposes)
time_vec=c(310.95433044433594, 290.10001,290.1,283.50001,283.5,273.00001,273.0,264.30001,264.3,259.50001,259.5,252.00001,252.0,247.00001,247.0,242.00001,242.0,237.00001,237.0,227.00001,227.0,217.00001,217.0,208.00001,208.0,200.7016429901123)
sp_mean=c(0.15688365199903712, 0.15688365199903712,0.15524872874101694,0.15524872874101694,0.1537700044055804,0.1537700044055804,0.15159584004020096,0.15159584004020096,0.14965075936072464,0.14965075936072464,0.14749683392675125,0.14749683392675125,0.1448471403755171,0.1448471403755171,0.14233456210647236,0.14233456210647236,0.1394435511837246,0.1394435511837246,0.13442748223351156,0.13442748223351156,0.12671670240595057,0.12671670240595057,0.11855591553975069,0.11855591553975069,0.09908289557950753,0.09908289557950753)
sp_lwr=c(0.1279026893530386, 0.1279026893530386,0.12987806777196165,0.12987806777196165,0.12975565533098032,0.12975565533098032,0.1288598381568455,0.1288598381568455,0.128131741876032,0.128131741876032,0.12532346279103293,0.12532346279103293,0.1239363532926807,0.1239363532926807,0.12094212010706973,0.12094212010706973,0.11695255676674962,0.11695255676674962,0.11070708426773382,0.11070708426773382,0.09636505530599054,0.09636505530599054,0.08331910022202184,0.08331910022202184,0.04572649369072084,0.04572649369072084)
sp_upr=c(0.1859828199069333, 0.1859828199069333,0.18192844421370222,0.18192844421370222,0.1786972929096031,0.1786972929096031,0.17536179206426133,0.17536179206426133,0.17235578313060804,0.17235578313060804,0.1679197912419996,0.1679197912419996,0.16583233228223457,0.16583233228223457,0.1635532955393014,0.1635532955393014,0.16138424668520843,0.16138424668520843,0.15862702744275176,0.15862702744275176,0.15642546090493925,0.15642546090493925,0.1577033349226872,0.1577033349226872,0.1591391418915603,0.1591391418915603)
ex_mean=c(0.13380127036766537, 0.13380127036766537,0.13731131378850722,0.13731131378850722,0.13970679836173688,0.13970679836173688,0.1424344827464674,0.1424344827464674,0.14433685366325033,0.14433685366325033,0.14602994124180735,0.14602994124180735,0.14768626154989456,0.14768626154989456,0.14894889055381608,0.14894889055381608,0.15014471500627996,0.15014471500627996,0.1517976611115831,0.1517976611115831,0.15373695294749573,0.15373695294749573,0.15538316933792584,0.15538316933792584,0.16000204310940086,0.16000204310940086)
ex_lwr=c(0.10485706517897297, 0.10485706517897297,0.11438662056620442,0.11438662056620442,0.11849602979158365,0.11849602979158365,0.12256918438169094,0.12256918438169094,0.12507904969738812,0.12507904969738812,0.1261596980683887,0.1261596980683887,0.12644454718655734,0.12644454718655734,0.12720241324563158,0.12720241324563158,0.12777062496876018,0.12777062496876018,0.12808413644009625,0.12808413644009625,0.12957100627635004,0.12957100627635004,0.12462412338919418,0.12462412338919418,0.1000505608986089,0.1000505608986089)
ex_upr=c(0.1610407388141092, 0.1610407388141092,0.16073322071784563,0.16073322071784563,0.16070656435497782,0.16070656435497782,0.16310390007772818,0.16310390007772818,0.16525484959092426,0.16525484959092426,0.16703712604917909,0.16703712604917909,0.16959278182197596,0.16959278182197596,0.17230955914160953,0.17230955914160953,0.1746913701500002,0.1746913701500002,0.17767516364486075,0.17767516364486075,0.1863003194548727,0.1863003194548727,0.19061904608371497,0.19061904608371497,0.22072534718935585,0.22072534718935585)
div_mean=c(0.02308238163137136, 0.02308238163137136,0.01793741495250987,0.01793741495250987,0.014063206043843542,0.014063206043843542,0.00916135729373368,0.00916135729373368,0.005313905697474713,0.005313905697474713,0.0014668926849435858,0.0014668926849435858,-0.0028391211743775393,-0.0028391211743775393,-0.006614328447343954,-0.006614328447343954,-0.010701163822555301,-0.010701163822555301,-0.017370178878071376,-0.017370178878071376,-0.027020250541545308,-0.027020250541545308,-0.03682725379817502,-0.03682725379817502,-0.06091914752989317,-0.06091914752989317)
div_lwr=c(-0.01334710651135107, -0.01334710651135107,-0.014916576573342638,-0.014916576573342638,-0.015782710746198858,-0.015782710746198858,-0.019604373392374502,-0.019604373392374502,-0.02219281099488099,-0.02219281099488099,-0.02552411279725894,-0.02552411279725894,-0.032892277505395445,-0.032892277505395445,-0.03662233429074871,-0.03662233429074871,-0.04030636989442925,-0.04030636989442925,-0.05308312338163326,-0.05308312338163326,-0.06525371154771144,-0.06525371154771144,-0.08588585337363062,-0.08588585337363062,-0.14179125485653304,-0.14179125485653304)
div_upr=c(0.05925294251591988, 0.05925294251591988,0.04741158974062107,0.04741158974062107,0.04172758388576986,0.04172758388576986,0.034885136550355966,0.034885136550355966,0.031825551876851654,0.031825551876851654,0.02949828586469158,0.02949828586469158,0.024436755104442043,0.024436755104442043,0.022807637536879477,0.022807637536879477,0.020177848055807968,0.020177848055807968,0.013587336803722344,0.013587336803722344,0.016050496654653357,0.016050496654653357,0.013050921015463013,0.013050921015463013,0.017913089654747222,0.017913089654747222)

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
  labs(title = "Temnospondyli BDNN By Stages No Environmental Predictors",
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
  scale_x_continuous(limits = c(-320, -190), # This needs to be outside of the range of coord_geo in case any data is outside of that range
                     breaks = seq(-320, -190, by = 10),
                     labels = format_labels) +
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
ggsave(file = 'C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/temnospondyli/mcmc_fixshift_no_predictors/D_bdnn_update/combined_10_RTT_final_deeptime.pdf',
       plot = combined_plot, width = 8, height = 10.8, dpi = 300)