## submit to metabo
## ------------------------------------- 
## format table
## mz, rt, p-value, FC
ba_idset <- lapply(list(
                        c("Bile acids, alcohols and derivatives",
                          "Lysophosphatidylcholines",
                          "Acyl carnitines",
                          "Lineolic acids and derivatives",
                          "Hydroxysteroids",
                          "Steroidal glycosides",
                          "Oxosteroids",
                          "Androstane steroids",
                          "Unsaturated fatty acids"
                        )),
       function(NAME){
         ## class id
         class_id <- dplyr::filter(tmp_nebula_index, name %in% NAME)$.id
         ## origin_id
         class_ori.id <- dplyr::filter(merge_df, .id %in% class_id)$origin_id
         ## id, mz, p-value, fc, rt
         df <- dplyr::filter(origin_analysis, origin_id %in% class_ori.id) %>% 
           dplyr::select(origin_id, origin_mz,
           Infection_pvalue, Infection_FC,
           # Mortality_pvalue, Mortality_FC,
           origin_rt) %>% 
           dplyr::filter(!is.na(Infection_pvalue) & Infection_pvalue != "NA")
         df.id <- dplyr::select(df, origin_id)
         ## data decoy 
         decoy <- data.table::data.table(mz = 1:1000, p = 0.9, fc = 1, rt = 1)
         colnames(decoy) <- colnames(df)[-1]
         df <- df[, -1] %>% 
           apply(2, as.numeric) %>% 
           dplyr::as_tibble() %>% 
           ## add decoy data
           dplyr::bind_rows(decoy) %>% 
           meta_metabo_pathway(extra_entity = ., only_return = T,
                               key = c("^.*mz", "^.*pvalue", "^.*FC", "^.*rt"))
         return(df.id)
       })

