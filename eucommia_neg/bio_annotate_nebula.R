## palette
stat_palette <- c(Blank = "#B8B8B8",
                  `EU-Raw` = "#C6DBEF",
                  `EU-Pro` = "#FDD0A2")
## ---------------------------------------------------------------------- 
## show statistic legend for nebula
m.stat_palette <- stat_palette
names(m.stat_palette) <- c("Blank", "Raw-Eucommia", "Pro-Eucommia")
mutate_show_palette(m.stat_palette, font_size = 25,
             width = 10,
             height = 2,
             title = "",
             fill_lab = "Group",
             legend.position = "bottom",
             legend.key.height = unit(0.5, "cm"),
             legend.key.width = unit(3, "cm"),
             xlab = "", ylab = "", re_order = F)
## ---------------------------------------------------------------------- 
## nodes_mark
mark_df <- data.table::data.table(.id = "3918",
                                  mark = "ID:3918")
mark_palette <- c(Others = "#D9D9D9", `ID:3918` = "#EFC000")
## Pyranones and derivatives
## Iridoid O-glycosides
nebula_name <- "Iridoid O-glycosides"
vis_via_molconvert_nebulae(nebula_name, .MCn.nebula_index,
                           output="mcnebula_results/trace/tmp/structure")
## ------------------------------------- 
annotate_child_nebulae(nebula_name,
                       layout = "fr",
                       output="mcnebula_results/trace",
                       ## pie diagrame setting
                       nodes_mark = mark_df,
                       palette = mark_palette,
                       ratio_df = mean.feature_stat,
                       palette_stat = stat_palette,
                       global.node.size = 0.8,
                       theme_args = list(panel.background = element_rect(),
                                         panel.grid = element_line()))
## ---------------------------------------------------------------------- 
## show statistic legend for nebula


