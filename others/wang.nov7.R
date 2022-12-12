
devtools::load_all("~/MCnebula2")
devtools::load_all("~/utils.tool/")

obj <- initialize_mcnebula(mcnebula())
obj <- filter_structure(obj)
obj <- create_reference(obj, "structure")
obj <- filter_formula(obj, by_reference = T)
obj <- create_stardust_classes(obj)

obj <- create_features_annotation(obj)
obj_1 <- cross_filter_stardust(obj, 15)
obj_1 <- create_nebula_index(obj_1)

obj_1 <- compute_spectral_similarity(obj_1)
obj_1 <- create_parent_nebula(obj_1)
obj_1 <- create_parent_layout(obj_1)
obj_1 <- create_child_nebulae(obj_1)
obj_1 <- create_child_layouts(obj_1)
obj_1 <- activate_nebulae(obj_1)

pdf("child_nebulae_1.pdf", height = 12, width = 11)
visualize_all(obj_1)
dev.off()

quant <- data.table::fread("../nov6.csv")
area <- dplyr::select(quant, .features_id = `row ID`, contains("Peak area"))
area <- cbind(area[, 1], log2(area[, -1] + 1))
colnames(area) <- gsub(".mzML Peak area", "", colnames(area))

metadata <- group_strings(colnames(area)[-1],
                          c(model = "^1201_M", treat = "^1201_S", control = "^1201_KB"),
                          target = "sample")
features_quantification(obj_1) <- dplyr::select(area, .features_id, dplyr::all_of(metadata$sample))
sample_metadata(obj_1) <- metadata

obj_1 <- binary_comparison(obj_1, model - control, treat - model)
top_compound <- top_table(statistic_set(obj_1))[[ "treat - model" ]]$.features_id[1:30]

obj_1 <- set_tracer(obj_1, top_compound)
obj_2 <- create_child_nebulae(obj_1)
obj_2 <- create_child_layouts(obj_2)
obj_2 <- activate_nebulae(obj_2)
obj_2 <- set_nodes_color(obj_2, use_tracer = T)

pdf("trace_child_nebula.pdf")
visualize_all(obj_2)
dev.off()

# obj_2 <- annotate_nebula(obj_2, "Straight chain fatty acids")
write_tsv(features_annotation(obj_2), "id_results.tsv")
mapply(1:2, c("model_vs_control", "treat_vs_model"),
       FUN = function(n, name){
         write_tsv(top_table(statistic_set(obj_2))[[ n ]], paste0(name, ".tsv"))
       })

