# ==========================================================================
# render as report
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

write_articlePdf("index.Rmd", "output.Rmd", "Report of Analysis")

origin <- list.files(".", ".*固定.*zip")
file.copy("output.pdf", "readMe_introduction.pdf", T)

zip(paste0("results_", origin),
  c("components_and_target_genes.csv",
    "all_gastric_Cancer_related_genes.csv",
    "figs",
    "gastric_Cancer_related_genes_Intersect_with_targetGenes.csv",
    "pearsonTest_allResults.csv",
    "pearsonTest_results_with_components.csv",
    "enrichKEGG",
    "enrichGO",
    "readMe_introduction.pdf",
    origin)
)


