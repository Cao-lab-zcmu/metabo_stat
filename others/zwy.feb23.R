## format qi csv as metaboanalyst input
## read as raw data

library(data.table)
library(dplyr)

setwd("~/operation/zwy")

file_set <- list.files(".", pattern = "csv$", recursive = T) %>%
  .[!grepl("format", .)]

pbapply::pblapply(file_set, function(file){
  path <- stringr::str_extract(file, "^[^/]*")
  metadata <- qi_get_format(file, metadata = T)
  df <- qi_get_format(file)
  select <- combn(unique(metadata$group), 2, , F)
  lapply(select,
    function(select) {
      export <- qi_as_metabo_inte.table(df, metadata, select)
      savename <- paste0(paste0(select, collapse = "_"), ".format.csv")
      write.table(export, paste0(path, "/", savename),
        sep = ",", col.names = T,
        row.names = F, quote = F)
    })
})
