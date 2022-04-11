## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## compare cluster accuracy of MCnebula with molnetEnhancer
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
molnet_path <- "mcnebula_results/gnps/molnet/output_network/ClassyFireResults_Network.txt"
molnet_raw <- read_tsv(molnet_path)
## ---------------------------------------------------------------------- 
## re_shape the data
molnet <- dplyr::select(molnet_raw, `cluster index`, ends_with("class")) %>% 
  dplyr::rename(.id = `cluster index`) %>% 
  dplyr::mutate(.id = paste0("gnps", .id))
## ------------------------------------- 
## format for function: stat_results_class 
## ------------------------------------- 
molnet_list <- pbapply::pblapply(colnames(molnet)[2:4],
                      function(col, df = molnet){
                        list <- by_group_as_list(df, col) %>% 
                          lapply(dplyr::select, .id) %>% 
                          .[!names(.) %in% c("", "no matches")] %>% 
                          lapply(function(df){
                                   if(nrow(df) >= 50)
                                     return(df)})
                        return(list)
                      })
## ---------------------------------------------------------------------- 
## unlist
parallel_molnet <- c(molnet_list[[1]], molnet_list[[2]], molnet_list[[3]])
  # .[names(.) %in% dominant_stat$classification]
## discard null
use_class <- mapply(function(df, number){
                          if(is.data.frame(df))
                            return(number)
                      }, parallel_molnet, 1:length(parallel_molnet)) %>% 
  unlist(use.names = F)
parallel_molnet <- parallel_molnet[use_class]
## ------------------------------------- 
## stat via classyfire results
molnet_stat_list <- mapply(stat_results_class, parallel_molnet, names(parallel_molnet),
                           path = "classyfire", SIMPLIFY = F)
## stat ratio of ture or false
molnet_stat_table <- lapply(molnet_stat_list, table_app, prop = T)
## ------------------------------------- 
## gather data
molnet_dominant_stat <- data.table::rbindlist(molnet_stat_table, fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## sides plot
## ------------------------------------- 
## ------------------------------------- 
# sum number in each classification
m_extra_stat_table <- lapply(molnet_stat_list, table_app, prop = F) %>%
  data.table::rbindlist(fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
m_extra_dominant <- merge(m_extra_stat_table, dplyr::select(molnet_dominant_stat, classification),
                        by = "classification", all.y = T) %>%
  mutate(., sum = apply(dplyr::select(., 2:4), 1, sum)) %>%
  dplyr::select(classification, sum)
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
mutate_horizon_bar_accuracy(molnet_dominant_stat, title = "MolnetEnhancer accuracy",
                            savename = "mcnebula_results/molnet_accuracy_bar.svg",
                            extra_sides_df = m_extra_dominant,
                            palette = ggsci::pal_locuszoom()(7),
                            width = 19,
                            l_ratio = 85,
                            m_ratio = 150,
                            return_p = F)
roman_convert("mcnebula_results/molnet_accuracy_bar.svg")

