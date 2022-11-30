
## codes
test <- mcn_5features

## the previous steps
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference=T)
test1 <- create_stardust_classes(test1)

test1 <- create_features_annotation(test1)
## see results
features_annotation(test1)
## or
reference(test1)$features_annotation
## or
reference(mcn_dataset(test1))$features_annotation

## merge additional data
ids <- features_annotation(test1)$.features_id
data <- data.frame(.features_id = ids, quant. = rnorm(length(ids), 1000, 200))
test1 <- create_features_annotation(test1, extra_data = data)
