
## codes
test <- mcn_5features

## filter chemical class candidates
## the default parameters:
filter_ppcp()

## if 'by_reference' set with TRUE, 'create_reference' should be
## run previously.
test1 <- filter_ppcp(test, by_reference = F)
latest(test1)

## customized filtering
## according to score
test1 <- filter_ppcp(test1, dplyr::filter, pp.value > 0.5,
                     by_reference = F)
latest(test1)

## complex filtering
test1 <- filter_ppcp(
  test1, dplyr::filter,
  ## PPCP value
  pp.value > 0.5,
  ## speicifid class
  class.name %in% c("Azoles"),
  by_reference = F
)
latest(test1)

## select columns
test1 <- filter_ppcp(test1, dplyr::select, 1:5,
                     by_reference = F)
latest(test1)
