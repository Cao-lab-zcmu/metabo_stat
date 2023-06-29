# ==========================================================================
# neg
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# setwd("/media/echo/王璐-1/mar4_analysis/pos")
setwd("/media/echo/喜/may4_analysis/neg/")

# workflow(mode = "print")

s0.1 <- new_section("Abstract", 1, reportDoc$abstract, NULL)

s0.2 <- new_section("Introduction", 1, reportDoc$introduction, NULL)

s0.3 <- new_section("Set-up", 1, reportDoc$setup,
  rblock({
    library(MCnebula2)
    library(exMCnebula2)
  }, F)
)

s0.9 <- new_heading("Integrate data and Create Nebulae", 1)

s1 <- new_heading("Initialize analysis", 2)

s1.1 <- new_section2(
  c("Set SIRIUS project path and its version to initialize mcnebula object."),
  rblock({
    mcn <- mcnebula()
    mcn <- initialize_mcnebula(mcn, "sirius.v5", ".")
    ion_mode(mcn) <- "neg"
  }, F)
)

load("mcn.rdata")
project_path(mcn) <- "../../GU_neg"
mcn <- collate_data(mcn, ".canopus")

s1.5 <- new_section2(
  c("Create a temporary folder to store the output data."),
  rblock({
    tmp <- paste0("temp_data")
    dir.create(tmp, F)
    export_path(mcn) <- tmp
  })
)

s2 <- new_heading("Filter candidates", 2)

s2.1 <- new_section2(
  reportDoc$filter,
  rblock({
    mcn <- filter_structure(mcn)
    mcn <- create_reference(mcn)
    mcn <- filter_formula(mcn, by_reference = T)
  })
)

s3 <- new_heading("Filter chemical classes", 2)

s3.1 <- new_section2(
  reportDoc$stardust,
  rblock({
    mcn <- create_stardust_classes(mcn)
    mcn <- create_features_annotation(mcn)
    mcn <- cross_filter_stardust(mcn, min_number = 30, max_ratio = .07)
    classes <- unique(stardust_classes(mcn)$class.name)
    table.filtered.classes <- backtrack_stardust(mcn)
  })
)

s3.5 <- new_section2(
  c("Manually filter some repetitive classes or sub-structural classes.",
    "By means of Regex matching, we obtained a number of recurring",
    "name of chemical classes that would contain manay identical compounds",
    "as their sub-structure."),
  rblock({
    classes
    pattern <- c("fatty acid", "hydroxy", "^Ar", "^Alk", "^Ben", "^orga",
      "^Carbo", "pyr", "benzen", "Purine", "Imidazoles", "Fatty")
    dis <- unlist(lapply(pattern, grep, x = classes, ignore.case = T))
    dis <- classes[dis]
    dis
  }, args = list(eval = T))
)

s3.6 <- new_section2(
  c("Remove these classes."),
  rblock({
    mcn <- backtrack_stardust(mcn, dis, remove = T)
  })
)

s4 <- new_heading("Create Nebulae", 2)

s4.1 <- new_section2(
  c("Create Nebula-Index data. This data created based on 'stardust_classes' data."),
  rblock({
    mcn <- create_nebula_index(mcn)
  })
)

s4.5 <- new_section2(
  reportDoc$nebulae,
  rblock({
    mcn <- compute_spectral_similarity(mcn)
    mcn <- create_parent_nebula(mcn)
    mcn <- create_child_nebulae(mcn)
  })
)

s5 <- new_heading("Visualize Nebulae", 2)

s5.1 <- new_section2(
  c("Create layouts for Parent-Nebula or Child-Nebulae visualizations."),
  rblock({
    mcn <- create_parent_layout(mcn)
    mcn <- create_child_layouts(mcn)
    mcn <- activate_nebulae(mcn)
  })
)

s5.3 <- new_section2(
  c("The available chemical classes for visualization and its",
    "sequence in storage."),
  rblock({
    table.nebulae <- visualize(mcn)
    table.nebulae
  }, args = list(eval = T))
)

s5.6 <- new_section2(
  c("Draw and save as .png or .pdf image files."),
  rblock({
    fig.s <- 1.6
    p <- visualize(mcn, "parent")
    ggsave(f5.61 <- paste0(tmp, "/parent_nebula.png"), p)
    pdf(f5.62 <- paste0(tmp, "/child_nebula.pdf"), 12 * fig.s, 14 * fig.s)
    visualize_all(mcn)
    dev.off()
  })
)

s5.6.fig1 <- include_figure(f5.61, "parent", "Parent-Nebula")
s5.6.fig2 <- include_figure(f5.62, "child", "Child-Nebulae")

