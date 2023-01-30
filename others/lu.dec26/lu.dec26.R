# ==========================================================================
# workflow to process data and output report (Eucomma)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# workflow(mode = "print")
devtools::load_all("~/MCnebula2")
devtools::load_all("~/exMCnebula2")

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
    mcn <- initialize_mcnebula(mcn, "sirius.v4", "/media/echo/DATA/lu/dec19/pos")
    ion_mode(mcn) <- "pos"
  })
)

s1.5 <- new_section2(
  c("Create a temporary folder to store the output data."),
  rblock({
    tmp <- paste0("/media/echo/DATA/lu/dec19", "/temp_data")
    dir.create(tmp, F)
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
    mcn <- cross_filter_stardust(
      mcn, min_number = 10, max_ratio = .1,
      cutoff = .4, tolerance = .4, identical_factor = .7
    )
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
    pattern <- c("pyr", "fatty acid", "hydroxy")
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
    print(table.nebulae, n = Inf)
  }, args = list(eval = T))
)

s5.6 <- new_section2(
  c("Draw and save as .png or .pdf image files."),
  rblock({
    p <- visualize(mcn, "parent")
    ggsave(f5.61 <- paste0(tmp, "/parent_nebula.png"), p)
    pdf(f5.62 <- paste0(tmp, "/child_nebula.pdf"), 14, 14)
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

## Output identification table
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
    mcn2 <- mcn
    feas <- features_annotation(mcn2)
    feas <- format_table(feas, export_name = NULL)
    key2d <- feas$inchikey2d
  })
)

s11.3 <- new_section2(
  c("Create a folder to store the acquired data."),
  rblock({
    tmp2 <- paste0(tmp, "/query")
    dir.create(tmp2, F)
  })
)

s11.4 <- new_section2(
  c("Query the compound's InChIKey, chemical class, IUPUA name.",
    "If your system is not Linux, the multithreading below may pose some problems,",
    "please remove the parameters `curl_cl = 4` and `classyfire_cl = 4`."),
  rblock({
    key.rdata <- query_inchikey(key2d, tmp2, curl_cl = 4)
    class.rdata <- query_classification(key2d, tmp2, classyfire_cl = 4)
    iupac.rdata <- query_iupac(key2d, tmp2, curl_cl = 4)
  })
)

s11.5 <- new_section2(
  c("We will also query for synonyms of compounds, but this is done in",
    "'CID' (PubChem's ID), so some transformation is required."),
  rblock({
    key.set <- extract_rdata_list(key.rdata)
    cid <- lapply(key.set, function(data) data$CID)
    cid <- unlist(cid, use.names = F)
    syno.rdata <- query_synonyms(cid, tmp2, curl_cl = 4)
  })
)

s11.6 <- new_section2(
  c("Screen for unique synonyms and chemical classes for all compounds."),
  rblock({
    syno <- pick_synonym(key2d, key.rdata, syno.rdata, iupac.rdata)
    feas$synonym <- syno
    class <- pick_class(key2d, class.rdata)
    feas$class <- class
    feas.table <- rename_table(feas)
    write_tsv(feas.table, paste0(tmp, "/compounds_format.tsv"))
    openxlsx::write.xlsx(feas.table, paste0(tmp, "/compounds_format.xlsx"))
  })
)

s11.7 <- new_section2(
  c("The formatted table as following:"),
  rblock({
    feas.table
  }, args = list(eval = T))
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
yaml(report)[1] <- c("title: Analysis on Eucommia dataset")
render_report(report, file <- paste0(tmp, "/report.Rmd"))
rmarkdown::render(file)




