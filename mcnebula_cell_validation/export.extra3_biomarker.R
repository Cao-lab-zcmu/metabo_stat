## format the alignment data
## merge with origin confidence
align.export <-  sirius_efs25.status %>% 
  dplyr::rename(id = .id) %>% 
  merge(tmp.confidence, by = "id", all.x = T) %>% 
  set_export.no(col = "origin_id") %>% 
  dplyr::select(name, id, mz, rt,
                tanimotoSimilarity, `COSMIC confidence`, inchikey2D,
                origin_id, origin_mz, origin_rt, Spectral_Library_Match) %>%
  apply(2, function(vec){ifelse(is.na(vec), "-", vec)}) %>% 
  dplyr::as_tibble() %>%
  dplyr::arrange(origin_id)
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