ref <- function(x) {
  paste0("(Fig. ", get_ref(x), ")")
}

s5.8 <- c(
  "In general, Parent-Nebulae", ref(s5.6.fig1),
  "is too informative to show, so Child-Nebulae", ref(s5.6.fig2),
  "was used to dipict the abundant classes of features (metabolites)",
  "in a grid panel, intuitively. In a bird's eye view of",
  "Child-Nebulae, we can obtain many characteristics of features,",
  "involving classes distribution, structure identified accuracy, as",
  "well as spectral similarity within classes."
)

s6 <- new_heading("Nebulae for Downstream analysis", 1)

## Statistic analysis
s7 <- new_heading("Statistic analysis", 2)

s7.1 <- new_section2(
  c("Next we perform a statistical analysis with quantification data of the",
    "features. Note that the SIRIUS project does not contain quantification",
    "data of features, so our object `mcn` naturally does not contain",
    "that either. We need to get it from elsewhere."),
  rblock({
    origin <- data.table::fread("../neg_feature.csv")
    origin <- tibble::as_tibble(origin)
  })
)

s7.2 <- new_section2(
  c("Now, let's check the columns in the table."),
  rblock({
    origin
  }, args = list(eval = T))
)

s7.3 <- new_section2(
  c("Remove the rest of the columns and keep only the columns for ID,",
    "m/z, retention time, and quantification."),
  rblock({
    quant <- dplyr::select(
      origin, id = 1, dplyr::contains("Peak area")
    )
    colnames(quant) <- gsub("\\.mzML Peak area", "", colnames(quant))
    quant <- dplyr::mutate(quant, .features_id = as.character(id))
  })
)

s7.6 <- new_section2(
  c("Create the metadata table and store it in the `mcn` object",
    "along with the quantification data."),
  rblock({
    gp <- c(Raw = "BZraw", Pro = "processing", Blank = "blank")
    metadata <- MCnebula2:::group_strings(colnames(quant), gp, "sample")
    features_quantification(mcn) <- dplyr::select(quant, -id)
    sample_metadata(mcn) <- metadata
  })
)

s7.7 <- new_section2(
  c(reportDoc$statistic, "", "In the following we use the",
    "`binary_comparison` function for variance analysis.",
    "To accommodate the downstream analysis of gene",
    "expression that the `limma` package was originally used for, we",
    "should log2-transform and centralize this data",
    "(use the default parameter 'fun_norm' of `binary_comparison()`)."),
  rblock({
    mcn <- binary_comparison(
      mcn, Pro - Raw
    )
    top.list <- top_table(statistic_set(mcn))
  })
)

s7.8 <- new_section2(
  c("Check the results."),
  rblock({
    top.list[1]
  }, args = list(eval = T, echo = T))
)

## Set tracer in Child-Nebulae
s8 <- new_heading("Set tracer in Child-Nebulae", 2)

s8.1 <- new_section2(
  reportDoc$tracer,
  rblock({
    n <- 50
    ## tani.score > 0.5, |log2(fc)| > 0.3, p.adjust.val < 0.05
    tops <- select_features(
      mcn, tani.score_cutoff = .5, order_by_coef = 1, coef = 1,
      togather = T
    )
    top20 <- tops[1:n]
    palette_set(melody(mcn)) <- colorRampPalette(palette_set(mcn))(n)
    mcn2 <- set_tracer(mcn, top20)
    mcn2 <- create_child_nebulae(mcn2)
    mcn2 <- create_child_layouts(mcn2)
    mcn2 <- activate_nebulae(mcn2)
    mcn2 <- set_nodes_color(mcn2, use_tracer = T)
  })
)

s8.2 <- new_section2(
  c("Draw and save the image."),
  rblock({
    pdf(f8.2 <- paste0(tmp, "/tracer_child_nebula.pdf"), 12 * 1.2, 14 * 1.2)
    visualize_all(mcn2)
    dev.off()
  })
)

s8.2.fig1 <- include_figure(f8.2, "tracer", "Tracing top features in Child-Nebulae")

s8.3 <- c("A part of the top features are marked with colored nodes in",
          "Child-Nebulae", paste0(ref(s8.2.fig1), "."))

s8.4 <- new_section2(
  c("Tops in classes: "),
  rblock({
    showTops <- select_features(
      mcn, tani.score_cutoff = .5, order_by_coef = 1, coef = 1,
    )
    showTops
  }, args = list(eval = T, echo = T))
)

s9 <- new_heading("Quantification in Child-Nebulae", 2)

