library(treeio)
library(ggtree)
library(ape)
library(paleotree)

tree <- read.beast("/home/zoo/sjoh4959/Documents/projects/procellariiform_phylogeny/0.0_submission/supplementary/trees/beast_random_UCE_timecalibrated.tre")

tree@phylo$root.time <- 60.5

tree2 <- drop.tip(tree, c("Spheniscus_demersus_USNM_631252", "Cicoinia_maguari_USNM_614527", "Sula_leucogaster_USNM_622596"))

ggtree(tree2, size=2.5)+
geom_tree(aes(color=log(rate_median)), continuous = TRUE, size=2.5)  + 
  geom_tree() + 
  scale_colour_gradient2(midpoint=mean(log(tree2@data$rate_median)),
                         low="#3B6290", 
                         high="#FF863D")  + 
  theme_tree(legend.position='none') + scale_x_continuous(labels=abs)# + geom_tiplab()
tree@info

write.beast(tree2, "fig3.tre")