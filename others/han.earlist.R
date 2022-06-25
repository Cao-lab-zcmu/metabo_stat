## mcnebula run
## ---------------------------------------------------------------------- 
source("~/operation/superstart.R")
# load_all("~/MCnebula/R")
# load_all("~/extra/R")
initialize_mcnebula(".")
collate_structure()
build_classes_tree_list()
collate_ppcp(min_possess = 20, max_possess_pct = 0.1)
generate_parent_nebula(rm_parent_isolate_nodes = T)
## ---------------------------------------------------------------------- 
generate_child_nebulae()
visualize_parent_nebula()
visualize_child_nebulae(width = 15, height = 20, nodes_size_range = c(2, 4))
## ---------------------------------------------------------------------- 
## Aminopyrimidines and derivatives
stat <- format_quant_table("../earlist.neg.csv", 
                           meta.group = c(blank = "BLANK",
                                          # ref.db = "^DB", ref.sa = "^SA",
                                          # mu.pro = "^G",
                                          raw = "^S", pro = "^J"))
## ------------------------------------- 
palette_stat <- c(blank = "grey",
                  # ref.db = "yellow", ref.sa = "#BBFF66",
                  # mu.pro = "#DA70D6",
                  raw = "lightblue", pro = "pink")
## ---------------------------------------------------------------------- 
## mark Taxifolin and SARRACENIN
formula.tax <- "C15H12O7"
formula.sar <- "C11H14O5"
id.tax <- dplyr::filter(.MCn.formula_set, molecularFormula == formula.tax)$.id
id.sar <- dplyr::filter(.MCn.formula_set, molecularFormula == formula.sar)$.id
## mark
nodes_mark <- data.frame(
  .id = c(id.tax, id.sar, "Others"),
  mark = c(rep(c("tax", "sar"), c(length(id.tax), length(id.sar))), "Others")
)
palette <- c(Others = "#D9D9D9", tax = "#DDFF77", sar = "#CCCCFF")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
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
## ---------------------------------------------------------------------- 
## Flavonoids
## Dioxanes parent:Organoheterocyclic compounds
## sar:structure, Hemiacetals
target_class <- "Hemiacetals"
target_index <- method_summarize_target_index(target_class)
hq.structure <- dplyr::filter(.MCn.structure_set, tanimotoSimilarity >= 0.1)
hq.target_index <- dplyr::filter(target_index, .id %in% hq.structure$.id)
## ---------------------------------------------------------------------- 
## re compute similarity
spec.path <- method_target_spec_compare(target_class,
                                        hq.target_index,
                                        edge_filter = 0.5)
## ---------------------------------------------------------------------- 
call_fun_mc.space("generate_parent_nebula",
                  list(write_output = F, edges_file = spec.path),
                  clear_start = T,
                  clear_end = F)
## ---------------------------------------------------------------------- 
test <- call_fun_mc.space("generate_child_nebulae",
                          list(nebula_index = hq.target_index),
                          clear_start = F,
                          clear_end = F)
## ------------------------------------- 
hq.amino <- dplyr::filter(hq.structure, .id %in% hq.target_index$.id)
vis_via_molconvert(hq.amino$smiles, hq.amino$.id)
## ------------------------------------- 
call_fun_mc.space("tmp_anno",
                  list(nebula_name = target_class,
                       nebula_index = hq.target_index),
                  clear_start = F,
                  clear_end = F)
## ---------------------------------------------------------------------- 
mutate_stat <- dplyr::summarise_at(stat, 2:ncol(stat), log2) %>% 
  dplyr::mutate(.id = stat$.id) %>% 
  dplyr::mutate(log2fc = pro - raw,
                change = ifelse(log2fc > 1, "up",
                                ifelse(log2fc < -1, "down", "-"))) %>%
  dplyr::relocate(.id, log2fc, change)
## ---------------------------------------------------------------------- 

