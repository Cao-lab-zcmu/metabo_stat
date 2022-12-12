
## codes
rblock({
  test1 <- 1
  test2 <- 2
  test3 <- 3
})

rblock({
  test <- mcn_5features
  ## this annotation line would be ignored
  test1 <- filter_structure(test)
  test1 <- create_reference(test1)
  test1 <- filter_formula(test1, by_reference=T)
  test1 <- create_stardust_classes(test1)
})
