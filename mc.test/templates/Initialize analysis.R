s1 <- new_heading("Initialize analysis", 2)

s1.1 <- new_section2(
  c("Set SIRIUS project path and its version to initialize mcnebula object."),
  rblock({
    mcn <- mcnebula()
    mcn <- initialize_mcnebula(mcn, "<<<sirius_version>>>", "<<<sirius_project>>>")
    ion_mode(mcn) <- "<<<ion_mode>>>"
  })
)

s1.5 <- new_section2(
  c("Create a temporary folder to store the output data."),
  rblock({
    tmp <- paste0(tempdir(), "/temp_data")
    dir.create(tmp, F)
    export_path(mcn) <- tmp
  })
)
