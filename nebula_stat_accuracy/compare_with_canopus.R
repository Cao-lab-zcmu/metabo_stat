## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## compare cluster accuracy of MCnebula with canopus
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
canopus_path <- "canopus_summary.tsv"
canopus_raw <- read_tsv(canopus_path)
## ---------------------------------------------------------------------- 
## re_shape the data
canopus <- dplyr::select(canopus_raw, name, `level 5`, subclass, class, superclass) %>% 
  dplyr::rename(level5 = `level 5`, .id = name) %>% 
  dplyr::mutate(.id = stringr::str_extract(.id, "(?<=_)[^_]{1,}$"))
## ------------------------------------- 
canopus_list <- pbapply::pblapply(colnames(canopus)[2:ncol(canopus)],
                      function(col, df = canopus){
                        list <- by_group_as_list(df, col) %>% 
                          lapply(dplyr::select, .id) %>% 
                          .[!names(.) %in% c("", "no matches")] %>% 
                          lapply(function(df){
                                   if(nrow(df) >= 50)
                                     return(df)})
                        return(list)
                      })
## ---------------------------------------------------------------------- 
parallel_canopus <- unlist(canopus_list, recursive = F)
  # .[names(.) %in% dominant_stat$classification]
## discard null
use_class <- mapply(function(df, number){
                          if(is.data.frame(df))
                            return(number)
                      }, parallel_canopus, 1:length(parallel_canopus)) %>% 
  unlist(use.names = F)
parallel_canopus <- parallel_canopus[use_class]
## ------------------------------------- 
## stat via classyfire results
canopus_stat_list <- mapply(stat_results_class, parallel_canopus, names(parallel_canopus),
                           path = "classyfire", SIMPLIFY = F)
## stat ratio of ture or false
canopus_stat_table <- lapply(canopus_stat_list, table_app, prop = T)
## ------------------------------------- 
## gather data
canopus_dominant_stat <- data.table::rbindlist(canopus_stat_table, fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
# sum number in each classification
canopus_extra_stat_table <- lapply(canopus_stat_list, table_app, prop = F) %>%
  data.table::rbindlist(fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
canopus_extra_dominant <- merge(canopus_extra_stat_table, dplyr::select(canopus_dominant_stat, classification),
                        by = "classification", all.y = T) %>%
  mutate(., sum = apply(dplyr::select(., 2:4), 1, sum)) %>%
  dplyr::select(classification, sum)
## ---------------------------------------------------------------------- 
## ----------------------------------------------------------------------
## filter substructral class
canopus_dominant_stat <- dplyr::filter(canopus_dominant_stat, false <= 0.4)
## the same filter of extra_dominant
canopus_extra_dominant <- dplyr::filter(canopus_extra_dominant,
                                        classification %in% canopus_dominant_stat$classification)
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
mutate_horizon_bar_accuracy(canopus_dominant_stat, title = "Canopus accuracy",
                            savename = "mcnebula_results/canopus_accuracy_bar.svg",
                            extra_sides_df = canopus_extra_dominant,
                            palette = ggsci::pal_locuszoom()(7),
                            width = 19,
                            l_ratio = 85,
                            m_ratio = 150,
                            return_p = F)
roman_convert("mcnebula_results/canopus_accuracy_bar.svg")

