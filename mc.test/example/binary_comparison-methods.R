
## codes
test <- mcn_5features

## the previous steps
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference = T)
test1 <- create_features_annotation(test1)

## set up a simulated quantification data.
test1 <- .simulate_quant_set(test1)
## the simulated data
features_quantification(test1)
sample_metadata(test1)

test1 <- binary_comparison(
  test1, control - model,
  model - control, 2 * model - control
)
## see results
top_table(statistic_set(test1))

## the default parameters
binary_comparison()
