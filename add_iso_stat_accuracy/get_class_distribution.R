## ------------------------------------- 
## ------------------------------------- 
## classyfire class distribution
reference_density <- get_reference_class_density()
those_level_inclass <- get_reference_class_parent(reference_density)
## ------------------------------------- 
## ------------------------------------- 
f.reference_density <- reference_density %>%
  filter(sum.N >= 50, !level %in% c("superclass", "kingdom", "level 5", "level 6", "level 7", "level 8"))
## ------------------------------------- 
## compare with nebula index
those_of_nebula <- stat$classification %>%
  mutate_get_parent_class(this_class = T) %>%
  lapply(end_of_vector) %>%
  unlist() %>%
  unname() %>%
  unique()
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## mean value
# mean_dominant_stat <- dplyr::summarise_at(dominant_stat, 2:4, mean)

