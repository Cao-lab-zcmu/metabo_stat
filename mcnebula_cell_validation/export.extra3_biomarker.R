## format the alignment data
## merge with origin confidence
align.export <-  sirius_efs25.status %>% 
  filter(!is.na(inchikey2D)) %>% 
  ## merge IUPACName
  merge(iupac, by.x = "inchikey2D", by.y = "inchikey2d", all.x = T) %>% 
  dplyr::mutate(name = ifelse(name == "null",
                              ## get better name
                              ifelse(is.na(IUPACName), name, IUPACName),
                              ifelse(nchar(name) < nchar(IUPACName), name, IUPACName)),
                name = ifelse(grepl("^bmse|^ACMC", name), IUPACName, name)) %>% 
  ## ------------------------------------- 
  dplyr::rename(id = .id) %>% 
  merge(tmp.confidence, by = "id", all.x = T) %>% 
  dplyr::arrange(origin_id) %>% 
  set_export.no(col = "origin_id") %>% 
  dplyr::select(No, name, id, mz, rt,
                tanimotoSimilarity, `COSMIC confidence`, inchikey2D,
                origin_id, origin_mz, origin_rt, Spectral_Library_Match) %>%
  apply(2, function(vec){ifelse(is.na(vec), "-", vec)}) %>% 
  dplyr::as_tibble() 
## ------------------------------------- 
## format name
mutate_set <- c("_", "rt", "mz", "molecularFormula",
                "\\.id",
                "tanimotoSimilarity", "inchikey2D")
replace_set <- c(" ", "RT (min)", "precursor m/z", "formula",
                 "id",
                 "tanimoto similarity", "InChIKey planar")
names(align.export) <- mapply_rename_col(mutate_set, replace_set, names(align.export))
## ------------------------------------- 
pretty_table(align.export, group = F)

