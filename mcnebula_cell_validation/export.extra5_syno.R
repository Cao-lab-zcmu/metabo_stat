## i.e. source("~/outline/eucommia_neg/export.extra1_syno.R")
## ------------------------------------- 
## get cid and inchikey set
rdata <- paste0("pubchem", "/", "inchikey.rdata")
## extract as list
cid_inchikey <- extract_rdata_list(rdata) %>% 
  lapply(function(df){
           if("CID" %in% colnames(df))
             return(df)
  }) %>% 
  data.table::rbindlist(idcol = T) %>% 
  dplyr::rename(inchikey2D = .id)
## ------------------------------------- 
## get cid
cid <- cid_inchikey$CID
## create dir
dir.create("syno")
## curl synonyms
pubchem_get_synonyms(cid, dir = "syno", curl_cl = 4)
## ---------------------------------------------------------------------- 
