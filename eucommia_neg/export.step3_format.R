## ---------------------------------------------------------------------- 
exclude <- c(
             # "Lignan glycosides",
             "Sugar acids and derivatives",
             "Glucuronic acid derivatives",
             # "Fatty acyl glycosides",
             # "Medium-chain fatty acids",
             # "Phenolic glycosides",
             "Fatty acyl glycosides"
             # "Long-chain fatty acids"
)
## ---------------------------------------------------------------------- 
export <- export.supp %>% 
  ## exclude useless
  dplyr::select(-IUPACName) %>% 
  ## relocate name
  dplyr::relocate(name, .id, mz, `massErrorPrecursor(ppm)`, rt) %>% 
  dplyr::relocate(inchikey2D, smiles, .after = last_col()) %>% 
  ## ------------------  manually exclude
  dplyr::filter(!Classification %in% all_of(exclude)) %>%
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
                variation = log2fc,
                `RT (min)` = rt, formula = molecularFormula,
                `tanimoto similarity` = tanimotoSimilarity,
                `InChIKey planar` = inchikey2D,
                `mass error (ppm)` = `massErrorPrecursor(ppm)`)
## ------------------------------------- 
export.dominant <- export %>% 
  dplyr::filter(name != "null") %>% 
  set_export.no()
## ------------------------------------- 
export.extra <- export %>% 
  dplyr::filter(name == "null")

