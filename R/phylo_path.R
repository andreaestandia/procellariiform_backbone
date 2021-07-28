library(ape)
library(phylopath)
library(tidyverse)
my_tree <- read.tree('exabayes_75.tre') #Find file in Suppl Data/trees
my_data <- read_csv("all_vars.csv") #Table S5

models <- define_model_set(
  one   = c(mass ~ pop_size + longevity +hwi, pop_size ~ longevity + afb),
  two   = c(hwi ~ mass + longevity +pop_size, mass ~ longevity + afb),
  three = c(longevity ~ mass + pop_size +hwi, mass ~ pop_size + afb),
  four  = c(pop_size ~ mass + longevity +hwi, mass ~ longevity + afb),
  five  = c(mass ~ hwi, hwi ~ longevity + afb, mass ~ longevity + afb),
  six   = c(pop_size ~ mass + longevity +hwi),
  seven   = c(mass ~ pop_size + longevity +hwi),
  eight  = c(longevity ~ mass + pop_size +hwi),
  nine   = c(hwi ~ mass + pop_size +longevity),
  .common = c(mass ~ afb, pop_size ~ afb, longevity ~ afb, hwi ~ afb)
)

plot_model_set(models)
plot(models$nine)

result <- phylo_path(models, data = my_data, tree = my_tree, model = 'lambda')

(s <- summary(result))
plot(s)
(best_model <- best(result, boot=10))
plot(best_model)

average_model <- average(result)

plot(average_model, algorithm = 'mds', curvature = 0.1)

average_model_full <- average(result, avg_method = "full")
plot(average_model_full, algorithm = 'mds', curvature = 0.1, 
     show.legend = FALSE,text_size = 8, edge_width = 0.5,box_x = 18, box_y=12,
     colors =  c("darkgrey", "black"),
     arrow = grid::arrow(type = "closed", 14, grid::unit(10, "points")))
 
coef_plot(average_model_full, reverse_order = TRUE) + 
   ggplot2::coord_flip() + 
   ggplot2::theme_classic()
 
