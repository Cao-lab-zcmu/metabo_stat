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
## draw child nebula
## index
## tmp_nebula_index$name %>% unique
annotate_child_nebulae("Bile acids, alcohols and derivatives",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = mark_df,
                       palette = mark_palette,
                       global.node.size = 0.6)
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
annotate_child_nebulae("Acyl carnitines",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = ac.mark_df,
                       palette = ac.mark_palette,
                       global.node.size = 0.6)
## ---------------------------------------------------------------------- 
annotate_child_nebulae("Phenylpropanoic acids",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = mark_df,
                       palette = mark_palette,
                       global.node.size = 1)

