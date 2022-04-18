## check whether Unkown compound stat in cell
## article counld be identified by SIRIUS soft
merge_efs25 <- merge_df %>% 
  dplyr::filter(origin_id %in% all_of(efs_top25.origin_id))
## ------------------------------------- 
sirius_efs25 <- .MCn.structure_set %>% 
  ## select neccessary
  dplyr::select(.id, inchikey2D, name, tanimotoSimilarity, file_name) %>% 
  ## merge to get origin id
  merge(merge_efs25, by = ".id", all.y = T) %>% 
  as_tibble()
## ------------------------------------- 

