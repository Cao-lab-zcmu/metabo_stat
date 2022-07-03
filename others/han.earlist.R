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
visualize_parent_nebula(layout = "kk", width = 20, height = 17)
## ---------------------------------------------------------------------- 
## [introduction] The parent-nebula shows the superclass of compounds in dataset (Fig. \@ref(fig:parentnebula)).
## [introduction] However, it was too informatics to illustration.
## @figure 

# ```{r parentnebula, echo = F, fig.cap = "parent-nebula", fig.width = 15, fig.height = 15}
# show_png("parent_nebula/parent_nebula.svg", "3000x")
# ```

## ---------------------------------------------------------------------- 
visualize_child_nebulae(width = 15, height = 20, nodes_size_range = c(2, 4))
## ---------------------------------------------------------------------- 
## [introduction] The child-nebulae shows the overall abundant classes and compound distribution for dataset (Fig. \@ref(fig:childnebulae)).
## @figure 

# ```{r childnebulae, echo = F, fig.cap = "child-nebulae", fig.width = 15, fig.height = 15}
# show_png("child_nebulae.svg", "3000x")
# ```

## ---------------------------------------------------------------------- 
## [introduction] Format quantification table and summarise mean value for each group (Table 1).
stat <- format_quant_table("../earlist.neg.csv", 
                           meta.group = c(blank = "BLANK",
                                          raw = "^S", pro = "^J"))
## ---------------------------------------------------------------------- 
## @tbl

# ```{r quant, echo = F}
# dplyr::as_tibble(stat) %>% 
#   head() %>%
#   knitr::kable(format = "latex", booktabs = T, caption = "mean level (peak area) of feature in each group")
# ```

## ---------------------------------------------------------------------- 
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
## [introduction] 'Flavonoids' and 'Iridoids and derivatives' are classes of interest.
## [introduction] They are classes of Taxifolin and SARRACENIN belong to.
## [introduction] Due to 'Flavonoids' not exists in nebula-index (Fig. \@ref(fig:childnebulae)),
## [introduction] MCnebula was used to target clustering the 'Flavonoids'.
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
## [introduction] Figure \@ref(fig:flavo) show 'Flavonoids'...
## @figure 

# ```{r flavo, echo = F, fig.cap = "child-nebula of Flavonoids", fig.width = 15, fig.height = 15}
# show_png("Flavonoids_graph.svg", "3000x")
# ```

## ---------------------------------------------------------------------- 
## [introduction] Subsequently, the child-nebula of 'Iridoids and derivatives' was visualized.
iri.index <- dplyr::filter(.MCn.nebula_index, name == 'Iridoids and derivatives')
hq.iri <- dplyr::filter(hq.structure, .id %in% iri.index$.id)
vis_via_molconvert(hq.amino$smiles, hq.amino$.id)
tmp_anno('Iridoids and derivatives')
## ---------------------------------------------------------------------- 
## [introduction] Figure \@ref(fig:iri) show 'Iridoids and derivatives'...
## @figure 

# ```{r iri, echo = F, fig.cap = "child-nebula of Iridoids.", fig.width = 15, fig.height = 15}
# show_png("Iridoids and derivatives_graph.svg", "3000x")
# ```

## ---------------------------------------------------------------------- 
## [introduction] The extracted ion chromatogram of specific ID (Taxifolin and SARRACENIN)...
## The package could found at: <https://github.com/Cao-lab-zcmu/utils_tool>
devtools::load_all("~/utils_tool")
metadata <- format_quant_table("../earlist.neg.csv", get_metadata = T,
                               meta.group = c(blank = "BLANK", raw = "^S", pro = "^J")) %>% 
  dplyr::slice(-1)
stack_ms1(idset = c(id.tax, id.sar),
          metadata = metadata,
          quant.path = "../earlist.neg.csv",
          mzml.path = "../Thermo_raw",
          palette = palette_stat
)
## ---------------------------------------------------------------------- 
## [introduction] Figure \@ref(fig:eic)...
## @figure 

# ```{r eic, echo = F, fig.cap = "EIC of candidates feature of Taxifolin and SARRACENIN", fig.width = 15, fig.height = 15}
# show_png("EIC.svg", "3000x")
# ```

## ---------------------------------------------------------------------- 
## [introduction] The MS/MS spectrum of specific ID...
stack_ms2(c(id.tax, id.sar))
## ---------------------------------------------------------------------- 
## [introduction] Figure \@ref(fig:ms2)
## @figure 

# ```{r ms2, echo = F, fig.cap = "MS/MS spectrum of candidates feature of Taxifolin and SARRACENIN", fig.width = 15, fig.height = 15}
# show_png("mirror.ms2.png", "3000x")
# ```

