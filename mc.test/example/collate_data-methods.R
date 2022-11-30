
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

## extract candidates data in SIRIUS project directory
## chemical structure
test <- collate_data(test, ".f3_fingerid")
latest(project_dataset(test))

## chemical formula
test <- collate_data(test, ".f2_formula")
latest(project_dataset(test))

## chemical classes
test <- collate_data(test, ".f3_canopus")
latest(project_dataset(test))

## mz and rt
test <- collate_data(test, ".f2_info")
latest(project_dataset(test))

## classification description
test <- collate_data(test, ".canopus")

## the extracted data in 'mcnebula'
dataset(project_dataset(test))
entity(dataset(project_dataset(test))$.f3_fingerid)

unlink(tmp, T, T)
