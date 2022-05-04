## 
load_all("~/MCnebula/R")
load_all("~/extra/R")
initialize_mcnebula(".")
# collate_structure(exclude_element = c("S", "B", "P", "Si"), fc = NA)
collate_structure()
build_classes_tree_list()
collate_ppcp(min_possess = 10, max_possess_pct = 0.1)
generate_parent_nebula()
generate_child_nebulae()
visualize_parent_nebula()
visualize_child_nebulae()

