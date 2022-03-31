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
stat_method <- lapply(dominant_stat$"classification", test_rerank_method,
                      meta = mutate_meta,
                      top_n = 5)
names(stat_method) = dominant_stat$classification
stat_method <- data.table::rbindlist(stat_method, idcol = T) %>%
  dplyr::rename(classification = .id)
## ---------------------------------------------------------------------- 
## plot with origin accuracy
merge_accuracy_list <- list(origin = cosmic_accuracy, re_rank = stat_method)
mutate_merge_horizon_accuracy(merge_accuracy_list, title = "re_rank accuracy",
                       savename = "mcnebula_results/re_rank_accuracy.svg",
                       return_p = F)

