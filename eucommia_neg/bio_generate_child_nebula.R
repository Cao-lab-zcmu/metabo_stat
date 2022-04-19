## ---------------------------------------------------------------------- 
## classes
classes <- dplyr::filter(.MCn.nebula_index, .id %in% log.fc_stat$.id)$name %>% 
  unique()
f.classes <- dplyr::filter(.data = .MCn.nebula_index, name %in% all_of(classes)) %>% 
  .$name %>% 
  table() %>% 
  .[which(. <= 300)] %>% 
  names()
## generate_child_nebulae
tmp_nebula_index <- dplyr::filter(.MCn.nebula_index,
                                  .id %in% log.fc_stat$.id,
                                  name %in% f.classes)
generate_child_nebulae(nebula_index = tmp_nebula_index,
                       output = "mcnebula_results/trace")

