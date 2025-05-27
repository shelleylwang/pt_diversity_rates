## RTT's WITH DEEPTIME GEOL STAGES AT BOTTOM

library(ggplot2)
library(deeptime)
library(gridExtra)

################################################### Data vectors, time_vec through div_upr (longevity vectors excluded for our purposes)
time_vec=c(309.9727478027344, 290.10001,290.1,283.50001,283.5,273.00001,273.0,264.30001,264.3,259.50001,259.5,252.00001,252.0,247.00001,247.0,242.00001,242.0,237.00001,237.0,227.00001,227.0,217.00001,217.0,208.00001,208.0,200.97370719909668)
sp_mean=c(0.24092791868588506, 0.24092791868588506,0.23220550973597565,0.23220550973597565,0.22574054443172517,0.22574054443172517,0.2177854703949625,0.2177854703949625,0.21176637064759943,0.21176637064759943,0.20600336812348835,0.20600336812348835,0.19991341014622516,0.19991341014622516,0.19490874475656841,0.19490874475656841,0.1898254097955963,0.1898254097955963,0.1821523716273576,0.1821523716273576,0.17213389942921073,0.17213389942921073,0.16335506781707834,0.16335506781707834,0.15168870319855962,0.15168870319855962)
sp_lwr=c(0.19613194954160038, 0.19613194954160038,0.19439366800615687,0.19439366800615687,0.19295001804869807,0.19295001804869807,0.19009747915441116,0.19009747915441116,0.18592832463545886,0.18592832463545886,0.18163987476253304,0.18163987476253304,0.17718335383358713,0.17718335383358713,0.17157937011312424,0.17157937011312424,0.16206260971535236,0.16206260971535236,0.15182890487167458,0.15182890487167458,0.13800884185014944,0.13800884185014944,0.12354997811272926,0.12354997811272926,0.09832156546567075,0.09832156546567075)
sp_upr=c(0.29195556017934904, 0.29195556017934904,0.2725698128718906,0.2725698128718906,0.2592089287286777,0.2592089287286777,0.24501326676308707,0.24501326676308707,0.23419074228956682,0.23419074228956682,0.22631130054743198,0.22631130054743198,0.2214483078572907,0.2214483078572907,0.21848199845756436,0.21848199845756436,0.2133531194265764,0.2133531194265764,0.21041363741311786,0.21041363741311786,0.20786888247258276,0.20786888247258276,0.20298233889641593,0.20298233889641593,0.21808306328670318,0.21808306328670318)
ex_mean=c(0.19620829277081359, 0.19620829277081359,0.19673045044057877,0.19673045044057877,0.19714019690786677,0.19714019690786677,0.19769048861464417,0.19769048861464417,0.19816018141494796,0.19816018141494796,0.1986739853774193,0.1986739853774193,0.19931379111443287,0.19931379111443287,0.19994333917585763,0.19994333917585763,0.2007156519973041,0.2007156519973041,0.2022552343782073,0.2022552343782073,0.205456393151253,0.205456393151253,0.21069529989179314,0.21069529989179314,0.24304027865803685,0.24304027865803685)
ex_lwr=c(0.16546100644112796, 0.16546100644112796,0.16967484926744916,0.16967484926744916,0.17099807166424666,0.17099807166424666,0.17408088143474926,0.17408088143474926,0.17676466165025398,0.17676466165025398,0.17550165351219563,0.17550165351219563,0.1768685020634401,0.1768685020634401,0.17684204222218483,0.17684204222218483,0.17823012577668976,0.17823012577668976,0.17853925100086218,0.17853925100086218,0.1795367165843697,0.1795367165843697,0.17629371543584996,0.17629371543584996,0.1681333174188109,0.1681333174188109)
ex_upr=c(0.22829495798184887, 0.22829495798184887,0.22448407172315074,0.22448407172315074,0.22166255918443611,0.22166255918443611,0.22043367530780086,0.22043367530780086,0.2208385250058307,0.2208385250058307,0.2188950105870215,0.2188950105870215,0.2204127345260146,0.2204127345260146,0.22094160273723423,0.22094160273723423,0.22340128294200762,0.22340128294200762,0.22636827025413772,0.22636827025413772,0.2355638218738132,0.2355638218738132,0.24511263956762583,0.24511263956762583,0.324221470515714,0.324221470515714)
div_mean=c(0.044719625915070366, 0.044719625915070366,0.03547505929539696,0.03547505929539696,0.028600347523857924,0.028600347523857924,0.020094981780318696,0.020094981780318696,0.013606189232651715,0.013606189232651715,0.007329382746069102,0.007329382746069102,0.0005996190317922014,0.0005996190317922014,-0.005034594419289219,-0.005034594419289219,-0.010890242201708058,-0.010890242201708058,-0.020102862750849985,-0.020102862750849985,-0.03332249372204234,-0.03332249372204234,-0.04734023207471495,-0.04734023207471495,-0.09135157545947738,-0.09135157545947738)
div_lwr=c(-0.008452553226518833, -0.008452553226518833,-0.004625839101790291,-0.004625839101790291,-0.006550821932013007,-0.006550821932013007,-0.008468360806200087,-0.008468360806200087,-0.01367611379273509,-0.01367611379273509,-0.01748432952457868,-0.01748432952457868,-0.027431951041502034,-0.027431951041502034,-0.032587163224200855,-0.032587163224200855,-0.04117703172747644,-0.04117703172747644,-0.055478709845917434,-0.055478709845917434,-0.07482045731376166,-0.07482045731376166,-0.09671647307468356,-0.09671647307468356,-0.19099657390189662,-0.19099657390189662)
div_upr=c(0.09906877455381943, 0.09906877455381943,0.0818948439495358,0.0818948439495358,0.06718374113181821,0.06718374113181821,0.05438959895541118,0.05438959895541118,0.04247126602441895,0.04247126602441895,0.03501033141579302,0.03501033141579302,0.025489663262303452,0.025489663262303452,0.022831755142487448,0.022831755142487448,0.01815327821776405,0.01815327821776405,0.012962512121953818,0.012962512121953818,0.008632477769108526,0.008632477769108526,0.0012026689444654404,0.0012026689444654404,-0.0029631581840572074,-0.0029631581840572074)

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
  labs(title = "Synapsida BDNN By Stages No Environmental Predictors",
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
ggsave(file = 'C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_no_predictors/D_bdnn_update/combined_10_RTT_final_deeptime.pdf',
       plot = combined_plot, width = 8, height = 10.8, dpi = 300)