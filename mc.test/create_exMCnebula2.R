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

files2 <- list(
  evaluation_workflow = c("/home/echo/outline/mc.test/evaluation_workflow/evaluation_workflow.R",
    "~/tmp_backup/R/evaluation/report.pdf"),
  eucommia_workflow = c("/home/echo/outline/mc.test/eucommia_workflow/eucommia_workflow.R",
    "~/tmp_backup/R/eucommia/temp_data/report.pdf"),
  serum_workflow = c("/home/echo/outline/mc.test/serum_workflow/serum_workflow.R",
    "~/tmp_backup/R/serum/temp_data/report.pdf"),
  mcn_principle = c("/home/echo/outline/mc.test/mcn_principle/a_elements.R",
    "/home/echo/outline/mc.test/mcn_principle/b_gather.R",
    "/home/echo/outline/mc.test/mcn_principle/figure_mech.pdf"),
  mcn_structure = c("/home/echo/outline/mc.test/mcn_structure/a_project.R",
    "/home/echo/outline/mc.test/mcn_structure/b_mcn_dataset.R",
    "/home/echo/outline/mc.test/mcn_structure/c_nebulae.R",
    "/home/echo/outline/mc.test/mcn_structure/d_across.R",
    "/mnt/data/wizard/Documents/article/MCnebula2/data_stream.pdf")
)

path <- "~/exMCnebula2/inst/extdata/scripts_evaluation"
dir.create(path)
lapply(names(files2),
  function(name) {
    dir <- paste0(path, "/", name)
    if (!file.exists(dir))
      dir.create(dir)
    lapply(files2[[ name ]], file.copy,
      to = dir, overwrite = T, recursive = T)
  })

