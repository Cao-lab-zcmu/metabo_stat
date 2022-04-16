## ---------------------------------------------------------------------- 
## classes
classes <- dplyr::filter(.MCn.nebula_index, .id %in% sirius_efs25$.id)$name %>% 
  unique()
f.classes <- dplyr::filter(.data = .MCn.nebula_index, name %in% all_of(classes)) %>% 
  .$name %>% 
  table() %>% 
  .[which(. <= 300)] %>% 
  names()
## generate_child_nebulae
tmp_nebula_index <- dplyr::filter(.MCn.nebula_index, name %in% f.classes)
generate_child_nebulae(nebula_index = tmp_nebula_index,
                       output = getwd())
## new id for efs25
re_efs25.id <- unique(sirius_efs25$.id)
## ------------------------------------- 
## test whether all top25 %in% tmp_nebula_index
in.re_efs25.id <- tmp_nebula_index$.id %>% 
  unique() %>% 
  .[which(. %in% re_efs25.id)]

