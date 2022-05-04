##  re-draw heartmap for specific id
sp.idset <- c(3380, 2824, 3938, 2664, 2529,
              2227, 3918, 1445, 1107,
              574, 458, 279) %>% 
  as.character()
## ------------------------------------- 
test <- tmp_nebula_index %>% 
  dplyr::filter(.id %in% all_of(sp.idset))