s9.1 <- new_section2(
  c("Show Fold Change (Pro versus Raw) in Child-Nebulae."),
  rblock({
    palette_gradient(melody(mcn2)) <- c("blue", "grey90", "red")
    mcn2 <- set_nodes_color(mcn2, "logFC", top.list[[1]])
    pdf(f9.1 <- paste0(tmp, "/logFC_child_nebula.pdf"), 12, 14)
    visualize_all(mcn2, fun_modify = modify_stat_child)
    dev.off()
  })
)

s9.1.fig1 <- include_figure(f9.1, "logFC", "Show log2(FC) in Child-Nebulae")

s9.2 <- c("Each Child-Nebula separately shows the overall content variation of",
          "the chemical class to which it belongs", ref(s9.1.fig1), ".")

s10 <- new_heading("Annotate Nebulae", 2)

s10.1 <- new_section2(
  c("Now, the available Nebulae contains:"),
  rblock({
    table.nebulae2 <- visualize(mcn2)
    table.nebulae2
  }, args = list(eval = T))
)

s10.2 <- new_section2(
  c("Next, let us focus on some specific classes."),
  rblock({
    mcn2 <- set_nodes_color(mcn2, use_tracer = T)
    palette_stat(melody(mcn2)) <- c(
      Raw = "#B6DFB6", Pro = "lightyellow"
    )
    focus_classes <- c("Flavones", "Triterpenoids")
    for (i in focus_classes) {
      mcn2 <- annotate_nebula(mcn2, i)
    }
  })
)

s10.3 <- new_section2(
  c("Draw and save the image."),
  rblock({
    fs <- as.list(focus_classes)
    names(fs) <- focus_classes
    for (i in focus_classes) {
      p <- visualize(mcn2, i, annotate = T)
      ggsave(fs[[ i ]] <- paste0(tmp, "/", gsub(" ", "_", i), "_child.pdf"), p, height = 5)
    }
    pdf(leg <- paste0(tmp, "/feature_4409.pdf"), 15, 6)
    show_node(mcn2, "4409")
    dev.off()
  })
)

s10.4.fig1 <- include_figure(fs[[1]], "ClassA", paste0("Annotated Nebulae: ", names(fs[1])))
s10.4.fig1.5 <- include_figure(leg, "legendF", "Legend of Nodes")
s10.4.fig2 <- include_figure(fs[[2]], "ClassB", paste0("Annotated Nebulae: ", names(fs[2])))

s12 <- new_heading("Export for Cytoscape", 2)

s12.1 <- new_section2(
  c("Export Child-Nebula of `indo` and others as '.graphml'."),
  rblock({
    res <- igraph(child_nebulae(mcn2))
    lapply(
      names(res),
      function(name) {
        igraph::write_graph(
          res[[name]],
          file = paste0(tmp, "/", name, ".graphml"),
          format = "graphml"
        )
      })
  })
)

s11 <- new_heading("Query compounds", 2)

s11.1 <- c("The `features_annotation(mcn)` contains the main annotation information of all",
           "the features, i.e., the identity of the  compound. Next, we would",
           "query the identified compounds based on the 'inchikey2d' column therein.",
           "Note that the stereoisomerism of the compounds is difficult to be",
           "determined due to the limitations of MS/MS spectra.",
           "Therefore, we used InChIKey 2D (representing the molecular",
           "backbone of the compound) to query",
           "the compound instead of InChI.")

s11.2 <- new_section2(
  c("First we need to format and organize the annotated data of",
    "features to get the non-duplicated 'inchikey2d'.",
    "We provide a function with a pre-defined filtering algorithm to quickly",
    "organize the table.",
    "By default, this function filters the data based on",
    "'tani.score' (Tanimoto similarity),",
    "and then sorts and de-duplicates it."),
  rblock({
    feas <- features_annotation(mcn2)
    feas <- merge(feas, top.list[[1]], by = ".features_id", all.x = T)
    feas <- dplyr::mutate(feas, arrange.rank = adj.P.Val)
    feas <- format_table(feas, export_name = NULL)
    key2d <- feas$inchikey2d
  })
)

s100 <- new_heading("Session infomation", 1)

s100.1 <- rblock({
  sessionInfo()
}, args = list(eval = T))

# ==========================================================================
# gather
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sections <- gather_sections()
report <- do.call(new_report, sections)
render_report(report, file <- paste0("report.Rmd"))
rmarkdown::render(file)

lapply(names(top.list),
  function(name) {
    data.table::fwrite(top.list[[ name ]], paste0(tmp, "/", name, ".csv"))
  })

save.image()
savehistory()

