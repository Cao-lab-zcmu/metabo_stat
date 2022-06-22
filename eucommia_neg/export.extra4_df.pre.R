## check error number
# check <- rapply(pdf_list,
                # function(vec){
                #   check <- lapply(vec,
                #                   function(vec){
                #                     if(vec == "error")
                #                       return("error")
                #                   })
                #   return(check)
                # }) %>% 
  # unlist()
## ---------------------------------------------------------------------- 
## syno.metadata: filter.syno
## cid_inchikey.metadata: cid_inchikey
## gether syno with inchikey2D
syno.metadata <- merge(filter.syno, cid_inchikey,
                       all.x = T, by.x = "cid", by.y = "CID") %>% 
  dplyr::as_tibble()
## ------------------------------------- 
## pdf.metadata: lite.df.file
## ------------------------------------- 
## format each pdf
format.lite <- pdf_list %>% 
  lapply(paste0, collapse = "") %>% 
  lapply(function(str){
           str <- gsub("\n", " ", str)
           return(str)
                       }) %>% 
  unlist()
