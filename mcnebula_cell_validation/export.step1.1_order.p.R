## according to p.value to distinct
tmp <- do.call(args = list(),
        function(){
          df <- origin_analysis %>% 
            dplyr::mutate(Infection_pvalue = as.numeric(Infection_pvalue)) %>% 
            dplyr::arrange(Infection_pvalue)
          level <- df$origin_id %>% 
            .[. %in% merge_df$origin_id]
          merge_df$origin_id <- factor(merge_df$origin_id, levels = level)
          merge_df <- dplyr::arrange(merge_df, origin_id)
          ## ------------------------------------- 
          level <- as.character(merge_df$.id) %>% 
            .[. %in% export.struc_set$.id] %>% 
            unique()
          ex <- export.struc_set$.id %>% 
            .[!. %in% level] %>% 
            unique()
          level <- c(level, ex)
          return(level)
        })
export.all <- export.struc_set %>% 
  dplyr::select(.id, name, molecularFormula, tanimotoSimilarity, inchikey2D, smiles) %>% 
  dplyr::mutate(.id = factor(.id, levels = tmp)) %>% 
  dplyr::arrange(.id, inchikey2D, desc(tanimotoSimilarity)) %>% 
  dplyr::mutate(.id = as.character(.id)) %>% 
  dplyr::distinct(inchikey2D, .keep_all = T) %>% 
  ## get mz and rt
  merge(mz_rt, by = ".id", all.x = T) %>%
  dplyr::relocate(.id, mz, rt) %>% 
  dplyr::as_tibble()

