
## codes
test <- mcn_5features

## the previous steps
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference = T)
test1 <- create_stardust_classes(test1)
test1 <- create_features_annotation(test1)

## the default parameters
cross_filter_stardust()
# This is a simulated dataset with only 5 'features',
# so the default parameters are meaningless for it.

# Note that real datasets often contain thousands of "features"
# and the following 'min_number' and 'max_ratio' parameter values are not suitable.
test1 <- cross_filter_stardust(
  test1,
  min_number = 2,
  max_ratio = 1
)
## see results
stardust_classes(test1)
## or
reference(test1)$stardust_classes
## or
reference(mcn_dataset(test1))$stardust_classes

e1 <- stardust_classes(test1)

## see the filtered classes
backtrack_stardust(test1)

## reset the 'stardust_classes'
test1 <- create_stardust_classes(test1)

## customized filtering
# Note that real datasets often contain thousands of "features"
# and the following 'min_number' and 'max_ratio' parameter values are not suitable.
test1 <- cross_filter_quantity(test1, min_number = 2, max_ratio = 1)
test1 <- cross_filter_score(test1,
  types = "tani.score",
  cutoff = 0.3,
  tolerance = 0.6
)
test1 <- cross_filter_identical(
  test1,
  hierarchy_range = c(3, 11),
  identical_factor = 0.7
)
e2 <- stardust_classes(test1)

identical(e1, e2)

## reset
test1 <- create_stardust_classes(test1)
## targeted plural attributes
test1 <- cross_filter_stardust(
  test1,
  min_number = 2,
  max_ratio = 1,
  types = c("tani.score", "csi.score"),
  cutoff = c(0.3, -150),
  tolerance = c(0.6, 0.3)
)
