
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
## customize the chemical classes displayed
## in the radial bar plot in node.
classes <- classification(test1)
## get some random classes
set.seed(10)
classes <- sample(classes$class.name, 50)
classes
test1 <- set_ppcp_data(test1, classes)
test1 <- draw_nodes(test1, class,
  add_structure = F,
  add_ration = F
)

## visualize with ID of 'feature' (.features_id)
## with legend
ids <- names(nodes_grob(child_nebulae(test1)))
x11(width = 15, height = 5)
show_node(test1, ids[1])

## get a function to generate default parameters
set_ppcp_data()
## the default parameters
set_ppcp_data()(test1)

unlink(tmp, T, T)
