## via pubchem, fill with name in witch compound
## idenfication table is 'null'
## ------------------------------------- 
dir.create("iupac_name")
pubchem_curl_inchikey(unique(export.class.cano$inchikey2D),
                      dir = "iupac_name",
                      get = "IUPACName",
                      curl_cl = 8)
## ------------------------------------- 
## extract data witch has curl down
## format
iupac <- extract_rdata_list("iupac_name/inchikey.rdata") %>% 
  data.table::rbindlist(idcol = T, fill = T) %>% 
  dplyr::rename(inchikey2d = .id) %>% 
  ## filter na
  dplyr::filter(is.na(x), !is.na(IUPACName)) %>% 
  dplyr::select(1:3) %>%
  ## length of character
  dplyr::mutate(n.ch = nchar(IUPACName)) %>% 
  dplyr::arrange(inchikey2d, n.ch) %>% 
  ## get the unique name
  dplyr::distinct(inchikey2d, .keep_all = T) %>% 
  dplyr::select(inchikey2d, IUPACName)

