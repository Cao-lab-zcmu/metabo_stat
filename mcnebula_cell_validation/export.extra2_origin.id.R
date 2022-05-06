## add:
## origin id
tmp_merge.df <- merge_df %>% 
  dplyr::select(.id, origin_id) %>% 
  dplyr::rename(`origin id` = origin_id) %>% 
  dplyr::mutate(.id = as.character(.id)) %>% 
  dplyr::distinct(.id, .keep_all = T)
## ------------------------------------- 
export.dominant <- export.dominant %>% 
  merge(tmp_merge.df, by.x = "id", by.y = ".id",
        all.x = T, sort = F) %>% 
  dplyr::mutate(`origin id` = ifelse(is.na(`origin id`), "-", `origin id`),
                ## post modify
                name = ifelse(name == ".beta.-D-",
                              "Mycophenolic acid 7-O-glucuronide", name)) %>% 
  dplyr::relocate(No, name, id, `origin id`) %>% 
  dplyr::arrange(No) %>% 
  dplyr::as_tibble()

