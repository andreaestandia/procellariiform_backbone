#setwd("/home/zoo/sjoh4959/Documents/projects/procellariiform_phylogeny/phylo_path/")
library(ape)
library(phylopath)
library(tidyverse)
my_tree <- read.tree('exabayes_unpartitioned_75.tre') #Find file in Suppl Data/trees
my_data <- read_csv("all_vars.csv") #Find file in Suppl Data/coevol
rownames(my_data) <- my_data$species

models <- define_model_set(
  one   = c(mass ~ afb),
  two   = c(mass ~ clutch),
  three = c(mass ~ longevity),
  four  = c(mass ~ pop_size),
  five  = c(mass ~ afb + pop_size + clutch+longevity),
  six   = c(mass ~ afb + pop_size),
  seven = c(mass ~ afb + pop_size + longevity),
  .common = c(mass ~ afb)
)

models <- define_model_set(
  one   = c(mass ~ afb),
  two   = c(clutch ~ pop_size, mass ~ longevity + clutch),
  three = c(mass ~ pop_size),
  four  = c(mass ~ afb + pop_size),
  five  = c(mass ~ afb + pop_size + clutch),
  six   = c(afb ~ mass, pop_size ~ afb + clutch),
  seven = c(pop_size ~ mass, mass ~ longevity + afb),
  eight = c(pop_size ~ mass),
  nine  = c(pop_size ~ mass, mass ~ longevity),
  .common = c(longevity ~ afb, pop_size ~ afb, adult_body_mass ~ pop_size)
)

models <- define_model_set(
  one   = c(Mass ~ AFB, Mass ~ pop_size),
  two   = c(Clutch ~ pop_size, Mass ~ Longevity),
  three = c(Longevity ~ pop_size),
  four  = c(Mass ~ AFB + pop_size + Longevity),
  five  = c(Mass ~ AFB + pop_size + Clutch),
  six   = c(Longevity ~ pop_size, Mass ~ AFB + Clutch),
  seven = c(pop_size ~ Mass + Longevity, Mass ~ Longevity + AFB),
  eight = c(pop_size ~ Mass + AFB),
  nine  = c(pop_size ~ Mass, Mass ~ Longevity+Clutch),
  .common = c(Mass ~ AFB, pop_size ~ AFB)
)

plot_model_set(models)
plot(models$nine)

result <- phylo_path(models, data = my_data, tree = my_tree, model = 'lambda')

(s <- summary(result))
plot(s)
(best_model <- best(result, boot=1000))
plot(best_model)

average_model <- average(result)

plot(average_model, algorithm = 'mds', curvature = 0.1)

average_model_full <- average(result, avg_method = "full")
plot(average_model_full, algorithm = 'mds', curvature = 0.1, 
     show.legend = FALSE,text_size = 4, edge_width = 0.5,box_x = 18, box_y=12,
     colors =  c("darkgrey", "black"),
     arrow = grid::arrow(type = "closed", 14, grid::unit(10, "points")))
 
coef_plot(average_model_full, reverse_order = TRUE) + 
   ggplot2::coord_flip() + 
   ggplot2::theme_classic()
 
