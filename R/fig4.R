library(tidyverse)
library(gghighlight)
library(patchwork)

text_size=12

df <-
  read.table("supplementary_material/5_coevol/csv4plots/coevol_nopopsize.csv",
             header = TRUE) 

afb <- 
  df %>%
  ggplot(aes(x = log(afb_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#cfc261") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#cfc261"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nAFB", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

body <- df %>%
  ggplot(aes(x = log(body_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#789c64") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#789c64"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nBody size", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

hwi <- df %>%
  ggplot(aes(x = log(hwi_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#74a198") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#74a198"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nHWI", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

longevity <- df %>%
  ggplot(aes(x = log(longevity_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#84649c") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#84649c"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nLongevity", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

popsize <- df %>%
  ggplot(aes(x = log(pop_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#9c6a7b") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#9c6a7b"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nPopulation size", title = "") +
  gghighlight::gghighlight(true_false == TRUE)


corr_wo_pop <- (afb + body) / (hwi + longevity)

df <-
  read.table(
    "supplementary_material/5_coevol/csv4plots/coevol_allvars.csv",
    header = TRUE
  )

afb <- df %>%
  ggplot(aes(x = log(afb_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#cfc261") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#cfc261"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nAFB", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

body <- df %>%
  ggplot(aes(x = log(body_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#789c64") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#789c64"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nBody size", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

hwi <- df %>%
  ggplot(aes(x = log(hwi_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#74a198") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#74a198"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nHWI", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

longevity <- df %>%
  ggplot(aes(x = log(longevity_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#84649c") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#84649c"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nLongevity", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

popsize <- df %>%
  ggplot(aes(x = log(pop_avg),
             y = dS2_avg)) +
  geom_jitter(alpha = 0.9, col = "#9c6a7b") +
  geom_smooth(
    method = "lm",
    color = "#343536",
    size = 0.5,
    fill = "#9c6a7b"
  ) +
  theme(
    plot.title = element_text(size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(vjust = 0.9,
                               hjust = 1,),
    axis.text.y =  element_text(),
    axis.title.x = element_text(),
    axis.title.y = element_text(),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nPopulation size", title = "") +
  gghighlight::gghighlight(true_false == TRUE)

corr_w_pop <- (afb + body + popsize) / (hwi + longevity)
