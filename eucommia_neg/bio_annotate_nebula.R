## palette
stat_palette <- c(Blank = "#B8B8B8",
                  `EU-Raw` = "#6BAED6",
                  `EU-Pro` = "#FD8D3C")
## nodes_mark
mark_df <- data.table::data.table(.id = "none",
                                  mark = "none")
mark_palette <- c(Others = "#B8B8B8")
annotate_child_nebulae("Iridoid O-glycosides",
                       layout = "fr",
                       output="mcnebula_results/trace",
                       ## pie diagrame setting
                       # nodes_mark = mark_df,
                       # palette = mark_palette,
                       ratio_df = mean.feature_stat,
                       palette_stat = stat_palette)

