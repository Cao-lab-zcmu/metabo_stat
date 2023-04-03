# ==========================================================================
# neg
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# setwd("/media/echo/王璐-1/mar4_analysis/neg")
setwd("/media/echo/back/mar4_analysis/neg")

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
  })
)

load("mcn.rdata")

s1.5 <- new_section2(
  c("Create a temporary folder to store the output data."),
  rblock({
    tmp <- paste0("temp_data")
    dir.create(tmp, F)
    export_path(mcn) <- tmp
  }, F)
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
    pattern <- c("stero", "fatty acid", "pyr", "hydroxy",
      "^Ar", "^Alk", "^Ben", "^orga", "^Carbo")
    dis <- unlist(lapply(pattern, grep, x = classes, ignore.case = T))
    dis <- classes[dis]
    dis
    dis <- dis[-1]
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
    fig.s <- 1.5
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
    origin <- data.table::fread("features.csv")
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
    gp <- c(Control = "URINE_B", Model = "URINE_M", QC = "URINE_QC",
      Pos = "URINE_POS", Treat_low = "URINE_CL", Treat_medium = "URINE_CM",
      Treat_high = "URINE_CH")
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
      mcn, Model - Control, Pos - Model,
      Treat_high - Model, Treat_medium - Model,
      Treat_low - Model
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

s9 <- new_heading("Set tracer in Child-Nebulae (customize the top Features)", 2)

s9.1 <- new_section2(
  c("Use custom defined Features to perform tracing mode of Child-Nebulae.",
    "The table was from:"),
  rblock({
    tb <- openxlsx::read.xlsx("../manual_id.xlsx")
    topsM <- tb[[4]]
    topsM <- as.character(topsM[ !is.na(topsM) ])
  })
)

s9.2 <- new_section2(
  c("Similar to above section:"),
  rblock({
    mcn2 <- set_tracer(mcn, topsM)
    mcn2 <- create_child_nebulae(mcn2)
    mcn2 <- create_child_layouts(mcn2)
    mcn2 <- activate_nebulae(mcn2)
    mcn2 <- set_nodes_color(mcn2, use_tracer = T)
  })
)

s9.3 <- new_section2(
  c("Draw and save the image."),
  rblock({
    pdf(f9.3 <- paste0(tmp, "/tracer_child_nebula_manual.pdf"), 12 * 1.2, 14 * 1.2)
    visualize_all(mcn2)
    dev.off()
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


