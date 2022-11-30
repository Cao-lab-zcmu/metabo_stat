
## codes
test <- mcn_5features

## filter chemical formula candidates
## use default parameters
test1 <- filter_formula(test)
latest(test1)

## the default parameters:
filter_formula()

## customized filtering
## according to score
test1 <- filter_formula(test1, dplyr::filter, zodiac.score > 0.5)
latest(test1)

## get top rank
test1 <- filter_formula(test1, dplyr::filter, rank.formula <= 3)
latest(test1)

## complex filtering
test1 <- filter_formula(
  test1, dplyr::filter,
  ## molecular formula
  !grepl("N", mol.formula),
  ## mass error
  abs(error.mass) < 0.001
)
latest(test1)

## select columns
test1 <- filter_formula(test1, dplyr::select, 1:5)
latest(test1)
