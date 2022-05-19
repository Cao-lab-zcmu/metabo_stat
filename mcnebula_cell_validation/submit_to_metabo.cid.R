## submit to metabo
## ------------------------------------- 
## format table
## mz, rt, p-value, FC
cid <- lapply(list(
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
              function(NAME, GROUP = "Infection"){
                ## p_value
                sym.p <- parse(text = paste0(GROUP, "_pvalue"))
                ## fc
                sym.fc <- parse(text = paste0(GROUP, "_FC"))
                ## ---------------------------------------------------------------------- 
                ## class id
                class_id <- dplyr::filter(tmp_nebula_index, name %in% NAME)$.id
                ## origin_id
                class_ori.id <- dplyr::filter(merge_df, .id %in% class_id)$origin_id
                ## id, mz, p-value, fc, rt
                df <- dplyr::filter(origin_analysis, origin_id %in% class_ori.id) %>% 
                  dplyr::select(origin_id, origin_mz,
                                eval(sym.p), eval(sym.fc),
                                origin_rt) %>% 
                  ## rename for easy use augments
                  dplyr::rename(pvalue = eval(sym.p), fc = eval(sym.fc)) %>% 
                  ## filter NA
                  dplyr::filter(!is.na(pvalue) & pvalue != "NA") %>% 
                  ## filter p-value < 0.05
                  dplyr::filter(pvalue < 0.05)
                ## ---------------------------------------------------------------------- 
                sig.id <- dplyr::filter(merge_df, origin_id %in% df$origin_id)$.id
                ## get inchikey2D
                sig.inchikey2d <- dplyr::filter(.MCn.structure_set, .id %in% sig.id)$inchikey2D
                ## ---------------------------------------------------------------------- 
                rdata <- paste0("pubchem", "/", "inchikey.rdata")
                ## extract as list
                cid_inchikey <- extract_rdata_list(rdata, sig.inchikey2d) %>% 
                  lapply(function(df){
                           if("CID" %in% colnames(df))
                             return(df)
                                }) %>% 
                  data.table::rbindlist(idcol = T) %>% 
                  dplyr::rename(inchikey2D = .id)
                ## ------------------------------------- 
                ## get cid
                cid <- cid_inchikey$CID
                ## ------------------------------------- 
                # dir.create("syno")
                # pubchem_get_synonyms(cid, dir = "syno", curl_cl = 4)
              return(cid)
              })

