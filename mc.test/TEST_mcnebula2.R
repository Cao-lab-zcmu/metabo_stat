setwd("~/operation/sirius.test")
# library(MCnebula2)

test <- initialize_mcnebula(mcnebula())
test1 <- filter_structure(test)
test1 <- create_reference(test1)
test1 <- filter_formula(test1, by_reference=T)

test1 <- create_stardust_classes(test1)
test1 <- create_features_annotation(test1)
test1 <- cross_filter_stardust(test1, 5, 1)

ids <- sample(features_annotation(test1)$.features_id, 8)
test1 <- draw_structures(test1, .features_id = ids)
# plot_msms_mirrors(test1, ids)

test1 <- create_nebula_index(test1)
test1 <- compute_spectral_similarity(test1)
test1 <- create_parent_nebula(test1, 0.01, T)
test1 <- create_child_nebulae(test1, 0.01, 5)

test1 <- create_parent_layout(test1)
test1 <- create_child_layouts(test1)
test1 <- activate_nebulae(test1)

pdf("instance.pdf", width = 8, height = 8.5)
visualize_all(test1)
dev.off()
pdftools::pdf_convert("instance.pdf", dpi = 150)

re <- history_rblock(, "initialize_mcnebula\\(", "activate_nebulae\\(")

test1 <- .simulate_quant_set(test1)
test1 <- set_ppcp_data(test1)
test1 <- set_ration_data(test1)
test1 <- binary_comparison(test1, control - model,
                           model - control, 2 * model - control)

test1 <- draw_structures(test1, "Fatty Acyls")
test1 <- draw_nodes(test1, "Fatty Acyls")
test1 <- annotate_nebula(test1, "Fatty Acyls")
visualize(test1, "Fatty Acyls", annotate = T)

# pdf("child_nebulae.pdf", width = 10, height = 12)
# visualize_all(test1)
# dev.off()

des <- "see Table \\@ref(tab:table1)"
re <- new_report(yaml = .yaml_default("de"),
                 document_mc_workflow("abstract"),
                 document_mc_workflow("introduction"),
                 document_mc_workflow("setup"),
                 new_heading("analysis", 1),
                 new_section("step1"),
                 new_section("step2"),
                 new_heading("statistic", 1),
                 new_section(NULL, paragraph = "the flowing is figure..."),
                 new_section(NULL, paragraph = des),
                 # include_figure("child_8.pdf", "plot1", "child-nebulae"),
                 # include_table(df, "table1", "top features"),
                 new_section(NULL, code_block =
                             new_code_block(codes = "re"))
)

# writeLines(call_command(re), "test.Rmd")
# rmarkdown::render("test.Rmd")


