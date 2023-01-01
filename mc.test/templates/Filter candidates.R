s2 <- new_heading("Filter candidates", 2)

s2.1 <- new_section2(
  reportDoc$filter,
  rblock({
    mcn <- filter_structure(mcn)
    mcn <- create_reference(mcn)
    mcn <- filter_formula(mcn, by_reference = T)
  })
)
