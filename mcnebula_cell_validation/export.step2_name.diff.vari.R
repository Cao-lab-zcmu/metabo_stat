## add supplementation data
export.supp <- export.class.cano %>% 
  ## get name
  merge(iupac, by.x = "inchikey2D", by.y = "inchikey2d", all.x = T) %>% 
  ## get mass difference
  merge(.MCn.formula_set[, c(".id", "massErrorPrecursor(ppm)")], ) %>% 
  dplyr::as_tibble() %>% 
  ## ------------------------------------- 
  ## format data
  dplyr::mutate(name = ifelse(name == "null",
                              ## get better name
                              ifelse(is.na(IUPACName), name, IUPACName),
                              ifelse(nchar(name) < nchar(IUPACName), name, IUPACName)),
                name = ifelse(grepl("^bmse|^ACMC", name), IUPACName, name),
                ## round rt min
                rt = round(rt, 1))
