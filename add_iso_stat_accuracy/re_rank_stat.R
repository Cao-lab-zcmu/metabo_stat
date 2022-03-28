## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## MCnebula aims to elevate accuracy of strucutre idenfication
## as the accuracy of clustering results much better than idenfication,
## possibly, there were enouph space to get batter of idenfacation
## test rerank algorithm
## ------------------------------------- 
## as the rerank algorithm may revise the df
backup_structure <- .MCn.structure_set
backup_formula <- .MCn.formula_set
# ------------------------------------- 
# -------------------------------------  
stat_method <- lapply(dominant_stat$"classification", test_rerank_method
                      meta = mutate_meta)
names(stat_method) = dominant_stat$classification
stat_method <- data.table::rbindlist(stat_method, idcol = T) %>%
  dplyr::rename(classification = .id)
