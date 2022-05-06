## ---------------------------------------------------------------------- 
## extract classyfire data
## do a rough filter
class_df <- extract_rdata_list("classyfire/class.rdata",
                                 export.struc_set$inchikey2D) %>% 
  data.table::rbindlist(idcol = T) %>% 
  dplyr::rename(inchikey2d = .id) %>% 
  dplyr::filter(!Level %in% all_of(c("kingdom", "level 7", "level 8", "level 9")),
                !grepl("[0-9]|Organ", Classification))
## ---------------------------------------------------------------------- 
## the classes keeped
## do further filter
## ---------------------------------------------------------------------- 
class_meta <- class_df
