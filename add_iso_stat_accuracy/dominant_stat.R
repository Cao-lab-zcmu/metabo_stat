## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## stat cluster
## ------------------------------------- 
## ------------------------------------- 
## main stat
## ------------------------------------- 
## ------------------------------------- 
## stat dominant structure classification
stat_list <- mapply(stat_results_class, list, names(list),
                    path = "classyfire",
                    SIMPLIFY = F)
stat_table <- lapply(stat_list, table_app, prop = T)
## gather data
stat <- data.table::rbindlist(stat_table, fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
dominant_stat <- dplyr::filter(stat, false <= 0.4)
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## sides plot
## ------------------------------------- 
## ------------------------------------- 
# sum number in each classification
extra_stat_table <- lapply(stat_list, table_app, prop = F) %>%
  data.table::rbindlist(fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
extra_dominant <- merge(extra_stat_table, dplyr::select(dominant_stat, classification),
                        by = "classification", all.y = T) %>%
  mutate(., sum = apply(dplyr::select(., 2:4), 1, sum)) %>%
  dplyr::select(classification, sum)
##------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## plot a bar to show accuracy intuitively
mutate_horizon_bar_accuracy(dominant_stat, title = "clustering accuracy",
                            savename = "mcnebula_results/cluster_accuracy_bar.svg",
                            extra_sides_df = extra_dominant,
                            return_p = F)
roman_convert("mcnebula_results/cluster_accuracy_bar.svg")

