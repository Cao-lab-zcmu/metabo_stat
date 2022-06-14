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
ratio_df <- data.table::fread("~/Downloads/shangzha0609.csv") %>% 
  dplyr::select(-2, -3) %>%
  dplyr::select(1:9) %>%
  dplyr::rename(.id = 1)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
nebula_name <- "Peptidomimetics"
annotate_child_nebulae(nebula_name,
                       layout = "fr",
                       ## pie diagrame setting
                       # nodes_mark = mark_df,
                       # palette = mark_palette,
                       ratio_df = ratio_df,
                       global.node.size = 0.8,
                       width = 8,
                       theme_args = list(panel.background = element_rect(),
                                         panel.grid = element_line()))

