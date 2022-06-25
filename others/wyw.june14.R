## mcnebula run
## ---------------------------------------------------------------------- 
source("~/operation/superstart.R")
# load_all("~/MCnebula/R")
# load_all("~/extra/R")
initialize_mcnebula(".")
collate_structure()
build_classes_tree_list()
collate_ppcp(min_possess = 10, max_possess_pct = 0.1)
generate_parent_nebula(rm_parent_isolate_nodes = T)
## ---------------------------------------------------------------------- 
generate_child_nebulae()
visualize_parent_nebula()
visualize_child_nebulae(width = 15, height = 20, nodes_size_range = c(2, 4))
## ---------------------------------------------------------------------- 
stat <- format_quant_table("../trip.csv", 
                           meta.group = c(blank = "BLANK", KA = "KA", PA = "PA"))
## ------------------------------------- 

palette_stat <- c(blank = "grey", KA = "lightblue", PA = "pink")
## ---------------------------------------------------------------------- 
nodes_mark <- data.frame(
                         .id = c(
                                 "Others"
                                 ),
                         mark = c(
                                  "Others"
                         )
)
palette <- c(Others = "#D9D9D9")
## ---------------------------------------------------------------------- 
tmp_anno <- function(nebula_name, nebula_index = .MCn.nebula_index){
  annotate_child_nebulae(
    ## string, i.e. class name in nebula-index
    nebula_name = nebula_name,
    nebula_index = nebula_index,
    layout = "fr",
    ## a table to mark color of nodes
    nodes_mark = nodes_mark,
    plot_nodes_id = T,
    plot_structure = T,
    plot_ppcp = T,
    ## manually define the color of nodes
    palette = palette,
    ## feature quantification table
    ratio_df = stat,
    ## A vector of the hex color with names or not
    palette_stat = palette_stat,
    ## control nodes size in child-nebula, zoom in or zoom out globally.
    global.node.size = 0.8,
    ## the args of `ggplot::theme`
    theme_args = list(
      panel.background = element_rect(),
      panel.grid = element_line()
    ),
    return_plot = F
  )
}
nebula_name <- "Triterpenoids"
tmp_anno(nebula_name)
## ---------------------------------------------------------------------- 
method_target_spec_compare(nebula_name)
generate_parent_nebula(write_output = F,
                       edges_file = paste0(.MCn.output, "/", .MCn.results, "/", nebula_name, ".spec.tsv"))
generate_child_nebulae()
tmp_anno(nebula_name)
## ---------------------------------------------------------------------- 
# target_index <- method_summarize_target_index("Amino acids, peptides, and analogues")
# ## ---------------------------------------------------------------------- 
# generate_child_nebulae(nebula_index = target_index)

