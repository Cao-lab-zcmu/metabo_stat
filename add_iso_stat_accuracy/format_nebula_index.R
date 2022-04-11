## ---------------------------------------------------------------------- 
## the above, all compound data were collate,
## involving metadata and classification data, curl via
## classyfireR
## the following, these data were compared with
## MCnebula computation results, involving
## clustering and idenfication
## ---------------------------------------------------------------------- 
## nebula class
class_nebula <- dplyr::ungroup(.MCn.nebula_index) %>%
  dplyr::select(.id, hierarchy, name)
# index <- dplyr::distinct(class_nebula, hierarchy, name)
## ------------------------------------- 
## as list
class_nebula_list <- extra::by_group_as_list(class_nebula, "name")
list <- list_merge_df(class_nebula_list, class_meta, by = ".id", all.x = T)
list <- lapply(list, select_app,
               col = c(".id", "hierarchy", "Ontology"))

