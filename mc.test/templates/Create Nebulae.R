s4 <- new_heading("Create Nebulae", 2)

s4.1 <- new_section2(
  c("Create Nebula-Index data. This data created based on 'stardust_classes' data."),
  rblock({
    mcn <- create_nebula_index(mcn)
  })
)

s4.5 <- new_section2(
  reportDoc$nebulae,
  rblock({
    mcn <- compute_spectral_similarity(mcn)
    mcn <- create_parent_nebula(mcn)
    mcn <- create_child_nebulae(mcn)
  })
)
