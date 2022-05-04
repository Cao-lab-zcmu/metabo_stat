## 
load_all("~/MCnebula/R")
load_all("~/extra/R")
initialize_mcnebula(".")
collate_structure()
build_classes_tree_list()
collate_ppcp(min_possess = 10, max_possess_pct = 0.1, filter_via_struc_score = NA)
generate_parent_nebula()
## ------------------------------------- 
f.classes <- .MCn.nebula_index$name %>% 
  table() %>% 
  .[which(. >= 50)] %>% 
  names()
tmp_nebula_index <- .MCn.nebula_index %>% 
  dplyr::filter(name %in% all_of(f.classes))
## ------------------------------------- 
generate_child_nebulae(nebula_index = tmp_nebula_index)
visualize_parent_nebula()
## ------------------------------------- 
visualize_child_nebulae()

