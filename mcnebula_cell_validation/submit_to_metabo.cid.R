## submit to metabo
## ------------------------------------- 
## format table
## mz, rt, p-value, FC
path.cid <- lapply(list(
                   c(
                     "Bile acids, alcohols and derivatives",
                     "Lysophosphatidylcholines",
                     "Phenylpropanoic acids",
                     "Lineolic acids and derivatives",
                     "Hydroxysteroids",
                     "Steroidal glycosides",
                     "Oxosteroids",
                     "Androstane steroids",
                     "Unsaturated fatty acids",
                     "Acyl carnitines"
                     )),
              function(
                       NAME,
                       GROUP = "Infection",
                       extra.compound = align.export$`InChIKey planar`
                       ){
                ## p_value
                sym.p <- paste0(GROUP, "_pvalue")
                ## fc
                sym.fc <- paste0(GROUP, "_FC")
                ## ---------------------------------------------------------------------- 
                ## class id
                class_id <- dplyr::filter(tmp_nebula_index, name %in% NAME)$.id
                ## origin_id
                class_ori.id <- dplyr::filter(merge_df, .id %in% class_id)$origin_id
                ## id, mz, p-value, fc, rt
                df <- dplyr::filter(origin_analysis, origin_id %in% class_ori.id) %>% 
                  dplyr::select(origin_id, origin_mz,
                                all_of(c(sym.p, sym.fc)),
                                origin_rt) %>% 
                  ## rename for easy use augments
                  dplyr::rename(pvalue = all_of(sym.p), fc = all_of(sym.fc)) %>% 
                  ## as.numeric
                  dplyr::mutate(pvalue = as.numeric(pvalue)) %>% 
                  ## filter NA
                  dplyr::filter(!is.na(pvalue) & pvalue != "NA") %>% 
                  ## filter p-value < 0.05
                  dplyr::filter(pvalue < 0.05)
                ## ------------------------------------- 
                sig.id <- dplyr::filter(merge_df, origin_id %in% df$origin_id)$.id
                ## get inchikey2D
                sig.inchikey2d <<- dplyr::filter(.MCn.structure_set,
                                                 tanimotoSimilarity >= 0.5,
                                                 .id %in% sig.id)
                ## ------------------------------------- 
                sig.inchikey2d <- sig.inchikey2d$inchikey2D
                ## ------------------------------------- 
                if(is.vector(extra.compound)){
                  sig.inchikey2d <- unique(c(sig.inchikey2d, extra.compound))
                }
                ## ---------------------------------------------------------------------- 
                ## get cid
                ## ------------------------------------- 
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
                ## output
                cat(unlist(cid), sep = "\n", file = "~/Desktop/cid.tmp.txt")
                ## ---------------------------------------------------------------------- 
                ## get kegg ID
                ## ------------------------------------- 
                ## ------------------------------------- 
                ## output
                # cat(unlist(kegg), sep = "\n", file = "~/Desktop/kegg.tmp.txt")
              return(cid)
              })

