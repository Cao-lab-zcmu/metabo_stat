## mcnebula run
## ---------------------------------------------------------------------- 
source("~/operation/superstart.R")
# load_all("~/MCnebula/R")
# load_all("~/extra/R")
initialize_mcnebula(".")
collate_structure()
build_classes_tree_list()
collate_ppcp(min_possess = 10, max_possess_pct = 0.07, filter_via_struc_score = NA)
generate_parent_nebula()
generate_child_nebulae()
visualize_parent_nebula()
visualize_child_nebulae(width = 15, height = 20, nodes_size_range = c(2, 4))
## ---------------------------------------------------------------------- 
## Aminopyrimidines and derivatives
nebula_name <- "Aminopyrimidines and derivatives"
annotate_child_nebulae(nebula_name,
                       layout = "fr",
                       ## pie diagrame setting
                       # nodes_mark = mark_df,
                       # palette = mark_palette,
                       # ratio_df = mean.feature_stat,
                       # palette_stat = stat_palette,
                       global.node.size = 0.8,
                       theme_args = list(panel.background = element_rect(),
                                         panel.grid = element_line()))

