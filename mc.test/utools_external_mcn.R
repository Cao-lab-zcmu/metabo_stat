test <- mcn_5features

e1 <- substitute({
  test1 <- filter_structure(test)
  test1 <- create_reference(test1)
  test1 <- filter_formula(test1, by_reference=T)
  test1 <- create_stardust_classes(test1)
  test1 <- create_features_annotation(test1)
})
eval(e1)

toAnno <- test1
save(toAnno5, "~/utils.tool/inst/extdata/toAnno5.rdata")

test1 <- cross_filter_stardust(test1, 1, 1)
test1 <- create_nebula_index(test1)
test1 <- compute_spectral_similarity(test1)
test1 <- create_parent_nebula(test1, 0.01, T)
test1 <- create_child_nebulae(test1, 0.01, 5)
test1 <- create_parent_layout(test1)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)

test1 <- .simulate_quant_set(test1)
test1 <- set_ppcp_data(test1)
test1 <- set_ration_data(test1)
test1 <- binary_comparison(test1, control - model,
                           model - control, 2 * model - control)

toBinary5 <- test1
save(toBinary5, file = "~/utils.tool/inst/extdata/toBinary5.rdata")

# test1 <- draw_structures(test1, "Fatty Acyls")
# test1 <- draw_nodes(test1, "Fatty Acyls")
# test1 <- annotate_nebula(test1, "Fatty Acyls")

# ==========================================================================
# 30 features
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setwd("~/operation/sirius.test")

test <- initialize_mcnebula(mcnebula())
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference=T)
test1 <- create_stardust_classes(test1)
test1 <- create_features_annotation(test1)
test1 <- cross_filter_stardust(test1, 5, 1)
test1 <- create_nebula_index(test1)
test1 <- compute_spectral_similarity(test1)
test1 <- create_parent_nebula(test1, 0.01, T)
test1 <- create_child_nebulae(test1, 0.01, 5)
test1 <- create_parent_layout(test1)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)

toActiv30 <- test1
save(toActiv30, file = "~/utils.tool/inst/extdata/toActiv30.rdata")


