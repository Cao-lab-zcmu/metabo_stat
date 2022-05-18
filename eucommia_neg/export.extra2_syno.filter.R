## extract data
cid_syno <- extract_rdata_list("syno/cid.rdata") %>% 
  data.table::rbindlist()
## ------------------------------------- 
## filter the syno, according to character 
filter.syno <- cid_syno %>% 
  ## na
  dplyr::filter(!is.na(syno)) %>% 
  ## specific ID
  dplyr::filter(!stringr::str_detect(syno, "[^[a-z]]{5,}$")) %>% 
  ## id filter
  dplyr::filter(!stringr::str_detect(syno, "[0-9]{4,}$")) %>% 
  ## alphabet number >= 4
  dplyr::filter(stringr::str_detect(syno, "[a-z]{4,}"))
## ------------------------------------- 
## show results
filter.syno %>% dplyr::as_tibble() %>% print(n = 20)
