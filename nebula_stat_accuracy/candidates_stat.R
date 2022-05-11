## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## whether MCnebula is deserved to development, is mostly depends on whether
## CSI:fingerID gathered the true structure into candidate.
## if there is no true structure in dataset, most of the compounds in nebula,
## there is no mean to do cluster or rerank
## so, a test is performed
## ------------------------------------- 
## get top n candidate
nebula_name <- dominant_stat$classification %>% 
  unique()
lapply(nebula_name, nebula_get_candidate)
## ------------------------------------- 
candidates_accuracy <- stat_topn_candidates_accuracy(dominant_stat$classification,
                                                     meta = mutate_meta)
## draw plot
horizon_bar_accuracy(candidates_accuracy, title = "all candidates accuracy",
                     savename = "mcnebula_results/mutate50_candidates_accuracy_bar.svg",
                     return_p = F)
roman_convert("mcnebula_results/mutate50_candidates_accuracy_bar.svg")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## merge accuracy plot 
merge_accuracy_list <- list(top1 = cosmic_accuracy, top50 = candidates_accuracy)
merge_horizon_accuracy(merge_accuracy_list, title = "candidates accuracy",
                       savename = "mcnebula_results/top1_vs_top50_accuracy.svg",
                       return_p = F)
## ---------------------------------------------------------------------- 