## ---------------------------------------------------------------------- 
## [introduction] ## Differential analysis
## [introduction] 
## [introduction] Limma [@gentleman_limma_2005-1] is generally used for gene differential expression analysis.
## [introduction] Here, we use several statistical functions in limma to analyze the difference of compound level between
## [introduction] raw. and pro..
quant <- format_quant_table("../earlist.neg.csv", get_raw_level = T,
                            meta.group = c(blank = "BLANK", raw = "^S", pro = "^J")) %>%
  dplyr::select(-(1:4)) %>% 
  data.frame() %>%
  .[, metadata$sample] %>% 
  scale()
rownames(quant) <- stat$.id
## group 
group <- factor(metadata$group)
## design matrix
design <- model.matrix(~ 0 + group)
colnames(design) <- gsub("group", "", colnames(design))
## contrast matrix
contrast <- limma::makeContrasts(pro - raw, levels = design)
## ---------------------------------------------------------------------- 
## [introduction] Use `limma::lmFit` to fit data with linear regression model
fit <- limma::lmFit(quant, design)
con.fit <- limma::contrasts.fit(fit, contrast)
ebayes.con.fit <- limma::eBayes(con.fit)
## ---------------------------------------------------------------------- 
## [introduction] The results (Table 2):
top <- limma::topTable(ebayes.con.fit, adjust="BH", lfc = 0.5) %>% 
  dplyr::mutate(.id = rownames(.)) %>% 
  dplyr::relocate(.id) %>% 
  dplyr::as_tibble()
## save the results
all.results <- limma::topTable(ebayes.con.fit, adjust="BH", number = Inf) %>% 
  dplyr::mutate(.id = rownames(.)) %>% 
  dplyr::relocate(.id) %>% 
  dplyr::as_tibble()
write_tsv(all.results, "Statistic_reults.tsv")
## ---------------------------------------------------------------------- 
## @tbl

# ```{r lmfit, echo = F}
# top %>% 
#   knitr::kable(format = "latex", booktabs = T, caption = "linear regression and statistic results of compounds level")
# ```

## ---------------------------------------------------------------------- 
## [introduction] Marking the top compounds in child-nebulae:
nodes_mark <- data.table::data.table(.id = top$.id, mark = "top10") %>% 
  dplyr::bind_rows(nodes_mark)
palette <- c(palette, top10 = "yellow")
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
## [introduction] Figure \@ref(fig:marknebula)
## @figure 

# ```{r marknebula, echo = F, fig.cap = "Top 10 compouunds in child-nebulae", fig.width = 15, fig.height = 15}
# show_png("top10_child.png", "3000x")
# ```

## ---------------------------------------------------------------------- 
stack_ms1(idset = top$.id,
          metadata = metadata,
          quant.path = "../earlist.neg.csv",
          mzml.path = "../Thermo_raw",
          palette = palette_stat
)
top10.struc <- dplyr::filter(.MCn.structure_set, .id %in% top$.id)
vis_via_molconvert(top10.struc$smiles, top10.struc$.id)
stack_ms2(idset = top$.id)
## ---------------------------------------------------------------------- 
## [introduction] Figure \@ref(fig:topeic)...
## @figure 

# ```{r topeic, echo = F, fig.cap = "EIC of Top 10 compounds", fig.width = 15, fig.height = 15}
# show_png("top10.EIC.png", "3000x")
# ```

## ---------------------------------------------------------------------- 
## [introduction] Figure \@ref(fig:topms2)...
## @figure 

# ```{r topms2, echo = F, fig.cap = "MS/MS spectrum of Top 10 compounds", fig.width = 15, fig.height = 15}
# show_png("top10_mirror.ms2.png", "3000x")
# ```

## ---------------------------------------------------------------------- 
## [introduction] Export compound identification table...
## [introduction] The script could find in <https://github.com/Cao-lab-zcmu/metabo_stat/tree/master/mcnebula_cell_validation>
source("~/outline/mcnebula_cell_validation/get_real_class.R")
source("~/outline/mcnebula_cell_validation/export.step0_manual.select.class.R")
source("~/outline/mcnebula_cell_validation/export.step1_class.R")
source("~/outline/mcnebula_cell_validation/export.step1.5_iupacname.R")
source("~/outline/mcnebula_cell_validation/export.step2_name.diff.vari.R")
source("~/outline/mcnebula_cell_validation/export.step3_format.R")
source("~/outline/mcnebula_cell_validation/export.step9_gt.R")
## ---------------------------------------------------------------------- 
## $start_________________________ 
