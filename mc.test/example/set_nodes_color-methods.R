
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
test1 <- create_parent_nebula(test1, 0.01, T)
test1 <- create_child_nebulae(test1, 0.01, 5)
test1 <- create_parent_layout(test1)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)

ids <- features_annotation(test1)$.features_id
extra_data <- data.frame(
  .features_id = ids,
  attr_1 = rnorm(length(ids), 100, 50),
  attr_2 = sample(c("special", "normal"), 5, replace = T)
)

test1 <- set_nodes_color(test1, "attr_1", extra_data)
visualize(test1, 1)
visualize_all(test1)
## set labal of the legend
export_name(test1) <- c(
  export_name(test1),
  attr_1 = "Continuous attribute",
  attr_2 = "Discrete attribute"
)
visualize_all(test1)

test1 <- set_nodes_color(test1, "attr_2", extra_data)
visualize(test1, 1)
visualize_all(test1)

## set colors for 'tracer'
test1 <- set_tracer(test1, ids[1:2])
## re-build Child-Nebulae
test1 <- create_child_nebulae(test1, 0.01, 5)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)
## set color
test1 <- set_nodes_color(test1, use_tracer = T)
visualize_all(test1)
