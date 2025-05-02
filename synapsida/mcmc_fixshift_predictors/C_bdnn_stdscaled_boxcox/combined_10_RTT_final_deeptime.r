## RTT's WITH DEEPTIME GEOL STAGES AT BOTTOM

library(ggplot2)
library(deeptime)
library(gridExtra)

################################################### Data vectors, time_vec through div_upr (longevity vectors excluded for our purposes)
time_vec=c(309.9504089355469, 290.10001,290.1,283.50001,283.5,273.00001,273.0,264.30001,264.3,259.50001,259.5,252.00001,252.0,247.00001,247.0,242.00001,242.0,237.00001,237.0,227.00001,227.0,217.00001,217.0,208.00001,208.0,201.24311447143555)
sp_mean=c(0.22591077084453423, 0.22591077084453423,0.17152185641343556,0.17152185641343556,0.09062267617562376,0.09062267617562376,0.2228207798941073,0.2228207798941073,0.301754035467,0.301754035467,0.17582176892967835,0.17582176892967835,0.22832619019923206,0.22832619019923206,0.2782676015951532,0.2782676015951532,0.120155191234924,0.120155191234924,0.09169022786599021,0.09169022786599021,0.05732260541682606,0.05732260541682606,0.05197408211594862,0.05197408211594862,0.12729682120224017,0.12729682120224017)
sp_lwr=c(0.1496911128811939, 0.1496911128811939,0.07323774267964721,0.07323774267964721,0.03073349793644756,0.03073349793644756,0.11926508844962505,0.11926508844962505,0.2162948292557275,0.2162948292557275,0.12141273154297542,0.12141273154297542,0.11228474649991035,0.11228474649991035,0.13978560071812363,0.13978560071812363,0.0389523659391261,0.0389523659391261,0.047562604259742305,0.047562604259742305,0.016793269061478426,0.016793269061478426,0.0028968114393388166,0.0028968114393388166,0.0001409897825608468,0.0001409897825608468)
sp_upr=c(0.31509682540251743, 0.31509682540251743,0.28970097526414107,0.28970097526414107,0.15809759534992923,0.15809759534992923,0.33121170494235885,0.33121170494235885,0.3901750794482019,0.3901750794482019,0.23523600859948843,0.23523600859948843,0.3658700119427441,0.3658700119427441,0.4372188439805904,0.4372188439805904,0.2148394830404735,0.2148394830404735,0.13920347168785058,0.13920347168785058,0.10100752941481404,0.10100752941481404,0.10252326283941875,0.10252326283941875,0.26033725234727717,0.26033725234727717)
ex_mean=c(0.12466372269576002, 0.12466372269576002,0.08505202437601316,0.08505202437601316,0.04430011663949026,0.04430011663949026,0.09912692555331046,0.09912692555331046,0.1612990351743429,0.1612990351743429,0.28104065960011604,0.28104065960011604,0.30130764428164236,0.30130764428164236,0.22293336320766216,0.22293336320766216,0.120744435208424,0.120744435208424,0.09206295589621279,0.09206295589621279,0.07615367618380167,0.07615367618380167,0.08416132002375605,0.08416132002375605,0.4180842755183109,0.4180842755183109)
ex_lwr=c(0.01144622132088867, 0.01144622132088867,0.0007533079095096416,0.0007533079095096416,4.438086075272721e-05,4.438086075272721e-05,0.024148224713701948,0.024148224713701948,0.07212463349311028,0.07212463349311028,0.2230945778860508,0.2230945778860508,0.13518232936761573,0.13518232936761573,0.09590802615638552,0.09590802615638552,0.02611834347519202,0.02611834347519202,0.04537916166969618,0.04537916166969618,0.01997223760656885,0.01997223760656885,0.018530318724987435,0.018530318724987435,0.25854082375538473,0.25854082375538473)
ex_upr=c(0.21313199672507163, 0.21313199672507163,0.16988149906074576,0.16988149906074576,0.09286050590604138,0.09286050590604138,0.1716000002948739,0.1716000002948739,0.25071690688821713,0.25071690688821713,0.34344238111703596,0.34344238111703596,0.4577639060508973,0.4577639060508973,0.34983496097749367,0.34983496097749367,0.2247337946320252,0.2247337946320252,0.14744370479315191,0.14744370479315191,0.12971298394836595,0.12971298394836595,0.1540396293389677,0.1540396293389677,0.6047748415434908,0.6047748415434908)
div_mean=c(0.10124704814877455, 0.10124704814877455,0.08646983203742278,0.08646983203742278,0.046322559536133505,0.046322559536133505,0.12369385434079669,0.12369385434079669,0.14045500029265864,0.14045500029265864,-0.10521889067043774,-0.10521889067043774,-0.07298145408240954,-0.07298145408240954,0.05533423838749163,0.05533423838749163,-0.0005892439735002372,-0.0005892439735002372,-0.00037272803022260476,-0.00037272803022260476,-0.01883107076697561,-0.01883107076697561,-0.032187237907807566,-0.032187237907807566,-0.2907874543160702,-0.2907874543160702)
div_lwr=c(-0.016442306726323797, -0.016442306726323797,-0.050073977644833415,-0.050073977644833415,-0.035527792679280246,-0.035527792679280246,-0.004181808119414487,-0.004181808119414487,0.017743246136761343,0.017743246136761343,-0.18342633161097813,-0.18342633161097813,-0.27267207085166967,-0.27267207085166967,-0.10292793799648636,-0.10292793799648636,-0.13447351813997813,-0.13447351813997813,-0.06376549369344467,-0.06376549369344467,-0.08533675959608998,-0.08533675959608998,-0.12559101102360767,-0.12559101102360767,-0.5143222848060427,-0.5143222848060427)
div_upr=c(0.22571353714547598, 0.22571353714547598,0.2287913367909361,0.2287913367909361,0.1242630869652732,0.1242630869652732,0.2467493986091338,0.2467493986091338,0.2700744777595351,0.2700744777595351,-0.019274318212570418,-0.019274318212570418,0.13334883827488808,0.13334883827488808,0.21800118853152703,0.21800118853152703,0.11912845625508811,0.11912845625508811,0.06132696959952537,0.06132696959952537,0.04660159982993854,0.04660159982993854,0.04821339372106231,0.04821339372106231,-0.09617154732833602,-0.09617154732833602)


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
  labs(title = "Synapsida BDNN By Stages With Environmental Predictors",
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
ggsave(file = 'C:/Users/SimoesLabAdmin/Documents/BDNN_Arielli/synapsida/mcmc_fixshift_predictors/C_bdnn_stdscaled_boxcox/combined_10_RTT_final_deeptime.pdf',
       plot = combined_plot, width = 8, height = 10.8, dpi = 300)