## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## MCnebula aims to elevate accuracy of strucutre idenfication
## as the accuracy of clustering results much better than idenfication,
## possibly, there were enouph space to get batter of idenfacation
## test rerank algorithm
# ------------------------------------- 
# -------------------------------------  
stat_method <- lapply(dominant_stat$"classification", test_rerank_method,
                      meta = mutate_meta,
                      top_n = 10,
                      curl_cl = 8,
                      classyfire_cl = 8,
                      filter_via_classification = T)
## ------------------------------------- 
names(stat_method) = dominant_stat$classification
stat_method <- data.table::rbindlist(stat_method, idcol = T) %>%
  dplyr::rename(classification = .id)
## ---------------------------------------------------------------------- 
## plot with origin accuracy
merge_accuracy_list <- list(origin = cosmic_accuracy, re_rank = stat_method)
mutate_merge_horizon_accuracy(merge_accuracy_list, title = "re_rank accuracy",
                       savename = "mcnebula_results/classyfire_re_rank_accuracy.svg",
                       return_p = F)

