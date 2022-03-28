msp_to_mgf(name = "msms_pos_gnps.msp",
           id_prefix = "gnps",
           path = "~/Downloads/msp",
           mass_level = "all",
           fun = "deal_with_msp_record")
load_all("~/MCnebula/R")
initialize_mcnebula(".")
collate_structure(fc = NA)
build_classes_tree_list()
collate_ppcp(min_possess = 50)
generate_parent_nebula()
generate_child_nebulae()
visualize_parent_nebula()
visualize_child_nebulae()
# use rcdk to add isotope pattern
## ---------------------------------------------------------------------- 

