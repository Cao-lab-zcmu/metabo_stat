
## codes
test <- mcn_5features

## the previous steps
test1 <- filter_structure(test)
test1 <- create_reference(test1)

test1 <- create_stardust_classes(test1)
## see results
stardust_classes(test1)
## or
reference(test1)$stardust_classes
## or
reference(mcn_dataset(test1))$stardust_classes

## the default parameters
create_stardust_classes()
