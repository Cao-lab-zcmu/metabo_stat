# ==========================================================================
# create the table for subjective_evaluation
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

menu <- list(
  identificaiton = c("MS1", "library match", "machine prediction"),
  classifying = c("structure based", "MS/MS based", "select classes"),
  visualize_dataset = c("spectral based", "classes based", "indepth annotation"),
  others = c("preprocessing", "statistics", "path_enrichment", "report"),
  usage = c("software", "availability", "difficulty")
)

methods <- c("MCnebula", "SIRIUS", "GNPS", "MZmine", "XCMS", "MetaboAnalyst", "MS-DIAL")

data <- lapply(menu, function(x) data.frame(item = x))
data <- data.table::rbindlist(data, idcol = T)
data <- dplyr::rename(data, group = .id)

data <- sapply(methods, function(name) data, simplify = F)
data <- data.table::rbindlist(data, idcol = T)
data <- dplyr::rename(data, method = .id)
data <- dplyr::mutate(
  data, eval = integer(1), 
  item = factor(item, levels = unique(item))
)
data <- tidyr::spread(data, method, eval)
data <- dplyr::arrange(data, item)
data <- dplyr::select(data, group, item, dplyr::all_of(methods))

filename <- paste0("subEval_", Sys.Date(), ".csv")
data.table::fwrite(data, filename)

# ==========================================================================
# format the table
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

filename <- "subEval_2023-02-21.csv"
data <- data.table::fread(filename)
data <- dplyr::filter(data, item != "software")
data <- dplyr::mutate_if(
  data, is.integer,
  function(x) {
    ifelse(x == 0, "-", 
      vapply(x, function(x) paste0(rep("*", abs(x)), collapse = ""), 
        character(1)))
  }
)
data <- dplyr::mutate(data, group = form(group), item = form(item))
colnames(data) <- form(colnames(data))

table <- pretty_table(
  dplyr::group_by(data, Group), title = "Functional evaluation", 
  subtitle = "Evaluation for software of analysis of LC-MS/MS"
)
data.table::fwrite(data, "subEval.csv")
