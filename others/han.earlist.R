## ^start_________________________ 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## [introduction] Run MCnebual basic workflow.
initialize_mcnebula(".")
collate_structure()
build_classes_tree_list()
collate_ppcp(min_possess = 20, max_possess_pct = 0.1)
generate_parent_nebula(rm_parent_isolate_nodes = T)
generate_child_nebulae()
visualize_parent_nebula()
visualize_child_nebulae(width = 15, height = 20, nodes_size_range = c(2, 4))
## ---------------------------------------------------------------------- 
## [introduction] read figure \@ref(fig:test)
## @figure 

# ```{r test, echo = F, fig.cap = "yourname"}
# png <- magick::image_read("~/Pictures/digit.jpg")
# png <- magick::image_resize(png, "300x")
# grid::grid.raster(png)
# ```

## ---------------------------------------------------------------------- 
## [introduction] Format quantification table and summarise mean value for each group.
stat <- format_quant_table("../earlist.neg.csv", 
                           meta.group = c(blank = "BLANK",
                                          raw = "^S", pro = "^J"))
## ------------------------------------- 
## [introduction] Set color palette for each group.
palette_stat <- c(blank = "grey",
                  raw = "lightblue", pro = "pink")
## ---------------------------------------------------------------------- 
## [introduction] Herein, Taxifolin and SARRACENIN are marked in child-nebulae.
## [introduction] Simply, compounds with identical formulae of above were marked with specific color.
formula.tax <- "C15H12O7"
formula.sar <- "C11H14O5"
id.tax <- dplyr::filter(.MCn.formula_set, molecularFormula == formula.tax)$.id
id.sar <- dplyr::filter(.MCn.formula_set, molecularFormula == formula.sar)$.id
nodes_mark <- data.frame(
  .id = c(id.tax, id.sar, "Others"),
  mark = c(rep(c("tax", "sar"), c(length(id.tax), length(id.sar))), "Others")
)
palette <- c(Others = "#D9D9D9", tax = "#DDFF77", sar = "#CCCCFF")
## ---------------------------------------------------------------------- 
## [introduction] A function of visualization of child-nebula was defined for reproducibly use.
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
## [introduction] 'Flavonoids' and 'Iridoids and relative compounds' are classes of interest.
## [introduction] They are classes of Taxifolin and SARRACENIN belong to.
target_class <- "Flavonoids"
target_index <- method_summarize_target_index(target_class)
hq.structure <- dplyr::filter(.MCn.structure_set, tanimotoSimilarity >= 0.1)
hq.target_index <- dplyr::filter(target_index, .id %in% hq.structure$.id)
## ---------------------------------------------------------------------- 
## [introduction] Re-compute the spectral similarity within child-nebula.
spec.path <- method_target_spec_compare(target_class,
                                        hq.target_index,
                                        edge_filter = 0.5)
## ---------------------------------------------------------------------- 
## [introduction] Use the re-computated spectral similarity file to generate parent-nebula. 
call_fun_mc.space("generate_parent_nebula",
                  list(write_output = F, edges_file = spec.path),
                  clear_start = T,
                  clear_end = F)
## ---------------------------------------------------------------------- 
## [introduction] Generate child-nebula.
test <- call_fun_mc.space("generate_child_nebulae",
                          list(nebula_index = hq.target_index),
                          clear_start = F,
                          clear_end = F)
## ------------------------------------- 
## [introduction] Use `molconvert` to visualize chemical structure.
hq.amino <- dplyr::filter(hq.structure, .id %in% hq.target_index$.id)
vis_via_molconvert(hq.amino$smiles, hq.amino$.id)
## ------------------------------------- 
## [introduction] Visualized the child-nebula with annotation of structure and quantification.
call_fun_mc.space("tmp_anno",
                  list(nebula_name = target_class,
                       nebula_index = hq.target_index),
                  clear_start = F,
                  clear_end = F)
## ---------------------------------------------------------------------- 
## [introduction] Check the changes of compounds level during processing.
mutate_stat <- dplyr::summarise_at(stat, 2:ncol(stat), log2) %>% 
  dplyr::mutate(.id = stat$.id) %>% 
  dplyr::mutate(log2fc = pro - raw,
                change = ifelse(log2fc > 1, "up",
                                ifelse(log2fc < -1, "down", "-"))) %>%
  dplyr::relocate(.id, log2fc, change)
## ---------------------------------------------------------------------- 
## $start_________________________ 
