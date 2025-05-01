## RTT's WITH DEEPTIME GEOL STAGES AT BOTTOM

library(ggplot2)
library(deeptime)
library(gridExtra)

################################################### Data vectors, time_vec through div_upr (longevity vectors excluded for our purposes)
time_vec=c(299.1209716796875, 290.10001,290.1,283.50001,283.5,273.00001,273.0,264.30001,264.3,259.50001,259.5,252.00001,252.0,247.00001,247.0,242.00001,242.0,237.00001,237.0,227.00001,227.0,217.00001,217.0,208.00001,208.0,198.4518165588379)
sp_mean=c(0.31596927631275507, 0.31596927631275507,0.3204149167034899,0.3204149167034899,0.32480634041873513,0.32480634041873513,0.3264662623975076,0.3264662623975076,0.3224156105090612,0.3224156105090612,0.3113979645984984,0.3113979645984984,0.2890097178398075,0.2890097178398075,0.2607489290817626,0.2607489290817626,0.2235144842192724,0.2235144842192724,0.1596113886482588,0.1596113886482588,0.09207353617294506,0.09207353617294506,0.06418061291967098,0.06418061291967098,0.11599383204471864,0.11599383204471864)
sp_lwr=c(0.23374386636788014, 0.23374386636788014,0.24645096757201984,0.24645096757201984,0.26950897755857783,0.26950897755857783,0.27519977980843097,0.27519977980843097,0.28009080192172636,0.28009080192172636,0.27550695733418346,0.27550695733418346,0.2557409797886321,0.2557409797886321,0.2300876118737081,0.2300876118737081,0.19928873269518543,0.19928873269518543,0.14200104436951833,0.14200104436951833,0.07824589818463872,0.07824589818463872,0.05213568633263375,0.05213568633263375,0.0906805971656018,0.0906805971656018)
sp_upr=c(0.3880027066071686, 0.3880027066071686,0.3852739125896454,0.3852739125896454,0.38801224178272886,0.38801224178272886,0.36966613492176814,0.36966613492176814,0.35842799554868277,0.35842799554868277,0.34620076481954337,0.34620076481954337,0.32121614317118197,0.32121614317118197,0.2904915661781256,0.2904915661781256,0.25022692161239146,0.25022692161239146,0.1765312321691633,0.1765312321691633,0.10521171709022115,0.10521171709022115,0.0765606977742959,0.0765606977742959,0.14617690209222295,0.14617690209222295)
ex_mean=c(0.2589411019378592, 0.2589411019378592,0.26074917864702907,0.26074917864702907,0.26244875420525154,0.26244875420525154,0.26239025396298565,0.26239025396298565,0.2588914892016989,0.2588914892016989,0.250335812639286,0.250335812639286,0.2326037321647501,0.2326037321647501,0.20938946887334664,0.20938946887334664,0.17821300944753166,0.17821300944753166,0.12670511297208692,0.12670511297208692,0.08320284799948993,0.08320284799948993,0.08326632178160884,0.08326632178160884,0.2956307104458808,0.2956307104458808)
ex_lwr=c(0.18605436285957863, 0.18605436285957863,0.1889215560693877,0.1889215560693877,0.20499736700836976,0.20499736700836976,0.2152373775285,0.2152373775285,0.22158032962234114,0.22158032962234114,0.21636137396732144,0.21636137396732144,0.19754898697009454,0.19754898697009454,0.17556189060811453,0.17556189060811453,0.15450421072307496,0.15450421072307496,0.10959949146510536,0.10959949146510536,0.0630219308314691,0.0630219308314691,0.06575222947591576,0.06575222947591576,0.23668517252992743,0.23668517252992743)
ex_upr=c(0.3320149623171294, 0.3320149623171294,0.3238083322108112,0.3238083322108112,0.32151782281966007,0.32151782281966007,0.3048147526570375,0.3048147526570375,0.29657573719572017,0.29657573719572017,0.29076973290452657,0.29076973290452657,0.2734536872207115,0.2734536872207115,0.24580448637099192,0.24580448637099192,0.20704793095883628,0.20704793095883628,0.14199364338071432,0.14199364338071432,0.10353240952202095,0.10353240952202095,0.10047947456024199,0.10047947456024199,0.3517751137620769,0.3517751137620769)
div_mean=c(0.05702817437489618, 0.05702817437489618,0.05966573805646083,0.05966573805646083,0.062357586213483515,0.062357586213483515,0.06407600843452174,0.06407600843452174,0.06352412130736187,0.06352412130736187,0.061062151959212156,0.061062151959212156,0.05640598567505742,0.05640598567505742,0.05135946020841617,0.05135946020841617,0.045301474771740596,0.045301474771740596,0.032906275676171694,0.032906275676171694,0.00887068817345519,0.00887068817345519,-0.019085708861937785,-0.019085708861937785,-0.17963687840116302,-0.17963687840116302)
div_lwr=c(-0.04163613332702748, -0.04163613332702748,-0.030159820835123308,-0.030159820835123308,-0.01842441111241966,-0.01842441111241966,0.0018628285735220462,0.0018628285735220462,0.014504071440047506,0.014504071440047506,0.011012032824066265,0.011012032824066265,0.00762033252665989,0.00762033252665989,0.00658488306408489,0.00658488306408489,0.008481061400590462,0.008481061400590462,0.009676950955721714,0.009676950955721714,-0.012736275642141581,-0.012736275642141581,-0.040464935613834595,-0.040464935613834595,-0.24076495697326483,-0.24076495697326483)
div_upr=c(0.15822954199166245, 0.15822954199166245,0.15258533595101134,0.15258533595101134,0.1378172865555226,0.1378172865555226,0.1257360931037172,0.1257360931037172,0.1166726471459984,0.1166726471459984,0.10620436596409241,0.10620436596409241,0.10288080895237367,0.10288080895237367,0.09715829912278998,0.09715829912278998,0.07949942608060975,0.07949942608060975,0.05623722547858426,0.05623722547858426,0.03142677677989067,0.03142677677989067,-0.00013182102904354953,-0.00013182102904354953,-0.1173390666565734,-0.1173390666565734)

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
  labs(title = "Reptilia BDNN By Stages No Environmental Predictors",
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
  geom_vline(xintercept = -guadalupian_extinction, color = s"red", linetype = "dashed") +
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
ggsave(file = 'C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/reptilia/mcmc_fixshift_no_predictors/D_bdnn_update/combined_10_RTT_final_deeptime.pdf',
       plot = combined_plot, width = 8, height = 10.8, dpi = 300)