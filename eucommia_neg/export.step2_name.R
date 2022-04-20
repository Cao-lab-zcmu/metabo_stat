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
## ---------------------------------------------------------------------- 
export <- export.class.cano %>% 
  merge(iupac, by.x = "inchikey2D", by.y = "inchikey2d", all.x = T) %>% 
  dplyr::as_tibble() %>% 
  dplyr::mutate(name = ifelse(name == "null",
                              ifelse(is.na(IUPACName), name, IUPACName),
                              ifelse(nchar(name) < nchar(IUPACName), name, IUPACName)),
                name = ifelse(grepl("^bmse|^ACMC", name), IUPACName, name)) %>% 
  ## exclude useless
  dplyr::select(-IUPACName) %>% 
  dplyr::relocate(.id, mz, rt, name) %>% 
  dplyr::relocate(inchikey2D, smiles, .after = last_col()) %>% 
  ## this class almost included in the parent class
  dplyr::filter(Classification != "Lignan glycosides") %>%
  dplyr::rename(id = .id)
## ------------------------------------- 
export.dominant <- export %>% 
  dplyr::filter(name != "null")
## ------------------------------------- 
export.extra <- export %>% 
  dplyr::filter(name == "null")
## ---------------------------------------------------------------------- 
## export
gt_table <- pretty_table(dplyr::rename(export.dominant[, -ncol(export.dominant)], info = Classification),
                         default = T)

