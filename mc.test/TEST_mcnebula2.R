setwd("~/operation/sirius.mcn")
# library(MCnebula2)
mcn <- initialize_mcnebula(mcnebula())

mcn1 <- filter_structure(mcn)
mcn1 <- create_reference(mcn1)
mcn1 <- filter_formula(mcn1, by_reference=T)

mcn1 <- create_stardust_classes(mcn1)
mcn1 <- create_features_annotation(mcn1)
mcn1 <- cross_filter_stardust(mcn1, 5, 1)

ids <- sample(features_annotation(mcn1)$.features_id, 8)
mcn1 <- draw_structures(mcn1, .features_id = ids)
# plot_msms_mirrors(mcn1, ids)

mcn1 <- create_nebula_index(mcn1)
mcn1 <- compute_spectral_similarity(mcn1)
mcn1 <- create_parent_nebula(mcn1, 0.01, 5, T)
mcn1 <- create_child_nebulae(mcn1, 0.01, 5)

mcn1 <- create_parent_layout(mcn1)
mcn1 <- create_child_layouts(mcn1)
mcn1 <- activate_nebulae(mcn1)

pdf("instance.pdf", width = 8, height = 8.5)
visualize_all(mcn1)
dev.off()

pdftools::pdf_convert("instance.pdf", dpi = 150)

re <- history_rblock(, "initialize_mcnebula\\(", "activate_nebulae\\(")

mcn1 <- .simulate_quant_set(mcn1)
mcn1 <- set_ppcp_data(mcn1)
mcn1 <- set_ration_data(mcn1)
mcn1 <- binary_comparison(mcn1, control - model,
                           model - control, 2 * model - control)

mcn1 <- draw_structures(mcn1, "Fatty Acyls")
mcn1 <- draw_nodes(mcn1, "Fatty Acyls")
mcn1 <- annotate_nebula(mcn1, "Fatty Acyls")
visualize(mcn1, "Fatty Acyls", annotate = T)

# pdf("child_nebulae.pdf", width = 10, height = 12)
# visualize_all(mcn1)
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
