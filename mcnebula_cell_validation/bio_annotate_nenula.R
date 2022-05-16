## for local analysis
## drawn annotated child nebula
## ---------------------------------------------------------------------- 
## add pie diagram
stat_palette <- c(NN = "#C7E9C0FF",
                  HN = "#C6DBEFFF",
                  HS = "#FDAE6BFF",
                  HM = "#B8B8B8FF")
ratio_df <- merge(merge_df[, c("origin_id", ".id")], mean.feature_stat,
                  by = "origin_id", all.x = T) %>% 
  dplyr::distinct(.id, .keep_all = T) %>% 
  dplyr::select(.id, NN, HN, HS, HM) %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 
## show statistic legend for nebula
mutate_show_palette(stat_palette, font_size = 25,
             width = 15,
             height = 2,
             title = "",
             fill_lab = "Group",
             legend.position = "bottom",
             legend.key.height = unit(0.5, "cm"),
             legend.key.width = unit(2, "cm"),
             xlab = "", ylab = "", re_order = F)
## ---------------------------------------------------------------------- 
## draw child nebula
## index
## tmp_nebula_index$name %>% unique
vis_via_molconvert_nebulae("Bile acids, alcohols and derivatives", .MCn.nebula_index,
                           output="tmp/structure")
annotate_child_nebulae("Bile acids, alcohols and derivatives",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = mark_df,
                       palette = mark_palette,
                       global.node.size = 0.6,
                       theme_args = list(panel.background = element_rect(),
                                         panel.grid = element_line())
)
## ac compounds
ac.export <-
  export.dominant %>%
  filter(`InChIKey planar` %in% ac_compound.docu$inchikey2d)
## ---------------------------------------------------------------------- 
## set mark
ac.mark_df <- data.table::data.table(.id = ac.export$id, mark = "Origin ACs") %>% 
  dplyr::bind_rows(mark_df, .) %>% 
  dplyr::distinct(.id, .keep_all = T)
## set palette
ac.mark_palette <- mark_palette %>% 
  c(., `Origin ACs` = "#EFC000")
## Acyl carnitines
vis_via_molconvert_nebulae("Acyl carnitines", .MCn.nebula_index,
                           output="tmp/structure")
annotate_child_nebulae("Acyl carnitines",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = ac.mark_df,
                       palette = ac.mark_palette,
                       global.node.size = 0.6,
                       theme_args = list(panel.background = element_rect(),
                                         panel.grid = element_line())
)
## ---------------------------------------------------------------------- 
## annotate nodes of ACs
## .id = "3286"
annotate_node(node_id = "14196",
              ## pie
              ratio_df = ratio_df,
              palette_stat = stat_palette,
              ## nodes color
              nodes_mark = ac.mark_df,
              palette = ac.mark_palette,
              output=".")
## ---------------------------------------------------------------------- 
vis_via_molconvert_nebulae("Phenylpropanoic acids", .MCn.nebula_index,
                           output="tmp/structure")
annotate_child_nebulae("Phenylpropanoic acids",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = mark_df,
                       palette = mark_palette,
                       global.node.size = 1,
                       theme_args = list(panel.background = element_rect(),
                                         panel.grid = element_line())
)
## ------------------------------------- 
vis_via_molconvert_nebulae("Lysophosphatidylcholines", .MCn.nebula_index,
                           output="tmp/structure")
annotate_child_nebulae("Lysophosphatidylcholines",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = mark_df,
                       palette = mark_palette,
                       global.node.size = 0.6,
                       theme_args = list(panel.background = element_rect(),
                                         panel.grid = element_line())
)

