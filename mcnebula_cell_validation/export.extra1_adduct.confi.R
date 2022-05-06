## add:
## adduct type
## confidence score of cosmic
export.dominant.ex <- export.dominant %>% 
  merge(.MCn.formula_set[, c(".id", "adduct")],
        by.x = "id", by.y = ".id", all.x = T, sort = F) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
tmp.confidence <- "compound_identifications.tsv" %>% 
  read_tsv() %>% 
  dplyr::select(id, ConfidenceScore) %>% 
  dplyr::mutate(id = stringr::str_extract(id, "(?<=_)[0-9]{1,}$"),
                ConfidenceScore = as.numeric(ConfidenceScore),
                ConfidenceScore = floor(100 * ConfidenceScore) / 100,
                ConfidenceScore = ifelse(is.na(ConfidenceScore), "-", ConfidenceScore)) %>% 
  dplyr::rename(`COSMIC confidence` = ConfidenceScore) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
export.dominant.ex <- export.dominant.ex %>% 
  merge(tmp.confidence, by = "id", all.x = T, sort = F) %>% 
  dplyr::as_tibble() %>% 
  dplyr::relocate(No, name, id, `precursor m/z`, `mass error (ppm)`,
                  `RT (min)`, formula, adduct, `tanimoto similarity`,
                  `COSMIC confidence`)
## ------------------------------------- 
export.dominant <- export.dominant.ex
