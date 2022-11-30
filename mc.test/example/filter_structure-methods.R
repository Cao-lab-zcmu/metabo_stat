
## codes
test <- mcn_5features

## filter chemical structure candidates
## use default parameters
test1 <- filter_structure(test)
latest(test1)

## the default parameters:
filter_structure()

## customized filtering
## according to score
test1 <- filter_structure(test1, dplyr::filter, tani.score > 0.4)
latest(test1)

## get top rank
test1 <- filter_structure(test1, dplyr::filter, rank.structure <= 3)
latest(test1)

## complex filtering
test1 <- filter_structure(
  test1, dplyr::filter,
  ## molecular formula
  !grepl("N", mol.formula),
  ## Tanimoto similarity
  tani.score > 0.4
)
latest(test1)

## select columns
test1 <- filter_structure(test1, dplyr::select, 1:5)
latest(test1)
