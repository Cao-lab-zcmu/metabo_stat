# ==========================================================================
# An attached package that packages the analysis tools used for the study.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

new_package.fromFiles("~/exMCnebula2",
  c("aaa.R", "grid_draw.R", "dot_heatmap.R", "query_synonyms.R",
    "query_inchikey.R", "query_classification.R", "query_others.R",
    "output_identification.R", "pick_annotation.R", "alignment_merge.R",
    "pathway_enrichment.R", "cross_select.R", "exReport.R", "plot_EIC_stack.R"),
  path = "~/utils.tool/R/", exclude = c("MSnbase", "MetaboAnalystR"))

# list.files("~/utils.tool/inst/extdata", full.names = T)
files <- c(
  "/home/echo/utils.tool/inst/extdata/mcn_serum6501.rdata",
  "/home/echo/utils.tool/inst/extdata/mcn_herbal1612.rdata",
  "/home/echo/utils.tool/inst/extdata/serum.tar.gz",
  "/home/echo/utils.tool/inst/extdata/herbal.tar.gz",
  "/home/echo/utils.tool/inst/extdata/svg",
  "/home/echo/utils.tool/inst/extdata/toActiv30.rdata",
  "/home/echo/utils.tool/inst/extdata/toBinary5.rdata",
  "/home/echo/utils.tool/inst/extdata/toAnno5.rdata",
  "/home/echo/utils.tool/inst/extdata/evaluation.tar.gz"
)

lapply(files, file.copy, to = "~/exMCnebula2/inst/extdata",
       recursive = T)
