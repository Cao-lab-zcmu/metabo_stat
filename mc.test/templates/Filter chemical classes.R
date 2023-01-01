s3 <- new_heading("Filter chemical classes", 2)

s3.1 <- new_section2(
  reportDoc$stardust,
  rblock({
    mcn <- create_stardust_classes(mcn)
    mcn <- create_features_annotation(mcn)
    mcn <- cross_filter_stardust(mcn)
    classes <- unique(stardust_classes(mcn)$class.name)
    table.filtered.classes <- backtrack_stardust(mcn)
  })
)

s3.5 <- new_section2(
  c("Manually filter some repetitive classes or sub-structural classes.",
    "By means of Regex matching, we obtained a number of recurring",
    "name of chemical classes that would contain manay identical compounds",
    "as their sub-structure."),
  rblock({
    classes
    pattern <- c("stero", "fatty acid", "pyr", "hydroxy", "^orga")
    dis <- unlist(lapply(pattern, grep, x = classes, ignore.case = T))
    dis <- classes[dis]
    dis
    dis <- dis[-1]
  }, args = list(eval = T))
)

s3.6 <- new_section2(
  c("Remove these classes."),
  rblock({
    mcn <- backtrack_stardust(mcn, dis, remove = T)
  })
)
