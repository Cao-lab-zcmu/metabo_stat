
heat.index <- dplyr::filter(tmp_nebula_index, name %in% all_of(heat.class))
 
## get original id and re-id for stat quant. table
heat.feature_stat <- merge(feature_stat, merge_df[, c("origin_id", ".id")], 
                           by = "origin_id", all.x = T) %>% 
  dplyr::distinct(origin_id, .keep_all = T) %>% 
  dplyr::distinct(.id, .keep_all = T) %>% 
  dplyr::relocate(origin_id, .id) %>%
  ## only selected classes
  dplyr::mutate(.id = as.character(.id)) %>% 
  dplyr::filter(.id %in% all_of(heat.index$.id)) %>% 
  dplyr::as_tibble()
 
## data nomalization
 
## data deal na
heat.norm.df <- meta_feature_stat[, c("name", "subgroup")] %>% 
  by_group_as_list("subgroup") %>% 
  lapply(
         function(meta){
           subgroup <- meta[1, ]$subgroup
           cat("## Processing", subgroup, "\n")
           ## ------------------------------------- 
           df <- dplyr::select(heat.feature_stat, all_of(meta$name))
           df <- dplyr::summarise_all(df, as.numeric)
           list <- pbapply::pbapply(df, 1,
                                  function(vec){
                                    if(!(F %in% is.na(vec))){
                                      vec[] <- 0
                                    }
                                    if(T %in% is.na(vec))
                                      vec[which(is.na(vec))] <- mean(vec, na.rm = T)
                                    df <- bind_rows(vec)
                                  }, simplify = F)
           df <- data.table::rbindlist(list)
           df <- as_tibble(df)
         })
heat.norm.df <- do.call(dplyr::bind_cols, heat.norm.df)
## scale
heat.norm.df <- heat.norm.df %>% 
  dplyr::bind_cols(heat.feature_stat[, 1:2], .)
 

