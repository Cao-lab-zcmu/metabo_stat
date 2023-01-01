
## codes
test <- mcn_5features

## the previous steps
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference = T)
test1 <- create_stardust_classes(test1)
test1 <- create_features_annotation(test1)
test1 <- cross_filter_stardust(test1, 2, 1)
test1 <- create_nebula_index(test1)
test1 <- compute_spectral_similarity(test1)
test1 <- create_child_nebulae(test1, 0.01)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)

## set features quantification data
ids <- features_annotation(test1)$.features_id
quant. <- data.frame(
  .features_id = ids,
  sample_1 = rnorm(length(ids), 1000, 200),
  sample_2 = rnorm(length(ids), 2000, 500)
)
metadata <- data.frame(
  sample = paste0("sample_", 1:2),
  group = c("control", "model")
)
features_quantification(test1) <- quant.
sample_metadata(test1) <- metadata

## optional 'nebula_name'
visualize(test1)
## a class for example
class <- visualize(test1)$class.name[1]
tmp <- export_path(test1)
test1 <- annotate_nebula(test1, class)

## The following can be run before "annotate_nebula()"
## to customize the visualization of nodes.
# test1 <- draw_structures(test1, "Fatty Acyls")
## set parameters for visualization of nodes
# test1 <- draw_nodes(
#   test1, "Fatty Acyls",
#   add_id_text = T,
#   add_structure = T,
#   add_ration = T,
#   add_ppcp = T
# )
# test1 <- annotate_nebula(test1, class)

## see results
ggset <- ggset_annotate(child_nebulae(test1))
ggset[[class]]
## visualize 'ggset'
call_command(ggset[[class]])
