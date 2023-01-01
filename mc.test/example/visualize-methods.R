
## codes
test <- mcn_5features

## the previous steps
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference = T)
test1 <- create_stardust_classes(test1)
test1 <- create_features_annotation(test1)
test1 <- cross_filter_stardust(test1, 2, 1)
test1 <- create_nebula_index(test1)
test1 <- compute_spectral_similarity(test1)
test1 <- create_parent_nebula(test1, 0.01)
test1 <- create_child_nebulae(test1, 0.01)
test1 <- create_parent_layout(test1)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)

## optional Child-Nebulae
visualize(test1)

visualize(test1, "parent")
visualize(test1, 1)
visualize_all(test1)
## ...

## use 'fun_modify'
visualize(test1, 1, modify_default_child)
visualize(test1, 1, modify_unify_scale_limits)
visualize(test1, 1, modify_set_labs)
## ...
