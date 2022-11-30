# ==========================================================================
# get the data
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
tmp <- paste0(tempdir(), "/temp_data")
dir.create(tmp, F)
eg.path <- system.file("extdata", "raw_instance.tar.gz",
                       package = "MCnebula2")

utils::untar(eg.path, exdir = tmp)

# ==========================================================================
# decrease object.size
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

test <- initialize_mcnebula(mcnebula(), , tmp)
test1 <- filter_structure(test)
test1 <- filter_formula(test1)
test1 <- filter_ppcp(test1, by_reference = F)

dataset(project_dataset(test1))

## ---------------------------------------------------------------------- 
## chemical structure

df <- entity(dataset(project_dataset(test1))[[ ".f3_fingerid" ]])
df <- dplyr::mutate(df, links = character(1), pubmed.ids = character(1))
df <- dplyr::mutate_if(df, is.numeric, function(x) round(x, 2))

format(object.size(df), units = "MB")
dplyr::as_tibble(df)
df

entity(dataset(project_dataset(test1))[[ ".f3_fingerid" ]]) <- df

## ---------------------------------------------------------------------- 
## chemical formula

df2 <- entity(dataset(project_dataset(test1))[[ ".f2_formula" ]])
df2 <- dplyr::mutate_if(df2, is.numeric, function(x) round(x, 2))

dplyr::as_tibble(df2)
df2

entity(dataset(project_dataset(test1))[[ ".f2_formula" ]]) <- df2

## ---------------------------------------------------------------------- 
## chmical classes

df3 <- entity(dataset(project_dataset(test1))[[ ".f3_canopus" ]])
df3 <- dplyr::mutate_if(df3, is.numeric, function(x) round(x, 2))
df3 <- dplyr::mutate(df3, description = character(1),
                     rel.index = as.integer(rel.index))

format(object.size(df3), units = "MB")
dplyr::as_tibble(df3)
df3

entity(dataset(project_dataset(test1))[[ ".f3_canopus" ]]) <- df3

## ---------------------------------------------------------------------- 
## others

reference <- specific_candidate(create_reference(test1, from = "structure"))
reference
test1 <- collate_data(test1, ".f3_spectra", reference = reference)
test1 <- collate_data(test1, subscript = ".f2_info")

## ---------------------------------------------------------------------- 
## delete tmpfile

mcn_dataset(test1) <- MCnebula2:::.mcn_dataset()

dataset(project_dataset(test1))

format(object.size(test1), units = "MB")

list.files(tmp)

# ==========================================================================
# test function
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

project_dataset(test1)
mcn_dataset(test1)
latest(test1, subscript = ".f3_canopus")

test3 <- test1

test3 <- filter_structure(test3)
test3 <- create_reference(test3)
test3 <- filter_formula(test3, by_reference=T)

test3 <- create_stardust_classes(test3)
test3 <- create_features_annotation(test3)
test3 <- cross_filter_stardust(test3, 2, 1)
stardust_classes(test3)

test3 <- create_nebula_index(test3)
test3 <- compute_spectral_similarity(test3)
test3 <- create_parent_nebula(test3, 0.01, F)
test3 <- create_child_nebulae(test3, 0.01, 5)
spectral_similarity(test3)

test3 <- create_parent_layout(test3)
test3 <- create_child_layouts(test3)
test3 <- activate_nebulae(test3)

test3 <- .simulate_quant_set(test3)
test3 <- set_ppcp_data(test3)
test3 <- set_ration_data(test3)
test3 <- binary_comparison(test3, control - model,
                           model - control, 2 * model - control)

top_table(statistic_set(test3))

visualize(test3)
visualize(test3, 3)

call_command(ggset(child_nebulae(test3))[[2]])
names(ggset(child_nebulae(test3))[2])
layout_ggraph(child_nebulae(test3))[2]
call_command(ggset(child_nebulae(test3))[[3]])

visualize(test3, "parent")

visualize_all(test3)
visualize()

# ==========================================================================
# save object
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mcn_5features <- test1
setwd("~/MCnebula2/")
usethis::use_data(mcn_5features)

# ==========================================================================
# post modify
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
library(magrittr)
backup <- mcn_5features
test <- mcn_5features

## non-asc
entity(dataset(project_dataset(test))[[".canopus"]])$description %<>% 
  enc2utf8()

mcn_5features <- test

## msms
test <- collate_data(test, subscript = ".f2_msms")
format(object.size(test), units = "MB")
project_dataset(test)

mcn_5features <- test

usethis::use_data(mcn_5features, overwrite = T)
# save(mcn_5features, file = "~/mcn_5features.rda")

unlink(tmp, T, T)
