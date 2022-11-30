
setwd("~/operation/shang")

library(magrittr)
devtools::load_all("~/utils.tool/")

data <- data.table::fread("compound_identifications.tsv")
data <- dplyr::mutate(data, cid = stringr::str_extract(data$pubchemids, "^[0-9]{1,}"))
cid <- data$cid
cid <- cid[!is.na(cid)]

pubchem_get_synonyms(cid = cid, dir = ".")
cid_set <- extract_rdata_list("cid.rdata")
cid_set <- data.table::rbindlist(cid_set)
cid_set <- dplyr::filter(cid_set, !is.na(syno))
cid_set <- dplyr::as_tibble(cid_set)
write_tsv(cid_set, "syno.tsv")

## ---------------------------------------------------------------------- 


