## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
export <- export.supp %>% 
  ## exclude useless
  dplyr::select(-IUPACName) %>% 
  ## relocate name
  dplyr::relocate(name, .id, mz, `massErrorPrecursor(ppm)`, rt) %>% 
  dplyr::relocate(inchikey2D, smiles, .after = last_col()) %>% 
  ## get hierarchy rank
  get_hierarchy.in_df(col = "Classification") %>% 
  ## duplicated in class
  dplyr::arrange(desc(hierarchy), inchikey2D) %>% 
  dplyr::distinct(inchikey2D, .keep_all = T) %>% 
  ## remove hierarchy
  dplyr::select(-hierarchy) %>% 
  ## order df
  dplyr::arrange(Classification, name) %>% 
  dplyr::rename(id = .id, `precursor m/z` = mz,
                `RT (min)` = rt, formula = molecularFormula,
                `tanimoto similarity` = tanimotoSimilarity,
                `InChIKey planar` = inchikey2D,
                `mass error (ppm)` = `massErrorPrecursor(ppm)`) %>% 
  dplyr::mutate(`mass error (ppm)` = floor(`mass error (ppm)` * 10) / 10,
                `tanimoto similarity` = floor(`tanimoto similarity` * 100) / 100)
## ------------------------------------- 
export.dominant <- export %>% 
  dplyr::filter(name != "null") %>% 
  set_export.no()
## ------------------------------------- 
export.extra <- export %>% 
  dplyr::filter(name == "null")

