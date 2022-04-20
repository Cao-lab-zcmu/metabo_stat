## select cols to export
## format table
export.all <- export.struc_set %>% 
  dplyr::select(.id, name, molecularFormula, tanimotoSimilarity, inchikey2D, smiles) %>% 
  dplyr::arrange(inchikey2D, desc(tanimotoSimilarity)) %>% 
  dplyr::distinct(inchikey2D, .keep_all = T) %>% 
  ## get mz and rt
  merge(mz_rt, by = ".id", all.x = T) %>%
  dplyr::relocate(.id, mz, rt) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
## merge with classyfire Classification
export.class <- export.all %>% 
  merge(dplyr::select(class_meta, inchikey2d, Classification),
        by.x = "inchikey2D", by.y = "inchikey2d", all.x = T) %>% 
  dplyr::as_tibble()
na.class.id <- dplyr::filter(export.class, is.na(Classification))$.id %>% 
  unique()
## ------------------------------------- 
## get canopus Classification annotation
canopus_anno <- "canopus_summary.tsv" %>% 
  read_tsv() %>% 
  dplyr::select(1:(ncol(.) - 1), -2, -3) %>% 
  dplyr::rename(.id = 1) %>% 
  ## get .id
  dplyr::mutate(.id = stringr::str_extract(.id, "[0-9]{1,}$")) %>% 
  reshape2::melt(id.vars = ".id", variable.name = "level", value.name = "canopus") %>% 
  dplyr::filter(canopus %in% keep3$class, level != "most specific class",
                .id %in% na.class.id) %>% 
  dplyr::select(.id, canopus) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
## fill na Classification annotation
export.class.cano <- merge(export.class, canopus_anno, all.x = T, by = ".id") %>% 
  dplyr::mutate(Classification = ifelse(is.na(Classification), canopus, Classification)) %>% 
  dplyr::select(-canopus) %>% 
  dplyr::filter(!is.na(Classification)) %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 
