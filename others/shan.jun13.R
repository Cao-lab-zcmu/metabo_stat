load_all("~/MCnebula/R")
load_all("~/extra/R")
initialize_mcnebula(".")
collate_structure()
build_classes_tree_list()
collate_ppcp(min_possess = 10, max_possess_pct = 0.1, filter_via_struc_score = NA)
generate_parent_nebula(rm_parent_isolate_nodes = T)
generate_child_nebulae(nebula_index = tmp_nebula_index)
visualize_parent_nebula()
## ------------------------------------- 
visualize_child_nebulae()
## ---------------------------------------------------------------------- 
file.rename("mcnebula_results/child_nebulae.svg", "mcnebula_results/origin.svg")
## ---------------------------------------------------------------------- 
nodes_mark <- data.frame(.id = c("339", "1222", "578"),
                         mark = c("Isoacetoside", "Apigenin", "Calceolarioside B")
                         )
palette <- c(Isoacetoside = "yellow",
             Apigenin = "#EAFF56",
             `Calceolarioside B`= "blue",
             Others = "#D9D9D9")
## ---------------------------------------------------------------------- 
visualize_child_nebulae(
  layout = "fr",
  nodes_mark = nodes_mark,
  palette = palette,
  remove_legend_lab = T,
  legend_fill = T,
  legend_position = "bottom",
  nodes_stroke = 0,
  edges_color = "#D9D9D9",
  width = 28,
  height = 35
  # nodes_size_range = c(2, 4)
)
## ---------------------------------------------------------------------- 
# target_class <- c("Benzenediols")
## ---------------------------------------------------------------------- 
stat <- format_quant_table("../quant.csv", 
                           meta.group = c(blank = "KB", ref = "HB", raw = "RCQ", pro = "PCQ"))
stat <- dplyr::select(stat, -blank, -ref)
## ---------------------------------------------------------------------- 
palette_stat <- c(
      blank = 'grey',
      pro = 'pink',
      raw = 'lightblue',
      ref = 'yellow'
    )
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
## ---------------------------------------------------------------------- 
tmp_anno("Benzenediols")
tmp_anno("Flavones")
## ---------------------------------------------------------------------- 
target_index <- method_summarize_target_index("Flavonoid glycosides")
## ---------------------------------------------------------------------- 
generate_child_nebulae(nebula_index = target_index)
tmp_anno("Flavonoid glycosides", target_index)
## ------------------------------------- 
annotate_node("339", ratio_df = stat,
              nodes_mark = nodes_mark,
              palette = palette,
              palette_stat = palette_stat)


