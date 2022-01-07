library(ggplot2)
library(treeio)
library(ggtree)
library(ape)
library(paleotree)
library(deeptime)

tree <-
  read.beast("supplementary_material/3_trees/rooted/beast_UCE_calibrated.tre")
traits <-
  read_csv("supplementary_material/5_coevol/csv4plots/traits_fig3.csv") %>% 
  rename(label = species)

tree2 <- full_join(tree, traits, by = 'label')

ggtree(tree2,
       size = 2.5,
       continuous = T,
       mrsd = "2021-12-12") +
  geom_tree(aes(color = rate_median, continuous = T), size = 2.5)  +
  geom_tree() +
  scale_colour_gradient2(
    midpoint = median(tree2@data$rate_median, na.rm = T),
    low = "#3B6290",
    high = "#FF863D"
  )  +
  theme_tree2(legend.position = 'left') + ggnewscale::new_scale_colour()  +
  geom_tippoint(aes(col = discr_mass, size = 2)) +
  scale_colour_viridis_c()
