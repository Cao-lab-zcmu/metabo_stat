## for local analysis
## drawn annotated child nebula
## ---------------------------------------------------------------------- 
## add pie diagram
## ---------------------------------------------------------------------- 
## for test
test_ratio <- data.table::data.table(.id = .MCn.formula_set$.id,
                                     sur = rnorm(length(.MCn.formula_set$.id), 10, 5),
                                     mor = rnorm(length(.MCn.formula_set$.id), 20, 10))
stat_palette <- c(sur = .MCn.palette[1],
                  mor = .MCn.palette[2])
## ---------------------------------------------------------------------- 
## draw child nebula
annotate_child_nebulae("Lysophosphatidylcholines",
                       output=".",
                       ## pie diagrame setting
                       # ratio_df = test_ratio,
                       # palette_stat = stat_palette,
                       ## biomarker tracing
                       nodes_mark = mark_df,
                       palette = mark_palette)

