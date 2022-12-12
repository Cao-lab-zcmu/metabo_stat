# ==========================================================================
# workflow to process data and output report
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

s0 <- rblock({
  tmp <- paste0(tempdir(), "/temp_data")
  dir.create(tmp, F)
})

s1 <- rblock({
  mcn <- mcnebula()
  mcn <- initialize_mcnebula(mcn)
  mcn <- filter_structure(mcn)
  mcn <- create_reference(mcn)
  mcn <- filter_formula(mcn, by_reference=T)
})

s2 <- rblock({
  mcn <- create_stardust_classes(mcn)
  mcn <- create_features_annotation(mcn)
  mcn <- cross_filter_stardust(mcn, 5, 1)
})

s3 <- rblock({
  mcn <- create_nebula_index(mcn)
  mcn <- compute_spectral_similarity(mcn)
  mcn <- create_parent_nebula(mcn, 0.01, T)
  mcn <- create_child_nebulae(mcn, 0.01, 5)
})

s4 <- rblock({
  mcn <- create_nebula_index(mcn)
  mcn <- compute_spectral_similarity(mcn)
  mcn <- create_parent_nebula(mcn, 0.01, T)
  mcn <- create_child_nebulae(mcn, 0.01, 5)
})
