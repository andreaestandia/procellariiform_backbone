##SCRIPT to make Figure S8 and Figure 4##
library(tidyverse)
library(patchwork)
text_size=12

high_gc <- read_delim("high_gc.csv", delim="\t") %>% filter(true_false==FALSE)
low_gc <- read_delim("low_gc.csv", delim="\t") %>% filter(true_false==FALSE)

low_plot1 <- low_gc %>%
  ggplot(aes(x = log(afb),
             y = t))+
             geom_jitter(alpha = 0.9, col = "#87679c") + 
               geom_smooth(method = "lm",
                           color = "#343536",
                           size = 0.5) +
               theme(
                 plot.title = element_text(family = "Ubuntu", size = text_size),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank(),
                 axis.ticks.x = element_blank(),
                 #axis.text.x = element_blank(),
                 axis.text.x = element_text(
                   vjust = 0.9,
                   hjust = 1,
                   family = "Ubuntu"
                 ),
                 axis.text.y =  element_blank(),
                 axis.title.x = element_text(family = "Ubuntu"),
                 axis.title.y = element_text(family = "Ubuntu"),
                 axis.ticks.y = element_blank()
               ) + labs(y = "Substitution rate\n", x = "\nAFB", title = "Low GC content\n\n")

low_plot2 <- low_gc %>%
  ggplot(aes(x = log(mass),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#87679c") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nMass", title = "")

low_plot3 <- low_gc %>%
  ggplot(aes(x = log(clutch),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#87679c") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nClutch", title = "")

low_plot4 <- low_gc %>%
  ggplot(aes(x = log(longevity),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#87679c") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nLongevity", title = "") 

low_plot5 <- low_gc %>%
  ggplot(aes(x = log(pop_size),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#87679c") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nPopulation size", title = "")
             
plot_low <- low_plot1 + low_plot2+low_plot3+low_plot4+low_plot5+ plot_layout(nrow = 5, byrow = FALSE)+  
  plot_annotation(title = 'Low GC content')


high_plot1 <- high_gc %>%
  ggplot(aes(x = log(body),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#4e8a99") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nAFB", title = "High GC content\n\n")
high_plot2 <- high_gc %>%
  ggplot(aes(x = log(mass),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#4e8a99") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nMass", title = "")

high_plot3 <- high_gc %>%
  ggplot(aes(x = log(clutch),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#4e8a99") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nClutch", title = "")

high_plot4 <- high_gc %>%
  ggplot(aes(x = log(longevity),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#4e8a99") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nLongevity", title = "")

high_plot5 <- high_gc %>%
  ggplot(aes(x = log(pop_size),
             y = t))+
  geom_jitter(alpha = 0.9, col = "#4e8a99") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5) +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_blank(),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nPopulation size", title = "")

plot_combined <- low_plot1 + high_plot1+low_plot2+ high_plot2+low_plot3+high_plot3+
  low_plot4+high_plot4+low_plot5+high_plot5+ plot_layout(nrow = 5,ncol=2) 



ggsave(
  plot = plot_combined,
  filename = "gc_plot_2.png",
  path = getwd(),
  device = "png",
  scale=1,
  width = 20,
  height = 30,
  dpi = 400,
  units = "cm"
)


total <- read.csv("total.csv") #%>% filter(true_false==TRUE)# %>% 

afb <- total %>%
  ggplot(aes(x = log(avg_afb),
             y = avg_dS))+
  geom_jitter(alpha = 0.9, col = "#cfc261") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5,
              fill= "#cfc261") +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_text(family = "Ubuntu"),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nAFB", title = "") +
  gghighlight::gghighlight(true_false==TRUE)

body <- total %>%
  ggplot(aes(x = log(avg_body),
             y = dS2))+
  geom_jitter(alpha = 0.9, col = "#789c64") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5,
              fill= "#789c64") +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_text(family = "Ubuntu"),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nBody size", title = "") +
  gghighlight::gghighlight(true_false==TRUE)

clutch <- total %>%
  ggplot(aes(x = log(avg_clutch),
             y = avg_dS))+
  geom_jitter(alpha = 0.9, col = "#74a198") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5,
              fill="#74a198") +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_text(family = "Ubuntu"),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nClutch size", title = "") +
  gghighlight::gghighlight(true_false==TRUE)

longevity <- total %>%
  ggplot(aes(x = log(avg_longevity),
             y = avg_dS))+
  geom_jitter(alpha = 0.9, col = "#84649c") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5,
              fill="#84649c") +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_text(family = "Ubuntu"),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nLongevity", title = "") +
  gghighlight::gghighlight(true_false==TRUE)

popsize <- total %>%
  ggplot(aes(x = log(avg_pop_size),
             y = avg_dS))+
  geom_jitter(alpha = 0.9, col = "#9c6a7b") + 
  geom_smooth(method = "lm",
              color = "#343536",
              size = 0.5,
              fill="#9c6a7b") +
  theme(
    plot.title = element_text(family = "Ubuntu", size = text_size),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.ticks.x = element_blank(),
    #axis.text.x = element_blank(),
    axis.text.x = element_text(
      vjust = 0.9,
      hjust = 1,
      family = "Ubuntu"
    ),
    axis.text.y =  element_text(family = "Ubuntu"),
    axis.title.x = element_text(family = "Ubuntu"),
    axis.title.y = element_text(family = "Ubuntu"),
    axis.ticks.y = element_blank()
  ) + labs(y = "Substitution rate\n", x = "\nPopulation size", title = "") +
  gghighlight::gghighlight(true_false==TRUE)

(afb+body+popsize)/(clutch+longevity)
