
## codes
## The raw data used for the example
tmp <- paste0(tempdir(), "/temp_data")
dir.create(tmp)
eg.path <- system.file("extdata", "raw_instance.tar.gz",
                       package = "MCnebula2")

utils::untar(eg.path, exdir = tmp)

## initialize 'mcnebula' object
test <- mcnebula()
test <- initialize_mcnebula(test, "sirius.v4", tmp)
## check the setting
export_path(test)
palette_set(test)
ion_mode(test)
project_version(test)

## initialize 'melody' object
test <- new("melody")
test <- initialize_mcnebula(test)
## check...
palette_stat(test)

## initialize 'project_conformation' object
test <- new("project_conformation")
test <- initialize_mcnebula(test, "sirius.v4")
## check
file_name(test)

## initialize 'project_api' object
test <- new("project_api")
test <- initialize_mcnebula(test, "sirius.v4")
## check
methods_format(test)

unlink(tmp, T, T)
