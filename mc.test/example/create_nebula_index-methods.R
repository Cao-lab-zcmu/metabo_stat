
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
## see results
nebula_index(test1)
## or
reference(test1)$nebula_index
## or
reference(mcn_dataset(test1))$nebula_index
