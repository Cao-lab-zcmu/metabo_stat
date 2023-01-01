
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

## default parameters
create_parent_nebula()

test1 <- create_parent_nebula(test1, 0.01)
## see results
igraph(parent_nebula(test1))
## write output for 'Cytoscape' or other network software
tmp <- tempdir()
igraph::write_graph(
  igraph(parent_nebula(test1)),
  file = paste0(tmp, "/parent_nebula.graphml",
    format = "graphml"
  )
)

unlink(tmp, T, T)
