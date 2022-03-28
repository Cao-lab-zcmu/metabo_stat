## Rscript
## path <- "/media/wizard/back/test_mcnebula/gnps_pos"
## library(MCnebula)
## ---------------------------------------------------------------------- 
## metadata
meta <- read_tsv("mcnebula_results/msms_pos_gnps.msp.meta.tsv") %>%
  dplyr::as_tibble()
class_meta <- dplyr::select(meta, .id, Ontology)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## get the predicted rt
rt_set <- read_tsv("mcnebula_results/all_msfinder_riken.txt") %>% 
  dplyr::mutate(inchikey2D = stringr::str_extract(INCHKEY, "^[A-Z]{1,}")) %>% 
  dplyr::select(inchikey2D, RT)
## ------------------------------------- 
rt_meta <- dplyr::mutate(meta, inchikey2D = stringr::str_extract(INCHIKEY, "^[A-Z]{1,}")) %>% 
  dplyr::select(.id, inchikey2D) %>% 
  merge(rt_set, by = "inchikey2D", all.x = T) %>% 
  dplyr::filter(is.na(RT) == F) %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ------------------------------------- 
## save data
# save(envir_store, file = "envir_store.rdata")
## stat all
# id_set <- ls(envir = envir_store)

