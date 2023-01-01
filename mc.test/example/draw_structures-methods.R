
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
test1 <- create_child_nebulae(test1, 0.01)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)

## optional 'nebula_name'
visualize(test1)
## a class for example
class <- visualize(test1)$class.name[1]
tmp <- export_path(test1)
test1 <- draw_structures(test1, class)

## see results
grobs <- structures_grob(child_nebulae(test1))
grobs
grid::grid.draw(grobs[[1]])
## visualize with ID of 'feature' (.features_id)
ids <- names(grobs)
show_structure(test1, ids[1])

unlink(tmp, T, T)
