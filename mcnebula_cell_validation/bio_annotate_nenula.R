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
annotate_child_nebulae("Acyl carnitines",
                       layout = "fr",
                       output=".",
                       ## pie diagrame setting
                       ratio_df = ratio_df,
                       palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = mark_df,
                       palette = mark_palette)

