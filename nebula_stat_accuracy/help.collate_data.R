load_all("~/MCnebula/")
load_all("~/extra/")
## ---------------------------------------------------------------------- 
common_compounds <- "/media/echo/DATA/yellow/common_compounds.tsv" %>% 
  read_tsv()
## ---------------------------------------------------------------------- 
nebula_index.backup <- .MCn.nebula_index
.MCn.nebula_index <- dplyr::filter(.MCn.nebula_index, .id %in% common_compounds$.id)
meta.backup <- meta
meta <- dplyr::filter(meta, .id %in% common_compounds$.id)
source("~/metabo_stat/add_iso_stat_accuracy/format_nebula_index.R")
source("~/metabo_stat/add_iso_stat_accuracy/dominant_stat.R")
source("~/metabo_stat/add_iso_stat_accuracy/idenfication_stat.R")
source("~/metabo_stat/add_iso_stat_accuracy/compare_with_molnet.R")

