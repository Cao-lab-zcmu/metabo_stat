## ------------------------------------- 
## extrac all pathview support ID type
## data(rn.list, package = "pathview")
## names(rn.list)
## ------------------------------------- 
## i.e.
## kegg
## 
syno.from.pub <-
  lapply(path.cid[1], function(cid.set){
           ## get syno
           rdata <- paste0("syno", "/", "cid.rdata")
           cid_syno <- extract_rdata_list(rdata)
           ## get kegg ID syno
           cid_syno <- cid_syno %>% 
             ## as list
             data.table::rbindlist(fill = T) %>% 
             ## rm na; keep usefull cid row
             dplyr::filter(!is.na(syno), cid %in% all_of(cid.set))
           cid_syno <- mapply(
                    FUN = function(pattern, mut.name, df){
                      df <- dplyr::filter(df, stringr::str_detect(syno, pattern))
                      df <- dplyr::mutate(df, syno.id = mut.name)
                    },
                    ## pattern
                    c(
                      "^C[0-9]{1,}$",
                      "^CHEMBL",
                      "^[0-9]{2,7}-[0-9]{2}-[0-9]{1}$",
                      "^DB[0-9]{1,20}$",
                      "^HMDB[0-9]{1,20}$"
                      ),
                    ## name
                    c(
                      "kegg",
                      "ChEMBL COMPOUND",
                      "CAS Registry Number",
                      "DrugBank accession",
                      "HMDB accession"
                      ),
                    SIMPLIFY = F,
                    MoreArgs = list(df = cid_syno))
})

