library(ape)
library(phylopath)
library(tidyverse)

my_tree <- read.tree('supplementary_material/3_trees/rooted/exabayes_unpartitioned_75.tre') %>% 
  drop.tip(c("Cicoinia_maguari_USNM_614527", "Sula_leucogaster_USNM_622596"))
my_data <- read.csv("supplementary_material/5_coevol/csv4plots/traits_fig3.csv", header=TRUE) %>% 
  rename(tip.label=species)

my_data <- my_data[match(my_tree$tip.label, my_data$tip.label),]
rownames(my_data) <- my_tree$tip.label

models <- define_model_set(
  one   = c(mass ~ popsize + longevity +hwi, popsize ~ longevity + afb),
  two   = c(hwi ~ mass + longevity +popsize, mass ~ longevity + afb),
  three = c(longevity ~ mass + popsize +hwi, mass ~ popsize + afb),
  four  = c(popsize ~ mass + longevity +hwi, mass ~ longevity + afb),
  five  = c(mass ~ hwi, hwi ~ longevity + afb, mass ~ longevity + afb),
  six   = c(popsize ~ mass + longevity +hwi),
  seven   = c(mass ~ popsize + longevity +hwi),
  eight  = c(longevity ~ mass + popsize +hwi),
  nine   = c(hwi ~ mass + popsize +longevity),
  .common = c(mass ~ afb, popsize ~ afb, longevity ~ afb, hwi ~ afb)
)

plot_model_set(models)

result <- phylo_path(models, data = my_data, tree = my_tree, model = 'lambda')

(s <- summary(result))
plot(s)
(best_model <- best(result, boot=10))
plot(best_model)

average_model <- average(result)

plot(average_model, algorithm = 'mds', curvature = 0.1)

average_model_full <- average(result, avg_method = "full")
plot(average_model_full, algorithm = 'mds', curvature = 0.1, 
     show.legend = FALSE,text_size = 5, edge_width = 0.1, box_x = 18, box_y=12,
     colors =  c("darkgrey", "black"),
     arrow = grid::arrow(type = "closed", 14, grid::unit(10, "points")))
 
coef_plot(average_model_full, reverse_order = TRUE) + 
   ggplot2::coord_flip() + 
   ggplot2::theme_classic()
 
