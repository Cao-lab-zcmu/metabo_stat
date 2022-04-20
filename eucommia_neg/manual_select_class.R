## ---------------------------------------------------------------------- 
## extract classyfire data
## do a rough filter
class_df <- extract_rdata_list("classyfire/class.rdata",
                                 export.struc_set$inchikey2D) %>% 
  data.table::rbindlist(idcol = T) %>% 
  dplyr::rename(inchikey2d = .id) %>% 
  dplyr::filter(!Level %in% all_of(c("kingdom", "level 7", "level 8", "level 9")),
                !grepl("[0-9]|Organ|Phenylpropanoids and polyketides", Classification))
## ------------------------------------- 
## the classes keeped
## do further filter
keep <- class_df$Classification %>%
  table() %>% 
  data.table::data.table() %>% 
  dplyr::filter(N >= 7, N < 100) %>% 
  dplyr::rename(class = 1, abund = 2)
## ------------------------------------- 
## get parent class
parent.class <- mutate_get_parent_class(keep$class, this_class = T)
## ------------------------------------- 
## ------------------------------------- 
## ---------------------------------------------------------------------- 
pretty_table(export)
